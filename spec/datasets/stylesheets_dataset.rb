class StylesheetsDataset < Dataset::Base
  uses :pages
  
  def load
    create_stylesheet "css" do
      create_stylesheet "site.css"
    end
  end
  
  helpers do
    def create_stylesheet(name, attributes={}, &block)    
      attributes = page_params(attributes.reverse_merge(:title => name, :slug => name, :class_name => 'StylesheetPage'))
      create_page(name, attributes, &block)
    end
  end
end