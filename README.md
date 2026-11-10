# Nuki

Plataforma académica de Medicina para Android. La app consume contenido versionado
desde un repositorio privado de GitHub a través de un Worker de Cloudflare, sin
exponer el token de GitHub dentro del APK.

- App Flutter: `lib/`
- API y landing: `nuki-worker/`
- Datos privados: `QuopTron/nuki-data`
- Descarga: https://nuki-api.guttural-engineer.workers.dev
- Última versión: 1.0.2

## Compilar

```bash
flutter pub get
flutter build apk --release --split-per-abi \
  --dart-define=NUKI_API_URL=https://nuki-api.guttural-engineer.workers.dev \
  --dart-define=NUKI_APP_KEY=TU_CLAVE
```

Las variantes quedan en `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
y `app-armeabi-v7a-release.apk`. El release oficial publica esos dos APK, sin el
universal pesado: ARM64 para teléfonos modernos y ARM 32-bit para equipos antiguos.

## Descarga

https://nuki-api.guttural-engineer.workers.dev/#descargar
