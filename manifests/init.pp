# Main SELinux class to be included on all nodes. If SELinux isn't enabled
# it does nothing anyway.
#
class selinux (
  $package_audit2allow = $::selinux::params::package_audit2allow,
  $restorecond         = $::selinux::params::restorecond,
  $package_restorecond = $::selinux::params::package_restorecond,
) inherits ::selinux::params {

  if $::selinux {
    package { $package_audit2allow:
      ensure => 'installed',
      alias  => 'audit2allow',
    }
    if $restorecond {
      if $package_restorecond {
        package { $package_restorecond:
          ensure => 'installed',
          before => Service['restorecond'],
        }
      }
      service { 'restorecond':
        ensure    => 'running',
        enable    => true,
        hasstatus => true,
      }
    }
    # The parent directory used from selinux::audit2allow
    @file { '/etc/selinux/local': ensure => 'directory' }
  }

}
