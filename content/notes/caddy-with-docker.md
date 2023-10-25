# docker-compose file to support Caddy/HTTPS:

services:
	caddy:
		build: 
			context:
			dockerfile: caddy.Dockerfile
		container_name: caddy
		restart: unless-stopped
		ports:
			- "80:80" # for http -> https redirects
			- "443:443"
		volumes:
			- $PWD/Caddyfile:/etc/caddy/Caddyfile
			- caddy_data:/data
			- caddy_config:/config
		env_file:
			- .caddy.env
		dns:
			- 1.0.0.3
		healthcheck:
			test: ["CMD", "caddy", "version"]
		depends_on:
			- cloudflared
		networks:
			net: {}

volumes:
	caddy_data:
		external: true
	caddy_config:


# Dockerfile to build Caddy for Cloudflare http challenge:

FROM caddy:builder AS builder

RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy


# Caddyfile to proxy HTTPS traffic to Pi-Hole

dns.example.com

reverse_proxy 10.0.0.3:80

tls  you@example.com {
	dns cloudflare {env.CLOUDFLARE_API_TOKEN}
	resolvers 10.0.0.3
}

encode zstd gzip
