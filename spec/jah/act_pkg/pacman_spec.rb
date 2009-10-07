require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/pacman"

describe Pacman do

  before do
    @pac ||= Pacman.new
  end

  it "should install stuff" do
    @pac.should_receive(:"`").with("pacman -Sy --noconfirm foo")
    @pac.install mock(Pkg, :name => "foo")
  end

  it "should list pkgs" do
    @pac.should_receive(:"`").with("pacman -Q ").and_return(QL)
    @pac.all.first.should be_instance_of(Pkg)
  end

SS = <<SS
extra/ruby 1.9.1_p243-2 [4.67 MB]
    An object-oriented language for quick and easy programming
extra/ruby-docs 1.9.1_p243-2 [0.87 MB]
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
xz-utils 4.999.9beta-1
QL

end
