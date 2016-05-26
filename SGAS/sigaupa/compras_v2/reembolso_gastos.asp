<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Reembolso Gastos"


set botonera = new CFormulario
botonera.carga_parametros "reembolso_gasto.xml", "botonera"

v_sogi_ncorr	= request.querystring("busqueda[0][sogi_ncorr]")

set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

	if  v_sogi_ncorr<>"" then
	
		sql_reembolso	= "select * from ocag_solicitud_giro a, personas c "&_
						 "	where a.pers_ncorr_proveedor=c.pers_ncorr and a.sogi_ncorr="&v_sogi_ncorr
		
		sql_detalle		= "select b.* from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
						 "	where a.sogi_ncorr=b.sogi_ncorr "&_
						 "	and a.sogi_ncorr="&v_sogi_ncorr
	else
		sql_reembolso	=	"select ''"
		sql_detalle		=	"select ''"
	end if


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reembolso_gasto.xml", "datos_proveedor"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar sql_reembolso
 f_busqueda.Siguiente


area_ccod=1 

set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "pago_proveedor.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' as cod_pre "
sql_codigo_pre="(select  distinct top 10 cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"'))as a"
f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.siguiente


set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select * from ocag_tipo_gasto"
f_tipo_gasto.consultar sql_tipo_gasto

set f_tipo_docto = new CFormulario
f_tipo_docto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_docto.inicializar conectar
sql_tipo_docto= "Select * from ocag_tipo_documento"
f_tipo_docto.consultar sql_tipo_docto

%>
<html>
<head>
<title>Reembolso de Gastos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Enviar(){
	//validar campos vacios
	return true;
}

