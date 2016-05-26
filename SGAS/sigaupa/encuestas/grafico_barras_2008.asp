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

cantidad_x_profesor = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos b where cast(secc_ccod as varchar)= '"&secc_ccod&"' and cast(pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 ")
if cantidad_x_profesor <> "0" then
	nivel_1_x_profesor = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_1) as decimal(3,2))*100 as numeric) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 "))
	nivel_2_x_profesor = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_2) as decimal(3,2))*100 as numeric)  from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 "))
	nivel_3_x_profesor = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_3) as decimal(3,2))*100 as numeric)  from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 "))
	nivel_4_x_profesor = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_4) as decimal(3,2))*100 as numeric)  from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 "))
else
	nivel_1_x_profesor = 0
	nivel_2_x_profesor = 0
	nivel_3_x_profesor = 0
	nivel_4_x_profesor = 0
end if

total_x_profesor = cInt(conexion.consultaUno("select cast(cast(avg(puntaje_total) as decimal(3,2))*100 as numeric)  from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr&"' and isnull(estado_cuestionario,0) = 2 "))
'response.Write("<br>"&nivel_1_x_profesor)
'response.Write("<br>"&nivel_2_x_profesor)
'response.Write("<br>"&nivel_3_x_profesor)
'response.Write("<br>"&nivel_4_x_profesor)
'response.Write("<br>"&total_x_profesor&"<br><br>")
carr_ccod = conexion.consultaUno("select carr_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")
peri_ccod = conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)= '"&secc_ccod&"'")

cantidad_x_carrera = conexion.consultaUno("select count(*) from secciones a, cuestionario_opinion_alumnos b where cast(a.carr_ccod as varchar)= '"&carr_ccod&"' and  cast(a.peri_ccod as varchar)= '"&peri_ccod&"' and a.secc_ccod=b.secc_ccod and isnull(estado_cuestionario,0) = 2 ")
if cantidad_x_carrera <> "0" then
		nivel_1_x_carrera = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_1) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_2_x_carrera = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_2) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_3_x_carrera = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_3) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_4_x_carrera = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_4) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))

else
        nivel_1_x_carrera = 0
		nivel_2_x_carrera = 0
		nivel_3_x_carrera = 0
		nivel_4_x_carrera = 0

end if

total_x_carrera = cInt(conexion.consultaUno("select cast(cast(avg(puntaje_total) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
'response.Write("<br>"&nivel_1_x_carrera)
'response.Write("<br>"&nivel_2_x_carrera)
'response.Write("<br>"&nivel_3_x_carrera)
'response.Write("<br>"&nivel_4_x_carrera)
'response.Write("<br>"&total_x_carrera&"<br><br>")
'response.Write("<hr>"&carr_ccod)

facu_ccod = conexion.consultaUno("select b.facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")

cantidad_x_facultad = conexion.consultaUno("select count(*) from secciones a,cuestionario_opinion_alumnos b where carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(a.peri_ccod as varchar)='"&peri_ccod&"' and a.secc_ccod=b.secc_ccod and isnull(estado_cuestionario,0) = 2 ")
if cantidad_x_facultad <> "0" then
		nivel_1_x_facultad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_1) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_2_x_facultad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_2) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_3_x_facultad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_3) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_4_x_facultad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_4) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
else
        nivel_1_x_facultad = 0
		nivel_2_x_facultad = 0
		nivel_3_x_facultad = 0
		nivel_4_x_facultad = 0

