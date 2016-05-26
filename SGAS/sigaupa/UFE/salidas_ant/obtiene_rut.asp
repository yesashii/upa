<!-- #include file = "funcion.asp" -->
<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()
function Extraer_rut(archivo)

arr_erchivo=split(archivo,".")

extension=arr_erchivo(1)

if extension="xls" then

rut=ExtraerRut_xls(archivo)

elseif extension="xlsx" then
rut=ExtraerRut_xlsx(archivo)
end if

Extraer_rut=rut
end function

function ExtraerRut_xls(archivo)
'Nos conectamos a la hoja de datos del Excel 
set cnn = createobject("ADODB.Connection")

DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo 
cnn.open DB_CONNECTIONSTRING 
'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
set rs = createobject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 

on error resume next
'response.Write(SQLStr)
'response.end()
rs.open SQLStr, DB_CONNECTIONSTRING

TieneRut=false
if err.number <> 0 then

	'response.Write(err.number)
	session("mensajeerror")="Error al cargar los datos , verifique que el nombre de la pestaña sea Hoja1"
	response.Redirect("salidas.asp")

else

	rs.MoveFirst() 
	Dim columnas
	columnas = rs.Fields.Count
	TieneRut=false
	cont=0
		While Not rs.eof 
				
				if cont=0 then
					 coma=""
				else
					 coma=","
					end if
			
					
					'response.Write("<br>"&ExtraeAcentosCaracteres(rs.Fields.Item(I).name)) 
					rut=Trim(rs.Fields.Item("rut").value)
					cadenacampo=cadenacampo&coma&rut
					 
			
		cont=cont+1
		rs.MoveNext()
		wend
end if
'response.Write(cadenacampo)
'
 'Se cierra y se destruye el objeto recordset 
 'response.end()
rs.close
' Se cierra y se destruye la conexion al archivo 
cnn.close
'response.End()
'		response.Redirect("selecciona_salida.asp?rut="&cadenacampo&"&arch="&archivo&"")
	ExtraerRut_xls	=cadenacampo
end function

function ExtraerRut_xlsx(archivo)

archivo= request.QueryString("arch")
descr= request.QueryString("desc")
ufco_ncorr= request.QueryString("ncorr")
'archivo="rut_ficticios.xlsx"

set cnn = createobject("ADODB.Connection")
set rs = createobject("ADODB.Recordset")

sFilePath = server.MapPath("archivos/"&archivo) 'path del archivo xls
sDataDir = server.MapPath("archivos") 'path de directotio que lo contiene

DB_CONNECTIONSTRING = "Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ="&sFilePath&";DefaultDir="&sDataDir&";"
sFileSQL = "SELECT * FROM [Hoja1$]"

cnn.Open DB_CONNECTIONSTRING 'abro el excel

set rs = cnn.Execute(sFileSQL)
 'selecciono los registros
	rs.MoveFirst() 
	Dim columnas
	columnas = rs.Fields.Count
	cont=0
	TieneRut=false
		While Not rs.eof 
		
			if cont=0 then
					 coma=""
				else
					 coma=","
					end if
			
					
					'response.Write("<br>"&ExtraeAcentosCaracteres(rs.Fields.Item(I).name)) 
					rut=Trim(rs.Fields.Item("rut").value)
					cadenacampo=cadenacampo&coma&rut
		
		rs.MoveNext()
		cont=cont+1
		wend


rs.Close
set rs = nothing
cnn.Close
set cnn = nothing

'response.Write(cadenacampo)

ExtraerRut_xlsx=cadenacampo
'response.End()
end function		
		
 %>