import React from 'react';
import { Link } from 'react-router-dom';
import { Search, Grid, List, MapPin } from 'lucide-react';
import './LandingPage.css';

const LandingPage = () => {
  return (
    <div className="landing-page animate-fade-in">
      {/* Hero Section */}
      <header className="hero">
        <div className="hero-overlay"></div>
        <nav className="navbar container">
          <div className="logo">
            <h2>HostSigchos</h2>
          </div>
          <div className="nav-actions">
            <Link to="/login" className="btn btn-glass">
              Ingresar
            </Link>
          </div>
        </nav>
        
        <div className="hero-content container">
          <h1 className="hero-title">Descubre HostSigchos</h1>
          <p className="hero-subtitle">
            Encuentra el lugar perfecto para tu próxima aventura en la naturaleza.
          </p>
        </div>
      </header>

      {/* Search Section */}
      <section className="search-section container">
        <div className="search-bar glass-panel">
          <div className="search-input-wrapper">
            <Search className="search-icon" size={20} />
            <input 
              type="text" 
              placeholder="Buscar por nombre, ubicación..." 
              className="search-input"
            />
          </div>
          <div className="view-toggles">
            <button className="icon-btn active"><Grid size={20} /></button>
            <button className="icon-btn"><List size={20} /></button>
          </div>
        </div>
      </section>

      {/* Placeholder Hosterias Section */}
      <section className="hosterias-section container">
        <h3 className="section-title">Hosterías Destacadas</h3>
        <div className="hosterias-grid">
          {/* Mock Card 1 */}
          <div className="card hosteria-card">
            <div className="card-image-wrapper">
              <div className="placeholder-img bg-green-light"></div>
            </div>
            <div className="card-content">
              <h4>Hostería San José</h4>
              <p className="location"><MapPin size={16}/> Sigchos, Centro</p>
              <div className="card-actions">
                <span className="price">$45 / noche</span>
                <Link to="/login" className="btn btn-primary btn-sm">Ver más</Link>
              </div>
            </div>
          </div>
          
          {/* Mock Card 2 */}
          <div className="card hosteria-card">
            <div className="card-image-wrapper">
              <div className="placeholder-img bg-green-dark"></div>
            </div>
            <div className="card-content">
              <h4>EcoLodge Quilotoa</h4>
              <p className="location"><MapPin size={16}/> Chugchilán</p>
              <div className="card-actions">
                <span className="price">$60 / noche</span>
                <Link to="/login" className="btn btn-primary btn-sm">Ver más</Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default LandingPage;
