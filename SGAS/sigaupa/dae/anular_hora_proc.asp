<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next


set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "modifica_hora.xml", "hora"
f_agrega.Inicializar conectar




hoto_ncorr =request.Form("hoto_ncorr")
peri_ccod =request.Form("peri_ccod")
sede_ccod =request.Form("sede_ccod")
fecha =request.Form("fecha")
indice =request.Form("indice")

 usu=negocio.obtenerUsuario



	sql_genera="update horas_tomadas set esho_ccod=4 , audi_tusuario="&usu&", audi_fmodificacion=getdate() where hoto_ncorr="&hoto_ncorr&""	
		
		  conectar.EjecutaS(sql_genera)
		session("mensajeerror")= "La hora selecionada fue anulada Correctamente"  
		
		
		response.Redirect("http://admision.upacifico.cl/peticion_horas/www/envia_correo_asp.php?sede_ccod="&sede_ccod&"&peri_ccod="&peri_ccod&"&fecha_consulta="&fecha&"&indice="&indice&"&hoto_ncorr="&hoto_ncorr&"&usuario_asp="&usu&"")

		

%>


