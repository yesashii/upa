<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Resumen anual de ingresos por caja"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_anos  		= request.querystring("busqueda[0][v_anos]")
v_fecha_corte  = request.querystring("busqueda[0][ding_fdocto]")

sql_anos=	" (Select anos_ccod as v_anos, 'Año '+cast(anos_ccod as varchar) as  anos_tdesc  "& vbCrLf &_
			" From anos where anos_ccod between '2004' and datepart(year,getdate()) ) as tabla"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "resumen_bancaj.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.siguiente
 
f_busqueda.AgregaCampoParam "v_anos", "destino", sql_anos 

f_busqueda.AgregaCampoCons "v_anos", v_anos
f_busqueda.AgregaCampoCons "ding_fdocto", v_fecha_corte


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "resumen_bancaj.xml", "botonera"


if v_fecha_corte <> "" then
	sql_adicional= " and b.ding_fdocto<='"&v_fecha_corte&"'"
end if

Function ObtenerConsulta(p_sede)
sql_bancaj=	" select mes_tdesc,sum(cheques) as cheques, sum(letras) as letras, sum(efectivo) as efectivo,  "& vbCrLf &_
			" sum(credito) as credito, sum(debito) as debito, sum(vale_vista) as vale_vista, sum(pagare) as pagare,  "& vbCrLf &_
			" (sum(cheques)+sum(letras)+sum(efectivo)+sum(credito)+sum(debito)+sum(vale_vista)+sum(pagare)+sum(multidebito)+sum(pagare_upa)) as total "& vbCrLf &_
			" from ( "& vbCrLf &_
			" select datepart(month,b.mcaj_finicio) as mes,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras,    "& vbCrLf &_  
				 " isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,isnull(max(pagare),0) as pagare,     "& vbCrLf &_
				 " isnull(max(multidebito),0) as multidebito,isnull(max(pagare_upa),0) as pagare_upa,    "& vbCrLf &_  
				 " (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0)+isnull(max(multidebito),0) + isnull(max(pagare_upa),0) ) as total    "& vbCrLf &_
				 " from (      "& vbCrLf &_
				 "     select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,    "& vbCrLf &_  
				 "     case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,     "& vbCrLf &_
				 "     case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,   "& vbCrLf &_  
				 "     case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,     "& vbCrLf &_
				 "     case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,     "& vbCrLf &_
				 "     case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,     "& vbCrLf &_
				 "     case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare,     "& vbCrLf &_
				 "     case ting_ccod when 59 then cast(sum(monto_recaudado) as numeric) end as multidebito,     "& vbCrLf &_
				 "     case ting_ccod when 66 then cast(sum(monto_recaudado) as numeric) end as pagare_upa     "& vbCrLf &_					 
				 "     from (     "& vbCrLf &_
				        "  select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, "& vbCrLf &_   
                        "  case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 "& vbCrLf &_
                        "        when a.ting_ccod = 88 then 3 "& vbCrLf &_
                        "        else b.ting_ccod end as ting_ccod,    "& vbCrLf &_
                        "  case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo "& vbCrLf &_
						"       else (case a.ting_ccod when 88 then 0 else b.ding_mdetalle end -protic.documento_pagado_x_otro(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    "& vbCrLf &_  
				        "  from ingresos a      "& vbCrLf &_
				        "  left outer join detalle_ingresos b    "& vbCrLf &_  
				        "      on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
				        "      and  b.ting_ccod in (3,4,6,13,14,51,52,88,59,66)  "&sql_adicional&"   "& vbCrLf &_   
				        "  left outer join tipos_ingresos c      "& vbCrLf &_ 
				        "      on b.ting_ccod=c.ting_ccod     "& vbCrLf &_ 
				        "  where a.mcaj_ncorr in (select mcaj_ncorr from movimientos_cajas where sede_ccod="&p_sede&" and  datepart(year,mcaj_finicio)='"&v_anos&"'   )      "& vbCrLf &_
				        "  and a.ting_ccod  in (7,15,16,33,34,88)     "& vbCrLf &_ 
				 "     ) as tabla      "& vbCrLf &_
				 "     group by mcaj_ncorr,ting_ccod      "& vbCrLf &_
				 " ) a      "& vbCrLf &_
				 " join movimientos_cajas b   "& vbCrLf &_   
				 "     on a.mcaj_ncorr=b.mcaj_ncorr    "& vbCrLf &_
				 " 	  and b.tcaj_ccod in (1000)   "& vbCrLf &_   
			"	 group by b.mcaj_finicio "& vbCrLf &_  
			"    ) as tabla "& vbCrLf &_  
			" join meses "& vbCrLf &_  
			"    on mes_ccod=mes   "& vbCrLf &_  
			" group by mes_ccod,mes_tdesc "& vbCrLf &_   
			" order by mes_ccod "
			
