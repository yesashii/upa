<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

ting_ccod 	= request.QueryString("ting_ccod")
v_cuenta 	= request.QueryString("cuenta")
viene 		= request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Mantenedor de Cuentas "
set botonera =  new CFormulario
botonera.carga_parametros "adm_cuentas_ingresos.xml", "btn_agregar_cuenta"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

if v_cuenta<>"" then
	sql_existe="Select csof_ncorr from cuentas_softland where cuenta='"&v_cuenta&"'"
	'response.Write(sql_existe)
	csof_ncorr = conectar.ConsultaUno(sql_existe)
end if

v_es_regularizacion=conectar.ConsultaUno("select count(*) from tipos_ingresos where ting_ccod="&ting_ccod&" and ting_bregularizacion='S'")

set negocio = new CNegocio
negocio.Inicializa conectar

'consulta="select area_ccod,inst_ccod,ecar_ccod,tcar_ccod,carr_tdesc,convert(varchar,carr_fini_vigencia,103) as carr_fini_vigencia,convert(varchar,carr_ffin_vigencia,103) as  carr_ffin_vigencia,carr_tsigla from carreras where carr_ccod = '"&carr_ccod&"'"

consulta ="  select ting_ccod,ting_tdesc,ting_cuenta_softland, ting_tipos_softland, ting_detalle_gasto " & vbCrlf & _
			" from tipos_ingresos " & vbCrlf & _
			" where cast(ting_ccod as varchar) = '"&ting_ccod&"' " & vbCrlf & _
			" order  by ting_tdesc desc" 

'response.Write("<pre>"&consulta&"</pre>")

set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_cuentas_ingresos.xml",	"tabla_valores"
formulario.inicializar		conectar
formulario.consultar 		consulta
formulario.siguientef
filas = formulario.nrofilas
if filas =0 then
	formulario.AgregaCampoCons "cuenta", v_cuenta
end if
'---------------------------------------------------------------------------------------------------

'response.Write(" Regularizacion"&v_es_regularizacion)
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
function agregar(formulario){
	formulario.action = 'proc_agrega_cuenta_ingresos.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
	}
 }
 
function salir(){
viene ='<%=viene%>'
if (viene !=1){
	self.opener.location.reload();
}
else{
	self.opener.close();
	self.opener.opener.location.reload();
}	
window.close();
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "em[0][CARR_FINI_VIGENCIA]","1","editar","fecha_oculta_CARR_FINI_VIGENCIA"
	calendario.MuestraFecha "em[0][CARR_FFIN_VIGENCIA]","2","editar","fecha_oculta_CARR_FFIN_VIGENCIA"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="550" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br>
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
            <td><%pagina.DibujarLenguetas Array("Mantenedor de Cuentas Ingresos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Datos de la Cuenta "%>
<font color="#CC3300">*</font>Campos Obligatorios            
  <form name="editar" method="post">
                <table width="90%" border="0" align="center">
                  <tr>
                    <td width="31%"><font color="#CC3300">* </font> C&oacute;digo</td>
                    <td width="69%">: <strong><%formulario.dibujacampo("ting_tdesc")%></strong></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">* </font>Nº Cuenta</td>
                    <td>:<%formulario.dibujacampo("ting_cuenta_softland")%></td>
                  </tr>
                  <tr>
                        <td><font color="#CC3300">* </font> Tipo Doc.</td>
                    <td>:<%formulario.dibujacampo("ting_tipos_softland")%></td>
                  </tr>
				  <%if v_es_regularizacion >"0" then%>
				  <tr>
                    <td>Detalle Gasto</td>
                    <td>:<%formulario.dibujacampo("ting_detalle_gasto")%></td>
                  </tr>
				  <%end if%>
				  <tr>
				    <td><%formulario.dibujacampo("ting_ccod")%></td>
				    <td>&nbsp;</td>
				    </tr>
                </table>
				<input type="hidden" name="em[0][csof_ncorr]" value="<%=csof_ncorr%>">
				<input type="hidden" name="inserta" value="<%=viene%>">

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
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "GUARDAR"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "SALIR"%>
                  </font> </div></td>
                  <td><div align="center"></div></td>
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
