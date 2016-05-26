<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.form(x))
'next


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

	' obtengo algunos datos antiguos
	f_datos_antiguos.Inicializar conexion
	sql_datos_antiguos= " select c.aran_nano_ingreso,b.peri_ccod,a.post_ncorr,a.ofer_ncorr, b.jorn_ccod " & vbCrLf &_
						" from alumnos a, ofertas_academicas b, aranceles c " & vbCrLf &_
						" where cast(matr_ncorr as varchar)='"&v_matricula&"'" & vbCrLf &_
						" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
						" and b.ofer_ncorr=c.ofer_ncorr "
	'response.Write("Jornada :"&sql_datos_antiguos)
	f_datos_antiguos.consultar sql_datos_antiguos
	f_datos_antiguos.siguiente
	
	v_ano_ingreso	=	f_datos_antiguos.ObtenerValor("aran_nano_ingreso")
	v_peri_ccod		=	f_datos_antiguos.ObtenerValor("peri_ccod")
	v_pos_ncorr		=	f_datos_antiguos.ObtenerValor("post_ncorr")
	v_ofer_antigua	=	f_datos_antiguos.ObtenerValor("ofer_ncorr")
	v_jornada		=	f_datos_antiguos.ObtenerValor("jorn_ccod")
	'response.Write("Jornada :"&v_jornada)
	' obtengo la oferta academica
	sql_obtiene_oferta= " select  a.ofer_ncorr from ofertas_academicas a, aranceles b " & vbCrLf &_
						" where cast(a.espe_ccod as varchar)='"&v_espe_ccod&"' " & vbCrLf &_
						" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' " & vbCrLf &_
						" and cast(a.jorn_ccod as varchar)='"&v_jornada&"' " & vbCrLf &_
						" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
						" and cast(b.aran_nano_ingreso as varchar)='"&v_ano_ingreso&"' "
	v_nueva_oferta=conexion.ConsultaUno(sql_obtiene_oferta)					
	if v_nueva_oferta<>"" then
		
		'response.Write("<h3>Cambiar oferta y especialidad </h3>")
		
		sql_actualiza_oferta	=	"update alumnos set plan_ccod='"&v_plan_ccod&"', ofer_ncorr="&v_nueva_oferta&" where matr_ncorr="&v_matricula
		sql_actualiza_det_pos	=	"update DETALLE_POSTULANTES set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_pos		=	"update POSTULANTES set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_sdes		=	"update SDESCUENTOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_sdet		=	"update SDETALLES_FORMA_PAGO set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_spag		=	"update SPAGOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_sdet_pag	=	"update SDETALLES_PAGOS set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_spase		=	"update PASE_MATRICULA set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		sql_actualiza_scarg		=	"update CARGOS_CONVALIDACION set ofer_ncorr='"&v_nueva_oferta&"' where post_ncorr='"&v_pos_ncorr&"'"
		
		'response.Write(sql_actualiza_oferta&"<br>"&sql_actualiza_det_pos&"<br>"&sql_actualiza_pos&"<br>"&sql_actualiza_sdet&"<br>"&sql_actualiza_sdes&"<br>"&sql_actualiza_spag&"<br>"&sql_actualiza_sdet_pag)
		conexion.ejecutas(sql_actualiza_oferta)
		'response.Write(conexion.obtenerEstadoTransaccion)
		conexion.ejecutaS(sql_actualiza_det_pos)
		conexion.ejecutaS(sql_actualiza_pos)
		conexion.ejecutaS(sql_actualiza_sdes)
		conexion.ejecutaS(sql_actualiza_spag)
		conexion.ejecutaS(sql_actualiza_sdet_pag)
		conexion.ejecutaS(sql_actualiza_spase)
		conexion.ejecutaS(sql_actualiza_scarg)
		
		'response.Write(conexion.obtenerEstadoTransaccion)
		if conexion.obtenerEstadoTransaccion=true then
			session("mensaje_error")="La especialidad fue modificada correctamente"
		end if
		
	else
		session("mensaje_error")="No existe una oferta para este periodo asociada a la especialidad elegida."
	end if
	'response.Write("<hr>"&sql_obtiene_oferta&"<br><br>nueva oferta:"&v_nueva_oferta)					
next


f_alumno.MantieneTablas false
'response.Write(conexion.obtenerEstadoTransaccion)
'response.end()
'------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
