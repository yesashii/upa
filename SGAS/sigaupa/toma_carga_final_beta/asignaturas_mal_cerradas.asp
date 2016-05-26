<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_conexion_alumnos_02.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Asignaturas mal cerradas"

set errores = new CErrores

'conexion a servidor de alumnos consultas generales
'set conexion2 = new CConexion2
'conexion2.Inicializar "upacifico"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set conexion2 = new CConexion2
'conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asignaturas_mal_cerradas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "asignaturas_mal_cerradas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' as peri_ccod"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod


set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "asignaturas_mal_cerradas.xml", "asignaturas"
f_asignaturas.Inicializar conexion
c_asignaturas =      " select sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
					 " e.asig_ccod as cod_asignatura, asig_tdesc as asignatura, secc_tdesc as sección "& vbCrLf &_
					 " from secciones a, sedes b, carreras c, jornadas d, asignaturas e "& vbCrLf &_
					 " where a.sede_ccod=b.sede_ccod and a.carr_ccod=c.carr_ccod "& vbCrLf &_
					 " and a.jorn_ccod=d.jorn_ccod and a.asig_ccod=e.asig_ccod "& vbCrLf &_
					 " and cast(a.peri_ccod as varchar)='"&q_peri_ccod&"' and isnull(a.estado_cierre_ccod,1) = 2 "& vbCrLf &_
					 " and exists ( "& vbCrLf &_
					 "			 select 1  "& vbCrLf &_
					 "			 from cargas_academicas tt  "& vbCrLf &_
					 "			 where tt.secc_ccod=a.secc_ccod and len(ltrim(rtrim(isnull(replace(sitf_ccod,' ',''),'')))) = 0 "& vbCrLf &_
					 "			) "& vbCrLf &_
					 " order by sede,carrera,jornada,asignatura,sección"
f_asignaturas.Consultar c_asignaturas
'f_asignaturas.Siguiente

peri_tdesc =  conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&q_peri_ccod&"'")

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
            <td><%pagina.DibujarLenguetas Array("Toma de Asignaturas Escuela"), 1 %></td>
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
                        <td><div align="right"><strong>Periodo</strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.dibujaCampo("peri_ccod")%></td>
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
	<%IF q_peri_ccod <> "" then %>
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
            <td>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				 <tr valign="top">
				 	<td colspan="3">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="100%" align="left">
									<table width="100%" cellpadding="0" cellspacing="0">
									 <tr>
										<td colspan="3">
											<div align="center"><br>
											  <%pagina.Titulo = "Asignaturas mal cerradas <br>(" &peri_tdesc&")"
												pagina.DibujarTituloPagina%><br>
											</div>
										</td>
									  </tr>
									  <tr>
										<td colspan="3">&nbsp;</td>
									  </tr>
									 </table>
								</td>
							</tr>
						</table>
					</td>
				 </tr>
                 <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Asignaturas mal cerradas"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">Pagina <%f_asignaturas.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_asignaturas.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  <td><div align="center"><%if f_asignaturas.nroFilas > 0 then 
				                            	f_botonera.agregabotonparam "excel", "url", "asignaturas_mal_cerradas_excel.asp?peri_ccod="&q_peri_ccod
										   		f_botonera.dibujaboton "excel"
											end if%></div></td>
                  
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<%end if ' para ocultar el cuadro cuando no han ingresado el periodo%>
	</td>
  </tr>  
</table>
</body>
</html>
