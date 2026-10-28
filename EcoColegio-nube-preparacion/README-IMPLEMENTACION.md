# EcoColegio — preparación de roles y base de datos compartida

## Qué incluye esta entrega
- `index.html`: copia del diseño actual con el enlace público de autocreación de cuentas oculto.
- `android/`: proyecto Android WebView existente, con el mismo HTML actualizado.
- `supabase/supabase_schema.sql`: esquema inicial de datos y políticas Row Level Security (RLS).
- `supabase/functions/admin-create-student/index.ts`: función de servidor para que un administrador cree cuentas de estudiantes.
- Se conserva el proyecto original; no se genera un proyecto distinto desde cero.

## Importante: qué está y qué no está activo
Esta entrega prepara la interfaz y el backend inicial, pero **la sincronización en la nube aún no está conectada ni probada** porque EcoColegio no tiene un proyecto Supabase configurado en esta entrega. El HTML conserva parte de la lógica local existente; no debe usarse como sistema multiusuario real hasta completar la integración del inicio de sesión y de las lecturas/escrituras de datos con Supabase.

## Modelo de permisos
- `admin`: puede gestionar registros de reciclaje, actividades, perfiles y configuración.
- `student`: solo puede consultar datos compartidos.
- La contraseña la gestiona Supabase Auth; no se guarda en la tabla `profiles`.
- La función `admin-create-student` valida la sesión y el rol de administrador en el servidor antes de crear una cuenta.

## Configurar Supabase
1. Crear un proyecto en Supabase.
2. Abrir **SQL Editor** y ejecutar `supabase/supabase_schema.sql`.
3. Crear el primer usuario administrador desde el panel de Auth.
4. Insertar su perfil con `role = 'admin'` en `public.profiles`, usando el UUID de ese usuario:
   ```sql
   insert into public.profiles (user_id, full_name, display_name, grade, role, active)
   values ('UUID_DEL_USUARIO_ADMIN', 'Administrador EcoColegio', 'Administrador', 'Institución', 'admin', true);
   ```
5. Desplegar la Edge Function `admin-create-student` con Supabase CLI y configurar sus secretos de servidor.
6. Integrar el HTML con Supabase Auth y las tablas para reemplazar el login y almacenamiento local. Esto es obligatorio para que la app use cuentas reales y datos sincronizados.
7. Probar permisos con una cuenta estudiante: debe fallar cualquier intento de insertar, actualizar o borrar registros.

## Seguridad
- Nunca pegues ni publiques la clave `service_role`.
- No incluyas credenciales privadas en HTML, ZIP, repositorios ni APK.
- Las cuentas iniciales deben ser creadas por el administrador.
- Usa contraseñas de al menos 8 caracteres y entrega las credenciales de forma privada.

## Próximo paso
Con el proyecto Supabase creado, la siguiente fase es conectar el inicio de sesión, el panel de administración, la creación de cuentas y las consultas del ranking a la nube. No compilar el APK definitivo hasta terminar esa integración y probarla.
