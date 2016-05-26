<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../funciones/funciones.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
valor 	= request.QueryString("valor")
'**************************'	
'**		BUSQUEDA		 **'
'**************************'------------------------
	consulta_facu = "" & vbCrLf & _	
	"select  protic.initcap(obje_tdesc) from objetivo	" & vbCrLf & _
	"where obje_ccod = '"&valor&"'   	" 
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta_facu&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG	
texto = conexion.consultauno(consulta_facu)	
'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
if(len(texto) > 2) then
%>
<hr/>
<strong>Detalle Del Objetivo:</strong>
<%=EncodeUTF8(texto)%><br/>
<hr/>
<%
end if

%>