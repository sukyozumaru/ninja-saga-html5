# Ayuda a restaurar Ninja Saga / Help preserve Ninja Saga

El objetivo es restauración 1:1 y traslado fiel a HTML5. Las contribuciones deben identificar su fuente, versión, diferencia y prueba. El cliente histórico es la referencia: no sustituir fórmulas, pantallas, animaciones ni contenido por reglas nuevas o de clones.

Prioridades:

1. Recuperar recursos de 3.3.00810, empezando por `swf/items/hair_10_1.swf`. Adjuntar URL de procedencia, tamaño, SHA-256 y evidencia de versión. Un nombre coincidente no autentica el archivo.
2. Reconstruir contratos AMF de creación/carga de personajes usando los consumidores AS3 del corpus.
3. Capturar referencias visuales y secuencias de animación del mismo build, sin datos privados de jugadores.
4. Validar importación de timelines y ejecución de reglas originales en HTML5.

Abre una issue con evidencia o un PR acotado. No publiques contraseñas, tokens, sesiones ni perfiles privados. Reproduce los fallos únicamente en localhost. Un recurso ausente debe devolver 404 y quedar registrado; no crear donantes ni archivos vacíos para ocultarlo.

## English

We are restoring the historical Ninja Saga client as faithfully as the recovered evidence allows, then working toward a native HTML5 port. The current milestone is the unmodified historical SWF loading its original libraries, authenticating against a local replacement service, and reaching the original character selection screen. This is **not a complete playable restoration**.

We welcome ActionScript/AVM2 analysis, AMF contract reconstruction, archival asset provenance, animation/timeline preservation, and reproducible compatibility tests. Attach source/version evidence and explain how you checked equivalence. Community clients are auxiliary references. Original game material retains its existing rights; public repository visibility does not grant a new license over that material.
