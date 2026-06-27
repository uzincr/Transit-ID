import React, { useState, useEffect } from 'react';
import { CreditCard, Download } from 'lucide-react';
import { api } from './api';

const badge = (s) => {
  const statusLower = (s || '').toLowerCase();
  const c = statusLower === 'success' || statusLower === 'completed' ? 'bg-green-500/10 text-green-400 border-green-500/20' :
    statusLower === 'pending' ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' :
    'bg-red-500/10 text-red-400 border-red-500/20';
  return <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold border ${c}`}>{s}</span>;
};

const fmt = (n) => {
  if (!n) return '0';
  return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
};

const PaymentsPage = ({ searchQuery = '' }) => {
  const [payments, setPayments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchPayments();
  }, []);

  const fetchPayments = async () => {
    try {
      setLoading(true);
      const data = await api.getPayments();
      setPayments(data);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  const getDriverName = (p) => {
    if (p.user) {
      return p.user.fullName || p.user.phone || 'Noma\'lum';
    }
    return 'Noma\'lum';
  };

  const filtered = payments.filter(t => {
    const driver = getDriverName(t).toLowerCase();
    const id = (t.id || '').toLowerCase();
    const query = searchQuery.toLowerCase();
    return driver.includes(query) || id.includes(query);
  });

  const totalSuccess = payments
    .filter(t => (t.status || '').toLowerCase() === 'success')
    .reduce((a, t) => a + Number(t.amount || 0), 0);

  const countByStatus = (status) => {
    return payments.filter(t => (t.status || '').toLowerCase() === status.toLowerCase()).length;
  };

  if (loading) {
    return <div className="text-center py-12 text-slate-400">Tranzaksiyalar yuklanmoqda...</div>;
  }

  if (error) {
    return <div className="text-center py-12 text-red-400">Xatolik yuz berdi: {error}</div>;
  }

  return (
    <div className="flex flex-col gap-6 h-full">
      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="glass-panel p-5 rounded-xl">
          <p className="text-xs text-slate-400 font-bold uppercase tracking-wider">Jami tushum</p>
          <p className="text-2xl font-display font-bold mt-1 text-white">{fmt(totalSuccess)} <span className="text-sm text-slate-500">UZS</span></p>
        </div>
        <div className="glass-panel p-5 rounded-xl">
          <p className="text-xs text-slate-400 font-bold uppercase tracking-wider">Muvaffaqiyatli</p>
          <p className="text-2xl font-display font-bold mt-1 text-green-400">{countByStatus('success')}</p>
        </div>
        <div className="glass-panel p-5 rounded-xl">
          <p className="text-xs text-slate-400 font-bold uppercase tracking-wider">Kutilmoqda</p>
          <p className="text-2xl font-display font-bold mt-1 text-amber-400">{countByStatus('pending')}</p>
        </div>
        <div className="glass-panel p-5 rounded-xl">
          <p className="text-xs text-slate-400 font-bold uppercase tracking-wider">Muvaffaqiyatsiz</p>
          <p className="text-2xl font-display font-bold mt-1 text-red-400">{countByStatus('failed')}</p>
        </div>
      </div>

      {/* Table */}
      <div className="glass-panel rounded-2xl overflow-hidden flex-1 flex flex-col">
        <div className="px-6 py-4 border-b border-white/5 flex justify-between items-center">
          <h2 className="text-lg font-bold text-white">Tranzaksiyalar tarixi</h2>
          <button onClick={fetchPayments} className="flex items-center gap-2 px-4 py-2 rounded-lg bg-white/5 hover:bg-white/10 text-slate-300 transition-colors border border-white/10">
            Yangilash
          </button>
        </div>
        <div className="overflow-x-auto flex-1">
          {filtered.length === 0 ? (
            <div className="text-center py-12 text-slate-500">Tranzaksiyalar topilmadi.</div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-white/[0.02]">
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">ID</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Foydalanuvchi</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Tavsif</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Summa</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Usul</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Sana</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Holati</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {filtered.map(t => (
                  <tr key={t.id} className="hover:bg-white/[0.02] transition-colors">
                    <td className="px-6 py-4 whitespace-nowrap font-mono text-slate-400 text-xs">{t.id ? t.id.substring(0, 8) : ''}</td>
                    <td className="px-6 py-4 whitespace-nowrap font-medium text-slate-200">{getDriverName(t)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-400">{t.description || 'Litsenziya yangilash'}</td>
                    <td className="px-6 py-4 whitespace-nowrap font-bold text-green-400">+{fmt(t.amount)} UZS</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className="px-2 py-1 rounded-lg bg-white/5 text-xs text-slate-300 border border-white/10 uppercase">{t.method}</span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-400">{t.createdAt ? t.createdAt.split('T')[0] : ''}</td>
                    <td className="px-6 py-4 whitespace-nowrap">{badge(t.status)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
};

export default PaymentsPage;
