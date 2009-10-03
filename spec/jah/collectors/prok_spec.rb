require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Prok do

  before dod
    Prok.stub!("`".to_sym).and_return(PSAUX) #```
  end

  it "should find all" do
    Prok.all.should be_instance_of Array
  end

  it "should be a intance of Prok" do
    Prok.all[0].should be_instance_of Prok
  end

  it "should a proc by pid" do
    Prok.find("3537").first.comm.should eql("ruby bin/jah")
  end

  it "should return [] if no proc found" do
    Prok.find("8888").should be_empty
  end

  it "should find by name" do
    Prok.find("jah")[0].pid.should eql 3537
  end

  it "should return [] if no comm found" do
    Prok.find("nothere").should be_empty
  end

  describe "A Prok" do
    before do
      @prok ||= Prok.all[0]
    end

    it "should get the command name" do
      @prok.comm.should eql("ini")
    end

    it "should set the user" do
      @prok.user.should eql("root")
    end

    it "should set the PID as integer" do
      @prok.pid.should eql(1)
    end

    it "should get cpu percentage" do
      @prok.cpu.should be_close(0.0, 0.01)
    end

    it "should get mem percentage" do
      @prok.mem.should be_close(0.0, 0.01)
    end

    it "should get the v size" do
      @prok.vsz.should eql(1684)
    end

    it "should get the rss size" do
      @prok.rss.should eql(480)
    end

    it "should get the TTY" do
      @prok.tty.should eql("?")
    end

    it "should get STAT" do
      @prok.stat.should eql("Ss")
    end

    it "should get TIME" do
      @prok.time.should eql("0:05")
    end

    it "should send a HUP" do
      @prok.should_receive(:exec).with("kill -1 1")
      @prok.hup!
    end

    it "should send a SIGTERM" do
      @prok.should_receive(:exec).with("kill 1")
      @prok.kill!
    end

    it "should send a KILL -9" do
      @prok.should_receive(:exec).with("kill -9 1")
      @prok.move_to_acre!
    end

  end

  it "should genocide!" do
    Prok.stub!(:new).and_return(@prok = mock(Prok))
    @prok.should_receive(:comm).and_return("bin/jah")
    @prok.stub!(:comm)
    @prok.should_receive(:kill!)
    Prok.genocide!("jah")
  end


