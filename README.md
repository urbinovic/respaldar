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
| `turnos.html` · `gastronomia.html` · `tienda.html` · `whatsapp.html` · `transporte.html` | **Las landings de campaña.** Una por rubro, para el tráfico de publicidad. |
| `campana.css` · `campana.js` | El motor que comparten las landings (y del que la home usa el píxel y los WhatsApp). |
| `campanas.html` | **Interna del equipo**, noindex. El plan de campañas: públicos, textos de anuncio, presupuesto y qué medir. |
| `vendedor.html` | **Interna del equipo**, sin links desde el sitio. El entrenador de ventas: se comparte como `respald.ar/vendedor.html?v=Nombre`. |
| `demos/` | Capturas REALES de producción usadas en la sección de demos, la foto y los logos de clientes. |
| `marca/` | Manual de marca y los tres SVG del logo. |
| `og-fuente.html` | Fuente de `og.png` (la tarjeta de WhatsApp). Se regenera con Edge headless. |
| `chequear.ps1` | Guardián de la paleta. Barre TODOS los .html y .css. Falla si se coló un color que no es de la marca. Correr antes de publicar. |
| `medir-largo.ps1` | Cuánto scroll cuesta cada sección. `medir-largo.ps1 turnos.html` para una landing. Correr **antes de opinar** sobre el largo. |

## La home y las landings son dos cosas distintas

No es la misma página más corta. Es otra página, para otro visitante:

| | La home | Una landing de campaña |
|---|---|---|
| Para quién | El que ya te conoce: referido, tarjeta, la mesa | El desconocido que tocó un anuncio |
| Qué trae | Todo lo que hacemos, y elige su rubro | UNA promesa, la del anuncio |
| Menú | Sí | **No.** La única salida es el WhatsApp |
| Largo | 12 a 15 pantallas | **6.** Medido, no opinado |
| Precio | En la primera pantalla | En la primera pantalla |

Las cinco landings comparten esqueleto: hero con el dolor del rubro en su
idioma, la prueba real antes de la pantalla 2, cuatro momentos del día, la
oferta, y el cierre. La barra fija de abajo tiene el WhatsApp siempre a la
vista: **la auditoría del 21/08/2026 encontró que la home tenía UN solo
link de WhatsApp y estaba en la pantalla 15,4 de 15,6.**

### Reglas de las landings

1. **Nada inventado al lado de lo real.** Transporte no tiene demo pública
   porque el panel de una empresa es privado, y por eso ahí la pantalla va
   dibujada y **rotulada como ejemplo**. No se pone una captura falsa
   debajo de un título que dice "esto no es una maqueta".
2. **Un solo precio en todo el sitio.** Si cambia la promo, cambia en las
   cinco landings y en la home. Buscar `$50.000`.
3. **El mensaje de WhatsApp lleva la campaña adentro**, entre paréntesis
   al final. Es la atribución que no depende de Meta: llega el mensaje y
   ya sabés de qué anuncio salió.
4. **El píxel se carga en `campana.js`**, una sola vez, y lo usan las seis
   páginas. Mientras esté vacío la página anda igual, sin medir.

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
