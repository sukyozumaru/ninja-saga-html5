# Recursos faltantes y avance del tutorial

Fecha: 2026-10-18. Corrección incremental; no se declara el juego completamente restaurado.

## Diagnóstico reproducido

1. El primer Create requiere `hair_10_1.swf` durante la precarga de ambos géneros; el corpus histórico devuelve 404.
2. Tras resolver ese archivo, se abre el editor original. El Create del editor requiere `swf/library/library.swf`, también ausente del corpus.
3. Al incorporar la biblioteca recuperada se llega a la elección original de elemento y al combate introductorio con Training Dummy. No se han modificado el SWF principal, las fórmulas ni el motor de combate.
4. Al terminar la introducción aparece de nuevo el error genérico. El contrato de persistencia continúa sin implementar: CharacterDAO.createCharacter, SystemData.getCreateCharacter y CharacterDAO.getExtraData. No se afirma persistencia ni acceso a la aldea.

## Excepciones con procedencia explícita

| Recurso | Tratamiento |
|---|---|
| hair_10_1.swf | Geometría vectorial nueva por autorización expresa del usuario, interfaz MovieClip compatible. No es arte original autenticado. XML editable y geometría en restoration/reconstructed/hair_10_1. SHA-256 c249e70573d353546558f8f8725c153cc17d91f97716fd9967eddee59cdaefc7. |
| library.swf | Copia sin modificar recuperada de shenjai47/NinjaSaga, web/cdn/swf/latest/swf/library/library.swf. 7058627 bytes; SHA-256 1b57b1779a5ba3f97d7bc2610dbfe4ac718f3d137ae088a01e0a6ab621bfb8f3. Conservada aparte en restoration/recovered. No autenticada para este build. |

Se inspeccionaron estáticamente 937 clases de library.swf con JPEXS: símbolos de imagen/audio, constructores, acciones de timeline y AppData. Se observaron acciones stop, retirada de efectos visuales y selección de plataforma; la inspección no encontró un motor de combate en esta biblioteca. Esto no prueba su equivalencia exacta con la versión perdida.

## Búsqueda adicional

- Archivo histórico https://archive.org/details/ninja_saga: sin los dos SWF requeridos.
- Consulta exacta de hair_10_1.swf y variantes: sin copia autenticada encontrada.
- Copias auxiliares de cabello en dos repositorios comunitarios: hashes distintos, autenticidad histórica no demostrada; se conservaron como evidencia, no como original canónico.
- APK https://archive.org/details/NinjaSaga0.9.30: cero SWF; análisis separado en APK-ANDROID-0.9.30.md.
- https://archive.nscommunity.cc/ se describe como archivo de recompensas del servidor comunitario actual; no proporciona prueba del recurso histórico buscado.
- https://softchuenk.blogspot.com/2012/03/full-swf-file-ninja-saga.html describe archivos alterados para trampas, no un corpus íntegro original.
- https://forum.ragezone.com/threads/ninja-saga-3-3-00810-3-3-00890.1203836/page-5 documenta independientemente el faltante library.swf; el enlace de recuperación está oculto para visitantes, por lo que no se verificó.

## Corrección de infraestructura y pruebas

Las respuestas de Cache API tienen cabeceras inmutables; Vinext intenta añadir cabeceras a la respuesta. Se crea una Response nueva con Headers mutables al recuperar un recurso de caché. Antes se reprodujo HTTP 500 en action_base.swf; después pasó la descarga y verificación SHA-256.

Pruebas locales: registro, login, lista, rechazo de contraseña/sesión inválidas; nueve recursos originales verificados por hash; cabello y biblioteca excepcionales con identidad explícita. Prueba visual: editor, selección de género y peinado, elección de fuego, combate introductorio. Las tres pruebas existentes de autenticación pasan. Las rutas desconocidas siguen devolviendo 404; no hay sustitución genérica.

El aviso exterior del sitio informa que el personaje no se guarda todavía. No se oculta el error original ni se declara que el backend pendiente esté restaurado.

## Publicación

Versión 2 de Sites publicada en https://ninja-saga-restoration.heartyglade5.chatgpt.site/client. Commit de fuente del alojamiento ea83c84dacacd27bf911d3c53ee7449e4f217012. Identificador de despliegue appgdep_6ad5499427188191872955fe1df09c53, estado succeeded. Paquete comprimido 24784641 bytes. Las comprobaciones HTTPS de registro, AMF, nueve originales, ambos recursos adicionales y 404 desconocido pasaron después de publicar.

Verificación visual en producción: selección → editor → elección de fuego → combate con Training Dummy y aviso original «Click to use Jutsu». Se pulsó el jutsu indicado. Evidencia: public-editor.png y public-tutorial.png. No se considera demostrado el guardado ni acceso a la aldea.
