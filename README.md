Squid
=====

This module configures a Squid HTTP proxy server on port 8080

OS Support
----------

Currently only supports Debian.

Configuration
-------------

#### General
* squid_admin_email: Administrator contact email.  Default: "root@$domain",
* squid_disable_forwarded_for (BOOLEAN): Disable X-Forwarded-For headers.  Squid option: "forwarded_for delete".  Default: false
* manage_firewall: Add a rule to the firewall to allow access.  Default: true

#### ACLs

ACLs are Deny blacklist, Allow whitelist, Deny All

Configuration variables:
* squid_allowednets: Array of networks to whitelist
* squid_bannednets: Array of subnets to blacklist, can overlap allowednets

#### Cache

Define squid_cache to enable caching.  Default: undef

squid_cache is a hash of config variables:
* mem_size: Amount of memory to use for cache with suffix.  Squid option: cache_mem
* mem_max_obj: Maximum object size to cache in memory with suffix.  Squid option: maximum_object_size_in_memory
* disk: (Optional) Enable aufs disk cache.  This is another hash:
   * path: Path to store cache.  Squid option: cache_dir
   * size: Amount of disk cache to use in MB without suffix. Squid option: cache_dir
   * L1: Number of first level directories to create in the cache structure. Squid option: cache_dir
   * L2: Number of second level directories to create in the cache structure. Squid option: cache_dir
   * max_obj: Maximum object size to cache in disk with suffix.  Squid option: maximum_object_size
   * cache_swap: Hash of swal caching settings
       * low: Low swap percent.  Squid option: cache_swap_low
       * high: Low swap percent.  Squid option: cache_swap_high

#### Example:

Example config allowing the 10/8 and 192.168/16 RFC1918 ranges while explicitly denying 10.0.7/24.
512MB of mem cache and 14G of disk cache enabled.

```
  class {'squid':
    squid_allowednets => [ "10.0.0.0/8", "192.168.0.0/16"],
    squid_bannednets  => [ "10.0.7.0/24" ],
    squid_cache       => {
      "mem_size"    => "512 MB",
      "mem_max_obj" => "16 MB",
      "disk"        => {
        "path"       => "/mnt/squidCache/squid3",
        "size"       => 14745,
        "L1"         => 128,
        "L2"         => 256,
        "max_obj"    => "4096 MB",
        "cache_swap" => {
          "low"  => 94,
          "high" => 95,
        },
      },
    },
    squid_disable_forwarded_for => true,
  }
```
