<%
q_origen = Request.QueryString("origen")
if(q_origen="1") then
	q_rut = Request.QueryString("rut")
	q_peri = Request.QueryString("peri")
	q_sede = Request.QueryString("sede")
	session("sede")=q_sede
	session("_periodo")=q_peri
	session("rut_usuario")=q_rut
'response.End()
end if
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_rutas.asp" -->


<% 
set pagina = new CPagina
pagina.Titulo = "Traspaso de Cajas"
'---------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores

v_sede_ccod = negocio.ObtenerSede


v_usuario=negocio.ObtenerUsuario()
'response.Write("Usuario"&v_usuario)

sql_rol_mini_tesorero="select count(*) from personas a,sis_roles_usuarios c, sis_roles b "& vbcrlf &_
						"where a.pers_ncorr=c.pers_ncorr"& vbcrlf &_
						"and c.srol_ncorr=b.srol_ncorr"& vbcrlf &_
						"and c.srol_ncorr=87"& vbcrlf &_
						"and a.pers_nrut='"&v_usuario&"' "

v_pers_ncorr=conexion.ConsultaUno("select top 1 pers_ncorr from personas where pers_nrut="&v_usuario)

Select Case v_pers_ncorr
	case "124445" 'BENAVIDES
		sql_sede="and a.sede_ccod = 4"
	case "12008" 'ichamblas
		sql_sede="and a.sede_ccod = 4"
	case "103170" 'gjara
		sql_sede="and a.sede_ccod in(1,8)"
	'case "101130" 
	'	sql_sede="and a.sede_ccod in (1,8) and a.audi_tusuario='"&v_usuario&"'"
End Select

'---------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "traspaso_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------
set f_cajas = new CFormulario
f_cajas.Carga_Parametros "traspaso_cajas.xml", "cajas"
f_cajas.Inicializar conexion


SQL = " select a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_ncorr, a.mcaj_finicio, protic.obtener_nombre_completo(b.pers_ncorr, 'PM,N') as cajero, c.ecua_tdesc, d.eren_tdesc ,a.sede_ccod "& vbCrLf &_
  " From movimientos_cajas a, cajeros b, estados_cuadre c, estados_rendicion d "& vbCrLf &_
  " Where a.caje_ccod = b.caje_ccod "& vbCrLf &_
  "   and a.sede_ccod = b.sede_ccod "& vbCrLf &_
  "   and a.ecua_ccod = c.ecua_ccod "& vbCrLf &_
  "   and a.eren_ccod = d.eren_ccod  "& vbCrLf &_
  "   and a.ecua_ccod in (1,2)"& vbCrLf &_
  "   and a.eren_ccod in (3,4) "&sql_sede&" " & vbCrLf &_
  "   and a.tcaj_ccod not in (1001,1002,1005) "& vbCrLf &_
  "   and isnull(a.mcaj_btraspasada_softland, 'N') = 'N' "& vbCrLf &_
  "   --and isnull(a.mcaj_btraspasada, 'S') = 'N' "& vbCrLf &_
  "   and convert(datetime,a.mcaj_finicio,103) >  convert(datetime,'01/01/2005',103)"& vbCrLf &_
  "   order by mcaj_finicio asc "

'SQL = SQL &  "   and a.sede_ccod = '" & v_sede_ccod & "'"

'response.Write("<pre>"&SQL&"</pre>")
f_cajas.Consultar SQL
%>




<html>
<head>
<title>Traspaso de Cajas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>
</head>

<!--body-->
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>

  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
       <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Traspaso
                          de Cajas</font></div></td>
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
                    </font> </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
                     <form name="edicion">
							<table width="98%"  border="0" align="center">
							  <tr>
								<td><div align="right">P&aacute;ginas : <%f_cajas.AccesoPagina%></div></td>
							  </tr>
							  <tr>
								<td><div align="center"><%f_cajas.DibujaTabla%></div></td>
							  </tr>
							  <tr>
								<td><div align="center"><%f_cajas.Pagina%></div></td>
							  </tr>
							</table>
							</form>
							<br>
							<table width="98%"  border="0" align="center">
							  <tr>
								<td><div align="right">
									<%
									
										f_botonera.DibujaBoton "traspasar_softland"
									
									%>
								</div></td>
							  </tr>
							</table>
                      </td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="103" bgcolor="#D8D8DE"><table width="91%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"><div align="center">
                        <%f_botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="259" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	

   </td>
  </tr>  
</table>
</body>
</html>



