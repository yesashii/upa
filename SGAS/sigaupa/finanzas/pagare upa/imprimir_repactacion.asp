<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_repa_ncorr = Request.QueryString("repa_ncorr")
q_leng = Request.QueryString("leng")
q_pers_nrut = Request.QueryString("pers_nrut")
'response.Write("repa_ncorr "&q_repa_ncorr)

Function SqlDocumentos(p_ting_ccod)
				   
SqlDocumentos = "select f.ting_ccod, f.ding_ndocto, f.ingr_ncorr, f.ting_ccod as c_ting_ccod," & vbCrLf &_
				"        f.ding_ndocto as c_ding_ndocto, f.ingr_ncorr as c_ingr_ncorr, f.plaz_ccod," & vbCrLf &_
				"        f.banc_ccod, f.ding_fdocto, f.ding_mdetalle, f.ding_tcuenta_corriente, a.repa_frepactacion," & vbCrLf &_
				"        isnull(isnull(b.post_ncorr, (select max(post_ncorr) from postulantes where pers_ncorr = b.pers_ncorr and ofer_ncorr is not null)), 0) as post_ncorr" & vbCrLf &_
				"    from repactaciones a,compromisos b,detalle_compromisos c,abonos d,ingresos e," & vbCrLf &_
				"        detalle_ingresos f --,contratos g " & vbCrLf &_
				"    where a.repa_ncorr = b.comp_ndocto  " & vbCrLf &_
				"        and b.tcom_ccod = c.tcom_ccod  " & vbCrLf &_
				"        and b.inst_ccod = c.inst_ccod  " & vbCrLf &_
				"        and b.comp_ndocto = c.comp_ndocto" & vbCrLf &_
				"        and c.tcom_ccod = d.tcom_ccod  " & vbCrLf &_
				"        and c.inst_ccod = d.inst_ccod  " & vbCrLf &_
				"        and c.comp_ndocto = d.comp_ndocto  " & vbCrLf &_
				"        and c.dcom_ncompromiso = d.dcom_ncompromiso" & vbCrLf &_
				"        and d.ingr_ncorr = e.ingr_ncorr" & vbCrLf &_
				"        and e.ingr_ncorr = f.ingr_ncorr" & vbCrLf &_
				"        --and protic.contrato_origen_repactacion_real(a.repa_ncorr) *= g.cont_ncorr" & vbCrLf &_
				"        and e.eing_ccod = 4  " & vbCrLf &_
				"        and b.tcom_ccod = 3  " & vbCrLf &_
				"        and b.ecom_ccod <> 3  " & vbCrLf &_
				"        and cast(f.ting_ccod as varchar)= '" & p_ting_ccod & "'  " & vbCrLf &_
				"        and cast(a.repa_ncorr as varchar)= '" & q_repa_ncorr & "'"
				
				'response.Write("<pre>"&SqlDocumentos&"</pre>")
End Function


if EsVacio(q_leng) then
	q_leng = "1"
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Imprimir documentos repactación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "imprimir_repactacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_repactacion = new CFormulario
f_repactacion.Carga_Parametros "imprimir_repactacion.xml", "datos_repactacion"
f_repactacion.Inicializar conexion

consulta = "select repa_ncorr, repa_frepactacion, repa_mrepactacion, repa_ncuotas " & vbCrLf &_
           "from repactaciones " & vbCrLf &_
		   "where cast(repa_ncorr as varchar)= '" & q_repa_ncorr & "'"
		   
f_repactacion.Consultar consulta

