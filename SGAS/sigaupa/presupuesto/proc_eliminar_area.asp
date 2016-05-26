<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

for i=0 to 9 
	indice=i
	cod_area=request.Form("em["&i&"][cod_area]")
	if cod_area <> "" then
		
		sql_existe="select count(*) from presupuesto_upa.protic.area_presupuesto_usuario where area_ccod="&cod_area
		v_existe=conexion2.ConsultaUno(sql_existe)
		
		if v_existe=0 then
			sql_elimina="delete from presupuesto_upa.protic.area_presupuestal where area_ccod="&cod_area
			v_estado_transaccion=conexion2.ejecutaS(sql_elimina)
		else
			msg_asocia="\nUna o mas areas selecconadas aun presentan Usuarios asociados. Asegurece de eliminar este vinculo antes de eliminarla."
		end if
		
	end if
next

if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="El area presupuestal no pudo ser eliminada correctamente.\nVuelva a intentarlo."&msg_asocia
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="El area presupuestal fue eliminada correctamente."&msg_asocia
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//	self.location.reload();
//	window.close();
</script>
