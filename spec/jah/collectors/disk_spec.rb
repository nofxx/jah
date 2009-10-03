require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Disk do
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Disk do

  before do
    Disk.should_receive(:"`").with("df").and_return(DISK)
  end

  it "should read" do
    Disk.all[0].should be_instance_of(Disk) #eql({:free=>"25191840", :used=>"7033476", :total=>"32225316", :percent=>"22%", :path=>"/dev/sda5"})
  end

  describe "A Partition" do
    before do
      @disk = Disk.all.first
    end

    it "should find free" do
      @disk.free.should eql(25191840)
    end

    it "should find percent used" do
      @disk.percent.should eql(22)
    end

    it "should find dev" do
      @disk.path.should eql("/dev/sda5")
    end

    it "should find mountpoint" do
      @disk.mount.should eql("/")
    end

  end



DISK = <<DFLH
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda5             32225316   7033476  25191840  22% /
none                   1037004       192   1036812   1% /dev
none                   1037004         0   1037004   0% /dev/shm
/dev/sda1            242216196 210412036  19597172  92% /mnt/disk
/dev/sda3             78121640  17208224  60913416  23% /home
DFLH


end
