<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_mcaj_ncorr 	= 	Request.QueryString("mcaj_ncorr")
q_ting_ccod 	= 	Request.QueryString("ting_ccod")
q_tdoc_ccod 	= 	Request.QueryString("tdoc_ccod")
q_leng			=	Request.QueryString("leng")

if q_leng="" then
	q_leng=3
end if
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cuadratura de Cajas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_caja.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "detalle_caja.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion

'consulta = "select obtener_rut(b.pers_ncorr) as rut, obtener_nombre_completo(b.pers_ncorr) as nombre_completo, a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio, sysdate as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
'           "from movimientos_cajas a, cajeros b " & vbCrLf &_
'		   "where a.sede_ccod = b.sede_ccod " & vbCrLf &_
'		   "  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
'		   "  and a.mcaj_ncorr = '" & q_mcaj_ncorr & "'"
		   
consulta = "select protic.obtener_rut(b.pers_ncorr) as rut," & vbCrLf &_
			"    protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"    a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr, a.mcaj_finicio," & vbCrLf &_
			"    getdate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
			"from movimientos_cajas a, cajeros b " & vbCrLf &_
			"where a.sede_ccod = b.sede_ccod " & vbCrLf &_
			"  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
			"  and cast(a.mcaj_ncorr as varchar) = '" & q_mcaj_ncorr & "'"
'response.Write("<pre>"&consulta&"</pre>")			
f_movimiento_caja.Consultar consulta



'-----------------------------------------------------------------------------------------------
v_inst_ccod = "1"
v_tdoc_tdesc = conexion.ConsultaUno("select UPPER(tdoc_tdesc) from tipos_documentos_mov_cajas where tdoc_ccod = '" & q_tdoc_ccod & "'")

if EsVacio(q_tdoc_ccod) then
	v_tdoc_tdesc = conexion.ConsultaUno("select UPPER(ting_tdesc) from tipos_ingresos where cast(ting_ccod as varchar) = '" & q_ting_ccod & "'")
end if

'------------------------------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "detalle_caja.xml", "documentos"
f_documentos.Inicializar conexion


SELECT CASE q_ting_ccod

CASE "52" 

	sql_extra= " case when len(isnull(b.ding_ndocto,0))<=4 "& vbCrLf &_
				" then protic.obtener_numero_pagare_pagado(b.ingr_ncorr) "& vbCrLf &_
				" else cast(b.ding_ndocto as varchar) end as ding_ndocto, 'N/B' as banc_ccod, "

CASE "10" 
	sql_extra=" cast(b.ding_ndocto as varchar)+' <br>('+cast(protic.obtener_numero_docto_pagado(b.ingr_ncorr) as varchar)+')' as ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod,"
	f_documentos.AgregaCampoParam "ding_ndocto", "descripcion", "N° cedente<br> (N° Letra)"
Case "6"
	sql_extra=" a.ingr_nfolio_referencia as ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod,"
CASE ELSE 
	sql_extra=" b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod,"
END SELECT 


if q_ting_ccod="87" then
	sql_orden="ORDER BY b.ding_ndocto asc, rut ASC,b.banc_ccod, b.ding_fdocto  ASC "
elseif q_ting_ccod="6" then
	sql_orden="ORDER BY a.ingr_nfolio_referencia asc, rut ASC, a.ingr_fpago  ASC "
else
	sql_orden="ORDER BY b.banc_ccod ASC, rut ASC, b.ding_ndocto, b.ding_fdocto  asc"
end if

