import React from 'react';
import './RecipeList.css';

const RecipeList = ({ recipes }) => {
  return (
    <div>
      {recipes.length > 0 ? (
        recipes.map((recipe) => (
          <div key={recipe.id} className="recipe-card">
            <h2>{recipe.title}</h2>
            <p className="category">Category: {recipe.category || 'Unknown'}</p>
            <p className="author">Author: {recipe.author || 'Unknown'}</p>
            <p className="ratings">Ratings: {recipe.ratings || 'No ratings'}</p>
            <p>Cook Time: {recipe.cook_time} mins</p>
            <p>Prep Time: {recipe.prep_time} mins</p>
            <h4>Ingredients:</h4>
            <ul>
              {recipe.ingredients.map((ingredient, index) => (
                <li key={index}>
                  {ingredient.quantity} {ingredient.measurement}{' '}
                  {ingredient.name} {ingredient.details}
                </li>
              ))}
            </ul>
          </div>
        ))
      ) : (
        <p>No recipes found. Please add ingredients to search for recipes.</p>
      )}
    </div>
  );
};

export default RecipeList;
