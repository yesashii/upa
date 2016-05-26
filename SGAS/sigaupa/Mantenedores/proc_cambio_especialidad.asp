<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.form(x))
'next
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

		set f_datos_antiguos = new CFormulario
		f_datos_antiguos.Carga_Parametros "consulta.xml", "consulta"

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "adm_cambio_especialidad.xml", "alumno"
f_alumno.Inicializar conexion
f_alumno.ProcesaForm

for fila = 0 to f_alumno.CuentaPost - 1
	'response.Write("<hr>entro")
	v_matricula = f_alumno.ObtenerValorPost (fila, "matr_ncorr")
	v_espe_ccod = f_alumno.ObtenerValorPost (fila, "especialidad")
	v_plan_ccod = f_alumno.ObtenerValorPost (fila, "plan_ccod")
	
	especialidad_antigua = conexion.consultaUno("select espe_ccod from alumnos a, ofertas_academicas b where cast(matr_ncorr as varchar)='"&v_matricula&"' and a.ofer_ncorr=b.ofer_ncorr")
	plan_antiguo = conexion.consultaUno("select isnull(plan_ccod,0) from alumnos where cast(matr_ncorr as varchar)='"&v_matricula&"'")
    'Si la especialidad se mantiene solo debemos cambiar el plan de estudios 
	if  cint(v_plan_ccod) <> cint(plan_antiguo) then
		insert_alumno = " update alumnos set plan_ccod="&v_plan_ccod&" where cast(matr_ncorr as varchar)='"&v_matricula&"'"
		conexion.ejecutaS(insert_alumno)
		'response.Write(insert_alumno &"<br>")
		
	end if
	'response.Write("---->v_espe_ccod "&v_espe_ccod&" especialidad_antigua "&especialidad_antigua&"<br>")
	if v_espe_ccod <> especialidad_antigua then
	' obtengo algunos datos antiguos
	f_datos_antiguos.Inicializar conexion
	sql_datos_antiguos= " select c.aran_nano_ingreso,b.peri_ccod,a.post_ncorr,a.ofer_ncorr, b.jorn_ccod,b.sede_ccod " & vbCrLf &_
						" from alumnos a, ofertas_academicas b, aranceles c " & vbCrLf &_
						" where cast(matr_ncorr as varchar)='"&v_matricula&"'" & vbCrLf &_
						" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
						" and b.ofer_ncorr=c.ofer_ncorr "
	'response.Write("<br><pre>"&sql_datos_antiguos&"</pre>")
	
	f_datos_antiguos.consultar sql_datos_antiguos
	f_datos_antiguos.siguiente
	
	v_ano_ingreso	=	f_datos_antiguos.ObtenerValor("aran_nano_ingreso")
	v_peri_ccod		=	f_datos_antiguos.ObtenerValor("peri_ccod")
	v_pos_ncorr		=	f_datos_antiguos.ObtenerValor("post_ncorr")
	v_ofer_antigua	=	f_datos_antiguos.ObtenerValor("ofer_ncorr")
	v_jornada		=	f_datos_antiguos.ObtenerValor("jorn_ccod")
	v_sede		    =	f_datos_antiguos.ObtenerValor("sede_ccod")
	'-------------------------------------en caso de no tener asociado un arancel para la oferta academica---------------
	'-------------------------------------------Generado por Msandova 15-02-2005-----------------------------------------
	num_antiguos=f_datos_antiguos.nroFilas
