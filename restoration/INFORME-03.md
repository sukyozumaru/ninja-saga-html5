# Informe 03 — prueba pública independiente de localhost

Fecha: 18 de octubre de 2026. **[Abrir la prueba pública](https://ninja-saga-restoration.heartyglade5.chatgpt.site)**.

## Alcance publicado y comprobado

El cliente histórico carga por HTTPS con sus bibliotecas originales, permite crear una cuenta de pruebas y autentica mediante el servidor alojado hasta llegar a la pantalla original de selección de personajes. No requiere que el desarrollador ni los visitantes ejecuten localhost. [Captura del cliente público autenticado](../reports/public-login.png).

La creación de personajes, las misiones y los servicios sociales todavía no están restaurados. La ausencia de `hair_10_1.swf` sigue registrada. El sitio muestra este alcance antes de entrar y ofrece un enlace para reportar problemas en GitHub. No se cambió el SWF, su interfaz ni sus fórmulas.

## Alojamiento

Sites aloja el Worker y una base D1 con cuentas, sesiones y límites de intentos. Los datos locales y sus contraseñas no se migraron. Las contraseñas nuevas usan PBKDF2-SHA256 con sal aleatoria y 100.000 iteraciones; las sesiones aleatorias duran 12 horas y solo se conserva su hash en la base. La firma histórica se mantiene exclusivamente para compatibilidad con Account.setupAccount. El servidor no registra contraseñas ni argumentos AMF.

El código se conserva en `hosting/` y en el repositorio de origen de Sites. Las migraciones de base se aplican durante la publicación; no se crean tablas desde las peticiones del juego.

## Recursos originales y límite del alojamiento

El paquete completo fue rechazado por el límite de entrada de 256 MiB de Sites. Se resolvió conservando dentro del sitio el cliente, las bibliotecas iniciales y Ruffle. El resto se sirve mediante rutas del mismo sitio que recuperan los binarios del commit público fijo `32ecad6973472e24e40476441dc70735c1ab7079`, comprueban tamaño y SHA-256 contra `asset-lock.json` y almacenan únicamente respuestas verificadas en caché.

Esto no utiliza donantes ni stubs. Si el recurso no existe en el manifiesto, devuelve 404; si la fuente falla o su huella no coincide, falla explícitamente. La primera carga de un recurso no incluido en el paquete depende de la disponibilidad del respaldo público de GitHub; las cuentas y el gateway AMF están alojados en Sites.

Se verificaron previamente las huellas de los 4.740 archivos fijados: 4.731 SWF de la colección histórica y nueve archivos de Ruffle. El paquete final comprimido tiene 17.726.696 bytes.

## Pruebas ejecutadas

- Tres pruebas automatizadas del backend alojado: firma original, persistencia de hashes, contraseña incorrecta, duplicados, sesión caducada y límites de intentos.
- Vista previa y producción: registro, login AMF, lista de personajes, rechazo de contraseña incorrecta y de sesión inválida.
- Producción: nueve recursos cotejados con el SHA-256 original, incluido `action_base.swf` servido a través de la ruta de respaldo y verificación.
- Producción: `hair_10_1.swf` devuelve 404.
- Navegador en la URL pública: bibliotecas → pantalla original de acceso → cuenta alojada → selección original. La captura no contiene credenciales.

## Identificadores de publicación

- Proyecto Sites: `appgprj_6ad53d8171a081919c87d4eacb1d623e`.
- Versión 1: `appgprj_6ad53d8171a081919c87d4eacb1d623e~appgver_e89965b712b48191b2067bff8092b6c0`.
- Despliegue confirmado: `appgdep_6ad543430cc08191aece97b3823118c4`.
- Commit de origen alojado: `e1aa9d5e63cb337c3270712181fd4bbb92adb8eb`.

## Continuación de la restauración

Se documentó el [contrato original de alta del personaje](CONTRATO-ALTA-PERSONAJE.md): el cliente envía la creación al terminar la rama de introducción/combate, con siete argumentos posicionales. La secuencia y las formas diferentes de las respuestas SystemData se conservarán al implementar el backend. Este análisis no equivale a haber restaurado ya esos servicios.
