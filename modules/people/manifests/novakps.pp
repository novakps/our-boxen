class people::novakps {
  include emacs
  include zsh
  include osx::dock::clear_dock
  include osx::dock::autohide
  include osx::keyboard::capslock_to_control
  include osx::dock::position

  $home = "/Users/${::boxen_user}"
  $dotfiles_dir = "${boxen::config::srcdir}/dotfiles"

  repository { $dotfiles_dir:
    source => "${::github_user}/dotfiles"
  }

  file { "${home}/.zshrc":
    ensure  => link,
    target  => "${dotfiles_dir}/.zshrc",
    require => Repository[$dotfiles_dir]
  }
}
