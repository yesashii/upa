
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_ding_ndocto 	= 	Request.QueryString("buscador[0][ding_ndocto]")

set pagina = new CPagina
pagina.Titulo = "Cambio Numero de Tarjeta"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambio_n_tarjeta.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cambio_n_tarjeta.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "ding_ndocto", q_ding_ndocto
f_busqueda.Siguiente

if q_ding_ndocto <> "" then
'---------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "cambio_n_tarjeta.xml", "datos_Alumno"
formulario.Inicializar conexion
sql_comentarios ="select top 1 ding_ndocto,DING_TCUENTA_CORRIENTE,p.pers_ncorr, protic.obtener_rut(p.pers_ncorr) as rut,protic.obtener_nombre_completo(p.pers_ncorr, 'n') as nombre "&_
"from DETALLE_INGRESOS d,INGRESOS i, personas p "&_
"where d.INGR_NCORR = i.INGR_NCORR "&_
"and d.ting_ccod = 52 "&_
"and i.PERS_NCORR = p.PERS_NCORR "&_
"and ding_ndocto ="&q_ding_ndocto

formulario.Consultar sql_comentarios
formulario.Siguiente


cantidad = conexion.ConsultaUno("select count(ding_ndocto) as cantidad from DETALLE_INGRESOS d,INGRESOS i, personas p where d.INGR_NCORR = i.INGR_NCORR and d.ting_ccod = 52 and i.PERS_NCORR = p.PERS_NCORR and ding_ndocto ="&q_ding_ndocto)

'--------------------------------------------------------------------------------------------------
codigo=formulario.ObtenerValor("pers_ncorr")


set asginacion = new CFormulario
asginacion.Carga_Parametros "cambio_n_tarjeta.xml", "datos_pagare"
asginacion.Inicializar conexion
sql_compromisos ="select case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, case " &_
 "when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 then "&_ 
"(Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) "&_
"when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') else (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) end as tcom_tdesc,cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota, "&_
"protic.trunc(a.comp_fdocto)as comp_fdocto,protic.trunc(b.dcom_fcompromiso)as dcom_fcompromiso, b.dcom_mcompromiso, case when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "&_
"then (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2)) else protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') end as ding_ndocto, "&_
"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d where c.edin_ccod = d.edin_ccod) as edin_tdesc " &_
"from compromisos a INNER JOIN detalle_compromisos b " &_
"	ON a.tcom_ccod = b.tcom_ccod " &_ 
"   and a.inst_ccod = b.inst_ccod " &_ 
"   and a.comp_ndocto = b.comp_ndocto " &_ 
"   LEFT OUTER JOIN detalle_ingresos c  " &_
"   ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod  " &_
"   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  " &_
"   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " &_ 
"   WHERE a.ecom_ccod = '1'  " &_ 
"   and b.ecom_ccod <> '3' " &_ 
"   and cast(a.pers_ncorr as varchar) ='"&codigo&"' " &_
"   and ding_ndocto ="&q_ding_ndocto&" "&_
"   order by b.dcom_fcompromiso desc"

	'response.Write(sql_compromisos)

asginacion.Consultar sql_compromisos

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

<script language="JavaScript">
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="32%"><div align="right"><strong>Pagare</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("ding_ndocto")%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>          
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><br>
              </div>		
	<%if q_ding_ndocto <> "" and cantidad > "0" then%>
			<form name="edicion">
			  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <td width="17%"><strong>Rut</strong></td>
                    <td width="3%"><strong>:</strong></td>
                    <td width="80%"><%formulario.dibujaCampo("rut")%></td>
                </tr>
				<tr>
                    <td><strong>Nombre</strong></td>
                    <td><strong>:</strong></td>
                    <td><%formulario.dibujaCampo("nombre")%></td>
                </tr>
                <tr>
                  <td><strong>N&deg; de tarjeta</strong></td>
                  <td><strong>:</strong></td>
                  <td><%formulario.dibujaCampo("DING_TCUENTA_CORRIENTE")%></td>
                </tr>
                <tr><td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td></tr>
              </table> 
              <table width="46%" border="0" align="center">
                      <tr>
						<td><%asginacion.DibujaTabla()%></td>
						</tr>
                    </table>                    
             <table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  </tr>
				<tr>
                    <td width="23%">&nbsp;</td>
                    <td width="1%">&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                    <td width="44%">&nbsp;</td>
                </tr>
				<tr>
				  <td><strong>Cambio n&deg; de tarjeta</strong></td>
				  <td><strong>:</strong></td>                  
                  <%formulario.dibujaCampo("ding_ndocto")%>
				  <td><%formulario.dibujaCampo("CUENTA_CORRIENTE")%></td>
				  <td><%f_botonera.DibujaBoton("guardar")%></td>
				  </tr>
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  </tr>
				<tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
              </table>          
            </form>  
            <%else%>
            	<table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td align="center"><strong><font size="3" color="red">NO se encuentran datos de este pagare..</font></strong></td>
				  </tr>
              </table> 
              <br>
              <br>
            <%end if%>          
            </td></tr>            
      </table>		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="45%">                           
                        </td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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