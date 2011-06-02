class JavascriptsDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page 'js', :slug => 'js', :class_name => 'JavascriptPage', :parent_id => pages(:home).id do
      create_page 'site.js', :slug => 'site.js', :class_name => 'JavascriptPage' do
        create_page_part 'site_js_body', :name => 'body', :content => 'alert("site!");'
      end
      create_page 'coffee.js', :slug => 'coffee.js', :class_name => 'JavascriptPage' do
        create_page_part 'coffee_js_body', :name => 'body', :content => 'alert("site!");', :filter_id => 'Coffee'
      end
    end
  end
  
end