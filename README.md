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

---

## Query Documentation

This query finds recipes based on available ingredients, prioritizing perfect matches (where all ingredients are available) and recipe ratings.

### Query Breakdown

#### 1. Initial Setup

```ruby
available_ingredients = @ingredients.map { |i| ActiveRecord::Base.connection.quote(i.downcase) }.join(', ')
```

- Converts ingredient array to comma-separated string
- Applies SQL injection protection via `quote`
- Converts all ingredients to lowercase for case-insensitive matching

#### 2. Select Clause

```sql
SELECT recipes.*,
CASE
  WHEN COUNT(DISTINCT ri.ingredient_id) = COUNT(DISTINCT CASE WHEN LOWER(i.name) IN (available_ingredients) THEN ri.ingredient_id END)
  THEN true
  ELSE false
END as is_perfect_match
```

- Retrieves all recipe fields
- Creates a boolean `is_perfect_match` column:
  - `true`: ALL recipe ingredients match available ingredients
  - `false`: Only SOME ingredients match
- Compares total ingredient count against matching ingredient count

#### 3. Table Joins

```sql
JOIN recipe_ingredients ri ON ri.recipe_id = recipes.id
JOIN ingredients i ON i.id = ri.ingredient_id
```

- Links recipes to ingredients through `recipe_ingredients` junction table
- Connects to `ingredients` table for ingredient names

#### 4. Grouping

```sql
GROUP BY recipes.id
```

- Groups results by recipe

#### 5. Having Clause

```sql
HAVING COUNT(DISTINCT CASE WHEN LOWER(i.name) IN (available_ingredients) THEN ri.ingredient_id END) > 0
```

- Ensures recipes have AT LEAST ONE matching ingredient
- Uses HAVING for filtering with aggregate functions

#### 6. Order Clause

```sql
ORDER BY
  CASE
    WHEN COUNT(DISTINCT ri.ingredient_id) = COUNT(DISTINCT CASE WHEN LOWER(i.name) IN (available_ingredients) THEN ri.ingredient_id END)
    THEN 0
    ELSE 1
  END,
  ratings DESC
```

- Primary sort: Perfect matches first (0 for perfect, 1 for partial)
- Secondary sort: Higher rated recipes first within each group

#### 7. Limit

```sql
LIMIT 3
```

- Returns maximum of 3 recipes

### Query Results

The query returns recipes in the following order:

1. Perfect matches (all ingredients available) sorted by highest rating
2. Partial matches (some ingredients available) sorted by highest rating
3. Maximum of 3 total recipes (For sure, we can get the limit from client as an enhancement)

This ensures users see:

- Recipes they can make immediately with available ingredients
- High-rated alternatives when perfect matches aren't available
- A manageable number of options

---

## Alternative Solution with OpenSearch

If I had more time to work on this project, I would explore using **OpenSearch** as an alternative to the current SQL-based query. OpenSearch, or its equivalent Elasticsearch, is a robust, distributed search engine that excels at handling complex search and filtering use cases.

### Benefits of Using OpenSearch

1. **Full-Text Search Capabilities:**

   - OpenSearch supports fuzzy matching, synonyms, and tokenization, enabling more flexible and forgiving ingredient search queries. For example, "flour" and "all-purpose flour" could be treated as equivalent terms. Alternatively I could make it with trigram matching.

2. **Advanced Ranking and Scoring:**

   - Recipes can be scored based on multiple criteria, such as:
     - Percentage of ingredients matched.
     - Recipe ratings.
     - Preparation and cooking time.
   - These scores can be fine-tuned to prioritize recipes that best meet user preferences.

3. **Faceted and Filtered Search:**

   - OpenSearch can provide additional filtering capabilities, such as allowing users to filter recipes by cuisine, category, or difficulty level, directly within the search interface.

4. **Performance and Scalability:**
   - OpenSearch is optimized for high-speed querying and can handle larger datasets efficiently, making it a better choice as the number of recipes and ingredients grows.

### High-Level Implementation Plan

1. **Data Indexing:**

   - Recipes and their associated ingredients would be indexed into OpenSearch. Each recipe document would include:
     - Recipe details (title, ratings, cook time, etc.).
     - List of ingredients with their quantities and measurements.
     - Metadata like cuisine and category.

2. **Search Query Design:**

   - The query would:
     - Match user-provided ingredients against the indexed ingredient list.
     - Use scoring algorithms to rank perfect matches higher than partial matches.
     - Incorporate additional fields (e.g., ratings, prep time) to further fine-tune the ranking.

3. **Integration with Rails:**

   - OpenSearch's RESTful API would be integrated into the Rails application. A service object in Rails would handle the communication with OpenSearch, transforming user input into search queries and returning the results.

4. **Enhanced User Experience:**
   - With OpenSearch, users could:
     - Get autocomplete suggestions for ingredient names.
     - Apply advanced filters (e.g., by cuisine or category).
     - View dynamically ranked and sorted recipes based on relevance.

### Why OpenSearch?

By leveraging OpenSearch, the application could provide a much richer and faster search experience, especially as the dataset grows or user requirements become more complex. While the SQL-based solution is effective for the current scope, OpenSearch would offer a scalable, future-proof alternative that aligns with modern search application standards. However, I came up with the SQL-based solution because the test assignement says not to over-engineer :)
