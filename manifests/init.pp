# Public: Installs & configures gh
#
# Examples
#
#   include gh
class gh(
  $ensure          = present,
  $alias_gh_to_git = true,
) {

  case $ensure {
    present: {
      if defined_with_params(Package[hub], { 'ensure' => 'latest' }) {
        fail('The gh package is incompatible with the hub package!')
      }

      include boxen::config

      homebrew::formula { 'gh': }


      package { 'boxen/brews/gh':
        ensure => latest,
      }

      git::config::global { 'gh.protocol':
        value => 'https'
      }

      if $::osfamily == 'Darwin' {
        include homebrew::config

        file { "${boxen::config::envdir}/gh.sh":
          ensure  => absent,
        }

        ->
        boxen::env_script { 'gh':
          content  => template('gh/env.sh.erb'),
          priority => lower,
        }
      }
    }

    absent: {
      package { 'gh':
        ensure => absent
      }

      file { "${boxen::config::envdir}/gh.sh":
        ensure => absent
      }
    }

    default: {
      fail("GH#ensure must be present or absent!")
    }

  }

}
