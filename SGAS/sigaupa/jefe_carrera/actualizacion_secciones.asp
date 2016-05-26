<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
q_asig_ccod = Request.QueryString("b[0][asig_ccod]")
q_asig_tdesc = Request.QueryString("b[0][asig_tdesc]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Edición de secciones"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
v_usuario = negocio.ObtenerUsuario
'v_usuario = "22"

'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
'if ((actividad = "6") and (autorizada > "0")) then
'	v_peri_ccod = session("_periodo")
'else
v_peri_ccod =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
'end if
v_peri = negocio.ObtenerPeriodoAcademico("CLASES18")

peri_tdesc  = conexion.consultaUno("select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "actualizacion_secciones.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "actualizacion_secciones.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

sql_carreras = "select distinct d.carr_ccod, d.carr_tdesc " & vbCrLf &_
               "from personas a, sis_especialidades_usuario b, especialidades c, carreras d " & vbCrLf &_
			   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			   "  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
			   "  and c.carr_ccod = d.carr_ccod " & vbCrLf &_
			   "  and cast(a.pers_nrut as varchar)= '" & v_usuario & "'"
			   
f_busqueda.AgregaCampoParam "carr_ccod", "destino", "(" & sql_carreras & ")t"			   

f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
f_busqueda.AgregaCampoCons "asig_ccod", q_asig_ccod
f_busqueda.AgregaCampoCons "asig_tdesc", q_asig_tdesc


'----------------------------------------------------------------------------------------------------
set f_secciones = new CFormulario
f_secciones.Carga_Parametros "actualizacion_secciones.xml", "secciones"
f_secciones.Inicializar conexion

'consulta = "select a.secc_ccod, a.jorn_ccod, " & vbCrLf &_
'           "       trim(b.asig_ccod) || ' - ' || b.asig_tdesc as asignatura, a.secc_tdesc, " & vbCrLf &_
'		   "	   b.asig_ccod, b.asig_tdesc, " & vbCrLf &_
'		   "	   to_char(a.secc_nota_presentacion, '9.9') as secc_nota_presentacion, " & vbCrLf &_
'		   "	   a.secc_porcentaje_presentacion, " & vbCrLf &_
'		   "	   a.secc_eval_mini, " & vbCrLf &_
'		   "	   a.secc_porce_asiste, " & vbCrLf &_
'		   "	   to_char(a.secc_nota_ex, '9.9') as secc_nota_ex, " & vbCrLf &_
'		   "	   to_char(a.secc_min_examen, '9.9') as secc_min_examen, " & vbCrLf &_
'		   "	   a.secc_eximision " & vbCrLf &_
'		   "from secciones a, asignaturas b " & vbCrLf &_
'		   "where a.asig_ccod = b.asig_ccod " & vbCrLf &_
'		   "  and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "  and a.sede_ccod = '" & negocio.ObtenerSede & "' " & vbCrLf &_
'		   "  and a.carr_ccod = '" & q_carr_ccod & "' " & vbCrLf &_
'		   "  and trim(b.asig_ccod) = trim(nvl('" & q_asig_ccod & "', b.asig_ccod)) " & vbCrLf &_
'		   "  and upper(b.asig_tdesc) like upper(nvl('%" & q_asig_tdesc & "%', b.asig_tdesc)) " & vbCrLf &_
'		   "  and exists (select 1 " & vbCrLf &_
'		   "              from personas a2, sis_especialidades_usuario b2, especialidades c2 " & vbCrLf &_
'		   "			  where a2.pers_ncorr = b2.pers_ncorr " & vbCrLf &_
'		   "			    and b2.espe_ccod = c2.espe_ccod " & vbCrLf &_
'		   "				and b2.jorn_ccod = a.jorn_ccod " & vbCrLf &_
'		   "				and c2.carr_ccod = a.carr_ccod " & vbCrLf &_
'		   "				and a2.pers_nrut = '" & v_usuario & "') " & vbCrLf &_
'		   "order by b.asig_tdesc asc"

consulta = "select a.secc_ccod, a.jorn_ccod, " & vbCrLf &_
           "       rtrim(ltrim(cast(b.asig_ccod as varchar))) + ' - ' + b.asig_tdesc as asignatura, a.secc_tdesc, " & vbCrLf &_
		   "	   b.asig_ccod, b.asig_tdesc, " & vbCrLf &_
		   "	   replace(cast(a.secc_nota_presentacion as decimal(2,1)),',','.') as secc_nota_presentacion, " & vbCrLf &_
		   "	   a.secc_porcentaje_presentacion, " & vbCrLf &_
		   "	   a.secc_eval_mini, " & vbCrLf &_
		   "	   a.secc_porce_asiste, " & vbCrLf &_
		   "	   replace(cast(a.secc_nota_ex as decimal(2,1)),',','.') as secc_nota_ex, " & vbCrLf &_
		   "	   replace(cast(a.secc_min_examen as decimal(2,1)),',','.') as secc_min_examen, " & vbCrLf &_
		   "	   a.secc_eximision, " & vbCrLf &_
		   "	   case a.secc_con_examen when 'S' then 'Sí' when 'N' then 'No' else '' end as secc_con_examen " & vbCrLf &_
		   "from secciones a, asignaturas b " & vbCrLf &_
		   "where a.asig_ccod = b.asig_ccod " & vbCrLf &_
		   "  and cast(a.peri_ccod as varchar)= case duas_ccod when 3 then '"&v_peri&"' else '" & v_peri_ccod & "' end " & vbCrLf &_
		   "  and cast(a.sede_ccod as varchar)= '" & negocio.ObtenerSede & "' " & vbCrLf &_
		   "  and cast(a.carr_ccod as varchar)= '" & q_carr_ccod & "' " & vbCrLf &_
		   "  and cast(b.asig_ccod as varchar) = case '" & q_asig_ccod & "' when '' then cast(b.asig_ccod as varchar) else '" & q_asig_ccod & "' end " & vbCrLf &_
		   "  and upper(b.asig_tdesc) like upper(isnull('%" & q_asig_tdesc & "%', b.asig_tdesc)) " & vbCrLf &_
		   "  and exists (select 1 " & vbCrLf &_
		   "              from personas a2, sis_especialidades_usuario b2, especialidades c2 " & vbCrLf &_
		   "			  where a2.pers_ncorr = b2.pers_ncorr " & vbCrLf &_
		   "			    and b2.espe_ccod = c2.espe_ccod " & vbCrLf &_
		   "				and b2.jorn_ccod = a.jorn_ccod " & vbCrLf &_
		   "				and c2.carr_ccod = a.carr_ccod " & vbCrLf &_
		   "				and cast(a2.pers_nrut as varchar) = '" & v_usuario & "')" & vbCrLf &_
		   "order by b.asig_tdesc asc"

'response.Write("<pre>"&consulta&"</pre>")
f_secciones.Consultar consulta

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
function salir(){
location.href="../lanzadera/lanzadera.asp?resolucion=1152"
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                  <td width="81%"><div align="center"><%f_busqueda.DibujaRegistro%></div></td>
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
                    <td><%pagina.DibujarSubtitulo "Secciones existentes en "&peri_tdesc%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : 
                              <%f_secciones.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <th scope="col"><%f_secciones.DibujaTabla%></th>
                          </tr>
                        <tr>
                          <td scope="col"><div align="center">
                                <%f_secciones.Pagina%>
                          </div></td>
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
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir2")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
