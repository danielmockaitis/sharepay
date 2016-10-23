require 'json'
class Transaction < ApplicationRecord

	validates_uniqueness_of :card_token, :on => :create
   validates_presence_of :price
   validates_presence_of :virtual_credit_card
   validates_presence_of :ccv
   validates_presence_of :expiration

	belongs_to :user

	user_token = "34e30c1b-f402-4beb-aace-b1f8c237f538"
	card_product_token = "54464a38-8a0a-49fb-9a93-7877247c4703"

	def self.create_new_card
		uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/cards?show_cvv_number=true&show_pan=true")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Accept"] = "application/json"
		request["Authorization"] = "Basic dXNlcjI1NTE0NzcxODgxODY6YzQ4NjRmNzMtMTg3ZC00NDMwLWI4MzctN2QyZmVmOTEwMDFj"
		request.body = "{
		 \"user_token\":\"34e30c1b-f402-4beb-aace-b1f8c237f538\",
		 \"card_product_token\":\"54464a38-8a0a-49fb-9a93-7877247c4703\"
		 }"

		response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
		  http.request(request)
	  	end
		puts "Response Recieved!"
		puts response.code
		puts response.body
		response = JSON.parse(response.body)
		card_dict = {:card_token => response["token"],
					 :pan_number => response["pan"],
					 :expiration => response["expiration"],
					 :cvv => response["cvv_number"] }
		return card_dict
	end
end