'num_antiguos=0
	if num_antiguos = 0 then
		v_pers_ncorr = conexion.consultaUno("Select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&v_matricula&"'") 
		consulta = " select top 1 min(b.peri_ccod)as periodo " & vbCrLf &_ 
		           " from postulantes a, periodos_academicos b " & vbCrLf &_
				   " where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' " & vbCrLf &_
				   " and a.peri_ccod=b.peri_ccod order by periodo asc"
		primer_periodo = conexion.consultaUno(consulta)
		'response.Write("<pre>"&consulta&"</pre>")
		primer_ano = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)= '"&primer_periodo&"'")
        'response.Write("<hr><center>Entre acá "& primer_ano&"</center><hr>")
		sql_datos_antiguos= " select top 1 "&primer_ano&" as aran_nano_ingreso,b.peri_ccod,a.post_ncorr,a.ofer_ncorr, b.jorn_ccod,b.sede_ccod " & vbCrLf &_
						" from alumnos a, ofertas_academicas b" & vbCrLf &_
						" where cast(matr_ncorr as varchar)='"&v_matricula&"'" & vbCrLf &_
						" and a.ofer_ncorr=b.ofer_ncorr " 
		'response.Write("<br><pre>"&sql_datos_antiguos&"</pre>")
		f_datos_antiguos.consultar sql_datos_antiguos
		f_datos_antiguos.siguiente
	
		v_ano_ingreso	=	f_datos_antiguos.ObtenerValor("aran_nano_ingreso")
		v_peri_ccod		=	f_datos_antiguos.ObtenerValor("peri_ccod")
		v_pos_ncorr		=	f_datos_antiguos.ObtenerValor("post_ncorr")
		v_ofer_antigua	=	f_datos_antiguos.ObtenerValor("ofer_ncorr")
		v_jornada		=	f_datos_antiguos.ObtenerValor("jorn_ccod")
		v_sede		    =	f_datos_antiguos.ObtenerValor("sede_ccod")
		
	end if 
	'--------------------------------------------------------------fin---------------------------------------------------
	'response.Write("Jornada :"&v_jornada)
	' obtengo la oferta academica
	plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
	if plec_ccod = "1" then
		filtro_activa = " and a.OFER_BACTIVA <> 'N'"
	else
		filtro_activa = ""
	end if
	sql_obtiene_oferta= " select  a.ofer_ncorr from ofertas_academicas a, aranceles b " & vbCrLf &_
						" where cast(a.espe_ccod as varchar)='"&v_espe_ccod&"' " & vbCrLf &_
						" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' " & vbCrLf &_
						" and cast(a.jorn_ccod as varchar)='"&v_jornada&"' " & vbCrLf &_
						" and cast(a.sede_ccod as varchar)='"&v_sede&"' " & vbCrLf &_
						" and a.ofer_ncorr=b.ofer_ncorr "&filtro_activa & vbCrLf &_
						" and cast(b.aran_nano_ingreso as varchar)='"&v_ano_ingreso&"' "
   ' response.Write("<pre>"&sql_obtiene_oferta&"</pre>")
	'response.End()
	'-----------------------------------------------en caso de no coincidir los aranceles con las ofertas----------
	if num_antiguos = 0 then
	sql_obtiene_oferta= " select  a.ofer_ncorr from ofertas_academicas a, periodos_academicos b " & vbCrLf &_
						" where cast(a.espe_ccod as varchar)='"&v_espe_ccod&"' " & vbCrLf &_
						" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' " & vbCrLf &_
						" and cast(a.jorn_ccod as varchar)='"&v_jornada&"' " & vbCrLf &_
						" and cast(a.sede_ccod as varchar)='"&v_sede&"' " & vbCrLf &_
						" and a.peri_ccod=b.peri_ccod "& filtro_activa & vbCrLf &_
						" and cast(b.anos_ccod as varchar)='"&v_ano_ingreso&"' "
	end if
	'---------------------------------------------------------------Fin--------------------------------------------						
	'response.Write("<br><pre>"&sql_obtiene_oferta&"</pre>")
	'response.End()
	v_nueva_oferta=conexion.ConsultaUno(sql_obtiene_oferta)					
	if v_nueva_oferta<>"" then
		
		'response.Write("<h3>Cambiar oferta y especialidad </h3>")
		
		sql_actualiza_oferta	=	"update alumnos set ofer_ncorr="&v_nueva_oferta&" where matr_ncorr="&v_matricula
		sql_actualiza_det_pos	=	"update DETALLE_POSTULANTES set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_pos		=	"update POSTULANTES set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_sdes		=	"update SDESCUENTOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_sdet		=	"update SDETALLES_FORMA_PAGO set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_spag		=	"update SPAGOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_sdet_pag	=	"update SDETALLES_PAGOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_spase		=	"update PASE_MATRICULA set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_scarg		=	"update CARGOS_CONVALIDACION set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		
		'response.Write(sql_actualiza_oferta&"<br>"&sql_actualiza_det_pos&"<br>"&sql_actualiza_pos&"<br>"&sql_actualiza_sdet&"<br>"&sql_actualiza_sdes&"<br>"&sql_actualiza_spag&"<br>"&sql_actualiza_sdet_pag)
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from alumnos where cast(plan_ccod as varchar)='"&v_plan_ccod&"' and cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(matr_ncorr as varchar)='"&v_matricula&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutas(sql_actualiza_oferta)
		end if
		'response.Write(conexion.obtenerEstadoTransaccion)
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from detalle_postulantes where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutaS(sql_actualiza_det_pos)
		end if	
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from postulantes where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
		conexion.ejecutaS(sql_actualiza_pos)
		end if
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from SDESCUENTOS where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutaS(sql_actualiza_sdes)
		end if
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from SDETALLES_FORMA_PAGO where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutaS(sql_actualiza_spag)
		end if
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from CARGOS_CONVALIDACION where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutaS(sql_actualiza_sdet_pag)
		end if
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from PASE_MATRICULA where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutaS(sql_actualiza_spase)
		end if
		cantidad_prueba = conexion.consultaUno("Select isnull(count(*),0) from PASE_MATRICULA where cast(ofer_ncorr as varchar)='"&v_nueva_oferta&"' and cast(post_ncorr as varchar)='"&v_pos_ncorr&"'")
		if cantidad_prueba = "0" then
			conexion.ejecutaS(sql_actualiza_scarg)
		end if
		'response.Write(conexion.obtenerEstadoTransaccion)
		if conexion.obtenerEstadoTransaccion=true then
			session("mensaje_error")="La especialidad fue modificada correctamente"
		end if
		'response.End()
	else
		session("mensaje_error")="No existe una oferta para este periodo asociada a la especialidad elegida."
	end if
	'response.Write("<hr>"&sql_obtiene_oferta&"<br><br>nueva oferta:"&v_nueva_oferta)					
end if
next


f_alumno.MantieneTablas false
'response.Write(conexion.obtenerEstadoTransaccion)
'response.end()
'------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
