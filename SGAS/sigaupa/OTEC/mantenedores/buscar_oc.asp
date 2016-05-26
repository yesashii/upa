<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
anio_admision = request.querystring("b[0][anio_admision]")
sede_ccod = request.querystring("b[0][sede_ccod]")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
nord_compra= request.querystring("b[0][nord_compra]")
empr_nrut= request.querystring("b[0][empr_nrut]")
empr_xdv= request.querystring("b[0][empr_xdv]")

'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/postulacion_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2&b[0][anio_admision]="&anio_admision&""
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Postulacion a Seminarios, Cursos y Diplomados"

set botonera =  new CFormulario
botonera.carga_parametros "postulacion_otec.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "postulacion_otec.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 
 consulta = "Select '"&anio_admision&"' as anio_admision, '"&sede_ccod&"' as sede_ccod, '"&dcur_ncorr&"' as dcur_ncorr "
 f_busqueda.consultar consulta

 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and a.esot_ccod not in (3) and a.dcur_ncorr not in (5,35) " & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc " 
			
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")

pers_empr_ncorr=conexion.consultaUno("select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&empr_nrut&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
'response.Write("select count(*) from ordenes_compras_otec where nord_compra="&nord_compra&" and dgso_ncorr="&dgso_ncorr&" and empr_ncorr="&pers_empr_ncorr&"")
'response.End()
if anio_admision<>"" and  sede_ccod<>"" and DCUR_NCORR<>"" and nord_compra<>"" then
existe= conexion.consultaUno("select count(*) from ordenes_compras_otec where nord_compra="&nord_compra&" and dgso_ncorr="&dgso_ncorr&" and empr_ncorr="&pers_empr_ncorr&"")
end if
'response.Write(tiene_datos_generales&"<br />")
'response.Write(existe&"<br />")
'response.write("select count(*) from ordenes_compras_otec where nord_compra="&nord_compra&" and dgso_ncorr="&dgso_ncorr&" and empr_ncorr="&pers_empr_ncorr&"")

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
function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function alcargar()
{

document.buscador.elements['b[0][nord_compra]'].value='<%=nord_compra%>';
document.buscador.elements['b[0][empr_nrut]'].value='<%=empr_nrut%>';
document.buscador.elements['b[0][empr_xdv]'].value='<%=empr_xdv%>';
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad=alcargar();"MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
				   <tr>
                    <td width="28%"><strong>Rut Empresa</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td width="69%"><input type='text'  name='b[0][empr_nrut]' value='' size='10'  maxlength='8'  id='NU-S' >-<input type='text'  name='b[0][empr_xdv]' value='' size='1'  maxlength='1'  id='TO-S' ></td>
                  </tr>
				  <tr>
                    <td width="28%"><strong>Año</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td width="69%"><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                  </tr>
				  <tr>
                    <td width="28%"><strong>Sede</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                  </tr>
				 <tr>
                    <td width="28%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr"%></td>
                 </tr>
					<tr>
                    <td width="28%"><strong>Orden de Compra </strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><input type='text'  name='b[0][nord_compra]' value='' size='10'  maxlength='8'  id='NU-N' ></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr>
					  <td align="left" colspan="3"><%botonera.dibujaboton "buscar"%></td>
					  </tr>
              </table>
            </form>
				  
			<%if anio_admision<>"" and  sede_ccod<>"" and DCUR_NCORR<>"" and nord_compra<>"" and existe >0 then%>
			<br>
			<form name="ingresa">
			<input type="hidden" name="b[0][dgso_ncorr]" value="<%=dgso_ncorr%>"/>
			<input type="hidden" name="b[0][nord_compra]" value="<%=nord_compra%>"/>
			<input type="hidden" name="b[0][empr_ncorr]" value="<%=pers_empr_ncorr%>"/>
			<table width="202" border="1">
				 
				  <tr>
                    <td width="28%"><strong>Nro Registro Sense</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><input type='text'  name='b[0][ocot_nro_registro_sense]' value='' size='25'  maxlength='50'  id='TO-N' ></td>
                 </tr>
			</table>
			</form>
			<%end if%>
			<table width="100%">
					  <tr>
					  <%if anio_admision<>"" and  sede_ccod<>"" and DCUR_NCORR<>"" and nord_compra<>"" and existe >0 then%>
						<td width="87%" align="left"><%botonera.AgregaBotonParam "guardar_arancel", "url", "ingresar_nro_reg_sence_proc.asp"
														botonera.AgregaBotonParam "guardar_arancel", "formulario", "ingresa"
														botonera.dibujaboton "guardar_arancel"%></td>
						<%end if%>
					  </tr>
				  </table></td>
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
	</td>
	</tr>
	</table>
	</td></tr>
  
</table>
</td>
</tr>
</table>
</body>
</html>
