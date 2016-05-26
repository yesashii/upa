<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'response.End()
'-----------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

Usuario = negocio.ObtenerUsuario
'----------------------------------------------------
minr_ncorr =  request.QueryString("minr_ncorr")
mall_ccod =  request.QueryString("a[0][mall_ccod]")

 if minr_ncorr <> "" and mall_ccod <> "" then
    sql = "insert into asignaturas_minor (minr_ncorr,mall_ccod,audi_tusuario, audi_fmodificacion) values ("&minr_ncorr&","&mall_ccod&",'"&Usuario&"',getDate())"    
end if
    
	'response.Write(sql & "<BR><BR>")
	'response.End()

    conectar.EjecutaS(sql)
	
	Respuesta = conectar.ObtenerEstadoTransaccion()
    'response.Write(Respuesta) 
	
if respuesta = true then
  session("mensajeerror")= "La Asignatura fue agregada correctamente al Minor"
else
  session("mensajeerror")= "Error agregar la asignatura al Minor"
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>



