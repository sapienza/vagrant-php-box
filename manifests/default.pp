# Puppet configurations

Exec { path =>  [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class base {

  ## Update apt-get ##
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }
}

class http {

  define apache::loadmodule () {
    exec { "/usr/sbin/a2enmod $name" :
      unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
      notify => Service[apache2]
    }
  }

  apache::loadmodule{"rewrite":}

  package { "apache2":
    ensure => present,
  }

  service { "apache2":
    ensure => running,
    require => Package["apache2"],
  }
}

class php{

  package { "php5":
    ensure => present,
  }

  package { "php5-cli":
    ensure => present,
  }

  package { "php5-xdebug":
    ensure => present,
  }

  package { "php5-mysql":
    ensure => present,
  }

  package { "php5-imagick":
    ensure => present,
  }

  package { "php5-mcrypt":
    ensure => present,
  }

  package { "php-pear":
    ensure => present,
  }

  package { "php5-dev":
    ensure => present,
  }

  package { "php5-curl":
    ensure => present,
  }

  package { "php5-sqlite":
    ensure => present,
  }

  package { "libapache2-mod-php5":
    ensure => present,
  }

}

class mysql{

  package { "mysql-server":
    ensure => present,
  }

  service { "mysql":
    ensure  => running,
    require => Package["mysql-server"],
    notify  => Exec["set-mysql-password"],
  }

  exec { "set-mysql-password":
    command => "mysqladmin -u root password root",
  }
}

class phpmyadmin{

  package
  {
    "phpmyadmin":
      ensure => present,
      require => [
        Exec['apt-get update'],
        Package["php5", "php5-mysql", "apache2"],
      ]
  }

  file
  {
    "/etc/apache2/conf-available/phpmyadmin.conf":
      ensure => link,
      target => "/etc/phpmyadmin/apache.conf",
      require => Package['apache2'],
      notify => Exec["load_phpmyadmin_conf"],
  }

  exec { "load_phpmyadmin_conf":
    command => "/usr/sbin/a2enconf phpmyadmin",
    notify  => Exec["reload_apache"],
  }
  exec { "reload_apache":
    command => "/etc/init.d/apache2 reload",
  }
}

include base
include http
include php
include mysql
include phpmyadmin
