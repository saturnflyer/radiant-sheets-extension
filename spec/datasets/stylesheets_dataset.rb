class StylesheetsDataset < Dataset::Base
  uses :home_page
  
  def load
    create_page "css", :slug => 'css', :class_name => 'StylesheetPage' do
      create_page "site.css", :slug => 'site.css', :class_name => 'StylesheetPage'
      create_page "sassy.sass", :slug => 'sassy.sass', :class_name => 'StylesheetPage' do
        create_page_part 'sass_body', :name => 'body', :content => 'header
  background: red', :filter_id => 'Sass'
      end
      create_page "container.css", :body => '<r:stylesheet slug="sassy.css" />', :class_name => 'StylesheetPage'
    end
  end
  
end