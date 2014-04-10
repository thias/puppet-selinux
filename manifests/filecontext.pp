# define: selinux::filecontext
#
# Change SELinux file security context.
#
# You can examine the current SELinux attributes on a file via 'ls -Z'.
# For example:
#
#     $ ls -Zd /dir
#     drwxrwxrwx. root apache unconfined_u:object_r:file_t:s0  /dir
#
# You might want to compare the folder that cannot be accessed by
# a given process (e.g. httpd) with one that can:
#
#     $ ls -Zd /var/www/html
#     drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html
# To see all existing file paths with contexts set:
#     # semanage fcontext -l
#     SELinux fcontext       type               Context
#     /                      directory          system_u:object_r:root_t:s0 
#     /.*                    all files          system_u:object_r:default_t:s0 
#     [...]
#
# To allow httpd to access the /dir directory and everyting it contains,
# we want to use the httpd_sys_content_t SELinux type.  We can do so with
# the following rule:
#
#     selinux::dircontext { '/dir':
#       seltype => 'httpd_sys_content_t',
#     }
#
# This will run the 'semanage' and 'restorecon' tools to apply the specified
# SELinux Type to the specified object persistently and immediately,
# respectively.
#
# If the directory in question already has a unique type that you do not
# want to change, because it is needed for some other policy, you might
# prefer to instead create a new policy for httpd and install it, so that
# the web server can access files of this type as well.  See policy.pp.
#
define selinux::filecontext (
  $object = $title,
  $seltype,
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
      unless  => "semanage fcontext -l -C -n | grep ^${object}",
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
