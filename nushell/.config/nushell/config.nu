# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
$env.config.edit_mode = 'vi'
$env.config.buffer_editor = '/usr/bin/nvim'
$env.config.show_banner = false
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: false
  isolation: true
}

$env.config.menus ++= [{
    name: history_menu
    only_buffer_difference: false # Search is done on the text written after activating the menu
    marker: "? "                 # Indicator that appears with the menu is active
    type: {
        layout: list             # Type of menu
        page_size: 10            # Number of entries that will presented when activating the menu
    }
    style: {
        text: green                   # Text style
        selected_text: green_reverse  # Text style for selected option
        description_text: yellow      # Text style for description
    }
}]

$env.config.keybindings ++= [
  {
    name: history_down
    modifier: control
    keycode: char_j
    mode: vi_insert
    event: {
      until: [
        { send: menu name: history_menu }
        { send: menunext }
      ]
    }
  }
  {
    name: history_up
    modifier: control
    keycode: char_k
    mode: vi_insert
    event: {
      until: [
        { send: menu name: history_menu }
        { send: menuprevious }
      ]
    }
  }
]

use '/home/erw/.config/broot/launcher/nushell/br' *

source ~/.zoxide.nu

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

def brf [] {
	br --cmd ":toggle_tree"
}
fastfetch

def beep [] {
	loop {
		play -qn synth 0.025 sine 300
		sleep 100ms
		play -qn synth 0.025 sine 300
		sleep 100ms
		play -qn synth 0.025 sine 300
		sleep 55sec
	}
}

def nvless [] {
  nvim -R -c 'set nomodifiable' -c 'nnoremap q :q<CR>' -
}
