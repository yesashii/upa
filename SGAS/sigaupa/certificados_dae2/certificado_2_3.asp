<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "genera_clave.asp" -->
<%
origen=request.QueryString("origen")
q_origen = Request.QueryString("origen")
if(q_origen="1") then
	q_rut = Request.QueryString("rut")
	q_peri = Request.QueryString("peri")
	q_sede = Request.QueryString("sede")
	session("sede")=q_sede
	session("_periodo")=q_peri
	session("rut_usuario")=q_rut
end if

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion
 
 'q_pers_nrut=16365740
 ''pers_nrut=16608757
 'q_peri_ccod=214
 'q_pers_nrut=17420975
 'q_pers_nrut=17131451
 'q_pers_nrut=9968176
  
  pers_ncorr=request.QueryString("pers_ncorr")
tdes_ccod=1
peri_ccod = "218"
pers_nrut = conexion.consultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "' ")
  matr_ncorr_temporal = conexion.consultaUno ("select max(matr_ncorr) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod = 1 ") 
 carr_ccod = conexion.consultaUno ("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and matr_ncorr="&matr_ncorr_temporal&"")


c_consulta = " select case count(*) when 0 then 'N' else 'S' end as tiene " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and tdes_ccod="&tdes_ccod&" " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"

tiene_grabado = conexion.consultaUno(c_consulta)
'---------------------revisamos si tiene grabado este certificado y ya esta vencido o no l tiene se debe grabar un certificado nuevo.

if tiene_grabado = "N" then 

set Password= new CPassword
clave= Password.GenerarPassword(25,conexion)

 codigo = "matr"&clave
 vencimiento = conexion.consultaUno("select protic.trunc(getDate()+30)")
 ceon_ncorr = conexion.consultaUno("exec obtenerSecuencia 'certificados_online'")
 c_insert = "insert into certificados_online (ceon_ncorr, pers_ncorr, carr_ccod, tdes_ccod, fecha_emision, fecha_vencimiento, audi_tusuario, audi_fmodificacion,cod_activacion)"&_
            "values ("&ceon_ncorr&","&pers_ncorr&",'"&carr_ccod&"',"&tdes_ccod&",getDate(), (getDate() + 30), '"&pers_nrut&"', getdate(),'"&codigo&"')"
			
 conexion.ejecutaS c_insert
elseif tiene_grabado = "S" then
c_codigo = " select ltrim(rtrim(cod_activacion)) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
codigo = conexion.consultaUno(c_codigo)
c_vencimiento = " select protic.trunc(fecha_vencimiento) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
vencimiento = conexion.consultaUno(c_vencimiento) 
end if 

