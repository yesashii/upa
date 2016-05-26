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
crit_ncorr =  request.QueryString("crit_ncorr")
preg_ncorr =  request.QueryString("preg_ncorr")
encu_ncorr =  request.QueryString("encu_ncorr")
preg_ccod =  request.QueryString("preg_ccod")
preg_tdesc=Ucase(request.QueryString("preg_tdesc"))
preg_norden = request.QueryString("preg_norden")

 if preg_ncorr <> "" then
   sql = "UPDATE preguntas SET preg_ccod='"&preg_ccod&"',preg_tdesc='"&preg_tdesc&"',preg_norden='"&preg_norden&"', audi_tusuario='"&Usuario&"', audi_fmodificacion=getDate() where cast(preg_ncorr as varchar)='"&preg_ncorr&"' and cast(crit_ncorr as varchar)= '"&crit_ncorr&"'"
 else
    preg_ncorr = conectar.consultaUno("execute obtenersecuencia 'preguntas'")	
	sql = "insert into preguntas (preg_ncorr,preg_ccod,preg_tdesc,preg_norden,crit_ncorr,audi_tusuario, audi_fmodificacion) values ("&preg_ncorr&",'"&preg_ccod&"','"&preg_tdesc&"',"&preg_norden&","&crit_ncorr&",'"&Usuario&"',getDate())"    
end if
'response.Write("consulta "&sql)
'response.End()
    conectar.EjecutaS(sql)
	
	Respuesta = conectar.ObtenerEstadoTransaccion()
	
if respuesta = true then
  session("mensajeerror")= "Pregunta ingresada con Éxito"
else
  session("mensajeerror")= "Error al guadar la Pregunta"
end if
%>

<script language="JavaScript" type="text/JavaScript">
   location.href = "m_preguntas2.asp?encu_ncorr="+<%=encu_ncorr%>+"&crit_ncorr="+<%=crit_ncorr%>;
  //close();
</script>

