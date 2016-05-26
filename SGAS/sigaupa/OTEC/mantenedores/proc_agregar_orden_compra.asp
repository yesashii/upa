<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

'response.End()

'conexion.ejecutaS "select 1"

usuario = negocio.obtenerUsuario
ocot_nalumnos=request.Form("o[0][ocot_nalumnos]")
ocot_monto_otic=request.Form("o[0][ocot_monto_otic]")
ocot_monto_empresa=request.Form("o[0][ocot_monto_empresa]")
ocot_monto_persona=request.Form("o[0][ocot_monto_persona]")
dgso_ncorr=request.Form("o[0][dgso_ncorr]")
'ocot_NRO_REGISTRO_SENCE=request.Form("o[0][ocot_NRO_REGISTRO_SENCE]")
empr_ncorr=request.Form("o[0][empr_ncorr]")
empr_ncorr_2 = request.Form("o[0][empr_ncorr_2]")
nord_compra=request.Form("o[0][nord_compra]")
fpot_ccod=request.Form("o[0][fpot_ccod]")
orco_ncorr=request.Form("o[0][orco_ncorr]")


set formulario = new CFormulario
formulario.Carga_Parametros "agrega_postulantes.xml", "detalle_datos_orden"
formulario.Inicializar conectar
formulario.ProcesaForm	


consulta_a = "select case count(*) when 0 then 'N' else 'S' end from ordenes_compras_otec where  cast(orco_ncorr as varchar)='"&orco_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'"
registro_orden = conectar.consultaUno(consulta_a)
'response.Write(consulta_a)

if dgso_ncorr <> "" and empr_ncorr <> "" and nord_compra <> "" then 

	if orco_ncorr = "" or EsVAcio(orco_ncorr) then
'	response.Write("fpot_ccod "&fpot_ccod&"-x-xxx  "&registro_orden&"<hr>")
		orco_ncorr = conectar.ConsultaUno("execute obtenersecuencia 'ordenes_compras_otec'")  
		'response.Write("orco : "&orco_ncorr)
	end if
'Response.Write("<hr> Transaccion 1:"&conectar.ObtenerEstadoTransaccion)
'## Empresa con Sence 
	 if fpot_ccod="2" or fpot_ccod="3" then
	     if registro_orden = "N" or registro_orden = "" or esVacio(registro_orden) then
		 
			 c_orden = " insert into ordenes_compras_otec (orco_ncorr,dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_otic,ocot_monto_empresa,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
					   " values ("&orco_ncorr&","&dgso_ncorr&","&empr_ncorr&","&nord_compra&",null,"&fpot_ccod&","&ocot_nalumnos&",null,"&ocot_monto_empresa&",'"&usuario&"',getdate())"
					 
		 elseif registro_orden = "S" then
		     c_orden = " update ordenes_compras_otec set ocot_nalumnos="&ocot_nalumnos&",ocot_monto_empresa="&ocot_monto_empresa&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
			           " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and orco_ncorr="&orco_ncorr&" "
		 end if	 
'		response.Write("primer if") 
'## Empresa con Otic 
	 elseif fpot_ccod="4" then
'	    response.Write("Else")
		 if registro_orden = "N" or registro_orden = "" or esVacio(registro_orden) then
			 c_orden = " insert into ordenes_compras_otec (orco_ncorr,dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_otic,ocot_monto_empresa,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
					   " values ("&orco_ncorr&","&dgso_ncorr&","&empr_ncorr&","&nord_compra&","&empr_ncorr_2&","&fpot_ccod&","&ocot_nalumnos&","&ocot_monto_otic&","&ocot_monto_empresa&",'"&usuario&"',getdate())"
		 elseif registro_orden = "S" then

			 c_orden = " update ordenes_compras_otec set ocot_nalumnos="&ocot_nalumnos&",ocot_monto_otic="&ocot_monto_otic&",ocot_monto_empresa="&ocot_monto_empresa&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
					   " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and orco_ncorr="&orco_ncorr&" "
	 
		 end if	
'## Persona natural con Empresa
	 elseif fpot_ccod="5" then
'	    response.Write("Else")
		 if registro_orden = "N" or registro_orden = "" or esVacio(registro_orden) then
			 c_orden = " insert into ordenes_compras_otec (orco_ncorr,dgso_ncorr,empr_ncorr,nord_compra,fpot_ccod,ocot_nalumnos,ocot_monto_persona,ocot_monto_empresa,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
					   " values ("&orco_ncorr&","&dgso_ncorr&","&empr_ncorr&","&nord_compra&","&fpot_ccod&","&ocot_nalumnos&","&ocot_monto_persona&","&ocot_monto_empresa&",'"&usuario&"',getdate())"
		 elseif registro_orden = "S" then

			 c_orden = " update ordenes_compras_otec set ocot_nalumnos="&ocot_nalumnos&",ocot_monto_persona="&ocot_monto_persona&",ocot_monto_empresa="&ocot_monto_empresa&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
					   " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and orco_ncorr="&orco_ncorr&" "
	 
		 end if	
	 end  if 	  
end if
'response.Write(c_orden)
conectar.ejecutaS c_orden
'Response.Write("<hr> Transaccion 2:"&conectar.ObtenerEstadoTransaccion&"<hr>")

formulario.AgregaCampoPost "orco_ncorr", orco_ncorr
formulario.MantieneTablas false

'Response.Write("<hr> Transaccion 3:"&conectar.ObtenerEstadoTransaccion)
'conectar.EstadoTransaccion false
'Response.End()

'response.write(request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>