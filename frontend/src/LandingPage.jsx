import React from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Features from './components/Features';
import GaiVerification from './components/GaiVerification';
import Footer from './components/Footer';

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-[#0f172a] text-slate-100 font-sans selection:bg-blue-500 selection:text-white">
      <Navbar />
      <Hero />
      <Features />
      <GaiVerification />
      <Footer />
    </div>
  );
}
