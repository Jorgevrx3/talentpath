# Frontend

Interfaz web en React + Vite. Reproduce el diseño de los mockups del apartado 1.6 del informe.

## Cómo ejecutarlo

Requiere [Node.js](https://nodejs.org) (versión LTS).

```bash
cd frontend
npm install
npm run dev
```

Se abre solo en `http://localhost:5173`. Si no, abre esa dirección a mano.

Para detenerlo: **Ctrl+C** en la terminal.

## Pantallas implementadas

| Ruta | Pantalla | Apartado |
|---|---|---|
| `/` | Registro e inicio de sesión | 1.6.1 |
| `/inicio` | Dashboard del postulante | 1.6.2 |
| `/ofertas` | Listado de ofertas laborales | 1.6.4 |
| `/ofertas/:id` | Análisis de compatibilidad | 1.6.5 |
| `/postulaciones` | Seguimiento de postulaciones | 1.6.6 |

Pendientes: editor de currículum (1.6.3), simulador de entrevista (1.6.7), asistente (1.6.8) y suscripción (1.6.9). Los diseños están en `../docs/mockups/`.

## Estructura

```
src/
├── main.jsx                  Punto de entrada
├── App.jsx                   Rutas de la aplicación
├── index.css                 Estilos y tokens de color (los mismos de Figma)
├── components/
│   ├── Layout.jsx            Menú lateral + área de contenido
│   ├── Menu.jsx              Menú lateral (equivale al componente de Figma)
│   └── Encabezado.jsx        Título, subtítulo y acciones
├── pages/                    Una pantalla por archivo
└── data/
    ├── mock.js               Datos de ejemplo (los mismos de seed.sql)
    └── compatibilidad.js     Reglas de compatibilidad en JavaScript
```

## Sobre los datos

Todavía no hay backend, así que las pantallas leen de `src/data/mock.js`, que reproduce el contenido de `../database/seed.sql`.

**Los porcentajes de compatibilidad no están escritos a mano:** se calculan en `src/data/compatibilidad.js`, que replica las reglas del motor Prolog. Por eso la interfaz muestra los mismos valores que `../prolog/base_conocimiento.pl` y que la consulta SQL de `../database/seed.sql`:

| Oferta | Compatibilidad |
|---|---|
| Practicante de Desarrollo Web | 100 % |
| Desarrollador Frontend Junior | 78 % |
| Desarrollador Full Stack | 56 % |
| Analista de Sistemas | 40 % |
| Ingeniero de Datos Junior | 29 % |

Cuando el backend esté listo, las constantes de `mock.js` se reemplazan por llamadas `fetch()` a la API y el cálculo lo devuelve el motor Prolog real.

## Cómo agregar una pantalla nueva

1. Crear el archivo en `src/pages/`
2. Registrar la ruta en `src/App.jsx`
3. Agregar la entrada en el arreglo `secciones` de `src/components/Menu.jsx`

Copiar la estructura de `Postulaciones.jsx`, que es la más simple.

## Estilos

Todos los colores están definidos como variables CSS en `src/index.css`, con los mismos nombres que las variables del archivo de Figma. Para cambiar la paleta, se editan esos valores y el cambio se propaga a toda la aplicación.
