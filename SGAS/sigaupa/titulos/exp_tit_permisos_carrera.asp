<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Permisos carrera para expedientes de titulación"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "exp_tit_permisos_carrera.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "exp_tit_permisos_carrera.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.Siguiente
  
'---------------------------------------------------------------------------------------------------
set f_encargados = new CFormulario
f_encargados.Carga_Parametros "exp_tit_permisos_carrera.xml", "f_encargados"
f_encargados.Inicializar conexion

consulta =  " select b.sede_tdesc as sede, c.carr_tdesc as carrera, d.jorn_tdesc as jornada," & vbCrLf &_
			"	   e.pers_tnombre + ' ' + e.pers_tape_paterno + ' ' + e.pers_tape_materno as encargado," & vbCrLf &_
			"	  (select pers_temail from EMAIL_DIRECTORES_CARRERA EDC" & vbCrLf &_
			"	   where EDC.carr_ccod=a.carr_ccod and EDC.jorn_ccod=a.jorn_ccod and EDC.sede_ccod=a.sede_ccod" & vbCrLf &_
			"	   and EDC.pers_ncorr=e.pers_ncorr ) as email_encargado" & vbCrLf &_       
			"  from cargos_carrera a, sedes b, carreras c, jornadas d, personas e" & vbCrLf &_
			"  where a.sede_ccod=b.sede_ccod and a.carr_ccod=c.carr_ccod and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_
			"  and c.carr_ccod='"&carr_ccod&"' and a.pers_ncorr=e.pers_ncorr " 
			
f_encargados.Consultar consulta

set f_permisos = new CFormulario
f_permisos.Carga_Parametros "exp_tit_permisos_carrera.xml", "t_permisos"
f_permisos.Inicializar conexion

consulta =  " select a.carr_ccod," & vbCrLf &_ 
			"	   isnull(PECA_DAT_PERSONAL,'0') AS PECA_DAT_PERSONAL, " & vbCrLf &_ 
			"	   isnull(PECA_DOC_ENTREGADOS,'0') AS PECA_DOC_ENTREGADOS, " & vbCrLf &_ 
			"	   isnull(PECA_HIS_NOTAS,'0') AS PECA_HIS_NOTAS, " & vbCrLf &_ 
			"	   isnull(PECA_PRA_PROFESIONAL,'0') AS PECA_PRA_PROFESIONAL, " & vbCrLf &_ 
			"	   isnull(PECA_FEC_EGRESO,'0') AS PECA_FEC_EGRESO, " & vbCrLf &_ 
			"	   isnull(PECA_REG_SALIDA,'0') AS PECA_REG_SALIDA, " & vbCrLf &_ 
			"	   isnull(PECA_SEM_TESIS,'0') AS PECA_SEM_TESIS, " & vbCrLf &_ 
			"	   isnull(PECA_CON_NOTAS,'0') AS PECA_CON_NOTAS " & vbCrLf &_ 
			" from carreras a left outer join PERMISOS_EVT_CARRERA b " & vbCrLf &_ 
			"	 on a.carr_ccod=b.carr_ccod " & vbCrLf &_ 
			" where a.carr_ccod='"&carr_ccod&"' "
	   
f_permisos.Consultar consulta
f_permisos.Siguiente

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
  buscador.action="exp_tit_permisos_carrera.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
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
                  <td width="100%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
							  <tr>
								<td colspan="3" align="right"><%botonera.DibujaBoton "buscar"%></td>
							  </tr>
                            </table>
                          </div>
				  </td>
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
	<%IF carr_ccod <> "" then%>
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
                                    <%f_encargados.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%f_encargados.DibujaTabla()%>
                          </div></td>
                  </tr>
				  <tr>
				     <td>&nbsp;</td>
				  </tr>
				  <tr>
				     <td><%pagina.DibujarSubtitulo "Permisos de edición EVT" %></td>
				  </tr>
				  <tr>
				     <td align="Left">Marqué las casillas para todas aquellas funciones donde desee entregar permisos de edición del expediente virtual a las personas encargadas de la escuela</td>
				  </tr>
				  <tr>
				     <td>&nbsp;</td>
				  </tr>
				  <tr>
				     <td>
					    <table width="100%" border="1"><input type="hidden" name="carr_ccod" value="<%=carr_ccod%>">
						 <tr>
						     <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_DAT_PERSONAL")%></td>
							 <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_DOC_ENTREGADOS")%></td>
							 <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_HIS_NOTAS")%></td>
							 <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_PRA_PROFESIONAL")%></td>
						 </tr>
						 <tr>
						     <td width="25%" align="center"><strong>Actualizar datos de contacto, colegio y domicilio.</strong></td>
							 <td width="25%" align="center"><strong>Ingresar o editar documentos entregados por el alumno.</strong></td>
							 <td width="25%" align="center"><strong>Asociar histórico de notas a EVT.</strong></td>
							 <td width="25%" align="center"><strong>Ingresar o editar antecedentes de práctica profesional</strong></td>
						 </tr>
						 <tr>
							 <td colspan="4">&nbsp;</td>
						 </tr>
						 <tr>
						     <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_FEC_EGRESO")%></td>
							 <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_REG_SALIDA")%></td>
							 <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_SEM_TESIS")%></td>
							 <td width="25%" align="center"><%f_permisos.DibujaCampo("PECA_CON_NOTAS")%></td>
						 </tr>
						 <tr>
						     <td width="25%" align="center"><strong>Ingresar calificación de práctica profesional, fechas de egreso e información CAE.</strong></td>
							 <td width="25%" align="center"><strong>Asignación de folio de salida, licenciaturas y fechas de salida.</strong></td>
							 <td width="25%" align="center"><strong>Ingreso o edición de comisión de tesis, fecha de título, fecha de ceremonia.</strong></td>
							 <td width="25%" align="center"><strong>Ingreso o edición de calificaciones y porcentajes notas finales concentración de notas.</strong></td>
						 </tr>
						</table>
					 </td>
				  </tr>
				  <tr>
				     <td>&nbsp;</td>
				  </tr>
				  <tr>
				     <td>Las opciones que no se encuentren marcadas podrán ser consultadas por las escuelas pero sin poder realizar modificaciones.</td>
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
                            <% if carr_ccod <> "" then
							      botonera.AgregaBotonParam "guardar" , "deshabilitado", "FALSE"
							   else
							      botonera.AgregaBotonParam "guardar" , "deshabilitado", "TRUE"
							   end if
							   botonera.DibujaBoton "guardar"%>				  
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
	<%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
