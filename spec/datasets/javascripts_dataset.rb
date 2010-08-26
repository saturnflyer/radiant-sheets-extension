class JavascriptsDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page 'js', :slug => 'js', :class_name => 'JavascriptPage', :parent_id => pages(:home).id do
      create_page 'site.js', :slug => 'site.js', :class_name => 'JavascriptPage'
    end
  end
  
end