if q_leng=4 then


	f_botonera.AgregaBotonParam "exportar_excel", "url", "detalle_documentos_excel_dep.asp"
	f_botonera.AgregaBotonUrlParam "exportar_excel", "q_leng", 4
	
	'Documentos depositados
	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
				"  protic.obtener_rut((SELECT top 1 pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT pos.post_ncorr FROM postulantes pos,periodos_academicos per WHERE pos.pers_ncorr = a.pers_ncorr and pos.peri_ccod=(select top 1 ab.peri_ccod from abonos ab where ab.ingr_ncorr=a.ingr_ncorr) and pos.peri_ccod=per.peri_ccod))) as rut_apoderado,"& vbCrLf &_
				"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,b.ting_ccod," & vbCrLf &_
				"     b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod, " & vbCrLf &_
				"    b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle," & vbCrLf &_
				"    cast(b.ding_mdocto as numeric) as ding_mdocto,b.plaz_ccod, " & vbCrLf &_
				"    protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as anulado," & vbCrLf &_
				"    b.ding_mdetalle - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo" & vbCrLf &_
				"    from ingresos a,detalle_ingresos b" & vbCrLf &_
				"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
				"        and a.eing_ccod not in (3,6) " & vbCrLf &_
				"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
				"        and b.ting_ccod = '3'" & vbCrLf &_
				"         and (b.ding_fdocto) <= (select mcaj_finicio from movimientos_cajas where cast(mcaj_ncorr as varchar)='" & q_mcaj_ncorr & "') "& vbCrLf &_
				"ORDER BY banc_ccod ASC, rut ASC, b.ding_ndocto, b.ding_fdocto asc"
elseif q_leng=5 then
	
	f_botonera.AgregaBotonParam "exportar_excel", "url", "detalle_documentos_excel_dep.asp"
	f_botonera.AgregaBotonUrlParam "exportar_excel", "q_leng", 5
	
	'Documentos en custodia
	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
			"  protic.obtener_rut((SELECT top 1 pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT pos.post_ncorr FROM postulantes pos,periodos_academicos per WHERE pos.pers_ncorr = a.pers_ncorr and pos.peri_ccod=(select top 1 ab.peri_ccod from abonos ab where ab.ingr_ncorr=a.ingr_ncorr) and pos.peri_ccod=per.peri_ccod))) as rut_apoderado,"& vbCrLf &_
			"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre," & vbCrLf &_
			"    b.ting_ccod, b.ding_ndocto, isnull(cast(b.banc_ccod as varchar),'N/B') as banc_ccod, b.plaz_ccod," & vbCrLf &_
			"    b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle," & vbCrLf &_
			"    cast(b.ding_mdocto as numeric) as ding_mdocto, " & vbCrLf &_
			"    protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as anulado," & vbCrLf &_
			"    b.ding_mdetalle - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo" & vbCrLf &_
			"    from ingresos a,detalle_ingresos b" & vbCrLf &_
			"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
			"        and a.eing_ccod not in (3,6) " & vbCrLf &_
			"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
			"        and b.ting_ccod = '3'" & vbCrLf &_
			"        and (b.ding_fdocto) > (select mcaj_finicio from movimientos_cajas where cast(mcaj_ncorr as varchar)='" & q_mcaj_ncorr & "') "& vbCrLf &_
			"ORDER BY b.banc_ccod ASC, rut ASC, b.ding_ndocto, b.ding_fdocto asc"
else

	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
				"  protic.obtener_rut((SELECT top 1 pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT pos.post_ncorr FROM postulantes pos,periodos_academicos per WHERE pos.pers_ncorr = a.pers_ncorr and pos.peri_ccod=(select top 1 ab.peri_ccod from abonos ab where ab.ingr_ncorr=a.ingr_ncorr) and pos.peri_ccod=per.peri_ccod))) as rut_apoderado,"& vbCrLf &_
				"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,b.ting_ccod," & vbCrLf &_
				"    "&sql_extra&" " & vbCrLf &_
				"    b.ding_fdocto, cast(b.ding_mdetalle as numeric) as ding_mdetalle," & vbCrLf &_
				"    cast(b.ding_mdocto as numeric) as ding_mdocto,b.plaz_ccod, " & vbCrLf &_
				"    protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as anulado," & vbCrLf &_
				"    b.ding_mdetalle - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo" & vbCrLf &_
				"    from ingresos a,detalle_ingresos b" & vbCrLf &_
				"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
				"        and a.eing_ccod not in (3,6) " & vbCrLf &_
				"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
				"        and cast(b.ting_ccod as varchar) = '" & q_ting_ccod & "'" & vbCrLf &_
				" "&sql_orden&" "
end if
			

