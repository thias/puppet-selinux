# Main SELinux class to be included on all nodes. If SELinux isn't enabled
# it does nothing anyway.
#
class selinux inherits ::selinux::params {

  if $::selinux {
    package { $package_audit2allow:
      alias  => 'audit2allow',
      ensure => installed,
    }
    if $restorecond {
      if $package_restorecond {
        package { $package_restorecond:
          ensure => installed,
          before => Service['restorecond'],
        }
      }
      service { 'restorecond':
        enable    => true,
        ensure    => running,
        hasstatus => true,
      }
    }
    package { 'libselinux-ruby': ensure => installed }
    # The parent directory used from selinux::audit2allow
    @file { '/etc/selinux/local': ensure => directory }
  }

}

