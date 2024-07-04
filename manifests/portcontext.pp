# define: selinux::portcontext
#
# Change SELinux port security context.
#
define selinux::portcontext (
  $seltype,
  $proto,
  $ensure = 'present',
  $object = $title,
) {

  if $::selinux {

    Exec {
      path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
      require => Package['audit2allow'],
    }

    # Run semanage to persistently set the SELinux Type.
    if $ensure == 'absent' {
      exec { "semanage_port_${seltype}_${object}_absent":
        command => "semanage port -d -t ${seltype} -p ${proto} ${object}",
        # RHEL 7.7+ added "-r 's0'" between -t and -p
        onlyif  => "semanage port -E | grep '^port -a -t ${seltype} .*-p ${proto} ${object}$'",
      }
    } else {
      exec { "semanage_port_${seltype}_${object}":
        command => "semanage port -a -t ${seltype} -p ${proto} ${object}",
        # RHEL 7.7+ added "-r 's0'" between -t and -p
        unless  => "semanage port -E | grep '^port -a -t ${seltype} .*-p ${proto} ${object}$'",
      }
    }

  }

}
