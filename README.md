# 🏋️‍♂️ FitChallenge  
*A fitness tracking and challenge management platform built with Ruby on Rails.*

---

## 📘 Overview
**FitChallenge** is a web application designed to motivate users through challenges, progress tracking, and leaderboards.  
It allows users to participate in fitness challenges, log their workout progress, and earn points and badges as they improve.  
Admins and Creators manage the platform and challenges, ensuring a fair and organized environment for all participants.

---

## 🧱 Technologies Used
- **Ruby on Rails 8**
- **PostgreSQL** for database storage
- **Devise** for authentication (sign up, login, logout, password recovery)
- **CanCanCan** for authorization and role-based permissions
- **Bootstrap** for styling and responsive design
- **Faker** for realistic seed data generation

---

## 👤 User Roles & Permissions
The platform defines **three main user roles**, each with specific permissions and restrictions:

| Role | Description | Permissions |
|------|--------------|--------------|
| **Admin** | Manages the platform | Can manage all models (users, challenges, exercises, badges, etc.) but **cannot participate** in challenges |
| **Creator** | Creates and manages challenges | Can create/edit challenges and exercises but **cannot join challenges or log progress** |
| **User (Participant)** | Regular user focused on completing challenges | Can join challenges, log progress, and earn points/badges |

---

## 🔒 Authentication & Authorization
- Authentication is managed by **Devise**, with:
  - Sign-up, login, logout, and password recovery
  - Account editing (e.g., changing name or password)
- Authorization is handled through **CanCanCan**:
  - Access is restricted based on the user’s role
  - Unauthorized access attempts show a friendly error message

---

## 🏠 Home Dashboard
After logging in, users see a summary of platform activity:
- Total counts of users, challenges, exercises, and badges
- A list of the **latest challenges**
- A feed of recent **progress entries**
- Quick navigation to main sections via the navbar

Admins and creators see management options, while participants see participation options (e.g., “Join Challenge”).

---

## 💪 Challenges & Participation
- Users can **browse and join available challenges**
- Each challenge has:
  - A **start date** and **end date**
  - A **goal metric** (e.g., total km, reps, or weight)
  - A difficulty level
- Once joined, the user gets a **Participation** record linking them to the challenge

Creators and admins **cannot** join or log progress in challenges.

---

## 📈 Progress Tracking
Participants log their workouts through **Progress Entries**, each containing:
- The selected **Challenge**
- The chosen **Exercise**
- **Entry Date**
- **Metric Value** (e.g., “5 km”, “30 reps”)

When selecting an exercise, its **unit** (e.g., km, reps, kg) is automatically displayed.

Each new progress entry:
- Adds **points** to the user’s total
- Updates the challenge’s completion status
- Recalculates user statistics (total points, challenges completed)
- Triggers **badge checks** automatically

---

## 🏅 Badges System
Badges are automatically awarded when users reach certain milestones, such as:
- Completing a specific number of challenges
- Reaching a high total points threshold
- Logging a large number of progress entries

Badges are displayed on the user’s profile and considered in the **leaderboards**.

---

## 🏆 Leaderboards
The **Leaderboard** displays multiple rankings based on platform activity:
- **Top Users by Points**
- **Top Users by Completed Challenges**
- **Top Users by Number of Badges**
- **Top Users by Progress Entries**
- **Top Creators by Challenges Created**

Each leaderboard shows the **Top 5** users in that category.

---

## ⚙️ Forms & Validations
All create/edit forms use **Rails form helpers** with **Bootstrap styling** for usability and accessibility:
- Inline validation errors
- Required field indicators
- Clear labels and placeholders
- Drop-down menus for predefined options (e.g., exercise units)

Validation occurs both:
- **Server-side** (ActiveRecord model validations)
- **Client-side** (HTML5 validation attributes)

---

## 🧪 Data Seeding
Run:
```bash
rails db:reset
```
This will:

- Recreate the database
- Populate it with realistic data using Faker
- Create multiple users (Admins, Creators, Participants)
- Generate challenges, exercises, participations, progress entries, and badges

This seed data ensures that leaderboards, badges, and all views are fully populated for testing and demo purposes.

---

## 🚀 Setup & Run Instructions
1. **Clone the Repository**
```bash
git clone https://github.com/ErikEckell/FitChallenge
cd FitChallenge
```
2. **Install Dependencies**
```bash
bundle install
```
3. **Set Up the Database**
```bash
rails db:reset
```
4. **Start the Server**
```bash
rails server
```
5. **Open in Browser**
Go to:
👉 http://localhost:3000

---

## 🔑 Test Accounts

| Role | Email | Password |
|------|--------|-----------|
| Admin | admin@example.com | 123456 |
| Creator | creator@example.com | 123456 |
| User | participant3@example.com | 123456 |

---

## 🧭 Project Structure
```bash
app/
 ├── models/              # ActiveRecord models (User, Challenge, Participation, etc.)
 ├── controllers/         # Business logic and access control
 ├── views/               # ERB templates with Bootstrap styling
 ├── helpers/             # View helpers
 └── assets/              # Stylesheets, JS, images
db/
 ├── migrate/             # Database migrations
 └── seeds.rb             # Data seeding logic
```

---

## 🧠 Key Features Recap
✅ Full CRUD operations on all major models  
✅ Authentication (Devise)  
✅ Role-based authorization (CanCanCan)  
✅ Dynamic forms with auto-filled fields  
✅ Automatic badge awarding  
✅ Leaderboards and user statistics  
✅ Modern Bootstrap-based UI  
✅ Comprehensive data seeding  

---

## ✍️ Author
**Name:** Erik Eckell Vasquez
**Course:** Web Technologies 2025-20  
**Institution:** Universidad de Los Andes, CL
