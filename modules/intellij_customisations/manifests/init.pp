class intellij_customisations(
  $license = undef,
) {
  require intellij

  $home_dir = "/Users/$::boxen_user"

  file { "$home_dir/Library/Preferences/IntelliJIdea12":
    ensure => 'directory',
  }

  if $license {
    file { "$home_dir/Library/Preferences/IntelliJIdea12/idea12.key":
      ensure => 'present',
      content => $license,
      require => File["$home_dir/Library/Preferences/IntelliJIdea12"],
    }
  }
  file { "$home_dir/Library/Preferences/IntelliJIdea12/disabled_plugins.txt":
    ensure => 'present',
    source => "puppet:///modules/intellij_customisations/disabled_plugins.txt",
    require => File["$home_dir/Library/Preferences/IntelliJIdea12"],
  }
}
