<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->

<%



server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


archivo= request.QueryString("arch")
descr= request.QueryString("desc")
ufco_ncorr= request.QueryString("ncorr")
'archivo="rut_ficticios.xlsx"

set cnn = createobject("ADODB.Connection")
'set rs = createobject("ADODB.Recordset")

sFilePath = server.MapPath("archivos/"&archivo) 'path del archivo xls
sDataDir = server.MapPath("archivos") 'path de directotio que lo contiene


'DB_CONNECTIONSTRING = "Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ="&sFilePath&";DefaultDir="&sDataDir&";"
DB_CONNECTIONSTRING ="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&sFilePath&";Extended Properties="&CHR(034)&"Excel 12.0 Xml;HDR=YES"&CHR(034)&";"
SQLStr = "SELECT * FROM [Hoja1$]"

cnn.Open DB_CONNECTIONSTRING 'abro el excel

'response.Write(DB_CONNECTIONSTRING)
'response.End()

set rs = server.CreateObject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 
on error resume next
rs.open SQLStr,cnn

 'selecciono los registros
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
					
					'response.Write(rut)
				Next 
			end if
		
		rs.MoveNext()
		cont=cont+1
		wend


rs.Close
set rs = nothing
cnn.Close
set cnn = nothing


'response.End()
 if TieneRut then
	'response.Write(conectar.ObtenerEstadoTransaccion())
		response.Redirect("selecciona_salida.asp?arch="&archivo&"")
 else
	    session("mensajeerror")="El archivo excel no tiene el campo Rut"
	    response.Redirect("salidas.asp")
 end if
%>