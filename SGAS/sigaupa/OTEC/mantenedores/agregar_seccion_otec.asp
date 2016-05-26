<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

maot_ncorr= request.Form("maot_ncorr")
dgso_ncorr= request.Form("dgso_ncorr")

seot_tdesc = conectar.consultaUno("select isnull(max(cast(seot_tdesc as numeric)),0) from secciones_otec where cast(maot_ncorr as varchar)='"&maot_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
seot_tdesc = cint(seot_tdesc) + 1
dgso_finicio = conectar.consultaUno("select dgso_finicio from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dgso_ftermino = conectar.consultaUno("select dgso_ftermino from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dgso_ncupo = conectar.consultaUno("select dgso_ncupo from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dgso_nquorum = conectar.consultaUno("select dgso_nquorum from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
seot_ncorr = conectar.consultaUno("exec obtenerSecuencia 'secciones_otec'")

c_otec = "insert into secciones_otec (seot_ncorr,seot_tdesc,dgso_ncorr,maot_ncorr,seot_finicio,seot_ftermino,seot_ncupo,seot_nquorum,seot_nhoras_programa,seot_npresupuesto_relator,seot_ncantidad_relator,audi_tusuario,audi_fmodificacion,jorn_ccod)"&_
         " values ("&seot_ncorr&",'"&seot_tdesc&"',"&dgso_ncorr&","&maot_ncorr&",'"&dgso_finicio&"','"&dgso_ftermino&"',"&dgso_ncupo&","&dgso_nquorum&",null,null,null,'agregar_seccion',getDate(),1)"
 
conectar.ejecutaS c_otec

	if not conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Ha ocurrido un error al crear la nueva sección"
	end if

 response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
