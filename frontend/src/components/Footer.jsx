import React from 'react';
import { Shield } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="py-8 px-6 border-t border-slate-800 bg-slate-950 text-center text-xs text-slate-500">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4">
        <div className="flex items-center gap-2">
          <Shield className="w-5 h-5 text-blue-500" />
          <span className="font-display font-extrabold text-lg text-white">TransitID</span>
        </div>
        <p>© 2026 TransitID Platform. Taxi Digital Licensing & Fleet Verification System.</p>
      </div>
    </footer>
  );
}
