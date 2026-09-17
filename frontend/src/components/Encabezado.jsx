// Encabezado de pagina: titulo, subtitulo y acciones a la derecha.
export default function Encabezado({ titulo, subtitulo, children }) {
  return (
    <div className="encabezado">
      <div>
        <div className="titulo">{titulo}</div>
        {subtitulo && <div className="subtitulo">{subtitulo}</div>}
      </div>
      {children && <div className="fila">{children}</div>}
    </div>
  )
}
