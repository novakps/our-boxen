require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # languages
  include java

  # browsers
  include chrome
  include firefox

  # development tools
  include virtualbox

  class { 'intellij':
    edition => 'ultimate',
    version => '12.1.7b'
  }
  class { 'intellij_customisations':
    license => file("/Users/$::boxen_user/idea12.key")
  }

  # text editors
  include emacs
  include emacs_customisations
  include prelude

 # databases
  include postgresql
  postgresql::db { 'seurat': }
#  package { 'pgadmin3': provider => 'brewcask'}

  # command line
  include terminal_customisations
  include zsh
  include zsh_customisations
  include wget
  include autojump
  include ctags
  include tmux

  # applications
  include evernote
  include googledrive
  include hipchat
  include sourcetree
  include calibre
  include cord
  include gimp
  include reggy
  include shiftit
  include skitch
  include skype
  include graphviz
  include vlc


  # osx defaults
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::tap_to_click
  include osx::global::enable_standard_function_keys
  include osx::global::disable_remote_control_ir_receiver
  include osx::global::key_repeat_rate
  class { 'osx::global::key_repeat_delay': delay => 10 }

  include osx::dock::autohide
  include osx::dock::icon_size

  include osx::finder::show_all_on_desktop
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library

  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::software_update
  include osx::keyboard::capslock_to_control

  class { 'osx::dock::hot_corners':
    top_right => "Application Windows",
    top_left => "Mission Control",
    bottom_left => "Put Display to Sleep",
    bottom_right => "Desktop",
  }

  # sudo defaults
  sudo::defaults { 'Defaults':
    parameters => ['timestamp_timeout=20'],
  }

  #  fail if FDE is not enabled
  # if $::root_encrypted == 'no' {
  #   fail('Please enable full disk encryption and try again')
  # }

  # node versions
  nodejs::version { 'v0.10': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'gawk',
      'p7zip',
      'ant',
      'haproxy'
    ]:
  }


  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
