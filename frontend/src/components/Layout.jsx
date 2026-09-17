import { Outlet } from 'react-router-dom'
import Menu from './Menu.jsx'

// Estructura comun a todas las pantallas internas:
// menu lateral fijo + area de contenido.
export default function Layout() {
  return (
    <div className="app">
      <Menu />
      <main className="contenido">
        <Outlet />
      </main>
    </div>
  )
}