'---------------------------------------------------------------------------------------------------
select case q_leng
	case "1"
		str_formulario = "tabla_repactacion"
		str_boton_imprimir = "imprimir_docto"
		f_botonera.AgregaBotonUrlParam "imprimir_docto", "repa_ncorr", q_repa_ncorr

	case "2"
		str_formulario = "cheques"
		
		consulta = SqlDocumentos("3")
				   
		str_boton_imprimir = "imprimir_cheques"
		
	case "3"
		str_formulario = "letras"
		
		consulta = SqlDocumentos("4")
		
		str_boton_imprimir = "imprimir_letras"
		
		v_tcom_ccod_origen = conexion.ConsultaUno("select protic.compromiso_origen_repactacion('" & q_repa_ncorr & "', 'tcom_ccod')")	
		if v_tcom_ccod_origen = "7" then ' si el origen fue un curso, se envia tipo=2 para prevenir datos en blanco en caso de no tener un post_ncorr
			f_botonera.AgregaBotonUrlParam "imprimir_letras", "tipo_impresion", "2"
		else		
			f_botonera.AgregaBotonUrlParam "imprimir_letras", "tipo_impresion", "3"
		end if
	
	case "4"
			str_formulario = "f_detalle_pagare"
	
			 consulta=" select pag.PAGA_NCORR, protic.obtiene_monto_pagare(rp.repa_ncorr,'M') as monto_actual,  " & vbcrlf &_  
					  " protic.obtiene_monto_pagare(rp.repa_ncorr,'C') as num_cuotas,protic.trunc(pag.paga_fpagare) as fecha    " & vbcrlf &_
					  " from repactaciones rp, pagares pag, compromisos com    " & vbcrlf &_
					  " where rp.repa_ncorr = pag.cont_ncorr    " & vbcrlf &_
					  " and rp.repa_ncorr=com.comp_ndocto  " & vbcrlf &_  
					  " and com.tcom_ccod=3    " & vbcrlf &_
					  " and cast(rp.repa_ncorr as varchar)='"&q_repa_ncorr&"' " & vbcrlf &_
					  " and com.ecom_ccod <>3  " & vbcrlf &_
					  " and pag.opag_ccod=2  "

			'response.Write("<pre>"&consulta&"</pre>")	
			str_boton_imprimir = "imprimir_pagare"

			sql_post_ncorr="select max(post_ncorr) as post_ncorr from postulantes " & vbcrlf &_
						" where epos_ccod=2  " & vbcrlf &_
						" and ofer_ncorr is not null " & vbcrlf &_
						" and pers_ncorr in (select top 1 pers_ncorr from ingresos where ingr_nfolio_referencia="&q_repa_ncorr&")" 

			sql_post_ncorr="select max(post_ncorr) as post_ncorr from postulantes " & vbcrlf &_
						" where epos_ccod=2  " & vbcrlf &_
						" and ofer_ncorr is not null " & vbcrlf &_
						" and pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut="&q_pers_nrut&")" 

			
			v_post_ncorr=conexion.ConsultaUno (sql_post_ncorr)
			
			f_botonera.AgregaBotonUrlParam "imprimir_pagare", "repa_ncorr", q_repa_ncorr
			f_botonera.AgregaBotonUrlParam "imprimir_pagare", "imprimir", "S"
			f_botonera.AgregaBotonUrlParam "imprimir_pagare", "post_ncorr", v_post_ncorr
	
	case "5"
		str_formulario = "comp_ingreso"
		
		consulta = "select b.ting_ccod, b.ingr_nfolio_referencia, b.pers_ncorr, d.ting_tdesc, sum(b.ingr_mtotal) as ingr_mtotal, max(cast(b.ingr_fpago as datetime)) as ingr_fpago " & vbCrLf &_
		           "from abonos a, ingresos b, detalle_ingresos c, tipos_ingresos d " & vbCrLf &_
				   "where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
				   "  and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
				   "  and b.ting_ccod = d.ting_ccod " & vbCrLf &_
				   "  and a.tcom_ccod = 3 " & vbCrLf &_
				   "  and b.eing_ccod = 7 " & vbCrLf &_
				   "  and c.ting_ccod = 44 " & vbCrLf &_
				   "  and cast(a.comp_ndocto as varchar)= '" & q_repa_ncorr & "' " & vbCrLf &_
				   "group by b.ting_ccod, b.ingr_nfolio_referencia, b.pers_ncorr, d.ting_tdesc"
				   
        'response.Write("<pre>"&consulta&"</pre>")
		str_boton_imprimir = "imprimir_comp_ingreso"
		
		set f_consulta = new CFormulario
		f_consulta.Carga_Parametros "consulta.xml", "consulta"
		f_consulta.Inicializar conexion
		f_consulta.Consultar consulta
		f_consulta.Siguiente
		
		f_botonera.AgregaBotonUrlParam "imprimir_comp_ingreso", "nfolio", f_consulta.ObtenerValor("ingr_nfolio_referencia")
		f_botonera.AgregaBotonUrlParam "imprimir_comp_ingreso", "nro_ting_ccod", f_consulta.ObtenerValor("ting_ccod")
		f_botonera.AgregaBotonUrlParam "imprimir_comp_ingreso", "pers_ncorr", f_consulta.ObtenerValor("pers_ncorr")
		f_botonera.AgregaBotonUrlParam "imprimir_comp_ingreso", "total", f_consulta.ObtenerValor("ingr_mtotal")
		f_botonera.AgregaBotonUrlParam "imprimir_comp_ingreso", "peri_ccod", negocio.ObtenerPeriodoAcademico("CLASES18")

	case "6"
			str_formulario = "f_detalle_multidebito"
	
			 consulta=" select pag.PMUL_NCORR, protic.obtiene_monto_pagare_multidebito(rp.repa_ncorr,'M') as monto_actual,  " & vbcrlf &_  
					  " protic.obtiene_monto_pagare_multidebito(rp.repa_ncorr,'C') as num_cuotas,protic.trunc(pag.pmul_fpagare) as fecha    " & vbcrlf &_
					  " from repactaciones rp, pagare_multidebito pag, compromisos com    " & vbcrlf &_
					  " where rp.repa_ncorr = pag.cont_ncorr    " & vbcrlf &_
					  " and rp.repa_ncorr=com.comp_ndocto  " & vbcrlf &_  
					  " and com.tcom_ccod=3    " & vbcrlf &_
					  " and cast(rp.repa_ncorr as varchar)='"&q_repa_ncorr&"' " & vbcrlf &_
					  " and com.ecom_ccod <>3  " & vbcrlf &_
					  " and pag.opag_ccod=2  "

			'response.Write("<pre>"&consulta&"</pre>")	
			str_boton_imprimir = "imprimir_multidebito"

			sql_post_ncorr="select max(post_ncorr) as post_ncorr from postulantes " & vbcrlf &_
						" where epos_ccod=2  " & vbcrlf &_
						" and ofer_ncorr is not null " & vbcrlf &_
						" and pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut="&q_pers_nrut&")" 
			
			v_post_ncorr=conexion.ConsultaUno (sql_post_ncorr)
			
			f_botonera.AgregaBotonUrlParam "imprimir_multidebito", "repa_ncorr", q_repa_ncorr
			f_botonera.AgregaBotonUrlParam "imprimir_multidebito", "imprimir", "S"
			f_botonera.AgregaBotonUrlParam "imprimir_multidebito", "post_ncorr", v_post_ncorr
			f_botonera.AgregaBotonUrlParam "imprimir_multidebito", "tipo_pagare", "M"
	
