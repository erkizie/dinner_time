# Dinner Time App

Dinner Time App is a Ruby on Rails-based application that manages recipes and ingredients. The application allows users to search for recipes by ingredients, making it easy to find recipes that match what they have in their pantry.

## Features

- **Recipe Management:** Store, search, and retrieve recipes along with their ingredients.
- **Ingredient Caching:** Improve performance with ingredient caching for faster access.
- **Data Seeding:** Automatically populate the database with recipes and ingredients from a JSON file.
- **Ingredient Normalization:** Ensure ingredients are standardized and duplicates are minimized during data processing.
- **API Endpoints:** Provide RESTful APIs to interact with recipes and ingredients.

---

## Application Structure

```
├── app/                      # Main Rails application directory
│   ├── controllers/          # Controllers for handling HTTP requests
│   │   ├── api/              # API namespace
│   │   │   └── v1/           # Version 1 of the API
│   │   │       ├── ingredients_controller.rb # Handles ingredients-related endpoints
│   │   │       └── recipes_controller.rb     # Handles recipe search endpoints
│   ├── helpers/              # Shared helper modules
│   │   └── response_helper.rb # Helper methods for JSON responses
│   ├── models/               # ActiveRecord models
│   │   ├── ingredient.rb     # Ingredient model
│   │   ├── recipe.rb         # Recipe model
│   │   └── recipe_ingredient.rb # Join model for recipes and ingredients
│   ├── queries/              # Query objects for complex database queries
│   │   └── recipes_query.rb  # Query object for finding recipes by ingredients
│   ├── serializers/          # JSON serialization logic
│   │   └── api/v1/recipe_serializer.rb # Serializer for recipe objects
│   └── services/             # Business logic and utilities
│       └── data_migration/   # Services for seeding and processing data
│           ├── recipe_file_splitter.rb # Splits and normalizes recipe files
│           └── recipe_seeder.rb       # Seeds recipes and ingredients into the database
├── client/                   # React front-end application
│   ├── public/               # Public static files
│   └── src/                  # React source files
│       ├── App.js            # Main React component
│       └── index.js          # React entry point
├── config/                   # Application configuration
│   ├── application.rb        # Application-level configurations
│   └── database.yml          # Database connection settings
├── db/                       # Database migrations and seeds
│   ├── migrate/              # Database schema migrations
│   ├── seeds.rb              # Seeds database with initial data
│   └── seeds/recipes-en.json # Raw recipe data for seeding
├── spec/                     # Test suite
│   ├── controllers/          # Controller tests
│   │   └── api/v1/           # Tests for API controllers
│   ├── factories/            # Test factories for models
│   ├── queries/              # Tests for query objects
│   └── support/              # Test helpers and configurations
│       ├── json_response_helper.rb # Helper for parsing JSON responses
│       └── rails_helper.rb        # RSpec setup
└── Gemfile                   # Ruby gem dependencies
```

---

## How to Run the Application

### Prerequisites

- **Docker**: For running the PostgreSQL database.
- **Ruby (3.2.x)** and **Rails (7.2.x)**
- **Node.js and Yarn**: For handling dependencies.

### Backend Setup

1. Clone the repository:

   ```bash
   git clone git@github.com:erkizie/dinner_time.git
   cd dinner_time
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Setup Docker for the database:

   ```bash
   docker-compose up -d
   ```

4. Setup the database:

   ```bash
   rails db:create db:migrate db:seed
   ```

5. Start the server:

   ```bash
   rails s
   ```

6. Access the application at `http://localhost:3000`.

### Front-End Setup

1. Navigate to the `client` directory:
   ```bash
   cd client
   ```
2. Install the Node.js dependencies:
   ```bash
   npm install
   ```
3. Start the React development server:
   ```bash
   npm start
   ```
4. Open your browser and navigate to `http://localhost:3001` (since the 3000 port is already used by the backend, React will run on port 3001) to access the front-end.

---

## How to Test the Application

1. Run RSpec tests:

   ```bash
   rspec
   ```

2. Ensure all tests pass before proceeding.

---

## API Endpoints

### **1. Fetch Ingredients**

**Endpoint:** `GET /api/v1/ingredients`

**Response:**

```json
{
  "success": true,
  "data": [
    { "id": 1, "name": "salt" },
    { "id": 2, "name": "sugar" }
  ]
}
```

### **2. Search Recipes**

**Endpoint:** `GET /api/v1/recipes/search`

**Params:**

- `ingredients`: Array of ingredient names

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Honey Cake",
      "cook_time": 45,
      "prep_time": 20,
      "ratings": 4.8,
      "cuisine": "Dessert",
      "category": "Cakes",
      "author": "John Doe",
      "ingredients": [
        {
          "quantity": "2",
          "measurement": "cups",
          "name": "flour",
          "details": ""
        }
      ]
    }
  ]
}
```

---

## User Stories

1. **As a user, I want to search for recipes by providing ingredients I have, so that I can quickly find meals to prepare.**

2. **As a user, I want to fetch a list of all available ingredients, so that I can see the options to choose from when searching for recipes.**

3. **As a developer, I want the database to be seeded with standardized recipe data, so that I can test the application reliably and showcase its features.**
