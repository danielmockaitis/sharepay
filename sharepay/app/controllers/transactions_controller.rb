require 'net/http'
require 'uri'


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

      end
   end

   def completed(transaction_id)
    if session[:current_user_id]
      transaction = Transactions.find(transaction_id)
      current_user_id = session[:current_user_id]
      @current_user = User.find(current_user_id)
      if transaction.num_accepted == transaction.num_needed
        @card_number = transaction.virtual_credit_card
        @ccv = transaction.ccv
        @expiration = transaction.expiration
      else
        redirect_to transactions_path
      end
    else
      redirect_to login_path
    end
   end
end
