<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

Usuario = negocio.ObtenerUsuario
'----------------------------------------------------
encu_ncorr =  request.QueryString("encu_ncorr")
crit_ncorr =  request.QueryString("crit_ncorr")
crit_ccod =  request.QueryString("crit_ccod")
crit_tdesc=Ucase(request.QueryString("crit_tdesc"))
crit_norden = request.QueryString("crit_norden")

 if crit_ncorr <> "" then
   sql = "UPDATE criterios SET crit_ccod='"&crit_ccod&"',crit_tdesc='"&crit_tdesc&"',crit_norden='"&crit_norden&"', audi_tusuario='"&Usuario&"', audi_fmodificacion=getDate() where cast(crit_ncorr as varchar)='"&crit_ncorr&"' and cast(encu_ncorr as varchar) = '"&encu_ncorr&"'"
 else
    crit_ncorr = conectar.consultaUno("execute obtenersecuencia 'criterios'") 	 	
	sql = "insert into criterios (crit_ncorr,crit_ccod,crit_tdesc,crit_norden,encu_ncorr,audi_tusuario, audi_fmodificacion) values ("&crit_ncorr&",'"&crit_ccod&"','"&crit_tdesc&"',"&crit_norden&","&encu_ncorr&",'"&Usuario&"',getDate())"    
end if
'response.Write("consulta "&sql)
'response.End()
    conectar.EjecutaS(sql)
	
	Respuesta = conectar.ObtenerEstadoTransaccion()
	
if respuesta = true then
  session("mensajeerror")= "Críterio ingresado con Éxito"
else
  session("mensajeerror")= "Error al guadar el críterio"
end if
%>

<script language="JavaScript" type="text/JavaScript">
  opener.location.href = "m_criterios2.asp?encu_ncorr="+<%=encu_ncorr%>;
  close();
</script>

