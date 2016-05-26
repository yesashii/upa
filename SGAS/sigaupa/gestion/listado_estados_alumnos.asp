<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "filtros de busqueda por carrera"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


periodo= negocio.obtenerPeriodoAcademico("CLASES18")
sede= negocio.obtenerSede
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
anos_ccod=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listado_estados_alumnos.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'response.Write(carr_ccod)
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listado_estados_alumnos.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 consulta_carreras= "(select distinct ltrim(rtrim(cast(c.carr_ccod as varchar))) as carr_ccod, carr_tdesc " & vbCrLf &_
				    " from ofertas_Academicas a, especialidades b,carreras c, periodos_Academicos d " & vbCrLf &_
				    " where a.espe_ccod=b.espe_ccod " & vbCrLf &_
				    " and b.espe_ccod in ( " & vbCrLf &_
				    "                    Select espe_ccod " & vbCrLf &_
				    "                    from sis_especialidades_usuario " & vbCrLf &_
					"                    where pers_ncorr='"&pers_ncorr_encargado&"') " & vbCrLf &_
					" and b.carr_ccod=c.carr_ccod " & vbCrLf &_
					" and cast(d.anos_ccod as varchar) ='"&anos_ccod&"' " & vbCrLf &_
					" and a.peri_ccod = d.peri_ccod " & vbCrLf &_
				    " and cast(a.sede_ccod as varchar)='"&sede&"')d "					
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.AgregaCampoParam "carr_ccod", "destino",consulta_carreras 
 f_busqueda.AgregaCampoParam "peri_ccod", "destino","(select peri_ccod,peri_tdesc from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"') a" 
 f_busqueda.Siguiente
'---------------------------------------------------------------------------------------------------

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
            <td><%pagina.DibujarLenguetas Array("Filtrar listado por carrera"), 1 %></td>
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
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Periodo</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("peri_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Estado</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("emat_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                   <td width="14%"><div align="center"><%
					              botonera.agregabotonparam "excel", "url", "listado_matriculas_totales.asp"
								  botonera.dibujaboton "excel"
								  %>
					 </div>
                  </td>
				  <td width="19%"><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
    </td>
  </tr>  
</table>
</body>
</html>
