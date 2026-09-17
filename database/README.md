# Base de datos

Esquema MySQL derivado del modelo entidad-relación del apartado 1.8 del informe.

## Archivos

- `schema.sql` — crea la base `db_talentpath` y sus 14 tablas con claves primarias, foráneas y restricciones
- `seed.sql` — datos de prueba (2 usuarios, 10 habilidades, 5 empresas, 5 ofertas, postulaciones y entrevistas)

## Cómo ejecutarlos

Desde esta carpeta, en la terminal:

```bash
mysql -u root -p < schema.sql
mysql -u root -p < seed.sql
```

O desde MySQL Workbench / phpMyAdmin: abrir cada archivo y ejecutarlo, primero `schema.sql` y luego `seed.sql`.

> `schema.sql` empieza con `DROP DATABASE IF EXISTS`, así que se puede volver a ejecutar cuantas veces sea necesario. Ojo: eso borra los datos que hubiera.

## Coherencia con el motor de reglas

Los datos de `seed.sql` reproducen los mismos hechos de `../prolog/base_conocimiento.pl`. La consulta de verificación que está comentada al final de `seed.sql` devuelve los mismos porcentajes que la regla `compatibilidad_ponderada/3`:

| Oferta | Compatibilidad |
|---|---|
| Practicante de Desarrollo Web | 100 % |
| Desarrollador Frontend Junior | 78 % |
| Desarrollador Full Stack | 56 % |
| Analista de Sistemas | 40 % |
| Ingeniero de Datos Junior | 29 % |

## Nota sobre el campo `nivel`

`perfil_habilidad.nivel` es un entero del 1 al 5:

| Nivel | Significado | Evidencia para el motor |
|---|---|---|
| 1 | mencionada | poco evidenciado |
| 2 | básica | poco evidenciado |
| 3 | intermedia | evidenciado |
| 4 | sólida | evidenciado |
| 5 | avanzada | evidenciado |

El diagrama del modelo está en `../docs/mockups/11_modelo_datos.png`.
