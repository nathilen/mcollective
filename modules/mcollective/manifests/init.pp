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

  file {'/etc/mcollective/client.cfg':
    ensure => present,
    source => 'puppet:///modules/mcollective/client.cfg',
    require => Package['mcollective-client']
  }

  apt::source {'rabbitmq':
    location => 'http://www.rabbitmq.com/debian/',
    release  => 'testing',
    repos    => 'main',
  }
  
  apt::key {'rabbitmq':
    key_source => 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc',
    before     => Apt::Source['rabbitmq'],
  }
    
  class { 'rabbitmq::server':
    delete_guest_user => true,
    require           => Apt::Source['rabbitmq'],
  }

  rabbitmq_user { 'mcollective':
    admin    => false,
    password => 'password',
    provider => 'rabbitmqctl',
  }

  rabbitmq_vhost { 'mcollective':
    ensure => present,
    provider => 'rabbitmqctl',
  }

  rabbitmq_user_permissions { 'mcollective@mcollective':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
    provider => 'rabbitmqctl',
  }

  rabbitmq_plugin {'rabbitmq_stomp':
    ensure => present,
    provider => 'rabbitmqplugins',
    notify => Service['rabbitmq-server'],
  }

  rabbitmq_plugin {'rabbitmq_management':
    ensure => present,
    provider => 'rabbitmqplugins',
    notify => Service['rabbitmq-server'],
  }
  
  file {'/usr/bin/rabbitmqadmin':
    ensure => present,
    source => 'puppet:///modules/mcollective/rabbitmqadmin',
    mode   => 0755,
    require => Rabbitmq_Plugin['rabbitmq_management'],
    notify => Service['rabbitmq-server'],
  }

  file_line{'node_entry':
    path => '/etc/hosts',
    line => '192.168.33.11 node1',
  }

  exec {'create_broadcast_exchange':
    command => '/usr/bin/rabbitmqadmin declare exchange --username=mcollective --password=password --vhost=mcollective --name=mcollective_broadcast type=topic',
    require => File['/usr/bin/rabbitmqadmin'],
  }

}