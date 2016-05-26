<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!--#include file="../biblioteca/canvas.asp"-->
<!--#include file="../biblioteca/charts/chart_bar.asp"-->
<!--#include file="../biblioteca/extra_fonts/lucida_8_point.asp"-->
<%

pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
'pers_ncorr = "23804"
'secc_ccod = "36734"
'response.Write(secc_ccod)

pers_ncorr_profesor = pers_ncorr

set conexion = new cconexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = "  select distinct a.sede_ccod,case a.sede_ccod when 1 then 'Sede' when 2 then 'Campus' when 4 then 'Sede' when 8 then 'Campus' end + ' ' + protic.initcap(a.sede_tdesc) as sede, "& vbcrlf & _
		   " (select count(*) from postulantes aa, detalle_postulantes bb, ofertas_academicas cc "& vbcrlf & _
		   "  where aa.post_ncorr=bb.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr and aa.peri_ccod=214 "& vbcrlf & _
		   "  and cc.sede_ccod=b.sede_ccod and aa.post_bnuevo='S' and aa.epos_ccod in (1,2) and isnull(bb.eepo_ccod,1)=1 "& vbcrlf & _
		   "  and not exists (select 1 from alumnos ccc where ccc.post_ncorr=aa.post_ncorr)) as postulacion_previa, "& vbcrlf & _
		   " (select count(*) from postulantes aa, detalle_postulantes bb, ofertas_academicas cc "& vbcrlf & _
		   "  where aa.post_ncorr=bb.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr and aa.peri_ccod=214 "& vbcrlf & _
		   "  and cc.sede_ccod=b.sede_ccod and aa.post_bnuevo='S' and aa.epos_ccod in (1) and isnull(bb.eepo_ccod,1)=2 "& vbcrlf & _
		   "  and not exists (select 1 from alumnos ccc where ccc.post_ncorr=aa.post_ncorr)) as aprobados_sin_completar, "& vbcrlf & _
		   " (select count(*) from postulantes aa, detalle_postulantes bb, ofertas_academicas cc "& vbcrlf & _
		   "  where aa.post_ncorr=bb.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr and aa.peri_ccod=214 "& vbcrlf & _
		   "  and cc.sede_ccod=b.sede_ccod and aa.post_bnuevo='S' and aa.epos_ccod in (2) and isnull(bb.eepo_ccod,1)=2 "& vbcrlf & _
		   "  and not exists (select 1 from alumnos ccc where ccc.post_ncorr=aa.post_ncorr)) as ficha_completa_sin_matricular,    "& vbcrlf & _
		   "  (select count(*) from postulantes aa, detalle_postulantes bb, ofertas_academicas cc "& vbcrlf & _
		   "   where aa.post_ncorr=bb.post_ncorr and bb.ofer_ncorr=cc.ofer_ncorr and aa.peri_ccod=214 "& vbcrlf & _
		   "   and cc.sede_ccod=b.sede_ccod and aa.post_bnuevo='S' and aa.epos_ccod in (2) and isnull(bb.eepo_ccod,1)=2 "& vbcrlf & _
		   "   and exists (select 1 from alumnos ccc where ccc.post_ncorr=aa.post_ncorr and ccc.ofer_ncorr=bb.ofer_ncorr)) as matriculados   "& vbcrlf & _
		   "   from sedes a, ofertas_academicas b "& vbcrlf & _
		   "  where a.sede_ccod=b.sede_ccod and b.peri_ccod=214 and b.post_bnuevo='S' "& vbcrlf & _
		   "  and b.ofer_bpublica='S' "
		  
formulario.Consultar consulta 

Dim objCanvas, objChart

Set objCanvas = New Canvas
Set objChart = New ChartBar

objCanvas.GlobalColourTable(0) = RGB(255,255,255)
objCanvas.GlobalColourTable(1) = RGB(0,0,0)
objCanvas.GlobalColourTable(2) = RGB(252,250,149)
objCanvas.GlobalColourTable(3) = RGB(144,0,0)
objCanvas.GlobalColourTable(4) = RGB(229,230,255)
objCanvas.GlobalColourTable(5) = RGB(111,121,255)
objCanvas.GlobalColourTable(6) = RGB(255,255,255)

objCanvas.Resize 550,450,False

objCanvas.ForegroundColourIndex = 1

objCanvas.Rectangle 0,0,548,448

Set objChart.ActiveCanvas = objCanvas

objChart.Left = 50
objChart.Top = 50

objChart.Width = 490
objChart.Height = 380

objChart.Max = 450

objChart.Min = 0

objChart.Vertical = True

Dim objSet


'15823
contador = 2
while formulario.siguiente
    sede                          = formulario.obtenerValor("sede")
	postulacion_previa            = formulario.obtenerValor("postulacion_previa")
	aprobados_sin_completar       = formulario.obtenerValor("aprobados_sin_completar")
	ficha_completa_sin_matricular = formulario.obtenerValor("ficha_completa_sin_matricular")
	matriculados                  = formulario.obtenerValor("matriculados")
	
	'Set objSet = objChart.AddSet()
	'objSet.Name = sede
	'objSet.AddPoints Array("Postulado",postulacion_previa,"Aprobado",aprobados_sin_completar,"Completado",ficha_completa_sin_matricular,"Matriculados",matriculados)
	'objSet.FillIndex = contador
	'response.Write("Postulado,"&postulacion_previa&",Aprobado,"&aprobados_sin_completar&",Completado,"&ficha_completa_sin_matricular&",Matriculados,"&matriculados&"<br>")
	'response.Write(contador&"<br>")
	contador = contador + 1
	
Wend

Set objSet = objChart.AddSet()
	objSet.Name = "LAS CONDES"
	objSet.AddPoints Array("Postulado",427,"Aprobado",77,"Completado",62,"Matriculados",0)
	objSet.FillIndex = 2

Set objSet = objChart.AddSet()
	objSet.Name = "LYON"
	objSet.AddPoints Array("Postulado",54,"Aprobado",5,"Completado",4,"Matriculados",0)
	objSet.FillIndex = 3

Set objSet = objChart.AddSet()
	objSet.Name = "MELIPILLA"
	objSet.AddPoints Array("Postulado",142,"Aprobado",21,"Completado",9,"Matriculados",0)
	objSet.FillIndex = 4

Set objSet = objChart.AddSet()
	objSet.Name = "BAQUEDANO"
	objSet.AddPoints Array("Postulado",78,"Aprobado",8,"Completado",3,"Matriculados",0)
	objSet.FillIndex = 5


Set objSet = objChart.AddSet()
objSet.Name = ""
objSet.AddPoints Array("Postulado",0,"Aprobado",0,"Completado",0,"Matriculados",0)
objSet.FillIndex = 6

'response.End()
objChart.Render
objCanvas.Write
%>