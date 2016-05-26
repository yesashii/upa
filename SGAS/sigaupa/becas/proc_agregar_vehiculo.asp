<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario()

pers_ncorr=request.Form("pers_ncorr_pariente")
patente = request.Form("patente_vehiculo")
avaluo = request.Form("avaluo_vehiculo")
ano = request.Form("ano_vehiculo")
marca = request.Form("marca_vehiculo")
uso = request.Form("uso_vehiculo")

'response.Write("pers_ncorr "&pers_ncorr&" rol "&rol&" avaluo "&avaluo)
if pers_ncorr <> "" and patente <> "" then
	'buscar_ingresos = conexion.consultaUno("select count(*) from vehiculos_personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(vepe_npatente as varchar)='"&patente&"'")
	'if buscar_ingresos = 0 then 
	 vepe_ncorr=conexion.consultauno("execute obtenersecuencia 'vehiculos_personas'")
			consulta_insert = " Insert into vehiculos_personas (vepe_ncorr,pers_ncorr,vepe_npatente,vepe_tmarca,vepe_nano,vepe_navaluo,vepe_cuso,audi_tusuario,audi_fmodificacion)"&_
							  " values ("&vepe_ncorr&", "&pers_ncorr&",'"&patente&"','"&marca&"',"&ano&","&avaluo&","&uso&",'"&usuario&"',getDate())"
	
	'response.Write(consulta_insert)
	conexion.ejecutaS(consulta_insert)      
    'end if
end if	 
'response.End()           
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

