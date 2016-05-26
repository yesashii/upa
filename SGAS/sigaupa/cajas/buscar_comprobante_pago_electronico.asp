<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
q_pele_ccod = Request.QueryString("busqueda[0][pele_ccod]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Buscar comprobante de pago electronico de letras"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'nombre del alumno

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "archivo_pago_electronico.xml", "botonera"



'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "archivo_pago_electronico.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

 set f_cargados = new CFormulario
 f_cargados.Carga_Parametros "archivo_pago_electronico.xml", "comprobantes_de_carga"
 f_cargados.Inicializar conexion

sql_existentes= " SELECT pele_ccod as comprobante, protic.trunc(getdate()) as fecha,count(*) as cantidad, sum (pele_mmonto_recaudado) as  total , "&_ 
				" min (pele_nidentificacion) as  desde , max(pele_nidentificacion) as hasta, isnull(epel_ccod,1) as estado, "&_
				" '<a href=""javascript:imprimir_comprobante('+ cast(pele_ccod as varchar)+ ')"">'+ 'Ver' + '</a>' as revisar " &_
				" FROM pago_electronico_letras "&_
				" where epel_ccod=4 "&_
				" and ingr_nfolio_referencia is not null "

					if q_pers_nrut <> "" then
					  sql_existentes = sql_existentes &  "and pers_nrut = '" & q_pers_nrut & "' "& vbCrLf
					end if
					if q_pele_ccod <> "" then
					  sql_existentes = sql_existentes &  "and pele_ccod = '" & q_pele_ccod & "' "& vbCrLf
					end if
					
					sql_existentes = sql_existentes & "group by pele_ccod, epel_ccod "


   if Request.QueryString <> "" then
     
		f_cargados.Consultar sql_existentes
   else
	 f_cargados.consultar "select '' where 1 = 2"
	 f_cargados.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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
function Validar()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
return true;	  
}



function imprimir_comprobante(pele_ccod)
{
	var url;
	url="imprimir_comprobante.asp?pele_ccod="+pele_ccod;
	window.open(url,"comprobante","resizable=yes,width=800,height=800,scrollbars=no");
}



</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
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
                  <td width="100%">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="109"><strong>RUT Alumno </strong></td>
                        <td width="18"><div align="center">:</div></td>
                        <td width="122"><%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
						<td width="140" align="right"><strong>Fecha Carga </strong></td>
						<td width="9"><div align="center">:</div></td>
						<td width="138"><%f_busqueda.DibujaCampo("audi_fmodificacion")%> 
						  (dd/mm/aaaa) </td>
                      </tr>
                      <tr>
                        <td><strong>N&deg; comprobante</strong> </td>
                        <td width="18"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pele_ccod")%></td>
						<td></td>
						<td width="9"></td>
						<td width="138"></td>
                      </tr>
                    </table>
                  </td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar2")%></div></td>
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
            </div>
            <form name="edicion">
                 <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                    <td><div align="right">
                      <div align="left">
                          <%pagina.DibujarSubtitulo "Listado pago de letras electronico"%>                          
                      </div>
                      <div align="right">                        </div></td>
                  </tr>
              
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%f_cargados.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%f_cargados.dibujatabla()%>
                    </div></td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
