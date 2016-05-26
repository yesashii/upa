<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

usu=negocio.obtenerUsuario

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_contacto"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
'for filai = 0 to f_agrega.CuentaPost - 1

	
	
	pais_ccod=request.Form("b[0][pais_ccod]") 'f_agrega.ObtenerValorPost (filai, "pais_ccod")
	ciex_ccod=request.Form("b[0][ciex_ccod]") 'f_agrega.ObtenerValorPost (filai, "ciex_ccod")
	univ_ccod=request.Form("b[0][univ_ccod]") 'f_agrega.ObtenerValorPost (filai, "univ_ccod")
	response.Write("<br>"&pais_ccod&"<br>")
	response.Write("<br>"&ciex_ccod&"<br>")
	response.Write("<br>"&univ_ccod&"<br>")
	
	existe=conectar.ConsultaUno("select case count(*) when 0 then 'N' else 'S' end  from universidad_ciudad aa where univ_ccod="&univ_ccod&" and ciex_ccod="&ciex_ccod&"")
	

if existe="N" then


				unci_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'universidad_ciudad'")
	
	  
	
				p_insert="insert into universidad_ciudad(unci_ncorr,univ_ccod,ciex_ccod,audi_tusuario,audi_fmodificacion)"& vbCrLf &_
				" values("&unci_ncorr&","&univ_ccod&","&ciex_ccod&",'"&usu&"',getDate())"		  
				response.Write("<pre>"&p_insert&"</pre>")
				conectar.ejecutaS (p_insert)
				Respuesta = conectar.ObtenerEstadoTransaccion()
				
				if Respuesta = true then
				response.Redirect("agrega_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bunci_ncorr%5D="&unci_ncorr&"")
				else
				  session("mensajeerror")= "Error al Guardar "
				  response.Redirect("universidad_convenio.asp")
				end if
	
		
else
				 unci_ncorr=conectar.ConsultaUno("select unci_ncorr from universidad_ciudad aa where univ_ccod="&univ_ccod&" and ciex_ccod="&ciex_ccod&"")
				tiene_convenio=conectar.ConsultaUno("select unci_ncorr from datos_convenio aa where unci_ncorr="&unci_ncorr&"")

		if tiene_convenio="S" then
		
			session("mensajeerror")= "Esta Universidad ya registra un convenio en esta ciudad, Busque la universidad en la función Editar Convenio si necesita modificar algun dato"
			response.Redirect("universidad_convenio.asp")	
		else

			response.Redirect("agrega_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bunci_ncorr%5D="&unci_ncorr&"")	
		
	   end if
		
		
end if		



'next




'response.Redirect(request.ServerVariables("HTTP_REFERER"))


'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()










%>


