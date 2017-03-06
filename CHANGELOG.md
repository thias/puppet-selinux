* Require newer concat where file resource seems no longer included.
* Fix limitation when a path contains another (foo.conf, foo.conf.puppet).
* Work around missing file_contexts.local on RHEL 7.3.

#### 2016-11-10 - 1.0.5
* Support a single concat managed audit2allow SELinux module.
* Support setting seltype copying its value (#7, @yakatz).

#### 2015-05-20 - 1.0.4
* Workaround in audit2allow package name/alias for Puppet 4 compatibility.

#### 2015-03-06 - 1.0.3
* Support ensure => 'absent' for audit2allow.

#### 2015-02-25 - 1.0.2
* Cosmetic fixes to make puppet-lint happy.
* Update README to make instructions shorter and clearer.

#### 2014-09-22 - 1.0.1
* Fix audit2allow refresh by comparing .pp file and messages timestamps.

#### 2014-09-09 - 1.0.0
* Make sure audit2allow exec is tried again if part of it fails.
* Work around audit2allow issue on RHEL7, previous module need to be unloaded.

#### 2014-04-28 - 0.2.0
* Apply changes also in Permissive mode.
* Add filecontext definition (#2, @carlossg).
* Add support for RHEL 7 (policycoreutils-restorecond package split).
* Add support for RHEL 4.
* Remove libselinux-ruby package, all recent puppet rpms pull it in.

#### 2014-01-16 - 0.1.3
* Set owner, group and mode for the local audit2allow files.
* Fix audit2allow directory ownership.

#### 2013-05-24 - 0.1.2
* Add new dircontext definition, still a work in progress (Greg Anderson).
* Update README and use markdown.
* Change to 2-space indent.
* Remove the clean up of the very very old file names this module used to use.
* Remove automatic support for message files provided inside this module.
* Update tests.

#### 2012-12-18 - 0.1.1
* Add policycoreutils-restorecond package for recent Fedora versions.

#### 2012-09-19 - 0.1.0
* Clean up the module for its initial forge release.

