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
 q_pers_nrut=request.QueryString("pers_nrut")
 'q_pers_nrut=9980210
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

					s_progra="select (select soft_tdesc from software where soft_ncorr=cdpa_tprograma )as cdpa_tprograma,nidi_tdesc from curriculum_dominio_programa_alumno a, NIVELES_IDIOMA b where a.nidi_ccod=b.nidi_ccod and pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") "
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
  
  trabaja=conexion.consultaUno("select case count(*) when 0 then 'No' else 'Si' end "& vbCrLf &_
			"from direccion_laboral_profesionales a,experiencia_alumno b "& vbCrLf &_
			"where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod in(1,3) and a.pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") ")
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

 
 
 
 ss_academico="select pers_ncorr,carr_ccod,carr_tdesc,emat_ccod,facu_tdesc,sede_ccod,anio_ingreso,ultimo_anio from(select pers_ncorr, "& vbCrLf &_
"c.carr_ccod,"& vbCrLf &_
"carr_tdesc ,"& vbCrLf &_
" emat_ccod,facu_tdesc,sede_ccod,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso ,"& vbCrLf &_
" protic.obtener_ultimo_anio_carrera(c.carr_ccod,a.pers_ncorr)as ultimo_anio"& vbCrLf &_
"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f" & vbCrLf &_
"where a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
"and b.espe_ccod=c.espe_ccod "& vbCrLf &_
"and c.carr_ccod=d.carr_ccod "& vbCrLf &_
"and d.area_ccod=e.area_ccod"& vbCrLf &_
"and e.facu_ccod=f.facu_ccod "& vbCrLf &_
"and matr_ncorr in (select matr_ncorr from alumnos a, ofertas_academicas b,especialidades c where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod =1 and b.espe_ccod=c.espe_ccod and a.ofer_ncorr=b.ofer_ncorr group by carr_ccod,matr_ncorr )"& vbCrLf &_
"and c.carr_ccod not in (select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod in (4,8) and b.espe_ccod=c.espe_ccod and a.ofer_ncorr=b.ofer_ncorr group by carr_ccod,matr_ncorr)"& vbCrLf &_
"and c.carr_ccod not in (select carr_ccod from alumnos a, ofertas_academicas b,especialidades c"& vbCrLf &_
"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_
"and b.espe_ccod=c.espe_ccod"& vbCrLf &_
"and a.pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")"& vbCrLf &_
"and emat_ccod=6)"& vbCrLf &_
"group by c.carr_ccod,d.carr_tdesc,a.pers_ncorr,f.facu_tdesc,b.sede_ccod,pers_ncorr,a.emat_ccod"& vbCrLf &_
"union"& vbCrLf &_
"select pers_ncorr,"& vbCrLf &_ 
"c.carr_ccod,"& vbCrLf &_
"carr_tdesc ,"& vbCrLf &_
 "emat_ccod,facu_tdesc,sede_ccod,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso ,"& vbCrLf &_
 "protic.obtener_ultimo_anio_carrera(c.carr_ccod,a.pers_ncorr)as ultimo_anio"& vbCrLf &_
