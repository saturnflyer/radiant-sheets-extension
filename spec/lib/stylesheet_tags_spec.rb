# require 'spec_helper'
require File.dirname(__FILE__) + '/../spec_helper'

describe "Stylesheet Tags" do
  dataset :stylesheets

  let(:page){ pages(:home) }

  describe "<r:stylesheet>" do
    let(:stylesheet_page){ StylesheetPage.find_by_slug('site.css')}
    subject { page }
    it { should render(%{<r:stylesheet />}).with_error("`stylesheet' tag must contain a `slug' attribute.") }
    it { should render(%{<r:stylesheet slug="bogus" />}).with_error("stylesheet not found") }
    it { should render(%{<r:stylesheet slug="site.css" />}).as("site.css body.") }
    it { should render(%{<r:stylesheet slug="site.css" as="url" />}).as("/css/site.css?#{stylesheet_page.updated_at.to_i}") }
    it { should render(%{<r:stylesheet slug="site.css" as="link" />}).as(%{<link rel="stylesheet" type="text/css" href="/css/site.css?#{stylesheet_page.updated_at.to_i.to_s}" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="link" type="special/type" />}).as(%{<link rel="stylesheet" type="special/type" href="/css/site.css?#{stylesheet_page.updated_at.to_i.to_s}" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="link" something="custom" />}).as(%{<link rel="stylesheet" type="text/css" href="/css/site.css?#{stylesheet_page.updated_at.to_i.to_s}" something="custom" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="link" rel="alternate" />}).as(%{<link rel="alternate" type="text/css" href="/css/site.css?#{stylesheet_page.updated_at.to_i.to_s}" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="inline" />}).as(%{<style type="text/css">
/*<![CDATA[*/
site.css body.
/*]]>*/
</style>}) }
    it { should render(%{<r:stylesheet slug="site.css" as="inline" type="special/type" />}).as(%{<style type="special/type">
/*<![CDATA[*/
site.css body.
/*]]>*/
</style>}) }
    it { should render(%{<r:stylesheet slug="site.css" as="inline" something="custom" />}).as(%{<style type="text/css" something="custom">
/*<![CDATA[*/
site.css body.
/*]]>*/
</style>}) }
  end

end