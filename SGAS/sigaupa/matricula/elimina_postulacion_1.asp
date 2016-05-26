<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion

set negocio2 = new CNegocio
negocio2.Inicializa conexion

'response.Write(" Sede :"&negocio2.ObtenerSede&" -> Post_ncorr:"&v_post_ncorr)


set f_postulacion = new CFormulario
f_postulacion.Carga_Parametros "postulacion_1.xml", "eliminar_postulacion"
f_postulacion.Inicializar conexion
f_postulacion.ProcesaForm
f_postulacion.MantieneTablas false


sql_carrera_pagan =" Select count(*) as total " & vbcrlf & _
				 " From detalle_postulantes a, ofertas_academicas b, especialidades c,carreras d,sedes e, " & vbcrlf & _
				 " ESTADO_EXAMEN_POSTULANTES G" & vbcrlf & _
				 " where a.ofer_ncorr = b.ofer_ncorr " & vbcrlf & _
				 " and b.espe_ccod = c.espe_ccod " & vbcrlf & _
				 " and c.carr_ccod = d.carr_ccod " & vbcrlf & _
				 " and b.sede_ccod =e.sede_ccod " & vbcrlf & _
				 " and A.EEPO_ccod = G.EEPO_ccod " & vbcrlf & _
				 " and a.post_ncorr ='"&v_post_ncorr&"'"&_
				 " And b.OFER_BPAGA_EXAMEN='S' "
v_carrera_pagan = conexion.consultaUno(sql_carrera_pagan)
'response.Write("<pre>"&sql_carrera_pagan&"</pre>")


if (v_carrera_pagan = 0) then
'response.Write("<br> aaa kiere eliminar el compromiso... Nooo!!!, hay que ofrecerle otra carrera...")
	' no tiene carreras que requieran pagos
	' entonces se eliminan sus compromisos
	pers_ncorr =conexion.consultauno("select pers_ncorr from postulantes where post_ncorr = '"&v_post_ncorr&"'")
	sql_anula_compromiso="Update compromisos Set ecom_ccod='3' "&_
						" Where tcom_ccod=15"&_
						" And ecom_ccod=1"&_
						" And sede_ccod="&negocio2.ObtenerSede&_
						" And pers_ncorr="&pers_ncorr
	'conexion.ejecutaS(sql_anula_compromiso)					
'response.Write("<pre>"&sql_anula_compromiso&"</pre>")
end if				 
'conexion.EstadoTransaccion false
'response.End()
'----------------------------------------------------------------------------------------------------------
Response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
