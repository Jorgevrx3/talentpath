const pool = require('../config/db')

async function obtenerPostulaciones(req, res) {
  try {
    const idUsuario = req.query.usuario || 1

    const [postulaciones] = await pool.query(`
      SELECT
        p.id_postulacion AS id,
        o.puesto,
        o.empresa,
        p.cv,
        p.fecha,
        p.estado,
        p.accion
      FROM postulacion p
      INNER JOIN oferta_laboral o
        ON p.id_oferta = o.id_oferta
      WHERE p.id_usuario = ?
      ORDER BY p.fecha DESC
    `, [idUsuario])

    res.json(postulaciones)

  } catch (error) {
    console.error(error)

    res.status(500).json({
      mensaje: 'Error al obtener postulaciones'
    })
  }
}

async function crearPostulacion(req, res) {
  try {
    const {
      id_usuario,
      id_oferta,
      cv,
      fecha,
      estado,
      accion
    } = req.body

    if (!id_usuario || !id_oferta || !cv || !fecha) {
      return res.status(400).json({
        mensaje: 'Faltan datos obligatorios'
      })
    }

    const [resultado] = await pool.query(`
      INSERT INTO postulacion
      (id_usuario, id_oferta, cv, fecha, estado, accion)
      VALUES (?, ?, ?, ?, ?, ?)
    `, [
      id_usuario,
      id_oferta,
      cv,
      fecha,
      estado || 'En revisión',
      accion || 'Esperar respuesta'
    ])

    res.status(201).json({
      mensaje: 'Postulación registrada correctamente',
      id: resultado.insertId
    })

  } catch (error) {
    console.error(error)

    res.status(500).json({
      mensaje: 'Error al registrar postulación'
    })
  }
}

module.exports = {
  obtenerPostulaciones,
  crearPostulacion
}