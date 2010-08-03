class StylesheetPage < Page
  include Sheet::Instance
  in_menu false
    
  def headers
    {'Content-Type' => 'text/css'}
  end
      
  def self.new_with_defaults(config = Radiant::Config)
    page = StylesheetPage.new
    page.parts.concat(self.default_page_parts)
    page.parent_id = StylesheetPage.root.try(:id)
    page.status_id = Status[:published].id
    page
  end
end