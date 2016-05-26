<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Reporte Compromisos Pagados"

v_fecha_inicio 		= request.querystring("busqueda[0][ingr_fpago]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_tdet_ccod	 		= request.querystring("busqueda[0][tdet_ccod]")
v_pers_nrut	 		= request.querystring("busqueda[0][pers_nrut]")
v_pers_xdv	 		= request.querystring("busqueda[0][pers_xdv]")



set botonera = new CFormulario
botonera.carga_parametros "reporte_compromisos_pagados.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reporte_compromisos_pagados.xml", "busqueda_compromisos"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


 f_busqueda.AgregaCampoCons "ingr_fpago", v_fecha_inicio
 f_busqueda.AgregaCampoCons "fecha_termino", v_fecha_termino
 f_busqueda.AgregaCampoCons "tdet_ccod", v_tdet_ccod
 f_busqueda.AgregaCampoCons "pers_nrut", v_pers_nrut
 f_busqueda.AgregaCampoCons "pers_xdv", v_pers_xdv

formulario.carga_parametros "reporte_compromisos_pagados.xml", "datos_compromisos"
formulario.inicializar conectar
negocio.inicializa conectar



if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + "and  protic.trunc(g.ingr_fpago) >= convert(datetime,'"&v_fecha_inicio&"',103)  "& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,g.ingr_fpago,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,g.ingr_fpago,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if

if v_pers_nrut <> "" then
	sql_adicional= sql_adicional + " and e.pers_nrut="&v_pers_nrut& vbCrLf 
end if

if v_tdet_ccod <> "" then
	if v_tdet_ccod="1231" then
		sql_adicional= sql_adicional + " and c.tdet_ccod in (1231,1260,1259) "& vbCrLf
	else 
		sql_adicional= sql_adicional + " and c.tdet_ccod ="&v_tdet_ccod& vbCrLf 
	end if
end if


'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
	sql_datos= 	" select protic.obtener_nombre_carrera((select top 1 ofer_ncorr from alumnos where pers_ncorr=b.pers_ncorr order by matr_ncorr desc),'CJ') as carrera, "& vbCrLf &_
				" d.tdet_tdesc as item,cast(sum(f.abon_mabono) as numeric) as monto,protic.trunc(max(g.ingr_fpago)) as fecha_pago, "& vbCrLf &_
			   	" b.pers_ncorr,protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno "& vbCrLf &_
			   	" from compromisos a "& vbCrLf &_
				" 	join detalle_compromisos b     "& vbCrLf &_
				" 		on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_     
				" 		and a.inst_ccod = b.inst_ccod  "& vbCrLf &_      
				" 		and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_ 
				" 	 join detalles c "& vbCrLf &_
				" 		on c.tcom_ccod = b.tcom_ccod  "& vbCrLf &_      
				" 		and c.inst_ccod = b.inst_ccod "& vbCrLf &_       
				" 		and c.comp_ndocto = b.comp_ndocto "& vbCrLf &_
				" 	 join tipos_detalle d "& vbCrLf &_
				" 		on c.tdet_ccod=d.tdet_ccod "& vbCrLf &_
				" 	 join personas e "& vbCrLf &_
				" 		on b.pers_ncorr=e.pers_ncorr "& vbCrLf &_
				" 	 join abonos f "& vbCrLf &_
				" 		on b.tcom_ccod = f.tcom_ccod "& vbCrLf &_       
				" 		and b.inst_ccod = f.inst_ccod "& vbCrLf &_       
				" 		and b.comp_ndocto = f.comp_ndocto "& vbCrLf &_
				" 		and b.dcom_ncompromiso = f.dcom_ncompromiso "& vbCrLf &_
				" 	 join ingresos g "& vbCrLf &_
				" 		on f.ingr_ncorr=g.ingr_ncorr "& vbCrLf &_
				" 		and g.eing_ccod not in (3,6) --no trae los nulos "& vbCrLf &_
				" 		and g.ting_ccod in (16,34) -- trae solo los ingresados por caja "& vbCrLf &_
				" 	 join movimientos_cajas h "& vbCrLf &_
				" 		on g.mcaj_ncorr=h.mcaj_ncorr "& vbCrLf &_
				" where a.ecom_ccod = '1' "& vbCrLf &_ 
				"	"&sql_adicional&" --filtro "& vbCrLf &_ 
				" group by b.pers_ncorr,d.tdet_tdesc,g.ingr_nfolio_referencia "& vbCrLf &_
				" order by fecha_pago asc " 
 
else
	sql_datos="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&sql_datos&"</pre>")
'response.End()				 


formulario.consultar sql_datos


%>


<html>
<head>
<title>Reporte Compromisos Pagados</title>
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
			<table cellspacing="0"  cellpadding="0" >
			<form name="buscador">
				<tr>
					<td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
					<td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
					<td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              	</tr>
				<tr>
					<td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
								<td width="209" valign="middle" background="../imagenes/fondo1.gif"><div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Filtro de busqueda</font></div></td>
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
				<tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
				  <td bgcolor="#D8D8DE">				  <table width="100%">
                    <tr>
                      <td width="17%"><strong> Compromiso </strong></td>
                      <td width="2%"><strong>:</strong></td>
                      <td colspan="4">
                        <%f_busqueda.dibujaCampo("tdet_ccod")%></td>
                      <td width="23%" rowspan="4"><%botonera.DibujaBoton "buscar_eventos"%></td>
                    </tr>
                    <tr>
                      <td><strong>Rut</strong></td>
                      <td><strong>:</strong></td>
					  <td width="24%"><%f_busqueda.dibujaCampo("pers_nrut")%>
					    -
				        <%f_busqueda.dibujaCampo("pers_xdv")%></td>
                      <td width="13%">&nbsp;</td>
					  <td width="3%">&nbsp;</td>
                      <td width="18%">&nbsp;</td>
                    </tr>
                    <tr>
                      <td><strong>  Desde </strong></td>
                      <td><strong>:</strong></td>
                      <td>
                        <%f_busqueda.dibujaCampo("ingr_fpago")%>
  (dd/mm/aaaa)</td>
                      <td><strong> Hasta</strong></td>
                      <td><strong>:</strong></td>
                      <td><%f_busqueda.dibujaCampo("fecha_termino")%>
(dd/mm/aaaa) </td>
                    </tr>
                  </table></td>
				  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
				<tr>
                	<td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                  	<td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                	<td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              	</tr> 
			  </form>
			</table>

			</td>
		</tr>
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">R</font><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">eporte
                          de alumnos por eventos </font></div></td>
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
                      </font>
                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
                      <table width="100%" border="0">
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td align="right"><strong><font color="000000" size="1"> 
                            <% formulario.pagina%></font></strong>
                            &nbsp;&nbsp;&nbsp;&nbsp; 
                            <% formulario.accesoPagina%>
                            </td>
                        </tr>
                        <tr> 
                          <td align="center"><strong><font color="000000" size="1"> 
                            <% formulario.dibujaTabla%>
                            </font></strong></td>
                        </tr>
                        <tr>
                              <td align="right">&nbsp; </td>
                        </tr>
                      </table>
                      <strong><font color="000000" size="1"> </font></strong></td>
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
				  <table width="100%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"> <%botonera.dibujaboton "salir"%> </td>
					  <td><%botonera.dibujaboton "excel"%></td>
                    </tr>
                  </table>                    
                </td>
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
