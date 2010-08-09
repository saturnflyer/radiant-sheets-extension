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
  
  context 'when saving a new page' do
    subject { s = StylesheetPage.new_with_defaults
        s.slug = 'test.css'
        s.save!
        s }
    its(:status){ should == Status[:published] }
    its(:status_id){ should == Status[:published].id }
    
    its(:published_at){ should_not be_nil }
    it "should have a published_at greater than or equal to the current time" do
      subject.published_at.to_i.should <= Time.zone.now.to_i
    end
    
    context 'with the default page status set to draft' do
      it 'should save a new page with a published status' do
        Radiant::Config['defaults.page.status'] = 'draft'
        new_sheet = StylesheetPage.new_with_defaults
        new_sheet.slug = 'published.css'
        new_sheet.save!
        new_sheet.status.should == Status[:published]
      end
    end
  end
end
