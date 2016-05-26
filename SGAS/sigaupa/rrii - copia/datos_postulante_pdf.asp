<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion
q_pers_nrut=Request.QueryString("b[0][pers_nrut]")
q_pers_xdv=Request.QueryString("b[0][pers_xdv]")
q_peri_ccod=Request.QueryString("b[0][peri_ccod]")
q_carr_ccod=Request.QueryString("b[0][carr_ccod]")

'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
 'q_pers_nrut=16355200
 'q_pers_nrut=14539813
 'q_pers_nrut=16661775
 'q_pers_nrut=16365740
 'q_pers_nrut=16608757
 'q_pers_nrut=16212689
 'q_pers_nrut=17131451
 'q_pers_nrut=9968176
 'q_pers_nrut=16291582
 '---------------------------------------------obtengo los datos del alumno
 set f_datos_antecedentes = new CFormulario
 f_datos_antecedentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_datos_antecedentes.Inicializar conexion

					
					selec_antecedentes="select top 1 pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,carr_tdesc,emat_tdesc,case when protic.ES_MOROSO (a.pers_ncorr,getdate())= 'S' then 'SI' else 'NO' end as es_moroso, protic.trunc(getdate())as hoy "& vbCrLf &_
					",case alum_nmatricula when 7777  then 'Matricula de Ajuste' end as mensaje,alum_nmatricula "& vbCrLf &_
					"from personas a,"& vbCrLf &_
					"alumnos b,"& vbCrLf &_
					"ofertas_academicas c,"& vbCrLf &_
					"especialidades d,"& vbCrLf &_
					"estados_matriculas e,"& vbCrLf &_
					"carreras f"& vbCrLf &_
					"where a.PERS_NCORR=b.PERS_NCORR"& vbCrLf &_
					"and b.OFER_NCORR=c.OFER_NCORR"& vbCrLf &_
					"and c.ESPE_CCOD=d.ESPE_CCOD"& vbCrLf &_
					"and b.EMAT_CCOD=e.EMAT_CCOD"& vbCrLf &_
					"and d.CARR_CCOD=f.CARR_CCOD"& vbCrLf &_
					"and d.CARR_CCOD="&q_carr_ccod&""& vbCrLf &_
					"and c.PERI_CCOD="&q_peri_ccod&""& vbCrLf &_
					"and a.pers_nrut="&q_pers_nrut&""& vbCrLf &_
					"order by matr_ncorr desc"
					
					
 f_datos_antecedentes.Consultar selec_antecedentes
 f_datos_antecedentes.Siguiente
 

 
   carrera=""
     
 
 espacio="                                       "
 espacio2="    "
 espacio3="                                                                             "
 linea="__________________________________________________________________________________________________"
 
 '##################################################### INICIO PDF ########################################################################
Set pdf=CreateJsObject("FPDF")

pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",10
pdf.Open()
pdf.LoadModels("info_post") 
pdf.AddPage()

'---------------------------------------------------nombre universidad-------------------------------------
pdf.Cell 32,1,"Fecha de Emision:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 50,1,""&f_datos_antecedentes.obtenerValor("hoy")&"","","","L"

'------------------------------------------------pais y ciudad--------------------------------------
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 15,1,"Nombre:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 85,1,""&f_datos_antecedentes.obtenerValor("nombre")&"","","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 15,1,"Carrera:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 80,1,""&f_datos_antecedentes.obtenerValor("carr_tdesc")&"","","","L"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 35,1,"Estado de Matricula:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 65,1,""&f_datos_antecedentes.obtenerValor("emat_tdesc")&" "&f_datos_antecedentes.obtenerValor("mensaje")&"","","","L"
pdf.SetFont "Arial","B",10
pdf.Cell 15,1,"Moroso:","","","L"
pdf.SetFont "Arial","",10
pdf.Cell 80,1,""&f_datos_antecedentes.obtenerValor("es_moroso")&"","","","L"



pdf.Close()
pdf.Output()

%> 