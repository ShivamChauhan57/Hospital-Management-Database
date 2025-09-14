import express from 'express';
import format from 'pg-format';
import { query } from '../db.js';

const router = express.Router();

const TABLE_PRIMARY_KEYS = {
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

function getTableAndKey(table) {
  const key = TABLE_PRIMARY_KEYS[table];
  if (!key) throw new Error('Invalid or unsupported table');
  return { table, key };
}

// CUSTOM QUERY (SELECT ONLY) — MUST BE FIRST!
router.post('/query', async (req, res) => {
  const { sql } = req.body;

  if (!sql || !sql.trim().toLowerCase().startsWith('select')) {
    return res.status(400).json({ error: 'Only SELECT queries are allowed.' });
  }

  try {
    const result = await query(sql);
    res.json(result.rows);
  } catch (err) {
    console.error('Custom query failed:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// SELECT TABLE
router.get('/:table', async (req, res, next) => {
  try {
    const { table } = getTableAndKey(req.params.table);
    const result = await query(`SELECT * FROM ${format.ident(table)} LIMIT 200`);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// INSERT
router.post('/:table', async (req, res, next) => {
  try {
    const { table } = getTableAndKey(req.params.table);
    const keys = Object.keys(req.body);
    const values = Object.values(req.body);
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(',');
    const sql = format(`INSERT INTO %I (%s) VALUES (%s) RETURNING *`, table, keys.join(','), placeholders);
    const result = await query(sql, values);
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

// UPDATE
router.put('/:table', async (req, res, next) => {
  try {
    const { table, key } = getTableAndKey(req.params.table);
    if (!req.body[key.toLowerCase()]) {
      return res.status(400).json({ error: `Missing primary key field '${key}' in body` });
    }

    const keys = Object.keys(req.body);
    const values = Object.values(req.body);
    const whereValue = req.body[key.toLowerCase()];
    const updateKeys = keys.filter(k => k.toLowerCase() !== key.toLowerCase() && k !== 'id');
    const updateValues = updateKeys.map(k => req.body[k]);

    const assignments = updateKeys.map((k, i) => `${format.ident(k)} = $${i + 1}`).join(', ');
    const sql = format(`UPDATE %I SET ${assignments} WHERE %I = $${updateKeys.length + 1} RETURNING *`, table, key);

    console.log('🟡 UPDATE');
    console.log('SQL:', sql);

    const result = await query(sql, [...updateValues, whereValue]);
    res.json(result.rows[0]);
  } catch (err) {
    console.error('UPDATE failed:', err.message);
    next(err);
  }
});

// ✅ DELETE
router.delete('/:table/:id', async (req, res) => {
  try {
    const { table, key } = getTableAndKey(req.params.table);
    const id = req.params.id;

    const sql = format(`DELETE FROM %I WHERE %I = $1 RETURNING *`, table, key);

    console.log('DELETE');
    console.log('SQL:', sql);

    const result = await query(sql, [id]);

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Record not found or already deleted.' });
    }

    res.json({ success: true });
  } catch (err) {
    console.error('DELETE failed:', err.message);
    res.status(500).json({ error: err.message });
  }
});

export default router;
