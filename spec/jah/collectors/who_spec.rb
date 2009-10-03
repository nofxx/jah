require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Who do


  before do
    Who.should_receive(:"`").with("who").and_return(WHO)
  end

  it "should return users" do
    Who.all[0][:who].should eql("nofxx")
  end




WHO = <<WHO
nofxx    tty1         2009-10-03 17:17
nofxx    pts/0        2009-10-03 17:17 (:0.0)
nofxx    pts/1        2009-10-03 18:58 (:0.0)
nofxx    pts/2        2009-10-03 18:21 (:0.0)
WHO

end
