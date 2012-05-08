class archiva::conf($version = "1.4-M2", $destination_parent = '/opt', $user = 'archiva') { 

    $destination = "$destination_parent/archiva"

    if !defined(File["$destination_parent"]) {
        file { "$destination_parent":
            ensure => 'directory',
            owner => "root",
            group => "root",
            mode => "0751",
        }
    }

}
