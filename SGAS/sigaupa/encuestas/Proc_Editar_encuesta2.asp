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
encu_ccod =  request.QueryString("codigo")
encu_tnombre=request.QueryString("nombre")
encu_ttitulo = Ucase(request.QueryString("titulo"))
encu_tinstruccion = Ucase(request.QueryString("instrucciones"))
encu_factivacion =  request.QueryString("dia_activacion") & "/" & request.QueryString("mes_activacion") & "/" &  request.QueryString("ano_activacion")
encu_fexpiracion =  request.QueryString("dia_expiracion") & "/" & request.QueryString("mes_expiracion") & "/" &  request.QueryString("ano_expiracion")

 if encu_ncorr <> "" then
   sql = "UPDATE encuestas SET encu_ccod='"&encu_ccod&"',encu_tnombre='"&encu_tnombre&"',encu_ttitulo='"&encu_ttitulo&"', encu_tinstruccion ='"&encu_tinstruccion&"' , encu_factivacion = convert(datetime,'"&encu_factivacion&"',103), encu_fexpiracion = convert(datetime,'"&encu_fexpiracion&"',103), audi_tusuario='"&Usuario&"', audi_fmodificacion=getDate() where cast(encu_ncorr as varchar)= '"&encu_ncorr&"' "
 else
    encu_ncorr = conectar.consultaUno("execute obtenersecuencia 'encuestas'") 	
	sql = "insert into encuestas (encu_ncorr,encu_ccod,encu_tnombre,encu_ttitulo,encu_tinstruccion,encu_fcreacion,encu_factivacion,encu_fexpiracion, audi_tusuario, audi_fmodificacion) values ("&encu_ncorr&",'"&encu_ccod&"','"&encu_tnombre&"','"&encu_ttitulo&"','"&encu_tinstruccion&"',getDate(),convert(datetime,'"&encu_factivacion&"',103),convert(datetime,'"&encu_fexpiracion&"',103),'"&Usuario&"',getDate())"    
   ' response.Write(sql & "<BR><BR>")
	'response.End()
end if
    
	'response.Write(sql & "<BR><BR>")
	'response.End()

    conectar.EjecutaS(sql)
	
	Respuesta = conectar.ObtenerEstadoTransaccion()
    'response.Write(Respuesta) 
	
if respuesta = true then
  session("mensajeerror")= "Encuesta creada con Éxito"
else
  session("mensajeerror")= "Error al crear la encuesta"
end if
%>

<script language="JavaScript" type="text/JavaScript">
  opener.location.href = "m_encuestas2.asp";
  close();
</script>

