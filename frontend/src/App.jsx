import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, useLocation } from 'react-router-dom';
import LandingPage from './LandingPage';
import AdminPanel from './AdminPanel';
import { Car } from 'lucide-react';

const Navbar = () => {
  const location = useLocation();
  const isAdmin = location.pathname.startsWith('/admin');

  if (isAdmin) return null; // Admin has its own layout/sidebar

  return (
    <nav className="sticky top-0 z-50 bg-dark-900/80 backdrop-blur-xl border-b border-white/10 px-8 py-4 flex justify-between items-center transition-all">
      <Link to="/" className="flex items-center gap-3 no-underline group">
        <div className="p-2 bg-primary-500/10 rounded-xl group-hover:bg-primary-500/20 transition-colors">
          <Car className="w-8 h-8 text-primary-500" />
        </div>
        <span className="font-display font-extrabold text-2xl tracking-tight text-white">
          Transit<span className="text-primary-500">ID</span>
        </span>
      </Link>
      <div className="flex items-center gap-8">
        <Link to="/" className="font-medium text-slate-300 hover:text-white transition-colors">Home</Link>
        <Link to="/features" className="font-medium text-slate-300 hover:text-white transition-colors">Features</Link>
        <Link to="/admin" className="font-medium text-slate-300 hover:text-white transition-colors">Admin Portal</Link>
        <button className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-primary-500 to-secondary-500 text-white font-semibold shadow-lg shadow-primary-500/30 hover:shadow-primary-500/50 hover:-translate-y-0.5 transition-all">
          Login
        </button>
      </div>
    </nav>
  );
};

function App() {
  return (
    <Router>
      <div className="flex flex-col min-h-screen">
        <Navbar />
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/admin/*" element={<AdminPanel />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
