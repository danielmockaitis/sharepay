require 'digest/sha1'
require 'net/http'
require 'uri'
require 'json'


class User < ApplicationRecord

   has_many :transactions

   validates_uniqueness_of :username, :on => :create
   validates_uniqueness_of :email, :on => :create
   validates_uniqueness_of :phone, :on => :create
   validates_presence_of :username
   validates_presence_of :phone, length: {is: 10}
   validates_presence_of :email
   validates_presence_of :password
   validates_presence_of :name
   validates_presence_of :credit_card_num, length: {minimum: 16}
   validates_presence_of :ccv, length: {is: 3}
   validates_presence_of :expiration, length: {is: 4}

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

  # # Send a mail of creation user to the user create
  #  def send_create_notification
  #     begin
  #        email_notification = NotificationMailer.notif_user(self)
  #        EmailNotify.send_message(self, email_notification)
  #     rescue => err
  #        logger.error "Unable to send notification of create user email: #{err.inspect}"
  #     end
  # end

   def self.link_to_temp(params)
      uri = URI.parse("https://sandbox.api.visa.com/pav/v1/cardvalidation")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["Authorization"] = "\"userid\": \"3MDJBT5IYBFSVJJJDWOW21r0CXtHq-UZGQfj-ORTm5kz-ABp8\", \"password \" : \"iE1A4AyzAJr\" }"
      request.body = "{
        \"addressVerificationResults\": {
          \"postalCode\": \"T4B 3G5\",
          \"street\": \"2881 Main Street Sw\"
        },
        \"cardAcceptor\": {
          \"address\": {
            \"city\": \"fostr city\",
            \"country\": \"PAKISTAN\",
            \"county\": \"CA\",
            \"state\": \"CA\",
            \"zipCode\": \"94404\"
          },
          \"idCode\": \"111111\",
          \"name\": \"rohan\",
          \"terminalId\": \"123\"
        },
        \"cardCvv2Value\": \"672\",
        \"cardExpiryDate\": \"2018-06\",
        \"primaryAccountNumber\": \"4957030000313108\",
        \"retrievalReferenceNumber\": \"015221743720\",
        \"systemsTraceAuditNumber\": \"743720\"
      }"
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
         http.request(request)
      end
         
      uri = URI.parse("https://shared-sandbox-api.marqeta.com/v3/fundingsources/paymentcard")
      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["Accept"] = "application/json"
      request["Authorization"] = "Basic dXNlcjI1NzE0NzcxOTAwNDQ6ZmJiMGY2ZWUtM2E2OC00ZDI3LTkwOTQtNTAxM2FmNDY2Mjdi"
      request.body =
      "{
       \"user_token\":\"34e30c1b-f402-4beb-aace-b1f8c237f538\",
       \"account_number\": \"" + params[:credit_card_num] + "\",
       \"exp_date\":\"" + params[:expiration] + "\",
       \"cvv_number\":\"" + params[:ccv] + "\"
      }"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
         http.request(request)
      end


      funding_source_token = JSON.parse(response.body)["token"]

      return funding_source_token
   end

end
