module Sheet
  module Instance
    def self.included(base)
      base.class_eval {
        before_validation :set_title
        before_validation :set_breadcrumb
        before_validation :set_published
        
        def self.root
          self.first(:order => 'id')
        end

        def self.default_page_parts
          PagePart.new(:name => 'body')
        end
        
        def self.create_from_upload(file)
          @sheet = self.new_with_defaults
          @sheet.upload = file
          @sheet.save
          @sheet
        end
        
      }
    end
    
    def cache?
      true
    end
  
    # stub to check type
    def sheet?
      true
    end
  
    # so that it is ignored when finding children in radius tags
    def virtual?
      true
    end
  
    def layout
      nil
    end
    
    def find_by_url(url, live = true, clean = true)
      url = clean_url(url) if clean
      my_url = self.url
      if (my_url == url) && (not live or published?)
        self
      elsif (url =~ /^#{Regexp.quote(my_url)}([^\/]*)/)
        slug_child = children.find_by_slug($1)
        if slug_child
          return slug_child
        else
          super
        end
      end
    end
        
    def upload=(file)
      case
      when file.blank?
        self.errors.add(:upload, 'not given. Please upload a file.')
      when !file.kind_of?(ActionController::UploadedFile)
        self.errors.add(:upload, 'is an unusable format.')
      when file.size > 262144 # 256k (that's a HUGE script or stylesheet)
        self.errors.add(:upload, 'file size is larger than 256kB. Please upload a smaller file.')
      else
        self.slug = file.original_filename.to_slug().gsub(/-css$/,'.css').gsub(/-js/,'.js')
        self.part('body').content = file.read
      end
    end
  
    private
  
    def set_title
      self.title = self.slug
    end
  
    def set_breadcrumb
      self.breadcrumb = self.slug
    end
    
    def set_published
      self.published_at = Time.now
      self.status_id = Status[:published].id
    end
  end
end