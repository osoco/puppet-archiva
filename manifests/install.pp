class archiva::install { 

    $standalone_url = "http://apache.rediris.es/archiva/binaries/apache-archiva-${archiva::conf::version}-bin.zip"

    include wget
    include archiva::conf

    file { "$archiva::conf::destination":
        ensure => 'directory',
        owner => "$archiva::conf::user",
        group => "$archiva::conf::user",
        mode => "0751",
    }

    wget::fetch { 'archiva-package-download':
        source => "$standalone_url",
        destination => "$archiva::conf::destination/apache-archiva.zip",
        require => [Package["wget"], File["$archiva::conf::destination"]],
    }

    exec { 'unzip-archiva-package':
        command => "unzip apache-archiva.zip",
        cwd => "$archiva::conf::destination",
        refreshonly => true,
        subscribe => Wget::Fetch['archiva-package-download'],
    }

    exec { 'mv-archiva-content':
        command => "find apache-archiva-* -mindepth 1 -maxdepth 1 -exec mv {} . \;",
        cwd => "$archiva::conf::destination",
        refreshonly => true,
        subscribe => Exec['unzip-archiva-package'],
    }

    exec { 'rm-archiva-dir':
        command => "find . -mindepth 1 -maxdepth 1 -type d -name 'apache-archiva-*' -exec rmdir {} \;",
        cwd => "$archiva::conf::destination",
        refreshonly => true,
        subscribe => Exec['mv-archiva-content'],
    }

    exec { 'chown-archiva':
        command => "chown -R $archiva::conf::user.$archiva::conf::user $archiva::conf::destination",
        refreshonly => true,
        subscribe => Exec['rm-archiva-dir'],
    }

    file { "$archiva::conf::destination/bin/wrapper-linux-x86-32":
        ensure => 'absent',
        require => Exec['mv-archiva-content']
    }

}
