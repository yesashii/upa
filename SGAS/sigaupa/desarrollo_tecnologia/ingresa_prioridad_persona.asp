<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_nrut=request.QueryString("a[0][pers_nrut]")
pers_xdv=request.QueryString("a[0][pers_xdv]")
tpus_ccod=request.QueryString("a[0][tpus_ccod]")

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina


set botonera = new CFormulario
botonera.carga_parametros "solicita_soporte.xml", "botonera"

 
 set f_peticion = new CFormulario
f_peticion.Carga_Parametros "solicita_soporte.xml", "ingresa_prioridad_persona"
f_peticion.Inicializar conexion

sql_descuentos= "select ''"

'response.write(sql_descuentos)'
f_peticion.Consultar sql_descuentos
f_peticion.siguiente


 set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "solicita_soporte.xml", "busqueda_ingresa_prioridad_persona"
f_busqueda.Inicializar conexion

sql_descuentos= "select ''"

'response.write(sql_descuentos)'
f_busqueda.Consultar sql_descuentos
f_busqueda.siguiente
f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
f_busqueda.AgregaCampoCons "tpus_ccod", tpus_ccod

 set f_resul = new CFormulario
f_resul.Carga_Parametros "solicita_soporte.xml", "prioridades_personas"
f_resul.Inicializar conexion
if request.QueryString<>"" then
if pers_nrut<>"" then
filtro=filtro&"and c.pers_nrut="&pers_nrut
end if

if tpus_ccod<>"" then
filtro2=filtro2&"and a.tpus_ccod="&tpus_ccod
end if
sql_descuentos= "select pers_tnombre+' '+pers_tape_paterno as nombre, tpus_tdesc" & vbCrLf &_
				"from info_usuarios_soporte a, tipos_prioridad_usuarios b,personas c"& vbCrLf &_
				"where a.tpus_ccod=b.tpus_ccod"& vbCrLf &_
				"and a.pers_ncorr=c.PERS_NCORR"& vbCrLf &_
				""&filtro&" "&filtro2&""
else
sql_descuentos= "select ''"
end if
'response.write(sql_descuentos)'
f_resul.Consultar sql_descuentos
f_resul.siguiente

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function Validar_rut()
{
	formulario = document.edicion;
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		formulario.elements["b[0][pers_nrut]"].focus();
		formulario.elements["b[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<form name="ingresa">
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
            <td><%
				
				 lenguetas=Array("Indicar Prioridad Persona")
					
					pagina.DibujarLenguetas lenguetas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			
				<table width="450" align="center">
					<tr>
						<td width="113"><strong>Rut Persona</strong></td>
						<td width="325"><strong>:</strong>&nbsp;<%f_peticion.DibujaCampo("pers_nrut")%><strong>-</strong>&nbsp;<%f_peticion.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "test[0][pers_nrut]", "test[0][pers_xdv]"%></td>
					</tr>
					<tr>
						<td><strong>Prioridad</strong></td>
						<td><strong>:</strong>&nbsp;<%f_peticion.DibujaCampo("tpus_ccod")%>&nbsp;&nbsp;</td>
					</tr>
					</table>
			
            </td>
		</tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<% 
					botonera.DibujaBoton"guardar_marca_monitores"%></div></td>

                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</form>
	<br>
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
            <td><%
				
				 lenguetas=Array("Mostrar Prioridad Persona")
					
					pagina.DibujarLenguetas lenguetas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<form name="busqueda">
				<table width="450" align="center">
					<tr>
						<td width="113"><strong>Rut Persona</strong></td>
						<td width="325"><strong>:</strong>&nbsp;<%f_busqueda.DibujaCampo("pers_nrut")%><strong>-</strong>&nbsp;<%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "a[0][pers_nrut]", "a[0][pers_xdv]"%></td>
					</tr>
					<tr>
						<td><strong>Prioridad</strong></td>
						<td><strong>:</strong>&nbsp;<%f_busqueda.DibujaCampo("tpus_ccod")%>&nbsp;&nbsp;</td>
					</tr>
					</table>
			</form>
			<hr>
			<table align="center" width="90%">
				<tr>
						 <td align="right">P&aacute;gina:
							 <%f_resul.accesopagina%>
						 </td>
				  </tr>
				<tr>
					<td><%f_resul.Dibujatabla()%></td>
				</tr>
			</table>
            </td>
		</tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%botonera.DibujaBoton"persona"%></div></td>
					<td><div align="center">
                    
					<%botonera.DibujaBoton"salir" %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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