# define: selinux::filecontext
#
# Change SELinux file security context.
#
define selinux::filecontext (
  $seltype,
  $object  = $title,
  $recurse = false,
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

    # Run semanage to persistently set the SELinux Type.
    # Note that changes made by semanage do not take effect
    # until an explicit relabel is performed.
    exec { "semanage_fcontext_${seltype}_${object}":
      command => "semanage fcontext -a -t ${seltype} '${target}'",
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
