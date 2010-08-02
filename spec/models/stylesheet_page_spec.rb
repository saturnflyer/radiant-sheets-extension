require File.dirname(__FILE__) + '/../spec_helper'

describe StylesheetPage do
  dataset :stylesheets
  let(:stylesheet){ pages(:css) }
  let(:site_css){ StylesheetPage.find_by_slug('site.css') }
  
  subject{ stylesheet }
  its(:cache?) { should be_true }
  its(:sheet?) { should be_true }
  its(:virtual?) { should be_true }
  its(:layout) { should be_nil }
  
  describe '.root' do
    subject{ StylesheetPage }
    its(:root) { should == stylesheet }
  end
  
  describe '.new_with_defaults' do
    describe '#parts' do
      let(:parts){ StylesheetPage.new_with_defaults.parts }
      subject{ parts }
      its(:length) { should == 1 }
      it "should have a body part" do
        parts[0].name.should == 'body'
      end
    end
  end
  
  describe '#headers' do
    it "should have a 'Content-Type' of 'text/css'" do
      stylesheet.headers['Content-Type'].should == 'text/css'
    end
  end
  
  describe '#find_by_url' do
    context 'with a valid url' do
      it 'should return the child found by the given slug' do
        stylesheet.find_by_url('/css/site.css').should == site_css
      end
    end
  end
  
  context 'when validating a new page' do
    it "should automatically set the title to the given slug" do
      j = StylesheetPage.new(:slug => 'site.css')
      j.valid?
      j.title.should == 'site.css'
    end
    it "should automatically set the breadcrumb to the given slug" do
      j = StylesheetPage.new(:slug => 'site.css')
      j.valid?
      j.breadcrumb.should == 'site.css'
    end
  end
end
