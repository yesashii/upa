<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_costo_vida"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

covi_ncorr= f_agrega.ObtenerValorPost (filai, "covi_ncorr")
tcvi_ccod= f_agrega.ObtenerValorPost (filai, "tcvi_ccod")
ciex_ccod= f_agrega.ObtenerValorPost (filai, "ciex_ccod")
covi_comentario= f_agrega.ObtenerValorPost (filai, "comentario")
covi_monto= f_agrega.ObtenerValorPost (filai, "monto")
anos_ccod= f_agrega.ObtenerValorPost (filai, "anos_ccod")
pais_ccod= f_agrega.ObtenerValorPost (filai, "pais_ccod")
 'acre_ncorr=1000
 
 existe=conectar.ConsultaUno("select count(*) from costo_vida where ciex_ccod="&ciex_ccod&" and tcvi_ccod="&tcvi_ccod&" and anos_ccod="&anos_ccod&"")
 usu=negocio.obtenerUsuario
  
 
  
 if cdbl(existe)=0 then
 	 covi_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'universidades'")
	p_insert="insert into costo_vida (covi_ncorr,tcvi_ccod,ciex_ccod,covi_comentario,covi_monto,anos_ccod,audi_tusuario,audi_fmodificacion) values("&covi_ncorr&","&tcvi_ccod&","&ciex_ccod&",'"&covi_comentario&"','"&covi_monto&"',"&anos_ccod&",'"&usu&"',getDate())"		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
	
else
	p_insert="update costo_vida set covi_comentario='"&covi_comentario&"',covi_monto='"&covi_monto&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where covi_ncorr="&covi_ncorr&""		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
end if
next
Respuesta = conectar.ObtenerEstadoTransaccion()

'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
session("mensajeerror")= " Se ha Guardado con exito"
else
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_costo_vida.asp?b%5B0%5D%5Bcovi_ncorr%5D=&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Banos_ccod%5D="&anos_ccod&"&b%5B0%5D%5Btcvi_ccod%5D=&b%5B0%5D%5Bmonto%5D=&b%5B0%5D%5Bcomentario%5D=")









%>


