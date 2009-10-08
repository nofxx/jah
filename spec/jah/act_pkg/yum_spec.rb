require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/yum"

describe Yum do

  before do
    @yum ||= Yum.new
  end

  describe "All" do
    before do
      @yum.stub!(:"`").and_return(YUMLIST)
      @pkgs ||= @yum.all
    end

    it "should fetch name" do
      @pkgs[0].name.should eql("db4")
    end

    it "should fetch version" do
      @pkgs[0].version.should eql("4.3.29-9.fc6")
    end

  end





YUMLIST = <<YUMLIST
Installed Packages
db4.i386                                 4.3.29-9.fc6           installed
dbus.i386                                1.0.0-7.el5            installed
dbus-devel.i386                          1.0.0-7.el5            installed
desktop-file-utils.i386                  0.10-7                 installed
YUMLIST

YUMINFO = <<YUMINFO
Available Packages
Name   : ruby
Arch   : i386
Version: 1.8.5
Release: 5.el5_3.7
Size   : 274 k
Repo   : updates
Summary: An interpreter of object-oriented scripting language
Description:
Ruby is the interpreted scripting language for quick and easy
object-oriented programming.  It has many features to process text
files and to do system management tasks (as in Perl).  It is simple,
straight-forward, and extensible.

YUMINFO

end
