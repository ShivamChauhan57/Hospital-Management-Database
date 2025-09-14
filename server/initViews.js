import fs from 'fs';
import path from 'path';
import { query } from './db.js';

// Auto-load SQL views from Views.txt
export async function initializeViews() {
  try {
    const viewsPath = path.resolve('views/Views.txt');
    const content = fs.readFileSync(viewsPath, 'utf-8');

    // Split SQL statements by semicolon, but filter out empty parts
    const statements = content
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0);

    for (const sql of statements) {
      console.log('Running view:', sql.slice(0, 50) + '...');
      await query(sql); // execute each CREATE VIEW statement
    }

    console.log('All views initialized.');
  } catch (err) {
    console.error('Failed to initialize views:', err.message);
  }
}
