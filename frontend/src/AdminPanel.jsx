import React, { useState } from 'react';
import { Users, CreditCard, FileText, Settings, Activity, Search, Bell, MoreVertical, Plus, Filter } from 'lucide-react';
import { Link, useLocation, Routes, Route, useNavigate } from 'react-router-dom';

// --- MOCK DATA ---
const MOCK_DRIVERS = [
  { id: 1, name: 'Aliyev Vali', phone: '+998901234567', company: 'Yandex Go', status: 'Active', joined: '2025-10-12' },
  { id: 2, name: 'Rustamov Aziz', phone: '+998911234567', company: 'MyTaxi', status: 'Inactive', joined: '2025-11-05' },
  { id: 3, name: 'Sobirov Jasur', phone: '+998931234567', company: 'Uklon', status: 'Active', joined: '2026-01-20' },
  { id: 4, name: 'Qodirov Murod', phone: '+998941234567', company: 'Independent', status: 'Banned', joined: '2026-02-15' },
];

const MOCK_LICENSES = [
  { id: 'TR-82910', driver: 'Aliyev Vali', issueDate: '2025-06-15', expiryDate: '2026-06-15', status: 'Active' },
  { id: 'TR-71029', driver: 'Rustamov Aziz', issueDate: '2025-05-18', expiryDate: '2026-05-18', status: 'Expiring' },
  { id: 'TR-90212', driver: 'Sobirov Jasur', issueDate: '2025-04-30', expiryDate: '2026-04-30', status: 'Expired' },
];

// --- COMPONENTS ---

const DashboardHome = () => (
  <div>
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group">
        <div className="absolute top-0 right-0 w-32 h-32 bg-primary-500/10 rounded-full blur-2xl -mr-10 -mt-10 group-hover:bg-primary-500/20 transition-colors" />
        <div className="flex justify-between items-start mb-4 relative z-10">
          <span className="text-sm font-bold text-slate-400 uppercase tracking-wider">Total Active Licenses</span>
          <div className="p-2 bg-primary-500/10 rounded-lg text-primary-400">
            <FileText className="w-5 h-5" />
          </div>
        </div>
        <span className="text-4xl font-display font-bold text-white relative z-10">24,592</span>
        <div className="mt-4 flex items-center gap-2 text-sm relative z-10">
          <span className="text-green-400 font-medium">+12.5%</span>
          <span className="text-slate-500">from last month</span>
        </div>
      </div>
      
      <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group">
        <div className="absolute top-0 right-0 w-32 h-32 bg-amber-500/10 rounded-full blur-2xl -mr-10 -mt-10 group-hover:bg-amber-500/20 transition-colors" />
        <div className="flex justify-between items-start mb-4 relative z-10">
          <span className="text-sm font-bold text-slate-400 uppercase tracking-wider">Expiring Soon</span>
          <div className="p-2 bg-amber-500/10 rounded-lg text-amber-400">
            <Activity className="w-5 h-5" />
          </div>
        </div>
        <span className="text-4xl font-display font-bold text-amber-400 relative z-10">1,204</span>
        <div className="mt-4 flex items-center gap-2 text-sm relative z-10">
          <span className="text-red-400 font-medium">+5.2%</span>
          <span className="text-slate-500">needs attention</span>
        </div>
      </div>
      
      <div className="glass-panel p-6 rounded-2xl relative overflow-hidden group">
        <div className="absolute top-0 right-0 w-32 h-32 bg-green-500/10 rounded-full blur-2xl -mr-10 -mt-10 group-hover:bg-green-500/20 transition-colors" />
        <div className="flex justify-between items-start mb-4 relative z-10">
          <span className="text-sm font-bold text-slate-400 uppercase tracking-wider">Total Revenue</span>
          <div className="p-2 bg-green-500/10 rounded-lg text-green-400">
            <CreditCard className="w-5 h-5" />
          </div>
        </div>
        <span className="text-4xl font-display font-bold text-white relative z-10">1.2B <span className="text-xl text-slate-500">UZS</span></span>
        <div className="mt-4 flex items-center gap-2 text-sm relative z-10">
          <span className="text-green-400 font-medium">+8.1%</span>
          <span className="text-slate-500">from last month</span>
        </div>
      </div>
    </div>

    <div className="glass-panel rounded-2xl overflow-hidden">
      <div className="px-6 py-5 border-b border-white/5 flex justify-between items-center">
        <h2 className="text-lg font-bold text-white">Recent License Activity</h2>
        <Link to="/admin/licenses" className="text-sm font-medium text-primary-400 hover:text-primary-300 transition-colors">View All</Link>
      </div>
      <div className="w-full overflow-x-auto">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-white/[0.02]">
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Driver Name</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">License ID</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Expiry Date</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Status</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {MOCK_LICENSES.map((lic) => (
              <tr key={lic.id} className="hover:bg-white/[0.02] transition-colors">
                <td className="px-6 py-4 whitespace-nowrap font-medium text-slate-200">{lic.driver}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400 font-mono">{lic.id}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{lic.expiryDate}</td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold border ${
                    lic.status === 'Active' ? 'bg-green-500/10 text-green-400 border-green-500/20' :
                    lic.status === 'Expiring' ? 'bg-amber-500/10 text-amber-400 border-amber-500/20' :
                    'bg-red-500/10 text-red-400 border-red-500/20'
                  }`}>
                    {lic.status}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  </div>
);

const DriversList = ({ searchQuery }) => {
  const filtered = MOCK_DRIVERS.filter(d => d.name.toLowerCase().includes(searchQuery.toLowerCase()) || d.phone.includes(searchQuery));
  
  return (
    <div className="glass-panel rounded-2xl overflow-hidden flex flex-col h-full">
      <div className="px-6 py-5 border-b border-white/5 flex justify-between items-center bg-dark-800/50">
        <h2 className="text-lg font-bold text-white">Driver Management</h2>
        <div className="flex gap-3">
          <button className="flex items-center gap-2 px-4 py-2 rounded-lg bg-white/5 hover:bg-white/10 text-slate-300 transition-colors border border-white/10">
            <Filter size={16} /> Filter
          </button>
          <button className="flex items-center gap-2 px-4 py-2 rounded-lg bg-primary-600 hover:bg-primary-500 text-white transition-colors">
            <Plus size={16} /> Add Driver
          </button>
        </div>
      </div>
      <div className="w-full overflow-x-auto flex-1">
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-white/[0.02]">
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Name</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Phone</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Company</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Joined Date</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">Status</th>
              <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider text-right">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.length > 0 ? filtered.map((driver) => (
              <tr key={driver.id} className="hover:bg-white/[0.02] transition-colors cursor-pointer group">
                <td className="px-6 py-4 whitespace-nowrap font-medium text-slate-200 group-hover:text-primary-400 transition-colors">{driver.name}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{driver.phone}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{driver.company}</td>
                <td className="px-6 py-4 whitespace-nowrap text-slate-400">{driver.joined}</td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold border ${
                    driver.status === 'Active' ? 'bg-green-500/10 text-green-400 border-green-500/20' :
                    driver.status === 'Inactive' ? 'bg-slate-500/10 text-slate-400 border-slate-500/20' :
                    'bg-red-500/10 text-red-400 border-red-500/20'
                  }`}>
                    {driver.status}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-slate-500">
                  <button className="hover:text-white transition-colors p-2 rounded-lg hover:bg-white/10"><MoreVertical className="w-5 h-5" /></button>
                </td>
              </tr>
            )) : (
              <tr><td colSpan="6" className="text-center py-10 text-slate-500">No drivers found matching "{searchQuery}"</td></tr>
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
    <button className="mt-8 px-6 py-3 bg-primary-600 hover:bg-primary-500 text-white rounded-xl transition-colors font-medium">
      Create New {title.split(' ')[0]}
    </button>
  </div>
);

