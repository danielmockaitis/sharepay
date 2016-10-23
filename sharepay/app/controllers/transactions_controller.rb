require 'net/http'
require 'uri'

class TransactionsController < ApplicationController

   def transaction_params
      params.permit(:price, :title, :description).except(:users)
   end

   def run
      transaction = Transaction.find(params[:id])
      if transaction.already_paid.to_i == transaction.total_payers
         #make Transaction
         transaction.status = "Approved"
         transaction.save
         # flash[:notice] = "Transaction Successfully Approved!"
      else
         flash[:error] = "Transaction Denied!"
         redirect_to transactions_path
      end
   end

   def approve
      transaction = Transaction.find(params[:id])
      transaction.already_paid.to_i += 1
      transaction.already_paid = transaction.already_paid.to_s
      transaction.save!
   end

   def show
      puts params.inspect
      @transaction = Transaction.find(params[:id])
   end

   def requests
      puts 'REQUEST'
      if session[:current_user_id]
         current_user_id = session[:current_user_id]
         puts current_user_id
         @current_user = User.find(current_user_id)
         @requested_transactions = @current_user.transactions.all
         puts "Requested Transactions"
         puts @requested_transactions.inspect
      else
         redirect_to login_path
      end
   end

   def index
      puts 'INDEX'
      if session[:current_user_id]
         current_user_id = session[:current_user_id]
         puts current_user_id
         @current_user = User.find(current_user_id)
         @pending_transactions = Transaction.where(requester: current_user_id).to_a
         puts "Pending Transactions"
         puts @pending_transactions.inspect
      else
         redirect_to login_path
      end
   end

   def new
      if request.post?
         puts params[:users]
         if params[:users].empty?
            flash[:error] = "Other Users must Sign Up Before You can Create a Transaction."
            redirect_to transactions_path
         else
            trans_params = transaction_params
            card_dict = Transaction.create_new_card
            puts card_dict
            trans_params[:card_token] = card_dict[:card_token]
            trans_params[:virtual_credit_card] = card_dict[:pan_number]
            trans_params[:expiration] = card_dict[:expiration]
            trans_params[:ccv] = card_dict[:cvv]
            trans_params[:already_paid] = '0'
            trans_params[:status] = 'Pending'
            trans_params[:requester] = session[:current_user_id]
            trans_params[:total_payers] = params[:users].length
            puts trans_params.inspect
            # transaction = Transaction.new(trans_params)
            co_payer_ids = params[:users].split()
            co_payer_ids.each do |co_payer_id|
               user = User.find(co_payer_id)
               trans = user.transactions.new(trans_params)
               if trans.save! and user.save!
                  flash[:notice] = 'Successfully Created a Transaction!'
                  redirect_to transactions_path
               else
                  flash[:error] = 'Transaction could not be completed!'
               end
            end
         end
      else
         @all_users = User.where.not(id: session[:current_user_id]).to_a
         if @all_users.length == 0
            flash[:warning] = "There are no other users inputted to share the payment with."
            redirect_to transactions_path
         end
      end
   end

	# def create_new_card
	# 	uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/cards?show_cvv_number=true&show_pan=true")
	# 	request = Net::HTTP::Post.new(uri)
	# 	request.content_type = "application/json"
	# 	request["Accept"] = "application/json"
	# 	request["Authorization"] = "Basic dXNlcjI1NTE0NzcxODgxODY6YzQ4NjRmNzMtMTg3ZC00NDMwLWI4MzctN2QyZmVmOTEwMDFj"
	# 	request.body = "{ \\
	# 	 \"user_token\":\"34e30c1b-f402-4beb-aace-b1f8c237f538\", \\
	# 	 \"card_product_token\":\"54464a38-8a0a-49fb-9a93-7877247c4703\"   \\
	# 	 }"

	# 	response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
	# 	  http.request(request)

	# 	card_dict = {"card_token" => response["token"],
	# 				 "pan_number" => response["pan"],
	# 				 "expiration" => response["expiration"],
	# 				 "cvv" => response ["cvv_number"] }
	# 	return card_dict
	# end
end
