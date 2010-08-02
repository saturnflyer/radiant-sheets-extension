require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  describe '#sheet?' do
    it "should return false" do
      Page.new.sheet?.should be_false
    end
  end
end
