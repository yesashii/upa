<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../funciones/funciones.asp" -->
<%
'for each k in request.QueryString()
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.End()	
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
valor 	= request.QueryString("valor")
'**************************'	
'**		BUSQUEDA		 **'
'**************************'------------------------
	set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
	f_busqueda.inicializar conexion		
	consulta_obje = "" & vbCrLf & _	
	"select obje_ccod,    			" & vbCrLf & _
	"       obje_tdesc    			" & vbCrLf & _
	"from   objetivo      			" & vbCrLf & _
	"where  prog_ccod = '"&valor&"' " & vbCrLf & _
	"order  by orden asc 			"
		
consulta_conteo = "" & vbCrLf & _	
	"select count(obje_ccod) 		" & vbCrLf & _
	"from   objetivo      			" & vbCrLf & _
	"where  prog_ccod = '"&valor&"' " 	
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta_conteo&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG
total = conexion.ConsultaUno(consulta_conteo)		
	
	f_busqueda.consultar consulta_obje	
'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
if total = 0 then
%>
<SELECT NAME="selCombo5" disabled>
<option value="0">-Bloqueado-</option>
</select>
<%
else
%>
<SELECT NAME="selCombo5" SIZE=1 onChange="traeDetaObjetivo(this.value);"> 
<option value="0">Seleccione una opci&oacute;n</option>
<% while f_busqueda.siguiente 
cadena =  EncodeUTF8(f_busqueda.ObtenerValor("obje_tdesc"))
cadena_aux = Cstr(cadenaCombo(cadena))
%>                                  
<option value="<%=f_busqueda.ObtenerValor("obje_ccod")%>"><%=cadena_aux %></option>
<% wend %>
</select>

<%end if%>
