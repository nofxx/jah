require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/apt"

describe Apt do











AP = <<APT
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Cfg-files/Unpacked/Failed-cfg/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Hold/Reinst-required/X=both-problems (Status,Err: uppercase=bad)
||/ Name                                                          Version                                   Description
+++-=============================================================-=========================================-=======================================================
ii  ack-grep                                                      1.80-1                                    A grep-like program specifically for large source trees
ii  acl                                                           2.2.47-2                                  Access control list utilities
ii  acpi-support                                                  0.121                                     scripts for handling many ACPI events
ii  acpid                                                         1.0.6-9ubuntu4.9.04.3                     Utilities for using ACPI power management
ii  adduser                                                       3.110ubuntu5                              add and remove users and groups
ii  adobe-certs                                                   1.5.8870                                  Certificates distributed by Adobe Systems.
ii  adobe-flashplugin                                             10.0.32.18-1jaunty1                       Adobe Flash Player plugin version 10
ii  adobeair1.0                                                   1.5.2.8870                                Adobe AIR
ii  alacarte                                                      0.11.10-0ubuntu1                          easy GNOME menu editing tool
ii  alien                                                         8.73                                      convert and install rpm and other packages
ii  alsa-base                                                     1.0.18.dfsg-1ubuntu8                      ALSA driver configuration files
ii  alsa-utils                                                    1.0.18-1ubuntu11                          ALSA utilities
ii  amarok                                                        2:2.0.2mysql5.1.30-0ubuntu3               easy to use media player based on the KDE 4 technology
ii  amarok-common                                                 2:2.0.2mysql5.1.30-0ubuntu3
ii  bind9-host                                                    1:9.5.1.dfsg.P2-1ubuntu0.1
APT


end
