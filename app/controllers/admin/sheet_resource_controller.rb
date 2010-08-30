class Admin::SheetResourceController < Admin::ResourceController
  paginate_models
  # only_allow_access_to must be set
  
  prepend_before_filter :find_root
  prepend_before_filter :create_root, :only => [:new, :upload]
  
  def upload
    if params[:upload].blank?  # necessary params are missing
      render :text => '', :status => :bad_request
    else
      @sheet = model_class.create_from_upload(params[:upload][:upload])
      if @sheet.valid?
        redirect_to index_page_for_model
      else
        flash[:error] = "There was an error. #{@sheet.errors.full_messages}"
        redirect_to index_page_for_model
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
    @root = model_class.root
  end
  
  def create_root
    unless @root
      s = model_class.new_with_defaults
      begin
        s.parent_id = Page.find_by_slug('/').id
      rescue
        flash[:error] = "You must first create a homepage before you may create a #{humanized_model_name}."
        redirect_to welcome_path and return false
      end
      s.slug = model_class == StylesheetPage ? 'css' : 'js'
      s.save
    end
  end
end
