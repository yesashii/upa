<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Generación de contratos - Información"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_contrato_1.xml", "botonera"




'---------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

'if not EsVacio(q_pers_nrut) then
'    conexion.EjecutaP "genera_bloqueos('" & q_pers_nrut & "', '" & v_peri_ccod & "')"
	
'	v_mensaje_bloqueo = conexion.ConsultaUno("select bloqueos_matricula('" & q_pers_nrut & "', '" & v_peri_ccod & "') from dual")
'	if not EsVacio(v_mensaje_bloqueo) then
'		Session("mensajeError") = v_mensaje_bloqueo
'		set errores = new CErrores	
'		f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
'	end if
'end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "genera_contrato_1.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'------------------------------------------------------------------------------------------------
consulta_datos = "select a.pers_ncorr, b.post_ncorr, a.pers_nrut || ' - ' || a.pers_xdv as rut, a.pers_tnombre || ' ' || a.pers_tape_paterno || ' ' || a.pers_tape_materno as nombre_completo, " & vbCrLf &_
                 "       e.carr_tdesc, d.espe_tdesc, to_char(sysdate, 'dd/mm/yyyy') as fecha_actual, g.sede_tdesc, " & vbCrLf &_
				 "	   f.aran_mmatricula, f.aran_mcolegiatura, nvl(f.aran_mmatricula, 0) + nvl(f.aran_mcolegiatura, 0) as total " & vbCrLf &_
				 "from personas_postulante a, postulantes b, ofertas_academicas c, especialidades d, carreras e, aranceles f, sedes g " & vbCrLf &_
				 "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
				 "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
				 "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
				 "  and d.carr_ccod = e.carr_ccod " & vbCrLf &_
				 "  and c.aran_ncorr = f.aran_ncorr " & vbCrLf &_
				 "  and c.sede_ccod = g.sede_ccod " & vbCrLf &_
				 "  and b.tpos_ccod = 1 " & vbCrLf &_
				 "  and b.epos_ccod = 2 " & vbCrLf &_
				 "  and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
				 "  and a.pers_nrut = '" & q_pers_nrut & "'"
	
set f_valores = new CFormulario
f_valores.Carga_Parametros "genera_contrato_1.xml", "tabla_valores"
f_valores.Inicializar conexion
f_valores.Consultar consulta_datos				 

if f_valores.NroFilas = 0 then
	f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
end if


set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion
fc_datos.Consultar consulta_datos
fc_datos.Siguiente

f_botonera.AgregaBotonParam "siguiente", "url", "genera_contrato_2.asp?post_ncorr=" & fc_datos.ObtenerValor("post_ncorr")


'-------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set postulante = new CPostulante
postulante.Inicializar conexion, persona.ObtenerPostNcorr(negocio.ObtenerPeriodoAcademico("POSTULACION"))
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
var t_busqueda;

function ValidaBusqueda()
{
	rut=document.buscador.elements['busqueda[0][pers_nrut]'].value+'-'+document.buscador.elements['busqueda[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['busqueda[0][pers_xdv]'].focus()
		document.buscador.elements['busqueda[0][pers_xdv]'].select()
		return false;
	}
	
	return true;	
}


function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Búsqueda de postulantes"), 1 %></td>
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
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="32%"><div align="right">R.U.T.</div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]" %></td>
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
                    <td>
                      <%pagina.DibujarSubtitulo "Datos del postulante"%>

                            <br>
							<%postulante.DibujaDatos%>
                            <br>
                            <%pagina.DibujarSubtitulo "Valores arancel"%>
                      <div align="center"><%f_valores.DibujaTabla%></div></td>
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
            <td width="27%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("siguiente")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="73%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
