# puppet-selinux

## Overview

Transparently create SELinux modules based on AVC denial messages, to easily
allow otherwise denied system operations, and set file and directory security contexts

* `selinux` : Main class which makes sure the basics are set up correctly.
* `selinux::audit2allow` : Definition for allowing based on avc denial messages.
* `selinux::filecontext` : Manage SELinux file context.
* `selinux::dircontext` : Manage SELinux file context recursively (directories).
* `selinux::portcontext` : Manage SELinux port context.

Note : For SELinux booleans, use the Puppet built-in `selboolean` type.


## selinux

Main SELinux class to be included on all nodes. If SELinux isn't available,
it does nothing anyway.


## selinux::audit2allow

Local SELinux modules, created from avc denial messages to be allowed.

The SELinux modules created and loaded are automatically prefixed with "local"
in order to never conflict with modules from the currently loaded policy.
You can get a list of existing loaded modules with : `semodule -l`

Example :

```puppet
selinux::audit2allow { 'mydaemon':
  source => "puppet:///modules/${module_name}/selinux/messages.mydaemon",
}
```

The content of the above files is based on kernel/audit avc denial messages,
typically found in `/var/log/audit/audit.log`.
See the included `messages.nrpe` file for an example.

When using it multiple times on a single node, the `selinux::concat` parameter
can be switched to `true` in order to create a single SELinux module instead
of one each time it is used. This speeds up Puppet runs a lot.


## selinux::filecontext and selinux::dircontext

Change SELinux file security context persistently using `semanage`.

To see all existing default contexts for file path patterns :

```bash
semanage fcontext -l
```

To see only the custom ones not included in the base policy, set manually or
by this module :

```bash
semanage fcontext -l -C
```

Example to set a new recursive file context entry (for a directory), which
will run the 'semanage' and 'restorecon' tools to apply the SELinux Type to
the specified path both persistently and immediately.

```puppet
selinux::dircontext { '/data/www':
  seltype => 'httpd_sys_content_t',
}
```

To set the context for just a file, without recursing :

```puppet
selinux::filecontext { '/srv/foo.txt':
  seltype => 'public_content_t',
}
```

To copy the context from another file, set 'copy' to `true` and 'seltype' to
the source file or directory :

```puppet
selinux::dircontext { '/export/home':
  seltype => '/home',
  copy    => true,
}
```

## selinux::portcontext

Change SELinux port security context persistently using `semanage`.

The `ensure` is not mandatory and default is `present`.
The `proto` must be `tcp` or `udp`. Example :
```
selinux::portcontext { '12345':
  seltype => 'redis_port_t',
  proto   => 'tcp',
  ensure  => 'present',
}
```

