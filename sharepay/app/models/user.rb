class User < ApplicationRecord

   require 'digest/sha1'
   require 'net/http'
   require 'uri'
   class User < ApplicationRecord

      validates_uniqueness_of :username, :on => :create
      validates_uniqueness_of :email, :on => :create
      validates_uniqueness_of :phone, :on => :create
      validates_presence_of :username
      validates_presence_of :phone
      validates_presence_of :email
      validates_presence_of :password
      validates_presence_of :name

      class_attribute :salt

      def self.salt
         '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
      end

      def self.authenticate(login, pass)
         User.where(["username = ? OR email = ? AND password = ?", login, login, password_hash(pass)]).first
         # find(:first,
         #    :conditions => ["username = ? OR email = ? AND password = ?", login, login, password_hash(pass)])
      end

      def self.authenticate?(login, pass)
         user = self.authenticate(login, pass)
         return false if user.nil?
         return true if user.login == login

         false
      end

      def password=(newpass)
         @password = newpass
      end

      def password(cleartext = nil)
         if cleartext
            @password.to_s
         else
            @password || read_attribute("password")
         end
      end

      protected

      def self.password_hash(pass)
         Digest::SHA1.hexdigest("#{salt}--#{pass}--")
      end

      def password_hash(pass)
         self.class.password_hash(pass)
      end

      before_create :crypt_password

      def crypt_password
         send_create_notification
         write_attribute "password", password_hash(password(true))
         @password = nil
      end

      before_update :crypt_unless_empty

      def crypt_unless_empty
         if password(true).empty?
               user = self.class.find(self.id)
               write_attribute "password", user.password
         else
            crypt_password
         end
      end

      private

     # Send a mail of creation user to the user create
      def send_create_notification
         begin
            email_notification = NotificationMailer.notif_user(self)
            EmailNotify.send_message(self, email_notification)
         rescue => err
            logger.error "Unable to send notification of create user email: #{err.inspect}"
         end
     end

   end

   def link_to_temp(user_id)
      user = Users.find_by(id:user_id)
      uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/fundingsources/paymentcard")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["Accept"] = "application/json"
      request["Authorization"] = "Basic dXNlcjI1NzE0NzcxOTAwNDQ6ZmJiMGY2ZWUtM2E2OC00ZDI3LTkwOTQtNTAxM2FmNDY2Mjdi"
      request.body = 
      "{ \\ 
       \"user_token\":\"34e30c1b-f402-4beb-aace-b1f8c237f538\", \\ 
       \"account_number\": \"" + user.credit_car + "\", \\ 
       \"exp_date\":\"" + user.exp_date + "\", \\ 
       \"cvv_number\":\"" + user.ccv + "\" \\ 
      }"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
         http.request(request)

      funding_source_token = response["token"]
   end

   def send_to_temp(transaction_id, user_id)
      user = Users.find_by(id: user_id)
      transaction = Transactions.find_by(id: transaction_id)
      uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/gpaorders")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["Accept"] = "application/json"
      request["Authorization"] = "Basic dXNlcjI1NzE0NzcxOTAwNDQ6ZmJiMGY2ZWUtM2E2OC00ZDI3LTkwOTQtNTAxM2FmNDY2Mjdi"
      request.body = "{ \\ 
        \"user_token\": \"34e30c1b-f402-4beb-aace-b1f8c237f538\", \\ 
        \"currency_code\": \"840\", \\ 
        \"amount\":" + transaction.price.to_s + ", \\ 
        \"funding_source_token\": \""+ user.funding_source_token+ "\", \\ 
        \"funding_source_address_token\": \"54fddb5b-2a7e-4fdb-b3c2-3e1d601dff51\" \\ 
      } \\ 
      "

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
       http.request(request)
   end

end
