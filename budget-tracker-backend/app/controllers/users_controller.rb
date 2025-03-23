require 'bcrypt'
class UsersController < ApplicationController
    def create
        name = params[:name]
        email = params[:email]
        mobile = params[:mobile]
        password = BCrypt::Password.create(params[:password])
        sql = <<-SQL
        INSERT INTO users (name, email, mobile, password_digest, created_at, updated_at)
        VALUES ('#{name}', '#{email}', '#{mobile}', '#{password}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        RETURNING *;
        SQL

        result = ActiveRecord::Base.connection.exec_query(sql)
        render json: { message: "User created manually", user: result.rows[0] }, status: :created

end