end select

'---------------------------------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "imprimir_repactacion.xml", str_formulario
f_documentos.Inicializar conexion

f_documentos.Consultar consulta

'---------------------------------------------------------------------------------------------------
url_leng_1 = "imprimir_repactacion.asp?repa_ncorr=" & q_repa_ncorr & "&leng=1&pers_nrut="&q_pers_nrut&" "
url_leng_2 = "imprimir_repactacion.asp?repa_ncorr=" & q_repa_ncorr & "&leng=2&pers_nrut="&q_pers_nrut&" "
url_leng_3 = "imprimir_repactacion.asp?repa_ncorr=" & q_repa_ncorr & "&leng=3&pers_nrut="&q_pers_nrut&" "
url_leng_4 = "imprimir_repactacion.asp?repa_ncorr=" & q_repa_ncorr & "&leng=4&pers_nrut="&q_pers_nrut&" "
url_leng_5 = "imprimir_repactacion.asp?repa_ncorr=" & q_repa_ncorr & "&leng=5&pers_nrut="&q_pers_nrut&" "
url_leng_6 = "imprimir_repactacion.asp?repa_ncorr=" & q_repa_ncorr & "&leng=6&pers_nrut="&q_pers_nrut&" "

'---------------------------------------------------------------------------------------------------
if f_documentos.NroFilas = 0 then
	f_botonera.AgregaBotonParam str_boton_imprimir, "deshabilitado", "TRUE"
