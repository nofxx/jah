require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/port"

describe Port do





LI = <<LI
autoconf                       @2.64           devel/autoconf
automake                       @1.11           devel/automake
bzip2                          @1.0.5          archivers/bzip2
cairo                          @1.8.8          graphics/cairo
cmake                          @2.6.4          devel/cmake
curl                           @7.19.6         net/curl
db46                           @4.6.21         databases/db46
expat                          @2.0.1          textproc/expat
libid3tag                      @0.15.1b        audio/libid3tag
openssl                        @0.9.8k         devel/openssl
p5-error                       @0.17015        perl/p5-error
LI

SEARCH = <<SEARCH
awesome @3.3.4 (x11, x11-wm)
    awesome is a tiling window manager

rancid @2.3.2a9 (net)
    Really Awesome New Cisco confIg Differ

Found 2 ports.

SEARCH

end

