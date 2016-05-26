<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
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



pers_ncorr= f_agrega.ObtenerValorPost (filai, "pers_ncorr")
secc_ccod= f_agrega.ObtenerValorPost (filai, "secc_ccod")
I_preg_1= f_agrega.ObtenerValorPost (filai, "I_preg_1")
I_preg_2= f_agrega.ObtenerValorPost (filai, "I_preg_2")
I_preg_3= f_agrega.ObtenerValorPost (filai, "I_preg_3")
I_preg_4= f_agrega.ObtenerValorPost (filai, "I_preg_4")
I_preg_5= f_agrega.ObtenerValorPost (filai, "I_preg_5")
I_preg_6= f_agrega.ObtenerValorPost (filai, "I_preg_6")
II_preg_1= f_agrega.ObtenerValorPost (filai, "II_preg_1")
II_preg_2= f_agrega.ObtenerValorPost (filai, "II_preg_2")
II_preg_3= f_agrega.ObtenerValorPost (filai, "II_preg_3")
II_preg_4= f_agrega.ObtenerValorPost (filai, "II_preg_4")
II_preg_5= f_agrega.ObtenerValorPost (filai, "II_preg_5")
II_preg_6= f_agrega.ObtenerValorPost (filai, "II_preg_6")
II_preg_7= f_agrega.ObtenerValorPost (filai, "II_preg_7")
II_preg_8= f_agrega.ObtenerValorPost (filai, "II_preg_8")
III_preg_1= f_agrega.ObtenerValorPost (filai, "III_preg_1")
III_preg_2= f_agrega.ObtenerValorPost (filai, "III_preg_2")
III_preg_3= f_agrega.ObtenerValorPost (filai, "III_preg_3")
III_preg_4= f_agrega.ObtenerValorPost (filai, "III_preg_4")
IV_preg_1= f_agrega.ObtenerValorPost (filai, "IV_preg_1")
IV_preg_2= f_agrega.ObtenerValorPost (filai, "IV_preg_2")
IV_preg_3= f_agrega.ObtenerValorPost (filai, "IV_preg_3")
IV_preg_4= f_agrega.ObtenerValorPost (filai, "IV_preg_4")
V_preg_1= f_agrega.ObtenerValorPost (filai, "V_preg_1")
V_preg_2= f_agrega.ObtenerValorPost (filai, "V_preg_2")
V_preg_3= f_agrega.ObtenerValorPost (filai, "V_preg_3")
I_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "I_foraleza_debilidad")
II_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "II_foraleza_debilidad")
III_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "III_foraleza_debilidad")
IV_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "IV_foraleza_debilidad")
V_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "V_foraleza_debilidad")
comentario= f_agrega.ObtenerValorPost (filai, "comentarios")

existe=conectar.ConsultaUno("select count(*) from auto_encuesta_docente_hhrr where pers_ncorr="&pers_ncorr&"and secc_ccod="&secc_ccod&"")

if existe="0" then

edrh_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'auto_encuesta_docente_rrhh'")
		strInser="insert into auto_encuesta_docente_hhrr (edrh_ncorr,secc_ccod,pers_ncorr,edrh_preg_I_1,edrh_preg_I_2,edrh_preg_I_3,edrh_preg_I_4,edrh_preg_I_5,edrh_preg_I_6,edrh_preg_II_1,edrh_preg_II_2,edrh_preg_II_3,edrh_preg_II_4,edrh_preg_II_5,edrh_preg_II_6,edrh_preg_II_7,edrh_preg_II_8,edrh_preg_III_1,edrh_preg_III_2,edrh_preg_III_3,edrh_preg_III_4,edrh_preg_IV_1,edrh_preg_IV_2 ,edrh_preg_IV_3,edrh_preg_IV_4,edrh_preg_V_1,edrh_preg_V_2,edrh_preg_V_3,edrh_I_foraleza_debilidad,edrh_II_foraleza_debilidad,edrh_III_foraleza_debilidad, edrh_IV_foraleza_debilidad,edrh_V_foraleza_debilidad,audi_fmodificacion)   values("&edrh_ncorr&",'"&secc_ccod&"','"&pers_ncorr&"','"&I_preg_1&"','"&I_preg_2&"','"&I_preg_3&"','"&I_preg_4&"','"&I_preg_5&"','"&I_preg_6&"','"&II_preg_1&"','"&II_preg_2&"','"&II_preg_3&"','"&II_preg_4&"','"&II_preg_5&"','"&II_preg_6&"','"&II_preg_7&"','"&II_preg_8&"','"&III_preg_1&"','"&III_preg_2&"','"&III_preg_3&"','"&III_preg_4&"','"&IV_preg_1&"','"&IV_preg_2&"','"&IV_preg_3&"','"&IV_preg_4&"','"&V_preg_1&"','"&V_preg_2&"','"&V_preg_3&"','"&I_foraleza_debilidad&"','"&II_foraleza_debilidad&"','"&III_foraleza_debilidad&"', '"&IV_foraleza_debilidad&"','"&V_foraleza_debilidad&"',getDate())"


	conectar.ejecutaS (strInser)



'response.Write("<pre>"&strInser&"</pre>")

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
session("mensajeerror")= "Esta sección ya fue evaluada"
end if
'
response.Redirect("asignaturas.asp")
'end if
'if pag=2 then
'response.Redirect("encuesta_parte3.asp")
'end if
' if pag=3 then
' response.Redirect("encuesta_parte4.asp")
'end if
 %>