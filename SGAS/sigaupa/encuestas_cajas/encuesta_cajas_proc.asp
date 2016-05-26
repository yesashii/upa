<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

pers_nrut	=request.Form("encu[0][pers_nrut]")
preg_1		=request.Form("pregunta_1")
preg_2		=request.Form("pregunta_2")
preg_3		=request.Form("pregunta_3")
preg_4		=request.Form("pregunta_4")
preg_5		=request.Form("pregunta_5")
preg_6		=request.Form("pregunta_6")
preg_7		=request.Form("pregunta_7")
preg_8		=request.Form("pregunta_8")
preg_9		=request.Form("pregunta_9")
preg_10		=request.Form("pregunta_10")
preg_11		=request.Form("pregunta_11")
preg_12		=request.Form("pregunta_12")


set conectar = new cconexion
conectar.inicializar "upacifico"


if(pers_nrut<>"") then
	sql_existe="select count(*) from encuesta_cajas where pers_nrut="&pers_nrut
	v_existe=conectar.ConsultaUno(sql_existe)
	
	if(v_existe=0) then
		sql_inserta=" insert into encuesta_cajas ( pers_nrut,preg_1,preg_2,preg_3,preg_4,preg_5,preg_6,preg_7,preg_8,preg_9,preg_10,preg_11,preg_12,audi_tusuario,audi_fmodificacion) "&_
					" values ("&pers_nrut&","&preg_1&","&preg_2&","&preg_3&","&preg_4&","&preg_5&","&preg_6&","&preg_7&","&preg_8&","&preg_9&","&preg_10&","&preg_11&",'"&preg_12&"','"&pers_nrut&"',getdate()) " 
		
		'response.Write(sql_inserta)
		conectar.ejecutaS(sql_inserta)
	end if
	
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>