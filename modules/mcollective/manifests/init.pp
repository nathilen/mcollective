class mcollective {
  include apt::update

  apt::source { 'puppetlabs':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'main',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

  package { 'mcollective-client':
    ensure => present,
    require => Apt::Source['puppetlabs'],
  }

  package { 'ruby-stomp':
    ensure => present,
    require => Apt::Source['puppetlabs'],
  }

  file { '/etc/mcollective/client.cfg':
    ensure => present,
    source => 'puppet:///modules/mcollective/client.cfg',
    require => Package['mcollective-client']
  }

  file { '/usr/share/mcollective/plugins/mcollective/agent/helloworld.ddl':
    ensure => present,
    source => 'puppet:///modules/mcollective/helloworld.ddl',
    require => Package['mcollective-client']
  }
}
