<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion'2
conexion.Inicializar "upacifico"

filas = request.Form("total_asignaturas")
pers_ncorr = request.Form("pers_ncorr")
carr_ccod=request.Form("carr_ccod")
plan_ccod=request.Form("plan_ccod")

tiene_grabado = conexion.consultaUno("select count(*) from ASIGNATURAS_CERTIFICADO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and ACER_ENVIADA='NO' ")
if tiene_grabado <> "0" then'debemos tomar el código grabado y eliminar lo grabado para volver a grabar
	codigo = conexion.consultaUno("select SCTG_NCORR from ASIGNATURAS_CERTIFICADO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and ACER_ENVIADA='NO' ")
	c_delete = "delete from ASIGNATURAS_CERTIFICADO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and ACER_ENVIADA='NO' "
	conexion.ejecutaS c_delete
else
	codigo_1= conexion.consultaUno("select isnull(max(SCTG_NCORR),0) + 1 from ASIGNATURAS_CERTIFICADO ")
	codigo_2= conexion.consultaUno("select isnull(max(SCTG_NCORR),0) + 1 from SOLICITUD_CERTIFICADOS_TYG ")
	if clng(codigo_1) > clng(codigo_2) then
		codigo = codigo_1
	else
		codigo = codigo_2
	end if	
end if

for i = 0 To cint(filas)' Step 1
	mall_ccod = request.Form("malla["&i&"]")
	if mall_ccod <> "" then
		c_insert = " insert into ASIGNATURAS_CERTIFICADO (SCTG_NCORR,PERS_NCORR,CARR_CCOD,PLAN_CCOD,MALL_CCOD,ACER_FSOLICITUD,ACER_ENVIADA,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
		           " values ("&codigo&","&pers_ncorr&",'"&carr_ccod&"',"&plan_ccod&","&mall_ccod&",getDate(),'NO','alumno',getDate())"
		conexion.ejecutaS c_insert
	end if
next
%>
<script type="text/javascript">
	opener.location.reload();
	close();
</script>
