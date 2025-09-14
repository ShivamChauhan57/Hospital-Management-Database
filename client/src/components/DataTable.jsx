import React, { useEffect, useState } from 'react';
import { DataGrid } from '@mui/x-data-grid';
import { Button, Typography, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import API from '../api';

export default function DataTable({ table }) {
  const [rows, setRows] = useState([]);
  const [columns, setColumns] = useState([]);
  const [selected, setSelected] = useState(null);
  const navigate = useNavigate();

  // Primary keys for each table
  const primaryKeys = {
    patient: 'patientid',
    pharmacy: 'pharmacyid',
    medication: 'medicationid',
    department: 'departmentid',
    staff: 'staffid',
    equipment: 'equipmentid',
    prescription: 'prescriptionid',
    insurancepolicy: 'insurancepolicyid',
    invoice: 'invoiceid',
    paystub: 'paystubid'
  };

  // Fetch table data and setup columns
  const fetchData = async () => {
    try {
      const { data } = await API.get(`/crud/${table}`);
      setRows(data);

      const dynamicCols = data.length > 0
        ? Object.keys(data[0]).map((key) => ({
            field: key,
            headerName: key,
            width: 150
          }))
        : [];

      setColumns(dynamicCols);
    } catch (err) {
      alert('Failed to fetch data: ' + (err.response?.data?.error || err.message));
    }
  };

  // Fetch data when table changes
  useEffect(() => {
    fetchData();
  }, [table]);

  // Delete selected row
  const handleDelete = async () => {
    if (!selected) return alert('Select a row first');

    const pk = primaryKeys[table];
    try {
      await API.delete(`/crud/${table}/${selected[pk]}`);
      await fetchData();
      setSelected(null);
    } catch (err) {
      alert('Delete failed: ' + (err.response?.data?.error || err.message));
    }
  };

  // Navigate to update form with selected row
  const handleUpdate = () => {
    if (!selected) return alert('Select a row first');
    const pk = primaryKeys[table];
    navigate(`/crud/${table}/update/${selected[pk]}`, { state: { row: selected } });
  };

  return (
    <Box sx={{ p: 2 }}>
      <Typography variant="h5" gutterBottom>{`Table: ${table}`}</Typography>

      {/* Action buttons */}
      <Box sx={{ display: 'flex', gap: 2, mb: 2 }}>
        <Button variant="contained" onClick={() => navigate(`/crud/${table}/insert`)}>Insert</Button>
        <Button variant="contained" color="warning" onClick={handleUpdate}>Update</Button>
        <Button variant="contained" color="error" onClick={handleDelete}>Delete</Button>
      </Box>

      {/* DataGrid to show table content */}
      <DataGrid
        rows={rows}
        getRowId={(row) => row[primaryKeys[table]]}
        columns={columns}
        autoHeight
        pageSize={10}
        onRowClick={(params) => setSelected(params.row)}
      />
    </Box>
  );
}
