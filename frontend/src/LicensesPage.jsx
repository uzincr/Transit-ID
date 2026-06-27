import React, { useState, useEffect } from 'react';
import { Plus, Edit, Eye } from 'lucide-react';
import { api } from './api';

const badge = (s) => {
  const statusLower = (s || '').toLowerCase();
  const c = statusLower === 'active' ? 'bg-green-500/10 text-green-400 border-green-500/20' :
    statusLower === 'expiring' ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' :
    'bg-red-500/10 text-red-400 border-red-500/20';
  return <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold border ${c}`}>{s}</span>;
};

const LicensesPage = ({ searchQuery = '' }) => {
  const [licenses, setLicenses] = useState([]);
  const [drivers, setDrivers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [showModal, setShowModal] = useState(false);
  const [selected, setSelected] = useState(null);

  // Form Fields
  const [formDriverId, setFormDriverId] = useState('');
  const [formLicenseNumber, setFormLicenseNumber] = useState('');
  const [formIssueDate, setFormIssueDate] = useState('');
  const [formExpiryDate, setFormExpiryDate] = useState('');
  const [formStatus, setFormStatus] = useState('ACTIVE');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [licList, drList] = await Promise.all([
        api.getLicenses(),
        api.getDrivers()
      ]);
      setLicenses(licList);
      setDrivers(drList.filter(d => d.role === 'DRIVER'));
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  const openCreateModal = () => {
    setSelected(null);
    setFormDriverId(drivers[0]?.id || '');
    setFormLicenseNumber('');
    setFormIssueDate(new Date().toISOString().split('T')[0]);
    
    // Default expiry 1 year from now
    const nextYear = new Date();
    nextYear.setFullYear(nextYear.getFullYear() + 1);
    setFormExpiryDate(nextYear.toISOString().split('T')[0]);
    setFormStatus('ACTIVE');
    setShowModal(true);
  };

  const openEditModal = (lic) => {
    setSelected(lic);
    setFormDriverId(lic.driverUserId || '');
    setFormLicenseNumber(lic.licenseNumber || '');
    setFormIssueDate(lic.issueDate || '');
    setFormExpiryDate(lic.expiryDate || '');
    setFormStatus(lic.status || 'ACTIVE');
    setShowModal(true);
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      const payload = {
        licenseNumber: formLicenseNumber,
        issueDate: formIssueDate,
        expiryDate: formExpiryDate,
        status: formStatus
      };

      if (selected) {
        // Update
        await api.updateLicense(selected.id, payload);
      } else {
        // Create
        await api.createLicense({
          ...payload,
          driverUserId: formDriverId
        });
      }
      setShowModal(false);
      fetchData();
    } catch (e) {
      alert('Saqlashda xatolik yuz berdi: ' + e.message);
    }
  };

  const filtered = licenses.filter(l => 
    (l.driverName || '').toLowerCase().includes(searchQuery.toLowerCase()) || 
    (l.licenseNumber || '').includes(searchQuery)
  );

  const stats = {
    total: licenses.length,
    active: licenses.filter(l => (l.status || '').toLowerCase() === 'active').length,
    expiring: licenses.filter(l => (l.status || '').toLowerCase() === 'expiring').length,
    expired: licenses.filter(l => (l.status || '').toLowerCase() === 'expired').length,
  };

  if (loading) {
    return <div className="text-center py-12 text-slate-400">Litsenziyalar yuklanmoqda...</div>;
  }

  if (error) {
    return <div className="text-center py-12 text-red-400">Xatolik: {error}</div>;
  }

  return (
    <div className="flex flex-col gap-6 h-full">
      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        {[
          { label: 'Jami', value: stats.total, color: 'text-primary-400' },
          { label: 'Faol', value: stats.active, color: 'text-green-400' },
          { label: 'Tugayapti', value: stats.expiring, color: 'text-amber-400' },
          { label: "Muddati o'tgan", value: stats.expired, color: 'text-red-400' },
        ].map(s => (
          <div key={s.label} className="glass-panel p-4 rounded-xl">
            <p className="text-xs text-slate-400 font-bold uppercase tracking-wider">{s.label}</p>
            <p className={`text-2xl font-display font-bold mt-1 ${s.color}`}>{s.value}</p>
          </div>
        ))}
      </div>

      {/* Table */}
      <div className="glass-panel rounded-2xl overflow-hidden flex-1 flex flex-col">
        <div className="px-6 py-4 border-b border-white/5 flex justify-between items-center">
          <h2 className="text-lg font-bold text-white">Litsenziyalar ro'yxati</h2>
          <button onClick={openCreateModal}
            className="flex items-center gap-2 px-4 py-2 rounded-lg bg-primary-600 hover:bg-primary-500 text-white transition-colors">
            <Plus size={16} /> Yangi litsenziya
          </button>
        </div>
        <div className="overflow-x-auto flex-1">
          {filtered.length === 0 ? (
            <div className="text-center py-12 text-slate-500 font-medium">Litsenziyalar topilmadi.</div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-white/[0.02]">
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">ID</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Haydovchi</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Toifa</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Berilgan</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Tugash</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Holati</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider text-right">Amallar</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {filtered.map(l => (
                  <tr key={l.id} className="hover:bg-white/[0.02] transition-colors">
                    <td className="px-6 py-4 whitespace-nowrap font-mono text-primary-400 font-medium">{l.licenseNumber}</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div><span className="font-medium text-slate-200">{l.driverName}</span></div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-300 font-bold">{l.classType || 'B'}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-400">{l.issueDate}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-400">{l.expiryDate}</td>
                    <td className="px-6 py-4 whitespace-nowrap">{badge(l.status)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-right">
                      <div className="flex gap-1 justify-end">
                        <button onClick={() => openEditModal(l)}
                          className="p-2 rounded-lg hover:bg-white/10 text-slate-400 hover:text-amber-400 transition-colors">
                          <Edit size={16}/>
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm" onClick={() => setShowModal(false)}>
          <form onSubmit={handleSave} className="glass-panel rounded-2xl p-8 w-full max-w-lg mx-4" onClick={e => e.stopPropagation()}>
            <h3 className="text-xl font-bold text-white mb-6">{selected ? 'Litsenziyani tahrirlash' : 'Yangi litsenziya'}</h3>
            <div className="flex flex-col gap-4">
              {!selected && (
                <div>
                  <label className="text-xs text-slate-400 mb-1 block">Haydovchini tanlang</label>
                  <select 
                    value={formDriverId} 
                    onChange={e => setFormDriverId(e.target.value)}
                    className="w-full px-4 py-3 bg-dark-900/80 border border-white/10 rounded-xl text-white focus:outline-none focus:border-primary-500/50"
                    required
                  >
                    {drivers.map(d => (
                      <option key={d.id} value={d.id} className="bg-dark-950 text-white">
                        {d.fullName} ({d.phone})
                      </option>
                    ))}
                  </select>
                </div>
              )}
              
              <div>
                <label className="text-xs text-slate-400 mb-1 block">Litsenziya raqami</label>
                <input 
                  placeholder="TR-XXXXX" 
                  value={formLicenseNumber}
                  onChange={e => setFormLicenseNumber(e.target.value)}
                  className="w-full px-4 py-3 bg-dark-900/80 border border-white/10 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-primary-500/50" 
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-xs text-slate-400 mb-1 block">Berilgan sana</label>
                  <input 
                    type="date" 
                    value={formIssueDate}
                    onChange={e => setFormIssueDate(e.target.value)}
                    className="w-full px-4 py-3 bg-dark-900/80 border border-white/10 rounded-xl text-white focus:outline-none focus:border-primary-500/50" 
                    required
                  />
                </div>
                <div>
                  <label className="text-xs text-slate-400 mb-1 block">Tugash sanasi</label>
                  <input 
                    type="date" 
                    value={formExpiryDate}
                    onChange={e => setFormExpiryDate(e.target.value)}
                    className="w-full px-4 py-3 bg-dark-900/80 border border-white/10 rounded-xl text-white focus:outline-none focus:border-primary-500/50" 
                    required
                  />
                </div>
              </div>

              <div>
                <label className="text-xs text-slate-400 mb-1 block">Litsenziya holati</label>
                <select 
                  value={formStatus} 
                  onChange={e => setFormStatus(e.target.value)}
                  className="w-full px-4 py-3 bg-dark-900/80 border border-white/10 rounded-xl text-white focus:outline-none focus:border-primary-500/50"
                  required
                >
                  <option value="ACTIVE" className="bg-dark-950 text-white">ACTIVE</option>
                  <option value="EXPIRING" className="bg-dark-950 text-white">EXPIRING</option>
                  <option value="EXPIRED" className="bg-dark-950 text-white">EXPIRED</option>
                </select>
              </div>
            </div>
            <div className="flex gap-3 mt-6">
              <button type="button" onClick={() => setShowModal(false)} className="flex-1 px-4 py-3 rounded-xl bg-white/5 text-slate-300 hover:bg-white/10 transition-colors border border-white/10">Bekor qilish</button>
              <button type="submit" className="flex-1 px-4 py-3 rounded-xl bg-primary-600 hover:bg-primary-500 text-white transition-colors font-medium">Saqlash</button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
};

export default LicensesPage;
