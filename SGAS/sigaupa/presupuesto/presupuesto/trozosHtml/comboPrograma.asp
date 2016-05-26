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
	"select prog_ccod, prog_tdesc from programa	" & vbCrLf & _
	"where foco_ccod = '"&valor&"'   			"  

consulta_conteo = "" & vbCrLf & _	
	"select count(prog_ccod) from programa	" & vbCrLf & _
	"where foco_ccod = '"&valor&"'   		" 	
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
<SELECT NAME="selCombo3" disabled>
<option value="0">-Bloqueado-</option>
</select>
<%
else
%>
<SELECT NAME="selCombo3" SIZE=1 onChange="traeComboProyecto(this.value); traeComboObjetivo(this.value);"> 
<option value="0">Seleccione una opci&oacute;n</option>
<% while f_busqueda.siguiente  
cadena =  EncodeUTF8(f_busqueda.ObtenerValor("prog_tdesc"))
cadena_aux = Cstr(cadenaCombo(cadena))	
%>                               
<option value="<%=f_busqueda.ObtenerValor("prog_ccod")%>"><%=cadena_aux%></option>
<% wend %>
</select>

<%end if%>