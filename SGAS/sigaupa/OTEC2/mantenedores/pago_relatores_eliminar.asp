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
formulario.carga_parametros "pago_relatores.xml", "f_horario"
formulario.inicializar conectar
formulario.procesaForm


for i=0 to formulario.cuentaPost - 1
	clave=formulario.obtenerValorPost(i,"clave")
	seot_ncorr=formulario.obtenerValorPost(i,"seot_ncorr")
		  

	if not EsVacio(clave) and not EsVacio(seot_ncorr)  then
	tiene_contrato= conectar.consultaUno("select count(*) from contratos_docentes_otec a, anexos_otec b, detalle_anexo_otec c where a.cdot_ncorr=b.cdot_ncorr and b.anot_ncorr=c.anot_ncorr and c.seot_ncorr="&seot_ncorr&" and pers_ncorr="&clave&" and ecdo_ccod=1")
		 if tiene_contrato="0" then
		
			SQL="DELETE pago_relatores_otec WHERE cast(pers_ncorr as varchar)='"&clave&"' and cast(seot_ncorr as varchar)='"&seot_ncorr&"'"
			'response.Write("<br>"&SQL)
			'----- antes de borrar a un docente habilitado en cierto programa debemos ver si tiene algun bloque asignado
			conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		else
			session("mensajeerror")= "No Puede Eliminar por que un tiene contrato asociado"
		end if
	end if
next
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
