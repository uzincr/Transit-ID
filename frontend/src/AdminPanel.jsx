import React, { useState, useEffect } from 'react';
import { Users, CreditCard, FileText, Settings, Activity, Search, Bell, MoreVertical, Plus, Filter, Key, Phone, CheckCircle, ArrowRight } from 'lucide-react';
import { Link, useLocation, Routes, Route, useNavigate } from 'react-router-dom';
import LicensesPage from './LicensesPage';
import PaymentsPage from './PaymentsPage';
import { api } from './api';

// --- DASHBOARD HOME WITH REAL DATA ---
const DashboardHome = () => {
  const [data, setData] = useState({ licenses: [], drivers: [], payments: [] });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchAll = async () => {
      try {
        const [lics, drs, pays] = await Promise.all([
          api.getLicenses(),
          api.getDrivers(),
          api.getPayments()
        ]);
        setData({ licenses: lics, drivers: drs, payments: pays });
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    };
    fetchAll();
  }, []);

  if (loading) {
    return <div className="text-slate-400 text-center py-12">Dashboard yuklanmoqda...</div>;
  }

  const activeLicensesCount = data.licenses.filter(l => (l.status || '').toLowerCase() === 'active').length;
  const expiringLicensesCount = data.licenses.filter(l => (l.status || '').toLowerCase() === 'expiring').length;
  
  const totalRevenue = data.payments
    .filter(p => (p.status || '').toLowerCase() === 'success')
    .reduce((a, b) => a + Number(b.amount || 0), 0);

  const formatRevenue = (val) => {
    if (val >= 1000000) {
      return (val / 1000000).toFixed(1) + 'M';
    }
    return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  return (
    <div>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-primary-500/10 rounded-full blur-2xl -mr-10 -mt-10 group-hover:bg-primary-500/20 transition-colors" />
          <div className="flex justify-between items-start mb-4 relative z-10">
            <span className="text-sm font-bold text-slate-400 uppercase tracking-wider">Faol litsenziyalar</span>
            <div className="p-2 bg-primary-500/10 rounded-lg text-primary-400">
              <FileText className="w-5 h-5" />
            </div>
          </div>
          <span className="text-4xl font-display font-bold text-white relative z-10">{activeLicensesCount}</span>
          <div className="mt-4 flex items-center gap-2 text-sm relative z-10">
            <span className="text-green-400 font-medium">Faol holatda</span>
          </div>
        </div>
        
        <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-amber-500/10 rounded-full blur-2xl -mr-10 -mt-10 group-hover:bg-amber-500/20 transition-colors" />
          <div className="flex justify-between items-start mb-4 relative z-10">
            <span className="text-sm font-bold text-slate-400 uppercase tracking-wider">Muddati tugayotgan</span>
            <div className="p-2 bg-amber-500/10 rounded-lg text-amber-400">
              <Activity className="w-5 h-5" />
            </div>
          </div>
          <span className="text-4xl font-display font-bold text-amber-400 relative z-10">{expiringLicensesCount}</span>
          <div className="mt-4 flex items-center gap-2 text-sm relative z-10">
            <span className="text-amber-400 font-medium">E'tibor talab qiladi</span>
          </div>
        </div>
        
        <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-green-500/10 rounded-full blur-2xl -mr-10 -mt-10 group-hover:bg-green-500/20 transition-colors" />
          <div className="flex justify-between items-start mb-4 relative z-10">
            <span className="text-sm font-bold text-slate-400 uppercase tracking-wider">Umumiy tushum</span>
            <div className="p-2 bg-green-500/10 rounded-lg text-green-400">
              <CreditCard className="w-5 h-5" />
            </div>
          </div>
          <span className="text-4xl font-display font-bold text-white relative z-10">{formatRevenue(totalRevenue)} <span className="text-xl text-slate-500">UZS</span></span>
          <div className="mt-4 flex items-center gap-2 text-sm relative z-10">
            <span className="text-green-400 font-medium">Muvaffaqiyatli to'lovlar</span>
          </div>
        </div>
      </div>

      <div className="glass-panel rounded-2xl overflow-hidden">
        <div className="px-6 py-5 border-b border-white/5 flex justify-between items-center">
          <h2 className="text-lg font-bold text-white">So'nggi faol litsenziyalar</h2>
          <Link to="/admin/licenses" className="text-sm font-medium text-primary-400 hover:text-primary-300 transition-colors">Barchasini ko'rish</Link>
        </div>
        <div className="w-full overflow-x-auto">
          {data.licenses.length === 0 ? (
            <div className="text-center py-8 text-slate-500 font-medium">Litsenziyalar mavjud emas.</div>
          ) : (
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="bg-white/[0.02]">
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Haydovchi</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Litsenziya ID</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Tugash muddati</th>
                  <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Holat</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-white/5">
                {data.licenses.slice(0, 5).map((lic) => (
                  <tr key={lic.id} className="hover:bg-white/[0.02] transition-colors">
                    <td className="px-6 py-4 whitespace-nowrap font-medium text-slate-200">{lic.driverName}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-400 font-mono">{lic.licenseNumber}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-slate-400">{lic.expiryDate}</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold border ${
                        (lic.status || '').toLowerCase() === 'active' ? 'bg-green-500/10 text-green-400 border-green-500/20' :
                        (lic.status || '').toLowerCase() === 'expiring' ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' :
                        'bg-red-500/10 text-red-400 border-red-500/20'
                      }`}>
                        {lic.status}
                      </span>
                    </td>
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

// --- DRIVERS LIST WITH REAL DATA ---
const DriversList = ({ searchQuery }) => {
  const [drivers, setDrivers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDrivers();
  }, []);

  const fetchDrivers = async () => {
    try {
      setLoading(true);
      const drs = await api.getDrivers();
      setDrivers(drs.filter(d => d.role === 'DRIVER'));
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="text-slate-400 text-center py-12">Haydovchilar yuklanmoqda...</div>;
  }

  const filtered = drivers.filter(d => 
    (d.fullName || '').toLowerCase().includes(searchQuery.toLowerCase()) || 
    (d.phone || '').includes(searchQuery)
  );
  
  return (
    <div className="glass-panel rounded-2xl overflow-hidden flex flex-col h-full">
      <div className="px-6 py-5 border-b border-white/5 flex justify-between items-center bg-dark-800/50">
        <h2 className="text-lg font-bold text-white">Haydovchilar ro'yxati</h2>
        <button onClick={fetchDrivers} className="flex items-center gap-2 px-4 py-2 rounded-lg bg-white/5 hover:bg-white/10 text-slate-300 transition-colors border border-white/10">
          Yangilash
        </button>
      </div>
      <div className="w-full overflow-x-auto flex-1">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-white/[0.02]">
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Ism familiyasi</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Telefon</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Avtomobil</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Avtoraqam</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Litsenziya toifasi</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider text-right">Rol</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.length > 0 ? filtered.map((driver) => (
              <tr key={driver.id} className="hover:bg-white/[0.02] transition-colors cursor-pointer group">
                <td className="px-6 py-4 whitespace-nowrap font-medium text-slate-200 group-hover:text-primary-400 transition-colors">{driver.fullName}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{driver.phone}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{driver.carBrand || 'Kiritilmagan'}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{driver.carNumber || 'Kiritilmagan'}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-300 font-bold">{driver.licenseClass || 'B'}</td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-slate-500">
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-primary-500/10 text-primary-400 border border-primary-500/20">{driver.role}</span>
                </td>
              </tr>
            )) : (
              <tr><td colSpan="6" className="text-center py-10 text-slate-500">Haydovchilar topilmadi: "{searchQuery}"</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

const EmptyState = ({ title, desc, icon: Icon }) => (
  <div className="flex flex-col items-center justify-center h-full text-center py-20 border border-dashed border-white/10 rounded-2xl glass-panel">
    <div className="w-20 h-20 bg-white/5 rounded-full flex items-center justify-center text-slate-400 mb-6">
      <Icon size={40} />
    </div>
    <h2 className="text-2xl font-display font-bold text-white mb-2">{title}</h2>
    <p className="text-slate-400 max-w-md">{desc}</p>
  </div>
);

// --- MAIN ADMIN LAYOUT WITH AUTHENTICATION ---
const AdminPanel = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [token, setToken] = useState(api.getToken());
  const [searchQuery, setSearchQuery] = useState('');

  // Login Form State
  const [phone, setPhone] = useState('+998991234567');
  const [otpStep, setOtpStep] = useState(false);
  const [otp, setOtp] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSendOtp = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      setError('');
      await api.sendOtp(phone);
      setOtpStep(true);
    } catch (err) {
      setError('OTP yuborishda xatolik yuz berdi. Iltimos raqamni tekshiring.');
    } finally {
      setLoading(false);
    }
  };

  const handleVerifyOtp = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      setError('');
      const data = await api.verifyOtp(phone, otp);
      setToken(data.accessToken);
    } catch (err) {
      setError('Tasdiqlash kodi noto\'g\'ri.');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    api.logout();
    setToken(null);
    setOtpStep(false);
    setOtp('');
    navigate('/admin');
  };

  if (!token) {
    // Return Glassmorphism Auth Screen
    return (
      <div className="flex-1 flex items-center justify-center min-h-[80vh] bg-dark-900 px-4 relative overflow-hidden">
        <div className="absolute top-1/4 left-1/4 w-80 h-80 bg-primary-500/10 rounded-full blur-[100px] pointer-events-none" />
        <div className="absolute bottom-1/4 right-1/4 w-80 h-80 bg-secondary-500/10 rounded-full blur-[100px] pointer-events-none" />
        
        <div className="glass-panel p-8 rounded-3xl w-full max-w-md border border-white/10 shadow-2xl relative z-10">
          <div className="flex flex-col items-center mb-8">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary-500 to-secondary-500 p-[2px] mb-4">
              <div className="w-full h-full bg-dark-900 rounded-[14px] flex items-center justify-center">
                <Key className="w-8 h-8 text-primary-400" />
              </div>
            </div>
            <h2 className="text-2xl font-bold text-white tracking-wide">Admin paneliga kirish</h2>
            <p className="text-xs text-slate-400 mt-2">TransitID boshqaruv paneli</p>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-red-500/10 border border-red-500/20 rounded-xl text-sm text-red-400 text-center font-medium">
              {error}
            </div>
          )}

          {!otpStep ? (
            <form onSubmit={handleSendOtp} className="flex flex-col gap-4">
              <div>
                <label className="text-xs text-slate-400 font-bold uppercase tracking-wider block mb-2">Telefon raqam</label>
                <div className="relative">
                  <Phone className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-500" />
                  <input 
                    type="text" 
                    value={phone} 
                    onChange={e => setPhone(e.target.value)}
                    placeholder="+998991234567" 
                    className="w-full pl-12 pr-4 py-3.5 bg-dark-950 border border-white/10 rounded-xl text-white placeholder-slate-600 focus:outline-none focus:border-primary-500/50" 
                    required 
                  />
                </div>
              </div>
              <button 
                type="submit" 
                disabled={loading}
                className="w-full py-4 bg-gradient-to-r from-primary-500 to-secondary-500 text-dark-900 font-bold rounded-xl hover:opacity-90 transition-opacity flex items-center justify-center gap-2 mt-2"
              >
                {loading ? 'Yuborilmoqda...' : 'Kirish kodini olish'} <ArrowRight className="w-5 h-5" />
              </button>
            </form>
          ) : (
            <form onSubmit={handleVerifyOtp} className="flex flex-col gap-4">
              <div>
                <div className="text-center mb-4 text-sm text-slate-300">
                  <span className="font-semibold text-primary-400">{phone}</span> raqamiga yuborilgan tasdiqlash kodini kiriting (Test kodi: <span className="font-mono text-white font-bold">123456</span>)
                </div>
                <label className="text-xs text-slate-400 font-bold uppercase tracking-wider block mb-2">Tasdiqlash kodi</label>
                <input 
                  type="text" 
                  value={otp} 
                  onChange={e => setOtp(e.target.value)}
                  placeholder="------" 
                  maxLength={6}
                  className="w-full px-4 py-3.5 bg-dark-950 border border-white/10 rounded-xl text-white text-center text-xl tracking-[1em] focus:outline-none focus:border-primary-500/50" 
                  required 
                />
              </div>
              <button 
                type="submit" 
                disabled={loading}
                className="w-full py-4 bg-gradient-to-r from-primary-500 to-secondary-500 text-dark-900 font-bold rounded-xl hover:opacity-90 transition-opacity flex items-center justify-center gap-2 mt-2"
              >
                {loading ? 'Tasdiqlanmoqda...' : 'Tasdiqlash'} <CheckCircle className="w-5 h-5" />
              </button>
              <button 
                type="button" 
                onClick={() => setOtpStep(false)}
                className="text-sm text-slate-400 hover:text-white transition-colors mt-2"
              >
                Orqaga qaytish
              </button>
            </form>
          )}
        </div>
      </div>
    );
  }

  const navItems = [
    { name: 'Dashboard', path: '/admin', icon: Activity },
    { name: 'Haydovchilar', path: '/admin/users', icon: Users },
    { name: 'Litsenziyalar', path: '/admin/licenses', icon: FileText },
    { name: 'To\'lovlar', path: '/admin/payments', icon: CreditCard },
  ];

  return (
    <div className="flex flex-1 h-[calc(100vh-80px)] overflow-hidden bg-dark-900">
      {/* Sidebar */}
      <aside className="w-72 bg-dark-800/50 backdrop-blur-xl border-r border-white/5 flex flex-col py-6 relative z-20">
        <div className="px-6 mb-8">
          <p className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-4">Asosiy menyu</p>
          <ul className="flex flex-col gap-2">
            {navItems.map((item) => {
              const isActive = location.pathname === item.path;
              const Icon = item.icon;
              return (
                <li key={item.name}>
                  <Link 
                    to={item.path} 
                    className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 font-medium ${
                      isActive 
                        ? 'bg-primary-500/10 text-primary-400 shadow-[inset_2px_0_0_var(--color-primary-500)]' 
                        : 'text-slate-400 hover:bg-white/5 hover:text-slate-200'
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    {item.name}
                  </Link>
                </li>
              );
            })}
          </ul>
        </div>
        
        <div className="px-6 mt-auto">
          <button 
            onClick={handleLogout} 
            className="w-full text-left flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 font-medium text-red-400 hover:bg-red-500/10"
          >
            Chiqish
          </button>
        </div>
      </aside>
      
      {/* Main Content */}
      <main className="flex-1 overflow-y-auto p-8 relative flex flex-col">
        {/* Top Header */}
        <div className="flex justify-between items-center mb-8 shrink-0">
          <div>
            <h1 className="font-display text-3xl font-bold text-white mb-1 capitalize">
              {location.pathname === '/admin' ? 'Boshqaruv paneli' : location.pathname.split('/').pop()}
            </h1>
            <p className="text-slate-400 font-medium">Barcha jarayonlarni onlayn kuzatish va boshqarish.</p>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="relative group">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-primary-500 transition-colors" />
              <input 
                type="text" 
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Global qidiruv..." 
                className="pl-10 pr-4 py-2.5 bg-dark-800/80 border border-white/10 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-primary-500/50 focus:ring-1 focus:ring-primary-500/50 transition-all w-64"
              />
            </div>
            <div className="w-11 h-11 rounded-xl bg-gradient-to-tr from-primary-500 to-secondary-500 p-[2px] cursor-pointer hover:shadow-[0_0_15px_rgba(59,130,246,0.5)] transition-shadow">
              <div className="w-full h-full bg-dark-900 rounded-[10px] flex items-center justify-center font-bold text-sm text-white">
                AD
              </div>
            </div>
          </div>
        </div>
        
        {/* Dynamic Content area */}
        <div className="flex-1 flex flex-col">
          <Routes>
            <Route path="/" element={<DashboardHome />} />
            <Route path="/users" element={<DriversList searchQuery={searchQuery} />} />
            <Route path="/licenses" element={<LicensesPage searchQuery={searchQuery} />} />
            <Route path="/payments" element={<PaymentsPage searchQuery={searchQuery} />} />
          </Routes>
        </div>
      </main>
    </div>
  );
};

export default AdminPanel;
