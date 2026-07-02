import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Home, Calendar, Users, Settings, LogOut, TrendingUp, BedDouble } from 'lucide-react';
import './Dashboard.css';

const DashboardPropietario = () => {
  const navigate = useNavigate();

  const handleLogout = () => {
    navigate('/login');
  };

  return (
    <div className="dashboard-layout animate-fade-in">
      {/* Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <h2>HostSigchos</h2>
          <p className="role-badge">Portal Propietario</p>
        </div>
        <nav className="sidebar-nav">
          <Link to="/dashboard" className="nav-item active"><Home size={20}/> Inicio</Link>
          <Link to="/dashboard" className="nav-item"><BedDouble size={20}/> Habitaciones</Link>
          <Link to="/dashboard" className="nav-item"><Calendar size={20}/> Reservas</Link>
          <Link to="/dashboard" className="nav-item"><Users size={20}/> Clientes</Link>
          <Link to="/dashboard" className="nav-item"><Settings size={20}/> Configuración</Link>
        </nav>
        <div className="sidebar-footer">
          <button onClick={handleLogout} className="btn-logout"><LogOut size={20}/> Cerrar Sesión</button>
        </div>
      </aside>

      {/* Main Content */}
      <main className="dashboard-content">
        <header className="dashboard-topbar">
          <div>
            <h1 className="page-title">Bienvenido, Hostería San José</h1>
            <p className="page-subtitle">Aquí tienes un resumen de tu actividad.</p>
          </div>
          <div className="user-profile">
            <div className="avatar bg-green-light">HJ</div>
          </div>
        </header>

        <section className="stats-grid">
          <div className="stat-card card">
            <div className="stat-icon bg-green-light"><Calendar size={24}/></div>
            <div className="stat-info">
              <h3>12</h3>
              <p>Reservas Activas</p>
            </div>
          </div>
          <div className="stat-card card">
            <div className="stat-icon bg-green-dark"><BedDouble size={24} color="white"/></div>
            <div className="stat-info">
              <h3>5</h3>
              <p>Habitaciones Libres</p>
            </div>
          </div>
          <div className="stat-card card">
            <div className="stat-icon bg-golden"><TrendingUp size={24}/></div>
            <div className="stat-info">
              <h3>$840</h3>
              <p>Ingresos del Mes</p>
            </div>
          </div>
        </section>

        <section className="recent-activity">
          <h2 className="section-title">Últimas Reservas</h2>
          <div className="card table-card">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Cliente</th>
                  <th>Fecha Ingreso</th>
                  <th>Habitación</th>
                  <th>Estado</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Juan Pérez</td>
                  <td>15 Jul 2026</td>
                  <td>Doble Premium</td>
                  <td><span className="status-badge pending">Pendiente</span></td>
                </tr>
                <tr>
                  <td>María Gómez</td>
                  <td>12 Jul 2026</td>
                  <td>Sencilla</td>
                  <td><span className="status-badge confirmed">Confirmada</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </div>
  );
};

export default DashboardPropietario;
