# Reservas de sala

App Flutter para que un estudiante autenticado reserve una sala de estudio por un intervalo
de tiempo. Los datos viven en Supabase.

## Correr las pruebas

```bash
flutter pub get
flutter test
```

Las pruebas de `test/` no necesitan red ni Supabase: usan un repositorio en memoria
(`test/support/reservas_en_memoria.dart`).

## Correr la app

1. Crea un proyecto en Supabase y ejecuta `supabase/migracion.sql` en el SQL Editor.
2. Copia la URL del proyecto y su clave publishable desde **Settings → API Keys**.
   La app Flutter solo debe usar la clave publishable. Nunca pongas una clave
   `service_role` o `secret` en una app móvil o web.
3. Si una clave `service_role` real ya se publicó en Git o en un bundle, desactívala
   en Supabase; quitarla del código no la revoca.
4. Inicia la app pasando esos valores en tiempo de compilación:

   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
     --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_your_key
   ```

Las políticas RLS requieren una sesión autenticada y que la reserva pertenezca al
usuario autenticado. Esta app asume que el inicio de sesión se realiza fuera de este
repositorio, como se indica en el encargo.

## Estructura

```text
lib/
├── domain/        reglas de negocio (Dart puro)
├── data/          acceso a Supabase
└── presentation/  pantallas
specs/001-reservas-sala/   spec y plan (GitHub Spec Kit)
supabase/                  esquema de la base
test/                      pruebas de dominio
```
