const pool = require('../config/db')

async function obtenerOfertas(req, res) {
  try {
    const [ofertas] = await pool.query(`
      SELECT
        o.id_oferta AS id,
        o.puesto,
        o.empresa,
        o.modalidad,
        o.ubicacion,
        o.descripcion,
        o.fecha_publicacion
      FROM oferta_laboral o
      ORDER BY o.id_oferta DESC
    `)

    res.json(ofertas)

  } catch (error) {
    console.error(error)

    res.status(500).json({
      mensaje: 'Error al obtener las ofertas'
    })
  }
}

async function obtenerOferta(req, res) {
  try {
    const { id } = req.params

    const [ofertas] = await pool.query(`
      SELECT
        id_oferta AS id,
        puesto,
        empresa,
        modalidad,
        ubicacion,
        descripcion,
        fecha_publicacion
      FROM oferta_laboral
      WHERE id_oferta = ?
    `, [id])

    if (ofertas.length === 0) {
      return res.status(404).json({
        mensaje: 'Oferta no encontrada'
      })
    }

    const [requisitos] = await pool.query(`
      SELECT
        id_requisito,
        nombre,
        obligatorio
      FROM requisito_oferta
      WHERE id_oferta = ?
    `, [id])

    res.json({
      ...ofertas[0],
      requisitos
    })

  } catch (error) {
    console.error(error)

    res.status(500).json({
      mensaje: 'Error al obtener la oferta'
    })
  }
}

module.exports = {
  obtenerOfertas,
  obtenerOferta
}