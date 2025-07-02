
module Api
    module V1
        class Api::V1::IncomeController < ApplicationController
            before_action :authorize_request
            def addIncome
                user_id = request_user_id.to_i
                icon = params[:icon] || ""
                source = params[:source]
                amount = params[:amount]
                date = params[:date]

                if source.blank? || amount.blank? || date.blank?
                    return render json: { message: "All fields are required" }, status: :bad_request
                end

                begin
                    ActiveRecord::Base.connection.execute("
                        INSERT INTO incomes (user_id, icon, source, amount, date, created_at, updated_at)
                        VALUES ('#{user_id}', '#{icon}', '#{source}', #{amount}, '#{date}', NOW(), NOW())
                    ")
                    new_income = ActiveRecord::Base.connection.exec_query("SELECT * FROM incomes WHERE user_id = '#{user_id}' ORDER BY id DESC LIMIT 1").first

                    render json: new_income, status: :ok

                    rescue => e
                        render json: { message: "Server Error", error: e.message }, status: :internal_server_error
                end
            end

            def getIncome
                user_id = request_user_id.to_i
                
                begin
                    incomes = ActiveRecord::Base.connection.exec_query("
                        SELECT * FROM incomes
                        WHERE user_id = #{user_id}
                        ORDER BY date DESC
                    ")

                    render json: incomes, status: :ok
                    rescue => e
                        render json: { message: "Server Error", error: e.message }, status: :internal_server_error
                end
            end

            def deleteIncome
                user_id = request_user_id.to_i
                ncome_id = params[:id]

                begin
                    ActiveRecord::Base.connection.execute("
                        DELETE FROM incomes
                        WHERE id = #{income_id} AND user_id = #{user_id}
                    ")
                    
                    render json: { message: "Income deleted successfully" }, status: :ok
                    rescue => e
                        render json: { message: "Server Error", error: e.message }, status: :internal_server_error
                end
            end

            private
            def authorize_request
                header = request.headers['Authorization']
                token = header.split(' ').last
                decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
                @current_user_id = decoded['user_id'].to_i
                rescue
                    render json: { message: "Not authorized" }, status: :unauthorized
            end

            def request_user_id
                @current_user_id
            end

        end
    end
end