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
'
anos_ccod=request.Form("ma[0][anos_ccod]")
tipo_mantenedora=request.Form("ma[0][tipo_mantenedora]")
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "mantenedores_escuela.xml", "insert_indi_3_4_a"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1

sede_ccod= f_agrega.ObtenerValorPost (filai, "sede_ccod")
'anos_ccod= f_agrega.ObtenerValorPost (filai, "anos_ccod")
base_indi_3_4_a_obligatoria= f_agrega.ObtenerValorPost (filai, "base_indi_3_4_a_obligatoria")
base_indi_3_4_a_complementaria= f_agrega.ObtenerValorPost (filai, "base_indi_3_4_a_complementaria")

real_indi_3_4_a_obligatoria= f_agrega.ObtenerValorPost (filai, "real_indi_3_4_a_obligatoria")
real_indi_3_4_a_complementaria= f_agrega.ObtenerValorPost (filai, "real_indi_3_4_a_complementaria")

estimativo_indi_3_4_a_complementaria= f_agrega.ObtenerValorPost (filai, "estimativo_indi_3_4_a_complementaria")
estimativo_indi_3_4_a_obligatoria= f_agrega.ObtenerValorPost (filai, "estimativo_indi_3_4_a_obligatoria")
'tipo_mantenedora= f_agrega.ObtenerValorPost (filai, "tipo_mantenedora")
 
 usu=negocio.obtenerUsuario

existe="0"
if tipo_mantenedora="1" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_base_sede where sede_ccod="&sede_ccod&"")

 if existe_carr="0" then
mdbs_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mdbs_ncorr'")
		strInser="insert into mantenedor_dato_base_sede(mdbe_ncorr,sede_ccod,carr_ccod,jorn_ccod,tcar_ccod,indi_3_4_a_obligatoria,indi_3_4_a_complementaria,audi_tusuario,audi_fmodificacion)   values("&mdbs_ncorr&","&sede_ccod&","&carr_ccod&","&jorn_ccod&","&tcar_ccod&","&base_indi_3_4_a_obligatoria&","&base_indi_3_4_a_complementaria&",'"&usu&"',getDate())"
			
else
mdbe_ncorr=conectar.ConsultaUno("select mdbs_ncorr from mantenedor_dato_base_sede where sede_ccod="&sede_ccod&"")
strInser="update mantenedor_dato_base_sede set indi_3_4_a_obligatoria="&base_indi_3_4_a_obligatoria&",indi_3_4_a_complementaria="&base_indi_3_4_a_complementaria&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where sede_ccod="&sede_ccod&""

end if

	conectar.ejecutaS (strInser)
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdbs_ncorr',"&mdbe_ncorr&",'indi_3_4_a_obligatoria-indi_3_4_a_complementaria','"&base_indi_3_4_a_obligatoria&"-"&base_indi_3_4_a_complementaria&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------
response.Write("<pre>"&strInser&"</pre>")
end if
if tipo_mantenedora="2" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_real_sede where sede_ccod="&sede_ccod&" and anos_ccod="&anos_ccod&"")

if existe_carr="0" then
mdrs_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mdrs_ncorr'")
		strInser="insert into mantenedor_dato_real_sede (mdre_ncorr,sede_ccod,carr_ccod,jorn_ccod,tcar_ccod,anos_ccod,indi_3_4_a_obligatoria,indi_3_4_a_complementaria,audi_tusuario,audi_fmodificacion)   values("&mdrs_ncorr&","&sede_ccod&","&tcar_ccod&","&anos_ccod&","&real_indi_3_4_a_obligatoria&","&real_indi_3_4_a_complementaria&",'"&usu&"',getDate())"

else
mdre_ncorr=conectar.ConsultaUno("select mdrs_ncorr from mantenedor_dato_real_sede where sede_ccod="&sede_ccod&" and anos_ccod="&anos_ccod&"")

strInser="update mantenedor_dato_real_sede set indi_3_4_a_obligatoria="&real_indi_3_4_a_obligatoria&",indi_3_4_a_complementaria="&real_indi_3_4_a_complementaria&", audi_tusuario="&usu&",audi_fmodificacion=getdate() where sede_ccod="&sede_ccod&" and anos_ccod="&anos_ccod&""

end if
	conectar.ejecutaS (strInser)
	
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdrs_ncorr',"&mdre_ncorr&",'indi_3_4_a_obligatoria-indi_3_4_a_complementaria','"&real_indi_3_4_a_obligatoria&"-"&real_indi_3_4_a_complementaria&"',"&usu&",getDate())"
conectar2.ejecutaS (str_log)
'-----------------------------------------------------------------------------------------------------------------------------------------

response.Write("<pre>"&strInser&"</pre>")
end if	
if tipo_mantenedora="3" then

	existe_carr=conectar.ConsultaUno("select count(*) from mantenedor_dato_estimativo_sede where sede_ccod="&sede_ccod&"and anos_ccod="&anos_ccod&" ")
	
if existe_carr="0" then
mdes_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'mdes_ncorr'")
		strInser="insert into mantenedor_dato_estimativo_sede (mdes_ncorr,sede_ccod,carr_ccod,jorn_ccod,tcar_ccod,anos_ccod,indi_3_4_a_obligatoria,indi_3_4_a_complementaria,audi_tusuario,audi_fmodificacion)   values("&mdee_ncorr&","&sede_ccod&","&anos_ccod&","&estimativo_indi_3_4_a_obligatoria&","&estimativo_indi_3_4_a_complementaria&",'"&usu&"',getDate())"
else
mdes_ncorr=conectar.ConsultaUno("select mdes_ncorr from mantenedor_dato_estimativo_sede where sede_ccod="&sede_ccod&" and anos_ccod="&anos_ccod&"")

strInser="update mantenedor_dato_estimativo_sede set indi_3_4_a_obligatoria="&estimativo_indi_3_4_a_obligatoria&",indi_3_4_a_complementaria="&estimativo_indi_3_4_a_complementaria&" ,audi_tusuario="&usu&",audi_fmodificacion=getdate() where sede_ccod="&sede_ccod&" and anos_ccod="&anos_ccod&""

end if
	conectar.ejecutaS (strInser)
'-----------------------------------------------------------------------------------------------------------------------------------------
'aqui se guarda en un log la modificación
str_log="insert into log_datos_mantenedores_indicador (nombre_ncorr,valor_ncorr,indi_ccod,valor_ingresado,audi_tusuario,audi_fmodificacion)values('mdes_ncorr',"&mdes_ncorr&",'indi_3_4_a_obligatoria,indi_3_4_a_complementaria','"&estimativo_indi_3_4_a_obligatoria&"-"&estimativo_indi_3_4_a_complementaria&"',"&usu&",getDate())"
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