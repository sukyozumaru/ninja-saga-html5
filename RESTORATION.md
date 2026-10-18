# Objetivo: restauración 1:1 de Ninja Saga

La meta es trasladar el juego original completo a un navegador moderno, conservando lo mejor posible sus pantallas, personajes, animaciones, controles, fórmulas, misiones, progresión, inventario y comportamiento online. HTML5 y el backend propio son sustituciones técnicas, no una autorización para rediseñar el juego.

El código y los recursos recuperados de una misma versión son la referencia principal. Los clones comunitarios son referencias auxiliares: sus mecánicas no se copiarán como si fueran las originales. Cada ausencia, adaptación o diferencia deberá registrarse y comprobarse.

El experimento de combate nuevo se apartó antes de hacer commit y no forma parte del repositorio. El arranque local existente mediante Ruffle se conserva como herramienta de referencia, sin considerarlo una migración nativa completa ni una prueba de fidelidad total.

## Primer entregable

[Informe de análisis del cliente histórico y arquitectura de reemplazo](restoration/INFORME-01.md).

Incluye las clases de combate, inventario y conexión; un corpus con huellas SHA-256; AS3 descompilado; servicios observados; límites de las referencias y criterios para validar la restauración 1:1.

## Regla de trabajo

Cada funcionalidad trasladada debe enlazar su implementación con código o datos de origen y una comprobación de equivalencia. Las funciones todavía no reconstruidas permanecen pendientes. Una respuesta simulada, un gráfico sustituto o una fórmula aproximada no cuentan como una función restaurada.