// --- MAIN ADMIN LAYOUT ---

const AdminPanel = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');

  const navItems = [
    { name: 'Dashboard', path: '/admin', icon: Activity },
    { name: 'Drivers', path: '/admin/users', icon: Users },
    { name: 'Licenses', path: '/admin/licenses', icon: FileText },
    { name: 'Payments', path: '/admin/payments', icon: CreditCard },
  ];

  return (
    <div className="flex flex-1 h-[calc(100vh-80px)] overflow-hidden bg-dark-900">
      {/* Sidebar */}
      <aside className="w-72 bg-dark-800/50 backdrop-blur-xl border-r border-white/5 flex flex-col py-6 relative z-20">
        <div className="px-6 mb-8">
          <p className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-4">Main Menu</p>
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
          <div className="h-px w-full bg-white/5 mb-6" />
          <p className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-4">System</p>
          <Link to="/admin/settings" className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 font-medium ${location.pathname === '/admin/settings' ? 'bg-primary-500/10 text-primary-400' : 'text-slate-400 hover:bg-white/5 hover:text-slate-200'}`}>
            <Settings className="w-5 h-5" />
            Settings
          </Link>
        </div>
      </aside>
      
      {/* Main Content */}
      <main className="flex-1 overflow-y-auto p-8 relative flex flex-col">
        {/* Top Header */}
        <div className="flex justify-between items-center mb-8 shrink-0">
          <div>
            <h1 className="font-display text-3xl font-bold text-white mb-1 capitalize">
              {location.pathname === '/admin' ? 'Platform Overview' : location.pathname.split('/').pop()}
            </h1>
            <p className="text-slate-400 font-medium">Manage your {location.pathname === '/admin' ? 'platform metrics' : location.pathname.split('/').pop()} seamlessly.</p>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="relative group">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-primary-500 transition-colors" />
              <input 
                type="text" 
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Global search..." 
                className="pl-10 pr-4 py-2.5 bg-dark-800/80 border border-white/10 rounded-xl text-white placeholder-slate-500 focus:outline-none focus:border-primary-500/50 focus:ring-1 focus:ring-primary-500/50 transition-all w-64"
              />
            </div>
            <button className="w-11 h-11 rounded-xl bg-dark-800/80 border border-white/10 flex items-center justify-center text-slate-400 hover:text-white transition-colors relative">
              <Bell className="w-5 h-5" />
              <span className="absolute top-2.5 right-2.5 w-2.5 h-2.5 rounded-full bg-red-500 ring-2 ring-dark-900 border border-dark-900 animate-pulse" />
            </button>
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
            <Route path="/licenses" element={<EmptyState title="Licenses Management" desc="Full CRUD operations for driver licenses will be implemented here linked with the Spring Boot backend." icon={FileText} />} />
            <Route path="/payments" element={<EmptyState title="Payment Logs" desc="Transaction history, Click/Payme webhooks, and billing statements." icon={CreditCard} />} />
            <Route path="/settings" element={<EmptyState title="Platform Settings" desc="System configurations, API keys, and notification preferences." icon={Settings} />} />
          </Routes>
        </div>
      </main>
    </div>
  );
};

export default AdminPanel;
