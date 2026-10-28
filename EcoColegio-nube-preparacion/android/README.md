# EcoColegio para Android

Proyecto Android Studio que empaqueta la versión web de EcoColegio dentro de una aplicación Android mediante WebView. El HTML está en `app/src/main/assets/index.html`, por lo que la interfaz se carga desde el propio teléfono y puede abrirse sin conexión si no depende de servicios externos.

## Generar e instalar

1. Instala Android Studio (versión reciente) y el Android SDK Platform 35.
2. Abre esta carpeta `EcoColegioAndroid` en Android Studio.
3. Espera a que termine la sincronización de Gradle.
4. Conecta un teléfono Android con depuración USB activada o usa un emulador.
5. Pulsa **Run** para instalar y ejecutar.
6. Para crear el APK: **Build > Build Bundle(s) / APK(s) > Build APK(s)**. Android Studio mostrará la ubicación del APK generado.

## Limitaciones importantes

- Este entorno no tiene Android SDK ni Gradle instalados, así que no se pudo compilar ni verificar un APK aquí. El ZIP contiene el proyecto fuente listo para abrir y compilar en Android Studio.
- Los usuarios, registros, evidencias y puntos usan `localStorage` del navegador/WebView. Permanecen en ese dispositivo y no se sincronizan entre estudiantes o teléfonos. Desinstalar o borrar los datos de la app puede eliminar esa información.
- El inicio de sesión de la versión actual es local, no autenticación segura en un servidor. Para una implementación escolar multiusuario real, se requiere backend, base de datos y control de permisos.
- No se añadió permiso de Internet porque la app carga el HTML local. Si después se agregan servicios externos, habrá que revisar permisos y políticas de seguridad.
