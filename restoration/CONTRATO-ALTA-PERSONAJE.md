# Contrato observado de alta del personaje

Fuente normativa: cliente histórico, `restoration/as3/code_library/ninjasaga/Battle.as:11383–11423`, y `main/ninjasaga/linkage/SelectCharMenu.as`. Documento de análisis; estos servicios todavía no están implementados en el servidor histórico.

## Momento de persistencia

El flujo original no crea la fila definitiva del personaje inmediatamente al pulsar Create. `SelectCharMenu.onAmfCreateCharacterResult` prepara el personaje en memoria, marca `isNewChar` e `isNewCharByCreate` e inicia el flujo original. En `Battle.battleFinish`, la rama que comprueba ambos indicadores llama a `CharacterDAO.createCharacter`. Por ello el backend no debe sustituir silenciosamente la secuencia de introducción/combate por un alta inmediata desde una interfaz nueva.

## Petición AMF posicional

`CharacterDAO.createCharacter` recibe exactamente siete argumentos observados:

| Posición | Expresión original / significado |
|---|---|
| 0 | `Account.getAccountSessionKey()` — sesión |
| 1 | `Central.main.getDBChar().character_name` |
| 2 | `Central.main.getDBChar().character_gender` |
| 3 | Índice del color de pelo dentro de `Data.getHairColorArr()` |
| 4 | Índice del color de piel dentro de `Data.getSkinColorArr()` |
| 5 | `character_hair.replace("hair_", "")` — conserva el sufijo completo, incluido género |
| 6 | `character_face.replace("face_", "")` — conserva el sufijo completo |

Los colores enviados son índices de las paletas originales, no valores RGB libres. Los identificadores de pelo y cara no deben convertirse automáticamente a un único entero.

## Respuesta y continuación

1. `onAmfCreateCharacter` valida la respuesta con `Main.validateAmfResponse` y obtiene **`character_id` en el nivel superior**, no dentro de `result`.
2. Solicita `SystemData.getCreateCharacter([session, Data.TEST_VERSION])`.
3. Su callback pasa **la respuesta completa** a `DataParser.parseSystemData`. Esto difiere del flujo de carga de un personaje existente, que toma `response.result` al recibir `SystemData.get`.
4. Calcula `Central.main.getHash(String(character.xp))` y solicita `CharacterDAO.getExtraData([session, xpHash, ACCESS_TOKEN])`.
5. Valida y entrega `response.result` a `DataParser.parseCharacterData`.

Para personajes existentes, `SelectCharMenu.amfGetCharacter` llama a `CharacterDAO.getCharacterById([session, selectedCharSelectId])`; el callback usa `DataParser.parseRawCharacter(response.result, false, true)` y después solicita `SystemData.get`.

## Pendiente antes de implementar

- Recuperar o autenticar `hair_10_1.swf`, requerido por la precarga original de personalización.
- Documentar los datos iniciales que el tutorial entrega al personaje y las reglas de validación del nombre, género y paletas.
- Reconstruir los campos completos de SystemData y getExtraData a partir de sus consumidores; no reutilizar respuestas de clones como si fueran el contrato original.
- Probar la secuencia original hasta la persistencia, recarga y entrada en la aldea. Estas etapas no se consideran restauradas todavía.
