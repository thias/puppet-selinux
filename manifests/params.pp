# Trivial parameters class, as many SELinux details differ over time
#
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
      $rmmod = false
    }
    'RedHat','CentOS','Scientific': {
      if versioncmp($::operatingsystemrelease, '8') >= 0 {
        $package_audit2allow = 'policycoreutils-python-utils'
        $restorecond = true
        $package_restorecond = 'policycoreutils-restorecond'
        $rmmod = true
      } elsif versioncmp($::operatingsystemrelease, '7') == 0 {
        $package_audit2allow = 'policycoreutils-python'
        $restorecond = true
        $package_restorecond = 'policycoreutils-restorecond'
        $rmmod = true
      } elsif versioncmp($::operatingsystemrelease, '5') >= 0 {
        $package_audit2allow = 'policycoreutils-python'
        $restorecond = true
        $package_restorecond = false
        $rmmod = false
      } else {
        # Very old...
        $package_audit2allow = 'policycoreutils'
        $restorecond = false
        $rmmod = false
      }
    }
  }

}
