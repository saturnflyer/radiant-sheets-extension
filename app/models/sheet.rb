module Sheet
  module Instance
    def self.included(base)
      base.class_eval {
        before_validation :set_title
        before_validation :set_breadcrumb
        
        def self.root
          root = self.first(:order => 'id')
        end

        def self.default_page_parts
          PagePart.new(:name => 'body')
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
  
    private
  
    def set_title
      self.title = self.slug
    end
  
    def set_breadcrumb
      self.breadcrumb = self.slug
    end
  end
end