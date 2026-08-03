import React from 'react';
import { ShieldCheck, ArrowRight } from 'lucide-react';
import DriverCardMockup from './DriverCardMockup';
import { Link } from 'react-router-dom';

export default function Hero() {
  return (
    <section id="hero" className="py-16 md:py-24 px-6 max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
      <div className="lg:col-span-7 flex flex-col items-start">
        <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-sm font-semibold mb-6">
          <ShieldCheck className="w-4 h-4" />
          <span>Yo'lovchi va Haydovchi Xavfsizligi Platformasi</span>
        </div>

        <h1 className="font-display text-4xl sm:text-6xl font-extrabold text-white tracking-tight leading-[1.15] mb-6">
          Raqamlashtirilgan <span className="bg-gradient-to-r from-blue-400 via-indigo-400 to-purple-400 bg-clip-text text-transparent">Taxi Litsenziya</span> Tizimi
        </h1>

        <p className="text-slate-400 text-lg md:text-xl leading-relaxed mb-8 max-w-2xl">
          Yo'lovchi tashish faoliyatini tartibga solish, haydovchilarni QR kod orqali tezkor tekshirish va litsenziya muddatlarini avtomatik boshqarish uchun mo'ljallangan yagona B2B va GAI platformasi.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto">
          <Link to="/admin" className="px-8 py-4 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white font-bold text-lg transition-all shadow-xl shadow-blue-500/25 flex items-center justify-center gap-2">
            Boshqaruv Paneli <ArrowRight className="w-5 h-5" />
          </Link>
          <a href="#features" className="px-8 py-4 rounded-xl bg-slate-800/80 hover:bg-slate-800 text-slate-200 font-semibold text-lg border border-slate-700 transition-all text-center">
            Batafsil Ma'lumot
          </a>
        </div>
      </div>

      <div className="lg:col-span-5 flex justify-center">
        <DriverCardMockup />
      </div>
    </section>
  );
}
