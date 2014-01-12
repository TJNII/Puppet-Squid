# Copyright 2014 Tom Noonan II (TJNII)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# See readme for variable descriptions
#
class squid (
  $squid_allowednets = [],
  $squid_bannednets  = [],
  $squid_cache       = undef,
  $squid_admin_email = "root@$domain",
  $squid_disable_forwarded_for = false,
  $manage_firewall   = true,
) {
  case $operatingsystem {
    debian: {
      package { 'squid3':
        ensure => installed,
      }
    }
    
    default: {
      fail("Unsupported OS: $operatingsystem")
    }
  }
  
    
  service { 'squid3':
    ensure    => running,
    enable    => true,
    subscribe => File['squid.conf'],
  }

  file { 'squid.conf':
    path    => '/etc/squid3/squid.conf',
    ensure  => file,
    require => Package['squid3'],
    content  => template("squid/squid.conf.erb"),
  }
  
  if $manage_firewall == true {
    include firewall-config::base
    
    firewall { '101 allow Squid':
      state => ['NEW'],
      dport => '8080',
      proto => 'tcp',
      action => accept,
    }
  }
}
  
  
