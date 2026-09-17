import { useParams, Link } from 'react-router-dom'
import { ofertas, misHabilidades } from '../data/mock.js'
import {
  compatibilidadPonderada, coincidencias, nivelEvidencia,
  etiquetaEvidencia, recomendaciones
} from '../data/compatibilidad.js'
import Encabezado from '../components/Encabezado.jsx'

// Pantalla 1.6.5 del informe.
export default function Compatibilidad() {
  const { id } = useParams()
  const oferta = ofertas.find(o => String(o.id) === id)

  if (!oferta) {
    return (
      <>
        <Encabezado titulo="Oferta no encontrada" />
        <Link to="/ofertas" className="boton-secundario">Volver a las ofertas</Link>
      </>
    )
  }

  const porcentaje = compatibilidadPonderada(misHabilidades, oferta)
  const evidenciados = coincidencias(misHabilidades, oferta).length
  const consejos = recomendaciones(misHabilidades, oferta)

  return (
    <>
      <Encabezado
        titulo="Análisis de compatibilidad"
        subtitulo={`${oferta.puesto} · ${oferta.empresa}`}
      >
        <Link to="/ofertas" className="boton-secundario">Ver oferta</Link>
        <button className="boton">Postular</button>
      </Encabezado>

      <div className="rejilla-2-1" style={{ gridTemplateColumns: '300px 1fr' }}>
        <div className="tarjeta tarjeta-oscura centrado" style={{ padding: '34px 22px' }}>
          <div className="etiqueta">Compatibilidad</div>
          <div style={{ fontSize: 64, fontWeight: 700, lineHeight: '78px' }}>{porcentaje}%</div>
          <div style={{ fontSize: 13, lineHeight: '21px', color: 'var(--ice)' }}>
            {evidenciados} de {oferta.requisitos.length} requisitos<br />plenamente evidenciados
          </div>
          <div style={{ borderTop: '1px solid var(--navy-medio)', margin: '22px 0 16px' }} />
          <div className="etiqueta" style={{ color: 'var(--texto-menu-suave)' }}>CV comparado</div>
          <strong>Frontend Junior</strong>
          <div style={{ fontSize: 12, color: 'var(--texto-menu-suave)', marginTop: 4 }}>
            versión del 06/09/2026
          </div>
        </div>

        <div className="columna">
          <div className="tarjeta">
            <strong style={{ fontSize: 16, color: 'var(--texto-titulo)' }}>
              Requisitos de la oferta
            </strong>
            {oferta.requisitos.map(r => {
              const ev = etiquetaEvidencia(nivelEvidencia(misHabilidades, r.nombre))
              return (
                <div className="requisito" key={r.nombre}>
                  <div className="requisito-nombre">{r.nombre}</div>
                  <div className="requisito-barra">
                    <div className="barra">
                      <div className="barra-relleno"
                           style={{ width: ev.ancho + '%', background: ev.color }} />
                    </div>
                  </div>
                  <div className="requisito-estado">
                    <span className={'insignia ' + ev.clase}>{ev.texto}</span>
                  </div>
                </div>
              )
            })}
          </div>

          <div className="tarjeta tarjeta-mint">
            <div className="etiqueta">Recomendación del asistente</div>
            {consejos.map((c, i) => (
              <div key={i} style={{ fontSize: 14, lineHeight: '23px', color: 'var(--mint-oscuro)', marginBottom: 8 }}>
                {c}
              </div>
            ))}
            <button className="boton mt" style={{ background: 'var(--mint-oscuro)' }}>
              Aplicar sugerencia al CV
            </button>
          </div>
        </div>
      </div>
    </>
  )
}