if p_sede="8" then
	'response.Write("<pre>"&sql_bancaj&"</pre>")
end if             
		ObtenerConsulta=sql_bancaj				 
end function

Function ObtenerTotales()

sql_total=	"select '<b>Totales x Documentos:</b>' as texto, sum(cheques) as cheques,sum(letras) as letras,"& vbCrLf &_  
				"sum(efectivo) as efectivo,sum(vale_vista) as vale_vista,sum(credito) as credito,sum(debito) as debito,sum(pagare) as pagare,"& vbCrLf &_  
				"(sum(cheques)+sum(letras)+sum(efectivo)+sum(vale_vista)+sum(credito)+sum(debito)+sum(pagare)+sum(multidebito)+sum(pagare_upa)) as total"& vbCrLf &_  
				" from "& vbCrLf &_  
				" (select datepart(month,b.mcaj_finicio) as mes,isnull(max(cheque),0) as cheques,isnull(max(letra),0) as letras,    "& vbCrLf &_  
				 " isnull(max(efectivo),0) as efectivo,isnull(max(credito),0) as credito,    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) as vale_vista,isnull(max(debito),0) as debito,isnull(max(pagare),0) as pagare,      "& vbCrLf &_
				 " isnull(max(multidebito),0) as multidebito,isnull(max(pagare_upa),0) as pagare_upa,   "& vbCrLf &_  
				 " (isnull(max(cheque),0) + isnull(max(letra),0) + isnull(max(efectivo),0) + isnull(max(credito),0) +    "& vbCrLf &_ 
				 " isnull(max(vale_vista),0) +isnull(max(debito),0) + isnull(max(pagare),0) +isnull(max(multidebito),0) + isnull(max(pagare_upa),0) ) as total    "& vbCrLf &_
				 " from (      "& vbCrLf &_
				 "     select mcaj_ncorr,case ting_ccod when 3 then cast(sum(monto_recaudado) as numeric) end as cheque,    "& vbCrLf &_  
				 "     case ting_ccod when 4 then cast(sum(monto_recaudado) as numeric) end as letra,     "& vbCrLf &_
				 "     case ting_ccod when 6 then cast(sum(monto_recaudado) as numeric) end as efectivo,   "& vbCrLf &_  
				 "     case ting_ccod when 13 then cast(sum(monto_recaudado) as numeric) end as credito,     "& vbCrLf &_
				 "     case ting_ccod when 14 then cast(sum(monto_recaudado) as numeric) end as vale_vista,     "& vbCrLf &_
				 "     case ting_ccod when 51 then cast(sum(monto_recaudado) as numeric) end as debito,     "& vbCrLf &_
				 "     case ting_ccod when 52 then cast(sum(monto_recaudado) as numeric) end as pagare,     "& vbCrLf &_
				 "     case ting_ccod when 59 then cast(sum(monto_recaudado) as numeric) end as multidebito,     "& vbCrLf &_
				 "     case ting_ccod when 66 then cast(sum(monto_recaudado) as numeric) end as pagare_upa     "& vbCrLf &_				 
				 "     from (     "& vbCrLf &_
				        "  select a.mcaj_ncorr,a.ingr_ncorr,a.ingr_nfolio_referencia,b.ding_mdetalle, a.ingr_mtotal, a.ingr_mefectivo, "& vbCrLf &_   
                        "  case  when b.ting_ccod is null and a.ingr_mefectivo is not null then 6 "& vbCrLf &_
                        "        when a.ting_ccod = 88 then 3 "& vbCrLf &_
                        "        else b.ting_ccod end as ting_ccod,    "& vbCrLf &_
                        "  case when b.ting_ccod is null and a.ingr_mefectivo is not null then a.ingr_mefectivo "& vbCrLf &_
						"       else (case a.ting_ccod when 88 then 0 else b.ding_mdetalle end -protic.documento_pagado_x_otro(a.ingr_ncorr,b.ding_bpacta_cuota,'A')) end as monto_recaudado    "& vbCrLf &_  
				        "  from ingresos a      "& vbCrLf &_
				        "  left outer join detalle_ingresos b    "& vbCrLf &_  
				        "      on a.ingr_ncorr=b.ingr_ncorr   "& vbCrLf &_   
				        "      and  b.ting_ccod in (3,4,6,13,14,51,52,59,66)  "&sql_adicional&"   "& vbCrLf &_   
				        "  left outer join tipos_ingresos c      "& vbCrLf &_ 
				        "      on b.ting_ccod=c.ting_ccod     "& vbCrLf &_ 
				        "  where a.mcaj_ncorr in (select mcaj_ncorr from movimientos_cajas where sede_ccod in (1,2,4,8) and  datepart(year,mcaj_finicio)='"&v_anos&"'   )      "& vbCrLf &_
				        "  and a.ting_ccod  in (7,15,16,33,34,88)     "& vbCrLf &_ 
				 "     ) as tabla      "& vbCrLf &_
				 "     group by mcaj_ncorr,ting_ccod      "& vbCrLf &_
				 " ) a      "& vbCrLf &_
				 " join movimientos_cajas b   "& vbCrLf &_   
				 "     on a.mcaj_ncorr=b.mcaj_ncorr    "& vbCrLf &_
				 " 	  and b.tcaj_ccod in (1000)   "& vbCrLf &_   
			"	 group by b.mcaj_finicio "& vbCrLf &_  
			"    ) as tabla "
 
