<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr=request.Form("pers_ncorr")
carr_ccod=request.Form("carr_ccod")
plan_ccod=request.Form("plan_ccod")

grabado = conexion.consultaUno("select count(*) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")
if grabado <> "0" then
    cegr_ncorr = conexion.consultaUno("select cegr_ncorr from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")
    
	c_delete = "delete from CANDIDATOS_EGRESO_DETALLE where cast(CEGR_NCORR as varchar)='"&cegr_ncorr&"'"
    conexion.EstadoTransaccion conexion.EjecutaS(c_delete)
	
	c_delete = "delete from CANDIDATOS_EGRESO where cast(CEGR_NCORR as varchar)='"&cegr_ncorr&"'"
    conexion.EstadoTransaccion conexion.EjecutaS(c_delete)
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>