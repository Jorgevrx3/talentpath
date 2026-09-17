import { Link } from 'react-router-dom'
import { usuario, indicadores, postulaciones, ofertas, misHabilidades } from '../data/mock.js'
import { brechasCriticas } from '../data/compatibilidad.js'

// Pantalla 1.6.2 del informe.
const clasesEstado = {
  'En revisión': 'insignia-ambar',
  'Entrevista': 'insignia-azul',
  'Aceptado': 'insignia-verde',
  'Rechazado': 'insignia-coral'
}

export default function Dashboard() {
  // El aviso del asistente se calcula: cuantas ofertas exigen algo
  // que el perfil no evidencia.
  const conBrecha = ofertas.filter(o => brechasCriticas(misHabilidades, o).includes('React'))

  return (
    <>
      <Encabezado />

      <div className="rejilla-4" style={{ marginBottom: 20 }}>
        {indicadores.map(i => (
          <div className="tarjeta" key={i.etiqueta}>
            <div className="etiqueta">{i.etiqueta}</div>
            <div className="indicador-valor">{i.valor}</div>
            <div className="indicador-nota">{i.nota}</div>
          </div>
        ))}
      </div>

      <div className="rejilla-2-1">
        <div className="tarjeta">
          <div className="entre" style={{ marginBottom: 10 }}>
            <strong style={{ fontSize: 16, color: 'var(--texto-titulo)' }}>
              Postulaciones recientes
            </strong>
            <Link to="/postulaciones" className="enlace-mint">Ver todas</Link>
          </div>
          <table>
            <thead>
              <tr><th>Puesto</th><th>Empresa</th><th>Fecha</th><th>Estado</th></tr>
            </thead>
            <tbody>
              {postulaciones.map(p => (
                <tr key={p.puesto}>
                  <td>{p.puesto}</td>
                  <td>{p.empresa}</td>
                  <td>{p.fecha}</td>
                  <td><span className={'insignia ' + clasesEstado[p.estado]}>{p.estado}</span></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="columna">
          <div className="tarjeta">
            <div className="etiqueta">Próxima entrevista</div>
            <strong style={{ fontSize: 17, color: 'var(--texto-titulo)' }}>Grupo Andes</strong>
            <div className="texto-chico" style={{ marginBottom: 14 }}>Martes 15 · 10:00 a. m.</div>
            <button className="boton-secundario boton-ancho">Practicar entrevista</button>
          </div>

          <div className="tarjeta tarjeta-oscura">
            <div className="etiqueta">Asistente IA</div>
            <div style={{ fontSize: 13, lineHeight: '21px', color: 'var(--ice)' }}>
              Tu CV no evidencia experiencia con React, requisito de {conBrecha.length} ofertas guardadas.
            </div>
            <Link to="/ofertas" className="enlace-mint" style={{ display: 'inline-block', marginTop: 14 }}>
              Ver recomendación →
            </Link>
          </div>
        </div>
      </div>
    </>
  )
}

function Encabezado() {
  return (
    <div className="encabezado">
      <div>
        <div className="titulo">Hola, {usuario.nombres}</div>
        <div className="subtitulo">Resumen de tu búsqueda laboral</div>
      </div>
      <button className="boton">+ Nueva postulación</button>
    </div>
  )
}
