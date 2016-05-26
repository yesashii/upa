 <!-- #include file="../biblioteca/_conexion_sbd02.asp" -->
 <!-- #include file="../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'####################################################
'campos de auditoria (mriffo)
	set negocio	=	new cnegocio
	negocio.Inicializa conectar
	v_usuario	=	negocio.ObtenerUsuario
'####################################################

formulario.carga_parametros "toma_carga_alfa.xml" , "tabla_Op_deportivos"
formulario.inicializar conectar

formulario.procesaForm 
for i=0 to formulario.cuentaPost - 1
	matr_ncorr=formulario.obtenerValorPost(i,"matr_ncorr")
	secc_ccod=formulario.obtenerValorPost(i,"secc_ccod")
	if  matr_ncorr <> "" and secc_ccod <> "" then
		evaluado = "select isnull(count(*),0) from calificaciones_alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'"
		canti_evaluado = conectar.consultaUno(evaluado)	
	
		consulta_delete= " delete from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
		                  " and cast(secc_ccod as varchar)='"&secc_ccod&"'"
		'en el caso en que la alumno ya tenga evaluaciones para esta sección no se puede eliminar.
        if cInt(canti_evaluado) = 0 then
			'***********************************************************************************************
				' (mriffo) actualiza el registro antes de eliminarlo para determinar que usuario cometio el ilicito ;)						  
				v_usuario=v_usuario&"-borra opt"
				sql_actualiza_borrado=" Update cargas_academicas set audi_tusuario='"&v_usuario&"', audi_fmodificacion=getdate() "&_
										" Where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
										" and cast(secc_ccod as varchar)='"&secc_ccod&"'"
				conectar.EstadoTransaccion conectar.ejecutaS(sql_actualiza_borrado)
			 '**********************************************************************************************									
            conectar.EstadoTransaccion	conectar.ejecutaS(consulta_delete)
			session("mensajeError")="El optativo ha sido eliminado de la carga horaria del alumno."
		else
		    session("mensajeError")="No se ha podido eliminar el optativo al alumno, ya que se encuentra evaluada."	
    	end if
		'response.Write("<br>"&consulta_update)

	end if 
next 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

