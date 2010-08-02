class JavascriptsDataset < Dataset::Base
  uses :pages
  
  def load
    create_javascript "js" do
      create_javascript "site.js"
    end
  end
  
  helpers do
    def create_javascript(name, attributes={}, &block)    
      attributes = page_params(attributes.reverse_merge(:title => name, :slug => name, :class_name => 'JavascriptPage'))
      create_page(name, attributes, &block)
    end
  end
end