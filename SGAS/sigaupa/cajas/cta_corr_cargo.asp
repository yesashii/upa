<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
rut = Request.QueryString("rut")
dv = Request.QueryString("dv")


set pagina = new CPagina
pagina.Titulo = "Cargos en cuenta corriente"

set conectar = new cconexion
set negocio = new CNegocio

set formulario = new cformulario
set ftotal = new cFormulario

conectar.inicializar "desauas"
negocio.Inicializa conectar

formulario.carga_parametros "cta_corr_cargo.xml", "cargos_cta_corr"
formulario.inicializar conectar

'ftotal.carga_parametros "cta_corr_cargo.xml", "ftotales"
'ftotal.inicializar conectar


'************************************************
cod_periodo = negocio.obtenerPeriodoAcademico("CLASES18")
'************************************************

personas = "SELECT pers_nrut || '-' || pers_xdv AS rut, " &_
           "       pers_tape_paterno || ' ' || pers_tape_materno || ' ' || pers_tnombre AS nombre_completo " &_
           "FROM personas a, alumnos b " &_
           "WHERE a.pers_ncorr = b.pers_ncorr AND " &_
		   "      pers_nrut = '" & rut & "' AND " &_
           "      pers_xdv = '" & dv & "' AND " &_
		   "      rownum = 1"

personas = "SELECT a.pers_nrut || '-' || a.pers_xdv AS rut, " &_
           "       a.pers_tape_paterno || ' ' || a.pers_tape_materno || ' ' || a.pers_tnombre AS nombre_completo " &_
		   "FROM personas a, postulantes b " &_
		   "WHERE a.pers_ncorr = b.pers_ncorr AND " &_
		   "      a.pers_nrut = " & rut & " AND " &_
		   "	  a.pers_xdv = '" & dv & "' AND " &_
		   "	  rownum = 1"

personas = "SELECT a.pers_nrut || '-' || a.pers_xdv AS rut, " &_
           "       a.pers_tape_paterno || ' ' || a.pers_tape_materno || ' ' || a.pers_tnombre AS nombre_completo " &_
		   "FROM personas a " &_
		   "WHERE a.pers_nrut = '" & rut & "' AND " &_
		   "	  a.pers_xdv = '" & dv & "'"


persona_existe = false
buscando_personas = false
if rut <> 0 and dv <> "" then
	buscando_personas = true
	
	conectar.ejecuta(personas)
	set rec_personas = conectar.obtenerRS
	
	if rec_personas.RecordCount > 0 then
		persona_existe = True
		
		rec_personas.MoveFirst
		rut_persona = rec_personas("rut")
		nombre_completo = rec_personas("nombre_completo")
	end if
	rec_personas.Close
	set rec_personas = Nothing
end if



ecom_ccod_nulo = 3

tabla = "SELECT f.comp_ndocto, g.inst_trazon_social, h.tcom_tdesc, f.comp_fdocto AS comp_fdocto, f.comp_mdocumento, " &_
        "       f.tcom_ccod, f.inst_ccod, f.ecom_ccod " &_
        "FROM personas a, compromisos f, instituciones g, tipos_compromisos h " &_
		"WHERE a.pers_ncorr = f.pers_ncorr AND " &_
		"      f.inst_ccod = g.inst_ccod AND " &_
		"      f.tcom_ccod = h.tcom_ccod AND " &_
		"      f.ecom_ccod <> " & ecom_ccod_nulo & " AND " &_
		"      (f.tcom_ccod BETWEEN 8 AND 13) AND " &_
		"      a.pers_nrut = " & rut & " AND " &_
		"      a.pers_xdv = '" & dv & "' " &_
		"ORDER BY f.comp_fdocto ASC, f.comp_ndocto ASC"

tabla = "SELECT f.comp_ndocto, g.inst_trazon_social, h.tcom_tdesc, f.comp_fdocto AS comp_fdocto, f.comp_mdocumento, " &_
        "       f.tcom_ccod, f.inst_ccod, f.ecom_ccod " &_
        "FROM personas a, compromisos f, instituciones g, tipos_compromisos h " &_
		"WHERE a.pers_ncorr = f.pers_ncorr AND " &_
		"      f.inst_ccod = g.inst_ccod AND " &_
		"      f.tcom_ccod = h.tcom_ccod AND " &_
		"      f.ecom_ccod <> " & ecom_ccod_nulo & " AND " &_
		"      h.tcom_bcargo = 'S' AND " &_
		"      a.pers_nrut = '" & rut & "' AND " &_
		"      a.pers_xdv = '" & dv & "' " &_
		"ORDER BY f.comp_fdocto ASC, f.comp_ndocto ASC"

