<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "genera_contrato_2.xml", "descuentos"
f_descuentos.Inicializar conexion
f_descuentos.ProcesaForm
for filai = 0 to f_descuentos.CuentaPost - 1


post_ncorr = f_descuentos.ObtenerValorPost (filai, "post_ncorr")
stde_ccod = f_descuentos.ObtenerValorPost (filai, "stde_ccod")



existe=conexion.ConsultaUno("select case count(post_ncorr) when 0 then 'N' else 'S' end from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod='"&stde_ccod&"'")

if stde_ccod ="1402" or stde_ccod="1544" or stde_ccod="1550"  or stde_ccod="1645" then

 'acre_ncorr=10000
 'usu=negocio.obtenerUsuario
 
	p_delete="delete  from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod='"&stde_ccod&"'"		  
	'response.Write("<pre>"&p_delete&"</pre>")
	conexion.ejecutaS (p_delete)

end if
next
f_descuentos.MantieneTablas false

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
