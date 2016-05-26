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

response.Write(cadenacampo)

response.Redirect("selecciona_salida.asp?rut="&cadenacampo&"&arch="&archivo&"")
'response.End()
 
%>