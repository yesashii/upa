<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Solicitud de giro"

v_ordc_ndocto	= request.querystring("busqueda[0][ordc_ndocto]")
v_sogi_ncorr	= request.querystring("busqueda[0][sogi_ncorr]")

 
set botonera = new CFormulario
botonera.carga_parametros "pago_proveedor.xml", "botonera"


set negocio 	= new Cnegocio
set conectar 	= new Cconexion
set formulario 	= new Cformulario

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

conectar.inicializar "upacifico"

negocio.inicializa conectar
sede=negocio.obtenerSede


 set f_buscador = new CFormulario
 f_buscador.Carga_Parametros "pago_proveedor.xml", "buscador"
 f_buscador.Inicializar conectar
 f_buscador.Consultar " select '' "
 f_buscador.Siguiente
 f_buscador.AgregaCampoCons "ordc_ndocto", v_ordc_ndocto
 f_buscador.AgregaCampoCons "sogi_ncorr", v_sogi_ncorr


'******************************************************
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
 f_busqueda.Inicializar conectar

 if v_ordc_ndocto <>"" and v_sogi_ncorr<>"" then

		sql_datos_orden= " Select top 1 protic.trunc(fecha_solicitud) as sogi_fecha_solicitud,pers_nrut,pers_xdv,* "&_
						 " from ocag_orden_compra a, personas b where a.pers_ncorr=b.pers_ncorr and a.ordc_ndocto="&v_ordc_ndocto

 else
 	 if v_sogi_ncorr<>"" then 
		sql_datos_orden= "select * from ocag_solicitud_giro a, personas c "&_
						 "	where a.pers_ncorr_proveedor=c.pers_ncorr and a.sogi_ncorr="&v_sogi_ncorr

		sql_detalle= "select b.* from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
					 "	where a.sogi_ncorr=b.sogi_ncorr "&_
					 "	and a.sogi_ncorr="&v_sogi_ncorr
					 						 
	elseif v_ordc_ndocto <>"" then
		sql_datos_orden= " Select top 1 protic.trunc(fecha_solicitud) as sogi_fecha_solicitud,pers_nrut,pers_xdv,* "&_
						 " from ocag_orden_compra a, personas b where a.pers_ncorr=b.pers_ncorr and a.ordc_ndocto="&v_ordc_ndocto
	else
 		sql_datos_orden= "select ''"
	end if
 end if

 f_busqueda.Consultar sql_datos_orden
 f_busqueda.Siguiente


area_ccod=1 

set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "pago_proveedor.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion

f_cod_pre.consultar "select '' as cod_pre "

sql_codigo_pre="(select  distinct top 10 cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"'))as a"

f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.siguiente


set f_detalle = new CFormulario
f_detalle.carga_parametros "pago_proveedor.xml", "detalle_giro"
f_detalle.inicializar conectar

if sql_detalle="" then
	sql_detalle="select ''"
end if

f_detalle.Consultar sql_detalle
f_detalle.Siguiente


	
%>


<html>
<head>
<title>Solicitud de Giro</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function AgregarDetalle(formu){
	document.datos.action="pago_proveedor_detalle_proc.asp";
	document.datos.method="post";
	document.datos.submit();
}

