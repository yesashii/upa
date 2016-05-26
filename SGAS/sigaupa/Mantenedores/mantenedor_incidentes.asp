<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

folio_buscar = request.querystring("folio_buscar")
servidor_buscar  = request.QueryString("servidor_buscar")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Incidentes"

set botonera =  new CFormulario
botonera.carga_parametros "mantenedor_incidentes.xml", "btn_busca_incidentes"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
servidor = ""
if servidor_buscar="SBD01" or servidor_buscar="172.16.11.132" or servidor_buscar="216.72.170.73" then
	servidor = "1"
elseif servidor_buscar="SBD010" or servidor_buscar="Softland" or servidor_buscar="172.16.11.180" then
	servidor = "2"
elseif servidor_buscar="sbd02" or servidor_buscar="172.16.11.11" then
	servidor = "3"
elseif servidor_buscar="sbd03" or servidor_buscar="Mirror" or servidor_buscar="172.16.11.111" or servidor_buscar="216.72.170.68" then
	servidor = "4"
elseif servidor_buscar="fangorn" or servidor_buscar="172.16.11.194" or servidor_buscar="216.72.170.82" then
	servidor = "5"
elseif servidor_buscar="Santiago" or servidor_buscar="172.16.11.25" then
	servidor = "6"
elseif servidor_buscar="Moodle" or servidor_buscar="172.16.12.38" or servidor_buscar="216.72.170.72" then
	servidor = "7"
elseif servidor_buscar="Moodle_BD" or servidor_buscar="172.16.12.39" then
	servidor = "8"
elseif servidor_buscar="upacifico" or servidor_buscar="Sitio Web" or servidor_buscar="10.10.10.6" then
	servidor = "9"
elseif servidor_buscar="admision" or servidor_buscar="caja" or servidor_buscar="PSU" or servidor_buscar="PENTAHO" or servidor_buscar="172.16.11.204" or servidor_buscar="216.72.170.71" then
	servidor = "10"
elseif servidor_buscar="Retrospect" or servidor_buscar="Respaldos" or servidor_buscar="172.16.11.35" then
	servidor = "11"
elseif servidor_buscar="HIP" or servidor_buscar="Biblioteca" or servidor_buscar="172.16.11.59" or servidor_buscar="216.72.170.83" then
	servidor = "12"
elseif servidor_buscar="BD Biblioteca" or servidor_buscar="172.16.11.224" then
	servidor = "13"	
end if
set formulario = new cformulario
formulario.carga_parametros "mantenedor_incidentes.xml", "form_busca_incidentes"
formulario.inicializar conexion

consulta =" select inci_ccod,protic.trunc(fecha_incidente) + ' ' + hora_incidente as fecha_incidente, lower(incidente) as incidente, "& vbCrLf &_
		  " status_solucion as status, "& vbCrLf &_
		  " protic.trunc(fecha_solucion)+' '+hora_solucion as fecha_solucion, "& vbCrLf &_
		  " protic.initCap(case when personal_tecnico='' then 'Sin asignar' when personal_tecnico is null then 'Sin asignar' else personal_tecnico end ) as personal_tecnico, fecha_incidente as ff "& vbCrLf &_
		  " from INCIDENTES  where 1=1 "
'response.write("<pre>"&consulta&"</pre>")		  
if folio_buscar <> "" then
	consulta = consulta & " and inci_ccod like '%"&folio_buscar&"%'"
end if
if servidor <> "" then
	consulta = consulta & " and serv_ccod = '"&servidor&"'"
end if
'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta & " order by ff desc"
'response.Write("<pre>"&consulta&" order by asig_tdesc</pre>")

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function enviar(formulario){
	formulario.action = 'mantenedor_incidentes.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "mantenedor_incidentes_editar.asp?codigo=<%=asig_ccod%>";
	resultado=window.open(direccion, "ventana1","width=560,height=550,scrollbars=yes");
	
 // window.close();
}
function salir(){
window.close()
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
					<td width="27%" align="left"><strong>FOLIO Incidente</strong></td>
					<td width="3%" align="left"><strong>:</strong></td>
					<td width="70%" align="left"><input type="text" name="folio_buscar" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" value="<%=folio_buscar%>"></td>
				</tr>
				<tr>
					<td width="27%" align="left"><strong>o por SERVIDOR</strong></td>
					<td width="3%" align="left"><strong>:</strong></td>
					<td width="70%" align="left"><input type="text" name="servidor_buscar" size="40" maxlength="40" ID="TO-S" value="<%=servidor_buscar%>" onKeyUp="this.value=this.value.toUpperCase()"></td>
				</tr>
				<tr>
                  <td colspan="3" align="right"><%botonera.dibujaboton "buscar"%></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td colspan="3"><div align="center"><br><%pagina.DibujarTituloPagina%></div></td>
                  </tr>
				  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="3"><div align="left"><%pagina.DibujarSubtitulo "Lista de incidentes registrados"%></div></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="20%" align="left"><strong>Folio</strong></td>
					<td width="80%" align="left"><strong>: </strong><%=folio_buscar%></td>
                  </tr>
				  <tr>
                    <td width="20%" align="left"><strong>Servidor</strong></td>
					<td width="80%" align="left"><strong>: </strong><%=servidor_buscar%></td>
                  </tr>
				  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="3"><div align="right"><strong>P&aacute;ginas :</strong><%formulario.accesopagina%></div></td>
                  </tr>
                  <tr>
                    <td colspan="3">&nbsp;</td>
                  </tr>
                  <tr>
                    <td colspan="3"><div align="center"><%formulario.dibujatabla()%></div></td>
                  </tr>
                </table>
             <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "agregar"%></div></td>
                  <td><div align="center"><%'botonera.dibujaboton "eliminar"%></div></td>
				  <td> <div align="center">  <%
				                           botonera.agregabotonparam "excel", "url", "mantenedor_incidentes_excel.asp?folio_buscar="&folio_buscar&"&servidor="&servidor
										   botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
