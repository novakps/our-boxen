class people::novakps {
  include emacs
  include zsh
  include ohmyzsh
  include zshgitprompt
  include osx::dock::clear_dock
  include osx::dock::autohide
  include osx::keyboard::capslock_to_control
  include osx::dock::position

  $home     = "/Users/${::boxen_user}"
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source  => 'novakps/dotfiles'
  }
}
