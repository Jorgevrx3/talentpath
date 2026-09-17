import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

// Pantalla 1.6.1 del informe.
// Por ahora no valida contra el backend: cualquier dato entra.
// Cuando exista la API, aqui va el fetch a POST /api/auth/login.
export default function Login() {
  const [correo, setCorreo] = useState('juan.perez@correo.com')
  const [clave, setClave] = useState('')
  const navegar = useNavigate()

  function entrar(e) {
    e.preventDefault()
    navegar('/inicio')
  }

  return (
    <div className="login">
      <div className="login-marca">
        <h1>Talent<span>Path</span></h1>
        <p>Tu currículum, tus postulaciones y tu preparación para entrevistas en un solo lugar.</p>
        <ul>
          <li>· Crea y versiona tu CV</li>
          <li>· Haz seguimiento de cada postulación</li>
          <li>· Practica entrevistas con retroalimentación</li>
        </ul>
      </div>

      <form className="login-form" onSubmit={entrar}>
        <div className="titulo">Iniciar sesión</div>
        <div className="subtitulo" style={{ marginBottom: 28 }}>
          Ingresa con tu cuenta para continuar
        </div>

        <div className="etiqueta">Correo electrónico</div>
        <input
          className="campo"
          type="email"
          value={correo}
          onChange={e => setCorreo(e.target.value)}
          placeholder="tucorreo@ejemplo.com"
          required
        />

        <div className="etiqueta">Contraseña</div>
        <input
          className="campo"
          type="password"
          value={clave}
          onChange={e => setClave(e.target.value)}
          placeholder="••••••••••"
        />

        <div className="entre" style={{ marginBottom: 22 }}>
          <label className="texto-chico">
            <input type="checkbox" /> Mantener sesión iniciada
          </label>
          <span className="enlace-mint">¿Olvidaste tu contraseña?</span>
        </div>

        <button className="boton boton-ancho" type="submit">Ingresar</button>

        <div className="centrado texto-chico" style={{ margin: '18px 0' }}>o continúa con</div>
        <button className="boton-secundario boton-ancho" type="button">Google</button>

        <div className="centrado texto-chico mt">
          ¿No tienes cuenta? <strong style={{ color: 'var(--texto-titulo)' }}>Regístrate</strong>
        </div>
      </form>
    </div>
  )
}
