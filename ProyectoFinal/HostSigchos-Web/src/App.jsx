import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import LandingPage from './pages/LandingPage';
import LoginPage from './pages/LoginPage';
import DashboardPropietario from './pages/DashboardPropietario';

function App() {
  return (
    <Router>
      <div className="app-layout">
        <main className="main-content">
          <Routes>
            <Route path="/" element={<LandingPage />} />
            <Route path="/login" element={<LoginPage />} />
            <Route path="/dashboard" element={<DashboardPropietario />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
