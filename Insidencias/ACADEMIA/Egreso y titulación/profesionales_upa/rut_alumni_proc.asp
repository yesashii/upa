<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'for each k in request.form
' response.Write(k&" = "&request.Form(k)&"<br>")
'next

rut_persona = request.form("rut_alumni_1")
dv_persona  = request.form("digito_verificador")
'response.end()
pers_ncorr   = conexion.consultaUno("select pers_ncorr from alumni_personas where cast(pers_nrut as varchar)='"&rut_persona&"'")

'response.Write("select isnull((select ltrim(rtrim(carr_ccod)) from egresados_upa2 where cast(pers_ncorr as varchar)='"&pers_ncorr&"'),'')")
'response.end()

carr_ccod    = conexion.consultaUno("select  isnull((select top 1 ltrim(rtrim(carr_ccod)) from egresados_upa2 where cast(pers_ncorr as varchar)='"&pers_ncorr&"'),'')")

institucion  = conexion.consultaUno("select  isnull((select top 1 entidad from egresados_upa2 where cast(pers_ncorr as varchar)='"&pers_ncorr&"'),'')")

jorn_ccod    = conexion.consultaUno("select jorn_ccod from egresados_upa2 where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

'response.Write("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut_persona&"'")
'response.end()
if carr_ccod="" or institucion="" then
	carr_ccod 	 = conexion.consultaUno("select top 1 ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' order by a.audi_fmodificacion desc")
	jorn_ccod 	 = conexion.consultaUno("select top 1 b.jorn_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' order by a.audi_fmodificacion desc")
	institucion  = "U"
end if

url = "editar_datos_personales.asp?pers_ncorr="&pers_ncorr&"&carr_ccod="&carr_ccod&"&letra="&institucion&"&jorn_ccod="&jorn_ccod&"&recortar=S"
%>
<script type="text/javascript">
self.moveTo(0,0);
self.resizeTo(900,600);
window.scrollTo(0,0);
self.scrollbars = true;
location.href = '<%=url%>';
</script>

