<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"


preg_1_a=request.Form("preg_1_a")
preg_1_b=request.Form("preg_1_b")
preg_1_c=request.Form("preg_1_c")
preg_1_d=request.Form("preg_1_d")
preg_2_a=request.Form("preg_2_a")
preg_2_b=request.Form("preg_2_b")
preg_2_c=request.Form("preg_2_c")
preg_2_d=request.Form("preg_2_d")
preg_3_a=request.Form("preg_3_a")
preg_3_b=request.Form("preg_3_b")
preg_3_c=request.Form("preg_3_c")
preg_3_d=request.Form("preg_3_d")
preg_4_a=request.Form("preg_4_a")
preg_4_b=request.Form("preg_4_b")
preg_4_c=request.Form("preg_4_c")
preg_4_d=request.Form("preg_4_d")
preg_5_a=request.Form("preg_5_a")
preg_5_b=request.Form("preg_5_b")
preg_5_c=request.Form("preg_5_c")
preg_5_d=request.Form("preg_5_d")
preg_6_a=request.Form("preg_6_a")
preg_6_b=request.Form("preg_6_b")
preg_6_c=request.Form("preg_6_c")
preg_6_d=request.Form("preg_6_d")
preg_7_a=request.Form("preg_7_a")
preg_7_b=request.Form("preg_7_b")
preg_7_c=request.Form("preg_7_c")
preg_7_d=request.Form("preg_7_d")
preg_8_a=request.Form("preg_8_a")
preg_8_b=request.Form("preg_8_b")
preg_8_c=request.Form("preg_8_c")
preg_8_d=request.Form("preg_8_d")
preg_9_a=request.Form("preg_9_a")
preg_9_b=request.Form("preg_9_b")
preg_9_c=request.Form("preg_9_c")
preg_9_d=request.Form("preg_9_d")


pers_ncorr=request.Form("encu[0][pers_ncorr]")
'response.Write("pers_ncorr="&pers_ncorr)
'response.End()
existe= conectar.consultaUno("select count(*) from encuesta_test where pers_ncorr="&pers_ncorr&"")

if existe="0" then
rete_ncorr = conectar.ConsultaUno("exec ObtenerSecuencia 'encuesta_test'")

'-------------------------crear registro de encuesta----------------
c_insert = "insert into encuesta_test(rete_ncorr,pers_ncorr,carr_ccod,preg_1_a,preg_1_b,preg_1_c,preg_1_d,preg_2_a,preg_2_b,preg_2_c,"&_
"preg_2_d,preg_3_a,preg_3_b,preg_3_c,preg_3_d,preg_4_a,preg_4_b,preg_4_c,preg_4_d,preg_5_a,preg_5_b,preg_5_c,preg_5_d,preg_6_a,preg_6_b,"&_
"preg_6_c,preg_6_d,preg_7_a,preg_7_b,preg_7_c,preg_7_d,preg_8_a,preg_8_b,preg_8_c,preg_8_d,preg_9_a,preg_9_b,preg_9_c,preg_9_d,fecha)"&_
" values ("&rete_ncorr&","&request.Form("encu[0][pers_ncorr]")&", '"&request.Form("encu[0][carr_ccod]")&"',"&preg_1_a&","&preg_1_b&","&_
"     "&preg_1_c&","&preg_1_d&","&preg_2_a&","&preg_2_b&","&preg_2_c&","&preg_2_d&","&preg_3_a&","&preg_3_b&","&preg_3_c&","&preg_3_d&","&preg_4_a&","&preg_4_b&","&preg_4_c&","&preg_4_d&","&_
"     "&preg_5_a&","&preg_5_b&","&preg_5_c&","&preg_5_d&","&preg_6_a&","&preg_6_b&","&preg_6_c&","&preg_6_d&","&preg_7_a&","&preg_7_b&","&preg_7_c&","&preg_7_d&","&preg_8_a&","&preg_8_b&","&_
"     "&preg_8_c&","&preg_8_d&","&preg_9_a&","&preg_9_b&","&preg_9_c&","&preg_9_d&",getDate())"
'response.Write(c_insert)
'conectar.ejecutaS c_insert

'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
if respuesta = true then
  session("mensajeerror")= "Resultados ingresados con Éxito"
else
  session("mensajeerror")= "Error al guardar los resultados"
end if
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>


