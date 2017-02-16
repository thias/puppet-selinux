# Main SELinux class to be included on all nodes. If SELinux isn't enabled
# it does nothing anyway.
#
class selinux (
  $package_audit2allow = $::selinux::params::package_audit2allow,
  $restorecond         = $::selinux::params::restorecond,
  $package_restorecond = $::selinux::params::package_restorecond,
  $concat              = false,
) inherits ::selinux::params {

  if $::selinux {
    package { 'audit2allow':
      ensure => 'installed',
      name   => $package_audit2allow,
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
    @file { '/etc/selinux/local':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    # RHEL 7.3 issue, file needs to exist for audit2allow to work
    @file { '/etc/selinux/targeted/contexts/files/file_contexts.local':
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
    # The single module when concat is used
    @selinux::audit2allow_single { 'audit2allow':
      ensure => 'present',
      concat => $concat,
    }
  }

}
