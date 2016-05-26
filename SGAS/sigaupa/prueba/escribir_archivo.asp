<!-- #include file = "../biblioteca/_rutas.asp" -->

<%
Server.ScriptTimeout = 2000 
v_ano_caja=2008
v_mes_caja="MAYO"
v_dia_caja=20

v_ruta_salida_nueva="C:\Inetpub\wwwroot\SIGAUPAPRUEBA\archivos_cajas_softland\"&v_ano_caja&"\"&v_mes_caja


'******************************************&"\"&v_dia_caja

	archivo_salida 		= "archivo_prueba.txt"


	set fso = Server.CreateObject("Scripting.FileSystemObject")
	set o_texto_archivo = fso.CreateTextFile(v_ruta_salida_nueva & "\" & archivo_salida)
	
	linea="este texto es solo para pruebas"
	o_texto_archivo.WriteLine(linea)	
	o_texto_archivo.Close


	'----------------------------------------------------------------------------------------------------------------
	set o_texto_archivo = Nothing
	set fso = Nothing
response.write(v_ruta_salida_nueva)
response.End()
%>