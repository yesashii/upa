<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
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

 
preg_1= f_agrega.ObtenerValorPost (filai, "preg_1")
'response.Write("<br> preg_1="&preg_1)
preg_3= f_agrega.ObtenerValorPost (filai, "preg_3")
'response.Write("<br> preg_3="&preg_3)
preg_3_otro= f_agrega.ObtenerValorPost (filai, "preg_3_otro")
'response.Write("<br> preg_3_otro="&preg_3_otro)
preg_4= f_agrega.ObtenerValorPost (filai, "preg_4")
'response.Write("<br> preg_4="&preg_4)
preg_4_otro= f_agrega.ObtenerValorPost (filai, "preg_4_otro")
'response.Write("<br> preg_4_otro="&preg_4_otro)
preg_5= f_agrega.ObtenerValorPost (filai, "preg_5")
'response.Write("<br>preg_5="&preg_5)

preg_6= f_agrega.ObtenerValorPost (filai, "preg_6")
'response.Write("<br> preg_6="&preg_6)
preg_7_a= f_agrega.ObtenerValorPost (filai, "preg_7_a")
'response.Write("<br> preg_7_a="&preg_7_a)
preg_7_b= f_agrega.ObtenerValorPost (filai, "preg_7_b")
'response.Write("<br> preg_7_b="&preg_7_b)
preg_7_c= f_agrega.ObtenerValorPost (filai, "preg_7_c")
'response.Write("<br> preg_7_c="&preg_7_c)
preg_7_d= f_agrega.ObtenerValorPost (filai, "preg_7_d")
'response.Write("<br> preg_7_d="&preg_7_d)
preg_7_e= f_agrega.ObtenerValorPost (filai, "preg_7_e")
'response.Write("<br> preg_7_e="&preg_7_e)
preg_7_f= f_agrega.ObtenerValorPost (filai, "preg_7_f")
'response.Write("<br> preg_7_f="&preg_7_f)
preg_7_g= f_agrega.ObtenerValorPost (filai, "preg_7_g")
'response.Write("<br> preg_7_g="&preg_7_g)
preg_7_h= f_agrega.ObtenerValorPost (filai, "preg_7_h")
'response.Write("<br> preg_7_h="&preg_7_h)
preg_7_i= f_agrega.ObtenerValorPost (filai, "preg_7_i")
'response.Write("<br> preg_7_i="&preg_7_i)

preg_8_a= f_agrega.ObtenerValorPost (filai, "preg_8_a")
'response.Write("<br> preg_8_a="&preg_8_a)
preg_8_b= f_agrega.ObtenerValorPost (filai, "preg_8_b")
'response.Write("<br> preg_8_b="&preg_8_b)
preg_8_c= f_agrega.ObtenerValorPost (filai, "preg_8_c")
'response.Write("<br> preg_8_c="&preg_8_c)
preg_8_d= f_agrega.ObtenerValorPost (filai, "preg_8_d")
'response.Write("<br> preg_8_d="&preg_8_d)
preg_8_e= f_agrega.ObtenerValorPost (filai, "preg_8_e")
'response.Write("<br> preg_8_e="&preg_8_e)
preg_8_f= f_agrega.ObtenerValorPost (filai, "preg_8_f")
'response.Write("<br> preg_8_f="&preg_8_f)
preg_8_g= f_agrega.ObtenerValorPost (filai, "preg_8_g")
'response.Write("<br> preg_8_g="&preg_8_g)
preg_8_h= f_agrega.ObtenerValorPost (filai, "preg_8_h")
'response.Write("<br> preg_8_h="&preg_8_h)

