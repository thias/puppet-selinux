class selinux::params {

  # Some tools were split out in sub-packages over time

  case $::operatingsystem {
    'Fedora': {
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
      $package_audit2allow = 'policycoreutils-python'
      if $::operatingsystemrelease >= 7 {
        $package_restorecond = 'policycoreutils-restorecond'
      } else {
        $package_restorecond = false
      }
    }
  }

}

