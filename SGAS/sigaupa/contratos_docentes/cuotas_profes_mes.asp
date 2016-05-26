<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "botonera_generica.xml", "botonera"
set botonera2 = new CFormulario
botonera2.carga_parametros "meses.xml", "botonera2"

set conexion = new cConexion
set negocio = new cNegocio
'set formu_resul= new cformulario
'set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

'**********************************************

set formulario = new CFormulario
formulario.carga_parametros "meses.xml", "meses"
formulario.Inicializar conexion
formulario.Consultar "select ''"
formulario.Siguiente
formulario.AgregaCampoCons "mes_ccod", Month(now())
%>


<html>
<head>
<title>Reporte Planificaci&oacute;n General</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="">
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
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="106" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"></font></div></td>
                    <td width="347" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="107" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    <td width="105" align="right" bgcolor="#D8D8DE"><%'=formu_resul.dibujaCampo("peri_tdesc")%></td>
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
				<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
				<form name="buscador" method="post">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table cellspacing=0 cellpadding=0 width="100%" border=0>
                        <tbody>
                          <tr>
                            <td width="88%" height=40 align=middle valign=top colspan="2">
                              <div align="center"><strong><font size="3">Listado
                                    de profesores (valor cuota mensual)</font></strong><br>
                                  Presione bot&oacute;n para generar archivo</div></td>
                            </tr>
                          <tr>
                            <td valign=top align="right"><strong>Selecione Mes :</strong></td>
                             <td><%formulario.DibujaCampo("mes_ccod")%></td>
                          </tr>
                        </tbody>
                      </table>
					  </td>
                      <td width="19%">
					  <table>
						  <tr>
							<td>
							 <div align="center">
							  <!--
							botonera.AgregaBotonParam "excel", "url", "cuotas_profes_mes_excel.asp"
							  botonera.AgregaBotonParam "excel", "formulario", "buscador"
							  botonera.AgregaBotonParam "excel", "accion", "guardar"
							  botonera.AgregaBotonParam "excel", "texto", "Contratos Nuevos"
							  botonera.dibujaboton "excel"
--><br></div>
							</td>
						  </tr>
						  <tr>
							<td>
							<% 
botonera2.dibujaboton "excel"
							'botonera.AgregaBotonParam "excel", "url", "cuotas_profes_mes_excel_unidas.asp"
							 'botonera.AgregaBotonParam "excel", "texto", "Contratos Unidos"
					  	     'botonera.dibujaboton "excel"%>
							</td>
						  </tr>
					  </table>
					 
					  </td>
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
            </table>			
          </td>
      </tr>
    </table>	
	<br>
    </td>
  </tr>  
</table>
</body>
</html>