<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


q_pers_ncorr= request.QueryString("pers_ncorr")
q_dcur_ncorr  = request.querystring("dcur_ncorr")
tcdo_ccod= request.QueryString("tcdo_ccod")

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion
 

 'tcdo_ccod=1
 'q_dcur_ncorr=106
 'q_pers_ncorr=123361
 
 'q_pers_ncorr=23669
 'q_pers_ncorr=23936
 'q_dcur_ncorr=105

 'response.end()
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_datos.Inicializar conexion

					consulta_datos="select * from(Select protic.obtener_nombre(a.pers_ncorr,'n') as nombre_docente," & vbCrLf &_
"protic.obtener_rut(a.pers_ncorr)as Rut_Docente,datepart(dd,getdate())as dia_actual,datepart(yyyy,getdate())as ano_actual,"& vbCrLf &_ 																			
"(select protic.trunc(pers_fnacimiento) from personas p where p.pers_ncorr=a.pers_ncorr)as fecha_nac,"& vbCrLf &_ 
"(select eciv_tdesc from personas f,estados_civiles e where f.pers_ncorr=a.pers_ncorr and f.eciv_ccod=e.eciv_ccod) as estado_civil," & vbCrLf &_
"(select ciud_tdesc+' / '+ciud_tcomuna  from direcciones f,ciudades h where f.pers_ncorr=a.pers_ncorr and f.ciud_ccod=h.ciud_ccod and tdir_ccod=1) as comuna,"& vbCrLf &_ 
 "(select top 1 cudo_titulo from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as profesion," & vbCrLf &_
"'docente'as TipoDocente,"& vbCrLf &_
"(select isnull(m.pais_tnacionalidad,'CHILENA') from personas p,paises m where p.pers_ncorr=a.pers_ncorr and p.PAIS_CCOD=m.PAIS_CCOD)as Nacionalidad," & vbCrLf &_
"protic.obtener_nombre_completo(l.pers_ncorr_representante,'n') as NombreRepLeg,inst_trazon_social,(select sede_tdesc from sedes s where sede_ccod=dg.sede_ccod)as sede_tdesc, "& vbCrLf &_
"(select case when DATEPART(mm, GETDATE()) = 1 then 'Enero' when DATEPART(mm, GETDATE()) = 2 then 'Febrero'  when DATEPART(mm, GETDATE()) = 3 then 'Marzo' when DATEPART(mm, GETDATE()) = 4 then 'Abril' when DATEPART(mm, GETDATE()) = 5 then 'Mayo' when DATEPART(mm, GETDATE()) = 6 then 'Junio'when DATEPART(mm, GETDATE()) = 7 then 'Julio'when DATEPART(mm, GETDATE()) = 8 then 'Agosto'when DATEPART(mm, GETDATE()) = 9 then 'Septiembre'when DATEPART(mm, GETDATE()) = 10 then 'Octubre'when DATEPART(mm, GETDATE()) = 11 then 'Noviembre'when DATEPART(mm, GETDATE()) = 12 then 'Diciembre'end) as mes,"& vbCrLf &_ 
"(select case when DATEPART(mm,anot_finicio) = 1 then 'Enero' when DATEPART(mm, anot_finicio) = 2 then 'Febrero'  when DATEPART(mm, anot_finicio) = 3 then 'Marzo' when DATEPART(mm,anot_finicio) = 4 then 'Abril' when DATEPART(mm,anot_finicio) = 5 then 'Mayo' when DATEPART(mm,anot_finicio) = 6 then 'Junio'when DATEPART(mm,anot_finicio) = 7 then 'Julio'when DATEPART(mm,anot_finicio) = 8 then 'Agosto'when DATEPART(mm,anot_finicio) = 9 then 'Septiembre'when DATEPART(mm, anot_finicio) = 10 then 'Octubre'when DATEPART(mm, anot_finicio) = 11 then 'Noviembre'when DATEPART(mm, anot_finicio) = 12 then 'Diciembre'end) as ini_con,"& vbCrLf &_ 
"(select case when DATEPART(mm,anot_ffin) = 1 then 'Enero' when DATEPART(mm, anot_ffin) = 2 then 'Febrero'  when DATEPART(mm, anot_ffin) = 3 then 'Marzo' when DATEPART(mm, anot_ffin) = 4 then 'Abril' when DATEPART(mm, anot_ffin) = 5 then 'Mayo' when DATEPART(mm,anot_ffin) = 6 then 'Junio'when DATEPART(mm, anot_ffin) = 7 then 'Julio'when DATEPART(mm, anot_ffin) = 8 then 'Agosto'when DATEPART(mm, anot_ffin) = 9 then 'Septiembre'when DATEPART(mm, anot_ffin) = 10 then 'Octubre'when DATEPART(mm, anot_ffin) = 11 then 'Noviembre'when DATEPART(mm, anot_ffin) = 12 then 'Diciembre'end) as fin_con," & vbCrLf &_
"( select dire_tcalle+'  #'+dire_tnro from direcciones where pers_ncorr=a.pers_ncorr and tdir_ccod=1)as Direccion,"& vbCrLf &_
"(select case when DATEPART(mm,cdot_finicio) = 1 then 'Enero' when DATEPART(mm, cdot_finicio) = 2 then 'Febrero' when DATEPART(mm, cdot_finicio) = 3 then 'Marzo' when DATEPART(mm,cdot_finicio) = 4 then 'Abril' when DATEPART(mm,cdot_finicio) = 5 then 'Mayo' when DATEPART(mm,cdot_finicio) = 6 then 'Junio'when DATEPART(mm,cdot_finicio) = 7 then 'Julio'when DATEPART(mm,cdot_finicio) = 8 then 'Agosto'when DATEPART(mm,cdot_finicio) = 9 then 'Septiembre'when DATEPART(mm, cdot_finicio) = 10 then 'Octubre'when DATEPART(mm, cdot_finicio) = 11 then 'Noviembre'when DATEPART(mm, cdot_finicio) = 12 then 'Diciembre'end) as mes_ini_contrato,"& vbCrLf &_
"(select case when DATEPART(mm,cdot_ffin) = 1 then 'Enero' when DATEPART(mm, cdot_ffin) = 2 then 'Febrero' when DATEPART(mm, cdot_ffin) = 3 then 'Marzo' when DATEPART(mm, cdot_ffin) = 4 then 'Abril' when DATEPART(mm, cdot_ffin) = 5 then 'Mayo' when DATEPART(mm,cdot_ffin) = 6 then 'Junio'when DATEPART(mm, cdot_ffin) = 7 then 'Julio'when DATEPART(mm, cdot_ffin) = 8 then 'Agosto'when DATEPART(mm, cdot_ffin) = 9 then 'Septiembre'when DATEPART(mm, cdot_ffin) = 10 then 'Octubre'when DATEPART(mm, cdot_ffin) = 11 then 'Noviembre'when DATEPART(mm, cdot_ffin) = 12 then 'Diciembre'end) as mes_fin_contrato,"& vbCrLf &_
"(select  DATEPART(yyyy,cdot_finicio) ) as anio_ini_contrato,"& vbCrLf &_
"(select  DATEPART(yyyy,cdot_ffin)) as anio_fin_contrato,"& vbCrLf &_
"protic.trunc(cdot_finicio)  as cdot_finicio,"& vbCrLf &_
"protic.trunc(cdot_ffin) as cdot_ffin,"& vbCrLf &_
"(SELECT DATEPART(d, GETDATE()))as Dia," & vbCrLf &_ 
"(SELECT DATEPART(yy, GETDATE())) as Año, " & vbCrLf &_
"(select tcat_valor from relatores_programa vvv, tipos_categoria bbb where vvv.pers_ncorr=a.pers_ncorr and vvv.dgso_ncorr=dg.dgso_ncorr and vvv.tcat_ccod=bbb.tcat_ccod)as valor_hora,"& vbCrLf &_
"(select protic.obtener_grado_docente(a.pers_ncorr,'G')) as grado,"& vbCrLf &_
"(select protic.obtener_grado_docente(a.pers_ncorr,'I')) as institucion_t1, "& vbCrLf &_
"(select top 1 cudo_tinstitucion from curriculum_docente where pers_ncorr = a.pers_ncorr and grac_ccod in(1,2) order by grac_ccod desc) as institucion_t"& vbCrLf &_
"From contratos_docentes_otec a, anexos_otec b , detalle_anexo_otec c,modulos_otec mo,secciones_otec so,datos_generales_secciones_otec dg,instituciones l"& vbCrLf &_ 
"Where a.cdot_ncorr   = b.cdot_ncorr "& vbCrLf &_
			          "and b.anot_ncorr  = c.anot_ncorr"& vbCrLf &_ 
			          "and c.seot_ncorr=so.seot_ncorr" & vbCrLf &_ 
			          "and b.cdot_ncorr = c.cdot_ncorr" & vbCrLf &_
			          "and mo.mote_ccod=c.mote_ccod" & vbCrLf &_
			          "and so.dgso_ncorr=dg.dgso_ncorr" & vbCrLf &_
			          "and l.INST_CCOD=1 " & vbCrLf &_
			          "and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"'"& vbCrLf &_
			         " and cast(dg.dcur_ncorr as varchar)='"&q_dcur_ncorr&"')aaa"& vbCrLf &_
