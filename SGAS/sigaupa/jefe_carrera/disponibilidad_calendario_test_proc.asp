<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

carr_ccod  =  request.Form("carr_ccod")
jorn_ccod  =  request.Form("jorn_ccod")
sede_ccod  =  request.Form("sede_ccod")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

for i = 1 to 7
	for j = 1 to 25
		valor_check = request.form("modulo_"&i&"_"&j)
		if valor_check = "" then
			valor_check = 0
		end if
		'response.Write("<br> dia= "&i&" bloque= "&j&" = "&valor_check)
		c_grabado = " select count(*) from DISPONIBILIDAD_TEST where cast(sede_ccod as varchar)='"&sede_ccod&"' "&_
		            " and carr_ccod = '"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' "&_
				    " and cast(dias_ccod as varchar) = '"&i&"' and cast(htes_ccod as varchar)='"&j&"' "
		grabado = conexion.consultaUno(c_grabado)
		if grabado = "0" then
			c_consulta = " insert into DISPONIBILIDAD_TEST (SEDE_CCOD,CARR_CCOD,JORN_CCOD,DIAS_CCOD,HTES_CCOD,ESTADO,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
			             " values ("&sede_ccod&",'"&carr_ccod&"',"&jorn_ccod&","&i&","&j&","&valor_check&",'"&negocio.obtenerUsuario&"',getDate() )"
		else
			c_consulta = " update DISPONIBILIDAD_TEST set ESTADO="&valor_check&",AUDI_TUSUARIO='"&negocio.obtenerUsuario&"',AUDI_FMODIFICACION = getDate() "&_
			             " where cast(SEDE_CCOD as varchar)='"&sede_ccod&"' and CARR_CCOD='"&carr_ccod&"' and cast(JORN_CCOD as varchar)='"&jorn_ccod&"' and cast(DIAS_CCOD as varchar)='"&i&"' and cast(HTES_CCOD as varchar)='"&j&"'"
		end if
		conexion.ejecutaS(c_consulta)
	next
next 
	
'--------------------------------------------------------------------------------------------------------------------------------------
'f_profesor.MantieneTablas false
'response.End()
'conexion.estadotransaccion false	
'response.End()
'-----------------------------------------------------------------------
Response.Redirect("disponibilidad_calendario_test.asp?busqueda%5B0%5D%5BSEDE_CCOD%5D="&sede_ccod&"&busqueda%5B0%5D%5BCARR_CCOD%5D="&carr_ccod&"&busqueda%5B0%5D%5BJORN_CCOD%5D="&jorn_ccod&"&g=1")
%>