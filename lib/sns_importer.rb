class SnsImporter
  class OldTextAsset < ActiveRecord::Base
    set_table_name 'text_assets'
    belongs_to :created_by, :class_name => 'User'
    belongs_to :updated_by, :class_name => 'User'
  end
  
  def sns_assets
    OldTextAsset.all
  end
  
  def stylesheet_root
    @stylesheet_root ||= StylesheetPage.root || StylesheetPage.create_root
  end
  
  def javascript_root
    @javascript_root ||= JavascriptPage.root || JavascriptPage.create_root
  end
  
  def root(which)
    case which
    when 'stylesheet'
      stylesheet_root
    when 'javascript'
      javascript_root
    end
  end
  
  def call
    sns_assets.each do |ta|
      p "Importing #{ta.class_name} #{ta.name}"
      create_text_asset(ta.attributes)
    end
  end
  
  def create_text_asset(attrs)
    class_name = attrs.fetch 'class_name', 'Stylesheet'
    klass = (class_name + 'Page').constantize
    sheet = klass.new_with_defaults

    sheet.slug = attrs['name']
    
    unless Page.exists?({:slug => sheet.slug, :parent_id => sheet.parent_id, :class_name => sheet.class_name})
      add_sheet_content(sheet, attrs)
      set_sheet_parent(sheet, class_name)

      clean_attrs = clean_sns_attributes(sheet, attrs)
      sheet.update_attributes(clean_attrs)
    end
    
    sheet
  end
  
  def clean_sns_attributes(sheet, attrs)
    clean_attrs = attrs.dup
    clean_attrs.delete_if { |att|
      att[0].to_s.match(/^(lock_version|id|content|filter_id|name|class_name)$/) || !sheet.respond_to?("#{att[0]}=")
    }
    clean_attrs
  end
  
  def add_sheet_content(sheet, attrs)
    sheet.part('body').content = attrs.fetch('content','')
    sheet.part('body').filter_id = attrs.fetch('filter_id','')
  end
  
  def set_sheet_parent(sheet, class_name)
    sheet.parent_id = root(class_name.downcase).id
  end
end