# Persistencia posintroducción y carga del personaje

Fecha de trabajo: 19 de octubre de 2026. Implementación en `hosting/lib/characters.mjs`; base alojada D1, independiente de localhost. No se cambia ningún SWF del corpus histórico.

## Fuentes normativas y límites

- `as3/code_library/ninjasaga/Battle.as:11383`: alta con siete argumentos al finalizar el combate; `character_id` al nivel superior; SystemData de alta sin envoltorio `result`; getExtraData firmado.
- `evidence/tutorial/Mission_01.as` y `Mission_01_StoryMC2.as`: extraídos del SWF archivado, SHA-256 `f19c7696b7af85fd64df177ec4650924186a5c4f65c2c82b30da36155f7e40de`. La función selectSkill de Mission_01 contiene una llamada previa, pero el timeline activo usa StoryMC2 y no la envía: se comprobó con el recorrido real. Battle transmite la elección después del alta y getExtraData. Habilidades iniciales exactas: agua skill9, fuego skill10, tierra skill12, rayo skill1, viento skill13.
- `evidence/tutorial/MissionDetail.as`: extraído de data_library_en.swf archivado, SHA-256 `c83a9eddf384eab355ec6f6f79598c3450ec0f0701e46dc01153443994027a8d`; msn0 da 130 XP, 250 oro y cero TP/SP.
- `as3/code_library/ninjasaga/dbclass/DBCharacter.as`: nivel 1, 0 XP, 300 oro, atributos elementales cero y equipo inicial set1/wpn1.
- `as3/code_library/ninjasaga/Character.as:753`: rama específica de alta/tutorial proporciona reward_items item1, item2, item3. Se usa esa rama del motor, sin adoptar recompensas de un servidor comunitario. El SWF de misión también contiene una lista heredada de dos unidades de cada objeto; no se observó que completeMission la consumiera. Esta diferencia queda documentada, no se declara autenticar un volcado de backend.
- `as3/code_library/ninjasaga/DataParser.as`: parseRawCharacter, parseCharacterData y parseSystemData determinan tipos, listas separadas por comas, apariencia y hashes. `Data.TEST_VERSION=false` hace que el cliente utilice sus propios catálogos.
- `as3/client_library/ninjasaga/linkage/ClientLibrary.as`: SHA-1 truncado a 12 caracteres, desplazado por el segundo dígito hexadecimal de sesión. No se desactivan comprobaciones.

## Modelo del backend de reemplazo

Una cuenta gratuita conserva un personaje. La restricción única en la base evita altas concurrentes duplicadas. El perfil conserva el género, índices exactos de paleta, sufijos de cabello/cara, habilidad inicial, equipo y recompensa de msn0. El alta repetida con la misma identidad devuelve el mismo ID y no incrementa recompensas. Una identidad distinta con el hueco ocupado se rechaza.

El alta guarda primero la identidad y apariencia con el estado inicial (0 XP, 300 oro, sin jutsu inventado). La elección transmitida después por Battle confirma el elemento y completa la salida de la introducción una sola vez. Se acepta también la llamada previa de la otra función recuperada si llega; no se exige al timeline activo. No se inventa un elemento por defecto. Las repeticiones confirman la misma habilidad, sin permitir cambiarla gratuitamente. La sesión registra qué personaje ha seleccionado su propietario; las lecturas cruzadas entre cuentas se rechazan.

El perfil persistido representa la salida del tutorial: 130 XP, 550 oro, sin repetir premios en una recarga. La llamada getExtraData durante el callback de alta acepta también el hash del estado local previo (0 XP) de esa sesión recién creada; al recargar solo se acepta el XP guardado. Esto conserva la secuencia asíncrona del cliente.

Las migraciones son aditivas. Las contraseñas y sesiones no se publican. Los servicios de misiones posteriores, compras y progresión no implementados siguen devolviendo un error explícito.

## Integridad de recursos y panel diario

`Main.fileCheck` se valida en el servidor contra rutas y tamaños reales del corpus, incluidos los tamaños declarados descomprimidos de los SWF. Su firma se reproduce sin modificar el algoritmo del cliente. Las entradas desconocidas o alteradas se rechazan. El selector de grupo map_key corresponde a los grupos admitidos por el cliente; sus listas comienzan sin observaciones y el propio AS3 registra las primeras cargas. El servidor comprueba todas esas cargas contra su catálogo preservado.

El panel `Panel_New_Daily_Login.swf` se recuperó sin modificar de shenjai47/NinjaSaga y se mantiene separado de los originales autenticados. Su correspondencia exacta con el build no está autenticada. La interfaz solicita un calendario mensual del servidor que no se recuperó. La respuesta expresa una campaña inactiva, con aviso de restauración pendiente, casillas sin premio y botones de reclamar ocultos. No se reconstruyen ni se simulan premios diarios; cualquier reclamación se rechaza. Esta adaptación de compatibilidad no cuenta como restauración de las mecánicas diarias.

## Validación

Las pruebas automatizadas cierran y reabren SQLite, verifican recarga, aislamiento de propietarios, repetición de altas, apariencia y paletas, habilidad inicial única, firmas y rechazo de archivos alterados. La verificación visual y la publicación se registrarán en el informe de esta entrega; el éxito de estas pruebas por sí solo no demuestra entrada a la aldea.
