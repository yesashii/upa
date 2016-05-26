<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Solicitud de giro"

v_fecha_inicio 		= request.querystring("busqueda[0][mcaj_finicio]")
v_estado_caja	 	= request.querystring("busqueda[0][eren_ccod]")
v_cajero 			= request.querystring("busqueda[0][caje_ccod]")
v_sede 				= request.querystring("busqueda[0][sede_ccod]")
v_tipo_caja			= request.querystring("busqueda[0][tcaj_ccod]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_num_caja			= request.querystring("busqueda[0][mcaj_ncorr]")
v_ingr_nfolio		= request.querystring("busqueda[0][ingr_nfolio]")
v_fecha_traspaso	= request.querystring("busqueda[0][fecha_traspaso]")  
 


set botonera = new CFormulario
botonera.carga_parametros "historico_cajas.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "historico_cajas.xml", "busqueda_cajas"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


 f_busqueda.AgregaCampoCons "sede_ccod", v_sede
 f_busqueda.AgregaCampoCons "mcaj_finicio", v_fecha_inicio
 f_busqueda.AgregaCampoCons "eren_ccod", v_estado_caja
 f_busqueda.AgregaCampoCons "caje_ccod", v_cajero
 f_busqueda.AgregaCampoCons "tcaj_ccod", v_tipo_caja
 f_busqueda.AgregaCampoCons "fecha_termino", v_fecha_termino
 f_busqueda.AgregaCampoCons "mcaj_ncorr", v_num_caja
 f_busqueda.AgregaCampoCons "ingr_nfolio", v_ingr_nfolio
 f_busqueda.AgregaCampoCons "fecha_traspaso", v_fecha_traspaso


w_mcaj=conectar.consultauno("select pers_ncorr from personas where pers_nrut=15964262")
formulario.carga_parametros "historico_cajas.xml", "cierre_de_cajas"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

'response.Write(w_mcaj)
'response.Write("v_fecha_termino :"&v_fecha_termino)

if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  protic.trunc(a.mcaj_finicio)='"&v_fecha_inicio&"' "& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,a.mcaj_finicio,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,a.mcaj_finicio,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if

if v_estado_caja <> "" then
	sql_adicional= sql_adicional + " and a.eren_ccod ="&v_estado_caja& vbCrLf 
end if

if v_sede <> "" then
	sql_adicional= sql_adicional + " and a.sede_ccod ="&v_sede& vbCrLf 
end if

if v_tipo_caja <> "" then
	sql_adicional= sql_adicional + " and a.tcaj_ccod ="&v_tipo_caja& vbCrLf 
end if

if v_num_caja <> "" then
	sql_adicional= sql_adicional + " and a.mcaj_ncorr ="&v_num_caja& vbCrLf 
end if

if v_ingr_nfolio <> "" and v_num_caja="" then
	v_caja_asociada=conectar.ConsultaUno("Select top 1 mcaj_ncorr from ingresos where ingr_nfolio_referencia="&v_ingr_nfolio)
	if v_caja_asociada <> "" then
		sql_adicional= sql_adicional + " and a.mcaj_ncorr ="&v_caja_asociada& vbCrLf 
	Else
		sql_adicional= sql_adicional + " and a.mcaj_ncorr =0"& vbCrLf 
	end if
end if

if v_cajero <> "" then
	sql_adicional= sql_adicional + " and a.caje_ccod  in (select caje_ccod from cajeros where pers_ncorr ="&v_cajero&")"& vbCrLf 
end if		

if v_fecha_traspaso <> "" then
	sql_adicional= sql_adicional + " and a.mcaj_ncorr  in (select distinct mcaj_ncorr "& vbCrLf &_
    												"	from traspasos_cajas_softland "& vbCrLf &_
    												"	where protic.trunc(audi_fmodificacion) = convert(datetime,'"&v_fecha_traspaso&"',103))"& vbCrLf 
end if		
		
'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
	cajas_abiertas_cons = "select a.*,(select case when count(*)>0 then 'SI' else 'NO' end from ingresos where mcaj_ncorr=a.mcaj_ncorr and eing_ccod not in (3,6)) as movimientos, "& vbCrLf &_
						" (select case when count(*)>0 then 'SI' else 'NO' end from ingresos where mcaj_ncorr=a.mcaj_ncorr and eing_ccod not in (3,6) and ting_ccod not in(8)) as no_conciliacion "& vbCrLf &_
						" from ( " & vbCrLf &_
						" select mcaj_ncorr,mcaj_ncorr as mcaj_ncorr_paso,mcaj_finicio,mcaj_ftermino,mcaj_mrendicion " & vbCrLf &_
						"        , pers_tnombre + ' ' + pers_tape_paterno as nombre " & vbCrLf &_
						"        , a.ecua_ccod, a.eren_ccod, d.tcaj_tdesc , a.sede_ccod," & vbCrLf &_
						"(select sum(cast(isnull(b.mcaj_mtotal, 0) as numeric)) as total"& vbCrLf &_
						"from"& vbCrLf &_
						"(select e.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc "& vbCrLf &_
      					"from movimientos_cajas e,"& vbCrLf &_
						"(select e.inst_ccod, e.tdoc_ccod, b.tdoc_tdesc"& vbCrLf &_
						"from documentos_instituciones e, tipos_documentos_mov_cajas b"& vbCrLf &_
 						"where e.tdoc_ccod = b.tdoc_ccod"& vbCrLf &_
 						"and cast(e.inst_ccod as varchar)= '1') b "& vbCrLf &_
						"where cast(e.mcaj_ncorr as varchar)= cast(a.mcaj_ncorr as varchar)) d, detalle_mov_cajas b" & vbCrLf &_
						"where d.mcaj_ncorr *= b.mcaj_ncorr"& vbCrLf &_
  						"and d.inst_ccod *= b.inst_ccod"& vbCrLf &_
 						" and d.tdoc_ccod *= b.tdoc_ccod"& vbCrLf &_
						"group by d.mcaj_ncorr)as total"& vbCrLf &_
						" from movimientos_cajas a,cajeros b,personas c,tipos_caja d" & vbCrLf &_
						" where a.caje_ccod = b.caje_ccod" & vbCrLf &_
						"    and a.sede_ccod = b.sede_ccod" & vbCrLf &_
						"    and b.pers_ncorr = c.pers_ncorr" & vbCrLf &_
						"    and a.tcaj_ccod = d.tcaj_ccod" & vbCrLf &_
						"    and a.tcaj_ccod not in (1002,1005) " & vbCrLf &_
						"    "&sql_adicional&" " & vbCrLf &_
						"    ) a "& vbCrLf &_
						"  order by a.mcaj_ncorr desc "
else
	cajas_abiertas_cons="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&cajas_abiertas_cons&"</pre>")
'response.End()				 

'"    and a.eren_ccod not in (3,4,5)" & vbCrLf &_

formulario.consultar cajas_abiertas_cons

formulario.agregaCampoParam "ecua_ccod","permiso", "lectura"
formulario.agregaCampoParam "eren_ccod","permiso", "lectura"

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
                    <td><strong><font color="000000" size="1"> </font></strong>
					
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut proveedor </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
                          -<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td width="14%">tipo moneda </td>
                        <td colspan="3"><select name="moneda">
                            <option> tipo 1</option>
                            <option> tipo 2</option>
                          </select></td>
                      </tr>
                      <tr> 
                        <td> nombre proveedor </td>
                        <td> <%f_busqueda.dibujaCampo("caje_ccod")%> </td>
                        <td> fecha docto </td>
                        <td width="48%"> <%f_busqueda.dibujaCampo("sede_ccod")%></td>
                      </tr>
                      <tr> 
                        <td>monto girar </td>
                        <td> <%f_busqueda.dibujaCampo("tcaj_ccod")%></td>
                        <td>tipo documento </td>
                        <td> <%f_busqueda.dibujaCampo("eren_ccod")%> </td>
                      </tr>
                      <tr> 
                        <td>Cond. Pago </td>
                        <td><%f_busqueda.dibujaCampo("mcaj_ncorr")%></td>
                        <td>numero docto </td>
                        <td><%f_busqueda.dibujaCampo("ingr_nfolio")%></td>
                      </tr>
                      <tr>
                        <td>mes</td>
                        <td><%f_busqueda.dibujaCampo("fecha_traspaso")%></td>
                        <td>monto docto </td>
                        <td><%f_busqueda.dibujaCampo("ingr_nfolio")%></td>
                      </tr>
                      <tr>
                        <td>a&ntilde;o</td>
                        <td><%f_busqueda.dibujaCampo("ingr_nfolio")%></td>
                        <td>codigo presupuesto </td>
                        <td><%f_busqueda.dibujaCampo("ingr_nfolio")%></td>
                      </tr>
                      <tr>
                        <td>tipo gasto </td>
                        <td><%f_busqueda.dibujaCampo("ingr_nfolio")%></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
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
								<td width="46%"><textarea cols="60" rows="10"></textarea> </td>
								<td width="54%" >
								    <table class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
									  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
									  		<th></th>
									    	<th>Tipo Docto </th>
										  	<th>N&deg; Docto </th>
										  	<th>Tipo Moneda </th>
										  	<th>Valor Original </th>
										  	<th>Valor Pesos </th>
										</tr>
										<tr bgcolor='#FFFFFF'>
											<td><input type="checkbox" value="" name="seleccionar"/></td>
										  <td><select name="tipo_docto">
											  <option> tipo 1</option>
											  <option> tipo 2</option>
											</select>                                      </td>
										  <td><input type="text" name="num_docto" value="" size="10"/></td>
										  <td><select name="tipo_moneda">
											  <option> tipo 1</option>
											  <option> tipo 2</option>
											</select>										  </td>
										  <td><input type="text" name="valor_original" value="" size="10"/></td>
										  <td><input type="text" name="valor_pesos" value="" size="10"/></td>
										</tr>
								    </table>								  </td>
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
								  <td >&nbsp;</td>
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
					  <td><%botonera.dibujaboton "excel"%></td>
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
