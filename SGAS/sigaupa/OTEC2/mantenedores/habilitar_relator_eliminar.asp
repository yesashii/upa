<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new cformulario
formulario.carga_parametros "habilitar_relator.xml", "f_relatores"
formulario.inicializar conectar
formulario.procesaForm

for i=0 to formulario.cuentaPost - 1
	dgso_ncorr=formulario.obtenerValorPost(i,"dgso_ncorr")
	pers_ncorr=formulario.obtenerValorPost(i,"pers_ncorr")
	anos_ccod=formulario.obtenerValorPost(i,"anos_ccod")
	if not EsVacio(dgso_ncorr) and not EsVacio(pers_ncorr) and not EsVacio(anos_ccod) then
	
	    c_asignado = " select case count(*) when 0 then 'N' else 'S' end  " & vbCrlf & _
					 " from secciones_otec a, bloques_horarios_otec b, bloques_relatores_otec c  " & vbCrlf & _
					 " where cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"' and a.seot_ncorr=b.seot_ncorr   " & vbCrlf & _
					 " and b.bhot_ccod=c.bhot_ccod "
		asignado = conectar.consultaUno(c_asignado)
		'response.Write("<pre>"&c_asignado&"</pre>")
		'response.End()
		if asignado = "N" then 
			SQL="DELETE relatores_programa WHERE cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar) ='"&pers_ncorr&"' and cast(anos_ccod as varchar)='"&anos_ccod&"'"
			'response.Write("<br>"&SQL)
			'----- antes de borrar a un docente habilitado en cierto programa debemos ver si tiene algun bloque asignado
			conectar.EstadoTransaccion conectar.EjecutaS(SQL)
	    else
	        msj_error ="ERROR: Imposible eliminar al relator ya se encuentra asignado a un módulo de este programa."
	        conectar.EstadoTransaccion false
		end if
	end if
next

if msj_error <> "" then 
		conectar.MensajeError msj_error
end if


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
