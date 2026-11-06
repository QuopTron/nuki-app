const REPO_OWNER = "QuopTron";
const REPO_NAME = "nuki-data";
const REPO_BRANCH = "main";
const APP_REPO = "QuopTron/nuki-app";
const APK_ARM64 = "nuki-arm64-v8a.apk";
const ARCHIVOS = new Set([
  "indice.json",
  "materias.json",
  "recursos.json",
  "reels.json",
  "evaluaciones.json",
  "foro.json",
  "apuntes.json",
  "notificaciones.json",
  "usuarios.json",
  "modelos.json",
  "perfil.json",
]);

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET,PUT,OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type,X-Nuki-Key",
  "Access-Control-Max-Age": "86400",
};

function respuestaJson(datos, estado = 200) {
  return new Response(JSON.stringify(datos), {
    status: estado,
    headers: {
      ...CORS,
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "no-store",
    },
  });
}

function error(mensaje, estado = 400) {
  return respuestaJson({ error: mensaje }, estado);
}

function cabecerasGitHub(env) {
  return {
    Accept: "application/vnd.github+json",
    Authorization: `Bearer ${env.GITHUB_TOKEN}`,
    "X-GitHub-Api-Version": "2022-11-28",
    "User-Agent": "nuki-worker",
  };
}

function uriContenido(ruta) {
  return `https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/contents/${encodeURIComponent(ruta)}?ref=${REPO_BRANCH}`;
}

function decodificarBase64(texto) {
  const limpio = String(texto || "").replace(/\s/g, "");
  const binario = atob(limpio);
  const bytes = new Uint8Array(binario.length);
  for (let i = 0; i < binario.length; i++) bytes[i] = binario.charCodeAt(i);
  return new TextDecoder().decode(bytes);
}

function codificarBase64(texto) {
  const bytes = new TextEncoder().encode(texto);
  let binario = "";
  const trozo = 0x8000;
  for (let i = 0; i < bytes.length; i += trozo) {
    binario += String.fromCharCode(...bytes.subarray(i, i + trozo));
  }
  return btoa(binario);
}

async function leerGitHub(env, ruta) {
  const respuesta = await fetch(uriContenido(ruta), {
    headers: cabecerasGitHub(env),
  });
  if (respuesta.status === 404) return null;
  if (!respuesta.ok) {
    throw new Error(`GitHub GET ${ruta}: ${respuesta.status}`);
  }
  const json = await respuesta.json();
  const texto = decodificarBase64(json.content);
  return { sha: json.sha, documento: JSON.parse(texto) };
}

async function escribirGitHub(env, ruta, documento, sha, version) {
  const metadatos =
    documento.metadatos && typeof documento.metadatos === "object"
      ? { ...documento.metadatos }
      : {};
  metadatos.version = version;
  metadatos.actualizado = new Date().toISOString();
  metadatos.rama = REPO_BRANCH;
  metadatos.ruta = ruta;
  documento.metadatos = metadatos;

  const respuesta = await fetch(uriContenido(ruta).split("?")[0], {
    method: "PUT",
    headers: {
      ...cabecerasGitHub(env),
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: `nuki: actualizar ${ruta}`,
      content: codificarBase64(JSON.stringify(documento, null, 2)),
      branch: REPO_BRANCH,
      ...(sha ? { sha } : {}),
    }),
  });
  if (respuesta.status === 200 || respuesta.status === 201) return true;
  const detalle = await respuesta.text();
  const err = new Error(`GitHub PUT ${ruta}: ${respuesta.status} ${detalle}`);
  err.status = respuesta.status;
  throw err;
}

async function guardar(env, ruta, documento) {
  let ultimoError;
  for (let intento = 0; intento < 4; intento++) {
    try {
      const actual = await leerGitHub(env, ruta);
      const version =
        (Number(actual?.documento?.metadatos?.version) || 0) + 1;
      await escribirGitHub(env, ruta, documento, actual?.sha, version);
      return;
    } catch (e) {
      ultimoError = e;
      if (![409, 422].includes(e.status)) break;
      await new Promise((r) => setTimeout(r, 250 * (intento + 1)));
    }
  }
  throw ultimoError || new Error("No se pudo guardar");
}

function autorizado(request, env) {
  if (!env.NUKI_APP_KEY) return true;
  return request.headers.get("X-Nuki-Key") === env.NUKI_APP_KEY;
}

