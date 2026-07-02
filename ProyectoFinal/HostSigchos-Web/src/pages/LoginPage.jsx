import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, ArrowLeft } from 'lucide-react';
import './LoginPage.css';

const LoginPage = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    navigate('/dashboard');
  };

  return (
    <div className="login-page animate-fade-in">
      <div className="login-container container">
        <div className="login-card glass-panel">
          <Link to="/" className="back-link">
            <ArrowLeft size={20} /> Volver
          </Link>
          
          <div className="login-header">
            <h2>Portal Propietario</h2>
            <p>Ingresa para administrar tu hostería</p>
          </div>

          <form onSubmit={handleSubmit} className="login-form">
            <div className="input-group">
              <label className="input-label">Nombre de la Hostería</label>
              <div className="input-with-icon">
                <Mail className="input-icon" size={20} />
                <input 
                  type="text" 
                  className="input-field" 
                  placeholder="Ej: Hostería San José"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>
            </div>

            <div className="input-group">
              <label className="input-label">Contraseña</label>
              <div className="input-with-icon">
                <Lock className="input-icon" size={20} />
                <input 
                  type="password" 
                  className="input-field" 
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </div>
            </div>

            <div className="form-actions">
              <a href="#" className="forgot-password">¿Olvidaste tu contraseña?</a>
            </div>

            <button type="submit" className="btn btn-primary login-btn">
              Iniciar Sesión
            </button>
          </form>

          <div className="login-footer">
            <p>¿No tienes una cuenta? <Link to="/register" className="register-link">Regístrate</Link></p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
