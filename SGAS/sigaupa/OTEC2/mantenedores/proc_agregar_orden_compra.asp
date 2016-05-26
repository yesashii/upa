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
dgso_ncorr=request.Form("o[0][dgso_ncorr]")
empr_ncorr=request.Form("o[0][empr_ncorr]")
empr_ncorr_2 = request.Form("o[0][empr_ncorr_2]")
nord_compra=request.Form("o[0][nord_compra]")
fpot_ccod=request.Form("o[0][fpot_ccod]")

consulta_a = "select case count(*) when 0 then 'N' else 'S' end from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'"
registro_orden = conectar.consultaUno(consulta_a)
'response.Write(consulta_a)
'response.Write("fpot_ccod "&fpot_ccod&"-x-xxx  "&registro_orden)
if dgso_ncorr <> "" and empr_ncorr <> "" and nord_compra <> "" then 
	 if fpot_ccod="2" or fpot_ccod="3" then
	     if registro_orden = "N" or registro_orden = "" or esVacio(registro_orden) then
			 c_orden = " insert into ordenes_compras_otec (dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_otic,ocot_monto_empresa,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
					   " values ("&dgso_ncorr&","&empr_ncorr&","&nord_compra&",null,"&fpot_ccod&","&ocot_nalumnos&",null,"&ocot_monto_empresa&",'"&usuario&"',getdate())"
		 elseif registro_orden = "S" then
		     c_orden = " update ordenes_compras_otec set ocot_nalumnos="&ocot_nalumnos&",ocot_monto_empresa="&ocot_monto_empresa&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
			           " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'"
		 end if	 
		 'response.Write(c_orden)  
	 elseif fpot_ccod="4" then
	    'response.Write(registro_orden)
		 if registro_orden = "N" or registro_orden = "" or esVacio(registro_orden) then
			 c_orden = " insert into ordenes_compras_otec (dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_otic,ocot_monto_empresa,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
					   " values ("&dgso_ncorr&","&empr_ncorr&","&nord_compra&","&empr_ncorr_2&","&fpot_ccod&","&ocot_nalumnos&","&ocot_monto_otic&","&ocot_monto_empresa&",'"&usuario&"',getdate())"
		 elseif registro_orden = "S" then
			 c_orden = " update ordenes_compras_otec set ocot_nalumnos="&ocot_nalumnos&",ocot_monto_otic="&ocot_monto_otic&",ocot_monto_empresa="&ocot_monto_empresa&",audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
					   " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'"
		 end if	
	 end  if  
end if




'response.Write("<br>-----"&c_orden)
'response.End()
conectar.ejecutaS c_orden
'response.End()
'response.write(request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>