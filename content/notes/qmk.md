---
type: "post"
---

# QMK aka I Guess I'm Learning C Now

## QMK cli

### Build environment

Install with pip (`python3 -m pip install --user qmk`)

Setup with `qmk setup` (add $HOME/.local/bin to PATH if you get an error)
    * `user.qmk_home` sets the home folder; your keyboard variable is the path relative to the keyboard directory in this dir
    * work off your personal fork wherever possible
    * add `autoload -Uz bashcompinit && bashcompinit` to  .zshrc for tab completion

### Commands

`qmk compile -kb <keyboard/path/rev> -km default`

Universal flags:
* -c
* -e  environment variables
* -j  number of jobs to run at once (or --parallel)
* -kb keyboard
* -km keymap
* -l  layout

#### qmk compile

* directory-aware: will use current keyboard and/or keymap if you're in that directory
* can use -kb all to compile maps for all keyboards that support them

#### qmk flash

* directory aware; can also flash Configurator files
* -bl bootloader to target (default :flash)
* -m  microcontroller to target (for HalfKay, QMK HID, and USBaspLoader bootloaders)
* `qmk flash -b` to list bootloaders

#### qmk cd

* opens a new shell in your qmk_firmware directory (or does nothing if you're already there)

#### qmk find

* searches through keyboards and keymaps
    * includes info.json and rules.mk
    * use json dotty syntax to find features (eg. `features.rgb_matrix=true`)
* -f  filter

#### qmk console

* if your keyboard has been compiled with `CONSOLE_ENABLE=yes`, allows you to connect to keyboard console to get debugging messages
* -l  list all devices
* -d  device (pid:vid[:index])
* -n  show pid:vid instead of names
* -t show timestamps
* --no-bootloaders  disable bootloader messages
* -w SECONDS

#### qmk doctor

* checks your environment and alerts you to potential problems; repairs them
* -y automatically fix
* -n report but don't fix

#### qmk format-json

* prettyprints a json file
* -f  format (info or keymap)

#### qmk info

* directory aware
* -kb will show basic info
* -km will print a json keymap
* -m will print the matrix instead
* -l will show layout(s)

#### qmk json2c

* creates a keymap.c from a QMK Configurator export
* -o filename

#### qmk c2json

* less reliable, but turns a keymap.c to a Configurator json
* -q
* --no-cpp
* -o filename

#### qmk lint

* finds common errors, problems, and anti-patterns
* directory-aware
* --strict

#### qmk list-keyboards

* lists everything currently defined in the home directory

#### qmk list-keymaps

* lists keymaps for a specified board and revision
* directory aware

#### qmk new-keyboard

* creates a new keyboard based on available templates
* will prompt for arguments that aren't provided
* -t  processor
* -l  layout
* -u  username (will use user.name from .gitconfig if not passed)

#### qmk new-keymap
 
* creates a new keymap based on the default
* directory aware

#### qmk clean

* cleans up the .build folder
* -a or --all to clean up any .hex or .bin files present in home folder

#### qmk via2json

* generates a keymap.json from a VIA keymap backup, including both layers and macros
* easy way to take your existing VIA customizations and move them into a C-based keymap

#### qmk import-keyboard

* imports a data-driven info.json keyboard into the repo
* -h  filename

#### qmk import-keymap

* imports a data-driven keymap.json into the repo
* -h filename

#### qmk import-firmware

* creates a new keyboard based on a Keyboard Firmware Builder export
* basic support only
* -h filename

##### Developer options

* qmk format-text -- fixes line endings
* qmk docs -- starts a local http server on port 8938 (or pass -p) to browse docs (pass -b to automatically open a browser window)
* qmk generate-docs to generate the files without serving them
* qmk painter-convert-graphics -- converts images into a useable format (also painter-make-font-image and painter-convert-font-image)

### Config
`qmk config`

* run alone to show the current configuration
* arguments are configuration tokens in the syntax: `<subcommand|general|default>[.<key>][=.value>]`
* delete a configuration by setting it to `None`
* user.qmk_home         sets home directory
* user.keyboard         sets default keyboard
* user.keymap           sets default keymap (most people use their github username)
* compile.keyboard      sets keyboard to use with compile w/no arguments
* compile.keymap        sets keymap to use with compile w/no arguments
* hello.name            sets the name to greet when run
* new_keyboard.keyboard sets the board to use when generating new keyboards w/no arguments
* new_keyboard.keymap   sets the keymap to use when generating new keyboards w/no arguments


## Understanding QMK's Code

* starts from main() in quantum/main.c, initializes platform & kicks off the main loop
* the main loop calls protocol_task() which calls keyboard_task() in quantum/keyboard.c
    * here you'll find:
    * matrix scanning
    * mouse handling
    * status LEDs (caps lock, num lock, etc.)

_Matrix scanning_ is the main function of a keyboard - identifying what keys are pressed. QMK requests the matrix state and gets back an array, then maps that array state to the physical layout map/keymap. QMK uses C macros to distinguish the physical layout from the function

LAYOUT() is defined at the keyboard level; that maps the matrix onto physical keys (including KC_NO where there's a slot in the matrix but no switch, for example where there's a 2u key)

At the keymap level you take LAYOUT() and map keycodes to physical locations--you'll use the same matrix (without the KC_NO entries) but instead of assigning just numbers to them you'll assign keypresses

* keymap calls process_record() to decide what to do next
* options set in rules.mk determine which functions are available from the list of:
    * process_combo
    * velocikey_accellerate
    * update_wpm
    * preprocess_tap_dance
    * process_key_lock
    * process_dynamic_macro
    * process_clicky
    * process_haptic
    * process_record_via
    * process_record_kb
        * process_record_user
    * process_secure
    * process_sequencer
    * process_midi
    * process_audio
    * process_backlight
    * process_steno
    * process_music
    * process_key_override
    * process_tap_dance
    * process_caps_word
    * process_unicode (with three options)
    * process_leader
    * process_auto_shift
    * process_dynamic_tapping_term
    * process_space_cadet
    * process_magic
    * process_grave_esc
    * process_rgb
    * process_joystick
    * process_programmable_button
    * or any functions processing Quantum-specific keycodes
* then a post_process_record() is called to handle cleanup, such as recording macros, clearing buffers, or other wrapup data

## The Hierarchy

* Core (`_quantum`)
    * Keyboard (or revision) (`_kb`)
        * Keymap (`_user`)

* this means that `_kb()` must always call `_user()` first or it won't ever get to the keymap

### Creating custom keycodes

* two steps: first, enumerate your keycode; then, program its behavior

1. Enumerating new keys
* you need to use a unique number for your new keycode; rather than make you figure out what that is, use `SAFE_RANGE` to define it
* for instance, add this to keymap.c and you can use FOO and BAR in your keymap:
```
enum my_keycodes {
    FOO = SAFE_RANGE, 
    BAR
};
```

2. Programming new keys
* add your function to process_record_user()
* if this returns true, QMK will process the keycode as usual; if it returns false, QMK will skip the normal keyhandling (and you'll have to pass any key up/down events required)
* example: define FOO and add a tone to the enter key:
``` 
bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case FOO:
            if (record->event.pressed) {
                //do a thing
         } else {
                // do something else when released
         }
         return false; // and skip all further processing of this key
         case KC_ENTER:
            // play a tone whenever enter is pressed
            if (record->event.pressed) {
                PLAY_SONG(tone_qwerty);
            }
            return true; // and then do the normal thing for enter
        default:
            return true; // process all other keycodes normally
    }
}
```

#### process_record_* arguments
* keyboard/revision level: `bool process_record_kb(uint16_t keycode, keyrecord_t *record)`
* keymap level: `bool process_record_user(uint16_t keycode, keyrecord_t, *record)`
* the keycode argument is whatever is defined in your keymap (eg. KC_L, MO(1)); use a switch...case block to handle these events
* the record argument contains information about the actual keypress

### Initialization

* first, keyboard_pre_init_* (at all layers), hardware startup 
    * you usually won't need this, unless you need to add LED support
* second, matrix_init_* categorizes everything
    * you won't need this until you get into things like handwiring
* third, keyboard_post_init_* is where most customization code goes
    * use this to set up things like underglow
    ```
    void keyboard_post_init_user(void) {
        rgblight_enable_noeeprom(); // enables RGB without saving settings
        rgblight_sethsv_noeeprom(180,255,255); // sets the color to teal/cyan, still without saving
        rgblight_mode_noeeprom(RGBLIGHT_MODE_BREATHING + 3); // sets mode to fast breathing, still without saving
    }
    ```

### Housekeeping

You'll use this for things like letting RGB fall asleep; I'll save this for later because frankly I don't want to figure this out right now

Oh except--it also includes code that runs every time the layer changes, like this example for setting the RGB lights per layer:

```
layer_state_t layer_state_set_user(layer_state_t state) {
    switch (get_highest_layer(state)) {
    case _RAISE:
        rgblight_setrgb (0x00,  0x00, 0xFF);
        break;
    case _LOWER:
        rgblight_setrgb (0xFF,  0x00, 0x00);
        break;
    case _PLOVER:
        rgblight_setrgb (0x00,  0xFF, 0x00);
        break;
    case _ADJUST:
        rgblight_setrgb (0x7A,  0x00, 0xFF);
        break;
    default: //  for any other layers, or the default layer
        rgblight_setrgb (0x00,  0xFF, 0xFF);
        break;
    }
  return state;
}
```

## Bootloaders

* Caterina, on Pro Micros, and Halfkay, on Teensys, don't need bootloader drivers
* Pretty much everything else does
* Zadig is a useful utility (but if you've run the install script, it should have already set things up for you)

## Keymaps

* defined in a C source file as an array of arrays
* outer array is list of layers
* inner array is list of keys
* max is 32 layers
    * this is because of how they're defined: two 32 bit parameters, one that indicates the base layer and another that shows the current on/off status of each layer
* higher layers have precedence
* you can define a variable ------- or XXXXXXX to use in place of KC_TRNS and KC_NO so you can clearly see which keys aren't overriden by a layer

left off at https://docs.qmk.fm/#/keymap?id=keymap-layer-status
also: https://thomasbaart.nl/2018/12/06/qmk-basics-how-to-add-a-layer-to-your-keymap/

# Keebio Documentation

- Quefrency uses the ATmega32u4 DFU bootloader
- each half of a split keyboard should be flashed individually with the same file (minor changes you can get away with just the side plugged into the computer
    - connecting them has no effect: it's a power cable, not a data cable
