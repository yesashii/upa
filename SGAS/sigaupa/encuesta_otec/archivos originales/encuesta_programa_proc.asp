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
dcur_ncorr= f_agrega.ObtenerValorPost (filai, "dcur_ncorr")
I_preg_1= f_agrega.ObtenerValorPost (filai, "I_preg_1")
I_preg_2= f_agrega.ObtenerValorPost (filai, "I_preg_2")
I_preg_3= f_agrega.ObtenerValorPost (filai, "I_preg_3")
I_preg_4= f_agrega.ObtenerValorPost (filai, "I_preg_4")
I_preg_5= f_agrega.ObtenerValorPost (filai, "I_preg_5")
I_preg_6= f_agrega.ObtenerValorPost (filai, "I_preg_6")
I_preg_7= f_agrega.ObtenerValorPost (filai, "I_preg_7")
II_preg_1= f_agrega.ObtenerValorPost (filai, "II_preg_1")
II_preg_2= f_agrega.ObtenerValorPost (filai, "II_preg_2")
II_preg_3= f_agrega.ObtenerValorPost (filai, "II_preg_3")
II_preg_4= f_agrega.ObtenerValorPost (filai, "II_preg_4")
II_preg_5= f_agrega.ObtenerValorPost (filai, "II_preg_5")
II_preg_6= f_agrega.ObtenerValorPost (filai, "II_preg_6")
II_preg_7= f_agrega.ObtenerValorPost (filai, "II_preg_7")
III_preg= f_agrega.ObtenerValorPost (filai, "III_preg")
IV_preg= f_agrega.ObtenerValorPost (filai, "IV_preg")
V_preg= f_agrega.ObtenerValorPost (filai, "V_preg")
sug= f_agrega.ObtenerValorPost (filai, "sug")


existe=conectar.ConsultaUno("select count(*) from encu_programa_otec where  pers_ncorr_alumno="&pers_ncorr_alumno&" and dcur_ncorr="&dcur_ncorr&"")
if existe="0" then
enrp_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'encu_programa_otec'")
		strInser="insert into encu_programa_otec (enpo_ncorr ,dcur_ncorr,pers_ncorr_alumno,enpo_I_1,enpo_I_2,enpo_I_3,enpo_I_4,enpo_I_5,enpo_I_6,enpo_I_7,enpo_II_1,enpo_II_2,enpo_II_3,enpo_II_4,enpo_II_5,enpo_II_6,enpo_II_7,enpo_III,enpo_IV,enpo_V,enrp_sug,audi_fmodificacion)   values("&enrp_ncorr&","&dcur_ncorr&","&pers_ncorr_alumno&","&I_preg_1&","&I_preg_2&","&I_preg_3&","&I_preg_4&","&I_preg_5&","&I_preg_6&","&I_preg_7&","&II_preg_1&","&II_preg_2&","&II_preg_3&","&II_preg_4&","&II_preg_5&","&II_preg_6&","&II_preg_7&","&III_preg&","&IV_preg&","&V_preg&",'"&sug&"',getDate())"


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
response.Redirect("programas.asp")
 %>