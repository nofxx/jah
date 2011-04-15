require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/pacman"

describe Pacman do

  before do
    @pac ||= Pacman.new
  end

  describe "Searching" do
    before do
      @pac.should_receive(:"`").with("pacman -Ss ruby").and_return(SS)
      @pac.should_receive(:"`").with("pacman -Q").and_return(QL)
      @pkgs = @pac.search("ruby")
    end

    it "should find pkgs" do
      first = @pkgs[0]
      first.name.should eql("ruby")
      first.desc.should eql("An object-oriented language for quick and easy programming")
    end

    it "should work nicely" do
      @pkgs[1].name.should eql("ruby-docs")
      @pkgs[1].desc.should eql("Documentation files for ruby")
    end

    it "should have ruby" do
      @pkgs[0].should be_installed
    end

    it "should not be installed" do
      @pkgs[1].should_not be_installed
    end

    it "should install if I want" do
      Pacman.should_receive(:new).and_return(@pac)
      @pac.should_receive(:"`").with("pacman -Sy --noconfirm ruby")
      @pkgs[0].install
    end

  end

  it "should install stuff" do
    @pac.should_receive(:"`").with("pacman -Sy --noconfirm foo")
    @pac.install mock(Pkg, :name => "foo")
  end

  it "should list pkgs" do
    @pac.should_receive(:"`").with("pacman -Q").and_return(QL)
    @pac.all.first.should be_instance_of(Pkg)
  end


  describe "List" do

    before do
      @pac.stub!(:"`").and_return(QL)
      @pkgs = @pac.all
      @ruby = @pkgs[11]
    end

    it "should have name" do
      @pkgs[0].name.should eql("a2ps")
    end

    it "should have version" do
      @pkgs[0].version.should eql("4.14-1")
    end

    it "should fetch info about a pkg" do
      @ruby.info.should be_instance_of Hash #("http://www.ruby-lang.org/en/")
    end

    it "should fetch url" do
      @ruby.url.should eql("http://www.ruby-lang.org/en/")
    end

    it "should fetch arch" do
      @ruby.arch.should eql("x86_64")
    end

    it "should fetch desc" do
      @ruby.desc.should eql("An object-oriented language for quick and easy programming")
    end

    it "should fetch license" do
      @ruby.license.should eql("custom")
    end

  end

SS = <<SS
extra/ruby 1.8.7_p174-1 [4.67 MB]
    An object-oriented language for quick and easy programming
extra/ruby-docs 1.8.7_p174-1 [0.87 MB]
    Documentation files for ruby
SS

QL = <<QL
a2ps 4.14-1
a52dec 0.7.4-4
acl 2.2.47-2
alsa-lib 1.0.21.a-1
ca-certificates 20090709-1
couchdb-svn 784601-1
emacs-cvs 20090730-1
emacs-magit-git 20090811-1
flashplugin 10.0.32.18-1.1
hal-info 0.20090716-2
libmad 0.15.1b-4
ruby 1.8.7_p174-1
xz-utils 4.999.9beta-1
QL

QI = <<QI
Name           : ruby
Version        : 1.9.2_p180-1
URL            : http://www.ruby-lang.org/en/
Licenses       : custom
Groups         : None
Provides       : rubygems  rake
Depends On     : gdbm  db  openssl  zlib  readline  libffi
Optional Deps  : tk: for Ruby/TK
Required By    : None
Conflicts With : rubygems  rake
Replaces       : None
Installed Size : 18848.00 K
Packager       : Eric Belanger <eric@archlinux.org>
Architecture   : x86_64
Build Date     : Sat 19 Feb 2011 04:27:10 AM BRST
Install Date   : Tue 29 Mar 2011 01:38:06 AM BRT
Install Reason : Explicitly installed
Install Script : No
Description    : An object-oriented language for quick and easy programming
QI


end
