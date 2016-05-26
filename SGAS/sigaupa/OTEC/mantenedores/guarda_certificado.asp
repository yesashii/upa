<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'for each k in request.querystring
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next
'response.End()
pers_ncorr = request.QueryString("pers_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")
tipo = request.QueryString("tipo")
'response.Write(tdes_ccod)
set conexion = new cConexion
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

resto_mensaje= "para los fines que estime conveniente."

tipo_certificado = "Certificado OTEC"

correlativo = conexion.consultaUno("execute obtenerSecuencia 'CERTIFICADOS_EMITIDOS_OTEC'")


consulta_insert = " insert into CERTIFICADOS_EMITIDOS_OTEC (CEOT_NCORR,PERS_NCORR,DGSO_NCORR,CERT_TIPO,cert_motivo_ccod,cert_motivo,cert_fecha,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
				  " values ("&correlativo&","&pers_ncorr&","&dgso_ncorr&",'"&tipo_certificado&"',0,'"&resto_mensaje&"',getDate(),'"&negocio.obtenerUsuario&"',getDate())"

conexion.ejecutaS(consulta_insert)
if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "Se ha guardado correctamente la solicitud de certificado."
else
	conexion.MensajeError "Ha ocurrido un error al tratar de guardar el certificado."	
end if
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>

