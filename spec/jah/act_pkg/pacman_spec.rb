require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/pacman"

describe Pacman do

  before do
    @pac ||= Pacman.new
  end

  it "should install stuff" do
    @pac.should_receive(:"`").with("pacman -S foo")
    @pac.install "foo"
  end



end
