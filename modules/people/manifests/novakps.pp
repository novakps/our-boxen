class people::novakps {
  include emacs
  include zsh
  include ohmyzsh
  include zshgitprompt
  include osx::dock::clear_dock
  include osx::dock::position

  git::config::global { 'user.email':
    value  => 'paul.novak@schrodinger.com'
  }

  git::config::global { 'user.name':
    value  => 'Paul Novak'
  }

  git::config::global { 'push.default':
    value => 'current'
  }
}
