# ![Jah](http://fireho.com/system/jahlogo.png)

Talk to/config your machines. Like a god.

## Install


    gem install jah


To create a config repo:

    jah new <path>


To create a config file for XMPP:

Just run it for the first time to create a config file.
Use `jah install` to force the wizard again.
Jah will try to find a `jah.yaml` file on ~/.jah or /etc.


## Support

* ArchLinux (tested)
* Mac OS X (tested)
* CentOS (tested)
* Debian (tested)
* BSD

Gems required for config mode:

* Capistrano


Gems required for XMPP mode:

* Blather
* EventMachine


## Modes

Jah has two modes you can use separately:

## Config


Jah new will create a tree like this:

     |- hosts.yml
     |- config
     |  |- deploy.rb
     |- example
     |  |- deploy.rb
     |  |- files/
     |  |- scripts/

THIS IS ALL SUBJECT TO BIG CHANGE! Some nice DSL coming soon hehe...

### hosts.yml

In hosts.yml, you inform all your servers and which profiles you want in them.


### config

Config deploy is just a "system wide" place for your custom tasks.


### profile

Example is a sample profile: Deploy works as you might expect,
you can define tasks and use capistrano syntax all along.



## Daemon

Notification/command dispatch via XMPP!



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
    naomi: I need you! NOW!


### System commands


## PubSub

Create a pubsub:

    pub create foo
    jah: Done.

Publish to it:

    foo: pubbin and dubbin from jah!
    jah: Published.

My pubs:

    pub mine
    jah: Pubsubs
    Owner: foo

All pubs:

    pub all
    jah: All Pubsubs
    => /foo
    => /bar

Subscribe to bar:

    pub sub bar
    jah: Done.


Unsubscribe to bar:

    pub unsub bar
    jah:Done.


Destroy a pub:

    pub destroy foo
    jah: Done.


## Use God?

### God commands

Start, stop, restart, monitor and unmonitor words on the beginning
of a phrase will make Jah add a "god" on the front of it, making it
trivial to work with your services:

    start nginx
    restart nanites
    unmonitor postgresql


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

Copyright (c) 2011 Marcos Piccinini. See LICENSE for details.
