module ControllerMacros
  def sign_in_user
    before do
      @city = create(:city)
      @user = create(:user, city: @city)
      log_in @user
    end
  end
end