<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
 for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()
set conectar = new cconexion
conectar.inicializar "upacifico"

set conectar2 = new cconexion
conectar2.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


negocio.Inicializa conectar2

anos_ccod=request.Form("ma[0][anos_ccod]")
tipo_mantenedora=request.Form("ma[0][tipo_mantenedora]")
base_indi_3_2_a= request.Form("ma[0][base_indi_3_2_a]")
real_indi_3_2_a= request.Form("ma[0][real_indi_3_2_a]")
estimativo_indi_3_2_a_2009= request.Form("ma[0][estimativo_indi_3_2_a_2009]")
estimativo_indi_3_2_a_2010= request.Form("ma[0][estimativo_indi_3_2_a_2010]")
estimativo_indi_3_2_a_2011= request.Form("ma[0][estimativo_indi_3_2_a_2011]")
estimativo_indi_3_2_a_2012= request.Form("ma[0][estimativo_indi_3_2_a_2012]")
estimativo_indi_3_2_a_2013= request.Form("ma[0][estimativo_indi_3_2_a_2013]")
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "mantenedor_anuales.xml", "f_mantenedor_base_3_2_a"
f_agrega.Inicializar conectar
'f_agrega.ProcesaForm
 
'anos_ccod= f_agrega.ObtenerValorPost (filai, "anos_ccod")

 
 
 
 usu=negocio.obtenerUsuario

existe="0"
if tipo_mantenedora="1" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_base_anual")

 if existe_carr="0" then
mdba_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mdba_ncorr'")
		strInser="insert into mantenedor_dato_base_anual (mdba_ncorr,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdba_ncorr&","&base_indi_3_2_a&",'"&usu&"',getDate())"
			
else
mdba_ncorr=conectar.ConsultaUno("select mdba_ncorr from mantenedor_dato_base_anual")
strInser="update mantenedor_dato_base_anual set indi_3_2_a="&base_indi_3_2_a&", audi_tusuario="&usu&",audi_fmodificacion=getdate()"

end if

	conectar.ejecutaS (strInser)
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdba_ncorr',"&mdba_ncorr&",'indi_3_2_a','"&base_indi_3_2_a&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------
response.Write("<pre>"&strInser&"</pre>")
end if
if tipo_mantenedora="2" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_real_anual where anos_ccod="&anos_ccod&"")

if existe_carr="0" then
mdra_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mdra_ncorr'")
		strInser="insert into mantenedor_dato_real_anual (mdra_ncorr,anos_ccod,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdra_ncorr&","&anos_ccod&","&real_indi_3_2_a&",'"&usu&"',getDate())"

else
mdra_ncorr=conectar.ConsultaUno("select mdra_ncorr from mantenedor_dato_real_anual where anos_ccod="&anos_ccod&"")

strInser="update mantenedor_dato_real_anual set indi_3_2_a="&real_indi_3_2_a&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where anos_ccod="&anos_ccod&""

end if
	conectar.ejecutaS (strInser)
	
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdra_ncorr',"&mdra_ncorr&",'indi_3_2_a','"&real_indi_3_2_a&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------

response.Write("<pre>"&strInser&"</pre>")
end if	
if tipo_mantenedora="3" then

	existe_2009=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_anual where anos_ccod=2009")
	existe_2010=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_anual where anos_ccod=2010")
	existe_2011=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_anual where anos_ccod=2011")
	existe_2012=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_anual where anos_ccod=2012")
	existe_2013=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_anual where anos_ccod=2013")

'********************************************************************2009***********************************************************************************************
if existe_2009="0" then
	mdea_ncorr1=conectar.ConsultaUno("exec obtenerSecuencia 'mdea_ncorr'")
			strInser="insert into mantenedor_dato_estimativo_anual (mdea_ncorr,anos_ccod,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdea_ncorr1&",2009,"&estimativo_indi_3_2_a_2009&",'"&usu&"',getDate())"
			str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr&",'indi_3_2_a',"&estimativo_indi_3_2_a_2009&","&usu&",getDate())"

else

	mdea_ncorr1=conectar.ConsultaUno("select mdea_ncorr from mantenedor_dato_estimativo_anual where anos_ccod=2009")
	
	strInser="update mantenedor_dato_estimativo_anual set indi_3_2_a="&estimativo_indi_3_2_a_2009&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where anos_ccod=2009"

end if
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr1&",'indi_3_2_a','"&estimativo_indi_3_2_a_2009&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
conectar.ejecutaS (strInser)
response.Write("<pre>"&strInser&"</pre>")
'********************************************************************2010***********************************************************************************************
if existe_2010="0" then
	mdea_ncorr1=conectar.ConsultaUno("exec obtenerSecuencia 'mdea_ncorr'")
			strInser="insert into mantenedor_dato_estimativo_anual (mdea_ncorr,anos_ccod,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdea_ncorr1&",2010,"&estimativo_indi_3_2_a_2010&",'"&usu&"',getDate())"
			str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr&",'indi_3_2_a',"&estimativo_indi_3_2_a_2010&","&usu&",getDate())"

