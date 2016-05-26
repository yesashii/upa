<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("pers_nrut")


set pagina = new CPagina
pagina.Titulo = "Agregar persona pactación"


Function SqlPersona(p_tipo)
	Dim consulta, str_select
	
	select case p_tipo
		case "ALUMNO" :
			str_select = "select b.post_ncorr, " & vbCrLf &_
						   "       a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, a.pers_tfono, " & vbCrLf &_
						   "       e.dire_tcalle, e.dire_tnro, e.dire_tpoblacion, e.ciud_ccod "
						   
		case "CODEUDOR" :
			str_select = "select b.post_ncorr, " & vbCrLf &_
						   "       d.pers_nrut, d.pers_xdv, d.pers_tape_paterno, d.pers_tape_materno, d.pers_tnombre, d.pers_tfono, " & vbCrLf &_
						   "       f.dire_tcalle, f.dire_tnro, f.dire_tpoblacion, f.ciud_ccod "
						   
	end select
	
	'consulta = str_select & vbCrLf &_
	'           "from personas a, postulantes b, codeudor_postulacion c, personas d, " & vbCrLf &_
	'		   "     direcciones e, direcciones f " & vbCrLf &_
	'		   "where a.pers_ncorr = b.pers_ncorr (+) " & vbCrLf &_
	'		   "  and b.post_ncorr = c.post_ncorr (+) " & vbCrLf &_
	'		   "  and c.pers_ncorr = d.pers_ncorr (+) " & vbCrLf &_
	'		   "  and a.pers_ncorr = e.pers_ncorr (+) " & vbCrLf &_
	'		   "  and d.pers_ncorr = f.pers_ncorr (+) " & vbCrLf &_
	'		   "  and e.tdir_ccod (+) = 1 " & vbCrLf &_
	'		   "  and f.tdir_ccod (+) = 1 " & vbCrLf &_
	'		   "  and b.peri_ccod (+) = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "' " & vbCrLf &_
	'		   "  and a.pers_nrut = '" & q_pers_nrut & "'"
	
consulta = str_select & vbCrLf &_
			"    from personas a,postulantes b,codeudor_postulacion c,personas d," & vbCrLf &_
			"        direcciones e,direcciones f" & vbCrLf &_
			"    where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
			"        and b.post_ncorr = c.post_ncorr" & vbCrLf &_
			"        and c.pers_ncorr = d.pers_ncorr" & vbCrLf &_
			"        and a.pers_ncorr *= e.pers_ncorr" & vbCrLf &_
			"        and d.pers_ncorr *= f.pers_ncorr" & vbCrLf &_
			"        and e.tdir_ccod  = 1 " & vbCrLf &_
			"        and f.tdir_ccod  = 1" & vbCrLf &_
			"        and cast(b.peri_ccod as varchar) = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "' " & vbCrLf &_
			"        and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'" 
			
	'response.Write("<pre>"&consulta&"</pre>")		   
	SqlPersona = consulta
End Function
'response.End()

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agregar_persona_pactacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "agregar_persona_pactacion.xml", "persona"
f_alumno.Inicializar conexion
f_alumno.AgregaParam "variable", "alumno"

f_alumno.Consultar SqlPersona("ALUMNO")
f_alumno.SiguienteF

v_dv = conexion.ConsultaUno("select dbo.dv('" & q_pers_nrut & "')")
f_alumno.AgregaCampoCons "pers_nrut", q_pers_nrut
f_alumno.AgregaCampoCons "pers_xdv", v_dv
f_alumno.AgregaCampoCons "rut", q_pers_nrut & " - " & v_dv



'---------------------------------------------------------------------------------------------------
set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "agregar_persona_pactacion.xml", "persona"
f_codeudor.Inicializar conexion
f_codeudor.AgregaParam "variable", "codeudor"

'response.Write("<pre>" & SqlPersona("CODEUDOR") & "</pre>")

f_codeudor.Consultar SqlPersona("CODEUDOR")
f_codeudor.SiguienteF

f_codeudor.AgregaCampoCons "rut", ""
f_codeudor.AgregaCampoParam "rut", "permiso", "OCULTO"


'--------------------------------------------------------------------------------------------
set f_rut = new CFormulario
f_rut.Carga_Parametros "agregar_persona_pactacion.xml", "rut"
f_rut.Inicializar conexion
'f_rut.Consultar "select '' from dual"
f_rut.Consultar SqlPersona("CODEUDOR")
f_rut.SiguienteF
'f_codeudor.AgregaCampoParam "pers_nrut", "permiso", "LECTURA"


'f_alumno.AgregaCampoCons "pers_xdv", v_dv
'f_alumno.AgregaCampoCons "rut", q_pers_nrut & " - " & v_dv

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



function CopiarInformacion()
{
	t_rut_codeudor.AsignarValor(0, "pers_nrut", t_alumno.ObtenerValor(0, "pers_nrut"));
	t_rut_codeudor.AsignarValor(0, "pers_xdv", t_alumno.ObtenerValor(0, "pers_xdv"));
	t_codeudor.AsignarValor(0, "pers_tape_paterno", t_alumno.ObtenerValor(0, "pers_tape_paterno"));
	t_codeudor.AsignarValor(0, "pers_tape_materno", t_alumno.ObtenerValor(0, "pers_tape_materno"));
	t_codeudor.AsignarValor(0, "pers_tnombre", t_alumno.ObtenerValor(0, "pers_tnombre"));
	t_codeudor.AsignarValor(0, "pers_tnombre", t_alumno.ObtenerValor(0, "pers_tnombre"));
	t_codeudor.AsignarValor(0, "dire_tcalle", t_alumno.ObtenerValor(0, "dire_tcalle"));
	t_codeudor.AsignarValor(0, "dire_tnro", t_alumno.ObtenerValor(0, "dire_tnro"));
	t_codeudor.AsignarValor(0, "ciud_ccod", t_alumno.ObtenerValor(0, "ciud_ccod"));
	t_codeudor.AsignarValor(0, "pers_tfono", t_alumno.ObtenerValor(0, "pers_tfono"));	
}


var t_alumno;
var t_codeudor;
var t_rut_codeudor;

function InicioPagina()
{
	t_alumno = new CTabla("alumno");
	t_codeudor = new CTabla("codeudor");
	t_rut_codeudor = new CTabla("rut_codeudor");
}


</script>

<style type="text/css">
<!--
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%pagina.DibujarLenguetas Array("Ingresar codeudor", "Seleccionar curso", "Pactación"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<br>
              <form name="edicion">
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos persona"%>
                      <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td><%f_alumno.DibujaRegistro%></td>
                        </tr>
                      </table>
                      <br>
                      <%pagina.DibujarSubtitulo "Datos codeudor"%>
                      <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="10"><div align="center" class="Estilo1">(*)</div></td>
                              <td width="160"><strong>R.U.T.</strong></td>
                              <td width="10"><div align="center"><strong>:</strong></div></td>
                              <td><%f_rut.DibujaCampo("pers_nrut")%> 
                              - 
                                <%f_rut.DibujaCampo("pers_xdv")%></td>
                              <td><div align="right"><%f_botonera.DibujaBoton("copiar_info")%></div></td>
                            </tr>
                          </table></td>
                        </tr>
                        <tr>
                          <td><%f_codeudor.DibujaRegistro%></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
                  </div></td>
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
