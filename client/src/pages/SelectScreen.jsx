import React, { useState, useEffect } from 'react';
import {
  Box, Select, MenuItem, Typography, Table, TableBody, TableCell,
  TableContainer, TableHead, TableRow, Paper, TextField, Button
} from '@mui/material';
import API from '../api';

export default function SelectScreen() {
  const [table, setTable] = useState('patient');     // Current selected table
  const [rows, setRows] = useState([]);              // Table data
  const [columns, setColumns] = useState([]);        // Table column names
  const [query, setQuery] = useState('');            // Custom SQL query

  const allTables = [
    'patient', 'pharmacy', 'medication', 'department', 'staff',
    'equipment', 'prescription', 'insurancepolicy', 'invoice', 'paystub'
  ];

  // Fetch default table data on load or when table changes
  useEffect(() => {
    const fetch = async () => {
      try {
        const { data } = await API.get(`/crud/${table}`);
        setRows(data);
        setColumns(data.length > 0 ? Object.keys(data[0]) : []);
        setQuery('');
      } catch (err) {
        alert(err.response?.data?.error || err.message);
      }
    };
    fetch();
  }, [table]);

  // Execute custom SELECT query
  const handleQuery = async () => {
    if (!query.toLowerCase().startsWith('select')) {
      alert('Only SELECT queries are allowed.');
      return;
    }

    try {
      const { data } = await API.post('/crud/query', { sql: query });
      setRows(data);
      setColumns(data.length > 0 ? Object.keys(data[0]) : []);
    } catch (err) {
      alert('Query failed: ' + (err.response?.data?.error || err.message));
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Select / Query</Typography>

      {/* Dropdown to select a table */}
      <Select
        label="Table"
        value={table}
        onChange={(e) => setTable(e.target.value)}
        sx={{ mb: 2, minWidth: 200 }}
      >
        {allTables.map((t) => (
          <MenuItem key={t} value={t}>{t}</MenuItem>
        ))}
      </Select>

      {/* Query input area */}
      <Box sx={{ my: 2 }}>
        <TextField
          label="Custom SELECT query"
          multiline
          fullWidth
          rows={3}
          value={query}
          onChange={(e) => setQuery(e.target.value)}
        />
        <Button onClick={handleQuery} variant="contained" sx={{ mt: 1 }}>
          Run Query
        </Button>
      </Box>

      {/* Display results in table format */}
      <TableContainer component={Paper} sx={{ maxHeight: 600, overflow: 'auto' }}>
        <Table stickyHeader size="small">
          <TableHead>
            <TableRow>
              {columns.map((col) => (
                <TableCell key={col}>{col}</TableCell>
              ))}
            </TableRow>
          </TableHead>
          <TableBody>
            {rows.map((row, idx) => (
              <TableRow key={idx}>
                {columns.map((col) => (
                  <TableCell key={col}>{row[col]}</TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
}