formulario.consultar tabla

		
	
cns_total = "SELECT sum(f.comp_mdocumento) AS total " &_
            "FROM personas a, compromisos f " &_
    		"WHERE a.pers_ncorr = f.pers_ncorr AND " &_
			"      f.ecom_ccod <> " & ecom_ccod_nulo & " AND " &_
			"      (f.tcom_ccod BETWEEN 8 AND 13) AND " &_
		    "      a.pers_nrut = " & rut & " AND " &_
		    "      a.pers_xdv = '" & dv & "' " &_
		    "ORDER BY f.comp_fdocto ASC, f.comp_ndocto ASC"
			
cns_total = "SELECT sum(b.comp_mdocumento) AS total " &_
            "FROM personas a, compromisos b, tipos_compromisos c " &_
			"WHERE a.pers_ncorr = b.pers_ncorr AND " &_
			"      b.tcom_ccod = c.tcom_ccod AND " &_
			"	   b.ecom_ccod <> " & ecom_ccod_nulo & " AND " &_
			"	   c.tcom_bcargo = 'S' AND " &_
			"	   a.pers_nrut = '" & rut & "' AND " &_
			"	   a.pers_xdv = '" & dv & "'"

'ftotal.consultar cns_total
'ftotal.siguiente
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
function FilasSeleccionadas(formulario)
{
	var n_filas_seleccionadas = 0;
	
	for (var i = 0; i < formulario.elements.length; i++) {
		if (formulario.elements[i].type == 'checkbox') {
			if (formulario.elements[i].checked) {
				n_filas_seleccionadas++;
			}
		}
	}
	
	return n_filas_seleccionadas;
}


function Eliminar(formulario)
{
	if (FilasSeleccionadas(formulario) > 0) {
		if (confirm('¿Está seguro que desea eliminar los cargos seleccionados?')) {
			
			for (i=0; i< formulario.elements.length; i++) {	
				if (formulario.elements[i].name.search(/\[ecom_ccod\]/) >= 0)		
					formulario.elements[i].value = 3;	
			}
			
			for (i=0; i< formulario.elements.length; i++) {	
				if (formulario.elements[i].name.search(/\[dcom_ncompromiso\]/) >= 0)		
					formulario.elements[i].value = 1;	
			}
			
			
	
			formulario.action = 'cta_corr_cargo_eliminar.asp?rut=<%=rut%>&dv=<%=dv%>';
			formulario.submit();
		}
	} else {
		alert('No ha seleccionado ningún compromiso para anular.');
	}
}



function AgregarCargo(p_rut, p_dv)
{
	resultado = open("cta_corr_cargo_agregar.asp?rut=" + p_rut + "&dv="+ p_dv, "", "width=780; height=420");
}


function AgregarPersona(p_rut, p_dv)
{
	if (valida_rut(p_rut + '-' + p_dv)) {
		resultado = open("agregar_persona.asp?rut=" + p_rut + "&dv="+ p_dv, "", "width=780; height=420");
	}
	else {
		alert('El RUT ' + p_rut + ' - ' + p_dv + ' no es válido.');
	}
}


function Agregar(p_rut, p_dv)
{
	<%if persona_existe then%>
	AgregarCargo(p_rut, p_dv);
	<%else%>
	AgregarPersona(p_rut, p_dv);
	<%end if%>	
}



function enviar(formulario){
	if (!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))) {
	    alert('ERROR.\nEl RUT que Ud. ha ingresado no es válido. Por favor, ingréselo nuevamente.');
		formulario.rut.focus();
		formulario.rut.select();
	 }
	else{
		formulario.action = '';
		formulario.submit();
	}
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
                  <td width="81%"><div align="center"></div></td>
                  <td width="19%"><div align="center">BUSCAR</div></td>
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
                    <td><%pagina.DibujarSubtitulo "Sub-título 1"%>
                      <br></td>
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
                  <td><div align="center">AGREGAR</div></td>
                  <td><div align="center">ELIMINAR</div></td>
                  <td><div align="center">SALIR</div></td>
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
