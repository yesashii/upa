<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_bloq_ccod = Request.QueryString("bloq_ccod")
'carrera = request.QueryString("Carrera_ocul")
'response.write(carrera)
'response.end

'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Asignar profesor"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

seccion_temporal=conexion.consultaUno("Select secc_ccod from bloques_horarios where cast(bloq_ccod as varchar)='"&q_bloq_ccod&"'")
sede_temporal=conexion.consultaUno("Select sede_ccod from secciones where cast(secc_ccod as varchar)='"&seccion_temporal&"'")
jornada_temporal=conexion.consultaUno("Select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&seccion_temporal&"'")
'response.Write("sede "&sede_temporal&" jornada "&jornada_temporal)
'---------------------------------------------------------------------------------------------------
if EsVacio(q_bloq_ccod) then
	q_bloq_ccod = conexion.ConsultaUno("execute obtenersecuencia 'bloq_ccod_seq'")
end if
'response.write(session("c_carr_TMP"))


'---------------------------------------------------------------------------------------------------
set f_profesor = new CFormulario
f_profesor.Carga_Parametros "edicion_plan_acad.xml", "agregar_profesor"
f_profesor.Inicializar conexion

f_profesor.Consultar "select '' "
f_profesor.AgregaCampoCons "bloq_ccod", q_bloq_ccod
f_profesor.AgregaCampoCons "sede_ccod", negocio.ObtenerSede
'f_profesor.AgregaCampoCons "bpro_mvalor", "0"


consulta = "select a.pers_ncorr, protic.obtener_nombre_completo(a.pers_ncorr, 'PM,N') as nombre_profesor, a.sede_ccod " & vbCrLf &_
           "from profesores a, personas b,  CARRERAS_DOCENTE C" & vbCrLf &_		   
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and cast(a.sede_ccod as varchar) = '" & negocio.ObtenerSede & "' " & vbCrLf &_
		   "  and b.pers_ncorr = c.pers_ncorr " & vbCrLf &_		   
		   "  and C.CARR_CCOD =  " & session("c_carr_TMP") & vbCrLf &_
		   "  and cast(C.SEDE_CCOD as varchar)=  '" & sede_temporal &"'" & vbCrLf &_		   
		   "  and cast(C.JORN_CCOD as varchar)=  '" & jornada_temporal &"'" & vbCrLf &_		   
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from bloques_profesores a2 " & vbCrLf &_
		   "				  where a2.pers_ncorr = a.pers_ncorr " & vbCrLf &_
		   "				    and cast(a2.bloq_ccod as varchar)= '" & q_bloq_ccod & "')"

f_profesor.AgregaCampoParam "pers_ncorr", "destino", "(" & consulta & ")t"


consulta = "select * " & vbCrLf &_
           "from tipos_profesores a  " & vbCrLf &_
		   "where not exists (select 1 " & vbCrLf &_
		   "                  from bloques_profesores a2 " & vbCrLf &_
		   "				  where a2.tpro_ccod = 1 " & vbCrLf &_
		   "				    and a2.tpro_ccod = a.tpro_ccod " & vbCrLf &_
		   "					and cast(a2.bloq_ccod as varchar) = '" & q_bloq_ccod & "')"
		   
f_profesor.AgregaCampoParam "tpro_ccod", "destino", "(" & consulta & ")r"


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_plan_acad.xml", "botonera_agregar_profesor"
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Asignar profesor"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Profesor"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><%f_profesor.DibujaRegistro%></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
                  </div></td>
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