function CalculaTotal()
{
	//alert("aaaaaa");
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	for (var i = 0; i <= 3; i++) {
	//alert("eeeeeeeeee");
		v_monto		=	formulario.elements["detalle["+i+"][drga_mdocto]"].value;
		v_retencion	=	formulario.elements["detalle["+i+"][drga_mretencion]"].value;
		if (!v_monto){
			v_monto=0;
			formulario.elements["detalle["+i+"][drga_mdocto]"].value=0;
		}
		if (!v_retencion){
			v_retencion=0;
			formulario.elements["detalle["+i+"][drga_mretencion]"].value=0;
		}
		v_neto		=	eval(v_monto-v_retencion);
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
		if (v_neto){
			v_total_solicitud = v_total_solicitud + parseInt(v_neto);
		}
	}
	
	formulario.total.value	=	eval(v_total_solicitud);
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Reembolso de Gastos </font></div></td>
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
				
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
					<form name="datos" method="post">
					<%f_busqueda.dibujaCampo("sogi_ncorr")%>					
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut funcionario </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
                          -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="14%">Tipo moneda </td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre funcionario </td>
                        <td> <%f_busqueda.dibujaCampo("pers_tnombre")%> </td>
                        <td> Codigo presupuesto </td>
                        <td width="48%"> 
                          <%f_cod_pre.dibujaCampo("cod_pre")%></td>
                      </tr>
                      <tr> 
                        <td>Monto girar </td>
                        <td> <%f_busqueda.dibujaCampo("sogi_mgiro")%></td>
                        <td>Mes</td>
                        <td><%f_busqueda.dibujaCampo("mes_ccod")%></td>
                      </tr>
                      <tr> 
                        <td>Fecha Pago </td>
                        <td><%f_busqueda.dibujaCampo("sogi_fecha_solicitud")%></td>
                        <td>A&ntilde;o</td>
                        <td><%f_busqueda.dibujaCampo("anos_ccod")%></td>
                      </tr>
                    </table>
					<br/>
                      <table width="100%" border="0">
                        <tr> 
                          <td><hr/></td>
                        </tr>
						<tr>
							<td>
							<table border ="1" align="center" width="100%">
								<tr valign="top">
								<td width="100%" >
								    <table class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
									  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
									  		<th width="20"></th>
											<th width="74">Fecha Docto </th>
									    	<th width="66">N&deg; Docto</th>
										  	<th width="54">Tipo Docto </th>
										  	<th width="66">Tipo Gasto </th>
										  	<th width="169">Descripcion gasto  </th>
										  	<th width="77">Retencion</th>
											<th width="95">Monto</th>
									  </tr>
										<tr bgcolor='#FFFFFF'>
										  <td><input type="checkbox" value="" name="seleccionar"/></td>
										  <td><input type="text" name="detalle[0][drga_fdocto]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[0][drga_ndocto]" value="" size="10"/></td>
										  <td><select name="detalle[0][tdoc_ccod]">
                                            <%f_tipo_docto.primero%>
                                            <%while f_tipo_docto.Siguiente %>
                                            <option value="<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>
                                            <%wend%>
                                          </select></td>
										  <td><select name="detalle[0][tgas_ccod]">
												<%f_tipo_gasto.primero%>
												<%while f_tipo_gasto.Siguiente %>
													<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
												<%wend%>
												</select>										  </td>
										  <td><input type="text" name="detalle[0][drga_tdescripcion]" value="" size="40"/></td>
										  <td><input type="text" name="detalle[0][drga_mretencion]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[0][drga_mdocto]" value="" size="10" onBlur="CalculaTotal()"/></td>
										</tr>
										<tr bgcolor='#FFFFFF'>
										  <td><input type="checkbox" value="" name="seleccionar"/></td>
										  <td><input type="text" name="detalle[1][drga_fdocto]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[1][drga_ndocto]" value="" size="10"/></td>
										  <td><select name="detalle[1][tdoc_ccod]">
                                            <%f_tipo_docto.primero%>
                                            <%while f_tipo_docto.Siguiente %>
                                            <option value="<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>
                                            <%wend%>
                                          </select></td>
										  <td><select name="detalle[1][tgas_ccod]">
												<%f_tipo_gasto.primero%>
												<%while f_tipo_gasto.Siguiente %>
													<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
												<%wend%>
												</select>											  </td>
										  <td><input type="text" name="detalle[1][drga_tdescripcion]" value="" size="40"/></td>
										  <td><input type="text" name="detalle[1][drga_mretencion]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[1][drga_mdocto]" value="" size="10" onBlur="CalculaTotal()"/></td>
										</tr>
										<tr bgcolor='#FFFFFF'>
										  <td><input type="checkbox" value="" name="seleccionar"/></td>
										  <td><input type="text" name="detalle[2][drga_fdocto]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[2][drga_ndocto]" value="" size="10"/></td>
										  <td><select name="detalle[2][tdoc_ccod]">
                                            <%f_tipo_docto.primero%>
                                            <%while f_tipo_docto.Siguiente %>
                                            <option value="<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>
                                            <%wend%>
                                          </select></td>
										  <td><select name="detalle[2][tgas_ccod]">
												<%f_tipo_gasto.primero%>
												<%while f_tipo_gasto.Siguiente %>
													<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
												<%wend%>
												</select>											  </td>
										  <td><input type="text" name="detalle[2][drga_tdescripcion]" value="" size="40"/></td>
										  <td><input type="text" name="detalle[2][drga_mretencion]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[2][drga_mdocto]" value="" size="10" onBlur="CalculaTotal()"/></td>
										</tr>
										<tr bgcolor='#FFFFFF'>
										  <td><input type="checkbox" value="" name="seleccionar"/></td>
										  <td><input type="text" name="detalle[3][drga_fdocto]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[3][drga_ndocto]" value="" size="10"/></td>
										  <td><select name="detalle[3][tdoc_ccod]">
                                            <%f_tipo_docto.primero%>
                                            <%while f_tipo_docto.Siguiente %>
                                            <option value="<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>
                                            <%wend%>
                                          </select></td>
										  <td><select name="detalle[3][tgas_ccod]">
												<%f_tipo_gasto.primero%>
												<%while f_tipo_gasto.Siguiente %>
													<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
												<%wend%>
												</select>											  </td>
										  <td><input type="text" name="detalle[3][drga_tdescripcion]" value="" size="40"/></td>
										  <td><input type="text" name="detalle[3][drga_mretencion]" value="" size="10"/></td>
										  <td><input type="text" name="detalle[3][drga_mdocto]" value="" size="10" onBlur="CalculaTotal()"/></td>
										</tr>
										<tr>
										<td colspan="7" align="right"><strong>Total a Girar</strong></td>
										<td ><input type="text" name="total" value="" size="15" readonly="yes"/></td>
										</tr>																														
								    </table>								  
								  </td>
								</tr>
								<tr valign="top">
								  <td> V°B° Responsable <select name="visto_bueno">
											  <option>-Seleccione Opcion-</option>
											  <option>Jefe Directo</option>
											  <option>Control Presupuesto</option>
											  <option>Direccion Finanzas</option>
											  <option>Vicerrectoria Finanzas</option>
											</select>
											<input type="submit" name="grabar" value="Grabar"/>
								  </td>
							    </tr>
							  </table>
								
							</td>
						</tr>
						<tr>
						<td>
						</td>
						</tr>
                      </table>
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
                  <td width="240" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"><%botonera.dibujaboton "guardar"%></td>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="429" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="10" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
