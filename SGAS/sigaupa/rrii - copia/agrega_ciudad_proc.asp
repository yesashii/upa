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
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_ciudad_extranjera"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
'for filai = 0 to f_agrega.CuentaPost - 1






ciex_tdesc =request.Form("b[0][ciex_tdesc]") 
pais_ccod =request.Form("b[0][pais_ccod]") 


consul="select case count(*) when 0 then 'N' else 'S' end from ciudades_extranjeras where pais_ccod="&pais_ccod&" and ltrim(rtrim(ciex_tdesc))=ltrim(rtrim('"&ciex_tdesc&"'))"
response.Write("<pre>"&consul&"</pre>")
existe=conectar.ConsultaUno(consul)


if ciex_tdesc<>"" and pais_ccod<>"" and existe="N" then

 ciex_ccod=conectar.ConsultaUno("exec ObtenerSecuencia 'ciudades_extranjeras'")
 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 
	p_insert="insert into ciudades_extranjeras(ciex_ccod,ciex_tdesc,pais_ccod,audi_tusuario,audi_fmodificacion) values("&ciex_ccod&",'"&ciex_tdesc&"',"&pais_ccod&",'"&usu&"',getDate())"		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
	Respuesta = conectar.ObtenerEstadoTransaccion()
else
Respuesta="false"
end if

'next


pais_ccod=request.Form("b[0][pais_ccod]")

'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta="true"  and existe="N" then
session("mensajeerror")= " La Ciudad fue Guardada"
end if

 if Respuesta="false" and existe="N" then
  session("mensajeerror")= "Error al Guardar "
end if

if Respuesta="false"  and existe="S" then
  session("mensajeerror")= "Ya existe esta ciudad para el pais seleccionado"
end if
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_ciudad_convenio.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"")









%>