preg_9_a= f_agrega.ObtenerValorPost (filai, "preg_9_a")
'response.Write("<br> preg_9_a="&preg_9_a)
preg_9_b= f_agrega.ObtenerValorPost (filai, "preg_9_b")
'response.Write("<br> preg_9_b="&preg_9_b)
preg_9_c= f_agrega.ObtenerValorPost (filai, "preg_9_c")
'response.Write("<br> preg_9_b="&preg_9_b)
preg_9_d= f_agrega.ObtenerValorPost (filai, "preg_9_d")
'response.Write("<br> preg_9_d"&preg_9_d)
preg_9_e= f_agrega.ObtenerValorPost (filai, "preg_9_e")
'response.Write("<br> preg_9_e="&preg_9_e)
preg_9_f= f_agrega.ObtenerValorPost (filai, "preg_9_f")
'response.Write("<br> preg_9_f="&preg_9_f)
preg_9_g= f_agrega.ObtenerValorPost (filai, "preg_9_g")
'response.Write("<br> preg_9_g="&preg_9_g)
'
preg_10_a= f_agrega.ObtenerValorPost (filai, "preg_10_a")
'response.Write("<br> preg_10_a="&preg_10_a)
preg_10_b= f_agrega.ObtenerValorPost (filai, "preg_10_b")
'response.Write("<br> preg_10_b="&preg_10_b)
preg_10_c= f_agrega.ObtenerValorPost (filai, "preg_10_c")
'response.Write("<br> preg_10_c="&preg_10_c)
preg_10_d= f_agrega.ObtenerValorPost (filai, "preg_10_d")
'response.Write("<br> preg_10_d="&preg_10_d)
preg_10_e= f_agrega.ObtenerValorPost (filai, "preg_10_e")
'response.Write("<br> preg_10_e="&preg_10_e)
preg_10_f= f_agrega.ObtenerValorPost (filai, "preg_10_f")
'response.Write("<br> preg_10_f="&preg_10_f)
preg_10_g= f_agrega.ObtenerValorPost (filai, "preg_10_g")
'response.Write("<br> preg_10_g="&preg_10_g)
'
'
preg_11= f_agrega.ObtenerValorPost (filai, "preg_11")
'response.Write("<br> preg_11="&preg_11)
preg_12= f_agrega.ObtenerValorPost (filai, "preg_12")
'response.Write("<br> preg_12="&preg_12)
preg_13= f_agrega.ObtenerValorPost (filai, "preg_13")
'response.Write("<br> preg_13="&preg_13)
preg_14_a= f_agrega.ObtenerValorPost (filai, "preg_14_a")
'response.Write("<br> preg_14_a="&preg_14_a)
preg_14_b= f_agrega.ObtenerValorPost (filai, "preg_14_b")
'response.Write("<br> preg_14_b="&preg_14_b)
preg_14_c= f_agrega.ObtenerValorPost (filai, "preg_14_c")
'response.Write("<br> preg_14_c="&preg_14_c)
preg_14_d= f_agrega.ObtenerValorPost (filai, "preg_14_d")
'response.Write("<br> preg_14_d="&preg_14_d)
preg_14_e= f_agrega.ObtenerValorPost (filai, "preg_14_e")
'response.Write("<br> preg_14_e="&preg_14_e)
preg_14_f= f_agrega.ObtenerValorPost (filai, "preg_14_f")
'response.Write("<br> preg_14_f="&preg_14_f)
preg_14_g= f_agrega.ObtenerValorPost (filai, "preg_14_g")
'response.Write("<br> preg_14_g="&preg_14_g)
preg_15= f_agrega.ObtenerValorPost (filai, "preg_15")
'response.Write("<br> preg_15="&preg_15)
preg_16= f_agrega.ObtenerValorPost (filai, "preg_16")
'response.Write("<br> preg_16="&preg_16)
preg_18= f_agrega.ObtenerValorPost (filai, "preg_18")
'response.Write("<br> preg_18="&preg_18)

pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")
'response.End()
if cstr(preg_10_a)="" then
preg_10_a="NULL"

end if
if cstr(preg_10_b) ="" then

preg_10_b="NULL"

end if
if cstr(preg_10_c) ="" then

preg_10_c="NULL"

end if
if cstr(preg_10_d) ="" then
preg_10_d="NULL"

end if
if cstr(preg_10_e) ="" then

preg_10_e="NULL"

end if
if cstr(preg_10_f) ="" then

preg_10_f="NULL"
end if
if cstr(preg_10_g) ="" then

preg_10_g="NULL"
end if
if cstr(preg_10_g) <>"" then
preg_10_a=1
preg_10_b=1
preg_10_c=1
preg_10_d=1
preg_10_e=1
preg_10_f=1
end if


if cstr(preg_14_a)="" then
preg_14_a="NULL"

end if
if cstr(preg_14_b) ="" then

preg_14_b="NULL"

end if
if cstr(preg_14_c) ="" then

preg_14_c="NULL"

end if
if cstr(preg_14_d) ="" then
preg_14_d="NULL"

end if
if cstr(preg_14_e) ="" then

preg_14_e="NULL"

end if
if cstr(preg_14_f) ="" then

preg_14_g="NULL"
end if
if cstr(preg_14_g) ="" then

