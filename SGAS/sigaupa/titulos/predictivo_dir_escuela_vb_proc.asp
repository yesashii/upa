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
sin_mencion = request.Form("sin_mencion")

grabado = conexion.consultaUno("select count(*) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")
if grabado <> "0" then
    cegr_ncorr = conexion.consultaUno("select cegr_ncorr from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")
else
    cegr_ncorr = conexion.ConsultaUno("exec ObtenerSecuencia 'CANDIDATOS_EGRESO'")
	c_insert = "Insert into CANDIDATOS_EGRESO (CEGR_NCORR,PERS_NCORR,PLAN_CCOD,CARR_CCOD,CEGR_FSOLICITUD,CEGR_BSIN_MENCION,ECEG_CCOD,CEGR_NVB_ESCUELA,AUDI_TUSUARIO,AUDI_FMODIFICACION)" &_
	           "values ("&cegr_ncorr&","&pers_ncorr&","&plan_ccod&",'"&carr_ccod&"',getdate(),'"&sin_mencion&"',1,1,'"&negocio.obtenerUsuario&"',getdate())"
    conexion.EstadoTransaccion conexion.EjecutaS(c_insert)
	
	for each k in request.form
	    if instr(k, "saca_ncorr") > 0  and request.Form(k) <> "" then
		SQL=" INSERT INTO CANDIDATOS_EGRESO_DETALLE (CEGR_NCORR,SACA_NCORR,ECEG_CCOD,USUA_NCORR_CREADOR,CEGR_FCREACION,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
		    " values ("&cegr_ncorr&","&request.Form(k)&",1,'"&negocio.obtenerUsuario&"',getdate(),'"&negocio.obtenerUsuario&"',getdate())"
		conexion.EstadoTransaccion conexion.EjecutaS(SQL)
		end if
    next
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>