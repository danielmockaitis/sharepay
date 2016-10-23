class TransactionsController < ApplicationController
   def index
      if session[:current_user_id]
         current_user_id = session[:current_user_id]
         @current_user = User.find(current_user_id)
      else
         redirect_to login_path
      end
   end

   def new
      if request.post?
         #What
      else
         @all_users = Users.all
         @all_users.delete current_user
      end
   end
end
