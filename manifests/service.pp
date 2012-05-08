class archiva::service {

    include archiva::conf
    include archiva::install
    include archiva::user

    file { '/etc/init.d/archiva':
	ensure => 'present',
	owner => 'root',
	group => 'root',
	mode => '0754',
        source => "puppet:///modules/archiva/etc/init.d/archiva",
	require => File["$archiva::conf::destination/bin/wrapper-linux-x86-32"]
    }

    service { "archiva":
        ensure => running,
        hasstatus => true,
        hasrestart => true,
        enable => true,
        require => [File['/etc/init.d/archiva'], Exec['chown-archiva'], User["$archiva::conf::user"]]
    }
}
