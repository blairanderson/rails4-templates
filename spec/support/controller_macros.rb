module ControllerMacros
  def login_user(user=nil)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @login_user = user || FactoryGirl.create(:user)
      sign_in @login_user
    end
  end
end
