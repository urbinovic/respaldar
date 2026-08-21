# ═══════════════════════════════════════════════════════════════════
#  GUARDIÁN DE LA PALETA  ·  respald.ar
# ═══════════════════════════════════════════════════════════════════
#  Pelá, 15/08/2026: "ojo con la paleta de colores".
#  La página había juntado un rosa, un verde manzana, un dorado y un
#  fondo casi negro sin que nadie lo decidiera. Un color se cuela de a
#  uno y no se nota hasta que la página parece de cinco marcas.
#
#  Correlo antes de publicar:   powershell -File respald\chequear.ps1
#  Sale 0 si está limpio, 1 si se coló algo.
#
#  21/08/2026: miraba SOLO index.html. Con las landings de campaña y el
#  CSS compartido eso ya no alcanza: un color se cuela justo en el
#  archivo que el guardián no mira y el guardián dice que está todo
#  bien. Ahora barre todos los .html y .css de la carpeta y de marca/,
#  y dice en cuál apareció.
# ═══════════════════════════════════════════════════════════════════

# marca/mundos.html y marca/propuestas*.html quedan AFUERA a propósito:
# son los tableros donde se muestran paletas alternativas para elegir
# una. Si el guardián las mirara, gritaría siempre y dejaríamos de
# hacerle caso, que es la única forma de que un chequeo sirva de nada.
$fuera = 'mundos\.html$|propuestas.*\.html$'

$archivos = @(Get-ChildItem -Path $PSScriptRoot -Include *.html,*.css -File -Recurse |
              Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.Name -notmatch $fuera })

# Los únicos colores que pueden aparecer escritos a mano. Todo lo demás
# tiene que salir de una variable var(--…). Si necesitás un tono nuevo,
# se agrega ACÁ y como token, nunca suelto en medio del archivo.
$permitidos = @(
  '#0f2a4a','#16385f',                     # tinta: la base
  '#ff8a3d','#c2540b','#2a1503','#ffe8d6', # cálido: la acción
  '#c8ee3d','#6f8c0e','#1e2b06','#e7f5cf', # lima: la energía
  '#c2453a','#fbe4e1',                     # rojo: la alerta
  '#ffffff','#fff','#eef2f7','#586b7e','#aabfd3','#dde5ed',
  # escala azul derivada del tinta (sombras, bordes y fondos suaves)
  '#0a1c30','#1d3550','#1c4471','#2c4c6d','#6d7f92',
  '#c9d4e0','#d3dde7','#e2ecf5','#e7ecf2','#eef2f6'
)

$intrusos = @{}
foreach ($a in $archivos) {
  $texto = [System.IO.File]::ReadAllText($a.FullName, [System.Text.Encoding]::UTF8)
  $rel = $a.FullName.Substring($PSScriptRoot.Length).TrimStart('\')
  foreach ($m in [regex]::Matches($texto, '#[0-9a-fA-F]{3,8}')) {
    $c = $m.Value.ToLower()
    if ($permitidos -notcontains $c) {
      $linea = ($texto.Substring(0, $m.Index) -split "`n").Count
      if (-not $intrusos.ContainsKey($c)) {
        $intrusos[$c] = [pscustomobject]@{ Veces = 0; Donde = "$rel linea $linea" }
      }
      $intrusos[$c].Veces++
    }
  }
}

"Revisados $($archivos.Count) archivos (.html y .css)."
if ($intrusos.Count -eq 0) {
  "PALETA OK - ningun color fuera de la marca"
  exit 0
}

"PALETA ROTA - se colaron $($intrusos.Count) colores que no son de la marca:"
foreach ($k in ($intrusos.Keys | Sort-Object)) {
  "   $k   x$($intrusos[$k].Veces)   (primera vez en $($intrusos[$k].Donde))"
}
"Arreglalo: usa un var(--token) existente, o sumalo arriba si de verdad hace falta."
exit 1