end if
total_x_facultad = cInt(conexion.consultaUno("select cast(cast(avg(puntaje_total) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
'response.Write("<br>"&nivel_1_x_facultad)
'response.Write("<br>"&nivel_2_x_facultad)
'response.Write("<br>"&nivel_3_x_facultad)
'response.Write("<br>"&nivel_4_x_facultad)
'response.Write("<br>"&total_x_facultad&"<br><br>")
cantidad_x_universidad = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos a,secciones b where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2")
if cantidad_x_universidad <> "0" then
		nivel_1_x_universidad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_1) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_2_x_universidad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_2) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_3_x_universidad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_3) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
		nivel_4_x_universidad = cInt(conexion.consultaUno("select cast(cast(avg(promedio_dimension_4) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))

else
        nivel_1_x_universidad = 0
		nivel_2_x_universidad = 0
		nivel_3_x_universidad = 0
		nivel_4_x_universidad = 0

end if
total_x_universidad = cInt(conexion.consultaUno("select cast(cast(avg(puntaje_total) as decimal(3,2))*100 as numeric)  from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 "))
'response.Write("<br>"&nivel_1_x_universidad)
'response.Write("<br>"&nivel_2_x_universidad)
'response.Write("<br>"&nivel_3_x_universidad)
'response.Write("<br>"&nivel_4_x_universidad)
'response.Write("<br>"&total_x_universidad&"<br><br>")

docente = conexion.consultaUno("Select replace ((pers_tnombre + ' ' + pers_tape_paterno),'Ñ','N') from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
carrera = conexion.consultaUno("Select replace(carr_tdesc,'Ñ','N') from carreras where carr_ccod ='"&carr_ccod&"'")
facultad = conexion.consultaUno("Select replace(facu_tdesc,'Ñ','N') from facultades where facu_ccod ='"&facu_ccod&"'")

Dim objCanvas, objChart

Set objCanvas = New Canvas
Set objChart = New ChartBar

objCanvas.GlobalColourTable(0) = RGB(255,255,255)
objCanvas.GlobalColourTable(1) = RGB(0,0,0)
objCanvas.GlobalColourTable(2) = RGB(252,250,149)
objCanvas.GlobalColourTable(3) = RGB(233,232,210)
objCanvas.GlobalColourTable(4) = RGB(229,230,255)
objCanvas.GlobalColourTable(5) = RGB(111,121,255)
objCanvas.GlobalColourTable(6) = RGB(255,255,255)

objCanvas.Resize 550,550,False

objCanvas.ForegroundColourIndex = 1

objCanvas.Rectangle 0,0,548,548

Set objChart.ActiveCanvas = objCanvas

objChart.Left = 50
objChart.Top = 80

objChart.Width = 490
objChart.Height = 380

objChart.Max = 600

objChart.Min = 0

objChart.Vertical = True

Dim objSet
'response.End()
Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO PROFESOR "&docente
objSet.AddPoints Array("NIVEL 1",nivel_1_x_profesor,"NIVEL 2",nivel_2_x_profesor,"NIVEL 3",nivel_3_x_profesor,"NIVEL 4",nivel_4_x_profesor,"PUNTAJE TOTAL",total_x_profesor)
objSet.FillIndex = 2

Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO CARRERA "&carrera
objSet.AddPoints Array("NIVEL 1",nivel_1_x_carrera,"NIVEL 2",nivel_2_x_carrera,"NIVEL 3",nivel_3_x_carrera,"NIVEL 4",nivel_4_x_carrera,"PUNTAJE TOTAL",total_x_carrera)
objSet.FillIndex = 3

Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO "&facultad
objSet.AddPoints Array("NIVEL 1",nivel_1_x_facultad,"NIVEL 2",nivel_2_x_facultad,"NIVEL 3",nivel_3_x_facultad,"NIVEL 4",nivel_4_x_facultad,"PUNTAJE TOTAL",total_x_facultad)
objSet.FillIndex = 4

Set objSet = objChart.AddSet()

objSet.Name = "PROMEDIO UNIVERSIDAD DEL PACIFICO"
objSet.AddPoints Array("NIVEL 1",nivel_1_x_universidad,"NIVEL 2",nivel_2_x_universidad,"NIVEL 3",nivel_3_x_universidad,"NIVEL 4",nivel_4_x_universidad,"PUNTAJE TOTAL",total_x_universidad)
objSet.FillIndex = 5
Set objSet = objChart.AddSet()
objSet.Name = ""
objSet.AddPoints Array("NIVEL 1",0,"NIVEL 2",0,"NIVEL 3",0,"NIVEL 4",0,"PUNTAJE TOTAL",0)
objSet.FillIndex = 6

objChart.Render
'response.End()
objCanvas.Write
%>