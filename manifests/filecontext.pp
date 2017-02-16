# define: selinux::filecontext
#
# Change SELinux file security context.
#
define selinux::filecontext (
  $seltype,
  $object  = $title,
  $recurse = false,
  $copy    = false,
) {

  if $::selinux {

    $target = $recurse ? {
      true  => "${object}(/.*)?",
      false => $object,
    }
    $restore_options = $recurse ? {
      true  => '-R ',
      false => '',
    }
    $onlyif_options = $recurse ? {
      true  => '-d',
      false => '-e',
    }
    $copy_options = $copy ? {
      true  => '-e',
      false => '-t',
    }

    # Run semanage to persistently set the SELinux Type.
    # Note that changes made by semanage do not take effect
    # until an explicit relabel is performed.
    exec { "semanage_fcontext_${seltype}_${object}":
      command => "semanage fcontext -a ${copy_options} ${seltype} '${target}'",
      path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
      unless  => "semanage fcontext -l -C -n | grep ^${object}$",
      require => Package['audit2allow'],
      notify  => Exec["restorecon_${seltype}_${object}"],
    }

    # Run restorecon to immediately set the SELinux Type.
    exec { "restorecon_${seltype}_${object}":
      command     => "restorecon ${restore_options}${object}",
      path        => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
      refreshonly => true,
      onlyif      => "test ${onlyif_options} ${object}",
    }

  }

}
