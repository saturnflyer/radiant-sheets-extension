class Admin::StylesController < Admin::ResourceController
  model_class StylesheetPage
  paginate_models
  only_allow_access_to :index, :new, :edit, :create, :update,
    :when => [:designer, :admin],
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have developer or administrator privileges to edit stylesheets.'
  
  prepend_before_filter :find_root
  prepend_before_filter :create_root, :only => [:new, :upload]
  
  def upload
    if params[:upload].blank?  # necessary params are missing
      render :text => '', :status => :bad_request
    else
      @sheet = model_class.create_from_upload(params[:upload][:upload])
      if @sheet.valid?
        redirect_to admin_styles_path
      else
        flash[:error] = "There was an error. #{@sheet.errors.full_messages}"
        redirect_to admin_styles_path
      end
    end
  end
  
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
    @root = StylesheetPage.root
  end
  
  def create_root
    unless @root
      j = StylesheetPage.new_with_defaults
      begin
        j.parent_id = Page.find_by_slug('/').id
      rescue
        flash[:error] = 'You must first create a homepage before you may create a stylesheet.'
        redirect_to welcome_path and return false
      end
      j.slug = 'css'
      j.save
    end
  end
end
