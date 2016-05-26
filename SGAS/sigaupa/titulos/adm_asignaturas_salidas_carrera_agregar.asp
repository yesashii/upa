<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_saca_ncorr = Request.QueryString("saca_ncorr")
q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
q_espe_ccod = Request.QueryString("b[0][espe_ccod]")
q_plan_ccod = Request.QueryString("b[0][plan_ccod]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar asignaturas requisito"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "botonera"

tipo_salida = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&q_saca_ncorr&"'")
carr_ccod = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&q_saca_ncorr&"'")
'response.Write(tipo_Salida)
'---------------------------------------------------------------------------------------------------
if tipo_salida="1" or tipo_salida="2" then
	set f_encabezado = new CFormulario
	f_encabezado.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "encabezado"
	f_encabezado.Inicializar conexion
	
	SQL = " select a.plan_ccod, b.espe_ccod, c.carr_ccod, d.tsca_tdesc, a.saca_tdesc, e.carr_tdesc, c.espe_tdesc, b.plan_tdesc," & vbCrLf &_
		  " a.saca_npond_asignaturas,(select count(*) from asignaturas_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr) as total " & vbCrLf &_
		  " from salidas_carrera a, planes_estudio b, especialidades c, tipos_salidas_carrera d, carreras e" & vbCrLf &_
		  " where a.plan_ccod = b.plan_ccod" & vbCrLf &_
		  "   and b.espe_ccod = c.espe_ccod" & vbCrLf &_
		  "   and a.tsca_ccod = d.tsca_ccod" & vbCrLf &_
		  "   and c.carr_ccod = e.carr_ccod " & vbCrLf &_
		  "   and cast(a.saca_ncorr as varchar)= '" & q_saca_ncorr & "'"
else		  
	set f_encabezado = new CFormulario
	f_encabezado.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "encabezado_otros"
	f_encabezado.Inicializar conexion
	
	SQL = " select a.plan_ccod, a.carr_ccod, '<font size=2><strong>'+d.tsca_tdesc+'</strong></font>' as tsca_tdesc, a.saca_tdesc, e.carr_tdesc," & vbCrLf &_
		  " a.saca_npond_asignaturas,(select count(*) from asignaturas_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr) as total " & vbCrLf &_
		  " from salidas_carrera a, tipos_salidas_carrera d, carreras e" & vbCrLf &_
		  " where a.tsca_ccod = d.tsca_ccod" & vbCrLf &_
		  "   and a.carr_ccod = e.carr_ccod " & vbCrLf &_
		  "   and cast(a.saca_ncorr as varchar)= '" & q_saca_ncorr & "'"
  'response.Write("<pre>"&SQL&"</pre>")
end if

f_encabezado.Consultar SQL
f_encabezado.Siguiente

  '---------------------------------------------------------------------------------------------------
  if tipo_salida <> "6" then  	
	set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "busqueda"
	f_busqueda.Inicializar conexion
	
	f_busqueda.Consultar "select ''"
	f_busqueda.Siguiente
	f_busqueda.AgregaCampoCons "espe_ccod", q_espe_ccod
	f_busqueda.AgregaCampoCons "plan_ccod", q_plan_ccod
		
	SQL = " select distinct b.espe_ccod, b.espe_tdesc, d.plan_ccod, d.plan_tdesc "
	SQL = SQL &  " from ofertas_academicas a, especialidades b, planes_estudio d, periodos_academicos e"
	SQL = SQL &  " where a.espe_ccod = b.espe_ccod"
	SQL = SQL &  "   and b.espe_ccod = d.espe_ccod"
	SQL = SQL &  "   and a.peri_ccod = e.peri_ccod"
	SQL = SQL &  "   and cast(b.carr_ccod as varchar)='"&carr_ccod&"'"
	SQL = SQL &  "   and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1 ) "
	SQL = SQL &  " order by b.espe_tdesc asc, d.plan_tdesc desc"
  else
    set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "busqueda_minors"
	f_busqueda.Inicializar conexion
	
	f_busqueda.Consultar "select ''"
	f_busqueda.Siguiente
	f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
	f_busqueda.AgregaCampoCons "espe_ccod", q_espe_ccod
	f_busqueda.AgregaCampoCons "plan_ccod", q_plan_ccod
		
	SQL = " select distinct f.carr_ccod,f.carr_tdesc, b.espe_ccod, b.espe_tdesc, d.plan_ccod, d.plan_tdesc "
	SQL = SQL &  " from ofertas_academicas a, especialidades b, planes_estudio d, periodos_academicos e, carreras f "
	SQL = SQL &  " where a.espe_ccod = b.espe_ccod"
	SQL = SQL &  "   and b.espe_ccod = d.espe_ccod"
	SQL = SQL &  "   and a.peri_ccod = e.peri_ccod and b.carr_ccod=f.carr_ccod and f.tcar_ccod=1 "
	SQL = SQL &  "   and e.anos_ccod >=2005 "
	SQL = SQL &  "   and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1 ) "
	SQL = SQL &  " order by f.carr_tdesc, b.espe_tdesc asc, d.plan_tdesc desc"
  end if
 	
	f_busqueda.InicializaListaDependiente "busqueda", SQL
