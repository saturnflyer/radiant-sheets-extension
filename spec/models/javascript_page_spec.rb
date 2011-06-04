require File.dirname(__FILE__) + '/../spec_helper'

describe JavascriptPage do
  dataset :javascripts
  let(:javascript){ pages(:js) }
  let(:site_js){ pages(:site_js) }
  
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
  
  describe '#find_by_path' do
    context 'with a valid url' do
      it 'should return the child found by the given slug' do
        javascript.find_by_path('/js/site.js').should == site_js
      end
    end
  end
  
  describe '#digest' do
    it 'should return an md5 hash of the rendered contents' do
      site_js.digest.should == Digest::MD5.hexdigest(site_js.render)
    end
  end
 
  describe '#path' do
    it 'should include an md5 hash of the rendered contents' do
      site_js.path.should == "/js/site.js?#{site_js.digest}"
    end
    it 'should not include an md5 hash of the rendered contents for the root' do
      javascript.path.should == "/js/"
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
  
  context 'when saving a new page' do
    subject { s = JavascriptPage.new_with_defaults
        s.slug = 'test.js'
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
        new_sheet = JavascriptPage.new_with_defaults
        new_sheet.slug = 'published.js'
        new_sheet.save!
        new_sheet.status.should == Status[:published]
      end
    end
  end
end
