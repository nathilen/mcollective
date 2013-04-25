class mcollective::daemon {
  include apt

  apt::source { 'puppetlabs':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'main',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

  package { 'ruby-stomp':
    ensure => present,
    require => Apt::Source['puppetlabs'],
  }

  package { 'mcollective':
    ensure => present,
    require => [Apt::Source['puppetlabs'], Package['ruby-stomp']],
  }

  service { 'mcollective':
    ensure  => running,
    enable  => true,
    require => [Package['mcollective'], Package['ruby-stomp']],
  }

  file { '/etc/mcollective/server.cfg':
    ensure => present,
    source => 'puppet:///modules/mcollective/server.cfg',
    require => Package['mcollective'],
    notify => Service['mcollective'],
  }
}