if esVacio(tdes_ccod) or tdes_ccod = "3" then
	resto_mensaje= ", para los fines que estime conveniente."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "5" or tdes_ccod = "1" or tdes_ccod = "4" or tdes_ccod = "9" or tdes_ccod = "10" or tdes_ccod = "11" or tdes_ccod = "12" or tdes_ccod = "13" or tdes_ccod = "19") then
	motivo = conexion.consultaUno("select tdes_tdesc from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petición del (la) interesado(a) para solicitar "&motivo&"."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "6" or tdes_ccod = "7" or tdes_ccod = "8" or tdes_ccod = "14" or tdes_ccod = "16" or tdes_ccod = "18") then
	motivo = conexion.consultaUno("select tdes_tdesc from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petición del (la) interesado(a) para ser presentado en "&motivo&"."
elseif not esVacio(tdes_ccod) and tdes_ccod = "2" then
	resto_mensaje= " a petición del (la) interesado(a) para ser presentado en Cant&oacute;n de Reclutamiento."
elseif not esVacio(tdes_ccod) and (tdes_ccod = "15" or tdes_ccod = "17")then
	motivo = conexion.consultaUno("select tdes_tdesc from tipos_descripciones where cast(tdes_ccod as varchar)='"&tdes_ccod&"'")
	resto_mensaje= " a petición del (la) interesado(a) para "&motivo&"."	
end if

consulta= " select top 1 e.jorn_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,jornadas e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.jorn_ccod=e.jorn_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'  and emat_ccod = 1 " & vbCrLf &_
		  " order by peri_ccod desc"


consulta_sede= " select top 1 e.sede_tdesc from personas a, alumnos b, ofertas_academicas c, especialidades d,sedes e " & vbCrLf &_
		  " where cast(a.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf &_
		  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
		  " and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
		  " and c.espe_ccod=d.espe_ccod " & vbCrLf &_
		  " and c.sede_ccod=e.sede_ccod " & vbCrLf &_
		  " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'   and emat_ccod = 1 " & vbCrLf &_
		  " order by peri_ccod desc"

nombre = conexion.consultaUno("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
rut = conexion.consultaUno("select protic.format_rut('"&pers_nrut&"')")
carrera = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")
jornada = conexion.consultaUno(consulta)
nombre_sede = conexion.consultaUno(consulta_sede)
tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "' ")


consulta_fecha = "  select cast(datePart(day,fecha_emision) as varchar)+ ' de ' + " & vbCrLf &_
				     "  case datePart(month,fecha_emision) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' " & vbCrLf &_
					 "  when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' " & vbCrLf &_
					 "  when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " & vbCrLf &_
					 "  + ' de ' + cast(datePart(year,fecha_emision) as varchar) as fecha_01 " & vbCrLf &_
					 "  from certificados_online " & vbCrLf &_
					 "  where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"'"				 
				
fecha_01 = conexion.consultaUno(consulta_fecha)
fecha_01 = "Santiago, "&fecha_01
'------------------------------------ configuramos mensaje de salida para el alumno de acuerdo a su estado---------------
pers_ncorr= conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
consulta_ultimo_estado= " select top 1 emat_ccod from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
						" where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					    " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
						" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  and emat_ccod= 1  " & vbCrLf &_
						" and c.carr_ccod='"&carr_ccod&"' " & vbCrLf &_  
						" order by peri_ccod desc,a.audi_fmodificacion desc"
estado=	conexion.consultaUno(consulta_ultimo_estado)					
'-------------------------Debemos ver si el alumno tiene matricula para el periodo solicitado
consulta_matricula = "select count(*) from alumnos a, ofertas_Academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&peri_ccod&"' and a.emat_ccod = 1 and b.espe_ccod=c.espe_ccod and c.carr_ccod='"&carr_ccod&"' "

tiene_matricula = conexion.consultaUno(consulta_matricula)

'response.Write(consulta_matricula)
if tcar_ccod <> "2" then
	
	if estado = "8" then
		mensaje = "Es alumno(a) Titulado(a)"	
	else
		if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
			mensaje = "Fue Alumno(a)"
		else
			mensaje = "Es Alumno(a)"
		end if
	end if	
else
	if estado = "8" then
		mensaje = "Se encuetra Graduado(a) "	
	else
		if estado= "2" or estado="3" or estado="5" or estado="6" or estado="9" or estado= "10" or tiene_matricula="0" then
			mensaje = "Fue Alumno(a)"
		else
			mensaje = "Es Alumno(a)"
		end if
	end if	

end if


detalle_estado= conexion.consultaUno("Select protic.initcap(emat_tdesc) from estados_matriculas where cast(emat_ccod as varchar)='"&estado&"'")
if estado = "1" or estado = "13" then
	mensaje = mensaje & " regular "
'else
'	mensaje = mensaje & detalle_estado & "(a)"
end if	

if tcar_ccod <> "2" then
	mensaje = mensaje & " de la Carrera de "
else
	mensaje = mensaje & " de "
end if	

Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()
'lineas superiores
pdf.Line 8, 18, 204, 18 
pdf.Line 7, 17, 205, 17 
'lineas izquierdas
pdf.Line 7, 17, 7, 285
pdf.Line 8, 18, 8, 284
'lineas derechas
pdf.Line 204, 18, 204, 284
pdf.Line 205, 17, 205, 285
'lineas inferiores
pdf.Line 8, 284, 204, 284 
pdf.Line 7, 285, 205, 285

pdf.Image "../certificados_dae/imagenes/logo_upa.jpg", 14, 22, 20, 20, "JPG"
	pdf.ln(45)
pdf.SetFont "times","B",12
pdf.Cell 180,1,"CERTIFICADO DE ALUMNO","","","C"  
	pdf.ln(15)
pdf.Cell 180,1,"La Universidad del Pacífico :","","","L" 
	pdf.ln(15)
	pdf.SetFont "times","",12
pdf.Cell 180,1,"Certifica que el(la) Sr.(ita).                                    :","","","L"
	pdf.ln(15)
pdf.Cell 180,1,"R.u.t..                                                                      :","","","L"
pdf.ln(15)	
pdf.Cell 180,1,"                :","","","L"
	pdf.ln(15)
pdf.Cell 180,1,"Jornada                                                                   :","","","L"
	pdf.ln(15)
pdf.Cell 180,1,"Sede                                                                        :","","","L"
	pdf.ln(15)
pdf.MultiCell 180,5,"Se extiende el presente certificado ","","","L"
pdf.Image "../certificados_dae/imagenes/firma2.jpg", 117, 175, 80, 30, "JPG"
pdf.ln(40)
pdf.SetFont "times","B",12
pdf.Cell 180,1,"MARIA TERESA MERINO GAME","","","R"
	pdf.ln(5)
pdf.Cell 180,1,"JEFE REGISTRO CURRICULAR","","","R"
	pdf.ln(10)
pdf.SetFont "times","B",10
pdf.Cell 180,1,"Código de Validación :","","","C"
	pdf.ln(05)
	pdf.SetFont "times","",10
pdf.Cell 180,1,"Para validar este certificado diríjase a la página de la Universidad:","","","C"
	pdf.ln(05)
	pdf.SetFont "times","B",10
pdf.Cell 180,1,"http://www.upacifico.cl/validacion_certificados/valida.htm","","","C"
	pdf.ln(05)
	pdf.SetFont "times","",10
pdf.Cell 180,1,"Ingrese Rut del alumno y código de validación","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"(el certificado es Válido sólo si el mostrado en pantalla de validación es idéntico al que se encuentra en su poder).","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"Este certificado es válido hasta el .","","","C"
	pdf.ln(05)
pdf.Cell 195,1,"Santiago: Sede Las Condes: Av.Las Condes 11.121 - Campus Lyon: Av. R. Lyon 227 - Campus Baquedano: Av. Ramón Carnicer 65.","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"Melipilla : Sede Melipilla : Andrés Bello 0383 - Mall Leyán, Av. Serrano 395, Local 13, Planta Baja","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"Concepción: Oficina Concepción: Víctor Lamas 917, Edificio Horizonte.","","","C"
	pdf.ln(10)
pdf.Cell 180,1,".","","","C"
	pdf.ln(1)
pdf.Close()
pdf.Output()
%> 
