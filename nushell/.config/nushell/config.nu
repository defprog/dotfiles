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

$env.config.buffer_editor = '/usr/bin/nvim'
$env.config.show_banner = false
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: false
  isolation: true
}

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
