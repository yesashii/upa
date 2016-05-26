<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
mensaje=""
for each k in request.form
        SQL1 = "Select case count(*) when 0 then 'N' else 'S' end from secciones_otec where cast(maot_ncorr as varchar)='"&request.Form(k)&"'"
		con_seccion = conectar.consultaUno(SQL1)
		if con_seccion = "N" then 
			SQL="DELETE mallas_otec WHERE cast(maot_ncorr as varchar)='"&request.Form(k)&"'"
			conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		else
			mensaje = "Imposible eliminar la(s) asignatura(s) de la malla, pertenecen a una planificación ya registrada"
		end if	
next
if mensaje <> "" then
	msj_error = mensaje
end if	
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
