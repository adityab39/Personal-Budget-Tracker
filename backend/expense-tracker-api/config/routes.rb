Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      get 'auth/getUser', to: 'auth#user_info'
      post "auth/upload-image", to: "auth#upload_image"
    end
  end

  namespace :api do
    namespace :v1 do
      post 'income/add', to: 'income#addIncome'
      get 'income/get', to: 'income#getIncome'
      delete 'income/:id', to: 'income#deleteIncome'
      get 'income/downloadExcel', to: 'income#downloadIncomeExcel'
    end
  end

end