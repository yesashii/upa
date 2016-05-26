<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listado_postulaciones_becas.xml", "botonera"

periodo=negocio.obtenerPeriodoAcademico("Postulacion")
nombre_periodo = conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

pagina.Titulo = "Listado de postulaciones a Becas <br>"&nombre_periodo
'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'response.Write(carr_ccod)
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 



set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "listado_postulaciones_becas.xml", "f_busqueda"
 
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
 
 consulta_carreras = " select distinct c.carr_ccod, c.carr_tdesc from ofertas_academicas a, especialidades b, carreras c "&_
					 " where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod" &_
					 " and cast(a.peri_ccod as varchar)='"&periodo&"' "&_
				 	 " and exists (select 1 from postulacion_becas pb where pb.peri_ccod=a.peri_ccod and b.carr_ccod=pb.carr_ccod)"
 f_busqueda.AgregaCampoParam "carr_ccod", "destino", "("&consulta_carreras&")a"
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.Siguiente
  
 'ultimo = carr_ccod
if carr_ccod <> "" then
	filtro_carrera = " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"
else
	filtro_carrera = ""
end if
'---------------------------------------------------------------------------------------------------
set f_postulaciones = new CFormulario
f_postulaciones.Carga_Parametros "listado_postulaciones_becas.xml", "f_postulaciones"
f_postulaciones.Inicializar conexion
 consulta = " select a.pobe_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, protic.initcap(b.pers_tape_paterno + ' ' + b.pers_tape_materno+ ' ' + b.pers_tnombre) as postulante,"& vbCrLf &_
			" pobe_ningreso_revisado as ingresos,pobe_nintegrantes_revisado as Nintegrantes,pobe_ncapacidad_pago as capacidad,protic.initcap(c.carr_tdesc) as carrera, "& vbCrLf &_
			" isnull(cast(pobe_nresolucion as varchar),'') as nresolucion, "& vbCrLf &_
			" protic.trunc(pobe_fobtencion) as fecha_obtencion,aran_mmatricula as matricula, aran_mcolegiatura as arancel,	"& vbCrLf &_
			" cast(isnull(cast(pobe_nporcentaje_asignado as varchar),'') as varchar) + ' %' as porcentaje "& vbCrLf &_
			" from postulacion_becas a, personas_postulante b,carreras c,ofertas_academicas d, aranceles e "& vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr and a.epob_ccod=2  and a.carr_ccod=c.carr_ccod"& vbCrLf &_
			" and cast(a.peri_ccod as varchar)='"&periodo&"' " &filtro_carrera& vbCrLf &_
			" and a.ofer_ncorr = d.ofer_ncorr and d.aran_ncorr=e.aran_ncorr " &vbCrLf &_
			" ORDER BY capacidad asc "
'response.write("<pre>"&consulta&"</pre>")
f_postulaciones.Consultar consulta

'---------------------------------------------------------------------------------------------------
cantidad = f_postulaciones.NroFilas
'response.Write(cantidad)
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
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
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
                            <table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><div align="center">
                     
                    <br>
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_postulaciones.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%f_postulaciones.DibujaTabla()%>
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
            <td width="14%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
					<td width="14%"> <div align="center">  <% if cantidad = "0" then
					                                          botonera.agregaBotonParam "excel","deshabilitado","true"
															  end if
				                           botonera.agregabotonparam "excel", "url", "listado_postulaciones_becas_excel.asp?carr_ccod="&carr_ccod
										   botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                </tr>
              </table>
            </div></td>
            <td width="86%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
