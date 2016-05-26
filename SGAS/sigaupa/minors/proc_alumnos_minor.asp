<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.Form()
	response.Write(k&" = "&request.Form(k)&"<br>")
next
response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut = request.Form("a[0][pers_nrut]")
minor = request.querystring("minr_ncorr")

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"'")

periodo= negocio.obtenerPeriodoAcademico("TOMACARGA")
'response.Write(" pers_ncorr "&pers_ncorr&" periodo "&periodo)

tiene_matricula = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"' and a.emat_ccod <> 9")
esta_en_minor = conexion.consultaUno("select count(*) from alumnos_minor where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(minr_ncorr as varchar)='"&minor&"'")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(a.peri_ccod as varchar)='"&periodo&"'")
'response.Write("tiene_matricula "&tiene_matricula&" esta en minor "&esta_en_minor)
response.Write(periodo_tdesc) response.End()

if tiene_matricula ="0" then
	msj_error = "ERROR : Inposible asignar el alumno al minor. No presenta matricula para el periodo solicitado( "&periodo_tdesc&")"
	elseif esta_en_minor <> "0" then
	msj_error = "ERROR : Inposible asignar el alumno al minor. Este alumno ya fue asignado al minor previamente."
else
	consulta_insercion = "insert into alumnos_minor (PERS_NCORR,MINR_NCORR,EAMI_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
	                     "values ("&pers_ncorr&","&minor&",1,'"&negocio.obtenerUsuario&"',getDate())"
	
	conexion.ejecutaS consulta_insercion
	msj_error = "El alumno fue agregado exitosamente al minor."			
	'response.Write(consulta_insercion)		 
end if

'response.End()

conexion.MensajeError msj_error

'conexion.estadotransaccion false  'roolback 
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
 CerrarActualizar();
</script>