'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
set f_asignaturas_malla = new CFormulario
f_asignaturas_malla.Carga_Parametros "adm_asignaturas_salidas_carrera.xml", "asignaturas_malla"
f_asignaturas_malla.Inicializar conexion

if tipo_salida = "1" or tipo_salida="2" then 

SQL = " select a.saca_ncorr, b.mall_ccod, b.nive_ccod, c.asig_ccod, c.asig_tdesc" & vbCrLf &_
      " from salidas_carrera a, malla_curricular b, asignaturas c" & vbCrLf &_
      " where a.plan_ccod = b.plan_ccod" & vbCrLf &_
      "   and b.asig_ccod = c.asig_ccod" & vbCrLf &_
      "   and cast(a.saca_ncorr as varchar)= '" & q_saca_ncorr & "'" & vbCrLf &_
      "   and not exists (select 1" & vbCrLf &_
      "                   from asignaturas_salidas_carrera a2" & vbCrLf &_
      " 				  where a2.saca_ncorr = a.saca_ncorr" & vbCrLf &_
      " 				    and a2.mall_ccod = b.mall_ccod) " & vbCrLf &_
      " order by b.nive_ccod, c.asig_tdesc"
else
SQL = " select "&q_saca_ncorr&" as saca_ncorr, b.mall_ccod, b.nive_ccod, c.asig_ccod, c.asig_tdesc" & vbCrLf &_
      " from malla_curricular b, asignaturas c" & vbCrLf &_
      " where b.asig_ccod = c.asig_ccod" & vbCrLf &_
      "   and cast(plan_ccod as varchar)= '"&q_plan_ccod&"'" & vbCrLf &_
      "   and not exists (select 1" & vbCrLf &_
      "                   from asignaturas_salidas_carrera a2" & vbCrLf &_
      " 				  where cast(a2.saca_ncorr as varchar)='"&q_saca_ncorr&"'" & vbCrLf &_
      " 				  and a2.mall_ccod = b.mall_ccod) " & vbCrLf &_
      " order by b.nive_ccod, c.asig_tdesc"

end if	  

f_asignaturas_malla.Consultar SQL

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
<% f_busqueda.GeneraJS %>
<script language="JavaScript">
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Agregar"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <table width="98%"  border="0" align="center">
              <tr>
                <td><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
              </tr>
              <%if tipo_salida <> "1" and tipo_salida <> "2" then %>
              <form name="buscador" method="get">
              <tr>
                  <td width="100%">
                    <table width="98%"  border="0" bgcolor="#CCCCCC">
					  <tr>
                      	<td colspan="4" align="left"><font size="2" color="#990000">Seleccione el plan de estudio para extraer las asignaturas...</font></td>
                      </tr>
					  <%if tipo_salida = "6" then %>
					  <tr>
                        <td><strong>Carrera</strong></td>
                        <td><strong>:</strong></td>
                        <td colspan="2"><%f_busqueda.DibujaCampoLista "busqueda", "carr_ccod"%></td>
                      </tr>
					  <%end if%>
                      <tr>
                        <td><strong>Especialidad</strong></td>
                        <td><strong>:</strong></td>
                        <td colspan="2"><%f_busqueda.DibujaCampoLista "busqueda", "espe_ccod"%></td>
                      </tr>
                      <tr>
                        <td><strong>Plan</strong></td>
                        <td><strong>:</strong></td>
                        <td align="left"><%f_busqueda.DibujaCampoLista "busqueda", "plan_ccod"%></td>
                        <td width="30%" align="left"><%f_botonera.DibujaBoton "buscar"%></td>
                      </tr>
                      <input type="hidden" name="saca_ncorr" value="<%=q_saca_ncorr%>">
                     </table>
                  </td>
                </tr>
                </form>
                <%end if%> 
            </table>
                  <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Asignaturas del plan"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="right">P&aacute;ginas :<%f_asignaturas_malla.accesopagina%> </div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><%f_asignaturas_malla.DibujaTabla%></div></td>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