PSAUX = <<PSAUX
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   1684   480 ?        Ss   Sep20   0:05 ini
root         2  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   Sep20   0:00 [migration/0]
root         4  0.0  0.0      0     0 ?        S<   Sep20   0:08 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<   Sep20   0:00 [watchdog/0]
root         6  0.0  0.0      0     0 ?        S<   Sep20   0:00 [migration/1]
root         7  0.0  0.0      0     0 ?        S<   Sep20   5:39 [ksoftirqd/1]
root         8  0.0  0.0      0     0 ?        S<   Sep20   0:00 [watchdog/1]
root         9  0.0  0.0      0     0 ?        S<   Sep20   0:16 [events/0]
root        10  0.0  0.0      0     0 ?        S<   Sep20   0:16 [events/1]
root        11  0.0  0.0      0     0 ?        S<   Sep20   0:00 [khelper]
root        12  0.0  0.0      0     0 ?        S<   Sep20   0:00 [async/mgr]
root        13  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kblockd/0]
root        14  0.0  0.0      0     0 ?        S<   Sep20   0:05 [kblockd/1]
root        15  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kacpid]
root        16  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kacpi_notify]
root        17  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kseriod]
root        18  0.0  0.0      0     0 ?        S    Sep20   0:03 [khungtaskd]
root        19  0.0  0.0      0     0 ?        S    Sep20   0:12 [pdflush]
root        21  0.0  0.0      0     0 ?        S<   Sep20   0:09 [kswapd0]
root        22  0.0  0.0      0     0 ?        S<   Sep20   0:00 [aio/0]
root        23  0.0  0.0      0     0 ?        S<   Sep20   0:00 [aio/1]
root        24  0.0  0.0      0     0 ?        S<   Sep20   0:00 [crypto/0]
root        25  0.0  0.0      0     0 ?        S<   Sep20   0:00 [crypto/1]
root       446  0.0  0.0      0     0 ?        S<   Sep20   0:00 [ata/0]
root       448  0.0  0.0      0     0 ?        S<   Sep20   0:00 [ata/1]
root       449  0.0  0.0      0     0 ?        S<   Sep20   0:00 [ata_aux]
root       450  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_0]
root       451  0.0  0.0      0     0 ?        S<   Sep20   0:04 [scsi_eh_1]
root       452  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_2]
root       455  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_3]
root       456  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_4]
root       457  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_5]
root       458  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_6]
root       461  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_7]
root       469  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_8]
root       470  0.0  0.0      0     0 ?        S<   Sep20   0:00 [scsi_eh_9]
root       562  0.0  0.0      0     0 ?        S<   Sep20   0:00 [reiserfs/0]
root       563  0.0  0.0      0     0 ?        S<   Sep20   0:00 [reiserfs/1]
root       588  0.0  0.0   1956   376 ?        S<s  Sep20   0:00 /sbin/udevd --daemon
root       836  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kpsmoused]
root       842  0.0  0.0      0     0 ?        S<   Sep20   0:00 [ksuspend_usbd]
root       843  0.0  0.0      0     0 ?        S<   Sep20   0:00 [khubd]
root       913  0.0  0.0      0     0 ?        S<   Sep20   0:00 [hd-audio0]
root       951  0.0  0.0      0     0 ?        S<   Sep20   0:00 [usbhid_resumer]
root      1129  0.0  0.0      0     0 ?        S<   Sep20   0:00 [kjournald]
root      1265  0.0  0.0   4700   192 ?        S    Sep20   0:00 supervising syslog-ng
root      1266  0.0  0.0   4880   868 ?        Ss   Sep20   0:00 /usr/sbin/syslog-ng
root      1276  0.0  0.0   2380   544 tty1     Ss   Sep20   0:00 /bin/login --
root      1277  0.0  0.0   1684   440 tty2     Ss+  Sep20   0:00 /sbin/agetty -8 38400 tty2 linux
root      1278  0.0  0.0   1684   440 tty3     Ss+  Sep20   0:00 /sbin/agetty -8 38400 tty3 linux
root      1279  0.0  0.0   1684   440 tty4     Ss+  Sep20   0:00 /sbin/agetty -8 38400 tty4 linux
root      1280  0.0  0.0   1684   440 tty5     Ss+  Sep20   0:00 /sbin/agetty -8 38400 tty5 linux
root      1281  0.0  0.0   1684   440 tty6     Ss+  Sep20   0:00 /sbin/agetty -8 38400 tty6 linux
nofxx     1292  0.0  1.9  95628 40664 ?        S    Sep28   3:32 terminal
nofxx     1293  0.0  0.0   1728   560 ?        S    Sep28   0:00 gnome-pty-helper
root      1313  0.0  0.0   1720   548 ?        S    Sep20   0:00 /usr/sbin/crond
root      1342  0.0  0.0   1864   244 ?        S    Sep20   0:03 /usr/lib/erlang/erts-5.7.1/bin/epmd -daemon
root      1344  0.0  0.0   2052   420 ?        Ss   Sep20   0:00 /usr/bin/rpcbind
nofxx     1348  0.0  0.0   4176  1456 ?        Ss   Sep20   4:52 /usr/sbin/famd -T 0 -c /etc/fam/fam.conf
dbus      1351  0.0  0.0   2384   868 ?        Ss   Sep20   0:00 /usr/bin/dbus-daemon --system
hal       1364  0.0  0.0   6028  1472 ?        Ss   Sep20   0:04 /usr/sbin/hald
root      1404  0.0  0.0   7856   852 ?        Sl   Sep20   0:00 PassengerNginxHelperServer /usr/lib/ruby/gems/1.8/gems/passenger-2.2.4 /usr/bin/ruby 3 4 0 6 0 300 1 nobody 1000 100 /tmp/passenger.1385
root      1413  0.0  0.1  23616  3032 ?        Sl   Sep20   3:11 Passenger spawn server
root      1416  0.0  0.0   4160   172 ?        Ss   Sep20   0:00 nginx: master process /opt/nginx/sbin/nginx -c /opt/nginx/conf/nginx.conf
nofxx     1417  0.0  0.0   4648   744 ?        S    Sep20   0:00 nginx: worker process
root      1443  0.0  0.0   9028   980 ?        Ssl  Sep20   0:00 /usr/sbin/console-kit-daemon
root      1444  0.0  0.0   3296   556 ?        S    Sep20   0:00 hald-runner
root      1540  0.0  0.0   3228   588 ?        S    Sep20   1:19 hald-addon-input: Listening on /dev/input/event7 /dev/input/event2 /dev/input/event1 /dev/input/event8
nofxx     1583  0.0  0.0   9452  1072 pts/2    Ss   Sep28   0:00 bash
hal       1584  0.0  0.0   2924   460 ?        S    Sep20   0:00 hald-addon-acpi: listening on acpi kernel interface /proc/acpi/event
root      1585  0.0  0.0   3232   556 ?        S    Sep20   0:06 hald-addon-storage: polling /dev/sr0 (every 16 sec)
root      1657  0.0  0.0   1872   248 ?        Ss   Sep20   0:00 /sbin/dhcpcd -q eth0
nofxx     1660  0.0  0.0   9420   732 tty1     S    Sep20   0:00 -bash
nofxx     2468  0.0  0.0   6228   708 tty1     S+   Sep20   0:00 /bin/sh /usr/bin/startx
nofxx     2484  0.0  0.0   2956   492 tty1     S+   Sep20   0:00 xinit /home/nofxx/.xinitrc -- /etc/X11/xinit/xserverrc :0 -auth /home/nofxx/.serverauth.2468
root      2485  0.6 15.2 872568 316392 tty7    S<s+ Sep20 120:31 /usr/bin/X -nolisten tcp
nofxx     2492  0.0  0.0   5980   708 tty1     S    Sep20   0:00 /bin/sh /etc/xdg/xfce4/xinitrc -- /etc/X11/xinit/xserverrc
nofxx     2501  0.0  0.0   5752   336 ?        Ss   Sep20   0:00 /usr/bin/ssh-agent -s
nofxx     2506  0.0  0.0   3156   348 tty1     S    Sep20   0:02 /usr/bin/dbus-launch --sh-syntax --exit-with-session
nofxx     2507  0.0  0.0   2272   900 ?        Ss   Sep20   0:30 /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
nofxx     2509  0.0  0.1  18864  3060 tty1     S    Sep20   0:39 /usr/bin/xfce4-session
nofxx     2511  0.0  0.0   3312   820 ?        S    Sep20   0:00 /usr/lib/xfconfd
nofxx     2515  0.0  0.0  15444  1364 tty1     S    Sep20   0:00 xfsettingsd
nofxx     2516  0.0  0.7  69088 15192 tty1     Sl   Sep20   0:26 xfdesktop --sm-client-id 2fe03b273-585f-4a64-8b6e-a2d8b82b094f --display :0.0
nofxx     2518  0.0  0.1  20064  2752 tty1     S    Sep20   0:36 xfce4-settings-helper --display :0.0 --sm-client-id 2720f3d6c-875a-4bf8-b46b-c4afdc31650a
nofxx     2519  0.0  0.0  15888  1976 tty1     S    Sep20   0:00 xfce4-panel
nofxx     2532  0.0  0.8  85832 16816 ?        Sl   Sep20   1:13 /usr/bin/Thunar --daemon
nofxx     2556  1.0  4.7 178944 97604 tty1     Sl   Sep20 199:51 skype -session 2d64394f0-cf8b-4e9f-8ab5-f1755485c_4299_196609
nofxx     2559  0.0  0.5  47116 11928 tty1     Sl   Sep20   0:02 /usr/lib/xfce4/panel-plugins/xfce4-mixer-plugin socket_id 16777248 name xfce4-mixer-plugin id 12476125132 display_name Mixer size 16 screen_position 7
nofxx     2575  0.2  0.3  21104  7900 ?        Ss   Sep20  44:53 awesome
nofxx     2787  0.0  0.6  14404 13076 pts/7    S    13:18   0:00 ruby /usr/bin/autospec
nofxx     2794  0.2  0.6  15480 14096 pts/7    S    13:18   0:00 /usr/bin/ruby -ws /usr/bin/autotest
nofxx     2912  0.0  0.0   7304  1264 pts/2    S+   Sep29   0:05 ssh naomi
nofxx     3226  0.0  0.0   5296  1040 pts/12   R+   13:25   0:00 ps auxww
nofxx     3285  0.0  0.0   9620  1072 pts/3    Ss   Sep28   0:00 bash
nofxx     3389  0.0  0.0   6728   904 pts/3    S+   Sep30   0:03 ssh naomi
nofxx     3537  0.9  1.0  25828 21532 pts/7    S+   13:30   0:00 ruby bin/jah
nofxx     3932  0.0  0.2   9836  4304 pts/9    Ss+  Sep30   0:00 bash
nofxx     4108  0.0  0.0  46732  1908 ?        Sl   Sep20   0:09 /usr/lib/erlang/erts-5.7.1/bin/beam.smp -- -root /usr/lib/erlang -progname erl -- -home /home/nofxx -W -pa spec -sname spec -s spec_server
nofxx     4403  4.0 13.4 392108 278704 ?       SLl  Sep29 241:50 python /usr/lib/exaile/exaile.py --datadir=/usr/share/exaile/data --startgui
nofxx     5426  0.0  0.2   9640  4616 pts/7    Ss+  Sep28   0:01 bash
couchdb  10908  0.0  0.0   6232   708 ?        S    Sep26   0:00 /bin/sh -e /usr/bin/couchdb -a \"/etc/couchdb/default.ini\" -a \"/etc/couchdb/local.ini\" -b -r 5 -p /var/run/couchdb/couchdb.pid -o /dev/null -e /dev/null -R
couchdb  10931  0.0  0.0   6232   148 ?        S    Sep26   0:00 /bin/sh -e /usr/bin/couchdb -a \"/etc/couchdb/default.ini\" -a \"/etc/couchdb/local.ini\" -b -r 5 -p /var/run/couchdb/couchdb.pid -o /dev/null -e /dev/null -R
couchdb  10932  0.0  0.1  67548  2484 ?        Sl   Sep26   6:14 /usr/lib/erlang/erts-5.7.1/bin/beam.smp -Bd -K true -- -root /usr/lib/erlang -progname erl -- -home /var/lib/couchdb -noshell -noinput -smp auto -sasl errlog_type error -pa /usr/lib/couchdb/erlang/lib/couch-0.10.0a784601/ebin /usr/lib/couchdb/erlang/lib/mochiweb-r97/ebin /usr/lib/couchdb/erlang/lib/ibrowse-1.4.1/ebin -eval application:load(ibrowse) -eval application:load(crypto) -eval application:load(couch) -eval crypto:start() -eval ibrowse:start() -eval couch_server:start([ "/etc/couchdb/default.ini", "/etc/couchdb/local.ini", "/etc/couchdb/default.ini", "/etc/couchdb/local.ini"]), receive done -> done end. -pidfile /var/run/couchdb/couchdb.pid -heart
couchdb  10941  0.0  0.0   1532   380 ?        Ss   Sep26   0:00 heart -pid 10932 -ht 11
nofxx    12033  0.0  0.0   9452  1072 pts/8    Ss   Sep28   0:00 bash
nofxx    12091  0.0  0.0   6180   840 pts/8    S+   Sep28   0:05 ssh naomi
root     12913  0.1  0.1  47768  3972 ?        Ssl  Sep22  19:38 /usr/lib/erlang/erts-5.7.1/bin/beam.smp -W w -K true -A30 -- -root /usr/lib/erlang -progname erl -- -home /home/nofxx -pa /usr/bin/../ebin -noshell -noinput -s rabbit -sname rabbit -boot start_sasl -kernel inet_default_listen_options [{nodelay,true},{sndbuf,16384},{recbuf,4096}] -kernel inet_default_connect_options [{nodelay,true}] -rabbit tcp_listeners [{"0.0.0.0", 5672}] -sasl errlog_type error -kernel error_logger {file,"/var/log/rabbitmq/rabbit.log"} -sasl sasl_error_logger {file,"/var/log/rabbitmq/rabbit-sasl.log"} -os_mon start_cpu_sup true -os_mon start_disksup false -os_mon start_memsup false -os_mon start_os_sup false -os_mon memsup_system_only true -os_mon system_memory_high_watermark 0.95 -mnesia dir "/var/lib/rabbitmq/mnesia/rabbit" -noshell -noinput
root     12962  0.0  0.0   1660   284 ?        Ss   Sep22   0:00 /usr/lib/erlang/lib/os_mon-2.2.1/priv/bin/cpu_sup
root     12963  0.0  0.0   1860   320 ?        Ss   Sep22   0:00 inet_gethost 4
root     12964  0.0  0.0   1908   352 ?        S    Sep22   0:00 inet_gethost 4
nofxx    14054  0.1  1.7  73168 35972 ?        S    Sep30   6:19 pidgin
root     15009  0.0  0.0   6192   404 ?        Ss   Sep30   0:00 /usr/sbin/sshd
nofxx    16716  0.0  0.0   9452  1072 pts/1    Ss   Sep28   0:00 bash
nofxx    16730  0.0  0.0   6536   828 pts/1    S+   Sep28   0:00 ssh naomi
nofxx    20500  0.0  0.2  57484  4712 ?        S    Sep26   1:09 /usr/bin/ruby /usr/bin/gembox
nofxx    23756  3.8 15.8 841728 329360 ?       Sl   Oct02  35:45 firefox
nofxx    23758  0.0  0.1   7556  2716 ?        S    Oct02   0:01 /usr/lib/GConf/gconfd-2
root     25145  0.0  0.0      0     0 ?        S    Oct02   0:00 [pdflush]
nofxx    25594  0.0  0.2   9456  4860 pts/6    Ss   Oct02   0:00 bash
nofxx    25597  0.0  0.2   9456  5036 pts/10   Ss+  Oct02   0:00 bash
nofxx    25631  0.0  0.0   6152  1480 pts/6    S+   Oct02   0:00 ssh tor
nofxx    26342  0.0  0.2   9456  4600 pts/11   Ss   Oct01   0:00 bash
postgres 31170  0.0  0.0  44096  1308 ?        S    Oct01   0:01 /usr/bin/postgres -D /var/lib/postgres/data
postgres 31179  0.0  0.2  44504  5336 ?        Ss   Oct01   0:06 postgres: writer process
postgres 31180  0.0  0.0  44096   592 ?        Ss   Oct01   0:03 postgres: wal writer process
postgres 31181  0.0  0.0  44452   852 ?        Ss   Oct01   0:03 postgres: autovacuum launcher process
postgres 31182  0.0  0.0  12532   684 ?        Ss   Oct01   0:06 postgres: stats collector process
nofxx    31873  0.0  0.2   9456  5096 pts/12   Ss   12:00   0:00 bash
nofxx    32343  0.1  2.7  88540 58032 ?        S    Oct02   2:14 emacs
nofxx    32402  0.0  0.0   5972  1452 ?        S    12:11   0:00 /bin/sh /usr/bin/thunderbird
nofxx    32406  0.0  0.0   5972  1456 ?        S    12:11   0:00 /bin/sh /usr/lib/thunderbird-2.0/run-mozilla.sh /usr/lib/thunderbird-2.0/thunderbird-bin
nofxx    32411  0.0  2.3 129828 49672 ?        Sl   12:11   0:02 /usr/lib/thunderbird-2.0/thunderbird-bin
nofxx    32725  0.0  0.7  19432 14924 pts/11   S+   12:19   0:00 irb
PSAUX

end
