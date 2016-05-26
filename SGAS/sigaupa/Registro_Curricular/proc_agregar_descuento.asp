<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "agregar_descuento.xml", "descuento"
f_descuentos.Inicializar conexion
f_descuentos.ProcesaForm
for filai = 0 to f_descuentos.CuentaPost - 1


post_ncorr = f_descuentos.ObtenerValorPost (filai, "post_ncorr")
stde_ccod = f_descuentos.ObtenerValorPost (filai, "stde_ccod")

if stde_ccod ="1402" then
pers_ncorr=conexion.ConsultaUno("select pers_ncorr from postulantes where post_ncorr="&post_ncorr&"")

tipo_alumno_cae=conexion.ConsultaUno("select protic.tipo_alumno_CAE ("&pers_ncorr&","&post_ncorr&")")
else
tipo_alumno_cae=""
end if

existe=conexion.ConsultaUno("select case count(post_ncorr) when 0 then 'N' else 'S' end from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod='"&stde_ccod&"'")
if existe="N" then


if stde_ccod ="1402" or stde_ccod="1544" or stde_ccod="1550"  or stde_ccod="1645" then 

 acre_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")
 'acre_ncorr=10000
 usu=negocio.obtenerUsuario
 
	p_insert="insert into alumno_credito(acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,tipo_alumno_cae) values("&acre_ncorr&","&post_ncorr&",'"&stde_ccod&"','"&usu&"','"&tipo_alumno_cae&"')"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conexion.ejecutaS (p_insert)

end if
end if
next
'response.End()
f_descuentos.MantieneTablas false
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>