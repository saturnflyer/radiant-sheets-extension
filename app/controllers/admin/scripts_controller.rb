class Admin::ScriptsController < Admin::ResourceController
  model_class JavascriptPage
  paginate_models
  only_allow_access_to :index, :new, :edit, :create, :update,
    :when => [:designer, :admin],
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have developer or administrator privileges to edit javascripts.'
  
  prepend_before_filter :find_root
  prepend_before_filter :create_root, :only => :new
  
  def new
    self.model = model_class.new_with_defaults
    response_for :new
  end
  
  def create
    model.parent_id = @root.id
    model.update_attributes!(params[model_symbol])
    response_for :create
  end
  
  private
  
  def load_models
    @root.try(:children) || []
  end
  
  def find_root
    @root = JavascriptPage.root
  end
  
  def create_root
    unless @root
      j = JavascriptPage.new_with_defaults
      j.parent_id = Page.find_by_slug('/').try(:id)
      j.slug = 'js'
      j.save
    end
  end
end
