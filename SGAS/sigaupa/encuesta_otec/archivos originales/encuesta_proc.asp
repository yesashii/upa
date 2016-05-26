<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()



 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar
'
'
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "encuesta_rr_pp.xml", "encuesta"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1



pers_ncorr_alumno= f_agrega.ObtenerValorPost (filai, "pers_ncorr_alumno")
pers_ncorr_relator= f_agrega.ObtenerValorPost (filai, "pers_ncorr_relator")
seot_ncorr= f_agrega.ObtenerValorPost (filai, "seot_ncorr")
dcur_ncorr= f_agrega.ObtenerValorPost (filai, "dcur_ncorr")
I_preg_1= f_agrega.ObtenerValorPost (filai, "I_preg_1")
I_preg_2= f_agrega.ObtenerValorPost (filai, "I_preg_2")
I_preg_3= f_agrega.ObtenerValorPost (filai, "I_preg_3")
I_preg_4= f_agrega.ObtenerValorPost (filai, "I_preg_4")
I_preg_5= f_agrega.ObtenerValorPost (filai, "I_preg_5")
I_preg_6= f_agrega.ObtenerValorPost (filai, "I_preg_6")
I_preg_7= f_agrega.ObtenerValorPost (filai, "I_preg_7")
I_preg_8= f_agrega.ObtenerValorPost (filai, "I_preg_8")
I_preg_9= f_agrega.ObtenerValorPost (filai, "I_preg_9")
I_preg_10= f_agrega.ObtenerValorPost (filai, "I_preg_10")
I_preg_11= f_agrega.ObtenerValorPost (filai, "I_preg_11")
I_preg_12= f_agrega.ObtenerValorPost (filai, "I_preg_12")
I_preg_13= f_agrega.ObtenerValorPost (filai, "I_preg_13")
sug= f_agrega.ObtenerValorPost (filai, "sug")


existe=conectar.ConsultaUno("select count(*) from ENCU_RELATOR_OTEC where pers_ncorr_relator="&pers_ncorr_relator&" and pers_ncorr_alumno="&pers_ncorr_alumno&" and seot_ncorr="&seot_ncorr&"")
if existe="0" then
enrp_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'ENCU_RELATOR_OTEC'")
		strInser="insert into ENCU_RELATOR_OTEC (enrp_ncorr,pers_ncorr_alumno,pers_ncorr_relator,seot_ncorr,enrp_1,enrp_2,enrp_3,enrp_4,enrp_5,enrp_6,enrp_7,enrp_8,enrp_9,enrp_10,enrp_11,enrp_12,enrp_13,enrp_sug,audi_fmodificacion)   values("&enrp_ncorr&","&pers_ncorr_alumno&","&pers_ncorr_relator&","&seot_ncorr&","&I_preg_1&","&I_preg_2&","&I_preg_3&","&I_preg_4&","&I_preg_5&","&I_preg_6&","&I_preg_7&","&I_preg_8&","&I_preg_9&","&I_preg_10&","&I_preg_11&","&I_preg_12&","&I_preg_13&",'"&sug&"',getDate())"


response.Write("<pre>"&strInser&"</pre>")


	conectar.ejecutaS (strInser)



'response.Write("<pre>"&strInser&"</pre>")

else

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
session("mensajeerror")= "La encuesta ha sido guardada"
else
  session("mensajeerror")= "Error al guardar "
end if
else

session("mensajeerror")= "Esta seccion ya ha sido evaluada "
end if
response.Redirect("modulos.asp?dcur_ncorr="&dcur_ncorr&"")
 %>