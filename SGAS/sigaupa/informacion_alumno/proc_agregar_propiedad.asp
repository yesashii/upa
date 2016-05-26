<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario()

pers_ncorr=request.Form("pers_ncorr_pariente")
rol = request.Form("rol_propiedad")

avaluo = request.Form("avaluo_propiedad")
'response.Write("pers_ncorr "&pers_ncorr&" rol "&rol&" avaluo "&avaluo)
if pers_ncorr <> "" and rol <> "" then
	'buscar_ingresos = conexion.consultaUno("select count(*) from propiedades_personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(prpe_nrol as varchar)='"&rol&"'")
	'if buscar_ingresos = 0 then 
	        prpe_ncorr=conexion.consultauno("execute obtenersecuencia 'propiedades_personas'")
		  	consulta_insert = " Insert into propiedades_personas (prpe_ncorr,pers_ncorr,prpe_nrol,prpe_navaluo,audi_tusuario,audi_fmodificacion)"&_
							  " values ( "&prpe_ncorr&","&pers_ncorr&",'"&rol&"',"&avaluo&",'"&usuario&"',getDate())"
	'response.Write(consulta_insert)
	'response.End()
	conexion.ejecutaS(consulta_insert)      
    'end if
end if	 
'response.End()           
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

