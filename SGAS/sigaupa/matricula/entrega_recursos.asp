<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: ADMISION Y MATRICULAS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:16/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *=
'LINEA			:117
'********************************************************************
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Entrega de recursos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "entrega_recursos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "entrega_recursos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'-------------------------------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")


'-------------------------------------------------------------------------------------------------------------------------
set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "entrega_recursos.xml", "datos_alumno"
f_datos_alumno.Inicializar conexion

'consulta = "select obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr) as nombre_completo, obtener_nombre_carrera(c.ofer_ncorr) as carrera " & vbCrLf &_
'           "from personas a, alumnos b, ofertas_academicas c " & vbCrLf &_
'		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
'		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
'		   "  and b.emat_ccod = 1 " & vbCrLf &_
'		   "  and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "  and a.pers_nrut = '" & q_pers_nrut & "'"
		   
consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
			"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    protic.obtener_nombre_carrera(c.ofer_ncorr,'CE') as carrera " & vbCrLf &_
			"from personas a, alumnos b, ofertas_academicas c " & vbCrLf &_
			"where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			"  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			"  and b.emat_ccod = 1 " & vbCrLf &_
			"  and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
			"  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
			
f_datos_alumno.Consultar consulta

'-------------------------------------------------------------------------------------------------------------------------
set f_recursos = new CFormulario
f_recursos.Carga_Parametros "entrega_recursos.xml", "recursos"
f_recursos.Inicializar conexion

'consulta = "select a.matr_ncorr, a.recu_ccod, a.recu_tdesc, decode(b.recu_ccod, null, 'N', 'S') as bentregado " & vbCrLf &_
'           "from (select b.matr_ncorr, d.recu_ccod, d.recu_tdesc  " & vbCrLf &_
'		   "      from personas a, alumnos b, ofertas_academicas c, recursos d " & vbCrLf &_
'		   "	  where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
'		   "	    and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
'		   "		and b.emat_ccod = 1 " & vbCrLf &_
'		   "		and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "		and a.pers_nrut = '" & q_pers_nrut & "') a, recursos_alumnos b " & vbCrLf &_
'		   "where a.matr_ncorr = b.matr_ncorr (+) " & vbCrLf &_
'		   "  and a.recu_ccod = b.recu_ccod (+)"
		   
'consulta = "select a.matr_ncorr, a.recu_ccod, a.recu_tdesc," & vbCrLf &_
'			"         case isnull(b.recu_ccod,0) when 0" & vbCrLf &_
'			"         then 'N' else 'S' end as bentregado" & vbCrLf &_
'			"from (select b.matr_ncorr, d.recu_ccod, d.recu_tdesc  " & vbCrLf &_
'			"      from personas a, alumnos b, ofertas_academicas c, recursos d " & vbCrLf &_
'			"	  where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
'			"	    and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
'			"		and b.emat_ccod = 1 " & vbCrLf &_
'			"		and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'			"		and d.erec_ccod = 1 " & vbCrLf &_
'			"      --and b.matr_ncorr=154646 " & vbCrLf &_
'			"		and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "') a, recursos_alumnos b " & vbCrLf &_
'			"where a.matr_ncorr *= b.matr_ncorr " & vbCrLf &_
'			"  and a.recu_ccod *= b.recu_ccod"

consulta = "select a.matr_ncorr, a.recu_ccod, a.recu_tdesc, " & vbCrLf &_
			"         case isnull(b.recu_ccod,0) when 0 " & vbCrLf &_
			"         then 'N' else 'S' end as bentregado " & vbCrLf &_
			" from (select b.matr_ncorr, d.recu_ccod, d.recu_tdesc " & vbCrLf &_
			"       from personas a INNER JOIN alumnos b " & vbCrLf &_
			"	    ON a.pers_ncorr = b.pers_ncorr and b.emat_ccod = 1 " & vbCrLf &_
			"       INNER JOIN ofertas_academicas c " & vbCrLf &_
			"	    ON b.ofer_ncorr = c.ofer_ncorr and c.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
			"       INNER JOIN recursos d " & vbCrLf &_
			"		ON d.erec_ccod = 1 WHERE cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "') a " & vbCrLf &_
			" LEFT OUTER JOIN recursos_alumnos b " & vbCrLf &_
			" ON a.matr_ncorr = b.matr_ncorr and a.recu_ccod = b.recu_ccod"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()		   
f_recursos.Consultar consulta


if f_recursos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
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
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;
	
}
function imprimir() {
  var rut;
  var direccion;
  rut=<%=q_pers_nrut%>
  direccion="impr_recursos.asp?pers_nrut="+rut;
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
  //alert("Enviando a imprimir");
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
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Recursos"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_recursos.DibujaTabla%></div></td>
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
            <td width="39%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("guardar")%></div></td>
				   <td><div align="center"><%f_botonera.DibujaBoton ("imprimir")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
