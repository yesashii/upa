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
minr_ncorr =  request.QueryString("minr_ncorr")
minr_tdesc =  request.QueryString("minr_tdesc")
carr_ccod  = request.QueryString("carr_ccod")

 if minr_ncorr <> "" then
   sql = " UPDATE minors SET minr_tdesc = '"&minr_tdesc &"',carr_ccod='"&carr_ccod&"', audi_tusuario='"&Usuario&"', audi_fmodificacion=getDate() where cast(minr_ncorr as varchar)= '"&minr_ncorr&"' "
 else
    minr_ncorr = conectar.consultaUno("execute obtenersecuencia 'minors'") 	
	sql = "insert into minors (minr_ncorr,minr_tdesc,carr_ccod,audi_tusuario, audi_fmodificacion) values ("&minr_ncorr&",'"&minr_tdesc&"','"&carr_ccod&"','"&Usuario&"',getDate())"    
   ' response.Write(sql & "<BR><BR>")
	'response.End()
end if
    
	'response.Write(sql & "<BR><BR>")
	'response.End()

    conectar.EjecutaS(sql)
	
	Respuesta = conectar.ObtenerEstadoTransaccion()
    'response.Write(Respuesta) 
	
if respuesta = true then
  session("mensajeerror")= "Minor creado con Éxito"
else
  session("mensajeerror")= "Error al crear el Minor"
end if
%>

<script language="JavaScript" type="text/JavaScript">
  opener.location.href = "m_minors.asp";
  close();
</script>

