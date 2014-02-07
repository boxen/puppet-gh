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

        ensure_resource('file', "/Users/${::boxen_user}/.config", {
          'ensure' => 'directory',
        })

        file { "/Users/${::boxen_user}/.config/gh":
          ensure  => present,
          content => "{\"credentials\":[{\"host\":\"github.com\",\"user\":\"${::github_login}\",\"access_token\":\"${::github_token}\"}]}\n",
        }
      }
    }

    absent: {
      package { 'gh':
        ensure => absent,
      }

      boxen::env_script { 'gh':
        ensure   => absent,
        priority => lower,
        content  => 'this is a hack',
      }
    }

    default: {
      fail('GH#ensure must be present or absent!')
    }

  }

}
