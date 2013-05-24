selinux::audit2allow { 'nrpe':
  source => 'puppet:///modules/selinux/messages.nrpe',
}
