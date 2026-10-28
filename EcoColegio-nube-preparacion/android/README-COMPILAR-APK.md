# EcoColegio para Android — listo para compilar en la nube

Este proyecto empaqueta `app/src/main/assets/index.html` dentro de una app Android mediante WebView. El HTML incluido corresponde a la versión EcoColegio moderna proporcionada.

## Cómo obtener el APK sin instalar Android Studio

1. Entra a https://github.com/ e inicia sesión o crea una cuenta.
2. Crea un repositorio nuevo llamado `EcoColegio-Android`.
3. Descomprime este ZIP en tu computador.
4. Sube **el contenido de esta carpeta** al repositorio; no subas el ZIP como un único archivo. Debes ver `app/`, `build.gradle`, `settings.gradle` y `.github/` en la raíz.
5. Abre la pestaña **Actions** y selecciona **Generar APK EcoColegio**. Pulsa **Run workflow** si aparece.
6. Espera a que la ejecución termine en verde.
7. Abre la ejecución completada, baja hasta **Artifacts** y descarga `EcoColegio-APK`.
8. Descomprime ese artefacto: dentro estará `app-debug.apk`. Pásalo al celular Android y ábrelo para instalarlo. Android podría pedir autorización para instalar aplicaciones desde esa fuente.

## Importante: limitaciones de esta versión

- Este ZIP es el proyecto fuente preparado para compilar en la nube; **no es el APK final**.
- No se pudo compilar ni verificar un APK en este entorno porque no hay Android SDK/Gradle instalado.
- La aplicación guarda usuarios, registros, puntos y evidencias en el almacenamiento local de ese dispositivo. No se sincronizan entre diferentes celulares.
- El inicio de sesión HTML no equivale a una autenticación segura de servidor. Para uso real de un colegio con múltiples usuarios hace falta un backend compartido, base de datos y permisos.
