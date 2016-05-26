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
carr_ccod= f_agrega.ObtenerValorPost (filai, "carr_ccod")
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
II_preg_1= f_agrega.ObtenerValorPost (filai, "II_preg_1")
II_preg_2= f_agrega.ObtenerValorPost (filai, "II_preg_2")
II_preg_3= f_agrega.ObtenerValorPost (filai, "II_preg_3")
II_preg_4= f_agrega.ObtenerValorPost (filai, "II_preg_4")
II_preg_5= f_agrega.ObtenerValorPost (filai, "II_preg_5")
II_preg_6= f_agrega.ObtenerValorPost (filai, "II_preg_6")
II_preg_7= f_agrega.ObtenerValorPost (filai, "II_preg_7")
II_preg_8= f_agrega.ObtenerValorPost (filai, "II_preg_8")
II_preg_9= f_agrega.ObtenerValorPost (filai, "II_preg_9")
II_preg_10= f_agrega.ObtenerValorPost (filai, "II_preg_10")
II_preg_11= f_agrega.ObtenerValorPost (filai, "II_preg_11")
I_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "I_foraleza_debilidad")
II_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "II_foraleza_debilidad")
IV_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "IV_foraleza_debilidad")
III_a_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "III_a")
III_b_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "III_b")
III_c_foraleza_debilidad= f_agrega.ObtenerValorPost (filai, "III_c")
derh_ncorr=f_agrega.ObtenerValorPost (filai, "derh_ncorr")


existe=conectar.ConsultaUno("select count(*) from dir_encuesta_docente_hhrr where pers_ncorr="&pers_ncorr&" and secc_ccod="&secc_ccod&"")

rut_diretor=negocio.obtenerUsuario

pers_ncorr_dir=conectar.consultaUno("select pers_ncorr from personas where pers_nrut="&rut_diretor&"")




strInser="update dir_encuesta_docente_hhrr set derh_preg_I_1="&I_preg_1&",derh_preg_I_2="&I_preg_2&",derh_preg_I_3="&I_preg_3&",derh_preg_I_4="&I_preg_4&",derh_preg_I_5="&I_preg_5&",derh_preg_I_6="&I_preg_6&",derh_preg_I_7="&I_preg_7&",derh_preg_I_8="&I_preg_8&",derh_preg_I_9="&I_preg_9&",derh_preg_I_10="&I_preg_10&",derh_preg_II_1="&II_preg_1&",derh_preg_II_2="&II_preg_2&",derh_preg_II_3="&II_preg_3&",derh_preg_II_4="&II_preg_4&",derh_preg_II_5="&II_preg_5&",derh_preg_II_6="&II_preg_6&",derh_preg_II_7="&II_preg_7&",derh_preg_II_8="&II_preg_8&",derh_preg_II_9="&II_preg_9&",derh_preg_II_10="&II_preg_10&",derh_preg_II_11="&II_preg_11&",derh_I_foraleza_debilidad='"&I_foraleza_debilidad&"',derh_II_foraleza_debilidad='"&II_foraleza_debilidad&"',derh_III_a='"&III_a_foraleza_debilidad&"',derh_III_b='"&III_b_foraleza_debilidad&"',derh_III_c='"&III_c_foraleza_debilidad&"',derh_IV_fortaleza_debilidad='"&IV_foraleza_debilidad&"',audi_fmodificacion=getDate() where derh_ncorr="&derh_ncorr&""
	conectar.ejecutaS (strInser)
'response.Write("<pre>"&strInser&"</pre>")
'response.End()




	
next

'response.End()

'response.Write("<pre>rut= "&pers_nrut&"</pre>")	
'response.Write("<pre>xdv= "&pers_xdv&"</pre>")
'response.Write("<pre>usu= "&usu&"</pre>")
'response.Write("<pre>peri= "&peri_ccod&"</pre>")
'response.Write("<pre>pos= "&post_ncorr&"</pre>")
'response.Write("<pre>tdet= "&tdet_ccod&"</pre>")
'response.Write("<pre>tiene = "&tiene_beca&"</pre>")
'response.Write("<pre>tiene = "&cuenta_post&"</pre>"
'response.Write("respuesta "&Respuesta)
'response.Write("<br>"&strInser)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()

'----------------------------------------------------
response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
session("mensajeerror")= "La encuesta ha sido guardada"
else
  session("mensajeerror")= "Error al guardar "
end if
response.Redirect("asignaturas.asp?pers_ncorr="&pers_ncorr&"&carr_ccod="&carr_ccod&"")
 %>