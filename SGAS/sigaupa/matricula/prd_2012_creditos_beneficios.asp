<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut = Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv = Request.QueryString("buscador[0][pers_xdv]")
q_leng = Request.QueryString("leng")

if EsVacio(q_leng) then
	q_leng = "1"
end if


set pagina = new CPagina
pagina.Titulo = "Revisión de Créditos y Beneficios"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cuenta_corriente.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cuenta_corriente.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)= '" & q_pers_nrut & "'")

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

'---------------------------------------------------------------------------------------------------
set cuenta_corriente = new CCuentaCorriente
cuenta_corriente.Inicializar conexion, q_pers_nrut, null

'---------------------------------------------------------------------------------------------------
url_leng_1 = "creditos_beneficios.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=1"
url_leng_2 = "creditos_beneficios.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=2"
url_leng_3 = "creditos_beneficios.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=3"


'---------------------------------------------------------------------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "cuenta_corriente.xml", "datos_alumno"
f_datos_alumno.Inicializar conexion

'consulta = "select obtener_nombre_completo(a.pers_ncorr) as nombre_completo, " & vbCrLf &_
'           "       obtener_rut(a.pers_ncorr) as rut_persona, " & vbCrLf &_
'		   "       obtener_nombre_carrera(b.ofer_ncorr) as nombre_carrera, " & vbCrLf &_
'		   "	   obtener_direccion(a.pers_ncorr, 1) as direccion, " & vbCrLf &_
'		   "	   d.cont_ncorr, e.ciud_ccod, a.pers_tfono " & vbCrLf &_
'		   "from personas a, alumnos b, ofertas_academicas c, contratos d, direcciones e " & vbCrLf &_
'		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
'		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
'		   "  and b.matr_ncorr = d.matr_ncorr " & vbCrLf &_
'		   "  and a.pers_ncorr = e.pers_ncorr (+) " & vbCrLf &_
'		   "  and e.tdir_ccod (+) = 1 " & vbCrLf &_
'		   "  and b.emat_ccod = 1 " & vbCrLf &_
'		   "  and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "  and a.pers_nrut = '" & q_pers_nrut & "'"
		   
consulta = "select protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo, " & vbCrLf &_
			"       protic.obtener_rut(a.pers_ncorr) as rut_persona, " & vbCrLf &_
			"       protic.obtener_nombre_carrera(b.ofer_ncorr,'CE') as nombre_carrera, " & vbCrLf &_
			"	   protic.obtener_direccion(a.pers_ncorr, 1,'CN-C') as direccion, " & vbCrLf &_
			"	   d.cont_ncorr, e.ciud_ccod, a.pers_tfono " & vbCrLf &_
			" from personas a,alumnos b,ofertas_academicas c,contratos d,direcciones e" & vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
			"    and b.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
			"    and b.matr_ncorr = d.matr_ncorr" & vbCrLf &_
			"    and a.pers_ncorr *= e.pers_ncorr" & vbCrLf &_
			"    and e.tdir_ccod = 1 " & vbCrLf &_
			"    and b.emat_ccod = 1 " & vbCrLf &_
			"    and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
			"    and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'		   "
'response.Write("<pre>"&consulta&"</pre>") 
'response.End() 
  
f_datos_alumno.Consultar consulta
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
var t_busqueda;

function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}


function InicioPagina()
{
	t_busqueda = new CTabla("buscador");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="32%"><div align="right">R.U.T.</div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
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
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%f_datos_alumno.DibujaRegistro%></td>
                </tr>
              </table>
</div>			
			<form name="edicion">
			  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                  <tr>
                    <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                    <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                    <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                  </tr>
                  <tr>
                    <td width="9" background="../imagenes/marco_claro/9.gif"></td>
                    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td><%pagina.DibujarLenguetasFClaro Array(Array("Créditos", url_leng_1), Array("Becas y descuentos", url_leng_2)), CInt(q_leng) %></td>
                        </tr>
                        <tr>
                          <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                        </tr>
                        <tr>
                          <td> 
                            <div align="left"><br>							
                              <br>
							<%
							select case q_leng
								case "1"
									pagina.DibujarSubtitulo("Créditos")
								case "2"
									pagina.DibujarSubtitulo("Becas y descuentos")								
							end select
							%>
                            </div>                            
                            <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td><div align="center">
                                        <%
										select case q_leng
											case "1"
												cuenta_corriente.DibujaCreditos
											case "2"
												cuenta_corriente.DibujaBecasDescuentos											
										end select
										%>
                                  </div></td>
                                </tr>
                                                        </table>                            <br>
                          </td>
                        </tr>
                    </table></td>
                    <td width="7" background="../imagenes/marco_claro/10.gif"></td>
                  </tr>
                  <tr>
                    <td width="9" height="13"><img src="../imagenes/marco_claro/base1.gif" width="9" height="13"></td>
                    <td height="13" background="../imagenes/marco_claro/15.gif"></td>
                    <td width="7" height="13"><img src="../imagenes/marco_claro/base3.gif" width="7" height="13"></td>
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
            <td width="18%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
