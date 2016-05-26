<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Fondos a Rendir"

v_fren_ncorr	= request.querystring("busqueda[0][fren_ncorr]")

set botonera = new CFormulario
botonera.carga_parametros "fondos_rendir.xml", "botonera"


set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar


v_usuario=negocio.ObtenerUsuario()

	if  v_fren_ncorr<>"" then
	
		sql_reembolso	= " select protic.trunc(fren_fpago) as fren_fpago,protic.trunc(fren_factividad) as fren_factividad,* "&_
						  " from ocag_fondos_a_rendir a, personas c "&_
						  "	where a.pers_ncorr=c.pers_ncorr and a.fren_ncorr="&v_fren_ncorr
		
		sql_detalle		= "select b.* from ocag_fondos_a_rendir a, ocag_detalle_solicitud_giro b "&_
						 "	where a.fren_ncorr=b.fren_ncorr "&_
						 "	and a.fren_ncorr="&v_fren_ncorr
	else
		sql_reembolso	=	"select ''"
		sql_detalle		=	"select ''"
	end if


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "fondos_rendir.xml", "datos_proveedor"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar sql_reembolso
 f_busqueda.Siguiente


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "fondos_rendir.xml", "codigo_presupuesto"
f_cod_pre.inicializar conectar
f_cod_pre.consultar "select '' as cod_pre "
sql_codigo_pre= " (select a.cod_pre, a.cod_tdesc +' ('+a.cod_pre+')' as valor from ocag_codigos_presupuesto a ,ocag_permisos_presupuestos b "&_
				"	where a.cod_pre=b.cod_pre "&_
				"	and pers_nrut="&v_usuario&" ) as tabla"
		
'sql_codigo_pre="(select  distinct cod_pre, cod_tdesc as valor from ocag_codigos_presupuesto )as a"
f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.siguiente

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

function CopiaNombre(){
	var formulario = document.forms["datos"];
	formulario.pers_nrut.value=formulario.elements["datos[0][pers_nrut]"].value;
	formulario.pers_xdv.value=formulario.elements["datos[0][pers_xdv]"].value;
	formulario.funcionario.value=formulario.elements["datos[0][pers_tnombre]"].value;
}

function Enviar(){
	//validar campos vacios
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Fondos a Rendir</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
					  
					  <form name="datos" method="post">
					  <%f_busqueda.dibujaCampo("fren_ncorr")%>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
					
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut funcionario </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
                          -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="14%">Fecha actividad</td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("fren_factividad")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre funcionario </td>
                        <td><%f_busqueda.dibujaCampo("pers_tnombre")%></td>
                        <td> codigo presupuesto </td>
                        <td width="48%"><%f_cod_pre.dibujaCampo("cod_pre")%></td>
                      </tr>
                      <tr> 
                        <td>Monto girar </td>
                        <td><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
                        <td>Mes </td>
                        <td><%f_busqueda.dibujaCampo("mes_ccod")%></td>
                      </tr>
                      <tr> 
                        <td>Fecha. Pago </td>
                        <td><%f_busqueda.dibujaCampo("fren_fpago")%></td>
                        <td>A&ntilde;o</td>
                        <td><%f_busqueda.dibujaCampo("anos_ccod")%></td>
                      </tr>
                      <tr>
                        <td>Descripcion actividad </td>
                        <td colspan="3"><%f_busqueda.dibujaTextArea("fren_tdescripcion_actividad")%></td>
                      </tr>
                    </table>
					
                      <table width="100%" border="0">
                        <tr> 
                          <td><hr/></td>
                        </tr>
						<tr>
							<td>
							<table border ="1" align="center" width="100%">
								<tr valign="top">
								<td>Yo: <input type="text" name="funcionario" size="30" value="<%=f_busqueda.obtenerValor("pers_tnombre")%>" readonly="yes">
								   Rut:
								   <input type="text" name="pers_nrut"  size="10" value="<%=f_busqueda.obtenerValor("pers_nrut")%>" readonly="yes">
								   -
								   <input type="text" name="pers_xdv" size="2" value="<%=f_busqueda.obtenerValor("pers_xdv")%>" readonly="yes">
								<br>
								<p>Autorizo que, en caso de NO rendir 30 dias despues de la fecha de la actividad (evento),<br>
								la Universidad del Pacifico descuente el monto autorizado, de mi remuneracion mensual o<br> 
								de mi indemnizacion por años de servicios que tenga derecho, desahucio y/u otros emolumentos legales.</p>
								<br>
								<br>
								<center><p>____________________</p></center>
								<center><p>Firma trabajador</p></center>								</td>
								</tr>
							  </table>
								
							</td>
						</tr>
						<tr>
						<td>
						</td>
						</tr>
                      </table>
                      </td>
                  </tr>
                </table>
				</form>
				
				<table>
					<tr valign="top">
					<td> 
						<form name="visto_bueno" method="post">
						V°B° Responsable <select name="visto_bueno">
								  <option>-Seleccione Opcion-</option>
								  <option>Jefe Directo</option>
								  <option>Control Presupuesto</option>
								  <option>Direccion Finanzas</option>
								  <option>Vicerrectoria Finanzas</option>
								</select>
							<input type="submit" name="grabar" value="Grabar"/>	
						</form>															  
						</td>
					</tr>
				</table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"> <%botonera.dibujaboton "salir"%> </td>
					  <td><%botonera.dibujaboton "guardar"%></td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
