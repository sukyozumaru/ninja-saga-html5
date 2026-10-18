# Ninja Saga local

Preparado el 18 de octubre de 2026.

## Jugar

Abre `Iniciar-Local.cmd` y deja esa ventana abierta. Después visita http://localhost:8080 . Si el servidor ya está funcionando, basta con abrir la dirección.

Esta primera etapa ejecuta el cliente Flash mediante Ruffle, con un servidor Node local. Todavía no es una reescritura HTML5 nativa. No requiere instalar Flash, cambiar el archivo hosts ni instalar certificados.

Se comprobó en el navegador: creación de CodexNinja, elección de elemento, entrada en la aldea, misión Hardworking Student, pantalla de victoria y recuperación del progreso después de recargar. El guardado contiene 20 XP y 515 de oro después de la misión. Los valores visuales transitorios del tutorial no siempre coinciden con el guardado del servidor.

## Carpetas

- `sources/shenjai47/`: descarga original del proyecto que sirve de base al arranque local.
- `sources/internet-archive/`: colección histórica de SWF de la versión 3.3.00810.
- `sources/aqhmal/`: biblioteca parcial en ActionScript, útil como referencia de datos.
- `sources/community-server/`: repositorio alternativo de pseudownload; cliente NinjaSage y servidor Laravel. Se conserva para comparación, sin ejecutarlo ni mezclarlo con la base local.
- `local/`: integración creada para localhost y copia de trabajo del código del servidor.
- `reports/`: inventario con SHA-256, comparación de recursos, resumen y captura de la misión.

## Guardado y reinicio

El progreso de prueba está en `local/server/characters.json`, separado del guardado incluido en el proyecto descargado. Haz una copia antes de editarlo. Cerrar el proceso que ejecuta `local/start.js` detiene el servidor; `Iniciar-Local.cmd` permite iniciarlo de nuevo con Node instalado.

Los originales de `sources/` se conservan sin adaptar. Al iniciar, se copian los archivos JavaScript del servidor base a `local/server/`; los cambios permanentes al arranque deben hacerse en `local/start.js`. El arranque no sobrescribe el guardado de trabajo.

## Cambios para localhost

- Página de arranque y Ruffle 0.7.1 descargado desde el registro npm.
- Servidor de página y recursos en 127.0.0.1:8080, gateway AMF en 127.0.0.1:8081.
- Redirección de las URL incrustadas, incluida `/Ninja Saga/web/swf/`, hacia los archivos locales.
- Base de personajes independiente y registros en `local/gateway.log` y `local/client.log`.

## Límites observados

La lista de amigos muestra un aviso de servicio no disponible. Facebook, pagos, PvP, clanes y eventos no se consideran verificados. El servidor es una reconstrucción con respuestas simuladas y puede sustituir recursos faltantes por clones o archivos vacíos. La victoria de una misión demuestra que el recorrido básico funciona, no que el balance, las animaciones o todas las reglas sean fieles al original. Hay parches y herramientas de modificación en los proyectos descargados.

## Trabajo para el prototipo HTML5

1. Mantener este arranque como referencia y seleccionar una versión de datos y recursos.
2. Extraer gráficos y animaciones del personaje, un enemigo, un escenario y una habilidad.
3. Reconstruir en JavaScript/TypeScript un combate por turnos y una pantalla de aldea.
4. Convertir las tablas necesarias a JSON; el repositorio alternativo ya aporta datos en JSON y BIN, cuya compatibilidad debe comprobarse.
5. Conectar guardado y recompensas a una API local explícita.

No se ha encontrado ni verificado el proyecto editable completo del juego original (.fla/.xfl y todo su ActionScript), ni el backend original completo. No son imprescindibles para comenzar una reconstrucción pequeña, pero su ausencia exige adaptar o reescribir lógica.

## Procedencia

- https://github.com/shenjai47/NinjaSaga (master)
- https://github.com/aqhmal/data_library_en (master)
- https://archive.org/details/ninja_saga — archivo `ns-static-bwhcb6a5289.netdna-ssl.com.7z`
- https://github.com/pseudownload/Ninja-Saga-Private-Server (main)

La descarga y la consulta de la API de Nik-Potokar/Ninja-Saga-Private-Server devolvieron 404 en esta sesión. La copia alternativa encontrada tiene un nombre y descripción similares, pero no se ha demostrado que sea idéntica a la versión desaparecida. Los enlaces de descarga del hilo de RaGEZONE requieren iniciar sesión y no se recuperaron.

La publicación pública y la reutilización de recursos deben resolverse con sus titulares; la presencia de un archivo en estos repositorios no acredita una licencia sobre el juego.
