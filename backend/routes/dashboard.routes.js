const pool = require('y../config/db')

async function obtenerDashboard(req, res) {
  try {
    const idUsuario = req.query.usuario || 1

    const [usuario] = await pool.query(`
      SELECT
        id_usuario AS id,
        nombres,
        apellidos,
        correo
      FROM usuario
      WHERE id_usuario = ?
    `, [idUsuario])

    const [postulaciones] = await pool.query(`
      SELECT
        p.id_postulacion AS id,
        o.puesto,
        o.empresa,
        p.fecha,
        p.estado
      FROM postulacion p
      INNER JOIN oferta_laboral o
        ON p.id_oferta = o.id_oferta
      WHERE p.id_usuario = ?
      ORDER BY p.fecha DESC
      LIMIT 5
    `, [idUsuario])

    const [cantidadPostulaciones] = await pool.query(`
      SELECT COUNT(*) AS total
      FROM postulacion
      WHERE id_usuario = ?
    `, [idUsuario])

    const [cantidadEntrevistas] = await pool.query(`
      SELECT COUNT(*) AS total
      FROM postulacion
      WHERE id_usuario = ?
      AND estado = 'Entrevista'
    `, [idUsuario])

    res.json({
      usuario: usuario[0],
      indicadores: {
        postulaciones: cantidadPostulaciones[0].total,
        entrevistas: cantidadEntrevistas[0].total
      },
      postulaciones
    })

  } catch (error) {
    console.error(error)

    res.status(500).json({
      mensaje: 'Error al obtener el dashboard'
    })
  }
}

module.exports = {
  obtenerDashboard
}