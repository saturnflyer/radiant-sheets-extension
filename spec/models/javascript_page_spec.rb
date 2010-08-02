require File.dirname(__FILE__) + '/../spec_helper'

describe JavascriptPage do
  dataset :javascripts
  let(:javascript){ pages(:js) }
  let(:site_js){ JavascriptPage.find_by_slug('site.js') }
  
  subject{ javascript }
  its(:cache?) { should be_true }
  its(:sheet?) { should be_true }
  its(:virtual?) { should be_true }
  its(:layout) { should be_nil }
  
  describe '.root' do
    subject{ JavascriptPage }
    its(:root) { should == javascript }
  end
  
  describe '.new_with_defaults' do
    describe '#parts' do
      let(:parts){ JavascriptPage.new_with_defaults.parts }
      subject{ parts }
      its(:length) { should == 1 }
      it "should have a body part" do
        parts[0].name.should == 'body'
      end
    end
  end
  
  describe '#headers' do
    it "should have a 'Content-Type' of 'text/javascript'" do
      javascript.headers['Content-Type'].should == 'text/javascript'
    end
  end
  
  describe '#find_by_url' do
    context 'with a valid url' do
      it 'should return the child found by the given slug' do
        javascript.find_by_url('/js/site.js').should == site_js
      end
    end
  end
  
  context 'when validating a new page' do
    it "should automatically set the title to the given slug" do
      j = JavascriptPage.new(:slug => 'site.js')
      j.valid?
      j.title.should == 'site.js'
    end
    it "should automatically set the breadcrumb to the given slug" do
      j = JavascriptPage.new(:slug => 'site.js')
      j.valid?
      j.breadcrumb.should == 'site.js'
    end
  end
end
