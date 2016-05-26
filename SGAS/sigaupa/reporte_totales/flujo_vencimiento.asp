<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

set f_busqueda = new CFormulario
set conexion = new CConexion
set botonera = new CFormulario
set negocio = new CNegocio

conexion.Inicializar "upacifico"
negocio.Inicializa conexion
'-----------------------------------------------------------------------
pagina.Titulo = "Flujo de Vencimiento"

'-----------------------------------------------------------------------
botonera.Carga_Parametros "reportes_totales_ingresos.xml", "btn_flujo"

 'fecha_inicio = request.querystring("busqueda[0][fecha_inicio]")
 'fecha_termino = request.querystring("busqueda[0][fecha_termino]")
 'sede = request.querystring("busqueda[0][sede]")



 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reportes_totales_ingresos.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "sede", sede
 f_busqueda.AgregaCampoCons "fecha_inicio", fecha_inicio
 f_busqueda.AgregaCampoCons "fecha_termino", fecha_termino

'-----------------------------AGREGADO X CARLOS------------------------------------------
Usuario = negocio.ObtenerUsuario()

consulta = "SELECT pers_ncorr FROM personas WHERE pers_nrut='" & Usuario & "'"
pers_ncorr = conexion.ConsultaUno(consulta)
f_busqueda.AgregaCampoParam "sede","destino", "(select a.sede_ccod, d.sede_tdesc from sis_sedes_usuarios a, sis_usuarios b, personas c, sedes d where a.pers_ncorr = b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and a.sede_ccod = d.sede_ccod and a.pers_ncorr =" & pers_ncorr & ") a"
'----------------------------------------------------------------------------

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
anodos = conexion.consultaUno("select datepart(year,getdate()) year")

'---------------------------------------------------------------------------------------------------
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
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

function chequear_fecha() {


var fecha_termino=document.buscador.elements["busqueda[0][fecha_termino]"].value;
var fecha_inicio=document.buscador.elements["busqueda[0][fecha_inicio]"].value;

if (document.buscador.elements["busqueda[0][sede]"].value == "" )
   {
	alert("Seleccione la Sede");
	document.buscador.elements["busqueda[0][sede]"].focus();
    return false;
  }
  
if (!isFecha(fecha_inicio)){
	alert("Ingrese Fecha de Inicio");
	document.buscador.elements["busqueda[0][fecha_inicio]"].focus();
    return false;
}
if (!isFecha(fecha_termino)){
	alert("Ingrese Fecha de Termino");
	document.buscador.elements["busqueda[0][fecha_termino]"].focus();
    return false;
}




var aa_fecha_termino = fecha_termino.split(/\//);
var aa_fecha_inicio = fecha_inicio.split(/\//);

var ano_t= aa_fecha_termino[2];
var ano_i=aa_fecha_inicio[2];
var mes_t=aa_fecha_termino[1];
var mes_i=aa_fecha_inicio[1];
var dia_t=aa_fecha_termino[0];
var dia_i=aa_fecha_inicio[0];

if( parseInt(ano_i) > parseInt(ano_t)) {
    alert("La Fecha de Inicio debe ser menor a la Fecha de Termino");
    return false;
  }
if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) > parseInt(mes_t)) ) {
    alert("La Fecha de Inicio debe ser menor a la Fecha de Termino");
    return false;
  }
if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) == parseInt(mes_t))&& (parseInt(dia_i) > parseInt(dia_t)) ) {
    alert("La Fecha de Inicio debe ser menor a la Fecha de Termino");
    return false;
  }

if( (parseInt(ano_i) == parseInt(ano_t))&&(parseInt(mes_i) == parseInt(mes_t))&& (parseInt(dia_i) == parseInt(dia_t)) ) {
    alert("La Fecha de Inicio debe ser menor a la Fecha de Termino");
    return false;
  }

return true;

}


function enviar_pdf() {
sede_j=document.buscador.elements["busqueda[0][sede]"].value;
fecha_termino_j=document.buscador.elements["busqueda[0][fecha_termino]"].value;
fecha_inicio_j=document.buscador.elements["busqueda[0][fecha_inicio]"].value;
periodo_j = document.buscador.periodo.value;
ano_actual_j = document.buscador.ano_actual.value;
if (document.buscador.tipo_informe[0].checked)
	tipo_informe_j = 1;
else
	tipo_informe_j = 2;

if (chequear_fecha())
{
	url= "../REPORTESNET/Flujo_Vencimiento.aspx?periodo="+periodo_j+"&sede="+sede_j+"&fecha_inicio="+fecha_inicio_j+"&fecha_termino="+fecha_termino_j+"&ano_actual="+ano_actual_j+"&tipo_informe="+tipo_informe_j;
	window.open(url);
}


	//buscador.method= "get";
	//buscador.action= "/REPORTESNET/Flujo_Vencimiento.aspx?periodo="+periodo_j+"&sede="+sede_j+"&fecha_inicio="+fecha_inicio_j+"&fecha_termino="+fecha_termino_j+"&ano_actual="+ano_actual_j;
	
	//buscador.target = "_blank";
	//alert(buscador.action);
	//buscador.submit();
	//navigate(buscador.action);
	
	
	
}
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
	
	rut_apoderado = formulario.elements["busqueda[0][code_nrut]"].value + "-" + formulario.elements["busqueda[0][code_xdv]"].value;	
    if (formulario.elements["busqueda[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][code_xdv]"].focus();
		formulario.elements["busqueda[0][code_xdv]"].select();
		return false;
	   }
	return true;
}

</script>

<script language="JavaScript">
function abrir()
 { 
  location.reload("Envios_Cobranza_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][fecha_inicio]","1","buscador","fecha_oculta_fecha_inicio"
	calendario.MuestraFecha "busqueda[0][fecha_termino]","2","buscador","fecha_oculta_fecha_termino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="282" valign="bottom" background="../imagenes/fondo1.gif"> 
                        <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Flujo 
                          de Vencimiento</font></div></td>
                      <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                      <td width="363" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    </tr>
                  </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center"> 
                    <form name="buscador" >
                      <table width="98%"  border="0">
                        <tr> 
                          <td width="81%"><table width="524" border="0">
                              <tr> 
                                <td width="86" height="20">Sede</td>
                                <td width="17">:</td>
                                <td width="151"> 
                                  <% f_busqueda.DibujaCampo("sede") %>
                                </td>
                                <td width="93">&nbsp;</td>
                                <td width="12">&nbsp;</td>
                                <td width="139">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Fecha Inicio</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.dibujaCampo ("fecha_inicio") %>
								  <%calendario.DibujaImagen "fecha_oculta_fecha_inicio","1","buscador" %>(dd/mm/aaaa)
                                  <input type="hidden" name="periodo" value="<%=Periodo%>">
                                  <input type="hidden" name="ano_actual" value="<%=anodos%>">
                                  </font></td>
                                <td>Fecha Termino</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <% f_busqueda.dibujaCampo ("fecha_termino") %>
								  <%calendario.DibujaImagen "fecha_oculta_fecha_termino","2","buscador" %>(dd/mm/aaaa)
                                  </font></td>
                              </tr>
                            </table></td>
                          <td width="19%"><div align="center"> 
                              	<%
							 
							  	botonera.DibujaBoton "imprimir_pdf_flujo" 
							  
          						%>
                              <br>
                              <br>
                              <input name="tipo_informe" type="radio" value="1" checked>
                              PDF 
                              <input type="radio" name="tipo_informe" value="2">
                              EXCEL</div></td>
                        </tr>
                      </table>
                    </form>
                  </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table></td>
        </tr>
      </table>
      <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>