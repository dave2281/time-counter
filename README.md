# ⏱️ Time Tracker

A modern, secure task management application with real-time time tracking capabilities built with Ruby on Rails 8.## 🚀 Production Deployment

### Using Kamal (Recommended)

1. **Setup environment variables**:
```bash
cp .env.example .env
# Fill in all required values in .env
```

2. **Configure Kamal secrets**:
```bash
mkdir -p .kamal
echo "KAMAL_REGISTRY_PASSWORD=your_docker_password" > .kamal/secrets
echo "RAILS_MASTER_KEY=$(cat config/master.key)" >> .kamal/secrets
```

3. **Deploy**:
```bash
kamal setup  # First time only
kamal deploy # Subsequent deployments
```

### Manual Docker Deployment

```bash
# Build and push image
docker build -t your-registry/time-tracker .
docker push your-registry/time-tracker

# Run on server
docker run -d \
  -p 3000:3000 \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE=your_secret_key \
  -v time_tracker_db:/rails/storage \
  your-registry/time-tracker
```

## 🔐 Security Features

- ✅ CSRF Protection enabled
- ✅ Secure password hashing with BCrypt
- ✅ HttpOnly and Secure cookies
- ✅ Content Security Policy (CSP)
- ✅ Security headers (XSS, Frame options, etc.)
- ✅ Input validation and sanitization
- ✅ Rate limiting on timer operations
- ✅ User authorization on all resources
- ✅ Regular security scanning with Brakeman
- ✅ Environment variables for sensitive data
- ✅ Gitignore configured for security fileshttps://img.shields.io/badge/Rails-8.0.1-red.svg)
![Ruby](https://img.shields.io/badge/Ruby-3.3+-red.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## 🚀 Features

- **Task Management**: Create up to 20 tasks with titles, descriptions, and custom colors
- **Real-time Timers**: Start/stop timers with up to 3 concurrent active timers
- **Smart Filtering**: Filter tasks by status (New, Active, Done, All)
- **Time Logging**: Automatic daily log creation with precise timestamps
- **User Authentication**: Secure registration and login with bcrypt
- **Responsive Design**: Dark theme with glass morphism effects
- **Pagination**: Clean 4-tasks-per-page display using Pagy
- **Security**: Built-in CSRF protection, secure headers, and content security policy

## 🛠️ Tech Stack

- **Backend**: Ruby on Rails 8.0.1
- **Frontend**: Hotwire (Stimulus + Turbo)
- **Styling**: Tailwind CSS 4.0
- **Database**: SQLite (development), ready for PostgreSQL (production)
- **Authentication**: BCrypt with secure sessions
- **Caching**: Solid Cache
- **Background Jobs**: Solid Queue
- **Deployment**: Kamal + Docker ready

### Key Dependencies

- `bcrypt` - Password hashing
- `pagy` - Efficient pagination
- `tailwindcss-rails` - Utility-first CSS framework
- `solid_cache` - Database-backed caching
- `solid_queue` - Background job processing
- `brakeman` - Security vulnerability scanner
- `rspec-rails` - Testing framework

## 📋 Prerequisites

- Ruby 3.3 or higher
- Node.js 18+ and npm
- SQLite3
- Git

## ⚡ Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/dave2281/time-counter.git
cd time-counter
```

### 2. Environment Setup

```bash
# Copy the environment variables template
cp .env.example .env

# Edit .env file and fill in your configuration
# Generate a secret key with: rails secret
```

### 3. Install dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies
npm install
```

### 4. Setup the database

```bash
# Create and migrate the database
rails db:create
rails db:migrate

# (Optional) Seed with sample data
rails db:seed
```

### 5. Build assets

```bash
# Build Tailwind CSS and JavaScript
npm run build

# Or for development with watch mode
npm run build:dev
```

### 6. Start the development server

```bash
# Start Rails server
rails server

# Or use the dev script (runs Rails + asset building)
bin/dev
```

Visit `http://localhost:3000` to access the application.

## 📱 Usage

### Creating Tasks

1. Register/Login to your account
2. Click "New Task" on the dashboard
3. Fill in title, description, and choose a color
4. Save to create your task

### Time Tracking

1. Click the "Start Timer" button on any task
2. Timer begins counting in real-time
3. You can have up to 3 active timers simultaneously
4. Click "Stop Timer" to end tracking
5. Time is automatically calculated and saved

### Task Management

- **Filter by status**: Use the filter buttons (New, Active, Done, All)
- **Mark as complete**: Check the "Finished" option when editing
- **View details**: Click on any task to see detailed view with timer controls
- **Navigate**: Use pagination to browse through your tasks

## 🔐 Security Features

- ✅ CSRF Protection enabled
- ✅ Secure password hashing with BCrypt
- ✅ HttpsOnly and Secure cookies
- ✅ Content Security Policy (CSP)
- ✅ Security headers (XSS, Frame options, etc.)
- ✅ Input validation and sanitization
- ✅ Rate limiting on timer operations
- ✅ User authorization on all resources
- ✅ Regular security scanning with Brakeman

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Dave** - [GitHub](https://github.com/dave2281)

---

⭐ **If you found this project helpful, please give it a star!**