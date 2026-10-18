# Informe 01 — cliente histórico y backend de reemplazo

Fecha: 18 de octubre de 2026. Objetivo aceptado: **restauración 1:1 de Ninja Saga, lo mejor que permitan las fuentes disponibles**.

## Resultado del análisis

Hay suficiente código recuperado para comenzar una migración basada en el funcionamiento real. Se identificaron el procesador del combate, las fórmulas, la actualización del personaje, el inventario, el gestor AMF y el canal de combate local/red. **Todavía no existe un port nativo completo ni se ha recuperado un backend original autenticado.**

La demostración que introducía reglas nuevas fue apartada antes de hacer commit. Se conserva fuera del proyecto, en el directorio de trabajo, y no se utiliza como implementación ni referencia de fidelidad.

Este informe separa tres niveles: **observado** en los archivos; **propuesto** para la nueva infraestructura; **pendiente** de comprobar. Que FFDec produzca un archivo AS3 no prueba por sí solo que sea compilable o equivalente al bytecode.

## 1. Corpus y procedencia

Fuente histórica: [colección ninja_saga de Internet Archive](https://archive.org/details/ninja_saga), archivo `ns-static-bwhcb6a5289.netdna-ssl.com.7z`, ya descargado. Los cinco SWF analizados se preservan sin modificar en `corpus/3.3.00810/`. Sus tamaños y SHA-256 están en [manifest.json](manifest.json).

| Módulo | Archivos AS3 exportados | Función observada |
|---|---:|---|
| `ninja_saga.swf` | 305 | Entrada, pantallas, contenedores visuales, constantes y arranque |
| `code_library.swf` | 223 | Combate, fórmulas, personajes, inventario, misiones y orquestación |
| `network_library.swf` | 139 | Comunicación, sockets, codificación y utilidades |
| `client_library.swf` | 10 | Funciones de hashes y clases con identificadores no legibles |
| `menu.swf` | 195 | Menú, pantallas y definiciones compartidas |
| **Total** | **872** | Archivos por módulo, no 872 clases únicas |

Herramienta: [JPEXS FFDec 26.3.0](https://github.com/jindrapetrik/jpexs-decompiler/releases/tag/version26.3.0). Los módulos se mantienen separados: hay clases con el mismo nombre presentes en distintas bibliotecas. Fusionarlas automáticamente puede elegir una definición equivocada.

La carpeta del archivo histórico indica `3.3.00810`, pero `main/ninjasaga/data/Data.as:26` declara **`BUILD_NO = 3.3.00809`**. Esto es un hecho del archivo, no prueba automática de corrupción. Antes de declarar una versión canónica se debe contrastar la combinación de bibliotecas, los datos y el arranque. Tampoco se ha autenticado la fecha exacta del build.

Se exportaron del SWF principal **73 imágenes: 65 PNG y 8 JPG**, conservadas en `assets/main/`. La exportación de sonidos de ese SWF no produjo archivos. Esto no significa que el juego carezca de audio: falta seguir las cargas de sus recursos externos. Los SWF originales conservan los símbolos y timelines; **no se ha hecho aún una exportación exhaustiva de todas las animaciones, fuentes, idiomas y sonidos de la colección**.

## 2. Legibilidad y recuperación de métodos

Gran parte del AS3 tiene nombres útiles y cuerpos legibles. Sin embargo, la afirmación de que todo el cliente original está libre de ofuscación no queda demostrada: el corpus contiene 11 declaraciones de clase con identificadores no estándar, incluidas clases `§…§` en `client_library`. Los registros de FFDec también mostraron diagnósticos de saltos inválidos.

Con un límite inicial de 20 segundos por método quedaron tres cuerpos sustituidos por marcadores de timeout:

| Clase / método | Instrucciones indicadas por FFDec | Resultado del reintento |
|---|---:|---|
| `Battle.attackHit_CB` | 7.474 | Cuerpo AS3 recuperado con límite ampliado |
| `CharacterBattle.nextBattleRound` | 9.379 | Cuerpo AS3 recuperado con límite ampliado |
| `BattleProcessor.processDamage` | 13.139 | Cuerpo AS3 recuperado con límite ampliado |

Se reexportaron esas clases con límite de 90 segundos y se incorporaron los resultados al corpus AS3. La auditoría final no encuentra marcadores `Not decompiled` o `Decompilation error` en los 872 archivos. Se conserva además una exportación P-code de `Battle` y `CharacterBattle` en `evidence/code-pcode/`, y los SWF completos permiten revisar el resto. **La verificación semántica contra el bytecode sigue pendiente.**

Auditoría reproducible: `node restoration/audit.mjs`. Produce [classes.json](classes.json), [services.json](services.json) y [manifest.json](manifest.json). El contador de clases no estándar y la ausencia de marcadores son controles acotados, no certificaciones de ausencia de ofuscación o errores.

## 3. Sistema de combate real

| Clase | Funciones / evidencia | Responsabilidad y tratamiento en el port |
|---|---|---|
| [`ninjasaga.Battle`](as3/code_library/ninjasaga/Battle.as) | `attackHit_CB:2869`, `processDamage:6939`; llamadas a servicios de resultados | Orquesta acciones, animaciones, impacto y finalización. Conservar los puntos de impacto ligados al timeline. |
| [`ninjasaga.battle.BattleProcessor`](as3/code_library/ninjasaga/battle/BattleProcessor.as) | `characterTurn:211`, `nextRound:310`, `setupAction:1262`, `processCommand:1414`, `processDamage:6807` | Procesa comandos, turnos, buffs/debuffs y daño. Es una fuente principal del motor, no debe sustituirse por reglas de un clon. |
| [`ninjasaga.base.CharacterBattle`](as3/code_library/ninjasaga/base/CharacterBattle.as) | `nextBattleRound:349`, sobrescrituras de buffs y debuffs | Evolución del personaje durante el combate y efectos de ronda. |
| [`ninjasaga.data.Formula`](as3/code_library/ninjasaga/data/Formula.as) | `calcDamage:21`, `calcAgility:51`, `calcCritical:225`, `calcDodge:454`, `calcHP:676`, `calcCP:871` | Fórmulas concretas de la versión. Incluyen equipo y efectos; conservar redondeos y orden de cálculo. |
| [`ninjasaga.base.CharacterDisplay`](as3/code_library/ninjasaga/base/CharacterDisplay.as) | `updateHP:550`, `updateCP:580`, `updateBattleFrame:1020` | Sincroniza estado y representación visual. Aquí están los equivalentes observados de actualización de barras. |
| [`ninjasaga.linkage.BattleDoc`](as3/main/ninjasaga/linkage/BattleDoc.as) y `BattleActionBar` | `BattleDoc.gotoBattle`, estados de victoria/derrota, contenedores de equipo/enemigos | Pantalla y controles originales. Conservar distribución, estados y etiquetas, sin crear otra interfaz. |
| [`ninjasaga.net.Client`](as3/network_library/ninjasaga/net/Client.as) | `joinRoom`, `sendData`, `receiveDataHAV`; clase interna `BattleController:446` | Conecta el flujo del combate con un controlador local o con el socket de red. |
| [`ninjasaga.AICharacter`](as3/code_library/ninjasaga/AICharacter.as), `Enemy`, `Skill`, `Mission` | Clases recuperadas y dependencias de los catálogos | IA, entidades, habilidades y secuencias de misión. El análisis exhaustivo por efecto y misión está pendiente. |

### Orden de turno: ATB, no alternancia fija

La clase interna `BattleController` en `network_library/ninjasaga/net/Client.as:446` conserva `atbPos` por combatiente. En `start_atb` calcula una velocidad dependiente de agilidad y busca el tiempo restante hasta el umbral 600 (`:521` y `:531`). Luego avanza las barras y genera acciones al alcanzar ese umbral. Por tanto, ordenar una lista por agilidad una sola vez o alternar jugador/enemigo **no reproduce este mecanismo**. Deben conservarse posiciones, cambios de agilidad, redondeos y empates.

Otro ejemplo observado: `Formula.randomizeValue` varía el valor base en ±20 % y aplica `Math.round`. `calcDamage` añade además casos dependientes de objetos. Esto no autoriza a reducir el daño completo a una única multiplicación: el procesador añade más efectos y reglas.

### Rangos y progresión

[`RankData`](as3/code_library/ninjasaga/data/RankData.as) incluye `STUDENT`, `GENIN`, variantes talentosas de Chunin/Jounin, `SPECIAL_JOUNIN`, `TUTOR` y `TUTOR_SENIOR`. Sus límites declarados incluyen 20, 40, 60, 80 y 100. No debe reemplazarse esa tabla por la descripción resumida «Genin → Chunin → Jounin → Sage» del encargo sin contrastar cada rango, examen y requisito.

## 4. Inventario y personalización

| Clase | Evidencia | Función |
|---|---|---|
| [`ninjasaga.Character`](as3/code_library/ninjasaga/Character.as) | `equipCharacter:677`; `setInventory:1993`, `addInventory:1998`, `removeInventory:2113`, `getInventory:2129` | Inventarios por categoría, objetos poseídos y equipo activo. |
| [`ninjasaga.DataParser`](as3/code_library/ninjasaga/DataParser.as) | `parseCharacterData:239`, `parseRawCharacter:1081`; campos `character_item`, `character_weapon`, `character_skill` | Traduce la respuesta del servidor al modelo del cliente; varios campos usan listas separadas por comas. |
| [`ninjasaga.dbclass.DBCharacter`](as3/code_library/ninjasaga/dbclass/DBCharacter.as) y `DBCharacterData` | Definiciones recuperadas | Modelo y nombres de campos del personaje; no son el esquema original de base de datos. |
| [`ninjasaga.Item`](as3/code_library/ninjasaga/Item.as) y `InventoryData` | Registro de objetos; `getWeaponIcon`, `getBodySetModel`, `getSkillIcon` | Categorías, iconos y modelos. Separar propiedad del objeto y representación gráfica. |
| [`ninjasaga.StateInventory`](as3/code_library/ninjasaga/StateInventory.as) | `getStateDictionary`, `getStateOnCount`, `setStateDictionary` | Estados de inventario asociados al personaje y al ID del objeto. No representa por sí sola todo el inventario. |

`Character.equipCharacter:713` llama a `CharacterDAO.equipCharacter` con sesión, personaje, atuendo, arma y demás posiciones de equipo. El port debe preservar estos contratos y el significado de cada posición antes de normalizarlos en el backend nuevo. Cambiar prefijos de IDs o mezclar datos de versiones puede alterar objetos y animaciones.

Quedan por inspeccionar las pantallas de compra/venta y las bibliotecas cargadas dinámicamente (`popup.swf`, paneles específicos y datos). Encontrar un nombre en `TrackingSystem` no demuestra que ya se haya recuperado su llamada efectiva o su respuesta.

## 5. Gestor de conexión y contratos online

La cadena observada es:

`NinjaSaga / Main → AMFConnector.service → ZendAMFClient → NetConnection.call`.

- [`AMFConnector`](as3/code_library/ninjasaga/AMFConnector.as): singleton, inicialización AMF, último servicio y restricciones de ciertos llamadores. `initAmf:40` conecta a `Data.AMF_GATEWAY`; `service:63` delega en el transporte.
- [`ZendAMFClient`](as3/code_library/bitemycode/net/zendamf/ZendAMFClient.as): cola, `Responder`, callbacks y reintentos. En `process:126` construye el servicio y sus argumentos y llama a `connection.call.apply` (`:147`). La codificación concreta AMF0/AMF3 se debe confirmar con paquetes de esa versión; no se infiere solo del nombre de la clase.
- [`Data`](as3/main/ninjasaga/data/Data.as): el gateway histórico es `https://app.ninjasaga.com/amf_live1/` (`:333–335`). Los dominios se preservan como evidencia, no se utilizan para enviar partidas o credenciales.
- [`Socket`](as3/network_library/ninjasaga/Socket.as): configura y usa `com.pnwrain.flashsocket.FlashSocket`; conexión en `:220–227`. Hay además clases WebSocket en la biblioteca. Se debe reconstruir el handshake y el protocolo antes de elegir una versión de Socket.IO o asumir que basta un WebSocket moderno.
- [`ClientLibrary`](as3/client_library/ninjasaga/linkage/ClientLibrary.as): funciones de hashes y firmas consumidas por el cliente. Se conservan para compatibilidad; la autenticación del nuevo servicio deberá ser propia.

### Servicios observados

[services.json](services.json) registra **102 nombres únicos** encontrados en llamadas literales `.service("…")`, con archivo y línea. Es un mínimo observado: no incluye todos los nombres construidos dinámicamente ni los SWF todavía no analizados.

| Área | Ejemplos observados | Responsabilidad del reemplazo |
|---|---|---|
| Cuenta / arranque | `SystemService.snsLogin`, `SystemService.login`, `SystemData.get` | Identidad propia y respuesta compatible con el flujo del cliente |
| Personajes | `CharacterDAO.getCharactersList`, `createCharacter`, `getCharacterById`, `getExtraData` | Crear, cargar y persistir personajes con campos correctos |
| Equipo / progresión | `CharacterDAO.equipCharacter`, `updateAP`, `rankup`, `CharacterValidation.validateSkill` | Propiedad, requisitos, progresión y validación |
| Misiones | `CharacterService.startMission`, `CharacterService.updateCharacter`, `SLevelMission.finishMission` | Instancias, avance y cierre de misiones según su tipo |
| Recompensas | `ItemDAO.getBossReward`, `SpecialReward.getLvUpReward`, `claimLvUpReward` | Reglas y concesiones verificadas, persistencia sin duplicación |
| Social / PvP / guerras | `FacebookService.getFriendList`, `SocialNetwork.getFriends`, `PVPService.pvpFinishRecord`, `ClanWar.generateBattleResult`, `CrewWar.finishLandHunt` | Sustituir Facebook por relaciones propias; reconstruir salas y guerras |

En esta versión, `Mission.as:261` llama a `CharacterService.startMission` con tres argumentos y `Character.as:768` presenta el cierre/actualización mediante `CharacterService.updateCharacter`. **No es el mismo contrato** que `BattleSystem.startMission` del blog de Ninja Legends. Reutilizar directamente las peticiones de ese blog rompería la fidelidad del cliente histórico.

La sustitución de Facebook mantendrá cuentas, selección de personaje, relaciones de amigos y reclutamiento equivalentes dentro del nuevo servicio. Recuperar cuentas o progreso históricos reales requeriría sus datos originales; no se han recuperado con estos SWF.

## 6. Referencias solicitadas: utilidad y límites

### RaGEZONE y servidor Java

El [hilo de las versiones 3.3.00810 / 3.3.00890](https://forum.ragezone.com/threads/ninja-saga-3-3-00810-3-3-00890.1203836/) anuncia archivos Flash/SNS y señala dependencia del servidor. Parte de los enlaces requiere registro. No se recuperó de él un paquete Java autenticado como servidor original. Una búsqueda pública de repositorios `NinjaSaga language:Java` devolvió cero resultados; esa búsqueda acotada no demuestra que el código no exista.

El proyecto descargado de [pseudownload/Ninja-Saga-Private-Server](https://github.com/pseudownload/Ninja-Saga-Private-Server) usa Laravel/PHP y corresponde a NinjaSage. Sirve para estudiar servicios, persistencia y herramientas. El servidor Node que ya arranca localmente también es una reconstrucción y contiene respuestas simuladas y sustituciones de recursos. Ninguno se presenta como el backend original completo ni como prueba de compatibilidad con este corpus histórico.

### Clon raintrapper / Shinobi Saga

Se descargó [raintrapper/ninja-saga-clone](https://github.com/raintrapper/ninja-saga-clone), cuyo HEAD consultado es `d542116f2f24be2c7f0df47c9aa087784ae68657`. Los dos archivos del repositorio se conservan en `references/`. Su README lo describe como un duelo inspirado en Ninja Saga, sin recursos externos. No es el motor original; sus reglas no se adoptarán como referencia normativa. Su utilidad se limita a comparación de estructura y herramientas.

### Blog técnico

El [artículo de phvietan](https://blog.drstra.in/posts/game-hack/) analiza **NinjaLegends.swf**, no el SWF histórico de Ninja Saga examinado aquí. La observación del artículo sobre código no ofuscado y las clases `BattleManager` / `updateHealthBar` pertenece a esa recreación. El artículo ayuda a comprender el enfoque de análisis y AMF, pero no autentica las fórmulas, las clases o el servidor original. No se hicieron pruebas contra sus servidores externos.

## 7. Propuesta de cliente de destino

**Decisión provisional: evaluar Haxe/OpenFL para conservar las APIs Flash y los timelines, antes de comprometer una migración completa.** La cantidad de `MovieClip`, símbolos exportados, frame scripts y callbacks de impacto hace especialmente costosa una traducción que rasterice personajes y rediseñe las pantallas.

[as3hx](https://lib.haxe.org/p/as3hx) puede ayudar a convertir AS3 a Haxe. Esto no implica conversión semántica automática del juego completo. La [documentación oficial de SWF de OpenFL](https://www.openfl.org/learn/haxelib/tutorials/using-swf-assets/) describe importación de gráficos y MovieClips, y advierte limitaciones con características dependientes de ActionScript, incluidos scripts de fotograma. Por eso habrá que portar explícitamente esos scripts y comprobar sus secuencias.

Puerta de decisión: importar una **pantalla original y una secuencia de animación original**, conservando composición, símbolos, frame labels, máscaras y callbacks; ejecutar una función original de reglas con las mismas entradas y el mismo resultado. Si falla la compatibilidad necesaria, evaluar JS/TS con una capa de display-list/timeline y PixiJS. Esta prueba no debe introducir una escena nueva ni mecánicas inventadas.

Ruffle permanece como runner de preservación y herramienta de comparación. Ejecutar el SWF con Ruffle no se declarará una migración nativa completa.

## 8. Propuesta de backend de reemplazo

### Componentes

| Componente propuesto | Papel |
|---|---|
| Gateway de compatibilidad Node.js | Recibir AMF del cliente histórico, despachar solo servicios registrados y devolver contratos de esa versión. El codec local existente es un punto de partida que requiere fixtures históricos. |
| API de dominio | Misma lógica de cuenta, personajes, inventario, misiones, recompensas y social para el cliente portado; transporte JSON separado del modelo del juego. |
| Motor de reglas compartido y versionado | Traducción trazable del AS3 para fórmulas y resultados; entradas de RNG controlables en las pruebas. No usar los valores del experimento apartado. |
| Persistencia transaccional PostgreSQL | Cuentas, sesiones, personajes, inventario, equipo, habilidades, progreso, misiones y recompensas. Es un esquema nuevo, no el esquema histórico recuperado. |
| Servicio de salas de combate | Estados originales `info` / `command`, ATB y acciones ordenadas; adaptación del transporte Flash al navegador. |
| Catálogo versionado de recursos y datos | Manifiesto por build, IDs y hashes; evitar mezclar clientes y bibliotecas. Un recurso inexistente se registra como faltante, no como otro objeto clonado. |
| Trazas y comparación | Registrar llamadas y eventos locales para contrastar cliente histórico, backend y port. |

### Modelo de datos inicial propuesto

`accounts`, `sessions`, `characters`, `character_attributes`, `inventory_entries`, `equipment_slots`, `learned_skills`, `mission_progress`, `mission_runs`, `battle_actions`, `reward_grants`, `friend_relations`, `recruit_slots`, `clans`, `clan_members`, `war_seasons` y `war_scores`.

Las tablas se derivarán de los campos efectivamente usados, y las categorías/IDs se conservarán con una tabla de equivalencias explícita cuando haga falta. Una misión finalizada y su recompensa deben confirmarse en una misma transacción, con identificador de ejecución para impedir concesiones duplicadas. Las reglas de daño, botín y progresión deben proceder de fuentes verificadas o quedar pendientes.

### Frontera de compatibilidad

Durante la restauración, el adaptador AMF conserva firmas, argumentos posicionales y forma de respuesta. Durante el port, el cliente nuevo llama a la misma capa de dominio mediante JSON. Las salas de PvP requieren secuencia y estado propios; no se confía en un resultado de victoria enviado sin validación. Esto sustituye la infraestructura de Facebook, preservando las reglas y el comportamiento del juego.

No se propone trasladar dependencias vulnerables o compatibilidades inseguras del transporte antiguo como requisito de fidelidad. La fidelidad se verifica en el resultado y la experiencia del juego; autenticación, almacenamiento y validación se implementan para el backend propio.

## 9. Criterios de fidelidad 1:1

| Área | Evidencia exigida antes de marcar restaurada |
|---|---|
| Pantallas / controles | Comparación visual y funcional con la pantalla original de la versión elegida, incluyendo mensajes, estados y navegación |
| Animación | Símbolos, poses, orden de fotogramas, máscaras y momento de impacto; un PNG estático no sustituye una animación |
| ATB / combate | Misma secuencia de turnos y resultados con entradas, equipo, efectos y RNG controlados |
| Fórmulas | Casos de prueba derivados del AS3, conservando conversiones numéricas y redondeos |
| Habilidades | ID, coste, cooldown, restricciones, efectos, duración y recursos de cada técnica |
| Inventario / personaje | Mismos objetos poseídos, ranuras, requisitos, apariencia y persistencia tras salir/entrar |
| Misiones / emboscadas | Misma secuencia, enemigos, condiciones, finales y recompensas verificadas |
| Social / equipo / clanes / PvP | Contratos y flujos completos del servicio propio, con equivalencia funcional documentada |
| Contenido incompleto | Lista explícita de faltantes por versión; nunca sustituir silenciosamente datos o animaciones |

Debe existir una matriz completa de funcionalidades y contenido antes de declarar la restauración completa. Cada fila tendrá origen, implementación, pruebas de equivalencia y diferencias conocidas. Los primeros casos de prueba podrán ser acotados para validar la migración, pero no reducirán el alcance final a una demostración.

## 10. Siguiente hito verificable

1. Completar la identificación de bibliotecas, datos, paneles, audio y versiones del corpus histórico, incluidas dependencias dinámicas.
2. Crear un perfil aislado para ejecutar **ese cliente histórico sin mezclarlo** con la colección comunitaria que actualmente arranca en localhost.
3. Documentar los contratos de login, selección/carga de personaje, inventario y una misión usando el AS3 y pruebas locales. Un handler genérico que devuelve éxito no cuenta como contrato restaurado.
4. Capturar pantallas, timelines y trazas de referencia del cliente histórico.
5. Validar OpenFL/as3hx sobre esa pantalla y una función real; elegir la ruta de port a partir del resultado.
6. Ampliar la migración por sistemas, conservando la matriz 1:1 hasta cubrir el juego completo.

**Pendiente:** no se ha compilado el AS3 exportado ni el cliente nativo; no se ha verificado la totalidad de fórmulas, catálogos o animaciones; no se ha recuperado un backend Java original, la base histórica de usuarios ni contratos de todos los servicios. El presente entregable es el análisis inicial y una propuesta de arquitectura sustentada en archivos recuperados.
