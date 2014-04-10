# puppet-selinux

## Overview

Transparently create SELinux modules based on AVC denial messages, to easily
allow otherwise denied system operations, and set file and directory security contexts

* `selinux` : Main class which makes sure the basics are set up correctly.
* `selinux::audit2allow` : Definition to allow based on avc denial messages.
* `selinux::filecontext` : Change SELinux file security context.
* `selinux::dircontext` : Change SELinux file security context recursively in a directory.

## selinux

Main SELinux class to be included on all nodes. If SELinux isn't enabled
it does nothing anyway.


## audit2allow

Local SELinux modules, created from avc denial messages to be allowed.

You must copy the avc denial messages of what you want to allow to :
files/messages.<selinux_module_name>

The module names loaded are automatically prefixed with "local" in order to
never conflict with modules from the currently loaded policy.
You can get a list of existing loaded modules with : semodule -l

Example:

    selinux::audit2allow { 'mydaemon':
      source => 'puppet:///modules/mymodule/selinux/messages.mydaemon',
    }

The content of the above files is based on kernel/audit avc denial messages.
See the included `messages.nrpe` file for an example.


## selinux::filecontext

Change SELinux file security context.

You can examine the current SELinux attributes on a file via 'ls -Z'.
For example:

    $ ls -Zd /dir
    drwxrwxrwx. root apache unconfined_u:object_r:file_t:s0  /dir

You might want to compare the folder that cannot be accessed by
a given process (e.g. httpd) with one that can:

    $ ls -Zd /var/www/html
    drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html

To see all existing file paths with contexts set:

    # semanage fcontext -l
    SELinux fcontext       type               Context
    /                      directory          system_u:object_r:root_t:s0
    /.*                    all files          system_u:object_r:default_t:s0
    [...]

To allow httpd to access the /dir directory and everyting it contains,
we want to use the httpd_sys_content_t SELinux type.  We can do so with
the following rule:

    selinux::dircontext { '/dir':
      seltype => 'httpd_sys_content_t',
    }

This will run the 'semanage' and 'restorecon' tools to apply the specified
SELinux Type to the specified object persistently and immediately,
respectively.

If the directory in question already has a unique type that you do not
want to change, because it is needed for some other policy, you might
prefer to instead create a new policy for httpd and install it, so that
the web server can access files of this type as well.  See audit2allow.pp.

To set the context for just a file, without recursing, use selinux::filecontext

    selinux::filecontext { '/var/home_dir':
      seltype => 'user_home_dir_t',
    }

## selinux::dircontext

Change SELinux file security context recursively in a directory.
See `selinux::filecontext` above for details
