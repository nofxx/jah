# ![Jah](http://fireho.com/system/jahlogo.png)

Talk to your machines. Like a god.

## Install

Just run it for the first time to create a config file.
Use `jah install` to force the wizard again.

Gems needed for XMPP mode:

* EventMachine (gem install eventmachine)
* Blather      (gem install blather)


Jah will try to find a `jah.yaml` file on ~/.jah or /etc.


## Modes

### XMPP

Chat with your server with your favorite XMPP client (pidgin, adium..)
Receive reports and failures realtime!
Send commands and


### POST

The old school way. Set up a Jah Web Server, and give Jah it`s address.
Jah will periodically post info. You can send commands through SSH.


### DUMP

AkA: Security freak. Jah just writes to tmp/ or whatever a dump file,
Jah Web securely connects (scp) and downloads the data to parse.


## Use God?


## XMPP Bot


Execute sh commands:

    pwd
    $> /home/jah


Executing ruby statements:

    ! 2 + 2
    => 4

    ! def foo; "hi"; end
    ! foo
    => "hi"


Execute Jah commands:

    cpu?
    msweet: 0.14, 0.25, 0.14

    mem?
    msweet: 53%

    net?
    7 connections
    [ips...]

    ok?
    [Personalized cool phrase...]


Group session:

    me: ok?
    msweet: I'm fine, thanks..
    ssaint: Kinda busy right now..
    naomi: I need you! Now!


Execute God statements:

Start, stop, restart, monitor and unmonitor words on the beginning
of a phrase will make Jah add a "god" on the front of it, making it
trivial to work with your services:


    start nginx
    restart nanites
    unmonitor postgresql


More to come...



## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Marcos Piccinini. See LICENSE for details.
