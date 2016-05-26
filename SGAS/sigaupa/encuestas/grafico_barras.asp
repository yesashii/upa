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

cantidad_x_profesor = conexion.consultaUno("select count(*) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
metodologicos_x_p = conexion.consultaUno("select sum(metodologicos) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
interaccion_x_p = conexion.consultaUno("select sum(interaccion) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")
administrativos_x_p = conexion.consultaUno("select sum(administrativos) from evaluacion_docente where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)= '"&pers_ncorr_profesor&"'")

if cantidad_x_profesor <> "0" then
        metodologicos_x_profesor = clng(clng(metodologicos_x_p) / clng(cantidad_x_profesor))
		interaccion_x_profesor = clng(clng(interaccion_x_p) / clng(cantidad_x_profesor))
		administrativos_x_profesor = clng(clng(administrativos_x_p) / clng(cantidad_x_profesor))
else
        metodologicos_x_profesor = 0
		interaccion_x_profesor = 0
		administrativos_x_profesor = 0
end if

total_x_profesor = clng(metodologicos_x_profesor) + clng(interaccion_x_profesor)+clng(administrativos_x_profesor)

carr_ccod = conexion.consultaUno("select carr_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")
peri_ccod = conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")

cantidad_x_carrera = conexion.consultaUno("select count(*) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
metodologicos_x_c = conexion.consultaUno("select sum(metodologicos) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
interaccion_x_c = conexion.consultaUno("select sum(interaccion) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
administrativos_x_c = conexion.consultaUno("select sum(administrativos) from secciones a, evaluacion_docente b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")

if cantidad_x_profesor <> "0" then
        metodologicos_x_carrera = clng(clng(metodologicos_x_c) / clng(cantidad_x_carrera))
		interaccion_x_carrera = clng(clng(interaccion_x_c) / clng(cantidad_x_carrera))
		administrativos_x_carrera = clng(clng(administrativos_x_c) / clng(cantidad_x_carrera))
else
        metodologicos_x_carrera = 0
		interaccion_x_carrera = 0
		administrativos_x_carrera = 0
end if

total_x_carrera = clng(metodologicos_x_carrera) + clng(interaccion_x_carrera)+clng(administrativos_x_carrera)

'response.Write("<hr>"&carr_ccod)

facu_ccod = conexion.consultaUno("select b.facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
cantidad_x_facultad = conexion.consultaUno("select count(*) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
metodologicos_x_f = conexion.consultaUno("select sum(metodologicos) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
interaccion_x_f = conexion.consultaUno("select sum(interaccion) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")
administrativos_x_f = conexion.consultaUno("select sum(administrativos) from secciones a,evaluacion_docente b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod")

if cantidad_x_profesor <> "0" then
        metodologicos_x_facultad = clng(clng(metodologicos_x_f) / clng(cantidad_x_facultad))
		interaccion_x_facultad = clng(clng(interaccion_x_f) / clng(cantidad_x_facultad))
		administrativos_x_facultad = clng(clng(administrativos_x_f) / clng(cantidad_x_facultad))
else
        metodologicos_x_facultad = 0
		interaccion_x_facultad = 0
		administrativos_x_facultad = 0
end if
total_x_facultad = clng(metodologicos_x_facultad) + clng(interaccion_x_facultad)+clng(administrativos_x_facultad)


cantidad_x_universidad = conexion.consultaUno("select count(*) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")
metodologicos_x_u = conexion.consultaUno("select sum(metodologicos) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")
interaccion_x_u = conexion.consultaUno("select sum(interaccion) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")
administrativos_x_u = conexion.consultaUno("select sum(administrativos) from evaluacion_docente where cast(peri_ccod as varchar)='"&peri_ccod&"'")

if cantidad_x_universidad <> "0" then
        metodologicos_x_universidad = clng(clng(metodologicos_x_u) / clng(cantidad_x_universidad))
		interaccion_x_universidad = clng(clng(interaccion_x_u) / clng(cantidad_x_universidad))
		administrativos_x_universidad = clng(clng(administrativos_x_u) / clng(cantidad_x_universidad))
else
        metodologicos_x_universidad = 0
		interaccion_x_universidad = 0
		administrativos_x_universidad = 0
end if
total_x_universidad = clng(metodologicos_x_universidad) + clng(interaccion_x_universidad)+clng(administrativos_x_universidad)


docente = conexion.consultaUno("Select replace ((pers_tnombre + ' ' + pers_tape_paterno),'Ñ','N') from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
carrera = conexion.consultaUno("Select replace(carr_tdesc,'Ñ','N') from carreras where carr_ccod ='"&carr_ccod&"'")
facultad = conexion.consultaUno("Select replace(facu_tdesc,'Ñ','N') from facultades where facu_ccod ='"&facu_ccod&"'")

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

objChart.Max = 140

objChart.Min = 0

objChart.Vertical = True

Dim objSet

Set objSet = objChart.AddSet()
'15823
objSet.Name = "PROMEDIO PROFESOR "&docente
objSet.AddPoints Array("METODOLOGIA",metodologicos_x_profesor,"INTERACCION",interaccion_x_profesor,"ADMINISTRATIVO",administrativos_x_profesor,"PUNTAJE TOTAL",total_x_profesor)
objSet.FillIndex = 2

Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO CARRERA "&carrera
objSet.AddPoints Array("METODOLOGIA",metodologicos_x_carrera,"INTERACCION",interaccion_x_carrera,"ADMINISTRATIVO",administrativos_x_carrera,"PUNTAJE TOTAL",total_x_carrera)
objSet.FillIndex = 3

Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO "&facultad
objSet.AddPoints Array("METODOLOGIA",metodologicos_x_facultad,"INTERACCION",interaccion_x_facultad,"ADMINISTRATIVO",administrativos_x_facultad,"PUNTAJE TOTAL",total_x_facultad)
objSet.FillIndex = 4

Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO UNIVERSIDAD DEL PACIFICO"
objSet.AddPoints Array("METODOLOGIA",metodologicos_x_universidad,"INTERACCION",interaccion_x_universidad,"ADMINISTRATIVO",administrativos_x_universidad,"PUNTAJE TOTAL",total_x_universidad)
objSet.FillIndex = 5
Set objSet = objChart.AddSet()
objSet.Name = ""
objSet.AddPoints Array("METODOLOGIA",0,"INTERACCION",0,"ADMINISTRATIVO",0,"PUNTAJE TOTAL",0)
objSet.FillIndex = 6

objChart.Render
'response.End()
objCanvas.Write
%>