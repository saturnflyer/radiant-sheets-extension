class Admin::ScriptsController < Admin::ResourceController
  model_class JavascriptPage
  only_allow_access_to :index, :new, :edit, :create, :update, :destroy,
    :when => [:designer, :admin],
    :denied_url => { :controller => 'pages', :action => 'index' },
    :denied_message => 'You must have developer or administrator privileges to edit javascripts.'
  
  private
  
  def edit_model_path
    edit_admin_script_path(params[:id])
  end
end
