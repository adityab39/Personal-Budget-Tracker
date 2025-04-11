class UserMailer < ApplicationMailer
    default from: 'aditya.bahulikar@gmail.com'
  
    def send_otp(user)
        
      @user = user
      puts "Inside mailer: #{@user.inspect}"
      mail(to: @user[:email], subject: "Your OTP Code")
    end
  end