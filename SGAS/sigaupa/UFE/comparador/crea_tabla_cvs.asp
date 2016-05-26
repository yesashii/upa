<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->

<%
'-----------------------------------------------------

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next


archivo= request.QueryString("arch")
ncorr= request.QueryString("ncorr")

server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

'archivo="corporacion_profesionales.csv"

set fs=Server.CreateObject("Scripting.FileSystemObject")
set f=fs.OpenTextFile(Server.MapPath("archivos/"&archivo&""), 1)

cont=0
dim sql 
cadenacampo=""
'name_table=Replace(archivo,".csv", "")
sql="exec sp_creatabla 'ufe_tb_tmp"&ncorr&"','"
do while f.AtEndOfStream = false
linea = f.ReadLine
	if cont=0 then
		linea = split(linea,";")
		for i = 0 to ubound(linea)
			if i=0 then
			 coma=""
			else
			 coma=","
			end if
			campo=ExtraeAcentosCaracteres(linea(i))
			cadenacampo=cadenacampo&coma&"a."&campo
			sql=sql&coma&campo
		next
		'response.write linea
	end if
cont=cont+1	
loop
sql=sql&"'"

'Set f=Nothing
'Set fs=Nothing
'response.write sql
'response.End()
'conectar.ejecutaS("update  ufe_comparador  set ufco_ttabla='tb_tmp"&ncorr&"' where ufco_ncorr="&ncorr)
conectar.estadotransaccion conectar.ejecutaS("update  ufe_comparador  set ufco_tctabla='"&cadenacampo&"', ufco_ttabla='ufe_tb_tmp"&ncorr&"' where ufco_ncorr="&ncorr)
'response.write ("update  ufe_comparador  set ufco_tctabla='"&cadenacampo&"', ufco_ttabla='tb_tmp"&ncorr&"' where ufco_ncorr="&ncorr)
'response.End()
conectar.estadotransaccion conectar.EjecutaS(sql)
'response.End()
'response.write sql&"<br>"
'response.End()
f.Close
Set f=Nothing
Set fs=Nothing
'-------------------------------------------------------------------------------

set fs=Server.CreateObject("Scripting.FileSystemObject")
set f=fs.OpenTextFile(Server.MapPath("archivos/"&archivo&""), 1)
'response.write(archivo&"<br>")
'response.write(Server.MapPath("archivos/"&archivo&"")&"<br>")
'response.write(f.AtEndOfStream)
cont=0
cont_e=0
'name_table=Replace(archivo,".csv", "")
sql=""
do while f.AtEndOfStream = false
linea = f.ReadLine

	if cont>0 then
	    sql="insert into ufe_tb_tmp"&ncorr&" values("
		linea = split(linea,";")
		for i = 0 to ubound(linea)
			if i=0 then
			 coma=""
			else
			 coma=","
			end if
			campo="'"&ExtraeCremilla(linea(i))&"'"
			sql=sql&coma&campo
		next
		'response.write linea
		sql=sql&")"
		
		conectar.ejecutaS(sql)	
		if conectar.ObtenerEstadoTransaccion=false then
		response.write(sql&"<br>")
		end if
			
	end if
'response.Write(sql)
'response.End()
	if conectar.ObtenerEstadoTransaccion<>true then
		cont_e=cont_e+1
	end if 
	cont=cont+1	
loop
'response.end()


Set f=Nothing
Set fs=Nothing
response.write("Errores: "&cont_e)
'response.End()
'filename=server.mappath(".") & "\archivos\"&archivo
'Set FSO = Server.CreateObject("Scripting.FileSystemObject")
'FSO.DeleteFile(filename)
'Set FSO = nothing
session("mensajeerror")="Archivo CVS cargado exitosamente"
response.Redirect("subir_excel.asp")
'response.Redirect(
%>