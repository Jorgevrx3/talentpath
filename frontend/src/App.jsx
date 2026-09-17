import { Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Layout.jsx'
import Login from './pages/Login.jsx'
import Dashboard from './pages/Dashboard.jsx'
import Ofertas from './pages/Ofertas.jsx'
import Compatibilidad from './pages/Compatibilidad.jsx'
import Postulaciones from './pages/Postulaciones.jsx'

// Rutas de la aplicacion. Cada ruta corresponde a una pantalla
// del apartado 1.6 del informe.
export default function App() {
  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route element={<Layout />}>
        <Route path="/inicio" element={<Dashboard />} />
        <Route path="/ofertas" element={<Ofertas />} />
        <Route path="/ofertas/:id" element={<Compatibilidad />} />
        <Route path="/postulaciones" element={<Postulaciones />} />
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
