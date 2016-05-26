<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "termino_convenios"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm


for each k in request.form

 'response.Write(request.Form(k)&"</br>")
 Respuesta=cdbl(conectar.ConsultaUno("exec GENERA_CONVENIO_INTERNACIONAL_NUEVO_ANO "&request.Form(k)&""))
next

'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = 0 then
  session("mensajeerror")= " Se Crearon con exito los convenios"
  
elseif  Respuesta = 99 then
  session("mensajeerror")= "El Convenio ya esta Creado para el año siguiente"
elseif  Respuesta = 1 or Respuesta = 2 then
  session("mensajeerror")= "Error al Guardar "
 else 
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("TERMINO_CONVENIO.ASP")









%>


