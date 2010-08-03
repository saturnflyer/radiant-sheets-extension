class JavascriptPage < Page
  include Sheet::Instance
  in_menu false
  
  def headers
    {'Content-Type' => 'text/javascript'}
  end
      
  def self.new_with_defaults(config = Radiant::Config)
    page = JavascriptPage.new
    page.parts.concat(self.default_page_parts)
    page.parent_id = JavascriptPage.root.try(:id)
    page.status_id = Status[:published].id
    page
  end
end