"group by nombre_docente,Rut_Docente,fecha_nac,estado_civil,comuna,profesion,TipoDocente,Nacionalidad,NombreRepLeg,inst_trazon_social,sede_tdesc,Dia,Mes,Año,fin_con,ini_con,mes_ini_contrato,mes_fin_contrato,anio_ini_contrato,anio_fin_contrato,Direccion,grado,institucion_t1,institucion_t,ano_actual,dia_actual,cdot_finicio,cdot_ffin,valor_hora"



f_datos.Consultar consulta_datos
f_datos.Siguiente



'response.Write(consulta_datos)
'
'response.end()



 '---------------------------------------------obtengo los datos del anexo
 set f_anexos = new CFormulario
 f_anexos.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_anexos.Inicializar conexion

					
				 selec_anexos="select  mote_tdesc,anot_ncodigo,daot_mhora,daot_nhora,protic.trunc(anot_finicio)as anot_finicio,protic.trunc(anot_ffin)as anot_ffin,anot_ncuotas,seot_tdesc,"& vbCrLf &_
"(select case when DATEPART(mm,anot_finicio) = 1 then 'Enero' when DATEPART(mm, anot_finicio) = 2 then 'Febrero'  when DATEPART(mm, anot_finicio) = 3 then 'Marzo' when DATEPART(mm,anot_finicio) = 4 then 'Abril' when DATEPART(mm,anot_finicio) = 5 then 'Mayo' when DATEPART(mm,anot_finicio) = 6 then 'Junio'when DATEPART(mm,anot_finicio) = 7 then 'Julio'when DATEPART(mm,anot_finicio) = 8 then 'Agosto'when DATEPART(mm,anot_finicio) = 9 then 'Septiembre'when DATEPART(mm, anot_finicio) = 10 then 'Octubre'when DATEPART(mm, anot_finicio) = 11 then 'Noviembre'when DATEPART(mm, anot_finicio) = 12 then 'Diciembre'end) as ini_ane," & vbCrLf &_
"(select case when DATEPART(mm,anot_ffin) = 1 then 'Enero' when DATEPART(mm, anot_ffin) = 2 then 'Febrero'  when DATEPART(mm, anot_ffin) = 3 then 'Marzo' when DATEPART(mm, anot_ffin) = 4 then 'Abril' when DATEPART(mm, anot_ffin) = 5 then 'Mayo' when DATEPART(mm,anot_ffin) = 6 then 'Junio'when DATEPART(mm, anot_ffin) = 7 then 'Julio'when DATEPART(mm, anot_ffin) = 8 then 'Agosto'when DATEPART(mm, anot_ffin) = 9 then 'Septiembre'when DATEPART(mm, anot_ffin) = 10 then 'Octubre'when DATEPART(mm, anot_ffin) = 11 then 'Noviembre'when DATEPART(mm, anot_ffin) = 12 then 'Diciembre'end) as fin_ane,"& vbCrLf &_
"datepart(yyyy,anot_finicio)as anio_ini_ane,"& vbCrLf &_
"datepart(yyyy,anot_ffin)as anio_fin_ane"& vbCrLf &_
							"from modulos_otec mo,"& vbCrLf &_
							"mallas_otec mot,"& vbCrLf &_
							"bloques_relatores_otec bro,"& vbCrLf &_
							"bloques_horarios_otec bho,"& vbCrLf &_
							"secciones_otec so,"& vbCrLf &_
							"relatores_programa rp,"& vbCrLf &_
							"contratos_docentes_otec cdot,"& vbCrLf &_
							"anexos_otec anot,"& vbCrLf &_
							"detalle_anexo_otec daot"& vbCrLf &_
							"where mot.mote_ccod=mo.mote_ccod"& vbCrLf &_
							"and mot.maot_ncorr=so.maot_ncorr"& vbCrLf &_
							"and bho.seot_ncorr=so.seot_ncorr"& vbCrLf &_
							"and bho.bhot_ccod=bro.bhot_ccod"& vbCrLf &_
							"and bro.pers_ncorr=rp.pers_ncorr"& vbCrLf &_
							"and so.dgso_ncorr=rp.dgso_ncorr"& vbCrLf &_
							
							"and bro.anot_ncorr=anot.anot_ncorr"& vbCrLf &_
							"and cdot.cdot_ncorr=anot.cdot_ncorr"& vbCrLf &_
							"and anot.anot_ncorr=daot.anot_ncorr"& vbCrLf &_
							"and cdot.cdot_ncorr=daot.cdot_ncorr"& vbCrLf &_
							"and dcur_ncorr="&q_dcur_ncorr&""& vbCrLf &_
							"and rp.pers_ncorr="&q_pers_ncorr&""	
 f_anexos.Consultar selec_anexos
 'f_anexos.Siguiente
 
 
 
 
 'response.end()
 
 valor_hora_cont=FormatCurrency(cint(f_datos.ObtenerValor("valor_hora")), 0)
 espacio="                                       "
 espacio2="    "


 comilla=""""
'response.end()
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","",12
pdf.Open()

if tcdo_ccod="1" then
 lineaFirmado="__________________________"
 lineaFirmado2="_________________________________"
 linea="  _______________________________________________________________________________________________________"
pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","B",13
pdf.Cell 180,1,"CONTRATO DE PRESTACION DE SERVICIOS PROFESIONALES","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.MultiCell 180,5,"En Santiago a "&f_datos.ObtenerValor("dia_actual")&" de "&f_datos.ObtenerValor("mes")&" de "&f_datos.ObtenerValor("ano_actual")&", entre la UNIVERSIDAD DEL PACIFICO, representada por ITALO GIRAUDO TORRES, con domicilio en Avenida Las Condes N°11.121 santiago, y don (a): "&f_datos.ObtenerValor("nombre_docente")&", nacionalidad "&f_datos.ObtenerValor("nacionalidad")&", estado civil "&f_datos.ObtenerValor("estado_civil")&" ,de profesión "&f_datos.ObtenerValor("profesion")&", cédula nacional de identidad número "&f_datos.ObtenerValor("Rut_Docente")&", domiciliado en "&f_datos.ObtenerValor("Direccion")&" "&f_datos.ObtenerValor("comuna")&" procedente de esta ciudad y de nacionalidad CHILENA, se ha convenido el siguiente Contrato de Prestación de Servicios Profesionales:","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"PRIMERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"              La Universidad del Pacífico contrata los servicios de don(a) "&f_datos.ObtenerValor("nombre_docente")&", para que en su calidad de docente preste servicios a la Universidad del Pacifico, sobre la base de honorarios profesionales o por el período académico convenido en el anexo del presente contrato a que se refiere la cláusula sexta.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEGUNDO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                   El presente contrato comenzará a regir a contar del día "&f_datos.ObtenerValor("cdot_ffinicio")&" y tendrá vigencia hasta el término total de las actividades académicas del período semestral y/o anual para el cual fueron contratados los servicios del docente. En todo caso, la vigencia del mismo no podrá extenderse más allá del día "&f_datos.ObtenerValor("cdot_ffin")&". No obstante la Universidad del Pacífico se reserva el derecho de poner término anticipado a esta prestación de Servicios Profesionales, sin tener derecho el docente a indemnización alguna.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"TERCERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                   El docente , "&f_datos.ObtenerValor("nombre_docente")&" prestará sus servicios libremente sin sujeción a horario, fiscalización superior inmediata ni modalidad alguna que pudiera configurar con la Universidad del Pacífico algún vínculo de subordinación o dependencia.","","J",""
pdf.ln(10)
pdf.MultiCell 180,5,"Sin perjuicio de lo anterior y para el sólo objeto de facilitar el ordenamiento y programación académica, el docente don(a) "&f_datos.ObtenerValor("nombre_docente")&", se compromete a convenir con el Director de la escuela los días y horas en que se llevará a cabo la docencia, de acuerdo a las necesidades académicas.","","J",""
pdf.ln(5)

'----------------------------------------------------------------------------pagina 2

pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","B",13
pdf.Cell 180,1,"CONTRATO DE PRESTACION DE SERVICIOS PROFESIONALES","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"CUARTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                Don(a) "&f_datos.ObtenerValor("nombre_docente")&" tendrá derecho a un honorario que se establece en el anexo de carga académica que se adjunta, el que se liquidará y pagará mensualmente el último día hábil de cada mes, contra entrega de la respectiva boleta de honorarios, siendo de responsabilidad de la Universidad del Pacífico la retención y pago de impuestos a la renta. Para el sólo efecto de la liquidación de su honorario don(a) "&f_datos.ObtenerValor("nombre_docente")&" deberá registrar de un modo adecuado y fehaciente la realización de cada sesión académica.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"QUINTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El docente "&f_datos.ObtenerValor("nombre_docente")&", se compromete a prestar sus servicios de acuerdo a los objetivos y normas éticas y académicas de tipo general que existen en la institución.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEXTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El docente se compromete a impartir la o las asignaturas durante el o los períodos académicos del "&f_datos.ObtenerValor("anio_ini_contrato")&" que se especifican en el documento anexo al presente contrato, el que debidamente firmado por las partes, pasará a formar parte integra del mismo.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEPTIMO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  Para todos los efectos de este contrato, las partes fijan su domicilio en esta ciudad y se someten a la jurisdicción de sus Tribunales de Justicia.","","J",""
pdf.ln(5)
pdf.MultiCell 180,5,"El presente Contrato de Prestación de Servicios Profesionales se extiende y firma en dos ejemplares de igual tenor y fecha, quedando uno en poder de cada parte.","","J",""
pdf.ln(40)
pdf.Image "../biblioteca/imagenes/firma.jpg", 23, 190, 55, 30, "JPG"
pdf.ln(1)
pdf.Cell 180,1,"         "&lineaFirmado&"","","","L"
pdf.ln(0)
pdf.Cell 175,1,""&lineaFirmado&"","","","R"
pdf.ln(4)
pdf.SetFont "Arial","",8
pdf.Cell 175,1,"             ITALO GIRAUDO TORRES","","","L"
pdf.ln(0)
pdf.Cell 175,7,"             p.p. UNIVERSIDAD DEL PACIFICO","","","L"
pdf.ln(0)
espacio4="                                                                                                                                                "
pdf.Cell 170,1,""&espacio4&""&f_datos.ObtenerValor("nombre_docente")&"","","","L"
pdf.ln(3)
pdf.Cell 139,1,"C.Ident:"&f_datos.ObtenerValor("Rut_Docente")&"","","","R"
'----------------------------------------------------------------------------pagina 3

while f_anexos.Siguiente
 nombre_asig=f_anexos.ObtenerValor("mote_tdesc")
 largo_nombre_asig=len(nombre_asig)
 n_cuotas=CInt(f_anexos.ObtenerValor("anot_ncuotas"))
 'response.Write(largo_nombre_asig)
 valor_hora_a=CDbl(f_anexos.ObtenerValor("daot_mhora"))
 nume_hora_a=CDbl(f_anexos.ObtenerValor("daot_nhora"))
 

 
 total=valor_hora_a*nume_hora_a
total_valor=FormatCurrency(total, 0)

valor_couta=round(total_valor/n_cuotas)
valor_couta_=FormatCurrency(valor_couta, 0)
 
 valor_hora_a=FormatCurrency(valor_hora_a, 0)

pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","B",13
pdf.Cell 180,1,"CONTRATO DE PRESTACION DE SERVICIOS PROFESIONALES","","","C"
pdf.ln(5)
pdf.SetFont "Arial","B",8
pdf.Cell 180,15,"ANEXO N°"&f_anexos.ObtenerValor("anot_ncodigo")&"","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",9
pdf.ln(5)
pdf.MultiCell 180,5,"ANEXO INTEGRANTE AL CONTRATO DE PRESTACION DE SERVICIOS","","0","C" 
pdf.ln(1)
pdf.SetX(71)
pdf.MultiCell 119,5,"PROFESIONALES DEL :docente "&f_datos.ObtenerValor("nombre_docente")&" ","","0","R" 
pdf.ln(5)
pdf.Cell 180,1,"QUE FIJA DOCENTE Y HONORARIOS PARA EL PERIODO:"&f_anexos.ObtenerValor("anot_finicio")&" y el "&f_anexos.ObtenerValor("anot_ffin")&"","","","L"
pdf.ln(9)
pdf.Cell 180,1,"    ASIGNATURA:","","","L"
pdf.ln(0)
pdf.Cell 180,1,"      Sección:","","","C"
pdf.ln(0)
pdf.Cell 180,1,"                                                             Horas:","","","C"
pdf.ln(0)
pdf.Cell 170,1,"  Honorarios ","","","R"
pdf.ln(3)
pdf.Cell 170,1,"  de Periodo:","","","R"
pdf.ln(1)
'pdf.SetFont "Arial","",12
pdf.Cell 50,1,""&linea&"","","",""
pdf.ln(3)
if largo_nombre_asig < 39 then 
'pdf.SetFont "Arial","",10
pdf.MultiCell 97,3,"    "&f_anexos.ObtenerValor("mote_tdesc")&"","","","L"
pdf.ln(-3)
'pdf.SetFont "Arial","",10
pdf.Cell 180,3,"      "&f_anexos.ObtenerValor("seot_tdesc")&"","","","C"
pdf.ln(0)
pdf.Cell 180,3,"                                                             "&f_anexos.ObtenerValor("daot_nhora")&"","","","C"
pdf.ln(0)
pdf.Cell 170,3,""&total_valor&"","","","R"
end if
if largo_nombre_asig > 38 then
'pdf.SetFont "Arial","",10
pdf.MultiCell 97,3,"    "&f_anexos.ObtenerValor("mote_tdesc")&"","","","L"
pdf.ln(-3)
'pdf.SetFont "Arial","",10
pdf.Cell 180,3,"      "&f_anexos.ObtenerValor("seot_tdesc")&"","","","C"
pdf.ln(0)
pdf.Cell 180,3,"                                                             "&f_anexos.ObtenerValor("daot_nhora")&"","","","C"
pdf.ln(0)
pdf.Cell 170,3,""&total_valor&"","","","R"

end if
pdf.ln(15)
pdf.SetFont "Arial","",10
pdf.ln(0)
pdf.Cell 180,5,"1) La honorarios total brutos de: "&total_valor&" se pagaría de la siguiente manera:","","","L"
pdf.ln(5)
pdf.SetFont "Arial","",10
pdf.ln(0)
pdf.MultiCell 180,5,"-Mediante "&f_anexos.ObtenerValor("anot_ncuotas")&" cuotas de "&valor_couta_&" bruto entre los meses de  "&f_anexos.ObtenerValor("ini_ane")&" de "&f_anexos.ObtenerValor("anio_ini_ane")&" a "&f_anexos.ObtenerValor("fin_ane")&" de "&f_anexos.ObtenerValor("anio_fin_ane")&"","","","L"
pdf.ln(5)
pdf.MultiCell 180,5,"2) El valor utilizado por hora cronológica en el cálculo es de "&valor_hora_a&"","","","L"
pdf.ln(5)
pdf.MultiCell 180,5,"3) El presente anexo de prestación de servicios profesionales se extiende y firma en dos ejemplares de igual tenor y fecha, quedando uno en poder de cada parte","","","L"

pdf.ln(60)
pdf.Image "../biblioteca/imagenes/firma.jpg", 23, 185, 55, 30, "JPG"
pdf.ln(1)
pdf.Cell 180,1,"         "&lineaFirmado2&"","","","L"
pdf.ln(0)
pdf.Cell 175,1,""&lineaFirmado2&"","","","R"
pdf.ln(4)
pdf.SetFont "Arial","",8
pdf.Cell 175,1,"             ITALO GIRAUDO TORRES","","","L"
pdf.ln(0)
pdf.Cell 175,7,"             p.p. UNIVERSIDAD DEL PACIFICO","","","L"
pdf.ln(0)
espacio3="                                                                                                                                           "
pdf.Cell 168,1,""&espacio3&""&f_datos.ObtenerValor("nombre_docente")&"","","","L"
pdf.ln(3)
pdf.Cell 135,1,"C.Ident:"&f_datos.ObtenerValor("Rut_Docente")&"","","","R"
wend
end if

''__________________________________________________________INDEFINIDO____________________________________________________________________________________________________________________
if tcdo_ccod="2" then
 lineaFirmado="__________________________"
 lineaFirmado2="_________________________________"
 linea="  _______________________________________________________________________________________________________"
pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","B",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO PARA DOCENTE","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.MultiCell 180,5,"En Santiago a "&f_datos.ObtenerValor("dia_actual")&" de "&f_datos.ObtenerValor("mes")&" de "&f_datos.ObtenerValor("ano_actual")&", entre la UNIVERSIDAD DEL PACIFICO, representada por ITALO GIRAUDO TORRES, con domicilio en Avenida Las Condes N°11.121 santiago, y don (a): "&f_datos.ObtenerValor("nombre_docente")&", nacionalidad "&f_datos.ObtenerValor("nacionalidad")&", estado civil "&f_datos.ObtenerValor("estado_civil")&" ,de profesión "&f_datos.ObtenerValor("profesion")&", cédula nacional de identidad número "&f_datos.ObtenerValor("Rut_Docente")&", domiciliado en "&f_datos.ObtenerValor("Direccion")&" "&f_datos.ObtenerValor("comuna")&" procedente de esta ciudad y de nacionalidad CHILENA, se ha convenido el siguiente Contrato de Prestación de Servicios Profesionales:","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"PRIMERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"              La Universidad del Pacífico contrata los servicios de don(a) "&f_datos.ObtenerValor("nombre_docente")&" para que en su calidad de docente preste servicios a la Universidad del Pacifico, sobre la base de honorarios profesionales o por el período académico convenido en el anexo del presente contrato a que se refiere la cláusula sexta.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEGUNDO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                   El presente contrato comenzará a regir a contar del día "&f_datos.ObtenerValor("cdot_ffinicio")&" y tendrá vigencia hasta el término total de las actividades académicas del período semestral y/o anual para el cual fueron contratados los servicios del docente. En todo caso, la vigencia del mismo no podrá extenderse más allá del día "&f_datos.ObtenerValor("cdot_ffin")&". No obstante la Universidad del Pacífico se reserva el derecho de poner término anticipado a esta prestación de Servicios Profesionales, sin tener derecho el docente a indemnización alguna.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"TERCERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                   El docente , "&f_datos.ObtenerValor("nombre_docente")&" prestará sus servicios libremente sin sujeción a horario, fiscalización superior inmediata ni modalidad alguna que pudiera configurar con la Universidad del Pacífico algún vínculo de subordinación o dependencia.","","J",""
pdf.ln(10)
pdf.MultiCell 180,5,"Sin perjuicio de lo anterior y para el sólo objeto de facilitar el ordenamiento y programación académica, el docente don(a) "&f_datos.ObtenerValor("nombre_docente")&", se compromete a convenir con el Director de la escuela los días y horas en que se llevará a cabo la docencia, de acuerdo a las necesidades académicas.","","J",""
pdf.ln(5)

'----------------------------------------------------------------------------pagina 2

pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","B",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO PARA DOCENTE","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"CUARTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  Don(a) "&f_datos.ObtenerValor("nombre_docente")&" tendrá derecho a un honorario que se establece en el anexo de carga académica que se adjunta, el que se liquidará y pagará mensualmente el último día hábil de cada mes, contra entrega de la respectiva boleta de honorarios, siendo de responsabilidad de la Universidad del Pacífico la retención y pago de impuestos a la renta. Para el sólo efecto de la liquidación de su honorario don(a) "&f_datos.ObtenerValor("nombre_docente")&" deberá registrar de un modo adecuado y fehaciente la realización de cada sesión académica.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"QUINTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El docente "&f_datos.ObtenerValor("nombre_docente")&", se compromete a prestar sus servicios de acuerdo a los objetivos y normas éticas y académicas de tipo general que existen en la institución.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEXTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El docente se compromete a impartir la o las asignaturas durante el o los períodos académicos del "&f_datos.ObtenerValor("anio_ini_contrato")&" que se especifican en el documento anexo al presente contrato, el que debidamente firmado por las partes, pasará a formar parte integra del mismo.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEPTIMO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  Para todos los efectos de este contrato, las partes fijan su domicilio en esta ciudad y se someten a la jurisdicción de sus Tribunales de Justicia.","","J",""
pdf.ln(5)
pdf.MultiCell 180,5,"El presente Contrato de Prestación de Servicios Profesionales se extiende y firma en dos ejemplares de igual tenor y fecha, quedando uno en poder de cada parte.","","J",""
pdf.ln(40)
pdf.Image "../biblioteca/imagenes/firma.jpg", 23, 190, 55, 30, "JPG"
pdf.ln(1)
pdf.Cell 180,1,"         "&lineaFirmado&"","","","L"
pdf.ln(0)
pdf.Cell 175,1,""&lineaFirmado&"","","","R"
pdf.ln(4)
pdf.SetFont "Arial","",8
pdf.Cell 175,1,"             ITALO GIRAUDO TORRES","","","L"
pdf.ln(0)
pdf.Cell 175,7,"             p.p. UNIVERSIDAD DEL PACIFICO","","","L"
pdf.ln(0)
espacio4="                                                                                                                                                "
pdf.Cell 170,1,""&espacio4&""&f_datos.ObtenerValor("nombre_docente")&"","","","L"
pdf.ln(3)
pdf.Cell 139,1,"C.Ident:"&f_datos.ObtenerValor("Rut_Docente")&"","","","R"
'----------------------------------------------------------------------------pagina 3

while f_anexos.Siguiente
 nombre_asig=f_anexos.ObtenerValor("mote_tdesc")
 largo_nombre_asig=len(nombre_asig)
 n_cuotas=CInt(f_anexos.ObtenerValor("anot_ncuotas"))
 'response.Write(largo_nombre_asig)
 valor_hora_a=CDbl(f_anexos.ObtenerValor("daot_mhora"))
 nume_hora_a=CDbl(f_anexos.ObtenerValor("daot_nhora"))
 

 
 total=valor_hora_a*nume_hora_a
total_valor=FormatCurrency(total, 0)

valor_couta=round(total_valor/n_cuotas)
valor_couta_=FormatCurrency(valor_couta, 0)
 
 valor_hora_a=FormatCurrency(valor_hora_a, 0)

pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","B",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO PARA DOCENTE","","","C"
pdf.ln(5)
pdf.SetFont "Arial","B",8
pdf.Cell 180,15,"ANEXO N°"&f_anexos.ObtenerValor("anot_ncodigo")&"","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",9
pdf.ln(5)
pdf.MultiCell 180,5,"ANEXO INTEGRANTE AL CONTRATO DE TRABAJO DEL :docente "&f_datos.ObtenerValor("nombre_docente")&" ","","0","C" 
pdf.ln(5)
pdf.Cell 180,1,"QUE FIJA DOCENTE Y REMUNERACION PARA EL PERIODO:"&f_anexos.ObtenerValor("anot_finicio")&" y el "&f_anexos.ObtenerValor("anot_ffin")&"","","","L"
pdf.ln(9)
pdf.Cell 180,1,"    ASIGNATURA:","","","L"
pdf.ln(0)
pdf.Cell 180,1,"      Sección:","","","C"
pdf.ln(0)
pdf.Cell 180,1,"                                                             Horas:","","","C"
pdf.ln(0)
pdf.Cell 170,1,"$ Valor Total:","","","R"
pdf.ln(1)
'pdf.SetFont "Arial","",12
pdf.Cell 50,1,""&linea&"","","",""
pdf.ln(3)
if largo_nombre_asig < 39 then 
'pdf.SetFont "Arial","",10
pdf.MultiCell 97,3,"    "&f_anexos.ObtenerValor("mote_tdesc")&"","","","L"
pdf.ln(-3)
'pdf.SetFont "Arial","",10
pdf.Cell 180,3,"      "&f_anexos.ObtenerValor("seot_tdesc")&"","","","C"
pdf.ln(0)
pdf.Cell 180,3,"                                                             "&f_anexos.ObtenerValor("daot_nhora")&"","","","C"
pdf.ln(0)
pdf.Cell 170,3,""&total_valor&"","","","R"
end if
if largo_nombre_asig > 38 then
'pdf.SetFont "Arial","",10
pdf.MultiCell 97,3,"    "&f_anexos.ObtenerValor("mote_tdesc")&"","","","L"
pdf.ln(-3)
'pdf.SetFont "Arial","",10
pdf.Cell 180,3,"      "&f_anexos.ObtenerValor("seot_tdesc")&"","","","C"
pdf.ln(0)
pdf.Cell 180,3,"                                                             "&f_anexos.ObtenerValor("daot_nhora")&"","","","C"
pdf.ln(0)
pdf.Cell 170,3,""&total_valor&"","","","R"

end if
pdf.ln(15)
pdf.SetFont "Arial","",10
pdf.ln(0)
pdf.Cell 180,5,"1) La remuneración total bruta de: "&total_valor&" se pagaría de la siguiente manera:","","","L"
pdf.ln(5)
pdf.SetFont "Arial","",10
pdf.ln(0)
pdf.MultiCell 180,5,"-Mediante "&f_anexos.ObtenerValor("anot_ncuotas")&" cuotas de "&valor_couta_&" bruto entre los meses de  "&f_anexos.ObtenerValor("ini_ane")&" de "&f_anexos.ObtenerValor("anio_ini_ane")&" a "&f_anexos.ObtenerValor("fin_ane")&" de "&f_anexos.ObtenerValor("anio_fin_ane")&" ambos meses inclusive, en el mes de Febrero, el docente hara uso de su feriado legal y su remuneración durante ese mes se pagara por el empleador conforme a lo dispuesto en el artículo 71, del codigo del trabajo.","","","L"
pdf.ln(5)
pdf.MultiCell 180,5,"2) En el mes de Enero de cada año el docente no estará obligado a impartir docencia en el evento de que hubiera desarrollado integramente la docencia pactada en este anexo.","","","L"
pdf.ln(5)
pdf.MultiCell 180,5,"3) El valor utilizado por hora cronológica en el cálculo es de "&valor_hora_a&"","","","L"
pdf.ln(5)
pdf.MultiCell 180,5,"4) Además, el docente tendrá derecho, por concepto de colación y movilización, a un de por cada día hábil, de Lunes a Viernes de cada mes calendario de Marzo a Diciembre de "&f_datos.ObtenerValor("anio_ini_contrato")&", ambos meses inclusive","","","L"
pdf.ln(5)
pdf.MultiCell 180,5,"5) El presente anexo se extiende y firma en dos ejemplares de igual tenor y fecha, quedando uno en poder de cada parte.","","","L"

pdf.ln(60)
pdf.Image "../biblioteca/imagenes/firma.jpg", 23, 223, 55, 30, "JPG"
pdf.ln(1)
pdf.Cell 180,1,"         "&lineaFirmado2&"","","","L"
pdf.ln(0)
pdf.Cell 175,1,""&lineaFirmado2&"","","","R"
pdf.ln(4)
pdf.SetFont "Arial","",8
pdf.Cell 175,1,"             ITALO GIRAUDO TORRES","","","L"
pdf.ln(0)
pdf.Cell 175,7,"             p.p. UNIVERSIDAD DEL PACIFICO","","","L"
pdf.ln(0)
espacio3="                                                                                                                                           "
pdf.Cell 168,1,""&espacio3&""&f_datos.ObtenerValor("nombre_docente")&"","","","L"
pdf.ln(3)
pdf.Cell 135,1,"C.Ident:"&f_datos.ObtenerValor("Rut_Docente")&"","","","R"
wend
end if









''__________________________________________________________PLAZO FIJO____________________________________________________________________________________________________________________
if tcdo_ccod="3" then
linea="  __________________________________________________________________________"
 lineaFirmado="________________________"
pdf.AddPage()
'----------------------------------------------------------------------------pagina 1

pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","BU",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO DE ACADÉMICO","","","C"
pdf.ln(4)
pdf.SetFont "Arial","B",13
pdf.Cell 180,2,"JORNADA PARCIAL","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.MultiCell 180,5,"En Santiago a "&f_datos.ObtenerValor("dia_actual")&" de "&f_datos.ObtenerValor("mes")&" de "&f_datos.ObtenerValor("ano_actual")&", entre la UNIVERSIDAD DEL PACIFICO, persona jurídica del giro educacional de su denominación, R.U.T. 71.704.700-1, representada por doña Elena Ortúzar Muñoz y don Italo Giraudo Torres, todos domiciliados en esta ciudad, Avda. Las Condes N° 11.121, de la Comuna del mismo nombre, en adelante indistintamente "&comilla&"El empleador"&comilla&" o "&comilla&"La Universidad"&comilla&", por una parte; y, por la otra, don (a): "&f_datos.ObtenerValor("nombre_docente")&", nacionalidad "&f_datos.ObtenerValor("nacionalidad")&", estado civil "&f_datos.ObtenerValor("estado_civil")&" ,de profesión "&f_datos.ObtenerValor("profesion")&", cédula nacional de identidad número "&f_datos.ObtenerValor("Rut_Docente")&", domiciliado en "&f_datos.ObtenerValor("Direccion")&" "&f_datos.ObtenerValor("comuna")&" en adelante "&comilla&"El Trabajador"&comilla&" se ha convenido el siguiente Contrato de Trabajo:","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"PRIMERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"       La Universidad del Pacífico, representada en la forma expresada en la comparecencia,declara que ser una persona jurídica de derecho privado del giro educacional, dedicada específicamente a la actividad de la educación superior Universitaria. Declara a su vez el trabajador, don "&f_datos.ObtenerValor("nombre_docente")&" que es poseedor del Titulo Universitario de "&f_datos.ObtenerValor("profesion")&" quele fuera otorgado por la Universidad "&f_datos.ObtenerValor("institucion_t")&" y del grado académico de "&f_datos.ObtenerValor("grado")&", otorgado por "&f_datos.ObtenerValor("institucion_t1")&" Estipulan las partes que las declaraciones que ambas han formulado en esta cláusula, han sido determinantes para la celebración del contrato de que da cuenta el presente instrumento..","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEGUNDO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                   Por el presente instrumento, doña Elena Ortúzar Muñoz y don Italo Giraudo Torres, en la representación en que comparecen, contratan a don (a) "&f_datos.ObtenerValor("nombre_docente")&" quién acepta y se obliga a desempeñar el cargo de académico, obligándose a dictar clases de su especialidad, a tiempo (jornada) parcial, en las condiciones que mas adelante se indican.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"TERCERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                   La jornada parcial por la que se contrata al académico, será durante el respectivo año académico de un mínimo de una sesión semanal (equivalente a 1 hora 30 minutos cronológicos). No obstante, podrá dictar un número mayor de sesiones semanales, las que podrán variar en cada semestre o año académico, sea aumentándolas o disminuyéndolas, de acuerdo a los planes y programas de estudio de la Universidad del Pacífico. Con quince días de antelación a cada período académico anual o semestral, la Universidad suscribirá con el académico un anexo en el que se especificará el número de sesiones y horarios en que el trabajador deberá dictar sus clases, de acuerdo a los planes y programas de la respectiva carrera. Las partes pactan expresamente que la disminución de la jornada parcial de trabajo del académico por efecto de lo dispuesto en esta cláusula, no constituirá menoscabo para el trabajador.","","J",""
pdf.ln(5)
'----------------------------------------------------------------------------pagina 2

pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","BU",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO DE ACADÉMICO","","","C"
pdf.ln(4)
pdf.SetFont "Arial","B",13
pdf.Cell 180,2,"JORNADA PARCIAL","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"CUARTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  Cada sesión académica comprenderá la preparación de la clase, la exposición de la materia, su registro en el Libro de Clases, la corrección de pruebas, la toma de exámenes y demás trabajos académicos inherentes al desarrollo del curso, debiendo el docente atenerse en todo a las instrucciones y demás normas de orden académico, de orientación y reglamentarias que imparta el Director de la respectiva Escuela, el Vicerrector Académico y el Rector de la Universidad.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"QUINTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El académico se obliga a prestar sus servicios conforme a los planes de Estudio elaborados por la empleadora y que el trabajador declara conocer y aceptar. Estas labores se llevarán a cabo por el trabajador en las distintas sedes con que cuenta la Universidad, todas de esta ciudad, por lo cual el trabajador acepta desde ya cualquier cambio del lugar en donde deba desempeñar sus funciones, cuando por razones de buen orden administrativo u operacional o de fuerza mayor la Universidad traslade la sede o sala de clases, sea transitoria o definitivamente.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEXTO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  La Universidad pagará al académico un sueldo base bruto mensual , por cada sesión (equivalente a 1 hora 30 minutos) efectivamente prestada por el académico, el día 30 de cada mes, o el día hábil anterior a éste si correspondiera a día sábado, o el día hábil siguiente si fuese domingo o festivo, en moneda de curso legal, la(s) remuneración(es) indicadas, compuesta por las sesiones efectivamente realizadas de los cursos, menos los descuentos legales y convencionales de cargo del trabajador(a) que corresponda. Las remuneraciones que el trabajador devengue por aplicación del presente contrato se pagarán mediante cheque, vale vista ó depósito directamente en la cuenta corriente que el trabajador determine e informe por escrito al empleador","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"SEPTIMO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  La jornada de trabajo será parcial y corresponderá exactamente al número de sesiones semanales que se determinen para cada semestre o año académico, con el mínimo semanal mencionado en la cláusula tercera. Estas horas semanales de clases se distribuirán de común acuerdo entre la Universidad y el trabajador, para cada semestre o año académico y según la carrera respectiva, dentro del horario de funcionamiento de la Universidad que va de Lunes a Viernes 8:00 a 23:25 horas y en Sábado de 8:00 a 17:45 horas, en el anexo que las partes suscribirán al inicio des respectivo período académico anual y/o semestra","","J",""
pdf.ln(5)
'----------------------------------------------------------------------------pagina 3
pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","BU",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO DE ACADÉMICO","","","C"
pdf.ln(4)
pdf.SetFont "Arial","B",13
pdf.Cell 180,2,"JORNADA PARCIAL","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"OCTAVO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  Para los efectos previsionales, si el académico presta servicios a otro empleador, deberá presentar a la Universidad del Pacífico un certificado de éstos en que conste el monto de sus remuneraciones e imposiciones previsionales. Cada vez que dichas remuneraciones e imposiciones experimenten un cambio deberá comunicarlo oportunamente a la Universidad, y si así no lo hiciere, serán de su exclusiva responsabilidad y cargo las sanciones e indemnizaciones que pudieren aplicársele a la Universidad del Pacífico por este concepto.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"NOVENO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El académico declara conocer y aceptar las normas reglamentarias internas de la Universidad, especialmente los reglamentos académicos y educacionales vigentes y su dependencia del respectivo Decano de la  Facultad y Director de la Escuela correspondiente.","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"DECIMO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                  El presente Contrato es a plazo fijo hasta el "&f_datos.ObtenerValor("cdot_ffin")&".","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"DECIMO PRIMERO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                                 Se deja constancia que don (a) "&f_datos.ObtenerValor("nombre_docente")&" ingresó al servicio de la Universidad el "&f_datos.ObtenerValor("cdot_finicio")&"","","J",""
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"DECIMO SEGUNDO:","","","L"
pdf.ln(0)
pdf.SetFont "Arial","",12
pdf.MultiCell 180,5,"                                   Cada ejemplar del presente Contrato de Trabajo está compuesto por tres hojas, que son firmadas por las partes en señal de aceptación y ratificación. Se deja constancia que el trabajador recibe un ejemplar íntegro de este Contrato.","","J",""
pdf.ln(50)
pdf.Image "../biblioteca/imagenes/firma.jpg", 23, 193, 55, 30, "JPG"
pdf.ln(1)
pdf.Cell 180,1,"         "&lineaFirmado&"","","","L"
pdf.ln(0)
pdf.Cell 175,1,""&lineaFirmado&"","","","R"
pdf.ln(4)
pdf.SetFont "Arial","",8
pdf.Cell 175,1,"             ITALO GIRAUDO TORRES","","","L"
pdf.ln(0)
pdf.Cell 175,7,"             p.p. UNIVERSIDAD DEL PACIFICO","","","L"
pdf.ln(0)
espacio4="                                                                                                                                                     "

pdf.Cell 175,1,""&espacio4&""&f_datos.ObtenerValor("nombre_docente")&"","","","L"
pdf.ln(3)
pdf.Cell 143,1,"C.Ident:"&f_datos.ObtenerValor("Rut_Docente")&"","","","R"

pdf.SetFont "Arial","",12
pdf.ln(3)


'----------------------------------------------------------------------------pagina 4
while f_anexos.Siguiente
 nombre_asig=f_anexos.ObtenerValor("mote_tdesc")
 largo_nombre_asig=len(nombre_asig)
 'response.Write(largo_nombre_asig)
 valor_hora_a=CDbl(f_anexos.ObtenerValor("daot_mhora"))
 nume_hora_a=CDbl(f_anexos.ObtenerValor("daot_nhora"))
 
 total=valor_hora_a*nume_hora_a
total_valor=FormatCurrency(total, 0)



pdf.AddPage()
pdf.ln(25)
pdf.Cell 42,1,"                                                       " 
pdf.ln(20)
pdf.SetFont "Arial","BU",13
pdf.Cell 180,1,"CONTRATO DE TRABAJO DE ACADÉMICO","","","C"
pdf.ln(4)
pdf.SetFont "Arial","B",13
pdf.Cell 180,2,"JORNADA PARCIAL","","","C"
pdf.ln(5)
pdf.SetFont "Arial","B",8
pdf.Cell 180,15,"ANEXO N°"&f_anexos.ObtenerValor("anot_ncodigo")&"","","","C"
pdf.ln(10)  
pdf.SetFont "Arial","",12
pdf.ln(5)
pdf.MultiCell 180,5,"En Santiago a "&f_datos.ObtenerValor("dia_actual")&"  de "&f_datos.ObtenerValor("ano_actual")&" , entre la UNIVERSIDAD DEL PACIFICO ,representada por doña ELENA ORTÚZAR MUÑOZ y "&f_datos.ObtenerValor("NombreRepLeg")&", por una parte; y , por la otra, el académico don "&f_datos.ObtenerValor("nombre_docente")&" , vienen en suscribir el siguiente Anexo al contrato de trabajo del académico, que regirá por el periodo académico comprendido entre el "&f_anexos.ObtenerValor("anot_finicio")&" y el "&f_anexos.ObtenerValor("anot_ffin")&"  ","","0","C" 
pdf.SetFont "Arial","B",12
pdf.ln(5)
pdf.Cell 180,1,"    Primero:","","","L"
pdf.SetFont "Arial","",12
pdf.ln(0)
pdf.Cell 180,1,"                   Los cursos a impartir por el académico serán:","","","L"
pdf.SetFont "Arial","",10
pdf.ln(9)
pdf.Cell 180,1,"    ASIGNATURA:","","","L"
pdf.ln(0)
pdf.Cell 180,1,"      Sección:","","","C"
pdf.ln(0)
pdf.Cell 180,1,"                                                             Horas:","","","C"
pdf.ln(0)
pdf.Cell 170,1,"$ Valor Total:","","","R"
pdf.ln(1)
pdf.SetFont "Arial","",12
pdf.Cell 50,1,""&linea&"","","",""
pdf.ln(3)
if largo_nombre_asig < 39 then 
pdf.SetFont "Arial","",10
pdf.MultiCell 97,3,"    "&f_anexos.ObtenerValor("mote_tdesc")&"","","","L"
pdf.ln(-3)
pdf.SetFont "Arial","",10
pdf.Cell 180,3,"      "&f_anexos.ObtenerValor("seot_tdesc")&"","","","C"
pdf.ln(0)
pdf.Cell 180,3,"                                                             "&f_anexos.ObtenerValor("daot_nhora")&"","","","C"
pdf.ln(0)
pdf.Cell 170,3,""&total_valor&"","","","R"
end if
if largo_nombre_asig > 38 then
pdf.SetFont "Arial","",10
pdf.MultiCell 97,3,"    "&f_anexos.ObtenerValor("mote_tdesc")&"","","","L"
pdf.ln(-6)
pdf.SetFont "Arial","",10
pdf.Cell 180,3,"      "&f_anexos.ObtenerValor("seot_tdesc")&"","","","C"
pdf.ln(0)
pdf.Cell 180,3,"                                                             "&f_anexos.ObtenerValor("daot_nhora")&"","","","C"
pdf.ln(0)
pdf.Cell 170,3,""&total_valor&"","","","R"

end if
pdf.ln(15)
pdf.SetFont "Arial","B",12
pdf.ln(0)
pdf.Cell 180,5,"    Segundo:","","","L"
pdf.SetFont "Arial","",12
pdf.ln(0)
pdf.MultiCell 180,5,"                     Los cursos referidos en la cláusula anterior se impartirán en un número de "&f_anexos.ObtenerValor("daot_nhora")&" horas, El valor utilizado por hora cronológica en el cálculo es de :"&valor_hora_b&"","","","L"
pdf.ln(5)
pdf.SetFont "Arial","B",12
pdf.Cell 180,5,"    Tercero:","","","L"
pdf.SetFont "Arial","",12
pdf.ln(0)
pdf.MultiCell 180,5,"                   El presente anexo regirá solo en el período indicado en el mismo, perdiendo completa vigencia terminado el mismo esto es el "&f_anexos.ObtenerValor("anot_ffin")&"","","","L"
pdf.ln(60)
pdf.Image "../biblioteca/imagenes/firma.jpg", 23, 195, 55, 30, "JPG"
pdf.ln(1)
pdf.Cell 180,1,"         "&lineaFirmado&"","","","L"
pdf.ln(0)
pdf.Cell 175,1,""&lineaFirmado&"","","","R"
pdf.ln(4)
pdf.Cell 175,1,"                    EMPLEADOR","","","L"
pdf.ln(0)
pdf.Cell 165,1,"TRABAJADOR","","","R"
pdf.ln(3)
wend
end if
pdf.Close()
pdf.Output()

      
%> 
