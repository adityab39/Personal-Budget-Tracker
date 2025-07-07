# Personal Budget Tracker

A full-stack web application to track your personal income and expenses. Built with React (Vite), Ruby on Rails, PostgreSQL, and Tailwind CSS.

---

## Features

- User Authentication (JWT-based)
- Add, view, delete income and expense entries
- Interactive bar charts for income/expenses (using Recharts)
- Download data as Excel
- Image upload support (e.g., category icons)
- Responsive design

---

## Tech Stack

### Frontend
- React (Vite)
- Tailwind CSS
- Axios
- Recharts
- React Router
- Toastify

### Backend
- Ruby on Rails (API only)
- PostgreSQL
- JWT for authentication
- Caxlsx for Excel generation

---

## Installation

### Backends


```bash
cd backend/expense-tracker-api
bundle install
rails db:create db:migrate
rails server 

### Frontend
cd frontend/expense-tracker
npm install
npm run dev

### License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for more information.
