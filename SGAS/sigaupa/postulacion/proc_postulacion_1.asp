<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion

set variables = new CVariables
variables.ProcesaForm

v_sede_ccod = variables.ObtenerValor("oferta", 0, "sede_ccod")
v_espe_ccod = variables.ObtenerValor("oferta", 0, "espe_ccod")
v_jorn_ccod = variables.ObtenerValor("oferta", 0, "jorn_ccod")
v_peri_ccod = session("periodo_postulacion")'negocio.ObtenerPeriodoAcademico("POSTULACION")
v_post_ncorr = Session("post_ncorr")


'--------------------------------------------------------------------------------------------------------		   
'consulta = "select b.ofer_ncorr " & vbCrLf &_
'           "from postulantes a, ofertas_academicas b " & vbCrLf &_
'		   "where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
'		   "  and b.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
'		   "  and b.espe_ccod = '" & v_espe_ccod & "' " & vbCrLf &_
'		   "  and b.jorn_ccod = '" & v_jorn_ccod & "' " & vbCrLf &_
'		   "  and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "  and a.post_ncorr = '" & v_post_ncorr & "'"

consulta = "select b.ofer_ncorr " & vbCrLf &_
           "from postulantes a, ofertas_academicas b, aranceles c, especialidades d " & vbCrLf &_
		   "where a.post_bnuevo = b.post_bnuevo " & vbCrLf &_
		   "  and b.espe_ccod = d.espe_ccod " & vbCrLf &_
		   "  and b.aran_ncorr = c.aran_ncorr " & vbCrLf &_
		    "  and c.aran_nano_ingreso in (select case a.post_bnuevo" & vbCrLf &_
		   "								when 'S' then c.aran_nano_ingreso" & vbCrLf &_
		   "								else protic.ano_ingreso_carrera(a.pers_ncorr, d.carr_ccod)" & vbCrLf &_
		   "								end)" & vbCrLf &_
		   "  and b.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "  and b.espe_ccod = '" & v_espe_ccod & "' " & vbCrLf &_
		   "  and b.jorn_ccod = '" & v_jorn_ccod & "' " & vbCrLf &_
		   "  and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and a.post_ncorr = '" & v_post_ncorr & "'"

v_ofer_ncorr = conexion.ConsultaUno(consulta)

if EsVacio(v_ofer_ncorr) then
	Session("mensajeError") = "No existe la oferta académica elegida."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
end if

'-------------------------------------------------------------------------------------------------------
set f_postulacion = new CFormulario
f_postulacion.Carga_Parametros "postulacion_1.xml", "postulacion"
f_postulacion.Inicializar conexion

f_postulacion.CreaFilaPost


f_postulacion.AgregaCampoPost "post_ncorr", v_post_ncorr
f_postulacion.AgregaCampoPost "ofer_ncorr", v_ofer_ncorr
f_postulacion.AgregaCampoPost "eepo_ccod", "1"
f_postulacion.AgregaCampoPost "FECHA_ASIGNACION_CARRERA",conexion.consultaUno("select getDate()")
f_postulacion.MantieneTablas false

ip_g = Request.ServerVariables("REMOTE_ADDR")
ip_e = Request.ServerVariables("REMOTE_ADDR")
c_ip_postulacion = " insert into IP_POSTULACIONES (POST_NCORR,OFER_NCORR,IP_GENERAL,IP_ESPECIFICA,OPCION,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
                   " values ("&v_post_ncorr&","&v_ofer_ncorr&",'"&ip_g&"','"&ip_e&"','SGA POSTULANTE','POSTULANTE',getDate())"
'response.Write(c_ip_postulacion)
'response.End()
conexion.ejecutaS c_ip_postulacion

'conexion.EstadoTransaccion false
'----------------------------------------------------------------------------------------------------------
Response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
