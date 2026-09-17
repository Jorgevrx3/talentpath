# TalentPath

Sistema inteligente integrador para la gestión y preparación del proceso de búsqueda laboral mediante un modelo SaaS.

Proyecto académico — Escuela Profesional de Ingeniería de Sistemas, Universidad Privada San Juan Bautista.

---

## Problema

Quien busca empleo usa una herramienta distinta para cada actividad del proceso: elabora el currículum en un procesador de textos, revisa ofertas en portales, postula en cada plataforma y practica entrevistas por su cuenta. Nada de eso queda conectado, así que la información se dispersa, el seguimiento depende de la memoria del usuario y no existe una evaluación estructurada del desempeño.

## Solución

Una plataforma SaaS que centraliza la creación y gestión del currículum, el seguimiento de postulaciones y la preparación para entrevistas, con un asistente de inteligencia artificial contextual que analiza el perfil frente a las ofertas y genera recomendaciones.

La inteligencia artificial **no es el núcleo del negocio**: funciona como componente de apoyo sobre un sistema de gestión.

## Enfoque de IA

Arquitectura híbrida con separación explícita de responsabilidades:

| Componente | Responsabilidad |
|---|---|
| Prolog (SWI-Prolog) | Reglas determinísticas: coincidencia entre habilidades y requisitos, cálculo de compatibilidad |
| Modelo generativo (OpenAI) | Comprensión y generación de lenguaje natural: análisis del CV, preguntas de entrevista, retroalimentación |
| Plataforma SaaS | Interfaz, usuarios, currículums, ofertas, postulaciones, entrevistas y suscripciones |

Prolog decide **qué** recomendar; el modelo de lenguaje decide **cómo** redactarlo.

---

## Estructura del repositorio

```
talentpath/
├── docs/                 Documentación del proyecto
│   ├── Cap1_*.docx       Informe del Capítulo I (formato APA 7.ª edición)
│   ├── Cap1_*.pptx       Presentación del capítulo
│   └── mockups/          Diseño de las 9 pantallas + arquitectura + modelo de datos
├── prolog/               Base de conocimiento
│   └── base_conocimiento.pl
├── database/             Esquema de base de datos (pendiente)
├── backend/              API REST (pendiente)
└── frontend/             Interfaz web (pendiente)
```

---

## Stack técnico

- **Frontend:** React
- **Backend:** Node.js con Express
- **Base de datos:** MySQL
- **Motor de reglas:** SWI-Prolog
- **Servicio de IA:** API de OpenAI

> El stack de frontend y backend es una propuesta del equipo y puede ajustarse.

---

## Cómo ejecutar la base de conocimiento

Requiere [SWI-Prolog](https://www.swi-prolog.org/download/stable).

```bash
cd prolog
swipl base_conocimiento.pl
```

Dentro del intérprete:

```prolog
?- demo.
```

Imprime el análisis de compatibilidad de los perfiles de ejemplo contra las ofertas registradas, con sus recomendaciones y el ranking de ofertas.

Consultas individuales:

```prolog
?- coincidencias(juan, frontend_junior, L).
?- faltantes(juan, frontend_junior, L).
?- brecha_critica(juan, frontend_junior, H).
?- compatibilidad_ponderada(juan, frontend_junior, P).
?- ofertas_ordenadas(juan, L).
?- informe(juan, frontend_junior).
```

---

## Estado del proyecto

| Entregable | Estado |
|---|---|
| Capítulo I — Diseño arquitectónico (1.1 a 1.8) | Completo |
| Diseño de mockups (9 pantallas) | Completo |
| Base de conocimiento en Prolog | Completo y verificado |
| Esquema de base de datos | Pendiente |
| Backend | Pendiente |
| Frontend | Pendiente |
| Integración con la API de OpenAI | Pendiente |

---

## Integrantes

- [Apellidos, Nombres]
- [Apellidos, Nombres]
- [Apellidos, Nombres]

**Docente:** [Apellidos, Nombres]

---

## Nota sobre credenciales

La clave de la API de OpenAI va exclusivamente en el backend, dentro de un archivo `.env` que **no se sube al repositorio**. Nunca en el código del frontend: sería visible para cualquiera que abra el inspector del navegador.
