Personal Budget Tracker

A full-stack personal budget management application built with Ruby on Rails for the backend and React.js with TailwindCSS for the frontend. The app allows users to manage incomes and expenses with JWT-based authentication, charts, data exports, and image uploads.

Features
	•	User authentication (JWT-based)
	•	Income & expense tracking
	•	Visual dashboards with bar charts
	•	Image uploads for user profiles
	•	Excel export of income data
	•	Responsive UI built with TailwindCSS

Tech Stack

Frontend:
	•	React.js
	•	TailwindCSS
	•	Recharts
	•	Axios
	•	Vite

Backend:
	•	Ruby on Rails
	•	PostgreSQL
	•	JWT

Other Tools:
	•	Cloudinary (for image uploads)
	•	Toastify (for notifications)

Setup Instructions

Backend

cd backend/expense-tracker-api
bundle install
rails db:create db:migrate
rails server

Frontend

cd frontend/expense-tracker
npm install
npm run dev

Folder Structure

Personal Budget Tracker/
├── backend/
│   └── expense-tracker-api/
│       ├── app/
│       ├── config/
│       ├── db/
│       └── ...
├── frontend/
│   └── expense-tracker/
│       ├── src/
│       │   ├── components/
│       │   ├── context/
│       │   ├── pages/
│       │   └── utils/
│       └── ...

Environment Variables

Backend: Create a .env file and add:

CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_key
CLOUDINARY_API_SECRET=your_secret
SECRET_KEY_BASE=your_rails_secret_key

Frontend: Create a .env file and add:

VITE_API_BASE_URL=http://localhost:3000

License

This project is licensed under the MIT License. See LICENSE for more information.
