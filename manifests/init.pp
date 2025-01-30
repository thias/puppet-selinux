# Main SELinux class to be included on all nodes. If SELinux isn't enabled
# it does nothing anyway.
#
class selinux (
  $package_audit2allow = $::selinux::params::package_audit2allow,
  $restorecond         = $::selinux::params::restorecond,
  $package_restorecond = $::selinux::params::package_restorecond,
  $concat              = false,
) inherits ::selinux::params {

  if ('selinux' in $facts['os']) {
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
    # Don't use a file resource since Puppet enforces system_u while an update
    # of the selinux-policy sets it back to unconfined_u for some reason, and
    # 'seluser => undef' doesn't seem to work on a file resource...
    exec { 'touch /etc/selinux/targeted/contexts/files/file_contexts.local':
      user    => 'root',
      path    => $facts['path'],
      creates => '/etc/selinux/targeted/contexts/files/file_contexts.local',
    }
    # The parent directory used from selinux::audit2allow
    @file { '/etc/selinux/local':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Exec['touch /etc/selinux/targeted/contexts/files/file_contexts.local'],
    }
    # The single module when concat is used
    @selinux::audit2allow_single { 'audit2allow':
      ensure => 'present',
      concat => $concat,
    }
  }

}
