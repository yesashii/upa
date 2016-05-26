<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

id = request.Form("alumnos[0][id]")
eopo_ccod = request.Form("alumnos[0][eopo_ccod]")
obpo_tobservacion = request.Form("alumnos[0][obpo_tobservacion]")
fecha_llamado  = request.Form("alumnos[0][fecha_llamado]")
htes_ccod  = request.Form("alumnos[0][htes_ccod]")
fecha_entrevista  = request.Form("alumnos[0][fecha_entrevista]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

tipo_postulante = session("r_tipo_postulante") 
'-------------------------------------------------------------------------------------------------
set f_enfermedades = new CFormulario
f_enfermedades.Carga_Parametros "listado_postulaciones.xml", "f_detalle"
if tipo_postulante = "2" then
	f_enfermedades.carga_parametros "detalle_postulacion_new.xml","f_detalle_otec"
end if


if tipo_postulante = "3" then
	existe = conexion.consultaUno("SELECT case count(*) when 0 then 'N' else 'S' end FROM [ASPT].[dbo].[observaciones_prospectos] where cast(id as varchar)='"&id&"'")
	if existe = "N" then
	  if len(htes_ccod) > 0 then
	    query = "insert into [ASPT].[dbo].[observaciones_prospectos] (id,eopo_ccod,obpo_tobservacion,fecha_llamado,audi_tusuario,audi_fmodificacion,fecha_entrevista,htes_ccod)" &_
	    		"values ("&id&","&eopo_ccod&",'"&obpo_tobservacion&"',case '"&fecha_llamado&"' when '' then NULL else '"&fecha_llamado&"' end,"&_
				"'"&negocio.obtenerUsuario()&"',getDate(), case '"&fecha_entrevista&"' when '' then NULL else '"&fecha_entrevista&"' end,'"&htes_ccod&"')"
	  else
	    query = "insert into [ASPT].[dbo].[observaciones_prospectos] (id,eopo_ccod,obpo_tobservacion,fecha_llamado,audi_tusuario,audi_fmodificacion,fecha_entrevista)" &_
	    		"values ("&id&","&eopo_ccod&",'"&obpo_tobservacion&"',case '"&fecha_llamado&"' when '' then NULL else '"&fecha_llamado&"' end,"&_
				"'"&negocio.obtenerUsuario()&"',getDate(), case '"&fecha_entrevista&"' when '' then NULL else '"&fecha_entrevista&"' end)"
	  end if
	else
	  if len(htes_ccod) > 0 then
		  query = " Update [ASPT].[dbo].[observaciones_prospectos] set eopo_ccod='"&eopo_ccod&"',obpo_tobservacion = '"&obpo_tobservacion&"'"&_
		          " ,fecha_llamado = case '"&fecha_llamado&"' when '' then NULL else '"&fecha_llamado&"' end, "&_
				  " audi_tusuario = '"&negocio.obtenerUsuario()&"', audi_fmodificacion = getDate() "&_
				  " ,fecha_entrevista = case '"&fecha_entrevista&"' when '' then NULL else '"&fecha_entrevista&"' end , htes_ccod = '"&htes_ccod&"'"&_ 
				  " where cast(id as varchar) = '"&id&"'" 
	  else
	  	  query = " Update [ASPT].[dbo].[observaciones_prospectos] set eopo_ccod='"&eopo_ccod&"',obpo_tobservacion = '"&obpo_tobservacion&"'"&_
		          " ,fecha_llamado = case '"&fecha_llamado&"' when '' then NULL else '"&fecha_llamado&"' end, "&_
				  " audi_tusuario = '"&negocio.obtenerUsuario()&"', audi_fmodificacion = getDate() "&_
				  " ,fecha_entrevista = case '"&fecha_entrevista&"' when '' then NULL else '"&fecha_entrevista&"' end "&_ 
				  " where cast(id as varchar) = '"&id&"'" 
	  end if
	end if
	
	'response.Write(query)
	conexion.ejecutaS query

else
	f_enfermedades.Inicializar conexion
	f_enfermedades.ProcesaForm
	f_enfermedades.MantieneTablas false
end if
	

'response.End()


if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "Las observaciones se guardaron correctamente."
end if
'conexion.estadotransaccion true
'response.End()
'---------------------------------------------------------------------------------------------------------------
'Response.Redirect("postulacion_4.asp")
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

