<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
matr_ncorr	=	request.QueryString("matr_ncorr")
secc_ccod	=	request.QueryString("secc_ccod")
'response.Write(registros)
set conectar 	= new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

consulta_delete1 = " delete from equivalencias where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
		           " and cast(secc_ccod as varchar)='"&secc_ccod&"'"
				   
consulta_delete2 = " delete from calificaciones_alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
   	               " and cast(secc_ccod as varchar)='"&secc_ccod&"'"				   

consulta_delete3 = " delete from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
   	               " and cast(secc_ccod as varchar)='"&secc_ccod&"'"

sitf_ccod = conectar.consultaUno("select sitf_ccod from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'")
carg_nnota = conectar.consultaUno("select carg_nnota_final from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"'")				
		'response.Write(consulta_delete1)
		'response.Write(consulta_delete2)
		'response.Write(consulta_delete3)		  
		conectar.ejecutaS consulta_delete1
		conectar.ejecutaS consulta_delete2
		conectar.ejecutaS consulta_delete3
		
		'debemos insertar un registro en una tabla que guarde las asignaturas eliminadas de los alumnos
		'---------------------------------creada por Marcelo sandoval-----------------------------
	    cael_ncorr = conectar.consultauno("execute obtenerSecuencia 'cargas_eliminadas'")
		if sitf_ccod <> "" and carg_nnota <> "" then
			consulta_insert = "insert into cargas_eliminadas (cael_ncorr,matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario,audi_fmodificacion,cael_nresolucion,cael_tobservacion)"&_
							  " values ("&cael_ncorr&","&matr_ncorr&","&secc_ccod&",'"&sitf_ccod&"',"&carg_nnota&",'"&negocio.obtenerUsuario&"',getDate(),'0000','Eliminada equivalencia completa')"
		elseif sitf_ccod = "" and carg_nnota <> "" then
			consulta_insert = "insert into cargas_eliminadas (cael_ncorr,matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario,audi_fmodificacion,cael_nresolucion,cael_tobservacion)"&_
							  " values ("&cael_ncorr&","&matr_ncorr&","&secc_ccod&",null,"&carg_nnota&",'"&negocio.obtenerUsuario&"',getDate(),'0000','Eliminada equivalencia completa')"

		elseif sitf_ccod <> "" and carg_nnota = "" then
			consulta_insert = "insert into cargas_eliminadas (cael_ncorr,matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario,audi_fmodificacion,cael_nresolucion,cael_tobservacion)"&_
							  " values ("&cael_ncorr&","&matr_ncorr&","&secc_ccod&",'"&sitf_ccod&"',null,'"&negocio.obtenerUsuario&"',getDate(),'0000','Eliminada equivalencia completa')"
        else
			consulta_insert = "insert into cargas_eliminadas (cael_ncorr,matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario,audi_fmodificacion,cael_nresolucion,cael_tobservacion)"&_
							  " values ("&cael_ncorr&","&matr_ncorr&","&secc_ccod&",null,null,'"&negocio.obtenerUsuario&"',getDate(),'0000','Eliminada equivalencia completa')"
        end if
		'-----------------------------------------------------------------------------------------
		conectar.ejecutaS consulta_insert

if conectar.ObtenerEstadoTransaccion then 
	session("mensajeError")="La equivalencia ha sido eliminada por completo de la carga del alumno."
else
    session("mensajeError")="No se ha podido eliminar la equivalencia, intentelo nuevamente."	
end if
			
				
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>