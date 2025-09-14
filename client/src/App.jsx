import React from 'react';
import { Routes, Route, Link } from 'react-router-dom';
import CrudScreen from './pages/CrudScreen';
import InsertForm from './pages/InsertForm';
import UpdateForm from './pages/UpdateForm';
import SelectScreen from './pages/SelectScreen';
import ViewScreen from './pages/ViewScreen';
import logo from './assets/hospital_logo.png'; 

export default function App() {
  return (
    <div style={{ padding: 20, fontFamily: 'Segoe UI, sans-serif' }}>
      <header style={{ display: 'flex', alignItems: 'center', gap: 16, marginBottom: 20 }}>
        <img src={logo} alt="Hospital Logo" style={{ height: 50 }} />
        <h1 style={{ margin: 0, fontSize: 28 }}>L'Hospital Management Database</h1>
      </header>

      <nav style={{ marginBottom: 20, display: 'flex', gap: 15 }}>
        <Link to="/crud" style={linkStyle}>Manage Records</Link>
        <Link to="/select" style={linkStyle}>Query Tables</Link>
        <Link to="/view" style={linkStyle}>Financial Reports</Link>
      </nav>

      <Routes>
        <Route path="/crud" element={<CrudScreen />} />
        <Route path="/crud/:table" element={<CrudScreen />} />
        
        <Route path="/crud/:table/insert" element={<InsertForm />} />
        <Route path="/crud/:table/update/:id" element={<UpdateForm />} />
        <Route path="/select" element={<SelectScreen />} />
        <Route path="/view" element={<ViewScreen />} />
        <Route path="*" element={<Home />} />
      </Routes>
    </div>
  );
}

const linkStyle = {
  textDecoration: 'none',
  color: '#1976d2',
  fontWeight: 'bold',
  fontSize: 18,
};

function Home() {
  return (
    <div style={{ textAlign: 'center', marginTop: 50 }}>
      <h2>Welcome to the Hospital Database Management Portal</h2>
      <p>Select an option from the menu above to get started.</p>
    </div>
  );
}
