require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Mem do

  describe "Read All" do
    before do
      Mem.should_receive(:`).with("cat /proc/meminfo").and_return(MEMINFO) #`
    end

    it "should get free mem" do
      Mem.free.should eql(4194)
    end

    it "should get free mem" do
      Mem.used.should eql(3790)
    end

    it "should get free percentage" do
      Mem.percent.should eql(52)
    end
  end

MEMINFO = <<MEMINFO
MemTotal:        8175844 kB
MemFree:          201264 kB
Buffers:          126684 kB
Cached:          3967476 kB
SwapCached:         7704 kB
Active:          5993204 kB
Inactive:        1731788 kB
Active(anon):    3077496 kB
Inactive(anon):   579456 kB
Active(file):    2915708 kB
Inactive(file):  1152332 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       7815580 kB
SwapFree:        7766252 kB
Dirty:               640 kB
Writeback:             0 kB
AnonPages:       3623964 kB
Mapped:            39020 kB
Slab:             208776 kB
SReclaimable:     195744 kB
SUnreclaim:        13032 kB
PageTables:        17348 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    11903500 kB
Committed_AS:    4057620 kB
VmallocTotal:   34348367 kB
VmallocUsed:      269584 kB
VmallocChunk:   34357495 kB
DirectMap4k:        3584 kB
DirectMap2M:     8384512 kB
MEMINFO

end
