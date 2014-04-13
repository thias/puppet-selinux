class selinux::params {

  # Some tools were split out in sub-packages over time

  case $::operatingsystem {
    'Fedora': {
      $restorecond = true
      if $::operatingsystemrelease >= 11 {
        $package_audit2allow = 'policycoreutils-python'
      } else {
        $package_audit2allow = 'policycoreutils'
      }
      if $::operatingsystemrelease >= 17 {
        $package_restorecond = 'policycoreutils-restorecond'
      } else {
        $package_restorecond = false
      }
    }
    'RedHat','CentOS','Scientific': {
      if $::operatingsystemrelease >= 7 {
        $package_audit2allow = 'policycoreutils-python'
        $restorecond = true
        $package_restorecond = 'policycoreutils-restorecond'
      } elsif $::operatingsystemrelease >= 5 {
        $package_audit2allow = 'policycoreutils-python'
        $restorecond = true
        $package_restorecond = false
      } else {
        # Very old...
        $package_audit2allow = 'policycoreutils'
        $restorecond = false
      }
    }
  }

}

