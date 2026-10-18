# Informe 02 — arranque histórico y acceso local

18 de octubre de 2026. Objetivo: ejecutar el cliente histórico con sus bibliotecas originales y sustituir Facebook, conservando interfaz y reglas.

## Resultado comprobado

El navegador carga el SWF histórico sin parchear, sus bibliotecas originales y su pantalla de usuario/contraseña. Una cuenta del servidor local inicia sesión por AMF y llega a la selección original de personajes. [Evidencia](../reports/historical-local-login.png).

Se conservó el runner comunitario en 8080; el histórico tiene proceso propio y puerto 8082. No comparte cuentas, guardados ni handlers de juego. Solo reutiliza su codec AMF0/AMF3, cuya compatibilidad con estas llamadas se verificó mediante el cliente real.

## Correspondencia con el código original

| Comportamiento | Fuente original | Reemplazo |
|---|---|---|
| Arranque sin Facebook | `main/NinjaSaga.as`, `selfPreloadFinish` e `initSocialPlatform` | Sin `fb_uid`, `fb_at` ni `fb_sig`; muestra el login incluido en el juego |
| Pantalla de usuario/contraseña | `main/ninjasaga/linkage/LoginMenu.as`, `onLogin`, `amfLogin` | Pantalla SWF original sin editar controles ni gráficos |
| Acceso | `LoginMenu.amfLogin` | `SystemService.login([usuario,contraseña,build])` en `historical/contracts.js` |
| Cuenta firmada | `code_library/ninjasaga/Account.as:setupAccount`; `client_library/ninjasaga/linkage/ClientLibrary.as:getHash/generateHash` | `[id,1,0,sesión]`, gratuita sin saldo concedido, firma compatible |
| Datos | `LoginMenu.onAmfLoginResult/loadDataFinish`; `DataParser.parseVersionData` | `swf_versions=[{type:'data',version:'3.3.00810'}]`; SWF inglés archivado |
| Selección | `main/ninjasaga/linkage/SelectCharMenu.as:amfGetCharactersList` | Lista vacía de la cuenta local, sin personajes inventados |

La autenticación nueva usa scrypt con sal aleatoria. Las sesiones aleatorias duran 12 horas en memoria y se invalidan al reiniciar. La firma SHA-1 truncada solo permite compatibilidad del protocolo; no protege las contraseñas. Se comprueban host/origen local y límites de petición e intentos. Cuentas y registros no se versionan.

El botón original de crear cuenta abre `registration.html`; el runner ofrece allí el formulario local. El enlace exterior permite lo mismo. La recuperación de contraseña está pendiente. Las casillas originales de guardar usuario/contraseña conservan el comportamiento histórico; no se activan por defecto en la prueba.

## Bibliotecas y recursos

`restoration/historical-assets/` conserva la extracción de [Internet Archive](https://archive.org/download/ninja_saga/ns-static-bwhcb6a5289.netdna-ssl.com.7z), incluidos los 4.731 SWF de la colección. `historical-assets.json` fija ruta, tamaño y SHA-256. `node historical/assets.js` contrasta toda la colección y los cinco módulos con el corpus del informe 01.

El SWF conserva `BUILD_NO=3.3.00809`. Su constructor admite `client_version`, y usamos `3.3.00810` para las rutas archivadas. No se renombra una biblioteca para simular otra versión.

El cliente exige reconocer su antiguo host dentro de `loaderURL`. Se sirve desde una ruta local que contiene literalmente `http://static.ninjasaga.com/`, satisfaciendo esa comprobación de cadena sin cambiar DNS, certificados ni archivos del sistema. Las [reglas de Ruffle](https://ruffle.rs/js-docs/master/interfaces/Config.URLLoadOptions.html#urlRewriteRules) redirigen HTTP/HTTPS a localhost. El servidor no hace proxy externo. JavaScript desde el SWF permanece desactivado. Los binarios están intactos.

## Límite encontrado

Pulsar Create intenta precargar la personalización, pero falla por `swf/3.3.00810/swf/items/hair_10_1.swf`, ausente de la colección histórica.

`HairData.getCreateData()` lo solicita para el género femenino y `SelectCharMenu.onCreate()` precarga los cabellos de ambos géneros. El servidor devuelve 404 y el cliente muestra su aviso original de conexión perdida. No es un fallo del login ni motivo para saltarse la precarga.

Existe un archivo de ese nombre en la colección comunitaria, pero ese proyecto también genera donantes y stubs. No se adopta sin verificar su procedencia y equivalencia. La búsqueda pública del nombre exacto no produjo una copia histórica autenticada. El [hilo RaGEZONE de esta versión](https://forum.ragezone.com/threads/ninja-saga-3-3-00810-3-3-00890.1203836/) sigue como pista; enlaces restringidos no cuentan como archivos recuperados.

También faltan contratos de creación/carga de personajes, inventario, misiones y servicios sociales. El gateway devuelve `LOCAL_NOT_RESTORED` para servicios pendientes, nunca éxito genérico. El acceso restaurado no demuestra jugabilidad completa ni fidelidad del backend original.

## Verificación y siguiente trabajo

- Navegador: arranque → bibliotecas → login original → dos llamadas AMF → selección original.
- Recurso ausente: 404 sin sustitutos.
- Pruebas: contraseña incorrecta, persistencia del hash, sesión inválida/caducada, build incompatible, firma de compatibilidad y rechazo de servicios pendientes.
- SHA-256: colección y correspondencia con los cinco módulos analizados.

Siguiente hito: autenticar el cabello faltante y reconstruir los contratos de alta hasta completar la creación original de personaje; después, aldea y misión histórica. Las diferencias se registran sin importar reglas o gráficos de otra versión silenciosamente.
