class people::novakps {
  include emacs
  include zsh
  include ohmyzsh
  include zshgitprompt
  include osx::dock::clear_dock
  include osx::dock::autohide
  include osx::keyboard::capslock_to_control
  include osx::dock::position

  $home = "/Users/${::boxen_user}"
  $dotfiles_dir = "${boxen::config::srcdir}/dotfiles"

  # Changes the default shell to the zsh version we get from Homebrew
  # Uses the osx_chsh type out of boxen/puppet-osx
  osx_chsh { $::luser:
    shell   => '/opt/boxen/homebrew/bin/zsh',
    require => Package['zsh'],
  }

  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
  }

  repository {
    $dotfiles_dir: source => "novakps/dotfiles"
  }

  file { "${home}/.zshrc":
    ensure => link,
    target => "${dotfiles_dir}/.zshrc",
    require => Repository[$dotfiles_dir]
  }
}
