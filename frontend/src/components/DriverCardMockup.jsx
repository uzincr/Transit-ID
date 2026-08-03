import React from 'react';

export default function DriverCardMockup() {
  return (
    <div className="relative group w-full max-w-[380px]">
      <div className="absolute -inset-4 bg-gradient-to-r from-blue-500 to-purple-600 rounded-[40px] blur-3xl opacity-30 group-hover:opacity-50 transition duration-1000" />
      <div className="relative bg-slate-900 rounded-[40px] p-3 ring-1 ring-white/20 shadow-2xl transform transition-transform duration-500 group-hover:-translate-y-2">
        <div className="bg-slate-950 rounded-[32px] overflow-hidden">
          {/* Status Bar */}
          <div className="flex justify-between items-center px-6 pt-4 pb-2">
            <span className="text-xs text-slate-400 font-medium">9:41</span>
            <div className="flex gap-1">
              <div className="w-4 h-2 rounded-sm bg-slate-500" />
              <div className="w-4 h-2 rounded-sm bg-slate-500" />
              <div className="w-6 h-3 rounded-sm bg-green-400/80" />
            </div>
          </div>

          {/* App Header */}
          <div className="text-center py-4">
            <span className="bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent font-extrabold text-xl tracking-wider">TransitID</span>
            <p className="text-[10px] text-slate-500 tracking-[3px] mt-1 uppercase">Taxi Driver Verification</p>
          </div>

          {/* Driver Info */}
          <div className="flex flex-col items-center pb-4">
            <div className="w-16 h-16 rounded-full bg-gradient-to-br from-blue-500 to-purple-500 p-[2px]">
              <div className="w-full h-full rounded-full bg-slate-900 flex items-center justify-center text-2xl font-bold text-white">SA</div>
            </div>
            <p className="text-sm font-bold text-white mt-3 tracking-wide">SAMUEL R. ADAMS</p>
            <p className="text-xs text-blue-400 font-mono mt-1">TID-8842109</p>
          </div>

          {/* Digital License */}
          <div className="mx-4 p-4 rounded-2xl bg-slate-900/80 border border-white/10 mb-4">
            <div className="flex justify-between items-center mb-3">
              <span className="text-xs font-bold text-slate-300 tracking-wider">DIGITAL LICENSE</span>
              <span className="text-[10px] px-2 py-0.5 rounded bg-green-500/20 text-green-400 font-bold border border-green-500/30">ACTIVE</span>
            </div>
            <div className="grid grid-cols-2 gap-2 text-xs">
              <div><span className="text-slate-500">Amal Qilish</span><p className="text-white font-medium">12 MAY 2026</p></div>
              <div><span className="text-slate-500">Toifa</span><p className="text-white font-medium">B (Taxi)</p></div>
            </div>
          </div>

          {/* QR Verification */}
          <div className="flex flex-col items-center pb-6">
            <div className="w-20 h-20 bg-white rounded-xl flex items-center justify-center mb-2 p-2">
              <svg viewBox="0 0 64 64" className="w-16 h-16">
                <rect x="4" y="4" width="16" height="16" rx="2" fill="#0f172a"/>
                <rect x="44" y="4" width="16" height="16" rx="2" fill="#0f172a"/>
                <rect x="4" y="44" width="16" height="16" rx="2" fill="#0f172a"/>
                <rect x="8" y="8" width="8" height="8" rx="1" fill="#3b82f6"/>
                <rect x="48" y="8" width="8" height="8" rx="1" fill="#3b82f6"/>
                <rect x="8" y="48" width="8" height="8" rx="1" fill="#8b5cf6"/>
                <rect x="28" y="24" width="8" height="8" rx="1" fill="#0f172a"/>
              </svg>
            </div>
            <span className="text-[10px] text-slate-400 tracking-widest uppercase">GAI QR TEKSHIRUV</span>
          </div>
        </div>
      </div>
    </div>
  );
}
