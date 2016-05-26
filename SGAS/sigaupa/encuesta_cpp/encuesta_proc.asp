<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_cpp.asp" -->
<%
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()



 
set conectar = new CConexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar
'
'


preg_1_1=request.Form("encu[0][preg_1_1]")
if preg_1_1= "" then
preg_1_1=0
end if
preg_1_2=request.Form("encu[0][preg_1_2]")
if preg_1_2= "" then
preg_1_2=0
end if
preg_1_3=request.Form("encu[0][preg_1_3]")
if preg_1_3= "" then
preg_1_3=0
end if
preg_1_4=request.Form("encu[0][preg_1_4]")
if preg_1_4= "" then
preg_1_4=0
end if
preg_1_5=request.Form("encu[0][preg_1_5]")
if preg_1_5= "" then
preg_1_5=0
end if
preg_1_6=request.Form("encu[0][preg_1_6]")
if preg_1_6= "" then
preg_1_6=0
end if
preg_1_7=request.Form("encu[0][preg_1_7]")
if preg_1_7= "" then
preg_1_7=0
end if
preg_1_8=request.Form("encu[0][preg_1_8]")
if preg_1_8= "" then
preg_1_8=0
end if
preg_1_9=request.Form("encu[0][preg_1_9]")
if preg_1_9= "" then
preg_1_9=0
end if
preg_1_10=request.Form("encu[0][preg_1_10]")
if preg_1_10= "" then
preg_1_10=0
end if
preg_2=request.Form("encu[0][preg_2]")
preg_3_1=request.Form("encu[0][preg_3_1]")
if preg_3_1= "" then
preg_3_1=0
end if
preg_3_2=request.Form("encu[0][preg_3_2]")
if preg_3_2= "" then
preg_3_2=0
end if
preg_3_3=request.Form("encu[0][preg_3_3]")
if preg_3_3= "" then
preg_3_3=0
end if
preg_3_4=request.Form("encu[0][preg_3_4]")
if preg_3_4= "" then
preg_3_4=0
end if
preg_3_5=request.Form("encu[0][preg_3_5]")
if preg_3_5= "" then
preg_3_5=0
end if
preg_3_6=request.Form("encu[0][preg_3_6]")
if preg_3_6= "" then
preg_3_6=0
end if
preg_3_7=request.Form("encu[0][preg_3_7]")
if preg_3_7= "" then
preg_3_7=0
end if
preg_3_8=request.Form("encu[0][preg_3_8]")
if preg_3_8= "" then
preg_3_8=0
end if
preg_4_1=request.Form("encu[0][preg_4_1]")
if preg_4_1= "" then
preg_4_1=0
end if
preg_4_2=request.Form("encu[0][preg_4_2]")
if preg_4_2= "" then
preg_4_2=0
end if
preg_4_3=request.Form("encu[0][preg_4_3]")
if preg_4_3= "" then
preg_4_3=0
end if
preg_4_4=request.Form("encu[0][preg_4_4]")
if preg_4_4= "" then
preg_4_4=0
end if
preg_4_5=request.Form("encu[0][preg_4_5]")
if preg_4_5= "" then
preg_4_5=0
end if
preg_4_6=request.Form("encu[0][preg_4_6]")
if preg_4_6= "" then
preg_4_6=0
end if
preg_4_7=request.Form("encu[0][preg_4_7]")
if preg_4_7= "" then
preg_4_7=0
end if
preg_4_8=request.Form("encu[0][preg_4_8]")
if preg_4_8= "" then
preg_4_8=0
end if
preg_5_1=request.Form("encu[0][preg_5_1]")
if preg_5_1= "" then
preg_5_1=0
end if
preg_5_2=request.Form("encu[0][preg_5_2]")
if preg_5_2= "" then
preg_5_2=0
end if
preg_5_3=request.Form("encu[0][preg_5_3]")
if preg_5_3= "" then
preg_5_3=0
end if
preg_5_4=request.Form("encu[0][preg_5_4]")
if preg_5_4= "" then
preg_5_4=0
end if
preg_5_5=request.Form("encu[0][preg_5_5]")
if preg_5_5= "" then
preg_5_5=0
end if
preg_5_6=request.Form("encu[0][preg_5_6]")
if preg_5_6= "" then
preg_5_6=0
end if
preg_6_1=request.Form("encu[0][preg_6_1]")
preg_6_2=request.Form("encu[0][preg_6_2]")
preg_6_3=request.Form("encu[0][preg_6_3]")
preg_6_4=request.Form("encu[0][preg_6_4]")
preg_6_5=request.Form("encu[0][preg_6_5]")
preg_6_6=request.Form("encu[0][preg_6_6]")
preg_6_7=request.Form("encu[0][preg_6_7]")
preg_6_8=request.Form("encu[0][preg_6_8]")
preg_6_9=request.Form("encu[0][preg_6_9]")
preg_6_10=request.Form("encu[0][preg_6_10]")
preg_6_11=request.Form("encu[0][preg_6_11]")
preg_6_12=request.Form("encu[0][preg_6_12]")
preg_6_13=request.Form("encu[0][preg_6_13]")
preg_7=request.Form("encu[0][carr_ccod]")
preg_8=request.Form("encu[0][preg_8]")
preg_9=request.Form("encu[0][preg_9]")
sexo=request.Form("encu[0][sexo]")
edad=request.Form("encu[0][edad]")
eciv=request.Form("encu[0][eciv]")
rut=request.Form("encu[0][pers_nrut]")
dv=request.Form("encu[0][pers_xdv]")
email=request.Form("encu[0][email]")

