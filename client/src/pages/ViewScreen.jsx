import React, { useEffect, useState } from 'react';
import {
  Box, Paper, Typography, MenuItem, Select, FormControl,
  InputLabel, Table, TableBody, TableCell, TableHead, TableRow
} from '@mui/material';
import API from '../api';

export default function ViewScreen() {
  const [selectedView, setSelectedView] = useState('view_patient_prescription_counts'); // default view
  const [rows, setRows] = useState([]);     // table data
  const [columns, setColumns] = useState([]); // table column headers

  // List of available views
  const viewOptions = [
    { name: 'view_patient_prescription_counts', label: 'Patient Prescription Counts' },
    { name: 'view_high_invoice_patients', label: 'High Invoice Patients' },
    { name: 'view_top_prescribing_staff', label: 'Top Prescribing Staff' },
    { name: 'view_basic_patient_info', label: 'Basic Patient Info' }
  ];

  // Fetch data from the selected view
  useEffect(() => {
    const fetchView = async () => {
      try {
        const { data } = await API.get(`/view/${selectedView}`);
        setRows(data);
        if (data.length > 0) {
          setColumns(Object.keys(data[0]));
        } else {
          setColumns([]);
        }
      } catch (err) {
        alert(err.response?.data?.error || 'Error loading view.');
      }
    };
    fetchView();
  }, [selectedView]);

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Database Views</Typography>

      {/* Dropdown to select a view */}
      <FormControl sx={{ mb: 3, minWidth: 300 }}>
        <InputLabel>Select a View</InputLabel>
        <Select
          value={selectedView}
          onChange={(e) => setSelectedView(e.target.value)}
          label="Select a View"
        >
          {viewOptions.map((view) => (
            <MenuItem key={view.name} value={view.name}>
              {view.label}
            </MenuItem>
          ))}
        </Select>
      </FormControl>

      {/* Display view data in a table */}
      <Paper sx={{ p: 2, overflow: 'auto' }}>
        {rows.length === 0 ? (
          <Typography>No data to display.</Typography>
        ) : (
          <Table>
            <TableHead>
              <TableRow>
                {columns.map((col) => (
                  <TableCell key={col} sx={{ fontWeight: 'bold' }}>{col}</TableCell>
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
        )}
      </Paper>
    </Box>
  );
}