"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f"& vbCrLf &_ 
"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_ 
"and b.espe_ccod=c.espe_ccod "& vbCrLf &_
"and c.carr_ccod=d.carr_ccod "& vbCrLf &_
"and d.area_ccod=e.area_ccod "& vbCrLf &_
"and e.facu_ccod=f.facu_ccod"& vbCrLf &_ 
"and matr_ncorr in (select matr_ncorr from alumnos a, ofertas_academicas b,especialidades c where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod  in (8) and b.espe_ccod=c.espe_ccod and a.ofer_ncorr=b.ofer_ncorr group by carr_ccod,matr_ncorr )"& vbCrLf &_
"group by c.carr_ccod,d.carr_tdesc,a.pers_ncorr,f.facu_tdesc,b.sede_ccod,pers_ncorr,a.emat_ccod"& vbCrLf &_
"union"& vbCrLf &_
"select pers_ncorr, "& vbCrLf &_
"c.carr_ccod,"& vbCrLf &_
"carr_tdesc ,"& vbCrLf &_
" emat_ccod,facu_tdesc,sede_ccod,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso ,"& vbCrLf &_
"protic.obtener_ultimo_anio_carrera(c.carr_ccod,a.pers_ncorr)as ultimo_anio"& vbCrLf &_
"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f"& vbCrLf &_ 
"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_ 
"and b.espe_ccod=c.espe_ccod "& vbCrLf &_
"and c.carr_ccod=d.carr_ccod "& vbCrLf &_
"and d.area_ccod=e.area_ccod "& vbCrLf &_
"and e.facu_ccod=f.facu_ccod "& vbCrLf &_
"and matr_ncorr in (select matr_ncorr from alumnos a, ofertas_academicas b,especialidades c where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod  in (4) and b.espe_ccod=c.espe_ccod and a.ofer_ncorr=b.ofer_ncorr group by carr_ccod,matr_ncorr )"& vbCrLf &_
"and c.carr_ccod not in (select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")and emat_ccod  in (8) and b.espe_ccod=c.espe_ccod and a.ofer_ncorr=b.ofer_ncorr group by carr_ccod,matr_ncorr )"& vbCrLf &_
"group by c.carr_ccod,d.carr_tdesc,a.pers_ncorr,f.facu_tdesc,b.sede_ccod,pers_ncorr,a.emat_ccod)aaaa"& vbCrLf &_
"order by anio_ingreso"
 
 
 

 
 
 
   
 f_academico.Consultar ss_academico
' while f_academico.Siguiente
'  aaaaa=f_academico.ObtenerValor("anio_ingreso")
'  response.Write("<br/>"&aaaaa)
'  wend
  'response.Write("<br/>"&ss_academico)
'  response.Write("<br/>"&aaaaa)
  'response.end() 
  
   
   
  
   carrera=""
     
 '------------------------------------------------obtengo las habiidades del alumnmo

  set f_habilidades = new CFormulario
 f_habilidades.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_habilidades.Inicializar conexion

					s_habilidades="select upper(chal_tarea_trabajo)as chal_tarea_trabajo,upper(chal_thabilidades_tecnica) as chal_thabilidades_tecnica,upper(chal_thabilidades_personales)as chal_thabilidades_personales,upper(chal_thabilidades_profesionales)as chal_thabilidades_profesionales from curriculum_habilidades_alumno a where  pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") "
					
					 

numero_habilidades=conexion.consultaUno("select count(*) from curriculum_habilidades_alumno a where  pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")")
  f_habilidades.Consultar s_habilidades
   f_habilidades.Siguiente
 'response.Write("<br/>"&s_habilidades)
 'response.end()
 '-----------------------------------------------------------
 '-----------------------------------------------------------formacion extra académica
   set f_formacion_extra = new CFormulario
 f_formacion_extra.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_formacion_extra.Inicializar conexion
 
 s_formacion_estra="select cscu_tnombre,cscu_tinstitucion,cscu_ano from curso_seminario_curriculum where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")"
 
 tiene_curso=conexion.consultaUno("select count(*)  from curso_seminario_curriculum where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&")")
 
 f_formacion_extra.Consultar s_formacion_estra
 
 '---------------------------------------------------------------------------------------
 
 espacio="                                       "
 espacio2="    "
 espacio3="                                                                             "
 linea="__________________________________________________________________________________________________"
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","",10
pdf.Open()
pdf.SetAutoPageBreak(1)
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
pdf.Cell 0,1,""&linea&" ","","","C"
  pdf.ln(5)
pdf.SetFont "Arial","B",10  
pdf.Cell 200,1,"    EDUCACIÓN","","","L"
  pdf.ln(1)

pdf.Cell 0,1,""&linea&" ","","","C"
while f_academico.Siguiente
pdf.ln(2)
pdf.SetFont "Arial","",10


   sede_ccod=f_academico.ObtenerValor("sede_ccod")
   matriculas=f_academico.ObtenerValor("emat_ccod")
   if sede_ccod="1" or sede_ccod="2" or sede_ccod="5" or sede_ccod="6" or sede_ccod="8" then
   sede="SANTIAGO"
   end if
   
   if  sede_ccod="4"then
   sede="MELIPILLA"
   end if
   
   if sede_ccod="7" then
   sede="CONCEPCION"
   end if
   
   
   if matriculas="1" then
   matricula="ESTUDIANTE DE"
   end if
   
     if matriculas="4" then
   matricula="EGRESADO DE"
   end if
   
     if matriculas="8" then
   matricula="TITULADO DE"
   end if
