/* ═══════════════════════════════════════════════════════════════════
   EL MOTOR DE LAS CAMPAÑAS  ·  respald.ar
   ═══════════════════════════════════════════════════════════════════
   Auditoría del 21/08/2026: la página no tenía NADA de medición — ni
   píxel, ni analytics, ni un solo evento. Poner plata en anuncios así
   es tirarla: Meta no puede optimizar hacia el que consulta si nunca
   se entera de que alguien consultó, y vos no podés saber qué anuncio
   trajo al cliente.

   Este archivo hace cuatro cosas y nada más:

   1. PÍXEL de Meta, si está cargado el ID acá abajo.
   2. GUARDA de dónde vino el visitante (utm_*, fbclid, gclid) apenas
      entra, en sessionStorage. Si toca tres links antes de escribir,
      el dato sigue estando.
   3. ARMA cada link de WhatsApp con un mensaje ya escrito que LLEVA LA
      CAMPAÑA ADENTRO. Es la atribución que no depende de nadie: te
      llega el mensaje y ya sabés de qué anuncio salió. (En Siciliano
      la atribución se perdió justamente por esto: 23 reservas marcadas
      "instagram" y ninguna forma de saber cuál campaña las trajo.)
   4. DISPARA los eventos: Contact cuando tocan el WhatsApp, y
      ViewContent cuando abren una demo real.

   ⚠️ EL ÚNICO DATO QUE FALTA CARGAR ES EL PÍXEL. Se saca de
   Meta Business Suite → Administrador de eventos → el conjunto de
   datos → arriba figura el ID (15 números). NO es un secreto: viaja
   en el HTML de cualquier página que lo use. Mientras esté vacío la
   página anda igual, sin medir.

   OJO al elegirlo: la cuenta 501516329077366 ya tiene varios píxeles
   (Todo Autos, Todo Autos Test1, En San Juan, Avalar Avisos, y el
   390717660318060 que usa Siciliano). respald.ar necesita el SUYO,
   limpio: mezclar públicos de un restaurante con los de dueños de
   negocio le arruina el aprendizaje a las dos campañas.
   ═══════════════════════════════════════════════════════════════════ */

(function () {
  "use strict";

  var PIXEL = "";                       // ← el ID de Meta va acá
  var WA = "5492644123194";             // el WhatsApp que atiende Pelá

  /* ── 1 · PÍXEL ────────────────────────────────────────────────── */
  if (PIXEL) {
    /* eslint-disable */
    !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
    n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}
    (window,document,'script','https://connect.facebook.net/en_US/fbevents.js');
    /* eslint-enable */
    window.fbq("init", PIXEL);
    window.fbq("track", "PageView");
  }
  function evento(nombre, datos) {
    try { if (window.fbq) window.fbq("track", nombre, datos || {}); } catch (e) {}
  }

  /* ── 2 · DE DÓNDE VINO ────────────────────────────────────────── */
  /* Se guarda en sessionStorage: si el visitante entra por el anuncio,
     abre el turnero real en otra pestaña y vuelve, el origen sigue ahí. */
  var CLAVE = "respaldar_origen";
  var origen = {};

  try {
    var q = new URLSearchParams(location.search);
    ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term",
     "fbclid", "gclid"].forEach(function (k) {
      var v = q.get(k);
      if (v) origen[k] = v.slice(0, 80);
    });
    if (Object.keys(origen).length) {
      sessionStorage.setItem(CLAVE, JSON.stringify(origen));
    } else {
      origen = JSON.parse(sessionStorage.getItem(CLAVE) || "{}");
    }
  } catch (e) { origen = {}; }

  /* La landing se identifica sola por el nombre del archivo: /turnos,
     /gastronomia, /tienda… Así el mensaje dice de qué página salió
     aunque el anuncio venga sin ninguna utm. */
  var landing = (location.pathname.split("/").pop() || "index")
                  .replace(/\.html$/, "") || "index";

  /* El rótulo que viaja adentro del mensaje de WhatsApp. Si hay campaña
     se usa esa; si no, la landing sola. Corto a propósito: es una
     referencia, no un informe. */
  function rotulo() {
    var partes = [landing];
    if (origen.utm_campaign) partes.push(origen.utm_campaign);
    else if (origen.utm_source) partes.push(origen.utm_source);
    if (origen.utm_content) partes.push(origen.utm_content);
    return partes.join(" · ");
  }

  /* ── 3 · LOS LINKS DE WHATSAPP ────────────────────────────────── */
  /* Cualquier <a data-wa="texto del mensaje"> se convierte en un link
     de WhatsApp con ese mensaje ya escrito y el rótulo de campaña al
     final. Si el atributo viene vacío se usa el mensaje de la página
     (data-wa-default en el <body>). */
  var porDefecto = document.body.getAttribute("data-wa-default") ||
                   "Hola! Vi la página de respald.ar y quiero saber cómo sería para mi negocio.";

  function armar(texto) {
    var msj = (texto || porDefecto).trim() + "\n\n(" + rotulo() + ")";
    return "https://wa.me/" + WA + "?text=" + encodeURIComponent(msj);
  }

  [].forEach.call(document.querySelectorAll("[data-wa]"), function (a) {
    a.setAttribute("href", armar(a.getAttribute("data-wa")));
    a.setAttribute("target", "_blank");
    a.setAttribute("rel", "noopener");
    a.addEventListener("click", function () {
      evento("Contact", { content_name: landing, content_category: rotulo() });
    });
  });

  /* ── 4 · LAS DEMOS REALES ─────────────────────────────────────── */
  /* Tocar una demo es la señal más fuerte de interés que da esta
     página: el tipo se fue a ver el turnero de una clienta. Se mide
     como ViewContent para poder armar el público de retargeting. */
  [].forEach.call(document.querySelectorAll("[data-demo]"), function (a) {
    a.addEventListener("click", function () {
      evento("ViewContent", { content_name: a.getAttribute("data-demo") });
    });
  });

  /* ── 5 · LA BARRA FIJA ────────────────────────────────────────── */
  /* Aparece cuando el visitante pasó el hero: antes taparía la promesa
     del anuncio, que es justo lo que vino a leer. */
  var fija = document.querySelector(".fija");
  if (fija) {
    var disparo = function () {
      var pasoElHero = window.scrollY > (window.innerHeight * 0.75);
      fija.classList.toggle("ver", pasoElHero);
    };
    window.addEventListener("scroll", disparo, { passive: true });
    disparo();
  }

  /* ── 6 · LLEGÓ HASTA EL FINAL ─────────────────────────────────── */
  /* El que baja hasta el cierre leyó la oferta entera. Sirve para
     separar "vino y rebotó" de "vino, leyó y no escribió", que son dos
     problemas distintos y se arreglan con cosas distintas. */
  var fin = document.querySelector("[data-fin]");
  if (fin && "IntersectionObserver" in window) {
    var visto = false;
    new IntersectionObserver(function (entradas) {
      if (visto || !entradas[0].isIntersecting) return;
      visto = true;
      evento("ViewContent", { content_name: landing + " · leyó hasta el final" });
    }, { threshold: 0.4 }).observe(fin);
  }
})();
