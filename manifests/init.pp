# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include dog_site
class dog_site (
  String $favourite = 'Poodles',
) {

  file {'c:\inetpub\dogsite':
    ensure => directory,
    owner  => system,
  }

  file {'c:\inetpub\dogsite\dogs.html':
    ensure  => file,
    content => epp('dog_site/dogs.epp', {'favourite' => $favourite, 'servertype' => $facts['os']['windows']['product_name']}),
  }

  acl { 'c:\inetpub\dogsite':
    permissions => [
      { identity => 'IIS_IUSRS', rights => ['read','execute'] },
    ],
  }

  # Configure Cat site
  iis_site { 'dogs':
    ensure           => 'started',
    physicalpath     => 'c:\inetpub\dogsite',
    applicationpool  => 'DefaultAppPool',
    enabledprotocols => 'http',
    bindings         => [
      {
        'bindinginformation' => '*:80:dogs',
        'protocol'           => 'http',
      }
    ],
    defaultpage      => 'dogs.html',
    name             => 'dog web site',
  }

}
