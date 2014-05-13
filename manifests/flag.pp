# = Define selinux::flag
#
# This define sets selinux flags.
#
# == Requirements:
#
# - This module requires selinux
#
# == Parameters
#
# [* flag *]
#   The name of the flag.  Defaults to the title of the define.
#
# [* value *]
#   The value of the flag.  Defaults to 1.
#
# == Examples
#
# == Author
#
define selinux::flag (
  $flag = $title,
  $value = '1'
) {

  $expected = $value ? {
    '0' => 'off',
    '1' => 'on'
  }

  exec { "setsebool-${flag}-${value}":
    command => "/usr/sbin/setsebool -P ${flag} ${value}",
    unless  => "/usr/sbin/getsebool ${flag} | grep -q -- '--> ${expected}'",
#    require => File["/etc/selinux/config"]
  }
}
