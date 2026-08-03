import React from 'react';
import { ShieldCheck, QrCode, Smartphone, Users } from 'lucide-react';

export default function Features() {
  const featureList = [
    {
      icon: QrCode,
      title: "Lahzalik QR Verifikatsiya",
      desc: "Yo'l patrul va YHXB xodimlari haydovchining litsenziya holatini maxsus QR kodni skanerlash orqali 1 soniyada tekshirishadi."
    },
    {
      icon: ShieldCheck,
      title: "Avtomatlashtirilgan Nazorat",
      desc: "Litsenziya muddatining tugashi, tibbiy ko'rik va texnik ko'riklardan o'tganlik holati real vaqt rejimida yangilanadi."
    },
    {
      icon: Smartphone,
      title: "Raqamli Haydovchi Guvohnomasi",
      desc: "Qog'ozbozlikka chek qo'yildi — barcha ruxsatnomalar haydovchining smartfonidagi xavfsiz raqamli guvohnomada saqlanadi."
    },
    {
      icon: Users,
      title: "B2B Park Boshqaruvi",
      desc: "Taxi kompaniyalari va parklar o'z haydovchilari hamda avtomobillar flotini yagona korporativ paneldan boshqarishadi."
    }
  ];

  return (
    <section id="features" className="py-20 px-6 max-w-7xl mx-auto border-t border-slate-800">
      <div className="text-center mb-16">
        <h2 className="font-display text-3xl md:text-4xl font-bold text-white mb-4">
          Nima Uchun <span className="bg-gradient-to-r from-blue-400 to-indigo-400 bg-clip-text text-transparent">TransitID</span> Tizimi?
        </h2>
        <p className="text-slate-400 max-w-2xl mx-auto">
          Taksi va jamoat transporti sohasini raqamlashtirish bo'yicha zamonaviy infratuzilma.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        {featureList.map((f, i) => {
          const Icon = f.icon;
          return (
            <div key={i} className="bg-slate-900/60 border border-slate-800 p-6 rounded-2xl hover:border-blue-500/50 transition duration-300">
              <div className="w-12 h-12 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-400 mb-6">
                <Icon className="w-6 h-6" />
              </div>
              <h3 className="text-lg font-bold text-white mb-2">{f.title}</h3>
              <p className="text-sm text-slate-400 leading-relaxed">{f.desc}</p>
            </div>
          );
        })}
      </div>
    </section>
  );
}
