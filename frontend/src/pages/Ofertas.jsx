import { Link } from 'react-router-dom'
import { ofertas, misHabilidades } from '../data/mock.js'
import { ofertasOrdenadas, claseInsignia } from '../data/compatibilidad.js'
import Encabezado from '../components/Encabezado.jsx'

// Pantalla 1.6.4 del informe.
// Los porcentajes NO estan escritos a mano: se calculan con las mismas
// reglas del motor Prolog.
export default function Ofertas() {
  const lista = ofertasOrdenadas(misHabilidades, ofertas)

  return (
    <>
      <Encabezado
        titulo="Ofertas laborales"
        subtitulo={`${lista.length} ofertas guardadas · ordenadas por compatibilidad ponderada`}
      >
        <button className="boton">+ Agregar oferta</button>
      </Encabezado>

      <div className="tarjeta" style={{ marginBottom: 18 }}>
        <div className="fila">
          <input className="campo" style={{ marginBottom: 0 }}
                 placeholder="Buscar por puesto, empresa o tecnología…" />
          <button className="boton-secundario">Modalidad ▾</button>
          <button className="boton-secundario">Ubicación ▾</button>
        </div>
      </div>

      <div className="tarjeta">
        <div className="entre" style={{ marginBottom: 6 }}>
          <strong style={{ fontSize: 16, color: 'var(--texto-titulo)' }}>Resultados</strong>
          <span className="texto-chico">Comparadas con tu CV «Frontend Junior»</span>
        </div>

        {lista.map(o => (
          <div className="oferta" key={o.id}>
            <div className="oferta-datos">
              <div className="oferta-puesto">{o.puesto}</div>
              <div className="oferta-meta">{o.empresa} · {o.meta}</div>
            </div>
            <span className={'insignia ' + claseInsignia(o.compatibilidad)}>
              {o.compatibilidad} % compatible
            </span>
            <Link to={`/ofertas/${o.id}`} className="boton-secundario boton-chico">
              Ver análisis
            </Link>
          </div>
        ))}
      </div>
    </>
  )
}
