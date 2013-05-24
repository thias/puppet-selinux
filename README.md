# puppet-selinux

## Overview

Transparently create SELinux modules based on AVC denial messages, to easily
allow otherwise denied system operations.

* `selinux` : Main class which makes sure the basics are set up correctly.
* `selinux::audit2allow` : Definition to allow based on avc denial messages.

## Examples

    selinux::audit2allow { 'mydaemon':
      source => 'puppet:///modules/mymodule/selinux/messages.mydaemon',
    }

The content of the above files is based on kernel/audit avc denial messages.
See the included `messages.nrpe` file for an example.

