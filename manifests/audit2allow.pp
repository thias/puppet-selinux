# Local SELinux modules, created from avc denial messages to be allowed.
#
# You must copy the avc denial messages of what you want to allow to :
# files/messages.<selinux_module_name>
#
# The module names loaded are automatically prefixed with "local" in order to
# never conflict with modules from the currently loaded policy.
# You can get a list of existing loaded modules with : semodule -l
#
define selinux::audit2allow (
  $content = undef,
  $source  = undef
) {

  include selinux

  # Parent directory and directory
  realize File['/etc/selinux/local']
  file { "/etc/selinux/local/${title}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "/etc/selinux/local/${title}/messages":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $content,
    source  => $source,
    # The refresh requires this, but put it here since otherwise the
    # refresh can get skipped then never run again.
    require => Package['audit2allow'],
  }

  # Reload the changes automatically
  exec { "audit2allow local${title}":
    command     => "rm -f local${title}.*; audit2allow -M local${title} -i messages && semodule -i local${title}.pp",
    path        => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
    cwd         => "/etc/selinux/local/${title}",
    subscribe   => File["/etc/selinux/local/${title}/messages"],
    unless      => "test -f local${title}.pp && ( semodule -l | egrep ^local${title} )",
  }

}

