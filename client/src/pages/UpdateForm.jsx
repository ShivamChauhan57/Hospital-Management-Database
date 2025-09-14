import React, { useState, useEffect } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { Box, TextField, Button, Typography } from '@mui/material';
import API from '../api';

export default function UpdateForm() {
  const { table } = useParams();                // Get table name from URL
  const navigate = useNavigate();               // Navigation hook
  const location = useLocation();               // Used to access row data from state

  // Initialize form state with selected row data
  const [form, setForm] = useState(location.state?.row || {});

  // Redirect to table if no row is provided (e.g., page refresh)
  useEffect(() => {
    if (!location.state?.row) {
      alert('No row selected for update. Please return to the table.');
      navigate(`/crud/${table}`);
    }
  }, [location.state, navigate, table]);

  // Submit updated data to the server
  const handleSubmit = async () => {
    try {
      await API.put(`/crud/${table}`, form);
      navigate(`/crud/${table}`); // Navigate back to the same table
    } catch (err) {
      alert(err.response?.data?.error || err.message);
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>{`Update ${table}`}</Typography>

      {/* Generate form fields dynamically */}
      <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, maxWidth: 600 }}>
        {Object.keys(form).map((field) => (
          <TextField
            key={field}
            label={field}
            value={form[field] ?? ''}
            onChange={(e) => setForm({ ...form, [field]: e.target.value })}
          />
        ))}

        {/* Submit and Cancel buttons */}
        <Button variant="contained" onClick={handleSubmit}>Update</Button>
        <Button variant="text" onClick={() => navigate(`/crud/${table}`)}>Cancel</Button>
      </Box>
    </Box>
  );
}
