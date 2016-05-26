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
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm

v_sede_ccod = variables.ObtenerValor("oferta", 0, "sede_ccod")
v_espe_ccod = variables.ObtenerValor("oferta", 0, "espe_ccod")
v_jorn_ccod = variables.ObtenerValor("oferta", 0, "jorn_ccod")
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
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

v_estado_examen=conexion.consultaUno("select ofer_bpaga_examen from ofertas_academicas where ofer_ncorr="&v_ofer_ncorr)

sql_tip_carr = " Select tcar_ccod from ofertas_academicas a, especialidades b,carreras c " & vbcrlf & _
    				" where cast(ofer_ncorr as varchar)='" & v_ofer_ncorr & "' " & vbcrlf & _
    				" and a.espe_ccod=b.espe_ccod " & vbcrlf & _
    				" and b.carr_ccod=c.carr_ccod "

tipo_carrera = conexion.ConsultaUno(sql_tip_carr)					
if v_estado_examen="N" then
	v_eepo_ccod=5 ' no rinde examen
else
	v_eepo_ccod=1
end if

if	tipo_carrera = "2"	 then ' carreras de postgrado
 	v_eepo_ccod=1 ' todos rinden examen para ser aprobados	
end if 	

f_postulacion.AgregaCampoPost "post_ncorr", v_post_ncorr
f_postulacion.AgregaCampoPost "ofer_ncorr", v_ofer_ncorr
f_postulacion.AgregaCampoPost "eepo_ccod", v_eepo_ccod
f_postulacion.AgregaCampoPost "FECHA_ASIGNACION_CARRERA",conexion.consultaUno("select protic.trunc(getDate())")
f_postulacion.MantieneTablas false

ip_g = Request.ServerVariables("REMOTE_ADDR")
ip_e = Request.ServerVariables("REMOTE_ADDR")
c_ip_postulacion = " insert into IP_POSTULACIONES (POST_NCORR,OFER_NCORR,IP_GENERAL,IP_ESPECIFICA,OPCION,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
                   " values ("&v_post_ncorr&","&v_ofer_ncorr&",'"&ip_g&"','"&ip_e&"','SGA','ADMINISTRATIVO',getDate())"
'response.Write(c_ip_postulacion)
'response.End()
conexion.ejecutaS c_ip_postulacion

'conexion.EstadoTransaccion false
'response.End()
'----------------------------------------------------------------------------------------------------------
Response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
