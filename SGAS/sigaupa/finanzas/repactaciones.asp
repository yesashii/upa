<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv = Request.QueryString("buscador[0][pers_xdv]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Repactación de documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "repactaciones.xml", "botonera"

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
	conexion.MensajeError "No puede hacer repactaciones si no tiene una caja abierta."
	Response.Redirect("../lanzadera/lanzadera.asp")
end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "repactaciones.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------
set f_detalle_compromisos = new CFormulario
f_detalle_compromisos.Carga_Parametros "repactaciones.xml", "detalle_compromisos"
f_detalle_compromisos.Inicializar conexion

'consulta = "select b.comp_ndocto, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod, b.tcom_ccod as c_tcom_ccod, b.dcom_ncompromiso || '/' || a.comp_ncuotas as cuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
'           "       nvl(b.dcom_mcompromiso, 0) - total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_		   
'		   "	   total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as recepcionar, " & vbCrLf &_
'		   "	   b.ecom_ccod, e.edin_ccod, e.ting_ccod, e.ding_ndocto, e.ingr_ncorr, e.ting_ccod as c_ting_ccod, e.ding_ndocto as c_ding_ndocto " & vbCrLf &_
'		   "from compromisos a, detalle_compromisos b, abonos c, ingresos d, detalle_ingresos e, personas f " & vbCrLf &_
'		   "where a.tcom_ccod = b.tcom_ccod  " & vbCrLf &_
'		   "  and a.inst_ccod = b.inst_ccod  " & vbCrLf &_
'		   "  and a.comp_ndocto = b.comp_ndocto  " & vbCrLf &_
'		   "  and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
'		   "  and b.inst_ccod = c.inst_ccod " & vbCrLf &_
'		   "  and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
'		   "  and b.dcom_ncompromiso = c.dcom_ncompromiso " & vbCrLf &_
'		   "  and c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
'		   "  and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
'		   "  and a.pers_ncorr = f.pers_ncorr " & vbCrLf &_
'		   "  --and a.tcom_ccod in (1, 2, 3, 7) " & vbCrLf &_
'		   "  and d.eing_ccod <> 3 " & vbCrLf &_
'		   "  and e.edin_ccod not in (6, 11, 16, 17) " & vbCrLf &_
'		   "  and e.ding_bpacta_cuota = 'S' " & vbCrLf &_
'		   "  --and nvl(b.dcom_mcompromiso, 0) - total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
'		   "  and total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
'		   "  and a.ecom_ccod = '1' " & vbCrLf &_
'		   "  and b.ecom_ccod = '1' " & vbCrLf &_
'		   "  and f.pers_nrut = '" & q_pers_nrut & "'" & vbCrLf &_
'		   "order by a.comp_fdocto asc, b.tcom_ccod asc, b.dcom_ncompromiso asc"
		   
consulta = "select f.pers_nrut,b.comp_ndocto, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod, b.tcom_ccod as c_tcom_ccod," & vbCrLf &_
			"        cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar) as cuota," & vbCrLf &_
			"        a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
			"        isnull(b.dcom_mcompromiso, 0) - protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod,b.comp_ndocto, b.dcom_ncompromiso) as abonos," & vbCrLf &_
			"        protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as recepcionar," & vbCrLf &_
			"        b.ecom_ccod, e.edin_ccod, e.ting_ccod, e.ding_ndocto, e.ingr_ncorr," & vbCrLf &_
			"        e.ting_ccod as c_ting_ccod, e.ding_ndocto as c_ding_ndocto " & vbCrLf &_
			"    from compromisos a,detalle_compromisos b,abonos c,ingresos d,detalle_ingresos e,personas f" & vbCrLf &_
			"    where a.tcom_ccod = b.tcom_ccod  " & vbCrLf &_
			"        and a.inst_ccod = b.inst_ccod  " & vbCrLf &_
			"        and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
			"        and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
			"        and b.inst_ccod = c.inst_ccod " & vbCrLf &_
			"        and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
			"        and b.dcom_ncompromiso = c.dcom_ncompromiso" & vbCrLf &_
			"        and c.ingr_ncorr = d.ingr_ncorr" & vbCrLf &_
			"        and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
			"        and a.pers_ncorr = f.pers_ncorr" & vbCrLf &_
			"        and d.eing_ccod <> 3 " & vbCrLf &_
			"        and e.edin_ccod not in (4,6, 16, 17)" & vbCrLf &_
			"        and e.ding_bpacta_cuota = 'S'" & vbCrLf &_
			"        and protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0" & vbCrLf &_
			"        and a.ecom_ccod = '1'" & vbCrLf &_
			"        and b.ecom_ccod = '1'" & vbCrLf &_
			"        and cast(f.pers_nrut as varchar) = '" & q_pers_nrut & "'" & vbCrLf &_
			"order by a.comp_fdocto asc, b.tcom_ccod asc, b.dcom_ncompromiso asc"
			
		
's_response.Write("<pre>"&consulta&"</pre>") 
'response.End() 
f_detalle_compromisos.Consultar consulta


'--------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno
alumno.Inicializar conexion, persona.ObtenerMatrNcorr(negocio.ObtenerPeriodoAcademico("CLASES18"))

if EsVacio(persona.ObtenerMatrNCorr(negocio.ObtenerPeriodoAcademico("CLASES18"))) then
	set f_datos = persona
else
	set f_datos = alumno
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
var t_busqueda;
var t_detalle_compromisos;

function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv").toUpperCase();
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}


