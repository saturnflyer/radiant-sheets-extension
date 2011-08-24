require File.expand_path("../../spec_helper", __FILE__)

describe Admin::ScriptsController do
  dataset :users, :home_page, :javascripts

  before :each do
    ActionController::Routing::Routes.reload
    login_as :designer
  end

  it "should be an ResourceController" do
    controller.should be_kind_of(Admin::ResourceController)
  end

  it "should handle JavascriptPages" do
    controller.class.model_class.should == JavascriptPage
  end


  describe "show" do
    it "should redirect to the edit action" do
      get :show, :id => 1
      response.should redirect_to(edit_admin_script_path(params[:id]))
    end

    it "should show xml when format is xml" do
      javascript = JavascriptPage.first
      get :show, :id => javascript.id, :format => "xml"
      response.body.should == javascript.to_xml
    end
  end
  describe "upload" do
    it "should respond with a bad request header if given no upload" do
      post :upload
      response.code.should == "400"
    end
    it "should redirect to the index action" do
      uploaded_file = mock(ActionController::UploadedFile).as_null_object
      uploaded_file.stub!(:original_filename).and_return('test.doc')
      uploaded_file.stub!(:read).and_return("Some content")
      uploaded_file.stub!(:size).and_return(100)
      uploaded_file.stub!(:kind_of?).with(ActionController::UploadedFile).and_return(true)
      post :upload, :upload => {:upload => uploaded_file}
      response.should redirect_to(admin_scripts_path)
    end
  end

  describe "with invalid javascript id" do
    before do
      @parameters = {:id => 999}
    end
    it "should redirect the edit action to the index action" do
      get :edit, @parameters
      response.should redirect_to(admin_scripts_path)
    end
    it "should say that the 'JavascriptPage could not be found.' after the edit action" do
      get :edit, @parameters
      flash[:notice].should match(/could not be found/)
    end
    it 'should redirect the update action to the index action' do
      put :update, @parameters
      response.should redirect_to(admin_scripts_path)
    end
    it "should say that the 'JavascriptPage could not be found.' after the update action" do
      put :update, @parameters
      flash[:notice].should match(/could not be found/)
    end
    it 'should redirect the destroy action to the index action' do
      delete :destroy, @parameters
      response.should redirect_to(admin_scripts_path)
    end
    it "should say that the 'JavascriptPage could not be found.' after the destroy action" do
      delete :destroy, @parameters
      flash[:notice].should match(/could not be found/)
    end
  end

  {:get => [:index, :show, :new, :edit],
   :post => [:create, :upload],
   :put => [:update],
   :delete => [:destroy]}.each do |method, actions|
    actions.each do |action|
      it "should require login to access the #{action} action" do
        logout
        lambda { send(method, action, :id => page_id(:site_js)) }.should require_login
      end

      if action == :show
        it "should request authentication for API access on show" do
          logout
          send(method, action, :id => page_id(:site_js), :format => "xml")
          response.response_code.should == 401
        end
      else
        it "should allow access to designers for the #{action} action" do
          lambda {
            send(method, action, :id => page_id(:site_js))
          }.should restrict_access(:allow => [users(:designer)],
                                  :url => '/admin/pages')
        end

        it "should allow access to admins for the #{action} action" do
          lambda {
            send(method, action, :id => page_id(:site_js))
          }.should restrict_access(:allow => [users(:designer)],
                                   :url => '/admin/pages')
        end

        it "should deny non-designers and non-admins for the #{action} action" do
          lambda {
            send(method, action, :id => JavascriptPage.first.id)
          }.should restrict_access(:deny => [users(:non_admin), users(:existing)],
                                   :url => '/admin/pages')
        end
      end
    end
  end

  it "should clear the page cache when saved" do
    Radiant::Cache.should_receive(:clear)
    put :update, :id => page_id(:site_js), :javascript => {:content => "Foobar."}
  end
end
