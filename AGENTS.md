# Ninja Saga: restauración 1:1

El objetivo del usuario es restaurar y trasladar Ninja Saga Original completo a HTML5, con la máxima fidelidad posible. No es crear un juego inspirado, un clon simplificado ni una demostración con mecánicas inventadas.

- Usar el código y los recursos recuperados de una versión coherente como referencia principal. Conservar pantallas, controles, animaciones, fórmulas, ATB, objetos, misiones, progresión y comportamiento online.
- Leer `RESTORATION.md` y `restoration/INFORME-01.md` antes de implementar sistemas. Registrar origen, equivalencia y diferencias de cada funcionalidad trasladada.
- Los clones comunitarios y otros servidores son referencias auxiliares; no representan automáticamente el funcionamiento original.
- Preservar los SWF de `restoration/corpus/` y sus SHA-256. Mantener separadas las definiciones AS3 de distintas bibliotecas; no fusionarlas por nombre de clase sin análisis.
- Un resultado de descompilación no equivale al proyecto editable original ni garantiza compilación o equivalencia semántica. Revisar bytecode ante discrepancias.
- No sustituir silenciosamente recursos faltantes, respuestas de servidor o fórmulas por aproximaciones. Registrar lo pendiente y buscar evidencia. El comportamiento de clones/stubs del runner actual no cuenta como fidelidad demostrada.
- Mantener el runner local funcional como referencia. Ruffle es una herramienta de preservación, no la prueba de una migración nativa completa.
- El backend propio sustituye técnicamente los servicios de Facebook y los servicios perdidos. Sus contratos deben derivarse del cliente histórico y validarse localmente.
- No ejecutar pruebas de vulnerabilidades contra servidores de terceros. La investigación del protocolo se hace sobre archivos públicos y entornos propios.
- Guardar avances en el repositorio privado existente. Excluir credenciales, partidas de prueba y registros de sesión.

El usuario descartó expresamente el experimento HTML5 que introducía reglas nuevas. Ese experimento fue apartado fuera del proyecto antes de hacer commit y no debe recuperarse como base del port.
