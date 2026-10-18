# Comparación de las descargas

18 de octubre de 2026. Inventario de archivos locales, sin afirmar integridad del juego original.

| Fuente | Archivos | SWF | Contenidos SWF únicos (SHA-256) | Tamaño sin comprimir |
|---|---:|---:|---:|---:|
| github | 8020 | 8013 | 8012 | 603.9 MiB |
| archive | 4731 | 4731 | 4731 | 457.0 MiB |
| data | 11 | 0 | 0 | 9.3 MiB |
| community | 16406 | 13711 | 7383 | 673.2 MiB |

## Archivo histórico frente a GitHub

La comparación busca archivos con el mismo nombre y compara SHA-256 contra todos los candidatos. Una coincidencia prueba igualdad binaria de ese recurso; no demuestra compatibilidad de versiones.

- 3755 recursos del archivo histórico tienen una copia idéntica en GitHub.
- 975 tienen el mismo nombre pero contenido diferente.
- 1 no tienen un candidato con el mismo nombre.

## Servidor alternativo

Hay 0 SWF con contenido idéntico a alguno del proyecto GitHub base y 13711 sin una coincidencia binaria allí. Los conteos incluyen copias y respaldos; no equivalen a ese número de recursos nuevos.

La carpeta contiene un cliente NinjaSage, datos JSON/BIN, código PHP/Laravel, 34 migraciones y 8 seeders. No se encontró un volcado .sql. No se ejecutó este servidor y no se ha probado la compatibilidad de su cliente/datos con el servidor Node.

## Estado del prototipo local

Verificado con Ruffle: creación de CodexNinja, elemento fuego, aldea, combate de la misión Hardworking Student, victoria, recompensa de 20 XP y 15 de oro, guardado y regreso a la aldea después de recargar. El servidor conserva 20 XP y 515 de oro.

La lista de amigos de Facebook presenta un aviso de servicio no disponible. No se verificaron multijugador, clanes, pagos, todos los eventos ni todas las misiones. El servidor base puede devolver respuestas simuladas y recursos sustitutos. No debe interpretarse esta prueba como una restauración íntegra o fiel del balance original.

## Qué falta para HTML5 nativo

No se verificó una copia completa de los proyectos editables FLA/XFL, de todo el ActionScript ni del backend original. Para empezar, ya hay material suficiente: cliente de referencia que funciona, gráficos/animaciones en SWF, tablas ActionScript y datos JSON de otro cliente. Hace falta elegir una versión coherente, extraer los recursos de una escena, traducir su lógica y definir una API de guardado y recompensas.

Los archivos diferentes se conservan separados; no se sustituyeron bibliotecas de una versión por otra. No es posible calcular un porcentaje total sin un manifiesto oficial de la versión objetivo.

Consulta LEEME.md para el arranque y la procedencia; inventory.json contiene tamaños y SHA-256, comparison.json los resultados por recurso y embedded-urls.json las direcciones detectadas.
