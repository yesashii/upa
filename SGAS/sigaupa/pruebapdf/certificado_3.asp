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
 'q_pers_nrut=16365740
 q_pers_nrut=16608757

 'q_pers_nrut=17131451
 'q_pers_nrut=9968176
 '---------------------------------------------obtengo los datos del alumno
 set f_datos_antecedentes = new CFormulario
 f_datos_antecedentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_datos_antecedentes.Inicializar conexion

					
				 selec_antecedentes=	"select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
				 	"cast(pers_nrut as varchar)+'-'+pers_xdv as rut,"& vbCrLf &_
					"upper(protic.obtener_f_nacimiento_escrita(pers_nrut))as fnacimiento,"& vbCrLf &_
					"pers_temail,"& vbCrLf &_
					"pers_temail2,pers_tcelular,"& vbCrLf &_
					"(select upper(dire_tcalle)+' '+dire_tnro from direcciones where pers_ncorr=a.pers_ncorr and tdir_ccod=1)as direccion,(select ciud_tdesc from ciudades cc where cc.ciud_ccod=c.ciud_ccod)as comuna ,"& vbCrLf &_
					"(select sexo_tdesc from sexos bb where a.sexo_ccod=bb.sexo_ccod )as sexo,"& vbCrLf &_
					"(select eciv_tdesc from estados_civiles aa where a.eciv_ccod=aa.eciv_ccod)as estado_civil,"& vbCrLf &_
					"(select pais_tnacionalidad from paises aa where aa.pais_ccod=a.pais_ccod)as nacionalidad,"& vbCrLf &_
					"dire_tfono,"& vbCrLf &_
					"(select ciud_tcomuna from ciudades cc where cc.ciud_ccod=c.ciud_ccod)as ciudad"& vbCrLf &_
					"from personas a, direcciones b,ciudades c "& vbCrLf &_
					"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
					"and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
					"and pers_nrut="&q_pers_nrut&""& vbCrLf &_
					"and tdir_ccod in (1)"
 f_datos_antecedentes.Consultar selec_antecedentes
 f_datos_antecedentes.Siguiente
 


 
   
   
   
   '---------------------------------------------obtengo los datos academicos
   
   set f_academico = new CFormulario
 f_academico.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_academico.Inicializar conexion
 
 
 s_academico="select  pers_ncorr, c.carr_ccod,carr_tdesc , emat_ccod,facu_tdesc,b.sede_ccod,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso"& vbCrLf &_
",(select top 1 anos_ccod from alumnos a,postulantes b,periodos_academicos c where a.pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod in (1,4,8)and a.pers_ncorr=b.pers_ncorr and b.peri_ccod=c.peri_ccod order by b.peri_ccod desc)as ultimo_ano"& vbCrLf &_
",cast(ARAN_MMATRICULA as numeric(18,0))as ARAN_MMATRICULA,cast(ARAN_MCOLEGIATURA as numeric(18,0))as ARAN_MCOLEGIATURA"& vbCrLf &_
"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f,aranceles g"& vbCrLf &_
"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_
"and b.espe_ccod=c.espe_ccod"& vbCrLf &_
"and c.carr_ccod=d.carr_ccod"& vbCrLf &_
"and d.area_ccod=e.area_ccod"& vbCrLf &_
"and e.facu_ccod=f.facu_ccod"& vbCrLf &_
"and b.ofer_ncorr=g.ofer_ncorr"& vbCrLf &_
"and b.aran_ncorr=g.aran_ncorr"& vbCrLf &_
"and matr_ncorr in (select top 1 matr_ncorr from alumnos where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod in (1) order by emat_ccod desc)"
   
 f_academico.Consultar s_academico
 f_academico.Siguiente
  'response.Write("<br/>"&s_academico)
 ' response.end() 
 
 espacio="                                       "
 espacio2="    "
 linea="________________________________________________________________________________________________"
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","",10
pdf.Open()
pdf.AddPage()
pdf.Image "../pruebapdf/upacificologopdf.jpg", 25, 20, 50, 20, "JPG"
	pdf.ln(45)
pdf.Cell 42,1,"                                                       " 
	pdf.ln(20)
pdf.SetFont "Arial","BU",10
	pdf.ln(5)
pdf.Cell 180,1,"CERTIFICADO SIMPLE","","","C" 
pdf.SetFont "Arial","",10
	pdf.ln(13)
	
pdf.Cell 180,1,"Santiago, 09 de Marzo de 2009","","","R" 
pdf.SetFont "Arial","",10
	pdf.ln(13)
pdf.MultiCell 190,5,"Gonzalo Hernández Pérez, Director de Finanzas de la Universidad del Pacífico, certifica que el(la) alumno(a) señor(ita) "&f_datos_antecedentes.ObtenerValor("nombre")&", Rut N°"&f_datos_antecedentes.ObtenerValor("rut")&", postuló a la carrera de Diseño de Interiores y Exteriores (D), que imparte la Institución en Sede Las Condes, siendo aceptada.","","J",""
	pdf.ln(6)
pdf.MultiCell 190,5,"De acuerdo a la malla curricular, debiera restarle UN AÑO Y MEDIO para egresar de la carrera.","","J",""
	pdf.ln(6)
pdf.MultiCell 190,5,"El(los) valor(es) de matrícula y arancel que el(la) alumno(a) deberá pagar/documentar para tener la calidad de alumno regular de la Institución, correspondiente al período académico 2009, segundo semestre, es el siguiente:","","J",""
pdf.ln(6)
pdf.Cell 180,1,"      Matrícula	   $265.000.-","","","L"
pdf.ln(3)
pdf.Cell 180,1,"      Arancel		      $1.381.600.-","","","L"
pdf.ln(6)
pdf.MultiCell 190,5,"En caso que dicha suma sea financiada total o parcialmente con un crédito bancario, el monto respectivo deberá ser girado en documento a nombre de:  UNIVERSIDAD DEL PACÍFICO, RUT:  71.704.700-1.","","J",""
pdf.ln(6)
pdf.MultiCell 190,5,"Se otorga el presente certificado a petición del interesado para los fines que estime pertinente, sin responsabilidad ulterior para la Universidad del Pacífico.","","J",""
pdf.ln(21)
pdf.MultiCell 180,5,"___________________________","","L",""
pdf.ln(1)
pdf.MultiCell 180,5,"     Firma y Timbre Institución","","L",""

pdf.Close()
pdf.Output()
%> 
