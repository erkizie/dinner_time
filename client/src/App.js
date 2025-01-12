import React, { useState, useEffect } from 'react';
import IngredientAutocomplete from './components/IngredientAutocomplete';
import './App.css';

const App = () => {
  const [selectedIngredients, setSelectedIngredients] = useState([]);
  const [recipes, setRecipes] = useState([]);

  const fetchRecipes = async (ingredients) => {
    try {
      const queryString = ingredients
        .map((ingredient) => `ingredients[]=${encodeURIComponent(ingredient)}`)
        .join('&');
      const response = await fetch(`/api/v1/recipes/search?${queryString}`);
      const data = await response.json();

      if (data.success) {
        setRecipes(data.data);
      } else {
        setRecipes([]);
      }
    } catch (error) {
      console.error('Error fetching recipes:', error);
      setRecipes([]);
    }
  };

  const handleIngredientsSelected = (ingredientNames) => {
    setSelectedIngredients(ingredientNames);
    if (ingredientNames.length > 0) {
      fetchRecipes(ingredientNames);
    } else {
      setRecipes([]);
    }
  };

  return (
    <div className="App">
      <h1>Recipe Finder</h1>
      <IngredientAutocomplete
        selectedIngredients={selectedIngredients}
        onSelectIngredients={handleIngredientsSelected}
      />
      <div className="recipes">
        {recipes.length > 0 ? (
          recipes.map((recipe) => (
            <div key={recipe.id} className="recipe-card">
              <h2>{recipe.title}</h2>
              <p>
                <strong>Category:</strong> {recipe.category || 'N/A'}
              </p>
              <p>
                <strong>Author:</strong> {recipe.author || 'Unknown'}
              </p>
              <p>
                <strong>Ratings:</strong> {recipe.ratings.toFixed(2)}
              </p>
              <p>
                <strong>Cook Time:</strong> {recipe.cook_time} mins
              </p>
              <p>
                <strong>Prep Time:</strong> {recipe.prep_time} mins
              </p>
              <h3>Ingredients:</h3>
              <ul>
                {recipe.ingredients.map((ingredient, index) => (
                  <li key={index}>
                    {ingredient.quantity} {ingredient.measurement}{' '}
                    {ingredient.name}
                    {ingredient.details && ` (${ingredient.details})`}
                  </li>
                ))}
              </ul>
            </div>
          ))
        ) : (
          <p>No recipes found. Please add ingredients to search for recipes.</p>
        )}
      </div>
    </div>
  );
};

export default App;
