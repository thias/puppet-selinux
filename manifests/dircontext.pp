# define: selinux::dircontext
#
# Change SELinux file security context recursively in a directory.
#
# See filecontext.pp
#
define selinux::dircontext (
  $seltype,
  $object = $title,
  $copy   = false,
  $force  = false,
) {

  selinux::filecontext { $object:
    seltype => $seltype,
    recurse => true,
    copy    => $copy,
    force   => $force,
  }

}
