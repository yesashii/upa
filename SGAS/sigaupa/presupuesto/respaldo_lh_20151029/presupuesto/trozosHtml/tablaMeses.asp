<!-- #include file = "../../../biblioteca/_conexion.asp" -->
<!-- #include file = "../../../biblioteca/_negocio.asp" -->
<!-- #include file = "../../../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../funciones/funciones.asp" -->
<%
Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = 0


set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

'for each k in request.QueryString()
' response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.end

cod_pre			= request.QueryString("valor")
area_ccod   	= request.QueryString("area_ccod")
eje_ccod    	= request.QueryString("eje_ccod")
prog_ccod   	= request.QueryString("prog_ccod")
proye_ccod  	= request.QueryString("proye_ccod")
obje_ccod   	= request.QueryString("obje_ccod")
cpre_ncorr   	= request.QueryString("cpre_ncorr")

if cpre_ncorr = "a" then ' si el detalle es agregar nuevo.
response.end()
end if

set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
	f_busqueda.inicializar conexion		
consulta ="" & vbCrLf & _
"select pred_ccod,                    " & vbCrLf & _
"       area_ccod,                    " & vbCrLf & _
"       eje_ccod,                     " & vbCrLf & _
"       foco_ccod,                    " & vbCrLf & _
"       prog_ccod,                    " & vbCrLf & _
"       proye_ccod,                   " & vbCrLf & _
"       obje_ccod,                    " & vbCrLf & _
"       tipo_gasto,                   " & vbCrLf & _
"       anio,                         " & vbCrLf & _
"       ene,                          " & vbCrLf & _
"       feb,                          " & vbCrLf & _
"       mar,                          " & vbCrLf & _
"       abr,                          " & vbCrLf & _
"       may,                          " & vbCrLf & _
"       jun,                          " & vbCrLf & _
"       jul,                          " & vbCrLf & _
"       ago,                          " & vbCrLf & _
"       sep,                          " & vbCrLf & _
"       octu,                         " & vbCrLf & _
"       nov,                          " & vbCrLf & _
"       dic,                          " & vbCrLf & _
"       total                         " & vbCrLf & _
"from   presupuesto_directo_area_desa " & vbCrLf & _
"where cod_pre 	= '"&cod_pre&"'       " & vbCrLf & _
"and area_ccod 	= '"&area_ccod&"'     " & vbCrLf & _
"and eje_ccod 	= '"&eje_ccod&"'      " & vbCrLf & _
"and prog_ccod 	= '"&prog_ccod&"'     " & vbCrLf & _
"and proye_ccod = '"&proye_ccod&"'	  " & vbCrLf & _
"and obje_ccod 	= '"&obje_ccod&"'     " & vbCrLf & _
"and cpre_ncorr = '"&cpre_ncorr&"'    " 
f_busqueda.consultar consulta
f_busqueda.siguiente
'--------------------------------------------------->>Debug
'response.write("<pre>"&consulta&"</pre>")
'response.end()
'--------------------------------------------------->>Debug
ene 	= f_busqueda.ObtenerValor("ene")
feb     = f_busqueda.ObtenerValor("feb")
mar     = f_busqueda.ObtenerValor("mar")
abr     = f_busqueda.ObtenerValor("abr")
may     = f_busqueda.ObtenerValor("may")
jun     = f_busqueda.ObtenerValor("jun")
jul     = f_busqueda.ObtenerValor("jul")
ago     = f_busqueda.ObtenerValor("ago")
sep     = f_busqueda.ObtenerValor("sep")
octu    = f_busqueda.ObtenerValor("octu")
nov     = f_busqueda.ObtenerValor("nov")
dic     = f_busqueda.ObtenerValor("dic")
total   = f_busqueda.ObtenerValor("total")

if ene   = "" then  ene   = 0 end if
if feb   = "" then  feb   = 0 end if
if mar   = "" then  mar   = 0 end if
if abr   = "" then  abr   = 0 end if
if may   = "" then  may   = 0 end if
if jun   = "" then  jun   = 0 end if
if jul   = "" then  jul   = 0 end if
if ago   = "" then  ago   = 0 end if
if sep   = "" then  sep   = 0 end if
if octu  = "" then  octu  = 0 end if
if nov   = "" then  nov   = 0 end if
if dic   = "" then  dic   = 0 end if
if total = "" then  total = 0 end if










set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
f_busqueda2.inicializar conexion2	
con_1 = "select concepto_pre from  presupuesto_upa.protic.codigos_presupuesto where cod_pre = '"&cod_pre&"'"
'response.write(con_1)
'response.end()
f_busqueda2.consultar con_1	
f_busqueda2.siguiente
nombre_1     = f_busqueda2.ObtenerValor("concepto_pre")














%>
<strong><%=nombre_1%></strong><hr/>
 <table width="95%" border="1" valign="top"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="33%">MES</th>
									  <th width="15%">2015</th>
									</tr>
									
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',1);" class="meses">ENERO      </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[0][solicitado]' value='$ <%=ene%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[0][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',2);" class="meses">FEBRERO    </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[1][solicitado]' value='$ <%=feb%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[1][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',3);" class="meses">MARZO      </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[2][solicitado]' value='$ <%=mar%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[2][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',4);" class="meses">ABRIL      </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[3][solicitado]' value='$ <%=abr%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[3][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',5);" class="meses">MAYO       </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[4][solicitado]' value='$ <%=may%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[4][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',6);" class="meses">JUNIO      </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[5][solicitado]' value='$ <%=jun%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[5][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',7);" class="meses">JULIO      </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[6][solicitado]' value='$ <%=jul%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[6][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',8);" class="meses">AGOSTO     </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[7][solicitado]' value='$ <%=ago%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[7][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',9);" class="meses">SEPTIEMBRE </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[8][solicitado]' value='$ <%=sep%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[8][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',10);" class="meses">OCTUBRE    </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[9][solicitado]' value='$ <%=octu%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[9][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',11);" class="meses">NOVIEMBRE  </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[10][solicitado]' value='$ <%=nov%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[10][solicitado]' value='0'>
</td>
									</tr>
									 
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(97,'',12);" class="meses">DICIEMBRE  </a></font></td>
									  <td> <input type='text' class="derecha" name='_test[11][solicitado]' value='$ <%=dic%>' onFocus='desenMascara(this)' onBlur='enMascara( this, "MONEDA",0);ValidaNumero(this);'  size='12'  maxlength=''  id='TO-N' >
 <input type='HIDDEN' name='test[11][solicitado]' value='0'>
</td>
									</tr>
									 
									 <tr bordercolor='#999999'>
										<td><a href="JAVASCRIPT:ver_detalle(97,'',0);"><b>TOTAL</b></a></td>
										<td align="left"><input type='text' size='12'  maxlength='' name='total_solicitud' value='$ <%=total%>' readonly style="background-color:#EDEDEF;border: 1px #EDEDEF solid;">
										<input type='HIDDEN' name='total_solicitud_' value='0'>
										</td>
									 </tr>
								  </table>
