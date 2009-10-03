require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Cpu do

  describe "Read All" do
    before do
      Cpu.should_receive(:`).with("uptime").and_return(" 20:10:57 up 12 days, 15:33,  8 users,  load average: 0.02, 0.08, 0.08\n")
    end

    it "should read one" do
      Cpu.should_receive(:`).with("cat /proc/cpuinfo | grep 'model name' | wc -l").and_return("2\n")
      Cpu.read[:one].should be_close(0.02, 0.01)
    end

    it "should read five minutes" do
      Cpu.read[:five].should be_close(0.08, 0.01)
    end


    it "should read five minutes" do
      Cpu.read[:ten].should be_close(0.08, 0.01)
    end

    it "should find the number of cores" do
      Cpu.read[:cores].should eql(2)
    end

    it "should calc the med" do
      Cpu.read[:med].should be_close(0.04, 0.01)
    end

    it "should have a method missing" do
      Cpu.one.should be_close(0.02, 0.01)
    end

  end

  describe "Direct" do

    it "should print load average" do
      Cpu.cores.should eql(2)
    end


  end
end
