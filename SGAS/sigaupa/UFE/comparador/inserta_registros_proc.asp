<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()
server.ScriptTimeout = 150000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

archivo= request.form("b[0][arch]")
pestana= request.form("b[0][pes]")
arancel=request.form("b[0][arancel]")
mantencion=request.form("b[0][mantencion]")
peri_ccod=request.form("b[0][peri_ccod]")
if arancel <>"" then
tdet_ccod=arancel
end if
if mantencion <>"" then
tdet_ccod=mantencion
end if

response.Write("<br> archivo="&archivo)
response.Write("<br> pestana="&pestana&"<br>")
'response.End()
'Nos conectamos a la hoja de datos del Excel 
set cnn = createobject("ADODB.Connection")

DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo 
cnn.open DB_CONNECTIONSTRING 
'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
set rs = createobject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 

on error resume next
rs.open SQLStr, DB_CONNECTIONSTRING

if err.number <> 0 then

response.Write(err.number)
'session("mensajeerror")= "El nombre de La pestaña no es Correcto"
'response.Redirect("subir_excel.asp")
else

rs.MoveFirst() 
contador=0
contador2=0
	While Not rs.eof 
	contador2=contador2+1
	rut = Trim(rs.fields("rut").value) 
	rs.MoveNext() 
	'Conexion para insertar la compañía en caso de que no exista  conectar.ConsultaUno(
	
	wend
end if

'response.end()
'
'response.Write("<BR>"&contador&"<BR>")
'response.Write("<BR>"&contador2&"<BR>")
 'Se cierra y se destruye el objeto recordset 
 'response.end()
rs.close
 'rs = Nothing 
' Se cierra y se destruye la conexion al archivo 
 db.close
 'db = Nothing


'



'
'
'Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
session("mensajeerror")= " Fueron procesados "&contador2&" alumnos de los cuales "&contador&" fueron guardados"
response.Redirect("subir_excel.asp")
%>




