<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Cambiar Asignatura "

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

DIAS_CCOD = Request.QueryString("DIAS_CCOD")
SALA_CCOD = Request.QueryString("SALA_CCOD")
BLOQ_CCOD = Request.QueryString("BLOQ_CCOD")
HORA_CCOD = Request.QueryString("HORA_CCOD")
SEDE_CCOD = Request.QueryString("SEDE_CCOD")
SSEC_NCORR = Request.QueryString("SSEC_NCORR")
SECC_CCOD = Request.QueryString("SECC_CCOD")

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cambio_asignatura.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_asignatura.xml", "datos_cambio_asignatura"
formulario.Inicializar conexion
consulta ="select ''"


formulario.Consultar consulta
formulario.Siguiente
formulario.AgregaCampoCons "DIAS_CCOD", DIAS_CCOD
formulario.AgregaCampoCons "SALA_CCOD", SALA_CCOD
formulario.AgregaCampoCons "BLOQ_CCOD", BLOQ_CCOD
formulario.AgregaCampoCons "HORA_CCOD", HORA_CCOD
formulario.AgregaCampoCons "SEDE_CCOD", SEDE_CCOD
formulario.AgregaCampoCons "SSEC_NCORR", SSEC_NCORR
formulario.AgregaCampoCons "SECC_CCOD", SECC_CCOD

consulta_Block = "select HORA_CCOD, CAST(cast(HORA_CCOD as varchar) +' ('+ SUBSTRING" & vbCrLf &_ 
" (CONVERT(CHAR(16),HORA_HINICIO,121), 12,8)+' '++' a '++' '+ SUBSTRING" & vbCrLf &_ 
" (CONVERT(CHAR(16),HORA_HTERMINO,121), 12,8)+') ' as varchar) as BLOCK from HORARIOS_SEDES"& vbCrLf &_
"  WHERE SEDE_CCOD = " &SEDE_CCOD

consulta_Sala = "select distinct SALA_CCOD,SALA_TDESC  from SALAS where SEDE_CCOD =" &SEDE_CCOD & " order by SALA_TDESC"


formulario.agregaCampoParam "HORA_CCOD", "destino", "("& consulta_Block &") HC"
formulario.agregaCampoParam "SEDE_CCOD", "destino", "("& consulta_Sala &") SC"

%>


<html>
<head>
<title>Cambio Promedio </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

function cerrarVentana(){
	window.close();
}


</script>

</head>
<body  onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../adm_sistema/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../adm_sistema/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
   <tr>
    <td height="268" valign="top" bgcolor="#EAEAEA">
	<BR>
	<BR>			
	
	<table  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="80%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif"  height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						  <td width="9" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
						  
                      <td width="205" valign="middle" background="../imagenes/fondo1.gif"><font color="white">Cambiar Asignatura</font> </td>
						  <td width="" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
						</tr>
					</table>
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif"  height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                </div>
                  <form name="edicion">
					         
					<table width="55%" border="0" >
                    
                    </table>
					<table width="549" border="0">
					  <tr>
					    <td width="98"><strong>Elija el D&iacute;a</strong></td>
					    <td width="19" align = "center"><div align="center"><strong>:</strong></div></td>
					    <td width="410"><%formulario.dibujaCampo("DIAS_CCOD")%></td>
				      </tr>
					  <tr>
					    <td><strong>Elija el Bloque</strong></td>
					    <td><div align="center"><strong>:</strong></div></td>
					    <td><%formulario.dibujaCampo("HORA_CCOD")%></td>
				      </tr>
					  <tr>
					    <td><strong>Elija la Sala</strong></td>
					    <td><div align="center"><strong>:</strong></div></td>
					    <td><%formulario.dibujaCampo("SALA_CCOD")%></td>
				      </tr>
					  <tr>
					    <td>&nbsp;</td>
					    <td><div align="center"></div></td>
					    <td><%formulario.dibujaCampo("BLOQ_CCOD")%></td>
                        <td><%formulario.dibujaCampo("SSEC_NCORR")%></td>
                        <td><%formulario.dibujaCampo("SECC_CCOD")%></td>
				      </tr>
				    </table>
					<p>&nbsp;</p>
					</form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="123" bgcolor="#D8D8DE"> <div align="left"></div> 
		            <div align="left">                       <table width="100%" border="0" cellpadding="0" cellspacing="0">
                         <tr>
                           <td width="16%">
						   <%botonera.dibujaboton "guardar"%>
                           </td>
                           <td width="84%"><% botonera.dibujaboton "cancelar"%>
                           </td>
                         </tr>
                       </table>
</div></td>
                  <td  rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="45%" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
