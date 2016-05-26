<%
Response.Buffer = False
Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = 0
varia 	= request.QueryString("valor")

if varia = "a" then
%>
<td><strong>Agrega nuevo detalle</strong> </td>
<td>
<input type='text'  name='busqueda[0][nuevo_detalle]' value='' size='50'  maxlength='' >
</td>
<td>
<table id="bt_guardar5334" width="92" border="0" cellspacing="0" cellpadding="0" class="click" onMouseOver="_OverBoton(this);" onMouseOut="_OutBoton(this);" onClick="GuardarDetalle();">
  <tr> 
    <td width="7" height="16" rowspan="3"><img src="../imagenes/botones/boton1.gif" width="5" height="16" id="bt_guardar5334c11"></td> 
    <td width="88" height="2"><img src="../imagenes/botones/boton2.gif" width="88" height="2" id="bt_guardar5334c12"></td> 
    <td width="10" height="16" rowspan="3"><img src="../imagenes/botones/boton4.gif" width="5" height="16" id="bt_guardar5334c13"></td>
  </tr>
  <tr> 
    <td height="12" bgcolor="#EEEEF0" id="bt_guardar5334c21" nowrap> 
      <div align="center"><font id="bt_guardar5334f21" color="#333333" size="1" face="Verdana, Arial, Helvetica, sans-serif">Agregar</font></div></td>
  </tr>
  <tr> 
    <td width="88" height="2"><img src="../imagenes/botones/boton3.gif" width="88" height="2" id="bt_guardar5334c31"></td>
  </tr>
</table>
</td>
<%
else
end if
%>