'*********************************
'********	BOLETAS		**********	   
if q_tdoc_ccod="25" then
	if q_leng=4 then
		bole_filtro="and a.tbol_ccod=1"
	elseif q_leng=5 then
		bole_filtro="and a.tbol_ccod=2"
	else
		bole_filtro=""
	end if
	
	consulta = 	" select protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_rut(a.pers_ncorr_aval) as rut_apoderado, "& vbCrLf &_
				"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, 1 as ting_ccod, "& vbCrLf &_
				"    a.bole_nboleta as ding_ndocto,'N/B' as banc_ccod, "& vbCrLf &_
				"    protic.trunc(a.bole_fboleta) as ding_fdocto,  cast(isnull(a.bole_mtotal,0) as numeric) as ding_mdetalle, "& vbCrLf &_
				"    cast(isnull(a.bole_mtotal,0) as numeric) as ding_mdocto,null as plaz_ccod, cast(isnull(a.bole_mtotal,0) as numeric) as saldo, "& vbCrLf &_
				"    case a.ebol_ccod when 3 then a.bole_mtotal end as anulado "& vbCrLf &_
				" from boletas a "& vbCrLf &_
				" left outer join ingresos b "& vbCrLf &_
				"    on a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
				"  join estados_boletas c " & vbCrLf &_
				" 	on a.ebol_ccod=c.ebol_ccod "& vbCrLf &_
				" where 1=1  "& vbCrLf &_
				" AND a.ebol_ccod not in (3) "& vbCrLf &_
				" and a.mcaj_ncorr='"&q_mcaj_ncorr&"'"& vbCrLf &_
				" "&bole_filtro&"  "& vbCrLf &_
				" group by a.ebol_ccod,a.pers_ncorr,a.pers_ncorr_aval,a.bole_fboleta,a.bole_ncorr,a.bole_nboleta, a.ingr_nfolio_referencia,a.bole_mtotal,c.ebol_tdesc "& vbCrLf &_
				" order by a.bole_nboleta asc"
end if


if q_ting_ccod = "6" then
	consulta = "select protic.obtener_rut(a.pers_ncorr) as rut," & vbCrLf &_
				"  protic.obtener_rut((SELECT top 1 pers_ncorr FROM codeudor_postulacion WHERE post_ncorr in (SELECT pos.post_ncorr FROM postulantes pos,periodos_academicos per WHERE pos.pers_ncorr = a.pers_ncorr and pos.peri_ccod=(select top 1 ab.peri_ccod from abonos ab where ab.ingr_ncorr=a.ingr_ncorr) and pos.peri_ccod=per.peri_ccod))) as rut_apoderado,"& vbCrLf &_
				"    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,b.ting_ccod," & vbCrLf &_
				"    "&sql_extra&" " & vbCrLf &_
				"    a.ingr_fpago as ding_fdocto, a.ingr_mefectivo as ding_mdetalle," & vbCrLf &_
				"    a.ingr_mefectivo as ding_mdocto,b.plaz_ccod, " & vbCrLf &_
				"    protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as anulado," & vbCrLf &_
				"    a.ingr_mefectivo - protic.total_rebajado_ingreso(b.ingr_ncorr, '" & q_mcaj_ncorr & "') as saldo" & vbCrLf &_
				"    from ingresos a,detalle_ingresos b" & vbCrLf &_
				"    where a.ingr_ncorr *= b.ingr_ncorr" & vbCrLf &_
				"        and a.eing_ccod not in (3,6) " & vbCrLf &_
				"        and a.ingr_mefectivo > 0 " & vbCrLf &_
				"        and cast(a.mcaj_ncorr as varchar)= '" & q_mcaj_ncorr & "' " & vbCrLf &_
				"        and cast(b.ting_ccod as varchar) = '" & q_ting_ccod & "'" & vbCrLf &_
				" "&sql_orden&" "

end if
'response.Write("<pre>"&consulta&"</pre>")
f_documentos.Consultar consulta

if q_ting_ccod = "3" then
	f_documentos.AgregaCampoParam "ding_mdocto", "permiso", "LECTURA"
end if

v_ting_brebaje = conexion.ConsultaUno("select isnull(ting_brebaje, 'N') from tipos_ingresos where cast(ting_ccod as varchar) = '" & q_ting_ccod & "'")
if v_ting_brebaje = "S" then
	'f_documentos.AgregaCampoParam "ding_mdetalle", "resumen", "SUMA"
	'f_documentos.AgregaCampoParam "anulado", "permiso", "OCULTO"
	'f_documentos.AgregaCampoParam "saldo", "permiso", "OCULTO"
