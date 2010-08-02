# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class SheetsExtension < Radiant::Extension
  version "1.0"
  description "Manage CSS and Javascript content in Radiant CMS as Sheets, a subset of Pages"
  url "http://github.com/radiant/radiant"
  
  def activate
    tab 'Design' do
      add_item "Stylesheets", "/admin/styles"
      add_item "Javascripts", "/admin/scripts"
    end
    
    Admin::NodeHelper.module_eval do
      def render_node_with_sheets(page, locals = {})
        unless page.sheet?
          render_node_without_sheets(page, locals)
        end
      end
      alias_method_chain :render_node, :sheets
    end
    
    Page.class_eval do
      def sheet?
        false
      end
      
      include JavascriptTags
      include StylesheetTags
    end
    
    SiteController.class_eval do
      cattr_writer :sheet_cache_timeout
  
      def self.sheet_cache_timeout
        @@sheet_cache_timeout ||= 30.days
      end
      
      def set_cache_control_with_sheets
        if @page.sheet?
          expires_in self.class.sheet_cache_timeout, :public => true, :private => false
        else
          set_cache_control_without_sheets
        end
      end
      alias_method_chain :set_cache_control, :sheets
    end
  end
end
