<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

rut_persona	= request.QueryString("rut_persona")
'**************************'	
'**		BUSQUEDA		 **'
'**************************'------------------------
pers_ncorr   = conexion.consultaUno("select pers_ncorr from alumni_personas where cast(pers_nrut as varchar)='"&rut_persona&"'")
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG
if pers_ncorr <> "" then
	response.write("ok")
else
	response.write("x")
end if
'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
%>