pdf.cell 200,10,""&espacio2&""&f_academico.ObtenerValor("anio_ingreso")&" - "&f_academico.ObtenerValor("ultimo_anio")&"","","","L"
pdf.ln(2) 
pdf.cell 200,10,""&espacio&"UNIVERSIDAD DEL PACIFICO,"&sede&",CHILE ","","","L"
pdf.ln(5) 
pdf.SetFont "Arial","",10
pdf.cell 200,10,""&espacio&""&f_academico.ObtenerValor("facu_tdesc")&"","","","L"
pdf.ln(5) 
pdf.cell 200,10,""&espacio&""&matricula&" "&f_academico.ObtenerValor("carr_tdesc")&"","","","L"
pdf.ln(5)
wend
if cstr(tiene_curso)="1" then
  pdf.ln(5)
pdf.Cell 0,1,""&linea&" ","","","C"
  pdf.ln(5)
pdf.SetFont "Arial","B",10  
pdf.Cell 200,1,"    FORMACIÓN EXTRA-ACADÉMICA","","","L"
  pdf.ln(1)
pdf.Cell 0,1,""&linea&" ","","","C"
while f_formacion_extra.Siguiente
pdf.ln(2)
pdf.SetFont "Arial","",10
pdf.cell 200,10,"    "&espacio2&""&f_formacion_extra.ObtenerValor("cscu_ano")&"","","","L"
pdf.ln(2) 
pdf.cell 200,10,""&espacio&""&f_formacion_extra.ObtenerValor("cscu_tnombre")&",","","","L"
pdf.ln(5) 
pdf.cell 200,10,""&espacio&""&f_formacion_extra.ObtenerValor("cscu_tinstitucion")&"","","","L"
pdf.ln(5) 
wend
end if

if numero_habilidades<>0 then


pdf.Cell 0,1,""&linea&" ","","","C"
   pdf.ln(5)
   pdf.SetFont "Arial","B",10
pdf.Cell 200,1,"    HABILIDADES","","","L"
  pdf.ln(1)
  pdf.SetFont "Arial","",10
pdf.Cell 0,1,""&linea&" ","","","C"
pdf.ln(3)
pdf.SetFont "Arial","B",10
pdf.Cell 100,10,"PROFESIONALES","","0","D"
pdf.ln(6)
pdf.SetFont "Arial","",10
pdf.SetX(15)  
pdf.MultiCell 180,5,""&f_habilidades.ObtenerValor("chal_thabilidades_profesionales")&"","","0","D" 
pdf.ln(6)
pdf.SetFont "Arial","B",10
pdf.Cell 100,10,"TECNICAS","","0","D"
pdf.ln(6)
pdf.SetFont "Arial","",10
pdf.SetX(15)  
pdf.MultiCell 180,5,""&f_habilidades.ObtenerValor("chal_thabilidades_tecnica")&"","","0","D"  
pdf.ln(6)
pdf.SetFont "Arial","B",10
pdf.Cell 100,10,"PERSONALES","","0","D"
pdf.ln(6)
pdf.SetFont "Arial","",10
pdf.SetX(15)  
pdf.MultiCell 180,5,""&f_habilidades.ObtenerValor("chal_thabilidades_personales")&"","","0","D" 
pdf.ln(6)
pdf.SetFont "Arial","B",10
pdf.Cell 100,10,"AREAS DEDESARROLLO","","0","D"
pdf.ln(6)
pdf.SetX(15) 
pdf.SetFont "Arial","",10
pdf.MultiCell 180,5,""&f_habilidades.ObtenerValor("chal_tarea_trabajo")&"","","0","D"  
 pdf.ln(6)

