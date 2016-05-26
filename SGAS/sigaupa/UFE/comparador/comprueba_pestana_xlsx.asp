<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
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

'DB_CONNECTIONSTRING = "Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ="&sFilePath&";DefaultDir="&sDataDir&";"
DB_CONNECTIONSTRING ="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&sFilePath&";Extended Properties="&CHR(034)&"Excel 12.0 Xml;HDR=YES;IMEX=1"&CHR(034)&";"
response.Write(DB_CONNECTIONSTRING)
sFileSQL = "SELECT * FROM [Hoja1$]"


'response.End()

cnn.Open DB_CONNECTIONSTRING 'abro el exel

'set rs = cnn.Execute(sFileSQL)

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
					  TieneRut="True"
					 end if
					
					response.Write("<br>"&ExtraeAcentosCaracteres(rut))
				Next 
			end if
		
		rs.MoveNext()
		cont=cont+1
		wend


rs.Close
set rs = nothing
cnn.Close
set cnn = nothing


'response.Write("<br>"&TieneRut)
'response.End()
 if TieneRut="True" and cont <= 3001 then
		'response.Write("<br>siiiiiii")
		conectar.ejecutaS("insert into ufe_comparador (ufco_ncorr,ufco_tdescripcion,audi_tusuario,audi_fmodificacion) values ("&ufco_ncorr&",'"&descr&"','"&negocio.obtenerUsuario&"',getdate())")
	'response.Write(conectar.ObtenerEstadoTransaccion())
		if conectar.ObtenerEstadoTransaccion() then
			'response.Write("<br>Redirecciona sin problemas")
			'response.end()
			response.Redirect("crea_tabla_excel_xlsx.asp?arch="&archivo&"&ncorr="&ufco_ncorr)
		else
			'response.Write("<br>con problemas 1")
'			 response.end()
			session("mensajeerror")="hubo error intentelo nuevamente"
			response.Redirect("subir_excel.asp")
		end if
 else
	    'response.Write("nooooooo")
		session("mensajeerror")="El archivo excel no tiene el campo Rut o bien supera las 3000 líneas, en dicho caso favor comunicarse con informática"
	    response.Redirect("subir_excel.asp")
 end if
%>