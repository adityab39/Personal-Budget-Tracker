require 'bcrypt'
class UsersController < ApplicationController
    def sendOtp
        name = params[:name]
        email = params[:email]
        mobile = params[:mobile]
        password = BCrypt::Password.create(params[:password])
        otp = rand(100000..999999).to_s

        existing_user_sql = <<-SQL
            SELECT * FROM pending_users WHERE email = '#{email}' OR mobile = '#{mobile}';
        SQL

        existing_user = ActiveRecord::Base.connection.exec_query(existing_user_sql)

        if existing_user.any?
            render json: { error: "User already exists. Please log in." }, status: :conflict and return
        end

        sql = <<-SQL
        INSERT INTO pending_users (name, email, mobile, password_digest, otp, created_at)
        VALUES ('#{name}', '#{email}', '#{mobile}', '#{password}','#{otp}', CURRENT_TIMESTAMP)
        RETURNING *;
        SQL

        UserMailer.send_otp({ name: name, email: email, otp: otp}).deliver_now

        result = ActiveRecord::Base.connection.exec_query(sql)
        render json: {
            email: email,
            otp: otp, 
            message: "OTP sent to #{email}. Please verify to complete registration." }, status: :ok
    end

    def signup
        email = params[:email]
        otp = params[:otp]
        
        check_sql = <<-SQL
            SELECT * FROM pending_users WHERE email = '#{email}' AND otp = '#{otp}';
        SQL

        pending_user = ActiveRecord::Base.connection.exec_query(check_sql)
        if pending_user.any?
            user = pending_user.first
            insert_sql = <<-SQL
            INSERT INTO users (name, email, mobile, password_digest, created_at, updated_at)
            VALUES ('#{user["name"]}', '#{user["email"]}', '#{user["mobile"]}', '#{user["password_digest"]}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            SQL

            ActiveRecord::Base.connection.execute(insert_sql)

            delete_sql = <<-SQL
                DELETE FROM pending_users WHERE email  = '#{email}';
                SQL
            ActiveRecord::Base.connection.execute(delete_sql)

            render json: { message: "Account created successfully." }, status: :created
        else
            render json: { error: "Invalid OTP or email." }, status: :unauthorized    
        end
    end

end
    