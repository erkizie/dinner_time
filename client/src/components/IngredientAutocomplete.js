import React, { useState, useEffect } from 'react';
import Autocomplete from '@mui/material/Autocomplete';
import TextField from '@mui/material/TextField';

const IngredientAutocomplete = ({
  selectedIngredients,
  onSelectIngredients,
}) => {
  const [ingredients, setIngredients] = useState([]);

  // Fetch available ingredients from the backend
  useEffect(() => {
    const fetchIngredients = async () => {
      try {
        const response = await fetch('/api/v1/ingredients');
        const data = await response.json();

        if (data.success) {
          setIngredients(data.data);
        } else {
          setIngredients([]);
        }
      } catch (error) {
        console.error('Error fetching ingredients:', error);
        setIngredients([]);
      }
    };

    fetchIngredients();
  }, []);

  // Handle ingredient selection change
  const handleSelectionChange = (event, value) => {
    if (onSelectIngredients) {
      onSelectIngredients(value.map((ingredient) => ingredient.name));
    }
  };

  return (
    <Autocomplete
      multiple
      options={ingredients}
      getOptionLabel={(option) => option.name}
      value={selectedIngredients.map(
        (name) =>
          ingredients.find((ingredient) => ingredient.name === name) || { name }
      )}
      onChange={handleSelectionChange}
      renderInput={(params) => (
        <TextField {...params} label="Ingredients" variant="outlined" />
      )}
    />
  );
};

export default IngredientAutocomplete;
