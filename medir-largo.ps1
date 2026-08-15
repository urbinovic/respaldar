# ═══════════════════════════════════════════════════════════════════
#  ¿CUÁNTO SCROLL CUESTA CADA SECCIÓN?  ·  respald.ar
# ═══════════════════════════════════════════════════════════════════
#  Pelá, 15/08/2026: "me sigue pareciendo ultra larga".
#  La página tenía 27 pantallas de celular y la grasa no estaba donde
#  parecía: las secciones más largas eran las que menos vendían (una se
#  comía 2,9 pantallas para decir en abstracto lo que el recorrido del
#  día ya demuestra con hechos).
#
#  Correlo cuando la página se sienta larga, ANTES de opinar:
#      powershell -File respald\medir-largo.ps1
#
#  Referencia: una landing que vende se recorre en 12 a 15 pantallas.
#  Una sección que pasa de 2 pantallas tiene que estar ganándoselas.
# ═══════════════════════════════════════════════════════════════════

$sp   = $env:TEMP
$web  = $PSScriptRoot
$html = [System.IO.File]::ReadAllText((Join-Path $web "index.html"), [System.Text.Encoding]::UTF8)
$html = $html.Replace('<head>', '<head><base href="file:///' + $web.Replace('\','/') + '/">')
[System.IO.File]::WriteAllText("$sp\_medir_pagina.html", $html, (New-Object System.Text.UTF8Encoding($false)))

$wrap = @'
<!doctype html><meta charset="utf-8"><body style="margin:0">
<iframe id="f" src="_medir_pagina.html" style="width:390px;height:60000px;border:0"></iframe>
<pre id="OUT"></pre>
<script>
document.getElementById('f').addEventListener('load',()=>{
  setTimeout(()=>{
    const d=document.getElementById('f').contentDocument;
    const total=d.body.scrollHeight;
    const filas=[...d.querySelectorAll('section')].map((s,i)=>{
      const h=s.querySelector('h1,h2');
      const alto=Math.round(s.getBoundingClientRect().height);
      return {n:i+1, id:s.id||'-', pant:+(alto/844).toFixed(1),
        pct:Math.round(alto/total*100),
        tit:(h?h.textContent.trim().replace(/\s+/g,' '):'(sin titulo)').slice(0,42)};
    });
    document.getElementById('OUT').textContent='@@'+JSON.stringify({
      pantallas:+(total/844).toFixed(1), secciones:filas})+'@@';
  },800);
});
</script>
'@
[System.IO.File]::WriteAllText("$sp\_medir_wrap.html", $wrap, (New-Object System.Text.UTF8Encoding($false)))

$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edge)) { $edge = "C:\Program Files\Microsoft\Edge\Application\msedge.exe" }
$salida = "$sp\_medir_dom.txt"
Start-Process -FilePath $edge -ArgumentList "--headless","--disable-gpu","--allow-file-access-from-files","--window-size=1200,900","--virtual-time-budget=12000","--dump-dom",("file:///" + "$sp\_medir_wrap.html".Replace('\','/')) -RedirectStandardOutput $salida -NoNewWindow -Wait

$t = [System.IO.File]::ReadAllText($salida, [System.Text.Encoding]::UTF8)
if ($t -notmatch '(?s)@@(.+?)@@') { "No pude medir (Edge no devolvio nada)"; exit 1 }
$j = $Matches[1] | ConvertFrom-Json

"LARGO TOTAL: $($j.pantallas) pantallas de celular    (objetivo: 12 a 15)"
""
"{0,-3} {1,-11} {2,6} {3,5}  {4}" -f "#","id","pant","%","titulo"
foreach ($s in $j.secciones) {
  $alerta = if ($s.pant -ge 2) { " <-- pesada" } else { "" }
  ("{0,-3} {1,-11} {2,6} {3,4}%  {4}{5}" -f $s.n,$s.id,$s.pant,$s.pct,$s.tit,$alerta)
}
""
"Regla: una seccion pesada tiene que DEMOSTRAR algo. Si solo lo afirma, se corta."
