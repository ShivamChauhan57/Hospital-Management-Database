import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { MenuItem, Select, Typography, Box } from '@mui/material';
import DataTable from '../components/DataTable';

export default function CrudScreen() {
  const { table: paramTable } = useParams();
  const navigate = useNavigate();

  // List of all valid tables
  const allTables = [
    'patient', 'pharmacy', 'medication', 'department', 'staff',
    'equipment', 'prescription', 'insurancepolicy', 'invoice', 'paystub'
  ];

  // Determine default table from route or fallback to "patient"
  const defaultTable = allTables.includes(paramTable) ? paramTable : 'patient';
  const [table, setTable] = useState(defaultTable);

  // Handle table selection change
  const handleChange = (e) => {
    const newTable = e.target.value;
    setTable(newTable);
    navigate(`/crud/${newTable}`);
  };

  return (
    <Box sx={{ p: 2 }}>
      <Typography variant="h4" gutterBottom>HospitalDB Manager</Typography>

      {/* Dropdown for selecting a table */}
      <Select value={table} onChange={handleChange} sx={{ mb: 2 }}>
        {allTables.map((t) => (
          <MenuItem key={t} value={t}>{t}</MenuItem>
        ))}
      </Select>

      {/* Display table contents */}
      <DataTable table={table} />
    </Box>
  );
}
