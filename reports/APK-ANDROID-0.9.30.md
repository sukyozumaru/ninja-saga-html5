# Inspección del APK Ninja Saga 0.9.30

Fecha: 2026-10-18. Inspección estática; APK no instalado ni ejecutado.

Fuente: https://archive.org/details/NinjaSaga0.9.30
Archivo descargado: Ninja Saga 0.9.30.apk, 22 349 240 bytes.
SHA-1: 7ef686fd2f34e3f0ca0abf7c1c55ae45848ee161 (coincide con metadatos del archivo).

El manifiesto contiene paquete com.emagist.ninja_saga y versión 0.9.30.
Certificado incluido: CN=Boniface Lee, OU=Emagist Entertainment Limited, O=Emagist Entertainment Limited.
Huella MD5 del certificado: 4d0631a66c35861341ee753059dfc06e.
Huella SHA-1 del certificado: fb13bec0bf39aeec81215fa6ab3fb9b7cb3f571b.
La huella MD5 coincide con la publicada por Uptodown para Ninja Saga Android (https://ninja-saga.br.uptodown.com/android). Es corroboración independiente de identidad de firma, no verificación criptográfica completa de las firmas JAR ni garantía de ausencia de modificaciones/malware.

Contenido observado: 8030 XML, 2462 plist, 235 MP3, 92 PNG, classes.dex (8424688 bytes), bibliotecas nativas libgdx.so/libandroidgl20.so para ARM. Hay tablas de misiones, personajes y layouts. Cero archivos SWF y cero fuentes .as o .java. No aparece hair_10_1 en los nombres de archivo. No se encontraron archivos del servidor en el inventario inspeccionado.

Conclusión: indicios sólidos de pertenecer a la aplicación Android histórica de Emagist. No es el cliente Flash/Facebook 3.3.00810 ni su código fuente, y no aporta directamente el SWF hair_10_1.swf que falta en el despliegue. Conservar como fuente secundaria separada: datos, arte y audio móviles requieren comparación antes de usarse en restauración 1:1; no asumir mismas mecánicas o formato.
