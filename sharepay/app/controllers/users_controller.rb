class UsersController < ApplicationController

   def login_params
      params.require(:login).permit(:username, :password)
   end

   def logout
      flash[:notice]  = "Successfully logged out!"
      session[:current_user_id]
      cookies.delete :auth_token
      cookies.delete :typo_user_profile
      redirect_to :action => 'login'
   end

   def login
      if request.post?
         puts 'Info for Login'
         puts params[:login][:username]
         puts params[:login][:password]
         user = User.authenticate(params[:login][:username], params[:login][:password])
         if user
            session[:current_user_id] = user.id
            redirect_to boards_index_path
         else
            flash[:error] = 'No Login Found, Try Again!'
         end
      end
   end

end
