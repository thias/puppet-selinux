# define: selinux::portcontext
#
# Change SELinux port security context.
#
define selinux::portcontext (
  $seltype,
  $proto,
  $object = $title,
) {

  if $::selinux {

    # Run semanage to persistently set the SELinux Type.
    exec { "semanage_port_${seltype}_${object}":
      command => "semanage port -a -t ${seltype} -p ${proto} ${object}",
      path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
      # RHEL 7.7+ added "-r 's0'" between -t and -p
      unless  => "semanage port -E | grep '^port -a -t ${seltype} .*-p ${proto} ${object}$'",
      require => Package['audit2allow'],
    }

  }

}
