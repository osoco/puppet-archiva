class archiva::user {

    include archiva::conf

    group { "$archiva::conf::user":
         ensure => present
    }

    user { "$archiva::conf::user":
        ensure => present,
        gid => "$archiva::conf::user",
        shell => '/bin/sh',
        home => "$archiva::conf::destination",
        require => Group["$archiva::conf::user"],
    }

}