async function manejarApi(request, env, url) {
  if (url.pathname === "/api/version") {
    const version = "1.0.1";
    const release = `https://github.com/${APP_REPO}/releases/latest`;
    const apk = `${release}/download/${APK_ARM64}`;
    try {
      const respuesta = await fetch(
        `https://api.github.com/repos/${APP_REPO}/releases/latest`,
        {
          headers: {
            Accept: "application/vnd.github+json",
            ...(env.GITHUB_TOKEN
              ? { Authorization: `Bearer ${env.GITHUB_TOKEN}` }
              : {}),
            "User-Agent": "nuki-worker",
          },
        },
      );
      if (respuesta.ok) {
        const json = await respuesta.json();
        const assets = Array.isArray(json.assets) ? json.assets : [];
        const buscar = (nombre) =>
          assets.find((a) => a.name === nombre)?.browser_download_url;
        return respuestaJson({
          version: String(json.tag_name || version).replace(/^v/, ""),
          apk: buscar(APK_ARM64) || apk,
          arm64: buscar(APK_ARM64) || apk,
          armv7: buscar("nuki-armeabi-v7a.apk") || apk,
          release: json.html_url || release,
        });
      }
    } catch {}
    return respuestaJson({
      version,
      apk,
      arm64: apk,
      armv7: `${release}/download/nuki-armeabi-v7a.apk`,
      release,
    });
  }

  if (url.pathname === "/api/salud") {
    return respuestaJson({
      ok: true,
      servicio: "nuki-api",
      repo: `${REPO_OWNER}/${REPO_NAME}`,
      version: 1,
    });
  }

  if (!autorizado(request, env)) return error("No autorizado", 401);

  const coincidencia = url.pathname.match(/^\/api\/repo\/([^/]+)$/);
  if (!coincidencia) return error("Ruta no encontrada", 404);
  const ruta = decodeURIComponent(coincidencia[1]);
  if (!ARCHIVOS.has(ruta)) return error("Archivo no permitido", 404);

  if (request.method === "GET") {
    try {
      const actual = await leerGitHub(env, ruta);
      if (!actual) return error("Archivo no encontrado", 404);
      return respuestaJson(actual.documento);
    } catch (e) {
      return error(String(e.message || e), 502);
    }
  }

  if (request.method === "PUT") {
    let documento;
    try {
      const texto = await request.text();
      if (texto.length > 2_000_000) return error("Documento demasiado grande", 413);
      documento = JSON.parse(texto);
    } catch {
      return error("JSON inválido", 400);
    }
    if (!documento || typeof documento !== "object" || Array.isArray(documento)) {
      return error("El documento debe ser un objeto JSON", 400);
    }
    try {
      await guardar(env, ruta, documento);
      return respuestaJson({ ok: true, ruta, actualizado: new Date().toISOString() });
    } catch (e) {
      return error(String(e.message || e), 502);
    }
  }

  return error("Método no permitido", 405);
}

