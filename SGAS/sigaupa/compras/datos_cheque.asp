<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Datos Cheque"

set botonera = new CFormulario
botonera.carga_parametros "entrega_cheques.xml", "botonera"


v_num_ndocto	= request.querystring("num_ndocto")
v_cpbnum		= request.querystring("cpbnum")
v_cod_aux		= request.querystring("cod_aux")


set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "entrega_cheques.xml", "buscador"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

 set f_cheques = new CFormulario
 f_cheques.Carga_Parametros "entrega_cheques.xml", "cheques"
 f_cheques.Inicializar conexion

if v_cod_aux <> "" then
	sql_cheques	=	"select paguesea,movtipdocref as solicitud,'XX' as num_solicitud, movnumdocref, "&_
					"	movtipdocref as tipo, movdebe as monto, movglosa as glosa,year(getdate()) as anos_ccod "&_
					"	from softland.cwmovim a "&_
					"	join softland.cwtauxi b "&_   
					"		on  a.codaux=b.codaux "&_
					"	where a.codaux='"&v_cod_aux&"' "&_
					"	and a.cpbnum='"&v_cpbnum&"' "
else
	sql_cheques	=	"select '' where 1=2"												
end if

'response.Write("<pre>"&sql_cheques&"</pre>")
'response.End()

f_cheques.Consultar sql_cheques
 
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

function Enviar(){
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Cheques en Cartera</font>  </div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
						<td>
						<br/>
						<strong><font color="000000" size="1"> </font></strong>
							<form name="datos" method="post">
							  <table width="98%"  border="0" align="center">
                                <tr bgcolor='#C4D7FF'>
                                  <th width="15%">Nombre </th>
                                  <th width="9%">Tipo Solicitud </th>
                                  <th width="8%">N&deg; Solictud </th>
                                  <th width="8%">A&ntilde;o Solicitud </th>
                                  <th width="10%">Tipo Doc</th>
                                  <th width="6%">N° Doc</th>
                                  <th width="12%">Monto</th>
                                  <th width="32%">Glosa</th>
                                </tr>
                                <%
								  ind=0
								  v_total=0
								  while f_cheques.Siguiente 
								  %>
                                <tr bgcolor='#FFFFFF'>
                                  <td><div align="right"><%=f_cheques.obtenerValor("paguesea")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("solicitud")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("num_solicitud")%></div></td>
                                  <td><div align="right"><%=f_cheques.obtenerValor("anos_ccod")%></div></td>
                                  <td><div align="center"><%=f_cheques.obtenerValor("tipo")%></div></td>
                                  <td><div align="center"><%=f_cheques.obtenerValor("movnumdocref")%></div></td>
                                  <td><div align="center"><%=f_cheques.obtenerValor("monto")%></div></td>
                                  <td><div align="center"><%=f_cheques.obtenerValor("glosa")%></div></td>
                                </tr>
                                <%
								  v_total=v_total+Clng(f_cheques.obtenerValor("monto"))
								  ind=ind+1
								  wend%>
                                <tr bgcolor='#FFFFFF'>
                                  <td bgcolor="#D8D8DE" colspan="6"><div align="right"><strong>Total Monto</strong></div></td>
                                  <td><div align="center"><%=formatcurrency(v_total,0)%></div></td>
								  <td bgcolor="#D8D8DE"></td>
                                </tr>
                              </table>
							</form>
							<br>						</td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="108" bgcolor="#D8D8DE">
				  <table width="23%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td><%botonera.dibujaboton "cerrar"%></td>
                    </tr>
                  </table>                </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
