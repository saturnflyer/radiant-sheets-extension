# require 'spec_helper'
require File.dirname(__FILE__) + '/../spec_helper'

describe "Javascript Tags" do
  dataset :javascripts

  let(:page){ pages(:home) }

  describe "<r:javascript>" do
    let(:javascript_page){ JavascriptPage.find_by_slug('site.js')}
    subject { page }
    it { should render(%{<r:javascript />}).with_error("`javascript' tag must contain a `slug' attribute.") }
    it { should render(%{<r:javascript slug="bogus" />}).with_error("javascript not found") }
    it { should render(%{<r:javascript slug="site.js" />}).as("site.js body.") }
    it { should render(%{<r:javascript slug="site.js" as="url" />}).as("/js/site.js?#{javascript_page.updated_at.to_i}") }
    it { should render(%{<r:javascript slug="site.js" as="link" />}).as(%{<script type="#{javascript_page.headers['Content-Type']}" src="#{javascript_page.url.gsub(/\/$/,'')}?#{javascript_page.updated_at.to_i.to_s}"></script>}) }
    it { should render(%{<r:javascript slug="site.js" as="link" type="special/type" />}).as(%{<script type="special/type" src="#{javascript_page.url.gsub(/\/$/,'')}?#{javascript_page.updated_at.to_i.to_s}"></script>}) }
    it { should render(%{<r:javascript slug="site.js" as="link" something="custom" />}).as(%{<script type="#{javascript_page.headers['Content-Type']}" src="#{javascript_page.url.gsub(/\/$/,'')}?#{javascript_page.updated_at.to_i.to_s}" something="custom"></script>}) }
    it { should render(%{<r:javascript slug="site.js" as="inline" />}).as(%{<script type="#{javascript_page.headers['Content-Type']}">
//<![CDATA[
site.js body.
//]]>
</script>}) }
    it { should render(%{<r:javascript slug="site.js" as="inline" type="special/type" />}).as(%{<script type="special/type">
//<![CDATA[
site.js body.
//]]>
</script>}) }
    it { should render(%{<r:javascript slug="site.js" as="inline" something="custom" />}).as(%{<script type="#{javascript_page.headers['Content-Type']}" something="custom">
//<![CDATA[
site.js body.
//]]>
</script>}) }
  end

end