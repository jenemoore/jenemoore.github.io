---
title: "QMK keycodes"
type: "post"
date: 2023-06-27
tags: "qmk"
---

# keycodes available in QMK

## Linux-only

- KC_EXECUTE / KC_EXEC
- KC_HELP 
- KC_MENU
- KC_SELECT / KC_SLCT
- KC_STOP
- KC_AGAIN / KC_AGIN
- KC_UNDO
- KC_CUT
- KC_COPY
- KC_PASTE / KC_PSTE
- KC_FIND
- KC_KP_COMMA / KC_PCMM -- comma for keypad (!!!)
- KC_CLEAR / KC_CLR

- KC_LGUI, LCMD, LWIN (and right equivalents) -- Meta modifier
- KC_MEH - ctrl, shift, and alt together
- KC_HYPR - ctrl, shift, alt, and meta together

## Modifier combos

Use these keycodes (eg. LSA(kc)) to hit a key with modifiers held down

These are all also available as mod-tap keys: hold it down to hold down the combo, tap it for (kc)

	This means you actually have three modifiers you're not using: Meta, Meh (Ctrl, Shift, Alt together), and Hyper (Ctrl, Shift, Alt, and Meta together)

- ctrl
- alt
- meta
- shift + meta
- alt + meta
- ctrl + alt
- shift + alt
- ctrl + alt + meta
- ctrl + alt + shift
- ctrl + alt + shift + meta
 

## Getting more keyboard shortcuts

Keyboard shortcuts using only one modifier are usually bound by the OS or by apps--ctrl+s, ctrl+f, etc. Ctrl is the most common. 

Use alt for the next most basic use (eg. window manager - i3 recommends alt for its basic modifier)

Use meta for the next level (it's more inconvenient on a default keyboard)

Then you're looking at combos: and again--with qmk, you can make these a single key as well

###Two key combos:
- ctrl+alt is also fairly common in pre-made shortcut configurations but you may find options for it
- shift+alt is pretty free
- shfit+meta

###Three key combos:
- ctrl+alt+meta (Meh)
- ctrl+alt+shift

###Four key combo:
- ctrl+alt+shift+meta (Hyper)

Combine all these options, and even removing ctrl and ctrl+alt, you have essentially have six additional full keyboard layouts of keyboard shortcuts, and you don't even need to use layers to get them


## More functionality: Macros

QMK lets you assign macros directly to a key; you can also use the leader key function (emacs/tmux style shortcuts)

eg. Leader, w, e (typed in sequence, not held down together) to type out your work email

###Other macro ideas:
- open your most used apps, folders, terminals, layouts
- use as bookmarks: type out urls even on other computers
- emoji shortcuts: leader + emoji name (up to 5 chars) to type the emoji (requires unicode support)
- leader, backspace to delete a whole word
- accents, special characters, and punctuation: leader, a for accent grave; leader, += for the combined sign
- leader, " to wrap word in quotes (parentheses, brackets, etc.)
- text expanders
- you can use the leader key with repeated keypresses: type leader, g, g and scroll to the top of wherever you are

You can also program QMK to do something if you typed the leader key and nothing was matched, such as flash an LED or play a sound

## More keys: Tap Dance

This is essentially giving you more keys with the same layout: one key for a single tap, one key for a double tap (or even a triple tap)

###Examples:
- add tab to a letter key (one you don't duplicate: q, j, x, z)
- send the shifted version of a key on double tap
- put reset on a layer with tap dance so you absolutely can't ever do it accidentally

