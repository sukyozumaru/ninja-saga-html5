# Investigación de ninjasaga.cc

Fecha de revisión: 2026-10-19 (America/New_York). Fuente aportada por el usuario: https://ninjasaga.cc/download.

## Resultado

La página publica un instalador Windows y dos APK Android. Los tres se descargaron y se inspeccionaron estáticamente, sin instalarlos ni ejecutarlos. Son aplicaciones Adobe AIR; el descriptor Android declara com.ninjasaga.air, versión 1.8 y copyright Emagist Entertainment. Esos textos son declaraciones del paquete, no una autenticación independiente de su editor.

El instalador Windows pudo abrirse como archivo con tar. Contiene 175 archivos, principalmente runtime y extensiones AIR, y air.swf (22856 bytes). El código exportado de ese SWF carga launcher.json y después un cliente remoto. Los APK también contienen air.swf y bibliotecas de extensiones. No son un volcado completo de los recursos del juego ni del backend.

El lanzador expone la configuración pública https://ninjasaga.cc/launcher.json y el cliente https://cdn.ninjasaga.cc/cdn/swf/latest/ninja_saga.swf. Se recuperaron ese cliente y diez recursos concretos mediante sus rutas conocidas. No se consultaron servicios de partidas, no se crearon cuentas y no se realizaron pruebas de vulnerabilidades.

## Comparación verificable

| Archivo | Resultado |
|---|---|
| hair_01_0.swf | Idéntico al corpus histórico, SHA-256 a50a05b0a48e0d349dc411b19bc6fd23c8fe7ca41854a0041a137d672d8941f8 |
| mission_01.swf | Idéntico a la misión introductoria histórica, SHA-256 f19c7696b7af85fd64df177ec4650924186a5c4f65c2c82b30da36155f7e40de |
| hair_10_1.swf | 7132 bytes; coincide con el candidato shenjai47 ya conocido, SHA-256 8186cc867b4b179d74cf5b93887e5086ee20ab9227df142b0f442a8a306aaf33. Símbolos hair, back_hair e icon. Sigue sin autenticar para 3.3.00810 |
| library.swf | Idéntico a la copia auxiliar ya incorporada, 7058627 bytes, SHA-256 1b57b1779a5ba3f97d7bc2610dbfe4ac718f3d137ae088a01e0a6ab621bfb8f3 |
| Panel_New_Daily_Login.swf | Idéntico a la copia auxiliar ya recuperada, SHA-256 317748bc2dcbd56256f5f3add43aafa4e0a4955ae940db0f4ffb951ae38aec43 |
| ninja_saga.swf, code_library, client_library, network_library, menu, data_library_en | Difieren de sus equivalentes históricos; se preservan por separado |

Dos coincidencias exactas con el corpus confirman que hay recursos históricos reutilizados. No autentican por extensión los demás archivos ni prueban independencia entre esta fuente y la colección comunitaria.

## Diferencias que impiden sustituir el motor sin análisis

Data.BUILD_NO declara latest, frente a 3.3.00809 dentro del cliente histórico y la ruta archivada 3.3.00810. El lanzador usa nuevos dominios de CDN, web y servidor AMF. ClientLibrary.generateHash devuelve un SHA-1 completo, mientras que la referencia histórica aplica truncamiento y desplazamiento. Cambiar esa biblioteca rompería el contrato firmado que estamos restaurando.

Se exportaron clases seleccionadas de Data, StaticVariables, SelectCharMenu, DataParser, DBCharacter, AMFConnector y ClientLibrary, junto al Main del lanzador y las clases del cabello. La descompilación es evidencia auxiliar, no un proyecto editable original ni prueba de equivalencia semántica.

La configuración identifica una URL de backend; no publica por ello su código PHP, base de datos o calendario mensual. No se recuperó código de servidor original de estas descargas. Tampoco queda corregido el guardado público por encontrar estos archivos.

## Material guardado y siguiente uso

Los once SWF del CDN, el air.swf Windows, la configuración y el AS3 seleccionado están en [restoration/references/ninjasaga-cc](../restoration/references/ninjasaga-cc). El [manifest.json](../restoration/references/ninjasaga-cc/manifest.json) registra tamaños, URL y SHA-256, incluidas las tres descargas originales.

Los instaladores completos permanecen en la carpeta local work/ninjasaga-cc del workspace; no se añaden al repositorio ni al despliegue. No se ejecutaron sus binarios. Ningún archivo nuevo sustituye silenciosamente el corpus histórico ni las excepciones activas.

Uso próximo: comparar las clases auxiliares con los contratos históricos y revisar cada recurso faltante por huella y símbolos. Primero se mantiene pendiente cerrar tutorial → guardado → aldea → recarga y su verificación pública. Esta investigación no cambia el estado publicado de versión 2.
