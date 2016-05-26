<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


daco_ncorr=request.QueryString("daco_ncorr")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Becas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "becas.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "convenios_rrii.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "becas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_datos_convenio = new CFormulario
f_datos_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_datos_convenio.Inicializar conexion


sql_descuentos= "select protic.initcap(univ_tdesc)as univ_tdesc,"& vbCrLf &_
 "protic.initcap(ciex_tdesc)as ciex_tdesc,"& vbCrLf &_
 "protic.initcap(pais_tdesc)as pais_tdesc,"& vbCrLf &_
 "daco_tweb,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem1_upa)as daco_flimite_pos_sem1_upa,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem1)as daco_fini_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem1)as daco_ffin_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2_upa)as daco_flimite_pos_sem2_upa,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem2)as daco_fini_clase_sem2,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem2)as daco_ffin_clase_sem2,"& vbCrLf &_
 "daco_ttest_idioma,"& vbCrLf &_
  "idio_tdesc,"& vbCrLf &_
 "daco_tescala_avalu,"& vbCrLf &_
 "daco_ncupo,"& vbCrLf &_
 "daco_tramos_cursar,"& vbCrLf &_
 "anos_ccod,idio_tdesc "& vbCrLf &_
 "from datos_convenio a,"& vbCrLf &_
 "universidad_ciudad b,"& vbCrLf &_
 "universidades c,"& vbCrLf &_
 "ciudades_extranjeras d,"& vbCrLf &_
 "paises e,"& vbCrLf &_
 "idioma f"& vbCrLf &_
 "where a.unci_ncorr=b.unci_ncorr"& vbCrLf &_
 "and b.univ_ccod=c.univ_ccod"& vbCrLf &_
 "and b.ciex_ccod=d.ciex_ccod"& vbCrLf &_
 "and d.pais_ccod=e.PAIS_CCOD"& vbCrLf &_
 "and a.idio_ccod=f.idio_ccod"& vbCrLf &_
 "and a.daco_ncorr="&daco_ncorr&""
	
'response.Write("<br>"&sql_descuentos&"<br>")
			
'response.End()

f_datos_convenio.Consultar sql_descuentos
f_datos_convenio.siguiente



set f_carreras_convenio = new CFormulario
f_carreras_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_carreras_convenio.Inicializar conexion


sql_carreras="select distinct ltrim(rtrim(protic.initcap(carr_tdesc)))as carr_tdesc"& vbCrLf &_
"from carreras_convenio a, carreras b"& vbCrLf &_
"where a.carr_ccod=b.CARR_CCOD"& vbCrLf &_
"and a.ecco_ccod=1"& vbCrLf &_
"and a.daco_ncorr="&daco_ncorr&""

f_carreras_convenio.Consultar sql_carreras

set f_costo= new CFormulario
f_costo.Carga_Parametros "tabla_vacia.xml", "tabla"
f_costo.Inicializar conexion

sql_descuentos="select protic.initcap(tcvi_tdesc)as tcvi_tdesc,covi_monto,covi_comentario"& vbCrLf &_ 
"from costo_vida a,"& vbCrLf &_ 
"universidad_ciudad b,"& vbCrLf &_ 
"datos_convenio c, "& vbCrLf &_
"tipo_costo_vida d"& vbCrLf &_
"where a.ciex_ccod=b.ciex_ccod"& vbCrLf &_
"and b.unci_ncorr=c.unci_ncorr"& vbCrLf &_
"and c.daco_ncorr="&daco_ncorr&""& vbCrLf &_
"and a.tcvi_ccod=d.tcvi_ccod"

f_costo.Consultar sql_descuentos


'set f_contacto= new CFormulario
'f_contacto.Carga_Parametros "tabla_vacia.xml", "tabla"
'f_contacto.Inicializar conexion
'
'sql_descuentos="select euco_tnombre,euco_tcargo,euco_temail,euco_tfono,euco_tfax "& vbCrLf &_ 
'"from encargado_universidad_convenio a"& vbCrLf &_
'"where a.daco_ncorr="&daco_ncorr&""
'f_contacto.Consultar sql_descuentos




