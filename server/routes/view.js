
import express from 'express';
import format from 'pg-format';
import { query } from '../db.js';

const router = express.Router();

router.get('/:viewName', async (req, res) => {
  const { viewName } = req.params;

  const allowedViews = [
    'view_patient_prescription_counts',
    'view_high_invoice_patients',
    'view_top_prescribing_staff',
    'view_basic_patient_info'
  ];

  if (!allowedViews.includes(viewName)) {
    return res.status(400).json({ error: 'View not allowed.' });
  }

  try {
    const result = await query(`SELECT * FROM ${format.ident(viewName)}`);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
