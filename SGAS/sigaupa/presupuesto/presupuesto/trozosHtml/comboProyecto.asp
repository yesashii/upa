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
	set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
	f_busqueda.inicializar conexion	
	consulta_facu = "" & vbCrLf & _	
	"select proye_ccod, proye_tdesc from proyecto	" & vbCrLf & _
	"where prog_ccod = '"&valor&"'   				" 
	
consulta_conteo = "" & vbCrLf & _	
	"select count(proye_ccod) from proyecto	" & vbCrLf & _
	"where prog_ccod = '"&valor&"'   		" 	
total = conexion.ConsultaUno(consulta_conteo)		
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta_facu&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG	
	f_busqueda.consultar consulta_facu	
'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
if total = 0 then
%>
<SELECT NAME="selCombo4" disabled>
<option value="0">-Bloqueado-</option>
</select>
<%
else
%>
<SELECT NAME="selCombo4" SIZE=1 onChange="traeDetaProyecto(this.value);"> 
<option value="0">Seleccione una opci&oacute;n</option>
<% while f_busqueda.siguiente 
cadena =  EncodeUTF8(f_busqueda.ObtenerValor("proye_tdesc"))
cadena_aux = Cstr(cadenaCombo(cadena))
%>                                  
<option value="<%=f_busqueda.ObtenerValor("proye_ccod")%>"><%=cadena_aux %></option>
<% wend %>
</select>

<%end if%>
