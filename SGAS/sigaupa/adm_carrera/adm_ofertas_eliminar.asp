<!-- #include file="../biblioteca/_conexion.asp"-->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "andres.xml", "consulta"

'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.Form(x))
'next


set t_ofertas_academicas = new CFormulario
t_ofertas_academicas.Carga_Parametros "adm_ofertas_eliminar.xml", "t_ofertas_academicas"
t_ofertas_academicas.Inicializar conexion
'response.End()
t_ofertas_academicas.ProcesaForm

'---------------------------------------------------------------------------------------------------------------
nFilas = t_ofertas_academicas.CuentaPost
'response.Write("<br>filas:"&nFilas)
'response.End()
mensajeError = ""

for iFila = 0 to nFilas - 1

	if t_ofertas_academicas.ObtenerValorPost(iFila, "ofer_ncorr") <> "" then
		v_ofer_ncorr=t_ofertas_academicas.ObtenerValorPost(iFila, "ofer_ncorr")
		consulta = "SELECT count(*) AS cuenta FROM postulantes WHERE ofer_ncorr = " & t_ofertas_academicas.ObtenerValorPost(iFila, "ofer_ncorr")
		f_consulta.Inicializar conexion
		f_consulta.Consultar consulta
		f_consulta.Siguiente
		cuenta = CInt(f_consulta.ObtenerValor("cuenta"))
    		
		consulta = "SELECT count(*) AS cuenta FROM alumnos WHERE ofer_ncorr = " & t_ofertas_academicas.ObtenerValorPost(iFila, "ofer_ncorr") & " AND emat_ccod = 1"			
		f_consulta.Inicializar conexion
		f_consulta.Consultar consulta
		f_consulta.Siguiente
		cuenta = cuenta + CInt(f_consulta.ObtenerValor("cuenta"))
		
		if cuenta > 0 then		
			v_jorn_tdesc = conexion.ConsultaUno("select jorn_tdesc from ofertas_academicas a, jornadas b where a.jorn_ccod = b.jorn_ccod and a.ofer_ncorr = '" & t_ofertas_academicas.ObtenerValorPost(iFila, "ofer_ncorr") & "'")		
			t_ofertas_academicas.EliminaFilaPost iFila
	
			mensajeError = mensajeError & " No se puede eliminar la oferta para jornada " & v_jorn_tdesc & ",\n porque tiene postulaciones asociadas o alumnos matriculados.\n\n"			
			
		else
			sentencia = "UPDATE aranceles SET aran_cvigente_fup = 'N' WHERE ofer_ncorr = " &v_ofer_ncorr
			sql_elimina_arancel	=	" Delete from ARANCELES where OFER_NCORR ="&v_ofer_ncorr
			sql_elimina_oferta	=	" Delete from OFERTAS_ACADEMICAS where OFER_NCORR ="&v_ofer_ncorr

			conexion.EstadoTransaccion conexion.EjecutaS (sql_elimina_arancel)
			conexion.EstadoTransaccion conexion.EjecutaS (sql_elimina_oferta)
			conexion.EstadoTransaccion conexion.EjecutaS (sentencia)
		end if

	end if
	
next

if mensajeError<>"" then
	Session("mensaje_error") = mensajeError
else
	Session("mensaje_error") = "La o las ofertas fueron eliminadas correctamente"
end if

't_ofertas_academicas.MantieneTablas true
'response.Write("<br>"&conexion.ObtenerEstadoTransaccion)
'---------------------------------------------------------------------------------------------------------------
'conexion.EstadoTransaccion false
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
