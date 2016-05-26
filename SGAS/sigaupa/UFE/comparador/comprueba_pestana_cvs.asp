<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->

<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

archivo= request.QueryString("arch")
descr= request.QueryString("desc")
ufco_ncorr= request.QueryString("ncorr")
server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


'
'archivo="corporacion_profesionales.csv"
TieneRut=false
set fs=Server.CreateObject("Scripting.FileSystemObject")
set f=fs.OpenTextFile(Server.MapPath("archivos/"&archivo&""), 1)

cont=0
do while f.AtEndOfStream = false
linea = f.ReadLine
	if cont=0 then
		linea = split(linea,";")
		for i = 0 to ubound(linea)
			'response.Write(ExtraeAcentosCaracteres(linea(i))&"<br>")
			
			if ExtraeAcentosCaracteres(linea(i))="rut" then
				TieneRut=true
			end if
			
		next
		response.write ("TieneRut " &TieneRut)
	end if
cont=cont+1	
loop
f.Close
Set f=Nothing
Set fs=Nothing
'response.end()

if TieneRut then
 	conectar.ejecutaS("insert into ufe_comparador (ufco_ncorr,ufco_tdescripcion,audi_tusuario,audi_fmodificacion) values ("&ufco_ncorr&",'"&descr&"','"&negocio.obtenerUsuario&"',getdate())")
	
	if conectar.ObtenerEstadoTransaccion() then
 		response.Redirect("crea_tabla_cvs.asp?arch="&archivo&"&ncorr="&ufco_ncorr)
	else
		
		session("mensajeerror")="hubo error intentelo nuevamente"
		response.Redirect("subir_excel.asp")
	end if
 else
	 session("mensajeerror")="El archivo excel no tiene el campo Rut"
	response.Redirect("subir_excel.asp")
 end if
'response.Redirect("subir_excel.asp")
'session("mensajeerror")= "El Archivo CSV no contiene el campo rut"
'response.Redirect("borra_archivo.asp?arch="&archivo&"")
%>