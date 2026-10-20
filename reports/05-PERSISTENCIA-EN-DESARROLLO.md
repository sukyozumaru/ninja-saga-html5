# Persistencia y aldea: cierre de desarrollo

Fecha: 2026-10-19. Este checkpoint no está desplegado. La prueba pública continúa en versión 2, con guardado pendiente.

## Implementación y evidencia

Se incorporan a hosting los contratos de alta, lista, carga, SystemData, datos adicionales y estadísticas; migraciones aditivas de personajes y estadísticas; comprobación de archivos con firmas y tamaños reales; y corrección del decodificador AMF0 para conservar listas ECMA y orden de propiedades.

La elección activa del tutorial se envía al servidor después del alta, desde Battle. Mission_01_StoryMC2 selecciona antes el jutsu en el cliente. La validación inicial exigía una llamada previa de otra función y rechazó el guardado; se corrigió para guardar identidad pendiente y confirmar después el jutsu sin inventar un elemento. La corrección todavía requiere repetir el recorrido visual completo.

Siete pruebas pasan con `node --test lib/amf.test.mjs lib/auth.test.mjs lib/characters.test.mjs` desde hosting: persistencia al cerrar/reabrir SQLite, aislamiento de cuentas, reintentos sin premios duplicados, apariencia, paletas, elección única, firmas, integridad y un paquete AMF independiente.

Una prueba local con un personaje creado mediante protocolo llegó a la aldea original con 130 XP y 550 oro. Esto no demuestra que una cuenta nueva complete el tutorial y se guarde correctamente en el recorrido visual real. Tampoco acredita producción.

## Recurso auxiliar y diferencia declarada

Panel_New_Daily_Login.swf se recupera sin modificar de shenjai47/NinjaSaga, separado del corpus original autenticado. SHA-256: `317748bc2dcbd56256f5f3add43aafa4e0a4955ae940db0f4ffb951ae38aec43`, 107286 bytes. Build exacto sin autenticar. El calendario del servidor no se recuperó: la adaptación expresa campaña inactiva, sin premios reclamables; no cuenta como restauración de recompensas diarias.

## Próximo criterio de cierre

1. Cuenta nueva: tutorial completo, guardado y entrada a la aldea usando la corrección del orden de llamadas.
2. Recargar y volver a iniciar sesión; comprobar misma identidad, apariencia, elemento, XP y oro, sin duplicar premios.
3. Verificar otra combinación de elemento/género y recuperación de un alta interrumpida.
4. Compilar, desplegar migraciones y repetir por HTTPS antes de cambiar el aviso público.

Después: primer ciclo de misión original con persistencia; inventario, equipo y progresión; sistemas sociales y eventos según evidencia; port HTML5 nativo por módulos con comparación contra el cliente preservado. No se estima un porcentaje global ni fecha final sin inventario completo.

Contrato y fuentes: [CONTRATO-PERSISTENCIA](../restoration/CONTRATO-PERSISTENCIA.md), con AS3 de evidencia en restoration/evidence/tutorial. No se modificó el corpus histórico de SWF.
