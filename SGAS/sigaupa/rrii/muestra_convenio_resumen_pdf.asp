<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod =Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
carr_ccod =Request.QueryString("b[0][carr_ccod]")
anos_ccod =Request.QueryString("b[0][anos_ccod]")
fecha_fin_1 =Request.QueryString("b[0][fecha_fin_1]")
fecha_ini_1 =Request.QueryString("b[0][fecha_ini_1]")
fecha_fin_2 =Request.QueryString("b[0][fecha_fin_2]")
fecha_ini_2 =Request.QueryString("b[0][fecha_ini_2]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



if pais_ccod<>"" and ciex_ccod<>"" then
 consulta_uni="select b.univ_ccod,univ_tdesc from universidad_ciudad a, universidades b where a.univ_ccod=b.univ_ccod and ciex_ccod="&ciex_ccod&""
else
 consulta_uni="select ''"
end if


if  pais_ccod <>""  then
filtro2=filtro2&"and e.pais_ccod="&pais_ccod&""
end if

if  ciex_ccod <>"" then
filtro=filtro&"and e.ciex_ccod="&ciex_ccod&""
end if




if univ_ccod<>"" then
filtro3=filtro3&"and b.univ_ccod="&univ_ccod&""
end if
 
 
if carr_ccod<> "" then
filtro4=filtro4&"and d.carr_ccod="&carr_ccod&""
end if


if fecha_fin_1<> ""  and  fecha_ini_1<> "" then
filtro6=filtro6&"and convert(datetime,daco_flimite_pos_sem1_upa,103) between convert(datetime,'"&fecha_ini_1&"',103) and convert(datetime,'"&fecha_fin_1&"',103)"
end if

if fecha_fin_2<> ""  and  fecha_ini_2<> "" then
filtro7=filtro7&"and convert(datetime,daco_flimite_pos_sem2_upa,103) between convert(datetime,'"&fecha_ini_2&"',103) and convert(datetime,'"&fecha_fin_2&"',103)"
end if


 
set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resumen_convenio.Inicializar conexion

sql_descuentos="select a.daco_ncorr,univ_tdesc,pais_tdesc,ciex_tdesc,"& vbCrLf &_
"protic.obtener_carreras_convenio_rrii_pdf(a.daco_ncorr)as carreras_convenio,"& vbCrLf &_
"protic.trunc(daco_flimite_pos_sem1_upa)as daco_flimite_pos_sem1_upa,"& vbCrLf &_
"protic.trunc(daco_flimite_pos_sem2_upa)as daco_flimite_pos_sem2_upa,"& vbCrLf &_
"daco_ncupo"& vbCrLf &_
"from datos_convenio a,"& vbCrLf &_
"universidad_ciudad b,"& vbCrLf &_
"universidades c,"& vbCrLf &_
"carreras_convenio d,"& vbCrLf &_
"ciudades_extranjeras e,"& vbCrLf &_
"paises f"& vbCrLf &_
"where a.unci_ncorr=b.unci_ncorr"& vbCrLf &_
"and b.univ_ccod=c.univ_ccod"& vbCrLf &_
"and b.ciex_ccod=e.ciex_ccod"& vbCrLf &_
"and a.daco_ncorr=d.daco_ncorr"& vbCrLf &_
"and a.anos_ccod="&anos_ccod&""& vbCrLf &_
"and d.ecco_ccod=1"& vbCrLf &_
"and e.pais_ccod=f.pais_ccod"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro6&""& vbCrLf &_
""&filtro7&""& vbCrLf &_
"group by univ_tdesc,a.daco_ncorr,daco_flimite_pos_sem1_upa,daco_flimite_pos_sem2_upa,daco_ncupo,pais_tdesc,ciex_tdesc"				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_resumen_convenio.Consultar sql_descuentos

	
				
Set pdf=CreateJsObject("FPDF")

pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",10
pdf.Open()
pdf.LoadModels("informe_encuesta") 
pdf.SetAutoPageBreak TRUE,20
pdf.AddPage()
pdf.SetFont "Arial","B",8
pdf.SetY(60)
pdf.MultiCell 35,8,"Institución","1","C",""
pdf.SetY(60)
pdf.SetX(45)
pdf.MultiCell 25,8,"Pais","1","C",""
pdf.SetY(60)
pdf.SetX(70)
pdf.MultiCell 28,8,"Ciudad","1","C",""
pdf.SetY(60)
pdf.SetX(98)
pdf.MultiCell 12,8,"Cupo","1","C",""
pdf.SetY(60)
pdf.SetX(110)
pdf.MultiCell 20,4,"Fecha Limite Pos. 1° sem","1","C",""
pdf.SetY(60)
pdf.SetX(130)
pdf.MultiCell 20,4,"Fecha Limite Pos. 2° sem","1","C",""
pdf.SetY(60)
pdf.SetX(150)
pdf.MultiCell 55,8,"Carrera UPA en Convenio","1","C",""
pdf.ln(3)
pdf.SetFont "Arial","",6
contador=0
while f_resumen_convenio.siguiente
pdf.ln(2)
pdf.MultiCell 35,5,f_resumen_convenio.ObtenerValor("univ_tdesc"),"","C",""
pdf.SetY(pdf.GetY()-5)
pdf.SetX(45)
pdf.MultiCell 25,5,f_resumen_convenio.ObtenerValor("pais_tdesc"),"","C",""
pdf.SetY(pdf.GetY()-5)
pdf.SetX(70)
pdf.MultiCell 28,5,f_resumen_convenio.ObtenerValor("ciex_tdesc"),"","C",""
pdf.SetX(98)
pdf.Cell 10,-6,""&f_resumen_convenio.ObtenerValor("daco_ncupo")&"","","","C"
pdf.SetX(110)	
pdf.Cell 20,-6,""&f_resumen_convenio.ObtenerValor("daco_flimite_pos_sem1_upa")&"","","","C"
pdf.SetX(130)
pdf.Cell 20,-6,""&f_resumen_convenio.ObtenerValor("daco_flimite_pos_sem2_upa")&"","","","C"	
	
	set f_carrera = new CFormulario
	f_carrera.Carga_Parametros "tabla_vacia.xml", "tabla" 
	f_carrera.Inicializar conexion
	
	daco_ncorr=f_resumen_convenio.ObtenerValor("daco_ncorr")
	sql_carr="select case when a.carr_ccod= 950 then 'PED.EDUC.MEDIA EN HISTORIA Y C.S.' when a.carr_ccod= 940 then 'PED. EDUCACION MEDIA EN LENGUAJE Y COM.' else carr_tdesc end as carr_tdesc from carreras a, carreras_convenio b where a.carr_ccod=b.carr_ccod and a.carr_ccod<>'001' and b.daco_ncorr="&daco_ncorr&""
	'response.Write(sql_carr)
	'response.End()
	f_carrera.Consultar sql_carr
	
	while f_carrera.siguiente
	pdf.ln(5)
	pdf.SetX(150)
	'pdf.MultiCell 78,8,"Carrera UPA en Convenio","1","C",""
	pdf.Cell 55,-30,""&f_carrera.ObtenerValor("carr_tdesc")&"","","","C"
	
	wend
	
if contador=0 then
	yy=pdf.GetY()-5
	pdf.Line 10, yy, 205, yy
else
	yy=pdf.GetY()-10
	pdf.Line 10, yy, 205, yy
end if

contador=contador+1
wend
pdf.Line 10, yy, 10, 60
pdf.Line 45, yy, 45, 60
pdf.Line 70, yy, 70, 60
pdf.Line 98, yy, 98, 60
pdf.Line 110, yy, 110, 60
pdf.Line 130, yy, 130, 60
pdf.Line 150, yy, 150, 60
pdf.Line 205, yy, 205, 60
pdf.Close()
pdf.Output()
%>
