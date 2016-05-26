<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next



v_area_ccod			=	request.Form("em[0][area_ccod]")
if v_area_ccod="" then
	v_area_ccod			=	request.Form("em[0][cod_area]")
end if
v_area_tdesc		=	request.Form("em[0][area_tdesc]")
v_inserta			=	request.Form("inserta")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

if v_inserta ="1" then
'obtiene secuencia
	
	sql_area= " Insert Into presupuesto_upa.protic.area_presupuestal (area_ccod, area_tdesc, audi_tusuario, audi_fmodificacion) " &_
				" Values ("&v_area_ccod&", '"&v_area_tdesc&"', '"&v_usuario&"', getdate())"
else
	sql_area= " Update presupuesto_upa.protic.area_presupuestal set area_tdesc='"&v_area_tdesc&"', audi_tusuario='cambia "&v_usuario&"', audi_fmodificacion=getdate() "&_
				" where area_ccod="&v_area_ccod
end if

v_estado_transaccion=conexion2.ejecutaS(sql_area)

if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="El area presupuestal no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La area presupuestal fue ingresada correctamente."
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	self.opener.location.reload();
	window.close();
</script>