pdf.AddPage()
pdf.Image "../pruebapdf/upacificologopdf.jpg", 25, 20, 50, 20, "JPG"
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)

end if
  pdf.ln(5)
pdf.Cell 0,1,""&linea&" ","","","C"
  pdf.ln(5)
  pdf.SetFont "Arial","B",10
pdf.Cell 200,1,"    EXPERIENCIA LABORAL","","","L"
pdf.SetFont "Arial","",10
  pdf.ln(1)
pdf.Cell 0,1,""&linea&" ","","","C"


if trabaja="Si" then
while f_trabajo_actual.siguiente
pdf.ln(5)
pdf.cell 200,10,""&espacio2&""&f_trabajo_actual.ObtenerValor("t_fecha_ini")&" - "&f_trabajo_actual.ObtenerValor("t_fecha_fin")&"","","","L"
 pdf.ln(5) 
pdf.cell 200,10,""&espacio&"LUGAR: "&f_trabajo_actual.ObtenerValor("dlpr_nombre_empresa")&"","","","L"
 
 pdf.ln(5) 
pdf.cell 200,10,""&espacio&"CARGO: "&f_trabajo_actual.ObtenerValor("dlpr_cargo_empresa")&" ","","","L"
pdf.ln(5)


if f_trabajo_actual.ObtenerValor("tiea_ccod")="3" then
pdf.cell 200,10,""&espacio&"PRÁCTICA LABORAL","","","L"
pdf.ln(5)
end if
wend
else
pdf.ln(2)
pdf.SetX(48)
pdf.cell 200,10,"SIN EXPERIENCIA","","","L"
 pdf.ln(5) 
end if



pdf.ln(5)
pdf.Cell 0,1,""&linea&" ","","","C" 
pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 200,1,"    INFORMACIÓN ADICIONAL","","","L"
pdf.SetFont "Arial","",10
pdf.ln(1)
pdf.Cell 0,1,""&linea&" ","","","C"


pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 200,0,""&espacio&"NACIONALIDAD:","","","L"
pdf.SetX(77)
pdf.SetFont "Arial","",10
pdf.Cell 200,0,""&f_datos_antecedentes.ObtenerValor("nacionalidad")&" ","","","L"

pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 200,0,""&espacio&"FECHA DE NACIMIENTO:","","","L"
pdf.SetX(92)
pdf.SetFont "Arial","",10
pdf.Cell 200,0,""&f_datos_antecedentes.ObtenerValor("fnacimiento")&" ","","","L"

pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 200,1,""&espacio&"RUT:","","","L"
pdf.SetX(57)
 pdf.SetFont "Arial","",10
pdf.Cell 200,1,""&f_datos_antecedentes.ObtenerValor("rut")&" ","","","L"


if numero_programa <>0 then
 pdf.ln(5)
 pdf.SetFont "Arial","B",10
pdf.Cell 200,0,""&espacio&"MANEJO DE SOFTWARE:  ","","","L"
pdf.SetFont "Arial","",10
n1=0
while f_programa.siguiente
 n1=n1+1
 if n1=1 then
 else
 pdf.ln(5)
 end if 
 pdf.SetX(93)
pdf.cell 200,0,""&f_programa.ObtenerValor("cdpa_tprograma")&" NIVEL "&f_programa.ObtenerValor("nidi_tdesc")&""
wend

end if

if numero_idiomas <>0 then
pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 200,0,""&espacio&"IDIOMA:  ","","","L"
pdf.SetFont "Arial","",10
n2=0
while f_idioma.siguiente
n2=n2+1
if n2=1 then
'pdf.ln(0) 
else
pdf.ln(5) 
end if
pdf.SetX(65) 
pdf.cell 200,0,""&f_idioma.ObtenerValor("idio_tdesc")&" NIVEL "&f_idioma.ObtenerValor("nidi_tdesc")&""
wend
  
  end if
pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 200,0,""&espacio&"ESTADO CIVIL: ","","","L"
pdf.SetX(75)
pdf.SetFont "Arial","",10
pdf.Cell 200,0,""&f_datos_antecedentes.ObtenerValor("estado_civil")&" ","","","L"
pdf.Close()
pdf.Output()
%> 
