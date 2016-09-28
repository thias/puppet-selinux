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
  $ensure  = 'present',
  $content = undef,
  $source  = undef,
) {

  include '::selinux'

  $concat = $::selinux::concat

  if $concat == false {

    selinux::audit2allow_single { $title:
      ensure  => $ensure,
      content => $content,
      source  => $source,
      concat  => false,
    }

  } else {

    if $ensure != 'absent' {

      realize Selinux::Audit2allow_single['audit2allow']
      # concat fragment
      concat::fragment{ "audit2allow ${title}":
        target  => '/etc/selinux/local/audit2allow/messages',
        content => $content,
        source  => $source,
      }

      # For when switching to concat, remove the non-concat
      selinux::audit2allow_single { $title:
        ensure  => 'absent',
        # Make sure we have changes at all times
        require => Selinux::Audit2allow_single['audit2allow']
      }

    } else {

      # explicit purge?

    }

  }

}
