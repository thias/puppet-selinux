# Local SELinux modules, created from avc denial messages to be allowed.
#
# You must copy the avc denial messages of what you want to allow to :
# files/messages.<selinux_module_name>
#
# The module names loaded are automatically prefixed with "local" in order to
# never conflict with modules from the currently loaded policy.
# You can get a list of existing loaded modules with : semodule -l
#
define selinux::audit2allow_single (
  $ensure  = 'present',
  $content = undef,
  $source  = undef,
  $concat  = $::selinux::concat,
) {

  if $ensure == 'absent' {

    # Unload module if found
    exec { "semodule -r local${title}":
      path   => $::path,
      onlyif => "semodule -l | egrep ^local${title}\s",
    } -> 

    # Remove our files and the ones audit2allow creates
    file { "/etc/selinux/local/${title}":
      ensure => 'absent',
      force  => true,
    }

  } else {

    # Parent directory and directory
    realize File['/etc/selinux/local']
    realize File['/etc/selinux/targeted/contexts/files/file_contexts.local']
    file { "/etc/selinux/local/${title}":
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    if $concat {
      concat { "/etc/selinux/local/${title}/messages":
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        # The refresh requires this, but put it here since otherwise the
        # refresh can get skipped then never run again.
        require => Package['audit2allow'],
        notify  => Exec["reload SELinux ${title} module"],
      }
    } else {
      file { "/etc/selinux/local/${title}/messages":
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $content,
        source  => $source,
        # The refresh requires this, but put it here since otherwise the
        # refresh can get skipped then never run again.
        require => Package['audit2allow'],
        notify  => Exec["reload SELinux ${title} module"],
      }
    }

    # Work around issue where .te file is corrupt on RHEL7 when "upgrading"
    if $::selinux::params::rmmod {
      $rmmod = "semodule -r local${title}; "
    } else {
      $rmmod = ''
    }

    # Reload the changes automatically
    exec { "reload SELinux ${title} module":
      command => "${rmmod}rm -f local${title}.*; audit2allow -M local${title} -i messages && semodule -i local${title}.pp",
      path    => $::path,
      cwd     => "/etc/selinux/local/${title}",
      # Don't run if .pp generation worked + module is loaded
      unless  => "test local${title}.pp -nt messages && ( semodule -l | egrep ^local${title}\s )",
    }

  }

}
