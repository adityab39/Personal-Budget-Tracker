require 'bcrypt'

module Api
  module V1
      class AuthController < ApplicationController
          def register
            full_name = params[:fullName]
            email = params[:email]
            password = params[:password]
            profile_image_url = params[:profileImageUrl]

            if full_name.blank? || email.blank? || password.blank?
              return render json: { message: "All fields are required" }, status: :bad_request
            end

            begin
              existing = ActiveRecord::Base.connection.exec_query("SELECT * FROM users WHERE email = '#{email}' LIMIT 1")

              if existing.any?
                return render json: { message: "Email already in use" }, status: :bad_request
              end
              
              hashed_password = BCrypt::Password.create(password)

              ActiveRecord::Base.connection.execute("
                INSERT INTO users (full_name, email, password, profile_image_url, created_at, updated_at)
                VALUES ('#{full_name}', '#{email}', '#{hashed_password}', '#{profile_image_url}', NOW(), NOW())
              ")

              new_user = ActiveRecord::Base.connection.exec_query("SELECT * FROM users WHERE email = '#{email}' LIMIT 1").first

              token = generate_token(new_user["id"])

              render json: {
                id: new_user["id"],
                user: new_user,
                token: token
              }, status: :created

            rescue => e
              render json: { message: "Error registering user", error: e.message }, status: :internal_server_error
            end
          end

          def login
            email = params[:email]
            password = params[:password]

            if email.blank? || password.blank?
              return render json: { message: "All fields are required" }, status: :bad_request
            end

            user_result = ActiveRecord::Base.connection.exec_query("SELECT * FROM users WHERE email = '#{email}' LIMIT 1")
            if user_result.empty?
              return render json: { message: "Invalid credentials" }, status: :bad_request
            end

            user = user_result.first
            if !BCrypt::Password.new(user["password"]).is_password?(password)
              return render json: { message: "Invalid credentials" }, status: :bad_request
            end

            token = generate_token(user["id"])

            render json: {
              id: user["id"],
              user: user.except("password"),
              token: token
            }, status: :ok

            rescue => e
              render json: { message: "Error logging in", error: e.message }, status: :internal_server_error
          end

          private
          def generate_token(user_id)
            payload = { user_id: user_id, exp: 7.days.from_now.to_i }
            JWT.encode(payload, Rails.application.secret_key_base)
          end

          
      end
  end
end