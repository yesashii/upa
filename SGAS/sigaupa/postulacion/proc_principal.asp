<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_pers_ncorr = Session("pers_ncorr")

if EsVacio(v_pers_ncorr) then
	Response.Redirect("denegado.asp")
end if

'-----------------------------------------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "desauas"

response.Write(v_pers_ncorr)


%>
