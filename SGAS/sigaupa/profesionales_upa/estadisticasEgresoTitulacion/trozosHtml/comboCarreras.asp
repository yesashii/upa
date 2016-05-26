<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../dlls/dll_1.asp" -->
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
	f_busqueda.Carga_Parametros "estadisticas_egreso_titulacion.xml", "buscador"
	f_busqueda.inicializar conexion
'	consulta="Select '"&facu_ccod&"' as facu_ccod, '"&carr_ccod&"' as carr_ccod"	
'	f_busqueda.consultar consulta	
	consulta_facu = "" & vbCrLf & _					
					"select distinct ltrim(rtrim(cast(a.carr_ccod as VARCHAR))) as carr_ccod, 	" & vbCrLf & _
					"                a.carr_tdesc  as  carr_tdesc                              	" & vbCrLf & _
					"from   carreras as a                                                     	" & vbCrLf & _
					"       inner join areas_academicas as b                                  	" & vbCrLf & _
					"               on a.area_ccod = b.area_ccod                              	" & vbCrLf & _
					"       inner join facultades as c                                        	" & vbCrLf & _
					"               on b.facu_ccod = c.facu_ccod                              	" & vbCrLf & _
					"                  and c.facu_ccod = '"&valor&"'   							" & vbCrLf & _
					"  order by  carr_tdesc							  							" 
				f_busqueda.consultar consulta_facu	
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG

'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
%>
<select name="selectCarrera" id="selectCarrera">
<option value="0">TODAS</option>
<% while f_busqueda.siguiente %>                                  
<option value="<%=f_busqueda.ObtenerValor("carr_ccod")%>"><%=EncodeUTF8(f_busqueda.ObtenerValor("carr_tdesc")) %></option>
<% wend %>
</select>