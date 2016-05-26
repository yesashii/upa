<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
publ_ccod=request.QueryString("publ_ccod")
pers_ncorr=request.QueryString("pers_ncorr")

if	EsVacio(request.QueryString("publ_ccod")) then ' Crear Nueva publicacion
	pagina.Titulo = "Agregar Documento"
else
	pagina.Titulo = "Editar Documento" ' Editar una publicacion
end if

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

SqlPublicacion=" Select publ_ccod,protic.trunc(publ_fpublicacion) as publ_fpublicacion,tpub_ccod,pers_ncorr, " & _
			   " publ_tdesc,publ_tmedio,pais_ccod,publ_tautoria" & _
			   " from publicacion_docente " & _
			   " where cast(publ_ccod as varchar)='" & publ_ccod & "'"

set F_Publicacion = new cformulario			   
F_Publicacion.carga_parametros "publicacion_docente.xml", "agregar_publicacion_docente"
F_Publicacion.inicializar conectar

F_Publicacion.consultar SqlPublicacion
F_Publicacion.siguientef


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "publicacion_docente.xml", "botonera"

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
function compfecha(formulario){
	StrDesde=formulario.elements["m[0][cudo_finicio]"].value;
	arrfechaDesde=StrDesde.split('/');
	StrHasta=formulario.elements["m[0][cudo_ftermino]"].value;
	arrFechaHasta=StrHasta.split('/');
	var FechaDesde = new Date(arrfechaDesde[2],arrfechaDesde[1],arrfechaDesde[0])	
	var FechaHasta = new Date(arrFechaHasta[2],arrFechaHasta[1],arrFechaHasta[0])
	if (FechaDesde<FechaHasta) {
		return true;
	}
	else {return false;}
	}
	
function ValidaForm(formulario)
{
	if (!compfecha(formulario)) {
		alert("La fecha desde debe ser menor a la fecha hasta.")
		return false;
	}
	
	return true;
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td height="8" background="../imagenes/top_r1_c2.gif"></td>
                <td height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif"><%=pagina.Titulo%></font></div></td>
                      <td bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td background="../imagenes/top_r3_c2.gif"></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="edicion">
					<input name="m[0][pers_ncorr]" type="hidden" value="<%=pers_ncorr%>">
					<input type="hidden" name="publ_ccod" value="<%=publ_ccod%>">
              <table width="100%" border="0">
                <tr> 
                  <td align="center"><div align="right"><font color="#CC3300">*</font> 
                      Campos Obligatorios</div></td>
                </tr>
              </table>
        
              <table width="100%" border="0">
                <tr> 
                  <td width="6%" align="right"><font color="#CC3300">*</font> 
                  </td>
                  <td width="38%" align="right"><div align="left"><strong>Nombre publicaci&oacute;n </strong></div></td>
                  <td width="56%" align="left">:<%F_Publicacion.dibujacampo("publ_tdesc")%>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="right"><font color="#CC3300">*</font></td>
                  <td align="right"><div align="left"><strong>Tipo documento</strong></div></td>
                  <td align="left">:<%F_Publicacion.dibujacampo("tpub_ccod")%>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="right">&nbsp;</td>
                  <td align="right"><div align="left"><strong>Pa&iacute;s publicado </strong></div></td>
                  <td align="left">:<%F_Publicacion.dibujacampo("pais_ccod")%> </td>
                </tr>
                <tr> 
                  <td align="right">&nbsp;</td>
                  <td align="right"><div align="left"><strong>Medio publicaci&oacute;n</strong></div></td>
                  <td>:<%F_Publicacion.dibujacampo("publ_tmedio")%></td>
                </tr>
				<tr> 
                  <td align="right">&nbsp;</td>
                  <td align="right"><div align="left"><strong>Fecha publicación</strong></div></td>
                  <td>:<%F_Publicacion.dibujacampo("publ_fpublicacion")%>
(dd/mm/aaaa)</td>
                </tr>
				<tr> 
                  <td align="right"><font color="#CC3300">&nbsp;</font></td>
                  <td align="right"><div align="left"><strong>Autoría</strong></div></td>
                  <td>:<%F_Publicacion.dibujacampo("publ_tautoria")%></td>
                </tr>
              </table>
            </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%f_botonera.DibujaBoton "guardar" %></div></td>
                      <td><div align="center"><%f_botonera.DibujaBoton "cerrar" %></div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
