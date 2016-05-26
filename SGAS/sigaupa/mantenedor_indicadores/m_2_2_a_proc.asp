<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()



 
set conectar = new cconexion
conectar.inicializar "upacifico"

set conectar2 = new cconexion
conectar2.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


negocio.Inicializa conectar2
'
anos_ccod=request.Form("ma[0][anos_ccod]")
tipo_mantenedora=request.Form("ma[0][tipo_mantenedora]")
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "mantenedores_escuela.xml", "insert_indi_2_2_a"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1

sede_ccod= f_agrega.ObtenerValorPost (filai, "sede_ccod")
carr_ccod= f_agrega.ObtenerValorPost (filai, "carr_ccod")
jorn_ccod= f_agrega.ObtenerValorPost (filai, "jorn_ccod")
tcar_ccod= f_agrega.ObtenerValorPost (filai, "tcar_ccod")
'anos_ccod= f_agrega.ObtenerValorPost (filai, "anos_ccod")
base_indi_2_2_a= f_agrega.ObtenerValorPost (filai, "base_indi_2_2_a")
real_indi_2_2_a= f_agrega.ObtenerValorPost (filai, "real_indi_2_2_a")
estimativo_indi_2_2_a= f_agrega.ObtenerValorPost (filai, "estimativo_indi_2_2_a")
'tipo_mantenedora= f_agrega.ObtenerValorPost (filai, "tipo_mantenedora")
 
 usu=negocio.obtenerUsuario

existe="0"
if tipo_mantenedora="1" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_base_escuela where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&"")

 if existe_carr="0" then
mdbe_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mantenedor_dato_base_escuela'")
		strInser="insert into mantenedor_dato_base_escuela (mdbe_ncorr,sede_ccod,carr_ccod,jorn_ccod,tcar_ccod,indi_2_2_a,audi_tusuario,audi_fmodificacion)   values("&mdbe_ncorr&","&sede_ccod&","&carr_ccod&","&jorn_ccod&","&tcar_ccod&","&base_indi_2_2_a&",'"&usu&"',getDate())"
			
else
mdbe_ncorr=conectar.ConsultaUno("select mdbe_ncorr from mantenedor_dato_base_escuela where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&"")
strInser="update mantenedor_dato_base_escuela set indi_2_2_a="&base_indi_2_2_a&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&""

end if

	conectar.ejecutaS (strInser)
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdbe_ncorr',"&mdbe_ncorr&",'indi_2_2_a','"&base_indi_2_2_a&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------
response.Write("<pre>"&strInser&"</pre>")
end if
if tipo_mantenedora="2" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_real_escuela where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&" and anos_ccod="&anos_ccod&"")

if existe_carr="0" then
mdre_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mantenedor_dato_real_escuela'")
		strInser="insert into mantenedor_dato_real_escuela (mdre_ncorr,sede_ccod,carr_ccod,jorn_ccod,tcar_ccod,anos_ccod,indi_2_2_a,audi_tusuario,audi_fmodificacion)   values("&mdre_ncorr&","&sede_ccod&","&carr_ccod&","&jorn_ccod&","&tcar_ccod&","&anos_ccod&","&real_indi_2_2_a&",'"&usu&"',getDate())"

else
mdre_ncorr=conectar.ConsultaUno("select mdre_ncorr from mantenedor_dato_real_escuela where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&" and anos_ccod="&anos_ccod&"")

strInser="update mantenedor_dato_real_escuela set indi_2_2_a="&real_indi_2_2_a&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&" and anos_ccod="&anos_ccod&""

end if
	conectar.ejecutaS (strInser)
	
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdre_ncorr',"&mdre_ncorr&",'indi_2_2_a','"&real_indi_2_2_a&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------

response.Write("<pre>"&strInser&"</pre>")
end if	
if tipo_mantenedora="3" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_escuela where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&" and anos_ccod="&anos_ccod&"")
	
if existe_carr="0" then
mdee_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mdee_ncorr'")
		strInser="insert into mantenedor_dato_estimativo_escuela (mdee_ncorr,sede_ccod,carr_ccod,jorn_ccod,tcar_ccod,anos_ccod,indi_2_2_a,audi_tusuario,audi_fmodificacion)   values("&mdee_ncorr&","&sede_ccod&","&carr_ccod&","&jorn_ccod&","&tcar_ccod&","&anos_ccod&","&estimativo_indi_2_2_a&",'"&usu&"',getDate())"
else
mdee_ncorr=conectar.ConsultaUno("select mdee_ncorr from mantenedor_dato_estimativo_escuela where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&" and anos_ccod="&anos_ccod&"")

strInser="update mantenedor_dato_estimativo_escuela set indi_2_2_a="&estimativo_indi_2_2_a&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where sede_ccod="&sede_ccod&" and carr_ccod="&carr_ccod&" and jorn_ccod="&jorn_ccod&" and tcar_ccod="&tcar_ccod&" and anos_ccod="&anos_ccod&""

end if
	conectar.ejecutaS (strInser)
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdee_ncorr',"&mdee_ncorr&",'indi_2_2_a','"&estimativo_indi_2_2_a&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------

response.Write("<pre>"&strInser&"</pre>")
end if	

next

'response.End()

'response.Write("<pre>rut= "&pers_nrut&"</pre>")	
'response.Write("<pre>xdv= "&pers_xdv&"</pre>")
'response.Write("<pre>usu= "&usu&"</pre>")
'response.Write("<pre>peri= "&peri_ccod&"</pre>")
'response.Write("<pre>pos= "&post_ncorr&"</pre>")
'response.Write("<pre>tdet= "&tdet_ccod&"</pre>")
'response.Write("<pre>tiene = "&tiene_beca&"</pre>")
'response.Write("<pre>tiene = "&cuenta_post&"</pre>")
'response.Write("respuesta "&Respuesta)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()

'----------------------------------------------------
response.Write("respuesta "&Respuesta)
'response.End()
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