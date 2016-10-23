class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :show_flash

  private

 #  def create_blank_user
	# uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/users")
	# request = Net::HTTP::Post.new(uri)
	# request.content_type = "application/json"
	# request["Accept"] = "application/json"
	# request["Authorization"] = "Basic dXNlcjI1NTE0NzcxODgxODY6YzQ4NjRmNzMtMTg3ZC00NDMwLWI4MzctN2QyZmVmOTEwMDFj"
	# request.body = JSON.dump(
	# })

	# response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
	#   http.request(request)

	# user_token = response["token"]
	# account_number = response["deposit_account"]["account_number"]
	# routing_number = response["deposit_account"]["routing_number"]
 #  end

  def show_flash
   #  flash.now[:notice] = "Found the about page!" if request.path == '/pages/about'
  end
end
