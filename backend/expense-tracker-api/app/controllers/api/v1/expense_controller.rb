require 'caxlsx'

module Api
    module V1
        class Api::V1::ExpenseController < ApplicationController
            before_action :authorize_request
            def addExpense
                user_id = request_user_id.to_i
                icon = params[:icon] || ""
                category = params[:category]
                amount = params[:amount]
                date = params[:date]

                if category.blank? || amount.blank? || date.blank?
                    return render json: { message: "All fields are required" }, status: :bad_request
                end

                begin
                    ActiveRecord::Base.connection.execute("
                        INSERT INTO expenses (user_id, icon, category, amount, date, created_at, updated_at)
                        VALUES ('#{user_id}', '#{icon}', '#{category}', #{amount}, '#{date}', NOW(), NOW())
                    ")
                    new_income = ActiveRecord::Base.connection.exec_query("SELECT * FROM expenses WHERE user_id = '#{user_id}' ORDER BY id DESC LIMIT 1").first

                    render json: new_income, status: :ok

                    rescue => e
                        render json: { message: "Server Error", error: e.message }, status: :internal_server_error
                end
            end

            def getExpense
                user_id = request_user_id.to_i
                
                begin
                    incomes = ActiveRecord::Base.connection.exec_query("
                        SELECT * FROM expenses
                        WHERE user_id = #{user_id}
                        ORDER BY date DESC
                    ")

                    render json: incomes, status: :ok
                    rescue => e
                        render json: { message: "Server Error", error: e.message }, status: :internal_server_error
                end
            end

            def deleteExpense
                user_id = request_user_id.to_i
                expense_id = params[:id]

                begin
                    ActiveRecord::Base.connection.execute("
                        DELETE FROM expenses
                        WHERE id = #{expense_id} AND user_id = #{user_id}
                    ")
                    
                    render json: { message: "Expense deleted successfully" }, status: :ok
                    rescue => e
                        render json: { message: "Server Error", error: e.message }, status: :internal_server_error
                end
            end

            def downloadExpenseExcel
                user_id = request_user_id
                income_data = ActiveRecord::Base.connection.exec_query("
                SELECT category, amount, date FROM expenses
                WHERE user_id = '#{user_id}'
                ORDER BY date DESC
                ")

                p = Axlsx::Package.new
                wb = p.workbook

                wb.add_worksheet(name: "Expense") do |sheet|
                    sheet.add_row ["Category", "Amount", "Date"]
                    income_data.each do |item|
                        sheet.add_row [item["category"], item["amount"], item["date"]]
                    end
                end

                filename = "expense_details_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx"
                filepath = Rails.root.join("tmp", filename)
                p.serialize(filepath)

                send_file filepath, filename: filename, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                rescue => e
                    render json: { message: "Server Error", error: e.message }, status: :internal_server_error

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
