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
 'q_pers_nrut=16212689
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
 

 '---------------------------------------------obtengo los datos de idioma
 set f_idioma = new CFormulario
 f_idioma.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_idioma.Inicializar conexion

					s_idioma="select  idal_ncorr,a.idio_ccod,idal_habla,idal_lee,idal_escribe,a.nidi_ccod,nidi_tdesc,case when a.idio_ccod=8 then idal_otro " & vbCrLf &_
					"else idio_tdesc end as idio_tdesc "& vbCrLf &_
					"from idioma_alumno a,niveles_idioma b,idioma c"& vbCrLf &_
					"where  a.nidi_ccod=b.nidi_ccod and a.idio_ccod=c.idio_ccod and pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") "

numero_idiomas=conexion.consultaUno("select count(*) from idioma_alumno a,niveles_idioma b,idioma c where  a.nidi_ccod=b.nidi_ccod and a.idio_ccod=c.idio_ccod and pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")")
  f_idioma.Consultar s_idioma


'---------------------------------------------obtengo los datos del los programas
 
  set f_programa = new CFormulario
 f_programa.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_programa.Inicializar conexion

					s_progra="select cdpa_tprograma,nidi_tdesc from curriculum_dominio_programa_alumno a, NIVELES_IDIOMA b where a.nidi_ccod=b.nidi_ccod and pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") "
numero_programa=conexion.consultaUno("select count(*) from curriculum_dominio_programa_alumno a, NIVELES_IDIOMA b where a.nidi_ccod=b.nidi_ccod and pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") ")
  f_programa.Consultar s_progra
  
'   response.Write(s_progra)
' response.end()
 
 tfijo=f_datos_antecedentes.ObtenerValor("dire_tfono")
 correo=f_datos_antecedentes.ObtenerValor("pers_temail")
 celu=f_datos_antecedentes.ObtenerValor("pers_tcelular")
 
 
 
 if cstr(tfijo)="" and cstr(celu) <>"" then
 telefonos=celu
 end if
  if cstr(tfijo)<>"" and cstr(celu) ="" then
  telefonos=tfijo
 end if
  if cstr(tfijo)<>"" and cstr(celu) <>"" then
  telefonos=""&tfijo&"/"&celu&""
 end if
 
  
 
 
 '---------------------------------------------obtengo los datos de los trabajos
 set f_trabajo_actual = new CFormulario
 f_trabajo_actual.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_trabajo_actual.Inicializar conexion
 
 s_trabajo="select top 3 dlpr_nombre_empresa,tiea_ccod,dlpr_cargo_empresa,"& vbCrLf &_
"upper(protic.obtener_mes_anio_curriculum(exal_fini)) as t_fecha_ini  "& vbCrLf &_
",upper(protic.obtener_mes_anio_curriculum(exal_ffin)) as t_fecha_fin "& vbCrLf &_
			"from direccion_laboral_profesionales a,experiencia_alumno b "& vbCrLf &_
			"where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod in(1,3) and a.pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") order  by exal_fini desc"
  f_trabajo_actual.Consultar s_trabajo
   'response.Write("<br/>"&s_trabajo)
   'response.end()
   anio_ini=f_trabajo_actual.ObtenerValor("anio_ini")
   mes_ini=f_trabajo_actual.ObtenerValor("t_mes_fin")
   practica=f_trabajo_actual.ObtenerValor("tiea_ccod")
   
   
   
   
   '---------------------------------------------obtengo los datos academicos
   
   set f_academico = new CFormulario
 f_academico.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_academico.Inicializar conexion
 
 
 s_academico="select  pers_ncorr, c.carr_ccod,carr_tdesc , emat_ccod,facu_tdesc,sede_ccod,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso"& vbCrLf &_
 ",(select top 1 anos_ccod from alumnos a,postulantes b,periodos_academicos c where a.pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod in (1,4,8)and a.pers_ncorr=b.pers_ncorr and b.peri_ccod=c.peri_ccod order by b.peri_ccod desc)as ultimo_ano"& vbCrLf &_
"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f"& vbCrLf &_
"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_
"and b.espe_ccod=c.espe_ccod"& vbCrLf &_
"and c.carr_ccod=d.carr_ccod"& vbCrLf &_
"and d.area_ccod=e.area_ccod"& vbCrLf &_
"and e.facu_ccod=f.facu_ccod"& vbCrLf &_
"and matr_ncorr in (select top 1 matr_ncorr from alumnos where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod in (1,4,8) order by emat_ccod desc)"
   
 f_academico.Consultar s_academico
 f_academico.Siguiente
  'response.Write("<br/>"&s_academico)
  'response.end() 
   
   facultad=f_academico.ObtenerValor("facu_tdesc")
   sede_ccod=f_academico.ObtenerValor("sede_ccod")
   matricula=f_academico.ObtenerValor("emat_ccod")
   if sede_ccod="1" or sede_ccod="2" or sede_ccod="5" or sede_ccod="6" or sede_ccod="8" then
   sede="SANTIAGO"
   end if
   
   if  sede_ccod="4"then
   sede="MELIPILLA"
   end if
   
   if sede_ccod="7" then
   sede="CONCEPCION"
   end if
   
   
   if matricula="1" then
   matricula="ESTUDIANTE DE"
   end if
   
     if matricula="4" then
   matricula="EGRESADO DE"
   end if
   
     if matricula="8" then
   matricula="TITULADO DE"
   end if
   
   carrera=""   
 
 espacio="                                       "
 espacio2="    "
 linea="__________________________________________________________________________________________________"
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","",10
pdf.Open()
pdf.AddPage()
pdf.Image "../pruebapdf/upacificologopdf.jpg", 25, 20, 50, 20, "JPG"
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.Cell 200,1,""&f_datos_antecedentes.ObtenerValor("nombre")&"","","","C"  
pdf.ln(5)
pdf.Cell 200,1,""&f_datos_antecedentes.ObtenerValor("direccion")&", "&f_datos_antecedentes.ObtenerValor("comuna")&",","","","C" 
pdf.ln(5)
pdf.Cell 200,1,""&f_datos_antecedentes.ObtenerValor("ciudad")&", CHILE","","","C" 
 if cstr(tfijo)="" and cstr(celu) ="" then

