import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import crud from './routes/crud.js';
import view from './routes/view.js';
import { initializeViews } from './initViews.js'; 

dotenv.config();

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/crud', crud);
app.use('/api/view', view);

initializeViews();

app.listen(PORT, () => {
  console.log(`Server running on :${PORT}`);
});