function paginaDescarga(version = "1.0.1") {
  const base = `https://github.com/${APP_REPO}/releases/latest/download`;
  const descargaArm64 = `${base}/nuki-arm64-v8a.apk`;
  const descargaArm = `${base}/nuki-armeabi-v7a.apk`;
  return `<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Nuki · Medicina en tu bolsillo</title>
<meta name="description" content="Nuki, la plataforma académica de medicina con reels, apuntes, evaluaciones y modelos 3D.">
<meta name="theme-color" content="#06172B" id="metaTema">
<script>
(function () {
  try {
    var q = new URLSearchParams(location.search).get('tema');
    var g = localStorage.getItem('nuki-tema');
    var s = window.matchMedia('(prefers-color-scheme: light)').matches ? 'claro' : 'oscuro';
    var tema = (q === 'claro' || q === 'oscuro') ? q : ((g === 'claro' || g === 'oscuro') ? g : s);
    document.documentElement.dataset.tema = tema;
  } catch (e) {
    document.documentElement.dataset.tema = 'oscuro';
  }
})();
</script>
<meta property="og:title" content="Nuki · Medicina en tu bolsillo">
<meta property="og:description" content="Reels, apuntes, evaluaciones y modelos 3D para estudiar medicina.">
<meta property="og:image" content="https://nuki-api.guttural-engineer.workers.dev/splash.png">
<link rel="icon" href="/icono.png" type="image/png">
<link rel="apple-touch-icon" href="/icono.png">
<style>
:root{
  color-scheme:dark;
  --fondo:#06172B;--fondo2:#0A2340;--tarjeta:#0D2542;--tarjeta2:#112C4E;
  --borde:rgba(255,255,255,.10);--texto:#F7FBFF;--gris:#A6BBD4;--nav:#B9CBE2;
  --azul:#39B4E8;--azul2:#1080C0;--celeste:#67D4F5;--crema:#FFF8EC;
  --coral:#F2545B;--rosa:#FF8C93;--acento:#67D4F5;
  --nav-fondo:rgba(6,23,43,.72);--hover:rgba(255,255,255,.06);
  --vidrio:rgba(255,255,255,.045);--vidrio-hover:rgba(255,255,255,.09);
  --chip-fondo:rgba(13,37,66,.92);--chip-acento:rgba(103,212,245,.09);
  --acento-texto:#B7ECFF;--punto:rgba(255,255,255,.34);--punto-op:.22;
  --linea:linear-gradient(90deg,transparent,rgba(255,255,255,.14),transparent);
  --sombra:0 24px 60px rgba(0,0,0,.35);
  --principal-deg:linear-gradient(135deg,#67D4F5,#39B4E8);
  --principal-texto:#03131F;--principal-sombra:0 16px 42px rgba(57,180,232,.28);
  --fondo-degradado:
    radial-gradient(60vw 60vw at 82% 4%,rgba(11,79,110,.42) 0,transparent 62%),
    radial-gradient(46vw 46vw at 4% 38%,rgba(23,58,122,.36) 0,transparent 62%),
    radial-gradient(42vw 42vw at 58% 100%,rgba(16,128,192,.24) 0,transparent 62%),
    linear-gradient(180deg,#06172B,#0A2340 55%,#051426);
  --aura:radial-gradient(circle,rgba(57,180,232,.36) 0,rgba(57,180,232,.10) 40%,transparent 68%);
  --drop:drop-shadow(0 34px 40px rgba(0,0,0,.62));
  --drop-mini:drop-shadow(0 18px 26px rgba(0,0,0,.55));
  --cta-fondo:radial-gradient(circle at 50% 0,rgba(11,79,110,.68),transparent 62%),linear-gradient(#0A2038,#07182C);
  --cta-borde:rgba(103,212,245,.24);
  --footer:#6F8AA8;--footer-a:#A6C2DD;
}
html[data-tema="claro"]{
  color-scheme:light;
  --fondo:#FFF8EC;--fondo2:#F2FBFF;--tarjeta:#FFFFFF;--tarjeta2:#F5FCFF;
  --borde:rgba(11,35,66,.13);--texto:#0B2342;--gris:#516B85;--nav:#294766;
  --azul:#1080C0;--azul2:#0B6C9E;--celeste:#39B4E8;--crema:#FFF8EC;
  --coral:#E63946;--rosa:#D9365B;--acento:#0E7FB8;
  --nav-fondo:rgba(255,248,236,.84);--hover:rgba(11,35,66,.06);
  --vidrio:rgba(255,255,255,.72);--vidrio-hover:#FFFFFF;
  --chip-fondo:rgba(255,255,255,.94);--chip-acento:rgba(16,128,192,.09);
  --acento-texto:#0B6C9E;--punto:rgba(11,35,66,.18);--punto-op:.55;
  --linea:linear-gradient(90deg,transparent,rgba(11,35,66,.14),transparent);
  --sombra:0 20px 50px rgba(11,35,66,.11);
  --principal-deg:linear-gradient(135deg,#1080C0,#39B4E8);
  --principal-texto:#FFFFFF;--principal-sombra:0 16px 42px rgba(16,128,192,.26);
  --fondo-degradado:
    radial-gradient(60vw 60vw at 82% 4%,rgba(103,212,245,.30) 0,transparent 62%),
    radial-gradient(46vw 46vw at 4% 38%,rgba(255,140,147,.25) 0,transparent 62%),
    radial-gradient(42vw 42vw at 58% 100%,rgba(57,180,232,.18) 0,transparent 62%),
    linear-gradient(180deg,#FFF8EC,#F2FBFF 55%,#FFF8EC);
  --aura:radial-gradient(circle,rgba(57,180,232,.28) 0,rgba(57,180,232,.08) 40%,transparent 68%);
  --drop:drop-shadow(0 26px 32px rgba(11,35,66,.20));
  --drop-mini:drop-shadow(0 14px 20px rgba(11,35,66,.16));
  --cta-fondo:radial-gradient(circle at 50% 0,rgba(103,212,245,.45),transparent 62%),linear-gradient(#FFFFFF,#F0FBFF);
  --cta-borde:rgba(16,128,192,.22);
  --footer:#5E7892;--footer-a:#0B6C9E;
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
html,body{margin:0;min-height:100%}
body{
  font-family:Inter,ui-sans-serif,system-ui,-apple-system,"Segoe UI",sans-serif;
  color:var(--texto);background:var(--fondo);overflow-x:hidden;
  transition:background-color .35s ease,color .35s ease;
}
body::before{
  content:"";position:fixed;inset:0;z-index:-3;pointer-events:none;
  background:var(--fondo-degradado);transition:opacity .35s ease;
}
body::after{
  content:"";position:fixed;inset:0;z-index:-2;pointer-events:none;opacity:var(--punto-op);
  background-image:radial-gradient(var(--punto) 1px,transparent 1px);
  background-size:34px 34px;
  mask-image:radial-gradient(ellipse at 50% 20%,#000 0,transparent 72%);
}
a{color:inherit}
.orbes{position:fixed;inset:0;overflow:hidden;z-index:-1;pointer-events:none}
.orbe{position:absolute;border-radius:50%;filter:blur(72px);opacity:.34;animation:deriva 18s ease-in-out infinite alternate;transition:opacity .35s ease}
.o1{width:430px;height:430px;background:#0AA6E6;top:-130px;right:-80px}
.o2{width:330px;height:330px;background:#F2545B;top:34%;left:-170px;animation-delay:-6s;opacity:.18}
.o3{width:380px;height:380px;background:#39B4E8;bottom:-170px;right:14%;animation-delay:-11s;opacity:.2}
html[data-tema="claro"] .orbe{opacity:.16}
html[data-tema="claro"] .o2{opacity:.11}
html[data-tema="claro"] .o3{opacity:.13}
.wrap{width:100%;max-width:1160px;margin:0 auto;padding:0 24px}
nav{
  position:sticky;top:0;z-index:20;display:flex;align-items:center;justify-content:space-between;
  width:100%;max-width:1160px;margin:0 auto;padding:18px 24px;
  background:var(--nav-fondo);backdrop-filter:blur(16px);
  transition:background-color .35s ease;
}
nav::after{content:"";position:absolute;inset:auto 24px 0;height:1px;background:var(--linea)}
.logo{display:flex;align-items:center;gap:11px;font-weight:900;font-size:21px;letter-spacing:-.035em;text-decoration:none;color:var(--texto)}
.logo img{width:42px;height:42px;border-radius:14px;box-shadow:0 8px 26px rgba(57,180,232,.30);transition:transform .35s ease}
.logo:hover img{transform:rotate(-7deg) scale(1.06)}
.nav-derecha{display:flex;align-items:center;gap:10px}
.enlace{color:var(--nav);text-decoration:none;font-size:14px;font-weight:600;padding:9px 12px;border-radius:10px;transition:.2s}
.enlace:hover{color:var(--texto);background:var(--hover)}
.boton{
  display:inline-flex;align-items:center;justify-content:center;gap:10px;
  padding:14px 22px;border-radius:14px;text-decoration:none;font-weight:800;
  transition:transform .22s ease,box-shadow .22s ease,background .22s;
}
.boton:hover{transform:translateY(-3px)}
.boton svg{width:18px;height:18px}
.principal{background:var(--principal-deg);color:var(--principal-texto);box-shadow:var(--principal-sombra)}
.principal:hover{box-shadow:0 20px 54px rgba(57,180,232,.38)}
.secundario{border:1px solid var(--borde);background:var(--vidrio);color:var(--texto)}
.secundario:hover{background:var(--vidrio-hover)}
.nav-boton{padding:10px 15px;font-size:13px;border-radius:11px}
.tema-boton{
  display:inline-flex;align-items:center;gap:7px;cursor:pointer;
  border:1px solid var(--borde);background:var(--vidrio);color:var(--nav);
  padding:9px 11px;border-radius:11px;font:inherit;font-size:12px;font-weight:700;
  transition:background .22s,color .22s,border-color .22s,transform .22s;
}
.tema-boton:hover{background:var(--vidrio-hover);color:var(--texto);transform:translateY(-1px)}
.tema-boton svg{width:15px;height:15px}
html[data-tema="oscuro"] .icono-luna,html[data-tema="claro"] .icono-sol{display:none}
html[data-tema="oscuro"] .tema-oscuro,html[data-tema="claro"] .tema-claro{display:none}
.hero{
  display:grid;grid-template-columns:1.02fr .98fr;gap:40px;align-items:center;
  min-height:calc(100vh - 82px);padding:42px 0 84px;
}
.etiqueta{
  display:inline-flex;align-items:center;gap:9px;border:1px solid color-mix(in srgb,var(--acento) 38%,transparent);
  background:var(--chip-acento);color:var(--acento-texto);padding:8px 13px;border-radius:999px;
  font-size:13px;font-weight:700;letter-spacing:.01em;transition:background .35s,color .35s,border-color .35s;
}
.etiqueta i{width:8px;height:8px;border-radius:50%;background:var(--acento);box-shadow:0 0 0 0 color-mix(in srgb,var(--acento) 55%,transparent);animation:latido 2.4s infinite}
h1{font-size:clamp(44px,6.4vw,78px);line-height:.96;letter-spacing:-.06em;margin:22px 0 20px;font-weight:900;color:var(--texto)}
h1 em{
  font-style:normal;background:linear-gradient(105deg,var(--celeste),var(--azul) 48%,var(--rosa));
  -webkit-background-clip:text;background-clip:text;color:transparent;
}
.lead{color:var(--gris);font-size:18px;line-height:1.7;max-width:560px;margin:0 0 30px;transition:color .35s}
.acciones{display:flex;gap:12px;flex-wrap:wrap}
.notas{display:flex;gap:22px;flex-wrap:wrap;color:var(--gris);font-size:13px;margin-top:22px;transition:color .35s}
.notas b{color:var(--texto);font-weight:700;opacity:.82}
.abi-lista{display:flex;gap:8px;flex-wrap:wrap;justify-content:center;margin:18px auto 0;max-width:700px}
.abi-lista a{padding:8px 12px;border-radius:999px;border:1px solid var(--borde);color:var(--gris);font-size:12px;font-weight:700;text-decoration:none;background:var(--tarjeta);transition:border-color .2s,color .2s,background .2s}
.abi-lista a:hover,.abi-lista a[aria-current="true"]{border-color:var(--azul);color:var(--texto);background:var(--tarjeta2)}
.nota-abis{font-size:12px!important;line-height:1.6!important;max-width:560px!important;margin:14px auto 0!important;opacity:.8}
.escena{
  position:relative;min-height:520px;display:grid;place-items:center;perspective:1000px;
  transform-style:preserve-3d;
}
.aura{
  position:absolute;width:430px;height:430px;border-radius:50%;
  background:var(--aura);filter:blur(12px);animation:respirar 6s ease-in-out infinite;
  transition:background .35s;
}
.anillo{
  position:absolute;border-radius:50%;border:1px solid color-mix(in srgb,var(--azul) 22%,transparent);
  animation:giro 26s linear infinite;
}
.anillo.a{width:440px;height:440px;border-style:dashed;border-color:color-mix(in srgb,var(--celeste) 32%,transparent)}
.anillo.b{width:530px;height:530px;border-color:color-mix(in srgb,var(--celeste) 16%,transparent);animation-direction:reverse;animation-duration:38s}
.anillo.c{width:340px;height:340px;border-color:color-mix(in srgb,var(--coral) 22%,transparent);animation-duration:20s}
.nucleo{
  position:relative;z-index:2;width:min(86%,460px);
  animation:flotar 7s ease-in-out infinite;
  filter:var(--drop);
  transform:translate3d(calc(var(--px,0)*14px),calc(var(--py,0)*14px),0);
  transition:transform .35s ease-out;
}
.nucleo img{display:block;width:100%;height:auto}
.mascota-flotante{
  position:absolute;z-index:3;width:132px;right:3%;bottom:9%;
  animation:flotar 5.2s ease-in-out infinite reverse;
  filter:var(--drop-mini);
  transform:translate3d(calc(var(--px,0)*-24px),calc(var(--py,0)*-24px),0);
  transition:transform .35s ease-out;
}
.mascota-flotante img{display:block;width:100%}
.chip{
  position:absolute;z-index:4;display:flex;align-items:center;gap:9px;
  padding:10px 13px;border-radius:14px;border:1px solid var(--borde);
  background:var(--chip-fondo);backdrop-filter:blur(10px);box-shadow:var(--sombra);
  font-size:12px;font-weight:700;color:var(--texto);white-space:nowrap;
  animation:flotar 6s ease-in-out infinite;transition:background .35s,color .35s,border-color .35s;
}
.chip b{color:var(--azul2)}
.chip .punto{width:9px;height:9px;border-radius:3px;background:var(--coral)}
.chip1{top:14%;left:-2%;animation-delay:-1s}
.chip2{top:30%;right:0;animation-delay:-2.8s}
.chip3{bottom:20%;left:0;animation-delay:-4.1s}
.celula{
  position:absolute;z-index:1;width:13px;height:13px;border-radius:46% 54% 58% 42%;
  background:linear-gradient(135deg,var(--celeste),var(--azul));opacity:.55;
  animation:subir 9s linear infinite;
}
.celula:nth-child(2){left:16%;bottom:16%;animation-delay:-2s;width:9px;height:9px}
.celula:nth-child(3){right:14%;top:18%;animation-delay:-5s;background:linear-gradient(135deg,var(--rosa),var(--coral))}
.celula:nth-child(4){left:28%;top:9%;animation-delay:-7s;width:8px;height:8px}
.seccion{padding:84px 0}
.titulo-seccion{max-width:720px;margin:0 auto 44px;text-align:center}
.titulo-seccion span{color:var(--azul2);font-size:13px;font-weight:800;letter-spacing:.14em;text-transform:uppercase}
.titulo-seccion h2{font-size:clamp(30px,4.3vw,48px);letter-spacing:-.045em;line-height:1.06;margin:12px 0 14px;color:var(--texto)}
.titulo-seccion p{color:var(--gris);line-height:1.65;margin:0;font-size:16px}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.card{
  position:relative;border:1px solid var(--borde);border-radius:22px;padding:24px;
  background:linear-gradient(145deg,var(--tarjeta),var(--tarjeta2));overflow:hidden;
  transition:transform .3s ease,border-color .3s,box-shadow .3s,background .35s;
}
.card:hover{transform:translateY(-6px);border-color:color-mix(in srgb,var(--azul) 34%,transparent);box-shadow:var(--sombra)}
.card::after{
  content:"";position:absolute;width:150px;height:150px;border-radius:50%;
  right:-70px;top:-70px;background:var(--brillo,#39B4E8);opacity:.09;filter:blur(10px);
}
.icono{
  width:46px;height:46px;border-radius:14px;display:grid;place-items:center;
  background:color-mix(in srgb,var(--azul) 12%,transparent);
  border:1px solid color-mix(in srgb,var(--azul) 24%,transparent);
  font-size:21px;margin-bottom:17px;color:var(--azul2);
}
.card h3{margin:0 0 8px;font-size:17px;letter-spacing:-.02em;color:var(--texto)}
.card p{margin:0;color:var(--gris);font-size:14px;line-height:1.65;transition:color .35s}
.reveal{opacity:0;transform:translateY(26px);transition:opacity .7s ease,transform .7s ease}
.reveal.visible{opacity:1;transform:none}
.banda{
  display:grid;grid-template-columns:.9fr 1.1fr;gap:44px;align-items:center;
  border:1px solid var(--borde);border-radius:30px;padding:34px;
  background:linear-gradient(120deg,var(--tarjeta),var(--tarjeta2) 55%,var(--tarjeta));
  overflow:hidden;position:relative;box-shadow:var(--sombra);
  transition:background .35s,border-color .35s,box-shadow .35s;
}
.banda::before{
  content:"";position:absolute;width:420px;height:420px;border-radius:50%;
  left:-190px;bottom:-210px;background:color-mix(in srgb,var(--azul) 18%,transparent);filter:blur(30px);
}
.banda img{display:block;width:min(100%,350px);margin:auto;animation:flotar 6s ease-in-out infinite;filter:var(--drop-mini)}
.lista{display:grid;gap:14px;margin-top:24px}
.item{display:flex;gap:12px;align-items:flex-start;color:var(--gris);font-size:14px;line-height:1.55;transition:color .35s}
.tilde{flex:0 0 24px;width:24px;height:24px;border-radius:8px;display:grid;place-items:center;background:var(--chip-acento);color:var(--azul2);font-weight:900;font-size:13px}
.cta{
  position:relative;text-align:center;border-radius:32px;padding:58px 24px;
  border:1px solid var(--cta-borde);overflow:hidden;
  background:var(--cta-fondo);box-shadow:var(--sombra);
  transition:background .35s,border-color .35s,box-shadow .35s;
}
.cta img{width:84px;border-radius:22px;margin-bottom:18px;box-shadow:0 16px 40px rgba(57,180,232,.30)}
.cta h2{font-size:clamp(30px,4.4vw,50px);letter-spacing:-.05em;margin:0 0 12px;color:var(--texto)}
.cta p{color:var(--gris);margin:0 auto 26px;max-width:520px;line-height:1.65}
footer{padding:36px 24px 10px;text-align:center;color:var(--footer);font-size:13px;transition:color .35s}
footer a{color:var(--footer-a)}
@media(max-width:860px){
  .hero{grid-template-columns:1fr;gap:12px;padding-top:24px;min-height:auto}
  .escena{min-height:440px;order:2}
  .copy{order:1;text-align:center}
  .lead{margin-left:auto;margin-right:auto}
  .acciones,.notas{justify-content:center}
  .cards{grid-template-columns:1fr 1fr}
  .banda{grid-template-columns:1fr;text-align:center}
  .banda .lista{text-align:left;max-width:420px;margin-left:auto;margin-right:auto}
  .item{text-align:left}
  .chip1{left:0}.chip2{right:0}
}
@media(max-width:560px){
  .nav-derecha .enlace{display:none}
  .cards{grid-template-columns:1fr}
  .escena{min-height:360px}
  .nucleo{width:92%}
  .mascota-flotante{width:92px;right:0;bottom:4%}
  .anillo.a{width:320px;height:320px}.anillo.b{width:390px;height:390px}.anillo.c{width:250px;height:250px}
  .chip2{display:none}
  .banda{padding:26px 20px}
  .tema-boton .tema-texto{display:none}
}
@media(prefers-reduced-motion:reduce){
  *,*::before,*::after{animation:none!important;transition:none!important;scroll-behavior:auto}
  .reveal{opacity:1;transform:none}
}
@keyframes flotar{0%,100%{transform:translateY(0) rotate(-1deg)}50%{transform:translateY(-16px) rotate(1deg)}}
@keyframes respirar{0%,100%{transform:scale(.92);opacity:.65}50%{transform:scale(1.08);opacity:1}}
@keyframes giro{to{transform:rotate(360deg)}}
@keyframes deriva{to{transform:translate3d(40px,-30px,0) scale(1.08)}}
@keyframes latido{0%{box-shadow:0 0 0 0 color-mix(in srgb,var(--acento) 55%,transparent)}70%{box-shadow:0 0 0 10px transparent}100%{box-shadow:0 0 0 0 transparent}}
@keyframes subir{0%{transform:translateY(20px) scale(.8);opacity:0}25%{opacity:.65}100%{transform:translateY(-110px) scale(1.15);opacity:0}}
</style>
</head>
<body>
<div class="orbes" aria-hidden="true"><div class="orbe o1"></div><div class="orbe o2"></div><div class="orbe o3"></div></div>
<nav>
  <a class="logo" href="/"><img src="/icono.png" alt="Nuki"><span>Nuki</span></a>
  <div class="nav-derecha">
    <a class="enlace" href="#funciones">Funciones</a>
    <a class="enlace" href="#estudiar">Cómo estudiar</a>
    <button class="tema-boton" id="botonTema" type="button" aria-label="Cambiar tema" title="Cambiar tema">
      <svg class="icono-sol" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.42 1.42M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.42-1.42M17.66 6.34l1.41-1.41"/></svg>
      <svg class="icono-luna" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></svg>
      <span class="tema-texto tema-claro">Claro</span>
      <span class="tema-texto tema-oscuro">Oscuro</span>
    </button>
    <a class="boton principal nav-boton" href="#descargar">Descargar</a>
  </div>
</nav>

<main class="wrap">
  <section class="hero">
    <div class="copy">
      <div class="etiqueta"><i></i> Disponible para Android</div>
      <h1>Medicina<br><em>en tu bolsillo.</em></h1>
      <p class="lead">Reels de repaso, apuntes, evaluaciones, foro y modelos anatómicos 3D. Tu contenido académico sincronizado con GitHub, ahora desde cualquier lugar.</p>
      <div class="acciones">
        <a class="boton principal" href="${descargaArm64}">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v12m0 0 4-4m-4 4-4-4"/><path d="M5 21h14"/></svg>
          Descargar Android · v${version}
        </a>
        <a class="boton secundario" href="#descargar">Elegir arquitectura</a>
      </div>
      <div class="notas"><span><b>Android 7+</b></span><span><b>~25 MB</b></span><span><b>ARM64 recomendado</b></span><span><a href="#descargar">¿No sabes cuál?</a></span></div>
    </div>

    <div class="escena" id="escena" aria-label="Nuki, tu compañero de estudio">
      <div class="aura"></div>
      <div class="anillo a"></div><div class="anillo b"></div><div class="anillo c"></div>
      <span class="celula"></span><span class="celula"></span><span class="celula"></span>
      <div class="nucleo"><img src="/splash_transparente.png" alt="Nuki"></div>
      <div class="mascota-flotante"><img src="/mascota_transparente.png" alt="Célula Nuki"></div>
      <div class="chip chip1"><span class="punto"></span> <b>Reels</b> de repaso</div>
      <div class="chip chip2"><b>+250</b> preguntas</div>
      <div class="chip chip3"><b>3D</b> anatomía</div>
    </div>
  </section>

  <section class="seccion" id="funciones">
    <div class="titulo-seccion reveal">
      <span>Todo en un lugar</span>
      <h2>Estudiar se siente<br>como jugar.</h2>
      <p>Nuki combina repaso visual, práctica y comunidad para que no sueltes el ritmo.</p>
    </div>
    <div class="cards">
      <article class="card reveal" style="--brillo:#f2545b"><div class="icono">▶</div><h3>Reels de repaso</h3><p>Micro-clases verticales para recordar lo importante en menos de un minuto.</p></article>
      <article class="card reveal" style="--brillo:#67d4f5;transition-delay:.06s"><div class="icono">◈</div><h3>Modelos 3D</h3><p>Explora anatomía desde cualquier ángulo y fija conceptos con tus manos.</p></article>
      <article class="card reveal" style="--brillo:#62e6b4;transition-delay:.12s"><div class="icono">✓</div><h3>Evaluaciones</h3><p>Cuestionarios con mapa de progreso, resultados claros y ganas de volver.</p></article>
      <article class="card reveal" style="--brillo:#a78bfa;transition-delay:.18s"><div class="icono">✎</div><h3>Apuntes vivos</h3><p>Tus resúmenes y recursos siempre sincronizados, listos para repasar.</p></article>
      <article class="card reveal" style="--brillo:#ff8c93;transition-delay:.24s"><div class="icono">✦</div><h3>Comunidad</h3><p>Foro, likes y comentarios para aprender junto a otros estudiantes.</p></article>
      <article class="card reveal" style="--brillo:#f7c948;transition-delay:.3s"><div class="icono">◎</div><h3>Racha diaria</h3><p>Pequeños avances todos los días. Nuki te recuerda que nunca es tarde.</p></article>
    </div>
  </section>

  <section class="seccion" id="estudiar">
    <div class="banda reveal">
      <div><img src="/mascota_transparente.png" alt="Mascota Nuki"></div>
      <div>
        <div class="etiqueta"><i></i> Tu compañero de estudio</div>
        <div class="titulo-seccion" style="text-align:left;margin:18px 0 0">
          <h2 style="margin-top:0">Un ritmo que sí<br>puedes mantener.</h2>
          <p>Sin distracciones. Solo lo que necesitas para llegar al examen con confianza.</p>
        </div>
        <div class="lista">
          <div class="item"><span class="tilde">✓</span><span><b>Repaso inteligente:</b> contenido corto, visual y alineado a tus materias.</span></div>
          <div class="item"><span class="tilde">✓</span><span><b>Progreso visible:</b> completa temas y mira cómo crece tu racha.</span></div>
          <div class="item"><span class="tilde">✓</span><span><b>Siempre contigo:</b> tus datos se sincronizan en la nube de Nuki.</span></div>
        </div>
      </div>
    </div>
  </section>

  <section class="seccion" id="descargar">
    <div class="cta reveal">
      <img src="/icono.png" alt="Nuki">
      <h2>Descarga Nuki v${version}.</h2>
      <p id="estadoDescarga">Elige la versión que corresponde a tu Android. La app es liviana y no necesita cuenta para explorar.</p>
      <div class="acciones" style="justify-content:center">
        <a class="boton principal" id="botonDescarga" href="${descargaArm64}">Descargar APK</a>
        <a class="boton secundario" href="#funciones">Conocer funciones</a>
      </div>
      <div class="abi-lista" aria-label="Arquitecturas de Android">
        <a href="${descargaArm64}" data-abi="arm64">ARM64 · recomendado</a>
        <a href="${descargaArm}" data-abi="armv7">ARM 32-bit · Android antiguo</a>
      </div>
      <p class="nota-abis">Si tu teléfono es de 2016 o anterior, prueba ARM 32-bit. Los APK se descargan directo desde el release oficial de Nuki; no necesitas instalar nada más.</p>
    </div>
  </section>
</main>

<footer>Creado por Nuki y asociados · <a href="https://github.com/${APP_REPO}">GitHub</a></footer>

<script>
const escena = document.getElementById('escena');
if (escena && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
  escena.addEventListener('pointermove', (e) => {
    const r = escena.getBoundingClientRect();
    const px = (e.clientX - r.left) / r.width - 0.5;
    const py = (e.clientY - r.top) / r.height - 0.5;
    escena.style.setProperty('--px', px.toFixed(3));
    escena.style.setProperty('--py', py.toFixed(3));
  });
  escena.addEventListener('pointerleave', () => {
    escena.style.setProperty('--px', 0);
    escena.style.setProperty('--py', 0);
  });
}
const observador = new IntersectionObserver((entradas) => {
  for (const entrada of entradas) {
    if (entrada.isIntersecting) {
      entrada.target.classList.add('visible');
      observador.unobserve(entrada.target);
    }
  }
}, { threshold: 0.14 });
document.querySelectorAll('.reveal').forEach((el) => observador.observe(el));

const botonTema = document.getElementById('botonTema');
const metaTema = document.getElementById('metaTema');
function sincronizarTema() {
  const claro = document.documentElement.dataset.tema === 'claro';
  metaTema.setAttribute('content', claro ? '#FFF8EC' : '#06172B');
  botonTema.setAttribute('aria-label', claro ? 'Cambiar a tema oscuro' : 'Cambiar a tema claro');
  botonTema.setAttribute('title', claro ? 'Cambiar a tema oscuro' : 'Cambiar a tema claro');
}
sincronizarTema();
botonTema.addEventListener('click', () => {
  const nuevo = document.documentElement.dataset.tema === 'claro' ? 'oscuro' : 'claro';
  document.documentElement.dataset.tema = nuevo;
  try { localStorage.setItem('nuki-tema', nuevo); } catch (e) {}
  sincronizarTema();
});

const descargas = {
  arm64: '${descargaArm64}',
  armv7: '${descargaArm}'
};
const botonDescarga = document.getElementById('botonDescarga');
const estadoDescarga = document.getElementById('estadoDescarga');
const opcionesAbi = Array.from(document.querySelectorAll('.abi-lista a'));
function elegirAbi(abi) {
  if (!descargas[abi]) return;
  botonDescarga.href = descargas[abi];
  opcionesAbi.forEach((a) => a.setAttribute('aria-current', a.dataset.abi === abi ? 'true' : 'false'));
  try { localStorage.setItem('nuki-abi', abi); } catch (e) {}
}
opcionesAbi.forEach((a) => a.addEventListener('click', () => elegirAbi(a.dataset.abi)));
const abiGuardada = (() => { try { return localStorage.getItem('nuki-abi'); } catch (e) { return null; } })();
const abiUrl = new URLSearchParams(location.search).get('abi');
const esAndroid = /Android/i.test(navigator.userAgent);
let abiElegida = descargas[abiUrl] ? abiUrl : (descargas[abiGuardada] ? abiGuardada : 'arm64');
if (esAndroid) {
  estadoDescarga.textContent = 'Detectamos Android. La descarga recomendada es ARM64 y pesa unos 27 MB; si tu teléfono es antiguo, elige ARM 32-bit.';
} else {
  estadoDescarga.textContent = 'Abre esta página desde tu Android para instalar Nuki. También puedes descargar el APK ARM64 y pasarlo al teléfono.';
}
if (navigator.userAgentData && navigator.userAgentData.getHighEntropyValues) {
  navigator.userAgentData.getHighEntropyValues(['architecture', 'bitness']).then((datos) => {
    const arquitectura = String(datos.architecture || '').toLowerCase();
    if (arquitectura.indexOf('x86') === -1 && datos.bitness === '32') abiElegida = 'armv7';
    elegirAbi(abiElegida);
  }).catch(() => {});
}
elegirAbi(abiElegida);
</script>
</body>
</html>`;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: CORS });
    }
    if (url.pathname === "/descargar") {
      const abi = (url.searchParams.get("abi") || "arm64").toLowerCase();
      const archivo = abi === "armv7" || abi === "arm"
        ? "nuki-armeabi-v7a.apk"
        : "nuki-arm64-v8a.apk";
      return Response.redirect(
        `https://github.com/${APP_REPO}/releases/latest/download/${archivo}`,
        302,
      );
    }
    if (url.pathname.startsWith("/api/")) {
      return manejarApi(request, env, url);
    }
    if (url.pathname === "/" || url.pathname === "/index.html") {
      return new Response(paginaDescarga(), {
        headers: {
          "Content-Type": "text/html; charset=utf-8",
          "Cache-Control": "public, max-age=300",
        },
      });
    }
    return new Response("No encontrado", { status: 404, headers: CORS });
  },
};
