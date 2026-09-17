// ---------------------------------------------------------------------------
// compatibilidad.js
//
// Replica en JavaScript las reglas del motor Prolog
// (prolog/base_conocimiento.pl) para que el frontend pueda mostrar el
// analisis sin depender todavia del backend.
//
// Cuando el backend este listo, estos calculos se piden a la API y el
// resultado viene del motor Prolog real. Esta version sirve mientras tanto
// y da exactamente los mismos numeros.
// ---------------------------------------------------------------------------
//Commit Pritel
// Un requisito obligatorio pesa el doble que uno deseable.
const PESO = { obligatorio: 2, deseable: 1 }

// Cuanto aporta cada nivel de evidencia.
const FACTOR = { evidenciado: 1.0, poco_evidenciado: 0.5, no_evidenciado: 0.0 }

/**
 * Clasifica cuanto evidencia el perfil una habilidad.
 * El motor considera "evidenciado" a partir del nivel 3.
 */
export function nivelEvidencia(misHabilidades, habilidad) {
  const nivel = misHabilidades[habilidad]
  if (nivel === undefined) return 'no_evidenciado'
  return nivel >= 3 ? 'evidenciado' : 'poco_evidenciado'
}

/** Requisitos de la oferta que el perfil si evidencia. */
export function coincidencias(misHabilidades, oferta) {
  return oferta.requisitos
    .filter(r => nivelEvidencia(misHabilidades, r.nombre) === 'evidenciado')
    .map(r => r.nombre)
}

/** Requisitos que el perfil no llega a evidenciar. */
export function faltantes(misHabilidades, oferta) {
  return oferta.requisitos
    .filter(r => nivelEvidencia(misHabilidades, r.nombre) !== 'evidenciado')
    .map(r => r.nombre)
}

/** Requisitos obligatorios no evidenciados: la brecha que hay que señalar. */
export function brechasCriticas(misHabilidades, oferta) {
  return oferta.requisitos
    .filter(r => r.obligatorio && nivelEvidencia(misHabilidades, r.nombre) !== 'evidenciado')
    .map(r => r.nombre)
}

/** Proporcion simple de requisitos evidenciados sobre el total. */
export function compatibilidadSimple(misHabilidades, oferta) {
  const total = oferta.requisitos.length
  if (total === 0) return 0
  return Math.round(coincidencias(misHabilidades, oferta).length * 100 / total)
}

/**
 * Version ponderada: los requisitos obligatorios pesan el doble y las
 * habilidades poco evidenciadas cuentan la mitad.
 * Es el valor que se muestra en la interfaz.
 */
export function compatibilidadPonderada(misHabilidades, oferta) {
  let obtenido = 0
  let maximo = 0
  for (const r of oferta.requisitos) {
    const peso = r.obligatorio ? PESO.obligatorio : PESO.deseable
    const evidencia = nivelEvidencia(misHabilidades, r.nombre)
    obtenido += peso * FACTOR[evidencia]
    maximo += peso
  }
  if (maximo === 0) return 0
  return Math.round(obtenido * 100 / maximo)
}

/** Ofertas ordenadas de mayor a menor compatibilidad. */
export function ofertasOrdenadas(misHabilidades, ofertas) {
  return [...ofertas]
    .map(o => ({ ...o, compatibilidad: compatibilidadPonderada(misHabilidades, o) }))
    .sort((a, b) => b.compatibilidad - a.compatibilidad)
}

/**
 * Texto base de las recomendaciones.
 * Prolog decide QUE recomendar; el modelo de lenguaje decidira COMO
 * redactarlo cuando se integre la API de OpenAI.
 */
export function recomendaciones(misHabilidades, oferta) {
  const lista = []

  for (const r of oferta.requisitos) {
    const evidencia = nivelEvidencia(misHabilidades, r.nombre)
    if (r.obligatorio && evidencia === 'no_evidenciado') {
      lista.push(`El requisito obligatorio ${r.nombre} no aparece en el CV. Agrégalo si lo has usado en algún proyecto.`)
    } else if (r.obligatorio && evidencia === 'poco_evidenciado') {
      lista.push(`El requisito obligatorio ${r.nombre} está poco evidenciado. Detalla el proyecto y tu rol concreto.`)
    } else if (!r.obligatorio && evidencia === 'no_evidenciado') {
      lista.push(`La oferta valora ${r.nombre} como habilidad deseable y el CV no la menciona.`)
    }
  }

  if (lista.length === 0) {
    lista.push('El perfil cubre todos los requisitos de la oferta. Conviene postular.')
  }
  return lista
}

/** Clase CSS de la insignia segun el porcentaje. */
export function claseInsignia(porcentaje) {
  if (porcentaje >= 70) return 'insignia-verde'
  if (porcentaje >= 50) return 'insignia-ambar'
  return 'insignia-coral'
}

/** Color y etiqueta legible de un nivel de evidencia. */
export function etiquetaEvidencia(evidencia) {
  if (evidencia === 'evidenciado') return { texto: 'Evidenciado', clase: 'insignia-verde', color: 'var(--mint)', ancho: 100 }
  if (evidencia === 'poco_evidenciado') return { texto: 'Poco evidenciado', clase: 'insignia-ambar', color: 'var(--ambar)', ancho: 40 }
  return { texto: 'No evidenciado', clase: 'insignia-coral', color: 'var(--coral)', ancho: 8 }
}
