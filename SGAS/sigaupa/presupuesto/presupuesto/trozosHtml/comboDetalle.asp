<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../../../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../funciones/funciones.asp" -->
<%
Response.Buffer = False
Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = 0
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion
codcaja 	= request.QueryString("valor")
'**************************'	
'**		BUSQUEDA		 **'
'**************************'------------------------
	set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
	f_busqueda.inicializar conexion2	
	consulta_facu = "" & vbCrLf & _	
"select distinct cpre_ncorr,                       " & vbCrLf & _
"                cod_pre,                          " & vbCrLf & _
"                concepto_pre,                     " & vbCrLf & _
"                detalle_pre                       " & vbCrLf & _
"from   presupuesto_upa.protic.codigos_presupuesto " & vbCrLf & _
"where  cpre_bestado in ( 1 )                      " & vbCrLf & _
"and cod_pre in ('"&codcaja&"')                    " 
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta_facu&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG	
f_busqueda.consultar consulta_facu	
'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'
if codcaja="" then
%>
<SELECT NAME="selCombo6" disabled>
<option value="x">-Bloqueado-</option>
</select>
<%
else
%>
<SELECT NAME="selCombo6" onChange="traeNuevoDetalle(this.value);">
<option value="0">Seleccione un Detalle</option>
<% while f_busqueda.siguiente %>                                  
<option value="<%=f_busqueda.ObtenerValor("cpre_ncorr")%>"><%=EncodeUTF8(f_busqueda.ObtenerValor("detalle_pre"))%></option>
<% wend %>
<option value="a">Agrega nuevo detalle</option>
</select>
<%end if%>
