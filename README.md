# Ninja Saga · Local / HTML5

Proyecto privado de restauración de Ninja Saga y traslado fiel del juego original a HTML5.

**Alcance confirmado: restauración 1:1 del juego original, lo mejor posible.** No se desarrollará un juego distinto ni se usarán reglas de clones como sustituto de las originales. Ver [RESTORATION.md](RESTORATION.md) y el [primer informe de análisis](restoration/INFORME-01.md).

## Empezar

Con Node.js 18 o posterior instalado:

```sh
npm start
```

Abre http://localhost:8080 y mantén el servidor funcionando. En Windows también puedes usar `Iniciar-Local.cmd`. No hace falta instalar dependencias npm, Flash ni certificados.

El cliente Flash se ejecuta con Ruffle 0.7.1. La migración nativa a JavaScript/TypeScript queda como siguiente etapa.

## Estado comprobado

El 18 de octubre de 2026 se verificaron creación de personaje, selección de elemento, aldea, combate de Hardworking Student, victoria, recompensa y persistencia después de recargar. El guardado de prueba se genera en `local/server/characters.json` y no se versiona.

La integración de amigos de Facebook muestra un aviso de servicio no disponible. PvP, clanes, pagos, eventos y el conjunto completo de misiones no se consideran verificados. El servidor reconstruido contiene respuestas simuladas y sustituciones de recursos; no se ha comprobado fidelidad completa al juego original.

## Contenido del respaldo

- `local/`: integración de localhost y Ruffle.
- `sources/shenjai47/NinjaSaga-master/`: código base y recursos de la versión que funciona; se omiten registros, ejecutables, guardados y respaldos redundantes.
- `reports/`: inventario SHA-256 de las colecciones investigadas, comparación y evidencia de la prueba.
- `LEEME.md`: detalles de la recuperación, procedencia y siguientes pasos.

Las colecciones de Internet Archive, aqhmal y el servidor alternativo se conservan fuera del seguimiento Git en la carpeta local `sources/`. Sus archivos están documentados en el inventario, pero no forman parte de este primer respaldo. `audit.js` y `write-report.js` sirven para regenerar el informe cuando estén disponibles esas colecciones completas.

## Siguiente etapa

Completar el corpus histórico y sus contratos de servidor; trasladar sus clases, pantallas y timelines con pruebas de equivalencia 1:1. El análisis y la arquitectura propuesta están en `restoration/INFORME-01.md`.

Los recursos originales conservan sus derechos y licencias de procedencia. Este repositorio no concede una licencia sobre Ninja Saga ni sus recursos.
