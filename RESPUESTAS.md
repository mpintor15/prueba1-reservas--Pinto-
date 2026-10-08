## Escenarios que elegí y por qué

Elegí cruces parciales en ambos sentidos y una solicitud que contiene una reserva existente para cubrir distintos extremos del solapamiento (`specs/001-reservas-sala/spec.md:38-46`). Añadí los casos de horarios contiguos y de otra sala para fijar los límites de la regla
(`specs/001-reservas-sala/spec.md:47-50`). Las pruebas también cubren una solicitud contenida y un intervalo idéntico (`test/crear_reserva_test.dart:91-100`). El caso de uso aplica la regla con comparaciones estrictas de inicio y fin (`lib/domain/crear_reserva.dart:18-20`).

## Riesgo más grave del repositorio

La configuración versionada contiene una clave literal con rol `service_role`
(`lib/data/supabase_config.dart:3-4`), y el README recomienda usar ese tipo de clave
(`README.md:18-20`). `lib/main.dart:11` pasa la clave a Supabase desde la app. Si corresponde a un proyecto real, la clave privilegiada está expuesta y debe rotarse. Además, las políticas dejan que cualquier usuario autenticado lea todas las reservas (`supabase/migracion.sql:16-19`) y permite inserciones con `with check (true)` (`supabase/migracion.sql:21-24`); `usuario_id` solo referencia una fila de `auth.users` (`supabase/migracion.sql:7`), sin vincularla al usuario actual.

## ¿La regla protege la app real?

Todavía no: la pantalla inserta directamente en Supabase (`lib/presentation/reserva_page.dart:58-65`), aunque `lib/main.dart:13-14` construya `CrearReserva` y `lib/main.dart:26` la entregue a la página. La tabla solo valida que el fin sea posterior al inicio (`supabase/migracion.sql:4-12`); no declara una restricción contra solapamientos. Por eso, una inserción directa puede evitar la regla del dominio.
