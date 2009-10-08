require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe History do

  before do
    Time.stub!(:now).and_return("NOW")
  end

  it "should record history" do
    History.set("nofxx", "test")
    History.all[0].should eql(["nofxx", "test", "NOW"])
  end

  it "should get last one " do
    History.last.should eql(["nofxx", "test", "NOW"])
  end

  it "should find all" do
    History.set("nofxx", "jah")
    History.all.should eql([["nofxx", "test", "NOW"], ["nofxx", "jah", "NOW"]])
  end

  it "should filter by user" do
    History.set("foo", "test")
    History.all("foo").should eql([["foo", "test", "NOW"]])
  end

  it "should clear it" do
    History.clear
    History.should be_empty
  end



end
