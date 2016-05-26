<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_pers_tape_paterno = Request.QueryString("b[0][pers_tape_paterno]")
q_pers_tape_materno = Request.QueryString("b[0][pers_tape_materno]")
q_pers_tnombre = Request.QueryString("b[0][pers_tnombre]")



if EsVacio(Request.QueryString) then
	buscando = false
else
	buscando = true
end if


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Personas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_personas.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_personas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "pers_tape_paterno", q_pers_tape_paterno
f_busqueda.AgregaCampoCons "pers_tape_materno", q_pers_tape_materno
f_busqueda.AgregaCampoCons "pers_tnombre", q_pers_tnombre


'---------------------------------------------------------------------------------------------------
set f_personas = new CFormulario
f_personas.Carga_Parametros "adm_personas.xml", "personas"
f_personas.Inicializar conexion
'if (q_pers_nrut)="" then
'	q_pers_nrut="NULL"
'end if 
'if (q_pers_xdv)="" then
'	q_pers_xdv="NULL"
'end if 
'if (q_pers_tape_paterno)="" then
'	q_pers_tape_paterno=" = isnull(null, a.pers_tape_paterno)"
'else
'	q_pers_tape_paterno=" like upper('%" & q_pers_tape_paterno & "%')"
'end if 
'if (q_pers_tape_materno)="" then
'	q_pers_tape_materno=" = isnull(null, a.pers_tape_materno)"
'else
'	q_pers_tape_materno="like upper('%" & q_pers_tape_materno & "%')"	
'end if 
'if (q_pers_tnombre)="" then
'	q_pers_tnombre=" = isnull(null, a.pers_tnombre)"
'else
'	q_pers_tnombre="like upper('%" & q_pers_tnombre& "%')"	
'end if 

if buscando then
	consulta = "select a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, protic.obtener_rut(a.pers_ncorr) as rut " & vbCrLf &_
			   "from personas a " & vbCrLf &_
			   "where cast(a.pers_nrut as varchar)= case '" & q_pers_nrut & "' when '' then cast(a.pers_nrut as varchar) else '" & q_pers_nrut & "' end " & vbCrLf &_
			   "  and a.pers_xdv = case '" & q_pers_xdv & "' when '' then a.pers_xdv else '" & q_pers_xdv & "' end " & vbCrLf &_
			   "  and a.pers_tape_paterno = case '"&q_pers_tape_paterno&"' when '' then a.pers_tape_paterno else '"&q_pers_tape_paterno&"' end " & vbCrLf &_
			   "  and a.pers_tape_materno = case '" & q_pers_tape_materno & "' when '' then a.pers_tape_materno else '" & q_pers_tape_materno & "' end " & vbCrLf &_
			   "  and a.pers_tnombre = case '" & q_pers_tnombre & "' when '' then a.pers_tnombre else '" & q_pers_tnombre & "' end  " & vbCrLf &_
			  " Union "& vbCrLf &_
			  "select a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, protic.obtener_rut(a.pers_ncorr) as rut " & vbCrLf &_
			   "from personas_postulante a " & vbCrLf &_
			   "where cast(a.pers_nrut as varchar)= case '" & q_pers_nrut & "' when '' then cast(a.pers_nrut as varchar) else '" & q_pers_nrut & "' end " & vbCrLf &_
			   "  and a.pers_xdv = case '" & q_pers_xdv & "' when '' then a.pers_xdv else '" & q_pers_xdv & "' end " & vbCrLf &_
			   "  and a.pers_tape_paterno = case '"&q_pers_tape_paterno&"' when '' then a.pers_tape_paterno else '"&q_pers_tape_paterno&"' end " & vbCrLf &_
			   "  and a.pers_tape_materno = case '" & q_pers_tape_materno & "' when '' then a.pers_tape_materno else '" & q_pers_tape_materno & "' end " & vbCrLf &_
			   "  and a.pers_tnombre = case '" & q_pers_tnombre & "' when '' then a.pers_tnombre else '" & q_pers_tnombre & "' end  " & vbCrLf &_
			   "order by a.pers_tape_paterno asc, a.pers_tape_materno asc, a.pers_tnombre asc"

			  
			  'response.Write("<pre>"&consulta&"<pre>")
else
	consulta = "select ''as valor from personas where 1=2 "
end if
'response.Write("<pre>"&consulta&"</pre>")
f_personas.Consultar consulta
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<link href="../estilos/estilos.css" rel=stylesheet type="text/css">
<link href="../estilos/tabla.css" rel=stylesheet type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
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
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="center">                            
                          <p>
                              <%f_busqueda.DibujaCampo("pers_nrut")%> 
                            - 
                                <%f_busqueda.DibujaCampo("pers_xdv")%>
                                <br>
                                <strong>R.U.T.</strong> </p>
                          </div></td>
                        <td><div align="center">
                          <%f_busqueda.DibujaCampo("pers_tape_paterno")%>
                          <br>
                          <strong>AP. PATERNO</strong></div></td>
                        <td><div align="center">
                          <%f_busqueda.DibujaCampo("pers_tape_materno")%>
                          <br>
                          <strong>AP. MATERNO</strong></div></td>
                        <td><div align="center">
                          <%f_busqueda.DibujaCampo("pers_tnombre")%>
                          <br>
                          <strong>NOMBRES</strong></div></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Personas"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">P&aacute;ginas : 
                              <%f_personas.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><%f_personas.DibujaTabla%></div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><%f_personas.Pagina%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("agregar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
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
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