'response.Write("<pre>"&sql_total&"</pre>")
'response.Flush()
'"         and a.ting_ccod  in (7,15,16,33,34) "& vbCrLf &_  
		Obtenertotales=sql_total				

end function


set casa_central = new CFormulario
casa_central.carga_parametros "resumen_bancaj.xml", "resumen_caja"
casa_central.inicializar conexion 

set providencia = new CFormulario
providencia.carga_parametros "resumen_bancaj.xml", "resumen_caja"
providencia.inicializar conexion 

set melipilla = new CFormulario
melipilla.carga_parametros "resumen_bancaj.xml", "resumen_caja"
melipilla.inicializar conexion 

set baquedano = new CFormulario
baquedano.carga_parametros "resumen_bancaj.xml", "resumen_caja"
baquedano.inicializar conexion 

set totales = new CFormulario
totales.carga_parametros "resumen_bancaj.xml", "resumen_caja_final"
totales.inicializar conexion 

sql_casa_central=ObtenerConsulta(1)
sql_providencia=ObtenerConsulta(2)
sql_melipilla=ObtenerConsulta(4)
sql_baquedano=ObtenerConsulta(8)

sql_resumen=ObtenerTotales()
'response.Write("<pre>"&sql_resumen&"</pre>")		

if not Esvacio(Request.QueryString) then
	casa_central.Consultar sql_casa_central
	providencia.Consultar sql_providencia
	melipilla.Consultar sql_melipilla
	baquedano.Consultar sql_baquedano
	
	totales.Consultar sql_resumen
	'casa_central.Consultar "select '' where 1=2 "
    'providencia.Consultar "select '' where 1=2 "
	'melipilla.Consultar "select '' where 1=2 "
	'totales.Consultar "select '' where 1=2 "
else

	vacia = "select '' where 1=2 "
	
	baquedano.Consultar vacia
	baquedano.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
 
	melipilla.Consultar vacia
	melipilla.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
	
	providencia.Consultar vacia
	providencia.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
	
	casa_central.Consultar vacia
	casa_central.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"

	totales.Consultar vacia
	totales.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"

end if
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

function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                          <td width="27%"><strong>Años Finacieros </strong></td>
                          <td width="2%"><strong>:</strong></td>
                          <td width="71%"><div align="left"></div>
                            <%f_busqueda.DibujaCampo("v_anos")%></td>
                        </tr>
                      <tr>
                        <td><strong>Fecha de Corte</strong> </td>
                        <td><strong>:</strong></td>
                        <td><%f_busqueda.dibujaCampo("ding_fdocto")%> (dd/mm/aaaa)</td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right"></td>
                            </tr>
                               <tr>
                                 <td align="center">
								 	<%pagina.DibujarSubtitulo "Las Condes"%><br>
                                    <%casa_central.dibujaTabla()%>
									<br>
                                 </td>
                             </tr>
							 <tr>
							 	<td align="center">
									<br>
									<%pagina.DibujarSubtitulo "Lyon"%><br>
									<%providencia.dibujaTabla()%>
									<br>
								</td>
							 </tr>
							 <tr>
							 	<td align="center">
								    <br>
									<%pagina.DibujarSubtitulo "Melipilla"%><br>									
									<%melipilla.dibujaTabla()%>
									<br>
								</td>
							 </tr>
							 <tr>
							 	<td align="center">
								    <br>
									<%pagina.DibujarSubtitulo "Baquedano"%><br>									
									<%baquedano.dibujaTabla()%>
									<br>
								</td>
							 </tr>
							 <tr>
							 	<td align="center">
									<br>
									<%pagina.DibujarSubtitulo "Totalización de ingresos"%><br>									
									<%totales.dibujaTabla()%>
									<br>
								</td>
							 </tr>												 
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
						  </table>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center">  <%f_botonera.dibujaboton "excel_anual"%>
					 </div>
                  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