Set pdf=CreateJsObject("FPDF")

pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",10
pdf.Open()
pdf.LoadModels("informe_encuesta2") 
pdf.SetAutoPageBreak TRUE,20
pdf.AddPage()

y0 = ""

'----------------------------------------PRIMER CUADRO-------------------------------------


'pdf.Cell 40,1,"Nombre Universidad:","","","L"
pdf.SetFont "Arial","B",15
pdf.Cell 190,1,f_datos_convenio.obtenervalor("univ_tdesc"),"","","C"
pdf.ln(8)
pdf.SetFont "Arial","B",10
pdf.SetX(20)
pdf.Cell 20,1,"Pais:","","","C"
pdf.SetFont "Arial","",10
pdf.SetX(35)
pdf.Cell 50,1,f_datos_convenio.obtenervalor("pais_tdesc"),"","L",""
pdf.SetFont "Arial","B",10
pdf.SetX(65)
pdf.Cell 15,1,"Ciudad:","","","C"
pdf.SetFont "Arial","",10
pdf.SetX(85)
pdf.Cell 30,1,f_datos_convenio.obtenervalor("ciex_tdesc"),"","","C"
pdf.SetFont "Arial","B",10
pdf.SetX(120)
pdf.Cell 25,1,"Página Web:","","","C"
pdf.SetFont "Arial","",10
pdf.Cell 40,1,f_datos_convenio.obtenervalor("daco_tweb"),"","","C"

'-----------------------------------------carreras upa en convenio--------------------------
pdf.ln(20)
pdf.SetFont "Arial","B",12
pdf.Cell 190,1,"CARRERAS UPA EN CONVENIO:","","","C"
pdf.ln(8)
pdf.SetFont "Arial","",10
contador=0
while f_carreras_convenio.siguiente
	
	if contado=0 then
	pdf.SetX(70)
		pdf.Cell 132,1,f_carreras_convenio.obtenervalor("carr_tdesc"),"","","L"
		contado=contador+1
	else
		pdf.ln(6)
		pdf.SetX(70)
		pdf.Cell 132,1,f_carreras_convenio.obtenervalor("carr_tdesc"),"","","L"
		contado=contador+1
	end if
wend

'----------------------------------------Escala de Evalucacion--------------------------------

pdf.ln(15)
pdf.SetX(9)
pdf.Cell 147,5,"_________________________________________________________________________________________________","","C",""
pdf.ln(4)
alto = pdf.GetY()
pdf.SetX(10)
pdf.SetFont "Arial","B",10
pdf.Cell 50,5,"Escala de Evaluacion:","LR","","C"
pdf.SetX(70)
pdf.Cell 40,5,"Máximo de Asignaturas a Cursar:","","","C"
pdf.SetFont "Arial","B",10
pdf.SetX(120)
pdf.Cell 80,5,"Test Idioma Requerido:","LR","","C"
y0 = pdf.GetY()
pdf.SetX(9)
pdf.Cell 147,5,"_________________________________________________________________________________________________","","C",""
pdf.ln(4)

pdf.ln(8)
pdf.SetY(y0+5)
pdf.SetX(10)
x1 = pdf.GetX()
pdf.SetFont "Arial","",10
pdf.MultiCell 50,5,f_datos_convenio.obtenervalor("daco_tescala_avalu"),"LR","L",""
y1 = pdf.GetY()
pdf.SetY(y0+5)
pdf.SetFont "Arial","",10
pdf.SetX(60)
x2 = pdf.GetX()
pdf.MultiCell 40,5,f_datos_convenio.obtenervalor("daco_tramos_cursar"),"","L",""
y2 = pdf.GetY()
pdf.SetFont "Arial","",10
pdf.SetY(y0+5)
pdf.SetX(120)
x3 = pdf.GetX()
pdf.MultiCell 80,5,f_datos_convenio.obtenervalor("daco_ttest_idioma"),"LR","","L"
pdf.SetX(200)
x4 = pdf.GetX()
y3 = pdf.GetY()