end if
	
'------------------------------------------------------------------------------------------
url_leng_1 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=1"
url_leng_2 = "detalle_caja.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=2"
url_leng_3 = "detalle_documentos.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=3&ting_ccod=3"
url_leng_4 = "detalle_documentos.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=4&ting_ccod=3"
url_leng_5 = "detalle_documentos.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=5&ting_ccod=3"

url_leng_6 = "detalle_documentos.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=3&ting_ccod=1&tdoc_ccod=25"
url_leng_7 = "detalle_documentos.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=4&ting_ccod=1&tdoc_ccod=25"
url_leng_8 = "detalle_documentos.asp?mcaj_ncorr=" & q_mcaj_ncorr & "&leng=5&ting_ccod=1&tdoc_ccod=25"


'------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "exportar_excel", "mcaj_ncorr", q_mcaj_ncorr
f_botonera.AgregaBotonUrlParam "exportar_excel", "ting_ccod", q_ting_ccod
f_botonera.AgregaBotonUrlParam "exportar_excel", "tdoc_ccod", q_tdoc_ccod

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
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%pagina.DibujarLenguetas Array("Cuadratura de Cajas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
			  <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_movimiento_caja.DibujaRegistro%></div></td>
                </tr>
              </table>
</div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                      <br>                                            
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                      <tr>
                        <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                        <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                        <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                      </tr>
                      <tr>
                        <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td><% 	if q_ting_ccod="3" then
							  				pagina.DibujarLenguetasFClaro Array(Array("Caja", url_leng_1), Array("Ingresos", url_leng_2), Array("CHEQUES", url_leng_3),Array("DEPOSITADOS", url_leng_4),Array("EN CUSTODIA", url_leng_5)), q_leng  
										elseif q_ting_ccod="1" then
											pagina.DibujarLenguetasFClaro Array(Array("Caja", url_leng_1), Array("Ingresos", url_leng_2), Array("BOLETAS", url_leng_6),Array("AFECTAS", url_leng_7),Array("EXENTAS", url_leng_8)), q_leng  
										else 
											pagina.DibujarLenguetasFClaro Array(Array("Caja", url_leng_1), Array("Ingresos", url_leng_2), v_tdoc_tdesc), 3 
										end if
								%></td>
                            </tr>
                            <tr>
                              <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                            </tr>
                            <tr>
                              <td><div align="left"><br>
							  
							        <%pagina.DibujarSubtitulo(v_tdoc_tdesc)%>
                                      </div>                                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr>
                                          <td><div align="right">Páginas : <%f_documentos.AccesoPagina%></div></td>
                                        </tr>
                                        <tr>
                                          <td><div align="center"><%f_documentos.DibujaTabla%></div></td>
                                        </tr>
                                        <tr>
                                          <td height="19">
<div align="center">
                                            <%f_documentos.Pagina%>
                                          </div></td>
                                        </tr>
                                                                      </table>                                
                                      <br>
</td>
                            </tr>
                        </table></td>
                        <td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="9" height="28"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
                        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="38%" height="20"><div align="center">
                                  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td><div align="center"></div></td>
                                      <td><div align="center"></div></td>
                                      <td><div align="center"></div></td>
                                    </tr>
                                  </table>
                              </div></td>
                              <td width="62%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                            </tr>
                            <tr>
                              <td height="8" background="../imagenes/marco_claro/13.gif"></td>
                            </tr>
                        </table></td>
                        <td width="7" height="28"><img src="../imagenes/marco_claro/16.gif" width="7" height="28"></td>
                      </tr>
                    </table></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="19%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
				  <% 
				     if q_tdoc_ccod="25" then
				      	f_botonera.agregabotonparam "exportar_excel", "url", "../cajas/ver_boletas_imprimir.asp" 
					 end if 
                      f_botonera.DibujaBoton("exportar_excel")%>
                  </div></td>
                  <td><div align="center">
                      <%f_botonera.DibujaBoton("cerrar")%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