preg_14_g="NULL"
end if
if cstr(preg_14_g) ="7" then
preg_14_a="NULL"
preg_14_b="NULL"
preg_14_c="NULL"
preg_14_d="NULL"
preg_14_e="NULL"
preg_14_f="NULL"
end if

pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")




'response.Write(" que waaa "&nom_var)

for ind = 0 to 7-1
	nom_var=cstr("preg_2_"&ind)
	valor_preg=f_agrega.ObtenerValorPost (filai, nom_var)
	'response.Write(" assdfsd "&nom_var)
	if(valor_preg<>"") then
		response.Write("<br>Esta variable <B>"&nom_var&"</B> tiene valor: "&valor_preg )

		if preg_2_a=0 then
		preg_2_a=valor_preg
		end if
		if  preg_2_a >0 and preg_2_b=0  then
		preg_2_b=valor_preg
		end if
		
		
	end if
next

for ind = 0 to 7-1
	nom_var=cstr("preg_17_"&ind)
	valor_preg=f_agrega.ObtenerValorPost (filai, nom_var)
	'response.Write(" assdfsd "&nom_var)
	if(valor_preg<>"") then
		response.Write("<br>Esta variable <B>"&nom_var&"</B> tiene valor: "&valor_preg )

		if preg_17_a=0 then
		preg_17_a=valor_preg
		end if
		if  preg_17_a >0 and preg_17_b=0 then
		preg_17_b=valor_preg
		end if
	
		
	end if
next

'
if preg_3 ="" then
preg_3=""
end if


post_ncorr=conectar.ConsultaUno("select a.post_ncorr  from alumnos a, postulantes b where a.post_ncorr=b.post_ncorr and peri_ccod=214 and a.pers_ncorr=protic.obtener_pers_ncorr1("&pers_nrut&")")

enbi_ncorr=conectar.ConsultaUno("exec obtenerSecuencia'encuesta_biblioteca'")

		strUpdt="insert into encuesta_biblioteca (enbi_ncorr,post_ncorr,preg_1,preg_2_a,preg_2_b,preg_3,preg_3_otro,preg_4,preg_4_otro,preg_5,preg_6,preg_7_a,preg_7_b,preg_7_c,preg_7_d,preg_7_e,preg_7_f,preg_7_g,preg_8_a,preg_8_b,preg_8_c,preg_8_d,preg_8_e,preg_8_f,preg_8_g,preg_9_a,preg_9_b,preg_9_c,preg_9_d,preg_9_e,preg_9_f,preg_9_g,preg_10_a,preg_10_b,preg_10_c,preg_10_d,preg_10_e,preg_10_f,preg_10_g,preg_11,preg_12,preg_13,preg_14_a,preg_14_b,preg_14_c,preg_14_d,preg_14_e,preg_14_f,preg_14_g,preg_15,preg_16,preg_17_a,preg_17_b,preg_18,fecha)values ("&enbi_ncorr&","&post_ncorr&","&preg_1&","&preg_2_a&","&preg_2_b&","&preg_3&",'"&preg_3_otro&"',"&preg_4&",'"&preg_4_otro&"',"&preg_5&","&preg_6&","&preg_7_a&","&preg_7_b&","&preg_7_c&","&preg_7_d&","&preg_7_e&","&preg_7_f&","&preg_7_g&","&preg_8_a&","&preg_8_b&","&preg_8_c&","&preg_8_d&","&preg_8_e&","&preg_8_f&","&preg_8_g&","&preg_9_a&","&preg_9_b&","&preg_9_c&","&preg_9_d&","&preg_9_e&","&preg_9_f&","&preg_9_g&","&preg_10_a&","&preg_10_b&","&preg_10_c&","&preg_10_d&","&preg_10_e&","&preg_10_f&","&preg_10_g&","&preg_11&","&preg_12&","&preg_13&","&preg_14_a&","&preg_14_b&","&preg_14_c&","&preg_14_d&","&preg_14_e&","&preg_14_f&","&preg_14_g&","&preg_15&","&preg_16&","&preg_17_a&","&preg_17_b&",'"&preg_18&"',getdate())"

'response.Write("<pre>"&strUpdt&"</pre>")
conectar.ejecutaS (strUpdt)

	
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
'response.Write("respuesta "&Respuesta)

'if post_ncorr <>""  and tiene_beca="N" then
'if Respuesta = true then
'session("mensajeerror")= " El alumno fue ingresado con Éxito"
'else
'  session("mensajeerror")= "Error al guardar "
'end if
'response.End()
'else


 response.Redirect("../informacion_alumno_2008b/mensajes.asp")

 %>