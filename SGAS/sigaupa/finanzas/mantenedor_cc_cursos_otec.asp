<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_tcom_ccod = Request.QueryString("tcom_ccod")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cursos - Diplomados OTEC"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedor_cc_cursos_otec.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "mantenedor_cc_cursos_otec.xml", "tipos_detalle"
f_tipos_detalle.Inicializar conexion

		   

consulta =	"select b.dcur_ncorr as codigo, b.dcur_ncorr as indice,a.tdet_ccod, a.tdet_tdesc, a.tdet_mvalor_unitario, '' as ccos_tcompuesto, '' as ccos_tdesc "& vbCrLf &_
			"	from tipos_detalle a join diplomados_cursos b  "& vbCrLf &_
			"	on a.tdet_ccod=b.tdet_ccod  "& vbCrLf &_
			"	where a.tcom_ccod = 7  "& vbCrLf &_
			"	and tdet_mvalor_unitario >=0  "& vbCrLf &_
			"   and year(b.audi_fmodificacion) >=2012 "& vbCrLf &_
			"   and a.tdet_ccod not in (2388,2355) "& vbCrLf &_
			"   and not exists (select 1 from centros_costos_asignados where tdet_ccod=a.tdet_ccod) "& vbCrLf &_
			"	order by convert(datetime,b.audi_fmodificacion,103) desc, a.tdet_ccod asc "		
			
'response.Write("<pre>"&consulta&"</pre>")		   
'response.End()
f_tipos_detalle.Consultar consulta


'---------------------------------------------------------------------------------------------------
v_tcom_tdesc = conexion.ConsultaUno("	select tcom_tdesc from tipos_compromisos where cast(tcom_ccod as varchar) = '"&q_tcom_ccod&"'")
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

function seleccionar(elemento){
	if (elemento.checked){
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.edicion.elements["tipos_detalle["+v_indice+"][ccos_tcompuesto]"].disabled=false;
		document.edicion.elements["tipos_detalle["+v_indice+"][ccos_tdesc]"].disabled=false;
	}else{
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.edicion.elements["tipos_detalle["+v_indice+"][ccos_tcompuesto]"].disabled=true;
		document.edicion.elements["tipos_detalle["+v_indice+"][ccos_tdesc]"].disabled=true;
	}
}

function ValidaPatron(campo) {
	var RegExPattern = /^\w{1}\-\w{2}\-\w{3}$/;
    var errorMessage = 'Estructura de codigo incorrecto. Debe cumplir el formato: X-XX-XXX';
    if ((campo.value.match(RegExPattern)) && (campo.value!='')) {

    } else {
        alert(errorMessage);
		campo.value='';
        campo.focus();
    } 
}

function MensajeError(){
<% if session("mensaje_error")<> "" then %>

	alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

</script>

<style type="text/css">
<!--
.Estilo1 {color: #FF0000}
.Estilo2 {color: #0033FF}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onBlur="revisaVentana();" onLoad="MensajeError();">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Tipos de Ítemes"), 1 %></td>
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
                    <td><%pagina.DibujarSubtitulo "Ítemes : " & v_tcom_tdesc%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
					  <td><div align="right"> <%f_tipos_detalle.AccesoPagina%></div></td>
					  </tr>
                        <tr>
                          <td><div align="center"><%f_tipos_detalle.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
						  <strong>(<span class="Estilo1">*</span>)</strong> El formato para ingresar un centro de costo es : <span class="Estilo2">X-XX-XXX</span><br>
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
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "aceptar"%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "salir"%>
                  </div></td>
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