else

	mdea_ncorr1=conectar.ConsultaUno("select mdea_ncorr from mantenedor_dato_estimativo_anual where anos_ccod=2010")
	
	strInser="update mantenedor_dato_estimativo_anual set indi_3_2_a="&estimativo_indi_3_2_a_2010&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where anos_ccod=2010"

end if
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr1&",'indi_3_2_a','"&estimativo_indi_3_2_a_2010&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
conectar.ejecutaS (strInser)
response.Write("<pre>"&strInser&"</pre>")
'********************************************************************2011***********************************************************************************************
if existe_2011="0" then
	mdea_ncorr2=conectar.ConsultaUno("exec obtenerSecuencia 'mdea_ncorr'")		
			strInser="insert into mantenedor_dato_estimativo_anual (mdea_ncorr,anos_ccod,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdea_ncorr2&",2011,"&estimativo_indi_3_2_a_2011&",'"&usu&"',getDate())"
			str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr2&",'indi_3_2_a',"&estimativo_indi_3_2_a_2011&","&usu&",getDate())"

else

	mdea_ncorr2=conectar.ConsultaUno("select mdea_ncorr from mantenedor_dato_estimativo_anual where anos_ccod=2011")
	
	strInser="update mantenedor_dato_estimativo_anual set indi_3_2_a="&estimativo_indi_3_2_a_2011&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where anos_ccod=2011"

end if
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr2&",'indi_3_2_a','"&estimativo_indi_3_2_a_2011&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
conectar.ejecutaS (strInser)
response.Write("<pre>"&strInser&"</pre>")
'********************************************************************2012***********************************************************************************************
if existe_2012="0" then		
	mdea_ncorr3=conectar.ConsultaUno("exec obtenerSecuencia 'mdea_ncorr'")		
	strInser="insert into mantenedor_dato_estimativo_anual (mdea_ncorr,anos_ccod,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdea_ncorr3&",2012,"&estimativo_indi_3_2_a_2012&",'"&usu&"',getDate())"
			str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr3&",'indi_3_2_a','"&estimativo_indi_3_2_a_2012&"',"&usu&",getDate())"

else

	mdea_ncorr3=conectar.ConsultaUno("select mdea_ncorr from mantenedor_dato_estimativo_anual where anos_ccod=2012")
	
	strInser="update mantenedor_dato_estimativo_anual set indi_3_2_a="&estimativo_indi_3_2_a_2012&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where anos_ccod=2012"

end if
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr3&",'indi_3_2_a','"&estimativo_indi_3_2_a_2012&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
conectar.ejecutaS (strInser)
response.Write("<pre>"&strInser&"</pre>")
'*********************************************************************2013**********************************************************************************************
if existe_2013="0" then
	mdea_ncorr4=conectar.ConsultaUno("exec obtenerSecuencia 'mdea_ncorr'")		
			strInser="insert into mantenedor_dato_estimativo_anual (mdea_ncorr,anos_ccod,indi_3_2_a,audi_tusuario,audi_fmodificacion)   values("&mdea_ncorr4&",2013,"&estimativo_indi_3_2_a_2013&",'"&usu&"',getDate())"
			str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr4&",'indi_3_2_a','"&estimativo_indi_3_2_a_2013&"',"&usu&",getDate())"

else

	mdea_ncorr4=conectar.ConsultaUno("select mdea_ncorr from mantenedor_dato_estimativo_anual where anos_ccod=2013")
	
	strInser="update mantenedor_dato_estimativo_anual set indi_3_2_a="&estimativo_indi_3_2_a_2013&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where anos_ccod=2013"

end if
	str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdea_ncorr',"&mdea_ncorr4&",'indi_3_2_a','"&estimativo_indi_3_2_a_2013&"',"&usu&",getDate())"
	conectar2.ejecutaS (str_log)

	conectar.ejecutaS (strInser)
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación

'-----------------------------------------------------------------------------------------------------------------------------------------

response.Write("<pre>"&strInser&"</pre>")
end if	


Respuesta = conectar.ObtenerEstadoTransaccion()

'----------------------------------------------------
response.Write("respuesta "&Respuesta)
if existe="0" then
if Respuesta = true then
session("mensajeerror")= "Los datos han sido grabados exitosamente"
else
  session("mensajeerror")= "Se ha presentado un error al momento de grabar"
end if
else

session("mensajeerror")= "Se ha presentado un error al momento de grabar"
end if
response.Redirect("selector.asp")
 %>