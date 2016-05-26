<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->


<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar



archivo= request.QueryString("arch")

'Nos conectamos a la hoja de datos del Excel 
set cnn = createobject("ADODB.Connection")

sFilePath = server.MapPath("archivos/"&archivo) 'path del archivo xls
sDataDir = server.MapPath("archivos") 'path de directotio que lo contiene

'RESPONSE.Write(server.mappath(".") & "\archivos\" &archivo)
DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel DRIVER (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo 
'DB_CONNECTIONSTRING ="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&sFilePath&";Extended Properties="&CHR(034)&"Excel 12.0 Xml;HDR=YES;IMEX=1"&CHR(034)&";"

'response.Write("abre conexion")
cnn.open DB_CONNECTIONSTRING 

'response.Write(SQLStr)
'response.end()
'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
set rs = createobject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 

on error resume next

'response.Write(SQLStr)
'response.end()

rs.open SQLStr, DB_CONNECTIONSTRING

TieneRut=false
if err.number <> 0 then

	response.Write(err.number)
	session("mensajeerror")="Error al cargar los datos , verifique que el nombre de la pestaña sea Hoja1"
	response.Redirect("salidas.asp")

else

	rs.MoveFirst() 
	Dim columnas
	columnas = rs.Fields.Count
	cont=0
	TieneRut=false
		While Not rs.eof 
		
			if cont=0 then
				For I=0 to columnas - 1    
					
					'response.Write("<br>"&ExtraeAcentosCaracteres(rs.Fields.Item(I).name)) 
					rut=Trim(rs.Fields.Item(I).name)
					 if  ExtraeAcentosCaracteres(rut)="rut" then
					  TieneRut=true
					 end if
				Next 
			end if
		
		rs.MoveNext()
		cont=cont+1
		wend
end if

'
 'Se cierra y se destruye el objeto recordset 
 'response.end()
rs.close
' Se cierra y se destruye la conexion al archivo 
cnn.close
'response.Write("<br>Tiene Rut "&TieneRut)
'response.end()
 
 if TieneRut then
		response.Redirect("selecciona_salida.asp?arch="&archivo&"")
 else
	    session("mensajeerror")="El archivo excel no tiene el campo Rut"
	    response.Redirect("salidas.asp")
 end if
 'response.Write("<br>Fin ejecucion asp")
' response.end()
 %>