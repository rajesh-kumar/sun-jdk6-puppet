class sun-jdk6 {
  
 file {"/etc/apt/sources.list":
    source => "puppet:///etc/apt/sources.list"
  }
  
  # Ensure we have set all configs for IDNA packages
  exec {
    "apt-get update":
      path => ["/usr/sbin", "/usr/bin", "/bin", "/sbin"],
      subscribe => File["/etc/apt/sources.list"];
  }

  file { "/var/cache/debconf/sun-jdk6.pressed":
    source => "puppet:///etc/sun-java-6/sun-jdk6.pressed",
    ensure => present;
  }
  

  package { "sun-java6-jdk":
    ensure  => installed,
    responsefile => "/var/cache/debconf/sun-jdk6.pressed",
    require => [File["/var/cache/debconf/sun-jdk6.pressed"], File["/etc/apt/sources.list"], Exec["apt-get update"]];
  }
  

  # Ensure we have sun-java set as the default alternative
  exec {
    "update-java-alternatives --jre --set java-6-sun":
      path => ["/usr/sbin", "/usr/bin", "/bin", "/sbin"],
      unless => 'test $(readlink /etc/alternatives/java) == "/usr/lib/jvm/java-6-sun/jre/bin/java"',
      require => Package["sun-java6-jdk"];
  }
}