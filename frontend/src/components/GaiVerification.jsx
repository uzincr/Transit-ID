import React, { useState } from 'react';
import { Search, CheckCircle, AlertCircle, ShieldAlert } from 'lucide-react';

export default function GaiVerification() {
  const [licenseId, setLicenseId] = useState('TID-8842109');
  const [result, setResult] = useState(null);

  const handleVerify = (e) => {
    e.preventDefault();
    if (licenseId.trim() === 'TID-8842109') {
      setResult({
        status: 'ACTIVE',
        name: 'SAMUEL R. ADAMS',
        vehicle: 'CHEVROLET LACETTI (01 A 777 AA)',
        expiry: '12 MAY 2026',
        medicalCheck: 'O\'TLGAN (01.08.2026)',
        techCheck: 'O\'TLGAN (02.08.2026)'
      });
    } else {
      setResult({
        status: 'NOT_FOUND',
        message: 'Kiritilgan ID bo\'yicha faol litsenziya topilmadi'
      });
    }
  };

  return (
    <section id="gai" className="py-20 px-6 max-w-5xl mx-auto">
      <div className="bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-2xl relative overflow-hidden">
        <div className="text-center mb-8">
          <span className="text-xs font-bold text-blue-400 tracking-widest uppercase mb-2 block">GAI Interaktiv Modul</span>
          <h2 className="text-2xl md:text-3xl font-bold text-white mb-2">Litsenziya Holatini Onlayn Tekshirish</h2>
          <p className="text-slate-400 text-sm">Haydovchining litsenziya kodi (masalan: TID-8842109) bo'yicha tekshiruv o'tkazing</p>
        </div>

        <form onSubmit={handleVerify} className="flex flex-col sm:flex-row gap-3 max-w-xl mx-auto mb-8">
          <input 
            type="text" 
            value={licenseId} 
            onChange={(e) => setLicenseId(e.target.value)}
            className="flex-1 bg-slate-950 border border-slate-700 rounded-xl px-4 py-3 text-white focus:outline-none focus:border-blue-500 font-mono text-sm"
            placeholder="Litsenziya ID (masalan: TID-8842109)..."
          />
          <button type="submit" className="px-6 py-3 rounded-xl bg-blue-600 hover:bg-blue-500 text-white font-bold transition flex items-center justify-center gap-2">
            <Search className="w-4 h-4" /> Tekshirish
          </button>
        </form>

        {result && (
          <div className="max-w-xl mx-auto p-5 rounded-2xl bg-slate-950 border border-slate-800">
            {result.status === 'ACTIVE' ? (
              <div>
                <div className="flex items-center justify-between border-b border-slate-800 pb-3 mb-3">
                  <span className="flex items-center gap-2 text-green-400 font-bold text-sm">
                    <CheckCircle className="w-5 h-5" /> FAOL LITSENZIYA (VERIFIED)
                  </span>
                  <span className="text-xs font-mono text-slate-400">AMAL QILADI</span>
                </div>
                <div className="space-y-2 text-xs md:text-sm">
                  <div className="flex justify-between"><span className="text-slate-400">Haydovchi:</span><span className="text-white font-bold">{result.name}</span></div>
                  <div className="flex justify-between"><span className="text-slate-400">Avtomobil:</span><span className="text-white font-mono">{result.vehicle}</span></div>
                  <div className="flex justify-between"><span className="text-slate-400">Amal qilish muddati:</span><span className="text-white">{result.expiry}</span></div>
                  <div className="flex justify-between"><span className="text-slate-400">Tibbiy ko'rik:</span><span className="text-green-400">{result.medicalCheck}</span></div>
                  <div className="flex justify-between"><span className="text-slate-400">Texnik ko'rik:</span><span className="text-green-400">{result.techCheck}</span></div>
                </div>
              </div>
            ) : (
              <div className="flex items-center gap-3 text-red-400 font-semibold text-sm">
                <AlertCircle className="w-5 h-5" /> {result.message}
              </div>
            )}
          </div>
        )}
      </div>
    </section>
  );
}
