// ---------------------------------------------------------------------------
// Datos de ejemplo. Reproducen el contenido de database/seed.sql
// Cuando el backend este listo, estas constantes se reemplazan por
// llamadas fetch() a la API.
// ---------------------------------------------------------------------------

export const usuario = {
  nombres: 'Juan',
  apellidos: 'Pérez Ramos',
  correo: 'juan.perez@correo.com',
  plan: 'Premium'
}

export const indicadores = [
  { etiqueta: 'Postulaciones activas',   valor: 12, nota: '3 esta semana' },
  { etiqueta: 'En proceso',              valor: 5,  nota: '2 en entrevista' },
  { etiqueta: 'Versiones de CV',         valor: 4,  nota: 'Última: hace 2 días' },
  { etiqueta: 'Entrevistas practicadas', valor: 9,  nota: 'Promedio 7.8/10' }
]

// Niveles: 1 mencionada · 2 basica · 3 intermedia · 4 solida · 5 avanzada
export const misHabilidades = {
  HTML: 4, CSS: 4, JavaScript: 3, React: 1, MySQL: 3
}

export const ofertas = [
  {
    id: 3, puesto: 'Practicante de Desarrollo Web', empresa: 'SoftLima',
    meta: 'Remoto · Prácticas',
    requisitos: [
      { nombre: 'HTML', obligatorio: true },
      { nombre: 'CSS', obligatorio: true },
      { nombre: 'JavaScript', obligatorio: false }
    ]
  },
  {
    id: 1, puesto: 'Desarrollador Frontend Junior', empresa: 'Innova Perú',
    meta: 'Lima · Híbrido · S/ 2 500',
    requisitos: [
      { nombre: 'HTML', obligatorio: true },
      { nombre: 'CSS', obligatorio: true },
      { nombre: 'JavaScript', obligatorio: true },
      { nombre: 'React', obligatorio: true },
      { nombre: 'Git', obligatorio: false }
    ]
  },
  {
    id: 4, puesto: 'Desarrollador Full Stack', empresa: 'Netcom',
    meta: 'Lima · Remoto · S/ 3 200',
    requisitos: [
      { nombre: 'JavaScript', obligatorio: true },
      { nombre: 'React', obligatorio: true },
      { nombre: 'Node.js', obligatorio: true },
      { nombre: 'MySQL', obligatorio: true },
      { nombre: 'Git', obligatorio: false }
    ]
  },
  {
    id: 2, puesto: 'Analista de Sistemas', empresa: 'Grupo Andes',
    meta: 'Ica · Presencial · S/ 2 200',
    requisitos: [
      { nombre: 'SQL', obligatorio: true },
      { nombre: 'MySQL', obligatorio: true },
      { nombre: 'Excel', obligatorio: false }
    ]
  },
  {
    id: 5, puesto: 'Ingeniero de Datos Junior', empresa: 'DataSur',
    meta: 'Lima · Presencial · S/ 3 000',
    requisitos: [
      { nombre: 'Python', obligatorio: true },
      { nombre: 'SQL', obligatorio: true },
      { nombre: 'MySQL', obligatorio: true },
      { nombre: 'Excel', obligatorio: false }
    ]
  }
]

export const postulaciones = [
  { puesto: 'Desarrollador Frontend Junior', empresa: 'Innova Perú', cv: 'Frontend Junior', fecha: '08/09', estado: 'En revisión', accion: 'Esperar respuesta' },
  { puesto: 'Analista de Sistemas',          empresa: 'Grupo Andes', cv: 'General 2026',    fecha: '05/09', estado: 'Entrevista',  accion: 'Entrevista 15/09' },
  { puesto: 'Practicante de TI',             empresa: 'SoftLima',    cv: 'Prácticas TI',    fecha: '02/09', estado: 'Aceptado',    accion: 'Firmar convenio' },
  { puesto: 'Soporte de Aplicaciones',       empresa: 'DataSur',     cv: 'General 2026',    fecha: '28/08', estado: 'Rechazado',   accion: 'Revisar feedback' },
  { puesto: 'Desarrollador Web',             empresa: 'Netcom',      cv: 'Frontend Junior', fecha: '25/08', estado: 'En revisión',  accion: 'Hacer seguimiento' }
]
