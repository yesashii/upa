<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->
<%
dim cnn,rs
set cnn = server.CreateObject("ADODB.Connection")
archivo="prueba_hector.xls"
'DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo 
ruta=server.mappath(".") & "\archivos\" &archivo

response.Write(ruta&"<br>")

cnn.Open "Provider=Microsoft.Jet.OLEDB.4.0; Data Source="&ruta&"; Extended Properties=""Excel 8.0; HDR=YES;IMEX=1"";" 

 
set rs = createobject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 
on error resume next
rs.open SQLStr,cnn


if err.number <> 0 then

	response.Write(err.number)

else

	rs.MoveFirst() 
	columnas = rs.Fields.Count
	response.Write("columnas=="&columnas&"<br>")
	cont=0

		While Not rs.eof 
		sql=""
				I=9
				nombre=rs.Fields.Item(I).name
				valor=rs.Fields.Item(I).value
				tipo=rs.Fields.Item(I).type
				valor=ExtraeCremilla(valor)
				
				if EsVacio(valor) then
				response.Write("dato Vacio <br>")
				
				'For I=0 to columnas - 1    
					'response.Write("<br>"&ExtraeAcentosCaracteres(rs.Fields.Item(I).value)) 
				campo= "Nombre= "&nombre&" valor= "&valor&" Tipo="&tipo&"' <br>"
				sql=sql&campo
					response.Write(sql)	
				end if
				'Next 
                response.Write("<br>--------------------------------------------------------------------------------------------------------------------------------<br>")
				'response.end()
		  
		rs.MoveNext()
		wend
		'response.end()
end if
%>