<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"



set negocio = new CNegocio
negocio.Inicializa conectar


formulario.carga_parametros "toma_formacion_profesional.xml", "carga_tomada_eliminar"
formulario.inicializar conectar
msj_topones=""
formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	matr_ncorr=formulario.obtenerValorPost(i,"matr_ncorr")
	secc_ccod=formulario.obtenerValorPost(i,"secc_ccod")
	eliminar=formulario.obtenerValorPost(i,"eliminar")
	if not EsVacio(matr_ncorr) and not EsVacio(secc_ccod) and eliminar="1" then
		consulta_delete2 = " delete from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"&_
   	                       " and cast(secc_ccod as varchar)='"&secc_ccod&"'"
				
		conectar.ejecutaS consulta_delete2
    	'debemos insertar un registro en una tabla que guarde las asignaturas eliminadas de los alumnos
		'---------------------------------creada por Marcelo sandoval-----------------------------
            cael_ncorr = conectar.consultauno("execute obtenerSecuencia 'cargas_eliminadas'")
			consulta_insert = "insert into cargas_eliminadas (cael_ncorr,matr_ncorr,secc_ccod,sitf_ccod,carg_nnota_final,audi_tusuario,audi_fmodificacion,cael_nresolucion,cael_tobservacion)"&_
			                  " values ("&cael_ncorr&","&matr_ncorr&","&secc_ccod&",null,null,'"&negocio.obtenerUsuario&"',getDate(),'0000','Eliminada por toma de carga regular')"
		'-----------------------------------------------------------------------------------------
		conectar.ejecutaS consulta_insert
	end if 
next 
conectar.MensajeError "Las Asignaturas han sido eliminadas correctamente"
response.Redirect("toma_formacion_profesional.asp?activar=1")

%>
