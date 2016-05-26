<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
pers_ncorr = request.QueryString("pers_ncorr")
saca_ncorr = request.QueryString("saca_ncorr")

c_delete=""
if pers_ncorr <> "" and saca_ncorr <> "" then
	c_delete = "Delete from alumnos_salidas_carrera where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(saca_ncorr as varchar)='"&saca_ncorr&"'"
	tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
	if tsca_ccod = "1" or tsca_ccod = "2" then
		plan_ccod = conexion.consultaUno("select plan_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
	    c_delete_comision = "delete from comision_tesis where cast(plan_ccod as varchar)='"&plan_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
	    c_update = " update detalles_titulacion_carrera set tema_tesis=NULL,inicio_tesis=NULL,termino_tesis=NULL,calificacion_tesis=NULL,fecha_titulacion=NULL, "&_
				   " calificacion_notas=NULL,porcentaje_notas=NULL,porcentaje_practica=NULL,porcentaje_tesis=NULL,mostrar_concentracion=NULL, "&_
				   " promedio_final=NULL,fecha_ceremonia=NULL,nota_tesis=NULL,porcentaje_nota_tesis=NULL, "&_
				   " fecha_proceso=NULL,observaciones=NULL,mall_ccod=NULL "&_
				   " where cast(plan_ccod as varchar)='"&plan_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"

		conexion.ejecutaS c_delete_comision
		conexion.ejecutaS c_update				  
	end if
end if
conexion.ejecutaS c_delete	
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
