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
 "protic.trunc(daco_flimite_pos_sem1)as daco_flimite_pos_sem1,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem1)as daco_fini_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem1)as daco_ffin_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2_upa)as daco_flimite_pos_sem2_upa,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2)as daco_flimite_pos_sem2,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem2)as daco_fini_clase_sem2,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem2)as daco_ffin_clase_sem2,"& vbCrLf &_
 "daco_ttest_idioma,"& vbCrLf &_
 "idio_tdesc,"& vbCrLf &_
 "daco_tescala_avalu,"& vbCrLf &_
 "daco_ncupo,"& vbCrLf &_
 "daco_tcomentario_cupo,"& vbCrLf &_
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


set f_contacto= new CFormulario
f_contacto.Carga_Parametros "tabla_vacia.xml", "tabla"
f_contacto.Inicializar conexion

sql_descuentos="select euco_tnombre,euco_tcargo,euco_temail,euco_tfono,euco_tfax,isnull(euco_direccion,'')as euco_direccion "& vbCrLf &_ 
"from encargado_universidad_convenio a"& vbCrLf &_
"where a.daco_ncorr="&daco_ncorr&""
f_contacto.Consultar sql_descuentos




Set pdf=CreateJsObject("FPDF")

pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",10
pdf.Open()
pdf.LoadModels("informe_encuesta") 
pdf.SetAutoPageBreak TRUE,20
pdf.AddPage()

'---------------------------------------------------nombre universidad-------------------------------------
pdf.Cell 40,1,"Nombre Universidad:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 140,1,f_datos_convenio.obtenervalor("univ_tdesc"),"","","L"

'------------------------------------------------pais y ciudad--------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 10,1,"Pais:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 80,1,f_datos_convenio.obtenervalor("pais_tdesc"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 15,1,"Ciudad:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 75,1,f_datos_convenio.obtenervalor("ciex_tdesc"),"","","L"

'----------------------------------------------pagina web--------------------------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 23,1,"Página Web:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 157,1,f_datos_convenio.obtenervalor("daco_tweb"),"","","L"

'----------------------------------------------cupo--------------------------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 11,1,"Cupo:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 173,1,f_datos_convenio.obtenervalor("daco_ncupo"),"","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 34,5,"Comentario Cupo:","","","L"
pdf.SetFont "Arial","",10
pdf.SetX(45)
pdf.MultiCell 134,5,f_datos_convenio.obtenervalor("daco_tcomentario_cupo"),"","L",""
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 34,5,"Escala de Evaluacion:","","","L"
pdf.SetFont "Arial","",10
pdf.SetX(48)
pdf.MultiCell 134,5,f_datos_convenio.obtenervalor("daco_tescala_avalu"),"","L",""
'pdf.Cell 157,1,f_datos_convenio.obtenervalor("daco_tcomentario_cupo"),"","","L"
'-------------------------------------------------------carreras upa en convenio-----------------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 48,1,"Carreras Upa en Convenio:","","","L"
pdf.SetFont "Arial","",10
contador=0
while f_carreras_convenio.siguiente
	
	if contado=0 then
		pdf.Cell 132,1,f_carreras_convenio.obtenervalor("carr_tdesc"),"","","L"
		contado=contador+1
	else
		pdf.ln(5)
		pdf.SetX(58)
		pdf.Cell 132,1,f_carreras_convenio.obtenervalor("carr_tdesc"),"","","L"
		contado=contador+1
	end if

wend
'----------------------------------------------asignaturas a cursar----------------------------------------------------------

pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 57,5,"Máximo de Asignaturas a Cursar:","","","L"
pdf.SetFont "Arial","",10
'pdf.Cell 123,1,f_datos_convenio.obtenervalor("daco_tramos_cursar"),"","","L"
pdf.MultiCell 123,5,f_datos_convenio.obtenervalor("daco_tramos_cursar"),"","L",""



'--------------------------------------------------fecha 1 semestre------------------------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 57,1,"1° Semestre","","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 54,1,"Fecha Limite Postulación UPA:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 19,1,f_datos_convenio.obtenervalor("daco_flimite_pos_sem1_upa"),"","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 45,1,"Fecha Limite Postulación:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 25,1,f_datos_convenio.obtenervalor("daco_flimite_pos_sem1"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 22,1,"Inicio Clases:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 25,1,f_datos_convenio.obtenervalor("daco_fini_clase_sem1"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 28,1,"Termino Clases:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 25,1,f_datos_convenio.obtenervalor("daco_ffin_clase_sem1"),"","","L"
'--------------------------------------------------------fecha 2 semestre------------------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 57,1,"2° Semestre","","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 54,1,"Fecha Limite Postulación UPA:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 19,1,f_datos_convenio.obtenervalor("daco_flimite_pos_sem2_upa"),"","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 45,1,"Fecha Limite Postulación:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 25,1,f_datos_convenio.obtenervalor("daco_flimite_pos_sem2"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 22,1,"Inicio Clases:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 25,1,f_datos_convenio.obtenervalor("daco_fini_clase_sem2"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 28,1,"Termino Clases:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 25,1,f_datos_convenio.obtenervalor("daco_ffin_clase_sem2"),"","","L"

'-------------------------------------------------------------idioma-----------
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 57,1,"IDIOMA","","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 32,1,"Idioma Requerido:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 29,1,f_datos_convenio.obtenervalor("idio_tdesc"),"","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 32,1,"Test Idioma Requerido:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 29,1,f_datos_convenio.obtenervalor("daco_ttest_idioma"),"","","L"

'---------------------------------------------------costos de vida -------------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 57,1,"COSTO VIDA","","","L"



while f_costo.siguiente
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 180,1,f_costo.obtenervalor("tcvi_tdesc")&":","","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 13,5,"Monto:","","","L"
pdf.SetFont "Arial","",10
pdf.MultiCell 65,5,f_costo.obtenervalor("covi_monto"),"","L",""
pdf.SetFont "Arial","B",10
pdf.Cell 25,5,"Comentario:","","","L"
pdf.SetFont "Arial","",10
pdf.MultiCell 82,5,f_costo.obtenervalor("covi_comentario"),"","L",""


wend 
'------------------------------------------------datos de contacto---------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 57,1,"Dato Contacto","","","L"

while f_contacto.siguiente
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 16,1,"Nombre:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 45,1,f_contacto.obtenervalor("euco_tnombre"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 14,1,"Cargo:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 50,1,f_contacto.obtenervalor("euco_tcargo"),"","","L"
pdf.ln(10)

pdf.SetFont "Arial","B",10
pdf.Cell 20,1,"Dirección:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 120,1,f_contacto.obtenervalor("euco_direccion"),"","","L"

pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 10,1,"Fono:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 51,1,f_contacto.obtenervalor("euco_tfono"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 8,1,"Fax:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 50,1,f_contacto.obtenervalor("euco_tfax"),"","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 12,1,"Email:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 50,1,f_contacto.obtenervalor("euco_temail"),"","","L"
wend





pdf.Close()
pdf.Output()
%> 
