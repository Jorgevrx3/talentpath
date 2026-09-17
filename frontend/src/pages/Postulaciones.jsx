import { useState } from 'react'
import { postulaciones } from '../data/mock.js'
import Encabezado from '../components/Encabezado.jsx'

// Pantalla 1.6.6 del informe.
const clasesEstado = {
  'En revisión': 'insignia-ambar',
  'Entrevista': 'insignia-azul',
  'Aceptado': 'insignia-verde',
  'Rechazado': 'insignia-coral'
}

const estados = ['Todas', 'En revisión', 'Entrevista', 'Aceptado', 'Rechazado']

export default function Postulaciones() {
  const [filtro, setFiltro] = useState('Todas')

  const lista = filtro === 'Todas'
    ? postulaciones
    : postulaciones.filter(p => p.estado === filtro)

  function contar(estado) {
    if (estado === 'Todas') return postulaciones.length
    return postulaciones.filter(p => p.estado === estado).length
  }

  return (
    <>
      <Encabezado
        titulo="Seguimiento de postulaciones"
        subtitulo={`${postulaciones.length} postulaciones registradas`}
      >
        <button className="boton">+ Registrar postulación</button>
      </Encabezado>

      <div className="filtros">
        {estados.map(e => (
          <button
            key={e}
            className={'filtro' + (filtro === e ? ' activo' : '')}
            onClick={() => setFiltro(e)}
          >
            {e} · {contar(e)}
          </button>
        ))}
      </div>

      <div className="tarjeta">
        <table>
          <thead>
            <tr>
              <th>Puesto</th><th>Empresa</th><th>CV usado</th>
              <th>Fecha</th><th>Estado</th><th>Próxima acción</th>
            </tr>
          </thead>
          <tbody>
            {lista.map(p => (
              <tr key={p.puesto}>
                <td className="fuerte">{p.puesto}</td>
                <td>{p.empresa}</td>
                <td>{p.cv}</td>
                <td>{p.fecha}</td>
                <td><span className={'insignia ' + clasesEstado[p.estado]}>{p.estado}</span></td>
                <td style={{ color: 'var(--texto-suave)' }}>{p.accion}</td>
              </tr>
            ))}
          </tbody>
        </table>
        {lista.length === 0 && (
          <div className="texto-chico" style={{ paddingTop: 16 }}>
            No hay postulaciones en este estado.
          </div>
        )}
      </div>
    </>
  )
}
