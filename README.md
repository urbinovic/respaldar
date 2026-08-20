# respald.ar

Sitio de **Respaldar**, la empresa de soluciones informáticas de Víctor "Pelá"
Martínez (San Juan). Marca separada de Aval.ar: acá se vende **desarrollo a
medida y los paquetes ya hechos**; Aval.ar es el producto propio y aparece
como caso y como la pata gratis de reputación.

> La familia: **aval.ar respalda a las personas · respald.ar respalda a los negocios.**

## Qué hay acá

| Archivo | Qué es |
|---|---|
| `index.html` | La página de venta. Todo el CSS y el JS van adentro, sin dependencias externas. |
| `vendedor.html` | **Interna del equipo**, sin links desde el sitio. El entrenador de ventas: se comparte como `respald.ar/vendedor.html?v=Nombre`. |
| `demos/` | Capturas REALES de producción usadas en la sección de demos, la foto y los logos de clientes. |
| `marca/` | Manual de marca y los tres SVG del logo. |
| `og-fuente.html` | Fuente de `og.png` (la tarjeta de WhatsApp). Se regenera con Edge headless. |
| `chequear.ps1` | Guardián de la paleta. Falla si se coló un color que no es de la marca. Correr antes de publicar. |
| `medir-largo.ps1` | Cuánto scroll cuesta cada sección, en pantallas de celular. Correr **antes de opinar** sobre el largo. |

## La sección de demos

Es la segunda sección de la página, arriba del argumento, porque la prueba
tiene que llegar antes que el discurso. Reglas:

- **Solo clientes reales y links públicos que abren.** El 20/08/2026 se mató la
  pantalla inventada de una barbería: teniendo el turnero real de Casa Valkiria,
  mostrar uno de mentira debajo del título *"esto no es una maqueta"* le regalaba
  la duda al que mira. Cada link se prueba antes de publicar.
- **Se agrupa por CLIENTE, no por función.** Lo que se vende no es un turnero
  suelto: es el negocio entero online. Por eso cada negocio muestra TODAS sus
  pantallas públicas.
- **El número del título se cuenta del DOM** (`#nDemos` cuenta los `.celu-links a`).
  Sumar o sacar un link no puede dejar el título mintiendo.

**Cómo se saca una captura** (Edge headless contra la URL pública):
`--headless=new` (el viejo falla), un **`--user-data-dir` distinto por captura**
(si no, la segunda y la tercera no salen y no avisan) y **`--window-size=480,900`**
(con 430 se corta el contenido a la derecha y los precios salen "$14.90" en vez
de "$14.900"). Después PNG→JPG con System.Drawing calidad 82.

## Reglas de esta página

1. **No se promete lo que no corre.** Lo que existe se muestra con captura real
   y link para tocarlo; lo que se puede construir se ofrece como "te lo
   armamos", nunca como andando.
2. **El cliente califica a la PERSONA que lo atendió, nunca al local.** Es el
   concepto de Aval.ar y no se escribe de otra manera.
3. **Prolijidad medible:** un solo padding de caja (`--caja`, y `--caja-b` para
   las que tienen borde), textos justificados, títulos nunca. Se verifica
   midiendo los ejes izquierdos en el DOM a 1280 y 375 px: dos ejes a menos de
   10 px son un error. El script está en el `CLAUDE.md` del repo de aval.ar.
4. **Toda caja de fondo claro declara su color de texto**, si no hereda el
   blanco de las franjas oscuras y el título desaparece.

## El bot

El chat del cierre y el entrenador de ventas usan la misma edge function
`entrevista-ia` que vive en el repo de aval.ar, con `marca:"respaldar"` (el
asistente se presenta como el de Respaldar) y `tipo:"sistemas"` o
`tipo:"vendedor"`. Las charlas quedan en `entrevista_conversaciones` y se leen
desde la solapa 🎙️ Entrevistas del admin de Aval.ar.

## Publicación

Cloudflare Pages, proyecto propio, plan Free. El dominio `respald.ar` se
registró el 13/08/2026 por NIC Argentina.
