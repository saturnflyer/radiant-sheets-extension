# require 'spec_helper'
require File.dirname(__FILE__) + '/../spec_helper'

describe "Stylesheet Tags" do
  dataset :stylesheets

  let(:page){ pages(:home) }

  describe "<r:stylesheet>" do
    let(:site_css){pages(:site_css)}
    subject { page }
    it { should render(%{<r:stylesheet />}).with_error("`stylesheet' tag must contain a `slug' attribute.") }
    it { should render(%{<r:stylesheet slug="bogus" />}).with_error("stylesheet bogus not found") }
    it { should render(%{<r:stylesheet slug="site.css" />}).as("p { color: blue; }") }
    it { should render(%{<r:stylesheet slug="site.css" as="url" />}).as("/css/site.css?#{site_css.digest}") }
    it { should render(%{<r:stylesheet slug="site.css" as="link" />}).as(%{<link rel="stylesheet" type="text/css" href="/css/site.css?#{site_css.digest}" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="link" type="special/type" />}).as(%{<link rel="stylesheet" type="special/type" href="/css/site.css?#{site_css.digest}" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="link" something="custom" />}).as(%{<link rel="stylesheet" type="text/css" href="/css/site.css?#{site_css.digest}" something="custom" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="link" rel="alternate" />}).as(%{<link rel="alternate" type="text/css" href="/css/site.css?#{site_css.digest}" />}) }
    it { should render(%{<r:stylesheet slug="site.css" as="inline" />}).as(%{<style type="text/css">
/*<![CDATA[*/
p { color: blue; }
/*]]>*/
</style>}) }
    it { should render(%{<r:stylesheet slug="site.css" as="inline" type="special/type" />}).as(%{<style type="special/type">
/*<![CDATA[*/
p { color: blue; }
/*]]>*/
</style>}) }
    it { should render(%{<r:stylesheet slug="site.css" as="inline" something="custom" />}).as(%{<style type="text/css" something="custom">
/*<![CDATA[*/
p { color: blue; }
/*]]>*/
</style>}) }
    it "should apply text filters when outputing content" do
      css_result_from_sass = Sass::Engine.new(pages(:sassy_sass).part('body').content, Compass.sass_engine_options || {}).render
      site_css.should render(%{<r:stylesheet slug="sassy.sass" />}).as(css_result_from_sass)
    end
  end

end