function EliminaDetalle(){
	document.detalle_doctos.action="pago_proveedor_detalle_elimina_proc.asp";
	document.detalle_doctos.method="post";
	document.detalle_doctos.submit();
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Orden de compra </font></div></td>
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
                    <td><hr>
					<form name="buscador"> 
					<table width="80%">
					<tr>
						<td>Extrae datos desde Orden de Compra:</td>
						<td><%f_buscador.dibujaCampo("ordc_ndocto")%></td>
						<td rowspan="2"><%botonera.DibujaBoton "buscar" %></td>
					</tr>
					<tr>
						<td>Datos por solicitud:</td>
						<td><%f_buscador.dibujaCampo("sogi_ncorr")%></td>
					</tr>
					</table>
					  </form>
					  <form name="datos" action="pago_proveedor_proc.asp" method="post">
					  <%f_busqueda.dibujaCampo("sogi_ncorr")%>
					<table width="100%" border="1" height="100%">
                      <tr> 
                        <td width="11%">Rut proveedor </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
					    <td> Fecha docto </td>
                        <td width="48%"><%f_busqueda.dibujaCampo("sogi_fecha_solicitud")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre proveedor </td>
                        <td> <%f_busqueda.dibujaCampo("pers_tnombre")%></td>
						<td width="14%">Codigo presupuesto</td>
                        <td ><%f_cod_pre.dibujaCampo("cod_pre")%></td>
                      </tr>
					  <tr>
					    <td>Monto girar </td>
					    <td><%f_busqueda.dibujaCampo("sogi_mgiro")%></td>
					      <td colspan="2" rowspan="4" bordercolor="#000000">
						  <table width="100%">
						  <tr>
							<td width="22%"><strong>Tipo moneda</strong></td>
                        	<td width="78%"><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
						  </tr>
						  <tr>
						     <td><strong>Tipo documento</strong></td>
                        	 <td><%f_busqueda.dibujaCampo("tdoc_ccod")%></td>
							</tr>
						  <tr>
						     <td><strong>Numero docto</strong></td>
                        	 <td><%f_busqueda.dibujaCampo("dsgi_ndocto")%></td>
							</tr>
						  <tr>
						     <td><strong>Monto docto</strong></td>
                        	 <td><%f_busqueda.dibujaCampo("dsgi_mdocto")%></td>
							</tr>															
						  </table>						  </td>
					  </tr>
                      <tr>
                        <td>Cond. Pago </td>
                        <td><%f_busqueda.dibujaCampo("cpag_ccod")%></td> 
                        </tr>
                      <tr>
                        <td>Mes</td>
                        <td><%f_busqueda.dibujaCampo("mes_ccod")%></td> 
                      </tr>
                      <tr>
                        <td>A&ntilde;o</td>
                        <td><%f_busqueda.dibujaCampo("anos_ccod")%></td>
                      </tr>
                      <tr>
                        <td>Tipo gasto </td>
                        <td><%f_busqueda.dibujaCampo("tgas_ccod")%></td>
                        <td colspan="2" align="center"><input type="button" onClick="AgregarDetalle(this.form)" name="agrega_pago" value="Agregar pago"></td>
                        </tr>
                      <tr>
                        <td colspan="4"><%f_busqueda.dibujatextarea("sogi_tobservaciones")%></td>
                      </tr>
                    </table>
					</form>
                      <table width="100%" border="0">
						<tr>
							<td valign="top">
							<table border ="1" align="center" width="100%">
								<tr valign="top">
								<td width="54%"  >
								
								<form name="detalle_doctos" method="post">
									<table class="v1" align="center" width="90%" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
										<tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th></th>
											<th>Tipo Docto </th>
											<th>N&deg; Docto </th>
											<th>Tipo Moneda </th>
											<th>Valor Original </th>
											<th>Valor Pesos </th>
										</tr>
										<%
										indice=0
										while f_detalle.Siguiente 
										
										%>
										<tr bgcolor='#FFFFFF'>
											<td><%f_detalle.DibujaCampo("sogi_ncorr")%>
											<input type="checkbox" value="<%=f_detalle.ObtenerValor("dsgi_ncorr")%>" name="datos[<%=indice%>][dsgi_ncorr]"/></td>
											<td><%=f_detalle.dibujacampo("tdoc_ccod")%></td>
											<td><%=f_detalle.dibujacampo("dsgi_ndocto")%></td>
											<td><%=f_detalle.dibujacampo("tmon_ccod")%></td>
											<td><%=f_detalle.dibujacampo("dsgi_mdocto")%></td>
											<td><%=f_detalle.dibujacampo("dsgi_mdocto")%></td>
										</tr>
										<%
										indice=indice+1
										wend
										%>
									</table>
									
									<p></p>
									<%botonera.dibujaboton "eliminar"%>
									</form>								  
									</td>
								</tr>
								<tr valign="top">
								<form name="vistobueno">
								  <td> V°B° Responsable <select name="visto_bueno">
											  <option>-Seleccione Opcion-</option>
											  <option>Jefe Directo</option>
											  <option>Control Presupuesto</option>
											  <option>Direccion Finanzas</option>
											  <option>Vicerrectoria Finanzas</option>
											</select> 
								    <input type="submit" name="grabar" value="Grabar"/>
									</td>

								  </form>
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