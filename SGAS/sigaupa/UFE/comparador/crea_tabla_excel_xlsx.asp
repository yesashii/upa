<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->

<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

archivo= request.QueryString("arch")
ncorr= request.QueryString("ncorr")

server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set cnn = createobject("ADODB.Connection")
'set rs = createobject("ADODB.Recordset")
'ruta=server.mappath(".") & "\archivos\" &archivo
'set cnn =  server.CreateObject("ADODB.Connection")
'cnn.Open "Provider=Microsoft.Jet.OLEDB.4.0; Data Source="&ruta&"; Extended Properties=""Excel 8.0; HDR=YES;IMEX=1"";" 
'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
'set rs = server.CreateObject("ADODB.Recordset")
'SQLStr = "SELECT * FROM [Hoja1$]" 
'on error resume next
'rs.open SQLStr,cnn


sFilePath = server.MapPath("archivos/"&archivo) 'path del archivo xls
sDataDir = server.MapPath("archivos") 'path de directotio que lo contiene

DB_CONNECTIONSTRING ="Provider=Microsoft.ACE.OLEDB.12.0; Data Source=" & sFilePath & "; Extended Properties=""Excel 12.0;HDR=YES;IMEX=1"";"

'"Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ="&sFilePath&";DefaultDir="&sDataDir&" HDR=YES;IMEX=1;"
sFileSQL = "SELECT * FROM [Hoja1$]"

cnn.Open DB_CONNECTIONSTRING 

set rs = server.CreateObject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 
on error resume next
rs.open SQLStr,cnn

TieneRut=false

if err.number <> 0 then

	response.Write(err.number)
	session("mensajeerror")="Error al cargar los datos , verifique que el nombre de la pestaña sea Hoja1"
	'response.Redirect("borra_archivo.asp?arch="&archivo&"")
	response.Redirect("subir_excel.asp?")
else
	rs.MoveFirst() 
	Dim columnas,sql
	columnas = rs.Fields.Count
	cont=0
	
	
	TieneRut=false
	cadenacampo=""	
	'response.Write(columnas)
    'response.end()
	 sql="exec sp_creatabla 'ufe_tb_tmp"&ncorr&"','"
		While Not rs.eof 
		
		if cont=0 then
				For I=0 to columnas - 1    
					'response.Write("<br>"&ExtraeAcentosCaracteres(rs.Fields.Item(I).name)) 
				if I=0 then
					 coma=""
				else
					 coma=","
					end if
				campo=ExtraeAcentosCaracteres(rs.Fields.Item(I).name)
				cadenacampo=cadenacampo&coma&"a."&campo
				sql=sql&coma&campo
				'response.Write(sql)
                'response.end()
				Next 
		  end if
		cont=cont+1
		rs.MoveNext()
		wend
end if
sql=sql&"'"
'f.Close
'Set f=Nothing
'Set fs=Nothing

'response.Write(" cadena de campos "& cadenacampo)
'response.end()
conectar.ejecutaS("update  ufe_comparador  set ufco_tctabla='"&cadenacampo&"', ufco_ttabla='ufe_tb_tmp"&ncorr&"' where ufco_ncorr="&ncorr)
conectar.EjecutaP(sql)

' Se cierra y se destruye la conexion al archivo 
rs.Close
Set rs=Nothing
cnn.close
set cnn=nothing
'-------------------------------------------------------------------------------

set cnn = server.createobject("ADODB.Connection")
set rs = server.createobject("ADODB.Recordset")

sFilePath = server.MapPath("archivos/"&archivo) 'path del archivo xls
sDataDir = server.MapPath("archivos") 'path de directotio que lo contiene

DB_CONNECTIONSTRING = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=" & sFilePath & "; Extended Properties=""Excel 12.0;HDR=YES;IMEX=1"";"
'"Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ="&sFilePath&";DefaultDir="&sDataDir&";"
sFileSQL = "SELECT * FROM [Hoja1$]"

cnn.Open DB_CONNECTIONSTRING 

set rs = cnn.Execute(sFileSQL)

TieneRut=false

if err.number <> 0 then

	'response.Write(err.number)
	session("mensajeerror")="Error al cargar los datos , verifique que el nombre de la pestaña sea Hoja1"
	response.Redirect("subir_excel.asp?")

else

	rs.MoveFirst() 
	columnas = rs.Fields.Count
	cont=0
	TieneRut=false	

	 sql="exec sp_creatabla 'ufe_tb_tmp"&ncorr&"','"
		While Not rs.eof 
		
		if cont>=0 then
		     sql="insert into ufe_tb_tmp"&ncorr&" values("
				For I=0 to columnas - 1    
					'response.Write("<br>"&ExtraeAcentosCaracteres(rs.Fields.Item(I).value)) 
				if I=0 then
					 coma=""
				else
					 coma=","
					end if
				campo= rs.Fields.Item(I).value
				if EsVacio(campo) then
				campo="NULL"
				else
				campo="'"&ExtraeCremilla(campo)&"'"
				end if
				sql=sql&coma&campo
									
				Next 
				 sql=sql&")"
                'response.Write("<br> Ultimo "& sql)
				'response.end()
				
		        conectar.ejecutaS(sql)    				
		  end if
		  
			if conectar.ObtenerEstadoTransaccion<>true then
				cont_e=cont_e+1
			end if 
		cont=cont+1
		rs.MoveNext()
		wend
		'response.end()
end if
'response.end()
' Se cierra y se destruye la conexion al archivo 
rs.Close
Set rs=Nothing
cnn.close
set cnn=nothing

session("mensajeerror")="Archivo Excel cargado exitosamente"
'response.Redirect("index.asp?")
response.Redirect("subir_excel.asp?")
%>