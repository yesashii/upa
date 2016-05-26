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
secc_ccod=f_agrega.ObtenerValorPost (filai, "secc_ccod")
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


existe=conectar.ConsultaUno("select count(*) from dir_encuesta_docente_hhrr where pers_ncorr="&pers_ncorr&" and secc_ccod="&secc_ccod&"")

rut_diretor=negocio.obtenerUsuario

pers_ncorr_dir=conectar.consultaUno("select pers_ncorr from personas where pers_nrut="&rut_diretor&"")

if existe="0" then
derh_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'dir_encuesta_docente_hhrr'")
		strInser="insert into dir_encuesta_docente_hhrr (derh_ncorr,secc_ccod,pers_ncorr,pers_ncorr_director,derh_preg_I_1,derh_preg_I_2,derh_preg_I_3,derh_preg_I_4,derh_preg_I_5,derh_preg_I_6,derh_preg_I_7,derh_preg_I_8,derh_preg_I_9,derh_preg_I_10,derh_preg_II_1,derh_preg_II_2,derh_preg_II_3,derh_preg_II_4,derh_preg_II_5,derh_preg_II_6,derh_preg_II_7,derh_preg_II_8,derh_preg_II_9,derh_preg_II_10,derh_preg_II_11,derh_I_foraleza_debilidad,derh_II_foraleza_debilidad,derh_III_a,derh_III_b,derh_III_c,derh_IV_fortaleza_debilidad,audi_fmodificacion)   values("&derh_ncorr&","&secc_ccod&",'"&pers_ncorr&"',"&pers_ncorr_dir&",'"&I_preg_1&"','"&I_preg_2&"','"&I_preg_3&"','"&I_preg_4&"','"&I_preg_5&"','"&I_preg_6&"','"&I_preg_7&"','"&I_preg_8&"','"&I_preg_9&"','"&I_preg_10&"','"&II_preg_1&"','"&II_preg_2&"','"&II_preg_3&"','"&II_preg_4&"','"&II_preg_5&"','"&II_preg_6&"','"&II_preg_7&"','"&II_preg_8&"','"&II_preg_9&"','"&II_preg_10&"','"&II_preg_11&"','"&I_foraleza_debilidad&"','"&II_foraleza_debilidad&"','"&III_a_foraleza_debilidad&"', '"&III_b_foraleza_debilidad&"','"&III_c_foraleza_debilidad&"','"&IV_foraleza_debilidad&"',getDate())"




	conectar.ejecutaS (strInser)
'response.Write("<pre>"&strInser&"</pre>")
'response.End()



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
response.Redirect("asignaturas.asp?pers_ncorr="&pers_ncorr&"&carr_ccod="&carr_ccod&"")
 %>