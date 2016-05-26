<!-- #include file="../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
set formulario = new cformulario
conectar.estadoTransaccion false
conectar.inicializar "upacifico"

formulario.carga_parametros "horas_docente.xml", "f_docentes"
formulario.inicializar conectar
formulario.procesaForm

for fila = 0 to formulario.CuentaPost - 1
   v_secc_ccod	= formulario.ObtenerValorPost (fila, "secc_ccod")
   v_pers_ncorr	= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_ebpr_ccod	= formulario.ObtenerValorPost (fila, "ebpr_ccod")
   v_tipo_bloque=formulario.ObtenerValorPost (fila, "bloq_ayudantia")
   
   	sql_bloq_ccod= " update bloques_profesores set ebpr_ccod= '"&v_ebpr_ccod&"' "& vbCrLf &_
					" where bloq_ccod in ( "& vbCrLf &_
					"	select c.bloq_ccod from  secciones a,bloques_horarios b, bloques_profesores c "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod "& vbCrLf &_
					" and b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" and c.pers_ncorr='"&v_pers_ncorr&"' "& vbCrLf &_
					" and b.bloq_ayudantia='"&v_tipo_bloque&"' "& vbCrLf &_
					" and a.secc_ccod='"&v_secc_ccod&"' )"& vbCrLf &_
					" and pers_ncorr ='"&v_pers_ncorr&"' "
					
	'response.Write("<pre>"&sql_bloq_ccod&"</pre><br>")
	conectar.EstadoTransaccion  conectar.ejecutaS(sql_bloq_ccod)
	'response.Write(conectar.ObtenerEstadoTransaccion)
'response.Write(conectar.ObtenerEstadoTransaccion)
next

formulario.mantienetablas false

'response.Write(conectar.ObtenerEstadoTransaccion)
'conectar.EstadoTransaccion false
'response.End()

if conectar.ObtenerEstadoTransaccion=true then
	conectar.MensajeError "Se han guardado correctamente las horas de los docentes. "

else
	conectar.MensajeError "Ocurrio un error inesperado, los datos no han sido modificados. "
end if
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
