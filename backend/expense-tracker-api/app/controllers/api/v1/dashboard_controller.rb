module Api
  module V1
    class DashboardController < ApplicationController
        before_action :authorize_request
        def getDashboardData
            user_id = request_user_id

            total_income_result = ActiveRecord::Base.connection.exec_query("
            SELECT COALESCE(SUM(amount), 0) AS total FROM incomes
            WHERE user_id = '#{user_id}'
            ")
            total_income = total_income_result.first["total"]

            total_expense_result = ActiveRecord::Base.connection.exec_query("
            SELECT COALESCE(SUM(amount), 0) AS total FROM expenses
            WHERE user_id = '#{user_id}'
            ")
            total_expense = total_expense_result.first["total"]

            income_last_60_days_result = ActiveRecord::Base.connection.exec_query("
            SELECT * FROM incomes
            WHERE user_id = '#{user_id}' AND date >= CURRENT_DATE - INTERVAL '60 days'
            ORDER BY date DESC
            ")
            income_last_60_days_total = income_last_60_days_result.to_a.sum { |tx| tx["amount"] }

            expense_last_30_days_result = ActiveRecord::Base.connection.exec_query("
            SELECT * FROM expenses
            WHERE user_id = '#{user_id}' AND date >= CURRENT_DATE - INTERVAL '30 days'
            ORDER BY date DESC
            ")
            expense_last_30_days_total = expense_last_30_days_result.to_a.sum { |tx| tx["amount"] }

            income_last_5 = ActiveRecord::Base.connection.exec_query("
            SELECT *, 'income' AS type FROM incomes
            WHERE user_id = '#{user_id}'
            ORDER BY date DESC
            LIMIT 5
            ")

            expense_last_5 = ActiveRecord::Base.connection.exec_query("
            SELECT *, 'expense' AS type FROM expenses
            WHERE user_id = '#{user_id}'
            ORDER BY date DESC
            LIMIT 5
            ")

            last_transactions = (income_last_5.to_a + expense_last_5.to_a).sort_by { |tx| tx["date"] }.reverse.take(5)

            render json: {
            totalBalance: total_income - total_expense,
            totalIncome: total_income,
            totalExpenses: total_expense,
            last30DaysExpenses: {
                total: expense_last_30_days_total,
                transactions: expense_last_30_days_result
            },
            last60DaysIncome: {
                total: income_last_60_days_total,
                transactions: income_last_60_days_result
            },
            recentTransactions: last_transactions
            }
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
