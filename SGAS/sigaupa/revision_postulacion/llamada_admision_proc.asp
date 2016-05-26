<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
rut=request.Form("pers_nrut")
digito=request.Form("pers_xdv")
observacion=request.Form("observacion")
postulado_online=request.Form("postulado_online")
pers_tfono=request.Form("pers_tfono")
pers_temail=request.Form("pers_temail")
nombre_completo=request.Form("nombre_completo")

set conexion = new cconexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario=negocio.ObtenerUsuario()

	acumulativo = conexion.consultaUno("SELECT ISNULL(MAX(LADM_NCORR),0) + 1 FROM ADMI_LLAMADAS_ADMISION ")
	consulta_insert = "insert into ADMI_LLAMADAS_ADMISION (LADM_NCORR,PERS_NRUT,PERS_NXDV,NOMBRE_COMPLETO,PERS_TFONO,PERS_TEMAIL,observacion,postulado_online,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
	                  " values ("&acumulativo&","&rut&",'"&digito&"','"&nombre_completo&"','"&pers_tfono&"','"&pers_temail&"','"&observacion&"','"&postulado_online&"','"&usuario&"',getDate())"
	conexion.ejecutaS consulta_insert
	'response.Write(consulta_insert)

'response.End()
response.Redirect("llamada_admision.asp?busqueda[0][pers_nrut]="&rut&"&busqueda[0][pers_xdv]="&digito&"&grabar=1")
%>
