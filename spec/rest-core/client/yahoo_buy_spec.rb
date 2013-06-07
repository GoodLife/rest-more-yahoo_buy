require 'rest-core/client/yahoo_buy'

describe RestCore::YahooBuy::Client do
  describe '.get_level_no' do
    it 'returns level no as is' do
      (0..4).each do |i|
        described_class.get_level_no(i).should == i
      end
    end
    it 'returns nil if privided level is a number but not a valid level_no' do
      described_class.get_level_no(-1).should == nil
      described_class.get_level_no(5).should == nil
    end
    it 'returns level if name is passed' do
      described_class.get_level_no('').should == 0
      described_class.get_level_no('z').should == 1
      described_class.get_level_no('sub').should == 2
      described_class.get_level_no('catid').should == 3
      described_class.get_level_no('catitemid').should == 4
    end
    it 'returns nil if name passed is invalid' do
      described_class.get_level_no('other').should == nil
    end
  end
end
