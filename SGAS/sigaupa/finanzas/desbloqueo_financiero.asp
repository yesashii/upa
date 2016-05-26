<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************'
'DESCRIPCION		    :
'FECHA CREACIÓN		    :
'CREADO POR 		    :
'ENTRADA		        :NA.
'SALIDA			        :NA.
'MODULO QUE ES UTILIZADO:FINANZAS.
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:04/02/2013.
'ACTUALIZADO POR	    :Luis Herrera G.
'MOTIVO			        :Corregir código, eliminar sentencia *=
'LINEA			        :83
'********************************************************************'
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Desbloqueos financieros"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "desbloqueo_financiero.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "desbloqueo_financiero.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv




'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "desbloqueo_financiero.xml", "encabezado"
f_encabezado.Inicializar conexion
f_encabezado.Consultar "select ''"
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "peri_ccod", v_peri_ccod

'---------------------------------------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "desbloqueo_financiero.xml", "alumno"
f_alumno.Inicializar conexion

'consulta = "select a.pers_nrut, obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr) as nombre, " & vbCrLf &_
'           "       es_moroso(a.pers_ncorr) as moroso, decode(b.dees_ncorr, null, 'N', 'S') as desbloqueado, b.dees_ncorr " & vbCrLf &_
'		   "from personas a, desbloqueos_especiales b " & vbCrLf &_
'		   "where a.pers_ncorr = b.pers_ncorr (+) " & vbCrLf &_
'		   "  and b.tdes_ccod (+) = 1 " & vbCrLf &_
'		   "  and b.dees_bvigente (+) = 'S' " & vbCrLf &_
'		   "  and b.peri_ccod (+) = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "  and a.pers_nrut = '" & q_pers_nrut & "'"

'consulta = "select a.pers_nrut, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre," & vbCrLf &_
'			"        protic.es_moroso(a.pers_ncorr,getdate()) as moroso," & vbCrLf &_
'			"        case isnull(b.dees_ncorr,0) when 0 then 'N' else 'S' end as desbloqueado, b.dees_ncorr" & vbCrLf &_
'			"    from personas a,desbloqueos_especiales b" & vbCrLf &_
'			"        where a.pers_ncorr *= b.pers_ncorr" & vbCrLf &_
'			"        and b.tdes_ccod = 1" & vbCrLf &_
'			"        and b.dees_bvigente = 'S'" & vbCrLf &_
'			"        and b.peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
'			"        and cast(a.pers_nrut  as varchar) = '" & q_pers_nrut & "'"

consulta = "select a.pers_nrut, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre," & vbCrLf &_
			"        protic.es_moroso(a.pers_ncorr,getdate()) as moroso," & vbCrLf &_
			"        case isnull(b.dees_ncorr,0) when 0 then 'N' else 'S' end as desbloqueado, b.dees_ncorr" & vbCrLf &_
			"    from personas a" & vbCrLf &_
			"    LEFT OUTER JOIN desbloqueos_especiales b" & vbCrLf &_
			"        on a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
			"        and b.tdes_ccod = 1" & vbCrLf &_
			"        and b.dees_bvigente = 'S'" & vbCrLf &_
			"        and b.peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
			"        where cast(a.pers_nrut  as varchar) = '" & q_pers_nrut & "'"	
			
'response.Write("<pre>" & consulta & "</pre>")  
'response.End()
f_alumno.Consultar consulta

if f_alumno.NroFilas > 0 then
	f_alumno.AgregaCampoCons "peri_ccod", v_peri_ccod
	f_alumno.AgregaCampoCons "tdes_ccod", "1"  
end if
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
				  <td width="35%"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                    Alumno </font></div></td>
                                <td width="3%">:</td>
                                <td width="20%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                  - 
                                  <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font></td>
                                <td width="20%">&nbsp;</td>
                  <td width="22%"><div align="center"><%f_botonera_g.DibujaBoton "buscar"%></div></td>
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
              <br>
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Alumno"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="center"><%f_alumno.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "desbloquear"%></div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "salir"%></div></td>
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
