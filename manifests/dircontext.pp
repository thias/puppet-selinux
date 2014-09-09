# define: selinux::dircontext
#
# Change SELinux file security context recursively in a directory.
#
# See filecontext.pp
#
define selinux::dircontext (
  $object = $title,
  $seltype,
) {

  selinux::filecontext { $title:
    seltype => $seltype,
    recurse => true,
  }

}
