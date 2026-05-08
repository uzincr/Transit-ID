import React from 'react';
import { Shield, ArrowRight, Smartphone, Zap, Lock, CheckCircle2 } from 'lucide-react';
import { Link } from 'react-router-dom';

const LandingPage = () => {
  return (
    <div className="flex flex-col w-full overflow-hidden relative">
      {/* Background patterns */}
      <div className="absolute inset-0 z-0 opacity-20 pointer-events-none" style={{ backgroundImage: 'radial-gradient(#3b82f6 1px, transparent 1px)', backgroundSize: '40px 40px' }}></div>
      
      {/* Hero Section */}
      <section className="relative min-h-[90vh] flex items-center justify-center px-8 pt-20 pb-32 z-10">
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-primary-500/10 rounded-full blur-[120px] pointer-events-none" />
        
        <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-2 gap-16 items-center relative z-10">
          <div className="flex flex-col gap-8 text-left">
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/5 border border-white/10 w-fit backdrop-blur-md">
              <span className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
              <span className="text-sm font-medium text-slate-300">v2.0 Now Live - GAI Integrated</span>
            </div>
            
            <h1 className="font-display text-5xl md:text-7xl font-bold leading-[1.1] tracking-tight">
              The Future of <br/>
              <span className="text-gradient">Driver Licensing</span>
            </h1>
            
            <p className="text-lg md:text-xl text-slate-400 leading-relaxed max-w-xl">
              TransitID automates the entire lifecycle of taxi driver licenses. Manage expirations, renew instantly, and verify securely with our robust platform.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 mt-4">
              <Link to="/admin" className="inline-flex items-center justify-center gap-2 px-8 py-4 rounded-xl bg-white text-dark-900 font-bold hover:bg-slate-200 transition-colors shadow-[0_0_40px_rgba(255,255,255,0.3)]">
                Open Admin Portal <ArrowRight className="w-5 h-5" />
              </Link>
              <button className="inline-flex items-center justify-center gap-2 px-8 py-4 rounded-xl glass-panel text-white font-semibold hover:bg-white/10 transition-colors">
                Download App
              </button>
            </div>
            
            <div className="flex items-center gap-6 mt-8 pt-8 border-t border-white/10">
              <div className="flex flex-col">
                <span className="font-display text-3xl font-bold text-white">24k+</span>
                <span className="text-sm text-slate-400 font-medium">Active Drivers</span>
              </div>
              <div className="w-px h-12 bg-white/10" />
              <div className="flex flex-col">
                <span className="font-display text-3xl font-bold text-white">100%</span>
                <span className="text-sm text-slate-400 font-medium">Digital Verification</span>
              </div>
            </div>
          </div>
          
          <div className="relative flex justify-center lg:justify-end">
             <div className="relative group perspective-1000 w-full max-w-[450px]">
               <div className="absolute -inset-4 bg-gradient-to-r from-primary-500 to-secondary-500 rounded-[40px] blur-3xl opacity-30 group-hover:opacity-50 transition duration-1000 group-hover:duration-200" />
               <img 
                 src="/transitid_app_mockup.png" 
                 alt="TransitID Mobile App Mockup" 
                 className="relative w-full rounded-[40px] shadow-2xl ring-1 ring-white/20 transform transition-transform duration-500 group-hover:-translate-y-4 group-hover:scale-[1.02] object-cover"
               />
             </div>
             
             {/* Floating badge */}
             <div className="absolute bottom-10 -left-32 glass-panel px-6 py-4 rounded-2xl flex items-center gap-4 animate-bounce" style={{ animationDuration: '4s' }}>
               <div className="w-12 h-12 rounded-full bg-green-500/20 flex items-center justify-center text-green-400 ring-1 ring-green-500/50">
                 <CheckCircle2 className="w-6 h-6" />
               </div>
               <div>
                 <p className="font-bold text-white">Verified Identity</p>
                 <p className="text-xs text-slate-400">Yandex Go Driver</p>
               </div>
             </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-24 px-8 bg-dark-800/50 border-y border-white/5 relative z-10 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="font-display text-3xl md:text-5xl font-bold mb-6">Everything you need to <br/><span className="text-gradient">manage fleets</span></h2>
            <p className="text-slate-400 max-w-2xl mx-auto text-lg">Powerful features designed specifically for modern taxi companies, individual drivers, and regulatory authorities.</p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-dark-900/50 p-8 rounded-3xl border border-white/5 hover:border-primary-500/30 flex flex-col gap-6 group transition-all duration-300 hover:shadow-[0_0_30px_rgba(59,130,246,0.15)] hover:-translate-y-2">
              <div className="w-14 h-14 rounded-2xl bg-primary-500/10 flex items-center justify-center text-primary-400 group-hover:bg-primary-500 group-hover:text-white transition-colors">
                <Zap className="w-7 h-7" />
              </div>
              <h3 className="font-display text-xl font-bold text-white">Instant Renewal</h3>
              <p className="text-slate-400 leading-relaxed">Drivers get notified 15 days before expiration and can renew instantly via Click or Payme right from the app.</p>
            </div>
            
            <div className="bg-dark-900/50 p-8 rounded-3xl border border-white/5 hover:border-secondary-500/30 flex flex-col gap-6 group transition-all duration-300 hover:shadow-[0_0_30px_rgba(139,92,246,0.15)] hover:-translate-y-2">
              <div className="w-14 h-14 rounded-2xl bg-secondary-500/10 flex items-center justify-center text-secondary-400 group-hover:bg-secondary-500 group-hover:text-white transition-colors">
                <Shield className="w-7 h-7" />
              </div>
              <h3 className="font-display text-xl font-bold text-white">GAI Integration</h3>
              <p className="text-slate-400 leading-relaxed">Traffic police can instantly verify the authenticity of a digital license using a secure QR code scanner.</p>
            </div>
            
            <div className="bg-dark-900/50 p-8 rounded-3xl border border-white/5 hover:border-blue-500/30 flex flex-col gap-6 group transition-all duration-300 hover:shadow-[0_0_30px_rgba(59,130,246,0.15)] hover:-translate-y-2">
              <div className="w-14 h-14 rounded-2xl bg-blue-500/10 flex items-center justify-center text-blue-400 group-hover:bg-blue-500 group-hover:text-white transition-colors">
                <Lock className="w-7 h-7" />
              </div>
              <h3 className="font-display text-xl font-bold text-white">B2B Admin Control</h3>
              <p className="text-slate-400 leading-relaxed">Taxi companies get full visibility into their drivers' license statuses, compliance metrics, and automated reporting.</p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA & Footer Section */}
      <footer className="py-20 px-8 relative z-10 bg-dark-900">
        <div className="max-w-5xl mx-auto bg-gradient-to-br from-primary-900/40 to-dark-800 rounded-[40px] p-12 border border-white/10 text-center relative overflow-hidden">
          <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] opacity-10"></div>
          <div className="relative z-10">
            <h2 className="font-display text-4xl font-bold text-white mb-6">Ready to digitize your workflow?</h2>
            <p className="text-slate-400 text-lg mb-10 max-w-2xl mx-auto">Join thousands of drivers and companies who have already switched to TransitID for seamless license management.</p>
            <button className="px-10 py-4 rounded-xl bg-white text-dark-900 font-bold text-lg hover:scale-105 transition-transform shadow-[0_0_30px_rgba(255,255,255,0.2)]">
              Get Started Now
            </button>
          </div>
        </div>
        <div className="max-w-7xl mx-auto mt-16 flex flex-col md:flex-row justify-between items-center border-t border-white/10 pt-8 text-slate-500 text-sm">
          <p>© 2026 TransitID by Ecos. All rights reserved.</p>
          <div className="flex gap-6 mt-4 md:mt-0">
            <a href="#" className="hover:text-white transition-colors">Privacy Policy</a>
            <a href="#" className="hover:text-white transition-colors">Terms of Service</a>
            <a href="#" className="hover:text-white transition-colors">Support</a>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default LandingPage;
