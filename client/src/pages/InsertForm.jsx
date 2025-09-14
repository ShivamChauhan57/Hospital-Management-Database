import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Box, TextField, Button, Typography } from '@mui/material';
import API from '../api';

export default function InsertForm() {
  const { table } = useParams();
  const navigate = useNavigate();
  const [form, setForm] = useState({});

  // Fields for each table
  const tableFields = {
    patient: ['patientid', 'patientfirstname', 'patientlastname', 'dateofbirth', 'sex', 'address', 'phonenumber'],
    pharmacy: ['pharmacyid', 'pharmacylocation', 'contact'],
    medication: ['medicationid', 'medicationname', 'medicationtype', 'manufacturer', 'expirydate', 'price'],
    department: ['departmentid', 'departmentname', 'departmentphonenumber', 'departmentfaxnumber'],
    staff: ['staffid', 'enrollmentstatus', 'stafffirstname', 'stafflastname', 'staffssn', 'staffbillingnumber'],
    equipment: ['equipmentid', 'equipmentname', 'equipmentcategory', 'equipmentstock', 'departmentid'],
    prescription: ['prescriptionid', 'prescriptiondate', 'patientid', 'staffid', 'medicationid', 'pharmacyid'],
    insurancepolicy: ['insurancepolicyid', 'insurancename', 'insurancephonenumber', 'billingnumber', 'faxnumber', 'patientid'],
    invoice: ['invoiceid', 'invoiceamount', 'invoicedate', 'patientid'],
    paystub: ['paystubid', 'staffid', 'paystubdate', 'paystubamount']
  };

  // Get the fields for the selected table
  const fields = tableFields[table] || [];

  // Submit new record to backend
  const handleSubmit = async () => {
    try {
      await API.post(`/crud/${table}`, form);
      navigate(`/crud/${table}`);
    } catch (err) {
      alert(err.response?.data?.error || err.message);
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>{`Insert into ${table}`}</Typography>

      {/* Form fields */}
      <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, maxWidth: 600 }}>
        {fields.map((field) => (
          <TextField
            key={field}
            label={field}
            value={form[field] || ''}
            onChange={(e) => setForm({ ...form, [field]: e.target.value })}
          />
        ))}

        <Button variant="contained" onClick={handleSubmit}>Submit</Button>
        <Button variant="text" onClick={() => navigate(`/crud/${table}`)}>Cancel</Button>
      </Box>
    </Box>
  );
}