existe=conectar.ConsultaUno("select  count(*) from encuesta_cpp where rut="&rut&"")

if existe="0" then

		strInser="insert into encuesta_cpp (rut,dv ,preg_1_1,preg_1_2,preg_1_3,preg_1_4,preg_1_5,preg_1_6,preg_1_7,preg_1_8,preg_1_9,preg_1_10,preg_2,preg_3_1,preg_3_2,preg_3_3,preg_3_4,preg_3_5,preg_3_6,preg_3_7,preg_3_8,preg_4_1,preg_4_2,preg_4_3,preg_4_4,preg_4_5,preg_4_6,preg_4_7,preg_4_8,preg_5_1,preg_5_2,preg_5_3,preg_5_4,preg_5_5,preg_5_6,preg_6_1,preg_6_2,preg_6_3,preg_6_4,preg_6_5,preg_6_6,preg_6_7,preg_6_8,preg_6_9,preg_6_10,preg_6_11,preg_6_12,preg_6_13,preg_7,preg_8,preg_9,sexo,edad,eciv,email,AUDI_FMODIFICACION) values ("&rut&",'"&dv&"','"&preg_1_1&"','"&preg_1_2&"','"&preg_1_3&"','"&preg_1_4&"','"&preg_1_5&"','"&preg_1_6&"','"&preg_1_7&"','"&preg_1_8&"','"&preg_1_9&"','"&preg_1_10&"','"&preg_2&"','"&preg_3_1&"','"&preg_3_2&"','"&preg_3_3&"','"&preg_3_4&"','"&preg_3_5&"','"&preg_3_6&"','"&preg_3_7&"','"&preg_3_8&"','"&preg_4_1&"','"&preg_4_2&"','"&preg_4_3&"','"&preg_4_4&"','"&preg_4_5&"','"&preg_4_6&"','"&preg_4_7&"','"&preg_4_8&"','"&preg_5_1&"','"&preg_5_2&"','"&preg_5_3&"','"&preg_5_4&"','"&preg_5_5&"','"&preg_5_6&"','"&preg_6_1&"','"&preg_6_2&"','"&preg_6_3&"','"&preg_6_4&"','"&preg_6_5&"','"&preg_6_6&"','"&preg_6_7&"','"&preg_6_8&"','"&preg_6_9&"','"&preg_6_10&"','"&preg_6_11&"','"&preg_6_12&"','"&preg_6_13&"','"&preg_7&"','"&preg_8&"','"&preg_9&"','"&sexo&"','"&edad&"','"&eciv&"','"&email&"',getDate())"


'response.Write("<pre>"&strInser&"</pre>")


	conectar.ejecutaS (strInser)



'response.Write("<pre>"&strInser&"</pre>")

else

end if


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
response.Redirect("menu_salida.asp")
else

session("mensajeerror")= "Solo puedes realizar una vez la encuesta"
response.Redirect("encuesta.asp")
end if

 %>