if y1 > y2  then
	if y1 > y3  then
		pdf.SetY(y1-4)
		pdf.SetX(9)
		pdf.Cell 150,5,"_________________________________________________________________________________________________","","C",""
		alto2 = pdf.GetY()
	else
	pdf.SetY(y3-4)
	pdf.SetX(9)
	pdf.Cell 150,5,"_________________________________________________________________________________________________","","C",""
	alto2 = pdf.GetY()
	end if
else
pdf.SetY(y2-4)
pdf.SetX(9)
pdf.Cell 150,5,"_________________________________________________________________________________________________","","C",""
alto2 = pdf.GetY()	
end if 

' margen, altura margen altura
pdf.Line x1,alto,x1,alto2+4.5
pdf.Line x2,alto,x2,alto2+4.5
pdf.Line x3,alto,x3,alto2+4.5
pdf.Line x4,alto,x4,alto2+4.5
'-------------------------------------fechas 1 y 2 semestre------------------------------------------

pdf.ln(15)
pdf.SetX(47)
pdf.Cell 130,5,"_________________________________________________________","","C",""
pdf.ln(4)
pdf.SetX(48)
pdf.SetFont "Arial","B",10
pdf.Cell 50,5,"Fecha Limite Postulación:","LR","","C"
pdf.Cell 30,5,"Inicio Clases:","LR","","C"
pdf.SetFont "Arial","B",10
pdf.Cell 31,5,"Termino Clases:","LR","","C"
pdf.SetX(9)
pdf.Cell 148,6.5,"____________________________________________________________________________","","C",""

pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.SetX(9)
pdf.Cell 149,5,"____________________________________________________________________________","","C",""
pdf.SetX(10)
pdf.Cell 38,5,"1° Semestre","LR","","L"
pdf.SetFont "Arial","",10
pdf.SetX(48)
pdf.Cell 50,5,f_datos_convenio.obtenervalor("daco_flimite_pos_sem1_upa"),"LR","","L"
pdf.SetFont "Arial","",10
pdf.Cell 30,5,f_datos_convenio.obtenervalor("daco_fini_clase_sem1"),"LR","","L"
pdf.SetFont "Arial","",10
pdf.Cell 31,5,f_datos_convenio.obtenervalor("daco_ffin_clase_sem1"),"LR","","L"

pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.SetX(9)
pdf.Cell 149,5,"____________________________________________________________________________","","C",""
pdf.SetX(10)
pdf.Cell 38,4,"2° Semestre","LR","","L"
pdf.SetFont "Arial","",10
pdf.SetX(48)
pdf.Cell 50,4,f_datos_convenio.obtenervalor("daco_flimite_pos_sem2_upa"),"LR","","L"
pdf.SetFont "Arial","",10
pdf.Cell 30,4,f_datos_convenio.obtenervalor("daco_fini_clase_sem2"),"LR","","L"
pdf.SetFont "Arial","",10
pdf.Cell 31,4,f_datos_convenio.obtenervalor("daco_ffin_clase_sem2"),"R","","L"

'---------------------------------------------------costos de vida -------------------------------------------
pdf.ln(20)
pdf.SetX(70)
pdf.SetFont "Arial","B",10
pdf.Cell 57,1,"COSTO VIDA","","","L"
pdf.SetX(69)
pdf.Cell 30,5,"_________________________________________","","C",""
pdf.ln(4)

while f_costo.siguiente

pdf.SetFont "Arial","B",10
pdf.SetX(69)
pdf.Cell 30,5,"_________________________________________","","C",""
pdf.SetX(70)
pdf.Cell 30,4.5,f_costo.obtenervalor("tcvi_tdesc")&":","LR","","L"
pdf.SetFont "Arial","",10
pdf.MultiCell 50,4.5,f_costo.obtenervalor("covi_monto"),"LR","L",""
pdf.SetFont "Arial","B",10

wend 






pdf.Close()
pdf.Output()
%> 
