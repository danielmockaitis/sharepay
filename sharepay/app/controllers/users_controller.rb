class UsersController < ApplicationController

   def login_params
      params.require(:login).permit(:username, :password)
   end

   def signup_params
      params.permit(:username, :password, :password_confirm, :name, :email, :phone, :credit_card_num, :ccv).except(:password_confirm, :exp_month, :exp_year)
   end

   def credit_card
      if request.post?
         params = params + session[:signup_params]

      else
         if flash[:came_from_signup]
            #render credit card
         else
            redirect_to signup_path
         end
      end
   end

   def signup
      if request.post?
         if params[:password_confirm] == params[:password]
            new_params = signup_params()
            new_params[:expiration] = params[:exp_month].to_s + params[:exp_year].to_s
            new_params[:funding_source_token] = User.link_to_temp(new_params)
            # puts funding_source
            user = User.new(new_params)
            if user.save!
               session[:current_user_id] = user.id
               flash[:notice] = "You have Successfully Signed Up!"
               redirect_to transactions_path
            else
               flash[:warning] = "Could not sign up at this time."
            end
         else
            flash[:error] = "Your Passwords do not match!"
         end
      end
   end

   def logout
      flash[:notice]  = "Successfully Logged Out!"
      session[:current_user_id] = nil
      cookies.delete :auth_token
      cookies.delete :typo_user_profile
      redirect_to :action => 'login'
   end

   def login
      if request.post?
         puts 'Info for Login'
         puts params[:login]
         puts params[:password]
         user = User.authenticate(params[:login], params[:password])
         if user
            session[:current_user_id] = user.id
            flash[:notice] = "Successfully Logged In!"
            redirect_to transactions_path
         else
            flash[:error] = 'No Login Found, Try Again!'
         end
      end
   end

end
