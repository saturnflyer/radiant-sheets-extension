require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  its(:sheet?){should be_false}
end
