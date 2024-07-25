# Search Analytics App

This application is designed to track and analyze search queries. It logs user search inputs, displays related articles in real-time, and provides analytics on the most common queries along with the user IPs that made them. The application is built with Rails, and utilizes Redis for logging incomplete search queries and PostgreSQL for persisting data.

## Features

- Real-time search functionality with instant display of related articles.
- Logs both completed and incomplete search queries.
- Analytics dashboard showing the most common queries, counts, and user IPs.
- Uses Redis to handle incomplete search queries to optimize performance.
- PostgreSQL database for persisting complete search queries.
- Moves queries from Redis to PostgreSQL after 10 seconds of inactivity.

## Algorithm and Flow

1. **Search Input Handling**:
   - When a user types in the search input, the frontend sends the current query to the backend.
   - If the user presses Enter, the query is immediately saved to the PostgreSQL database and removed from Redis.
   - If the user doesn't press Enter, the query is logged to Redis only if it consists of more than one word to avoid logging incomplete queries.
   - After 10 seconds of inactivity, queries stored in Redis are moved to PostgreSQL.

2. **Logging and Analytics**:
   - The `SearchQueryLogger` job is responsible for logging search queries to Redis.
   - Completed search queries are persisted in PostgreSQL with their associated user IP.
   - The analytics dashboard fetches and groups queries from PostgreSQL, displaying them along with the count and user IPs.

## Requirements

- Ruby on Rails
- PostgreSQL
- Redis

## Setup

 **1- Clone the Repository**:
   ```
   git clone https://github.com/Ahmed-Yassen/search-analytics-app.git
   cd search-analytics-app
   ```

 **2- Install Dependencies**:
   ```
   bundle install
   ```

 **3- Database Setup**:
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

 **4- Environment Variables**:
 create a .env file in the root directory and add these Variables
   ```
   SEARCH_ANALYTICS_APP_DATABASE_PASSWORD=your_database_password
   REDIS_URL=your_redis_url
   ```

**6- Start the Rails Server**:
   ```
   rails s
   ```

**7- Run Sidekiq**:
   ```
   bundle exec sidekiq
   ```
