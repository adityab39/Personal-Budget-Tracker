require 'bcrypt'
class UsersController < ApplicationController
    def create
        name = params[:name]
        email = params[:email]
        mobile = params[:mobile]
        password = BCrypt::Password.create(params[:password])
        existing_user_sql = <<-SQL
            SELECT * FROM users WHERE email = '#{email}' OR mobile = '#{mobile}';
        SQL

        existing_user = ActiveRecord::Base.connection.exec_query(existing_user_sql)

        if existing_user.any?
            render json: { error: "User already exists. Please log in." }, status: :conflict and return
        end

        sql = <<-SQL
        INSERT INTO users (name, email, mobile, password_digest, created_at, updated_at)
        VALUES ('#{name}', '#{email}', '#{mobile}', '#{password}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        RETURNING *;
        SQL

        result = ActiveRecord::Base.connection.exec_query(sql)
        render json: { message: "Welcome, #{name}! Your account has been created.", user: result.rows[0] }, status: :created
    end
end
    