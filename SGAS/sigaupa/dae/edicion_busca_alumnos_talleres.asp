<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

'---------------------------------------------------------------------------------------------------
q_peri_ccod =Request.QueryString("b[0][peri_ccod]")
q_tasi_ncorr= request.QueryString("b[0][tasi_ncorr]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")


set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "edicion_talleres.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_talleres.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "edicion_talleres.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_dictados = new CFormulario
f_dictados.Carga_Parametros "edicion_talleres.xml", "dictados_busqueda"
f_dictados.Inicializar conexion
f_busqueda.AgregaCampoCons "tasi_ncorr",q_tasi_ncorr
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod


if q_sede_ccod <>"" or q_tasi_ncorr <>"" or q_peri_ccod <>"" then

filtro1=filtro1&"where"
end if


if q_sede_ccod <>""  then

filtro2=filtro2&"sede_ccod="&q_sede_ccod&""
end if

if q_tasi_ncorr <>"" and  q_sede_ccod =""then

filtro3=filtro3&"tasi_ncorr="&q_tasi_ncorr&""
end if

if q_tasi_ncorr <>"" and q_sede_ccod <>"" then

filtro3=filtro3&"and tasi_ncorr="&q_tasi_ncorr&""
end if





if q_peri_ccod <>"" and  q_sede_ccod ="" and q_tasi_ncorr = "" then

filtro4=filtro4&"peri_ccod="&q_peri_ccod&""
end if

if q_peri_ccod <>"" and  q_sede_ccod <>""  then

filtro4=filtro4&"and peri_ccod="&q_peri_ccod&""
end if

if q_peri_ccod <>"" and  q_tasi_ccod <>""  then

filtro4=filtro4&"and peri_ccod="&q_peri_ccod&""
end if


if q_peri_ccod="" and  q_tasi_ncorr="" and q_sede_ccod="" then

sql_dictados="select ''"

else
sql_dictados= "select tdsi_ncorr,tasi_ncorr,sede_ccod,peri_ccod,fecha from  talleres_dictados_sicologia "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				" " &filtro4&" "			
end if


			






				
'response.Write("<pre>"&sql_dictados&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_acre_ncorr&"</pre>")
'response.End()
f_dictados.Consultar sql_dictados	


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
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
                    <br>
					<form name="buscador">
					  <table width="98%"  border="0" align="center">
					  
                            <tr>						
                                <td width="12%"><strong>Taller  :</strong></td>
                                <td width="53%" align="left">
					          <%f_busqueda.DibujaCampo("tasi_ncorr")%>  </td> 
							  
							  
						      <td width="35%"><div align="center">
                    
					<%f_botonera.DibujaBoton"buscar" %></div></td>
							   
                        </tr>
						
						<tr>
						<td width="12%"><strong>Sede  :</strong></td>
						<td  align="left"> <%f_busqueda.DibujaCampo("sede_ccod")%>  </td>
						</tr>
						<tr>
						<td width="12%"><strong>Periodo Academico  :</strong></td>
						<td  align="left"> <%f_busqueda.DibujaCampo("peri_ccod")%>  </td>
						</tr>
                      </table>
					 
                    <table width="100%" border="0">
              </table>			 
			     </form></tr>
			 
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Cursos Dictados"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_dictados.accesopagina%>                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_dictados.DibujaTabla()%>							   </td>
                        </tr>
                      </table>
					 
					    
					
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>                            </td>
                        </tr>
                      </table></td>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%'f_botonera.DibujaBoton"guardar" %></div></td>
			
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir2")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>	</td>
  </tr>  
</table>
</body>
</html>