function ValidarFormRepactacion()
{
	if (t_detalle_compromisos.CuentaSeleccionados("ingr_ncorr") == 0) {
		alert('No ha seleccionado documentos para repactar.');
		return false;
	}
	
		
	/*
	var comp_ndocto_repactacion = '';
	var tcom_ccod_repactacion = '';
	b_compromisos_distintos = false;
	b_tipos_distintos = false;
	
	for (var i = 0; i < t_detalle_compromisos.filas.length; i++) {
		if (t_detalle_compromisos.filas[i].campos["ingr_ncorr"].objeto.checked) {
					
			if (comp_ndocto_repactacion != '') {
				if (comp_ndocto_repactacion != t_detalle_compromisos.ObtenerValor(i, "comp_ndocto")) {
					b_compromisos_distintos = true;
				}
				
				if (tcom_ccod_repactacion != t_detalle_compromisos.ObtenerValor(i, "tcom_ccod")) {
					b_tipos_distintos = true;
				}				
			}			
			
			comp_ndocto_repactacion = t_detalle_compromisos.ObtenerValor(i, "comp_ndocto");
			tcom_ccod_repactacion = t_detalle_compromisos.ObtenerValor(i, "tcom_ccod");
		}
	}		
	
	
	if ((b_compromisos_distintos) || (b_tipos_distintos)) {
		alert('Seleccione documentos de un mismo tipo y origen.');
		//return false;
		return true;
	}	*/

	return true;
}

function Repactar()
{
	var formulario = document.forms["edicion"];	
		
	if (ValidarFormRepactacion()) {		
		resultado = open("", "wrepactacion", " resizable, top=100, left=100, width=860, height=500, scrollbars=yes");	
		formulario.action = "agregar_repactacion.asp"
		formulario.target = "wrepactacion";
		formulario.method = "post";
		formulario.submit();
	}
}


function InicioPagina()
{
	t_busqueda = new CTabla("buscador");
	t_detalle_compromisos = new CTabla("detalle_compromisos");
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
                        <td width="32%"><div align="right"><strong>R.U.T.</strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
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
              <%pagina.DibujarTituloPagina%><br>
			  <br>
			  <%f_datos.DibujaDatos%>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Documentos para repactar"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_detalle_compromisos.DibujaTabla%></div></td>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("repactar")%>
                  </div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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
