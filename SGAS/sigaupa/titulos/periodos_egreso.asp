<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Mantenedor de periodos de egreso"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "periodos_egreso.xml", "botonera"

'-----------------------------------------------------------------------
peri_ccod = request.querystring("busqueda[0][peri_ccod]")

periodo = conexion.consultauno("SELECT peri_tdesc FROM periodos_academicos WHERE cast(peri_ccod as varchar) = '" & peri_ccod & "'")

'response.Write(espe_ccod & ":"& especialidad & "<BR><BR>")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "periodos_egreso.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.AgregaCampoCons "peri_ccod", peri_ccod 
  
 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
 set f_periodo_egreso = new CFormulario
 f_periodo_egreso.Carga_Parametros "periodos_egreso.xml", "f_periodo_egreso"
 f_periodo_egreso.Inicializar conexion
 consulta = " SELECT PEGR_NCORR,b.PERI_CCOD,PERI_TDESC,EPEG_TDESC,PROTIC.TRUNC(PEGR_FINICIO) AS PEGR_FINICIO,protic.trunc(PEGR_FTERMINO) AS PEGR_FTERMINO " & vbCrLf &_
            " FROM PRE_PERIODOS_EGRESO a, PERIODOS_ACADEMICOS b, PRE_ESTADOS_PERIODOS_EGRESO c" & vbCrLf &_
		    " WHERE a.peri_ccod = b.peri_ccod and a.EPEG_CCOD = c.EPEG_CCOD" & vbCrLf &_
			" AND a.peri_ccod = case '"&peri_ccod&"' when '' then a.peri_ccod else '"&peri_ccod&"' end " & vbCrLf &_
			" ORDER BY EPEG_TDESC, PEGR_FTERMINO"
 'response.Write("<pre>"&consulta&"</pre>")
 f_periodo_egreso.Consultar consulta
 'response.End()		 
'-------------------------------------------------------------

Subtitulo =      " <table width=""100%""  border=""0"" cellpadding=""0"" cellspacing=""0"">" & vbCrLf &_
		         "  <tr>" & vbCrLf &_
				 "     <td>" & vbCrLf &_ 	
		         "     <table width=""99%"" border=""0"" align=""left"" cellpadding=""0"" cellspacing=""0""> " & vbCrLf &_
		         "     <tr> " & vbCrLf &_
				 "        <td><font face=""Verdana, Arial, Helvetica, sans-serif"" size=""1""><b><font color=""#666677"" size=""2"">Período: " & periodo & "</font></b></font></td> " & vbCrLf &_
				 "     </tr> " & vbCrLf &_
				 "     <tr> " & vbCrLf &_
				 "        <td width=""0"" height=""0""><font color=""#666677""><img src=""../imagenes/linea.gif"" width=""100%"" height=""9""></font></td> " & vbCrLf &_
				 "     </tr> " & vbCrLf &_
				 "     </table>" & vbCrLf &_				 
		         "   </tr>" & vbCrLf &_
		         " </table>"



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
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}


function inicio()
{
  
}



</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="15%"><div align="left">Período Académico</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="81%"><% f_busqueda.dibujaCampo ("peri_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><div align="center">
                    <br> <%if periodo <> "" then%>
                    <table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Periodo</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=periodo%></font></b></font></td>
  </tr>
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table> <%end if%>
                    <br>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_periodo_egreso.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <% f_periodo_egreso.DibujaTabla()%>
                          </div></td>
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
                  <td><div align="center"> 
                            <% if peri_ccod <> "" and  peri_ccod <> "-1" then
							      botonera.AgregaBotonParam "nueva" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "nueva" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "nueva", "url", "periodos_egreso_agregar.asp?peri_ccod=" & peri_ccod
							   botonera.DibujaBoton "nueva"
							%>
                          </div></td>
                  <td><div align="center">
                            <% if peri_ccod <> "" and  peri_ccod <> "-1" then
							      botonera.AgregaBotonParam "eliminar" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar" , "deshabilitado", "TRUE"
							   end if
							   botonera.DibujaBoton "eliminar"%>				  
                          </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
