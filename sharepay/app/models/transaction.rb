require 'twilio-ruby'

class Transaction < ApplicationRecord
	user_token = "34e30c1b-f402-4beb-aace-b1f8c237f538"
	card_product_token = "54464a38-8a0a-49fb-9a93-7877247c4703" 


	def create_new_card
		uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/cards?show_cvv_number=true&show_pan=true")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Accept"] = "application/json"
		request["Authorization"] = "Basic dXNlcjI1NTE0NzcxODgxODY6YzQ4NjRmNzMtMTg3ZC00NDMwLWI4MzctN2QyZmVmOTEwMDFj"
		request.body = "{ \\ 
		 \"user_token\":\"34e30c1b-f402-4beb-aace-b1f8c237f538\", \\ 
		 \"card_product_token\":\"54464a38-8a0a-49fb-9a93-7877247c4703\"   \\ 
		 }"

		response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
		  http.request(request)

		card_dict = {"card_token" => response["token"], 
					 "pan_number" => response["pan"], 
					 "expiration" => response["expiration"], 
					 "cvv" => response ["cvv_number"] }
		return card_dict 
	end

	def send_text(phone_number)
		# put your own credentials here
		account_sid = 'AC1ab1324c91641f3d1754afef6a1242a0'
		auth_token = '418933176622159f66931b2fd6dbea5f'

		# set up a client to talk to the Twilio REST API
		@client = Twilio::REST::Client.new account_sid, auth_token

		# alternatively, you can preconfigure the client like so
		Twilio.configure do |config|
		  config.account_sid = account_sid
		  config.auth_token = auth_token
		end

		# and then you can create a new client without parameters
		@client = Twilio::REST::Client.new

		@client.messages.create(
		  from: '+13603472827',
		  to: '+' + phone_number,
		  body: 'Hey there!'
		)

	end
end
