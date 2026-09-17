import { NavLink } from 'react-router-dom'
import { usuario } from '../data/mock.js'

// Menu lateral. Equivale al componente "Menu lateral" del archivo de Figma.
const secciones = [
  { texto: 'Inicio',        ruta: '/inicio' },
  { texto: 'Mi currículum', ruta: '/curriculum' },
  { texto: 'Ofertas',       ruta: '/ofertas' },
  { texto: 'Postulaciones', ruta: '/postulaciones' },
  { texto: 'Entrevistas',   ruta: '/entrevistas' },
  { texto: 'Asistente',     ruta: '/asistente' },
  { texto: 'Suscripción',   ruta: '/suscripcion' }
]

export default function Menu() {
  return (
    <nav className="menu">
      <div>
        <div className="menu-marca">Talent<span>Path</span></div>
        {secciones.map(s => (
          <NavLink
            key={s.ruta}
            to={s.ruta}
            className={({ isActive }) => 'menu-item' + (isActive ? ' activo' : '')}
          >
            {s.texto}
          </NavLink>
        ))}
      </div>
      <div className="menu-usuario">
        {usuario.nombres} {usuario.apellidos}<br />
        Plan {usuario.plan}
      </div>
    </nav>
  )
}
