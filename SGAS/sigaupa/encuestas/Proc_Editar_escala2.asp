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
resp_ncorr =  request.QueryString("resp_ncorr")
resp_ccod =  request.QueryString("resp_ccod")
resp_tabrev =  request.QueryString("resp_tabrev")
resp_tdesc=Ucase(request.QueryString("resp_tdesc"))
resp_nnota =  request.QueryString("resp_nnota")
resp_bpondera =  request.QueryString("resp_bpondera")
resp_norden = request.QueryString("resp_norden")

'response.Write("ncorr= "&encu_ncorr&"<br>resp_ncorr="&resp_ncorr&"<br>ccod="&resp_ccod&"<br>tabrev="&resp_tabrev&"<br>tdesc="& resp_tdesc&"<br>nnota="&resp_nnota&"<br>bpondera="&resp_bpondera&"<br>norden="&resp_norden)
'response.End()
 if resp_ncorr <> "" then
   sql = "UPDATE respuestas SET resp_ccod='"&resp_ccod&"',resp_tabrev='"&resp_tabrev&"',resp_tdesc='"&resp_tdesc&"',resp_nnota="&resp_nnota&",resp_bpondera='"&resp_bpondera&"',resp_norden='"&resp_norden&"', audi_tusuario='"&Usuario&"', audi_fmodificacion=getDate() where cast(resp_ncorr as varchar)='"&resp_ncorr&"' and cast(encu_ncorr as varchar)= '"&encu_ncorr&"'"
 else
    resp_ncorr =  conectar.consultaUno("execute obtenersecuencia 'respuestas'") 	
	sql = "insert into respuestas (resp_ncorr,encu_ncorr,resp_ccod,resp_tabrev,resp_tdesc,resp_nnota,resp_bpondera,resp_norden,audi_tusuario, audi_fmodificacion) values ("&resp_ncorr&","&encu_ncorr&",'"&resp_ccod&"','"&resp_tabrev&"','"&resp_tdesc&"',"&resp_nnota&",'"&resp_bpondera&"',"&resp_norden&",'"&Usuario&"',getDate())"    
end if
'response.Write(sql)
'response.End()
    conectar.EjecutaS(sql)
	
	Respuesta = conectar.ObtenerEstadoTransaccion()
	
if respuesta = true then
  session("mensajeerror")= "Escala ingresada con Éxito"
else
  session("mensajeerror")= "Error al guadar la Escala"
end if
%>

<script language="JavaScript" type="text/JavaScript">
  opener.location.href = "m_escala2.asp?encu_ncorr="+<%=encu_ncorr%>;
  close();
</script>

