# **Personal Budget Tracker**

A **full-stack personal budget tracker** that enables users to track income and expenses, analyze financial trends, and download records — all via a modern, responsive UI.

---

## ** Features**

- **User Authentication** (Register/Login)
- **Add, View, and Delete** Income & Expenses
- **Download Income/Expense** as Excel
- **Charts** and visualizations for financial trends
- **Secure Profile Image Upload**
- **JWT-Protected Routes**

---

## Demo Videos

Watch the feature demonstrations:

### Registration
[https://github.com/adityab39/Personal-Budget-Tracker/issues/1#issue-3213782065](https://github.com/user-attachments/assets/84161b36-754d-493c-b50b-48b4145f5f60)

### Income Page
https://github.com/user-attachments/assets/649b8452-d2a6-46f5-a9fb-bbf0bf0b76ba


### Expense Page
https://github.com/user-attachments/assets/18bd51a1-dcbd-4cc3-8a5b-e139ff4c47ab


## ** Tech Stack**

### **Frontend**
- **React.js** (Vite)
- **Tailwind CSS**
- **Recharts**
- **Axios**

### **Backend**
- **Ruby on Rails** (API Mode)
- **PostgreSQL**
- **JWT Authentication**
- **Caxlsx** (Excel Export)

---

## **Getting Started**

### **Prerequisites**
Make sure you have the following installed:
- **Ruby**
- **Rails**
- **PostgreSQL**

---

## ** Installation Instructions**

### **Backend**

```bash
cd backend/expense-tracker-api
bundle install
rails db:create db:migrate
rails server
```

### **Frontend**

```bash
cd frontend/expense-tracker
npm install
npm run dev
```

### **Folder Structure**

```bash
Personal Budget Tracker/
├── backend/
│   └── expense-tracker-api/
├── frontend/
│   └── expense-tracker/
```

### **License**
This project is licensed under the MIT License.
See the LICENSE file for details.
