# define: selinux::portcontext
#
# Change SELinux port security context.
#
define selinux::portcontext (
  $seltype,
  $proto,
  $object = $title,
  $ensure = 'present',
) {

  if $::selinux {

    # Run semanage to persistently set the SELinux Type.
    if $ensure == 'absent' {
      exec { "semanage_port_${seltype}_${object}_absent":
        command => "semanage port -d -t ${seltype} -p ${proto} ${object}",
        path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        # RHEL 7.7+ added "-r 's0'" between -t and -p
        onlyif  => "semanage port -E | grep '^port -a -t ${seltype} .*-p ${proto} ${object}$'",
        require => Package['audit2allow'],
      }
    } else {
      exec { "semanage_port_${seltype}_${object}":
        command => "semanage port -a -t ${seltype} -p ${proto} ${object}",
        path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        # RHEL 7.7+ added "-r 's0'" between -t and -p
        unless  => "semanage port -E | grep '^port -a -t ${seltype} .*-p ${proto} ${object}$'",
        require => Package['audit2allow'],
      }
    }

  }

}
