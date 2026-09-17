const pool = require('../config/db')
const bcrypt = require('bcryptjs')

async function login(req, res) {
  try {
    const { correo, clave } = req.body

    if (!correo || !clave) {
      return res.status(400).json({
        mensaje: 'Correo y contraseña son obligatorios'
      })
    }

    const [usuarios] = await pool.query(
      'SELECT * FROM usuario WHERE correo = ?',
      [correo]
    )

    if (usuarios.length === 0) {
      return res.status(401).json({
        mensaje: 'Credenciales incorrectas'
      })
    }

    const usuario = usuarios[0]

    const contraseñaCorrecta = await bcrypt.compare(
      clave,
      usuario.contrasena
    )

    if (!contraseñaCorrecta) {
      return res.status(401).json({
        mensaje: 'Credenciales incorrectas'
      })
    }

    res.json({
      mensaje: 'Login correcto',
      usuario: {
        id: usuario.id_usuario,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
        correo: usuario.correo
      }
    })

  } catch (error) {
    console.error(error)

    res.status(500).json({
      mensaje: 'Error interno del servidor'
    })
  }
}

module.exports = {
  login
}