end if
'---------------------------------------------------------------------------------------------------



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
var t_documentos;
var t_alt_documentos;

function imprimir_d_click(objeto)
{	
	for (var i = 0; i < t_alt_documentos.filas.length; i++) {
		if (t_alt_documentos.filas[i].campos["imprimir_d"].objeto != objeto) {			
			t_alt_documentos.filas[i].campos["imprimir_d"].objeto.checked = false;
		}
		cambiaOculto(t_alt_documentos.filas[i].campos["imprimir_d"].objeto, '1', '0');
	}
}


function ValidaImprimirCheque()
{
	if (t_documentos.CuentaSeleccionados("imprimir_d") == 0) {
		alert('Debe seleccionar cheques para imprimir.');
		return false;		
	}	

	return true;
}


function ValidaImprimirLetras()
{
	if (t_documentos.CuentaSeleccionados("ding_ndocto") == 0) {
		alert('Debe seleccionar letras para imprimir.');
		return false;		
	}
	
	open ("", "wLetras", "top=, left=, width=, height=");	
	return true;
}



function InicioPagina()
{
	t_documentos = new CTabla("envios");
	t_alt_documentos = new CTabla("_envios");
}

function imprimir_acuse(){
	if (confirm("¿Desea imprimir un acuse de recibo por los documentos pagados?")){
		window.open("../cajas/acuse_recibo.asp?nfolio=<%=q_repa_ncorr%>&ting_ccod=9", "acuse", " ");
	}
	return false;
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();" onUnload="imprimir_acuse();window.opener.parent.top.location.reload();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Repactación"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<br>
			<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td><%'f_repactacion.DibujaRegistro%></td>
              </tr>
            </table>
			<br>    
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<form name="repactacion">
					<%pagina.DibujarSubtitulo "Documentos para imprimir"%>
                      <br>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                            <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                              <tr>
                                <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                                <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                                <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                              </tr>
                              <tr>
                                <td width="9" background="../imagenes/marco_claro/9.gif"></td>
                                <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td><%pagina.DibujarLenguetasFClaro Array(Array("Documento Repactación", url_leng_1), Array("Cheques", url_leng_2), Array("Letras", url_leng_3), Array("Pagare", url_leng_4), Array("Comprobante de Ingreso", url_leng_5),Array("Multidebito", url_leng_6)), CInt(q_leng) %></td>
                                    </tr>
                                    <tr>
                                      <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                                    </tr>
                                    <tr>
                                      <td><br>                                              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                          <td><%f_documentos.DibujaTabla%></td>
                                        </tr>
                                      </table> </td>
                                    </tr>
                                </table></td>
                                <td width="7" background="../imagenes/marco_claro/10.gif"></td>
                              </tr>
                              <tr>
                                <td width="9" height="13"><img src="../imagenes/marco_claro/base1.gif" width="9" height="13"></td>
                                <td height="13" background="../imagenes/marco_claro/15.gif"></td>
                                <td width="7" height="13"><img src="../imagenes/marco_claro/base3.gif" width="7" height="13"></td>
                              </tr>
                            </table>
                          </div></td>
                        </tr>
                      </table>
                      </form>
                      </td>
                  </tr>
                </table>
                </td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton(str_boton_imprimir)%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>	</td>
  </tr>  
</table>
</body>
</html>
