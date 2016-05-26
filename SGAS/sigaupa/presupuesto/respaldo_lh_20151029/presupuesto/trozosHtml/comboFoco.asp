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
	consulta_foco = "" & vbCrLf & _	
					"select a.foco_ccod,                         	" & vbCrLf & _
					"       a.foco_tdesc                         	" & vbCrLf & _
					"from   foco as a                            	" & vbCrLf & _
					"       inner join eje_foco as b             	" & vbCrLf & _
					"               on a.foco_ccod = b.foco_ccod 	" & vbCrLf & _
					"                  and b.eje_ccod= '"&valor&"'  " & vbCrLf & _
					"order  by a.orden asc                       	" 
'--------------------------------------------------------
consulta_conteo = "" & vbCrLf & _	
			"select count(a.foco_ccod) 						" & vbCrLf & _
			"from   foco as a                            	" & vbCrLf & _
			"       inner join eje_foco as b             	" & vbCrLf & _
			"               on a.foco_ccod = b.foco_ccod 	" & vbCrLf & _
			"                  and b.eje_ccod= '"&valor&"'  " 	
total = conexion.ConsultaUno(consulta_conteo)	
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta_facu&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG	
	f_busqueda.consultar consulta_foco	
'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
if total = 0 then
%>
<SELECT NAME="selCombo2" disabled>
<option value="0">-Bloqueado-</option>
</select>
<%
else
%>
<SELECT NAME="selCombo2" onChange="traeComboPrograma(this.value);">
<option value="0">Seleccione un foco Del PDEI </option>
<% while f_busqueda.siguiente 
cadena =  EncodeUTF8(f_busqueda.ObtenerValor("foco_tdesc"))
cadena_aux = Cstr(cadenaCombo(cadena))
%>                                  
<option value="<%=f_busqueda.ObtenerValor("foco_ccod")%>"><%=cadena_aux%></option>
<% wend %>
</select>
<%end if%>