else
  pdf.ln(5)
pdf.Cell 200,1,"TEL. "&telefonos&" ","","","C"
 end if
 
 if cstr(correo)<>"" then
   pdf.ln(5)
pdf.Cell 200,1,"E-MAIL: "&correo&" ","","","C"
end if
  pdf.ln(5)
pdf.Cell 200,1,""&linea&" ","","","C"
  pdf.ln(5)
pdf.Cell 200,1,"    EDUCACI�N","","","L"
  pdf.ln(1)
pdf.Cell 200,1,""&linea&" ","","","C"
pdf.ln(2)
pdf.cell 200,10,""&espacio2&""&f_academico.ObtenerValor("anio_ingreso")&" - "&f_academico.ObtenerValor("ultimo_ano")&"","","","L"
pdf.ln(2) 
pdf.cell 200,10,""&espacio&"UNIVERSIDAD DEL PACIFICO,"&sede&",CHILE ","","","L"
pdf.ln(5) 
pdf.cell 200,10,""&espacio&""&facultad&"","","","L"
pdf.ln(5) 
pdf.cell 200,10,""&espacio&""&matricula&" "&f_academico.ObtenerValor("carr_tdesc")&"","","","L"
  pdf.ln(5)
pdf.Cell 200,1,""&linea&" ","","","C"

'  pdf.ln(5)
'pdf.Cell 200,1,""&linea&" ","","","C"
'   pdf.ln(5)
'pdf.Cell 200,1,"    METAS PROFESIONALES","","","L"
'  pdf.ln(1)
'pdf.Cell 200,1,""&linea&" ","","","C"
'
' 
' pdf.ln(5)
'pdf.Cell 200,1,""&linea&" ","","","C" 

  pdf.ln(5)
pdf.Cell 200,1,"    EXPERIENCIA LABORAL","","","L"
  pdf.ln(1)
pdf.Cell 200,1,""&linea&" ","","","C"

while f_trabajo_actual.siguiente
pdf.ln(5)
pdf.cell 200,10,""&espacio2&""&f_trabajo_actual.ObtenerValor("t_fecha_ini")&" - "&f_trabajo_actual.ObtenerValor("t_fecha_fin")&"","","","L"
 pdf.ln(5) 
pdf.cell 200,10,""&espacio&"LUGAR: "&f_trabajo_actual.ObtenerValor("dlpr_nombre_empresa")&"","","","L"
 
 pdf.ln(5) 
pdf.cell 200,10,""&espacio&"CARGO: "&f_trabajo_actual.ObtenerValor("dlpr_cargo_empresa")&" ","","","L"
if f_trabajo_actual.ObtenerValor("tiea_ccod")="3" then
 pdf.ln(5) 
pdf.cell 200,10,""&espacio&"PR�CTICA LABORAL","","","L"
end if
wend



pdf.ln(5)
pdf.Cell 200,1,""&linea&" ","","","C" 
  pdf.ln(5)
pdf.Cell 200,1,"    INFORMACI�N ADICIONAL","","","L"
  pdf.ln(1)
pdf.Cell 200,1,""&linea&" ","","","C"


  pdf.ln(10)
pdf.Cell 200,1,""&espacio&"NACIONALIDAD: "&f_datos_antecedentes.ObtenerValor("nacionalidad")&" ","","","L"
  pdf.ln(5)
pdf.Cell 200,1,""&espacio&"FECHA DE NACIMIENTO: "&f_datos_antecedentes.ObtenerValor("fnacimiento")&" ","","","L"
  pdf.ln(5)
pdf.Cell 200,1,""&espacio&"RUT: "&f_datos_antecedentes.ObtenerValor("rut")&" ","","","L"

if numero_programa <>0 then
 pdf.ln(5)
pdf.Cell 200,1,""&espacio&"MANEJO DE SOFTWARE:  ","","","L"
while f_programa.siguiente
 pdf.ln(5) 
pdf.cell 42,10,""&espacio&"                           -"&f_programa.ObtenerValor("cdpa_tprograma")&" NIVEL "&f_programa.ObtenerValor("nidi_tdesc")&""
wend
end if

if numero_idiomas <>0 then

 pdf.ln(10)
pdf.Cell 200,1,""&espacio&"IDIOMA:  ","","","L"
while f_idioma.siguiente
 pdf.ln(5) 
pdf.cell 42,10,""&espacio&"                           -"&f_idioma.ObtenerValor("idio_tdesc")&" NIVEL "&f_idioma.ObtenerValor("nidi_tdesc")&""
wend

  pdf.ln(10)
  else
   pdf.ln(5)
  end if
pdf.Cell 200,1,""&espacio&"ESTADO CIVIL: "&f_datos_antecedentes.ObtenerValor("estado_civil")&" ","","","L"

pdf.Close()
pdf.Output()
%> 
