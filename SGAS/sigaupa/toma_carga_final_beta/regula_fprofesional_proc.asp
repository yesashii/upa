<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new cformulario
formulario.carga_parametros "regula_fprofesional.xml", "formulario_asignaturas"
formulario.inicializar conectar
formulario.procesaForm

msj_errores=""
for i=0 to formulario.cuentaPost - 1
	matr_ncorr=formulario.obtenerValorPost(i,"matr_ncorr")
	secc_ccod=formulario.obtenerValorPost(i,"secc_ccod")
	mall_ccod=formulario.obtenerValorPost(i,"mall_ccod")
	if not EsVacio(matr_ncorr) and not EsVacio(secc_ccod)then
	    ' antes de grabar la equivalencia debemos borrar lo que tenga asociado esa matricula y seccion
		c_delete_equivalencia = "delete from equivalencias where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='"+secc_ccod+"'"
		conectar.ejecutaS c_delete_equivalencia	
		'response.Write("<br>"&c_delete_equivalencia)
		if not EsVacio(mall_ccod) then
		    ya_asignada = conectar.consultaUno("select count(*) from equivalencias where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(mall_ccod as varchar)='"&mall_ccod&"'")
			if ya_asignada = "0" then
				asig_ccod = conectar.consultaUno("select asig_ccod from malla_curricular where cast(mall_ccod as varchar)='"&mall_ccod&"'")
				c_insert_equivalencia = "insert into equivalencias (MATR_NCORR,SECC_CCOD,MALL_CCOD,ASIG_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION)" &_
										" VALUES ("&matr_ncorr&","&secc_ccod&","&mall_ccod&",'"&asig_ccod&"','"&negocio.obtenerUsuario&"',getDate())"	
				conectar.ejecutaS c_insert_equivalencia
			 end if	
			'response.Write("<br>"&c_insert_equivalencia)
		end if
	end if 
next 
'response.End()
if conectar.obtenerEstadoTransaccion then
	conectar.MensajeError "Las equivalencias se han ingresado exitosamente"
else
	conectar.MensajeError "Ocurrió un error al tratar de grabar las equivalencias, vuelva a intentarlo"
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
