<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "parametros.xml", "btn_inf_cuadre"

set negocio = new cNegocio
set conectar = new cconexion
set formulario = new cformulario
set fCuadre = new cFormulario

conectar.inicializar "desauas"
formulario.carga_parametros "parametros.xml", "comp_rendicion_de_cajas"
formulario.inicializar conectar
fCuadre.carga_parametros "parametros.xml", "cuadre"
fCuadre.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

mcaj_ncorr = request.QueryString("mcaj_ncorr")
	rendicion_cons = "select sysdate as mcaj_ftermino, 2 as eren_ccod, mcaj_ncorr as mcaj_ncorr_paso, a.* , sysdate as fecha_emision, pers_nrut || '-' || pers_xdv as pers_nrut, pers_tape_paterno || ' ' || pers_tape_materno || ', ' || pers_tnombre as cajero " & _ 
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0) +  nvl(mcaj_mrend_df_intercia_ip,0) + nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+ nvl(mcaj_mrend_arp_ip,0)+  nvl(mcaj_mrend_ncredito_ip,0) + nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) as t_disponible_ip " & _
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0)+  nvl(mcaj_mrend_df_intercia_ip,0) +  nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+ nvl(mcaj_mrend_arp_ip,0)+  nvl(mcaj_mrend_ncredito_ip,0)  + nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) + nvl(mcaj_mrend_cheques_fecha_ip,0) as t_rend1_ip " & _
					",nvl(mcaj_mrend_tarj_credito_ca,0) + nvl(mcaj_mrend_dep_banco_ca,0) +nvl(mcaj_mrend_cheques_dia_ca,0) + nvl(mcaj_mrend_cheques_fecha_ca,0) as t_rend1_ca " & _
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0)+  nvl(mcaj_mrend_df_intercia_ip,0) +  nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+ nvl(mcaj_mrend_arp_ip,0)+  nvl(mcaj_mrend_ncredito_ip,0)  + nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) + nvl(mcaj_mrend_cheques_fecha_ip,0) as t_rend1_ip1 " & _
					", nvl(mcaj_mrend_boletas_ip,0) + nvl(mcaj_mrend_facturas_ip ,0)+ nvl(mcaj_mrend_facturas_ae_ip ,0)+ nvl(mcaj_mrend_notas_debito_ip,0) + nvl(mcaj_mrend_notas_credito_ip,0) + nvl(mcaj_mrend_notas_cargo_ip,0) as t_rend2_ip " & _
					", nvl(mcaj_mrend_boletas_ca,0) + nvl(mcaj_mrend_facturas_ca ,0) as t_rend2_ca " & _
					", nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_f_intercia_cft,0) + nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_tarj_credito_cft,0) + nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0)+  nvl(mcaj_mrend_ncredito_cft,0)  + nvl(mcaj_mrend_cheques_dia_cft,0) as t_disponible_cft " & _
					", nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_f_intercia_cft,0) +  nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_tarj_credito_cft,0) + nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0)+ nvl(mcaj_mrend_ncredito_cft,0)   +   nvl(mcaj_mrend_cheques_dia_cft,0) + nvl(mcaj_mrend_cheques_fecha_cft,0) as t_rend1_cft " & _
					", nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_f_intercia_cft,0) +  nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_tarj_credito_cft,0)+ nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0)+ nvl(mcaj_mrend_ncredito_cft,0)   + nvl(mcaj_mrend_cheques_dia_cft,0) + nvl(mcaj_mrend_cheques_fecha_cft,0) as t_rend1_cft1 " & _
					",  nvl(mcaj_mrend_tarj_credito_ca,0) + nvl(mcaj_mrend_dep_banco_ca,0)+ nvl(mcaj_mrend_cheques_dia_ca,0) + nvl(mcaj_mrend_cheques_fecha_ca,0) as t_rend1_ca1 " & _
					", nvl(mcaj_mrend_boletas_cft,0) + nvl(mcaj_mrend_facturas_cft ,0)+ nvl(mcaj_mrend_facturas_ae_cft ,0)+ nvl(mcaj_mrend_notas_debito_cft,0) + nvl(mcaj_mrend_notas_credito_cft,0) + nvl(mcaj_mrend_notas_cargo_cft,0) as t_rend2_cft " & _
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0)+  nvl(mcaj_mrend_df_intercia_ip,0) +  nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+ nvl(mcaj_mrend_arp_ip,0)+  nvl(mcaj_mrend_ncredito_ip,0)  + nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) + nvl(mcaj_mrend_cheques_fecha_ip,0) " & _
					"+  nvl(mcaj_mrend_tarj_credito_ca,0)+ nvl(mcaj_mrend_dep_banco_ca,0)+ nvl(mcaj_mrend_cheques_dia_ca,0) + nvl(mcaj_mrend_cheques_fecha_ca,0)  " & _
					"+ nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_f_intercia_cft,0) +  nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_tarj_credito_cft,0)+ nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0)+ nvl(mcaj_mrend_ncredito_cft,0)   + nvl(mcaj_mrend_cheques_dia_cft,0) + nvl(mcaj_mrend_cheques_fecha_cft,0) + nvl(mcaj_mrend_efectivo,0) as t_rend1 " & _
					" from movimientos_cajas a, cajeros b, personas c where a.caje_ccod=b.caje_ccod and a.sede_ccod=b.sede_ccod and b.pers_ncorr=c.pers_ncorr and mcaj_ncorr = " & mcaj_ncorr				


formulario.consultar rendicion_cons
formulario.siguiente
formulario.agregaParam "permisoGeneral", "LECTURA"

efectivo_cons = "select nvl(sum(ingr_mefectivo),0) from ingresos where mcaj_ncorr= " & mcaj_ncorr & " and eing_ccod=1 "
efectivo = conectar.consultaUno(efectivo_cons)
efectivo_f = "$ " & formatNumber(efectivo,0,-1,0,-1)

mov_cons = "select " & _
	 " nvl(sum(case when b.ting_ccod=1 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as boletas_ip " & _
     ", nvl(sum(case when b.ting_ccod=2 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as cupones_ip " & _
     ", nvl(sum(case when b.ting_ccod=3 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as facturas_ip " & _
     ", nvl(sum(case when b.ting_ccod in (4,52) and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as nc_ip " & _
      ", nvl(sum(case when b.ting_ccod = 17 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as vvista_ip " & _ 
      ", nvl(sum(case when b.ting_ccod = 74 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as arecp_ip " & _ 
    ", nvl(sum(case when b.ting_ccod=5 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as nd_ip " & _
     ", nvl(sum(case when b.ting_ccod=6 and a.inst_ccod=6 and ding_fdocto <= ingr_fpago then ding_mdetalle else 0 end),0) as ch_dia_ca " & _
     ", nvl(sum(case when b.ting_ccod=6 and a.inst_ccod=2 and ding_fdocto <= ingr_fpago then ding_mdetalle else 0 end),0) as ch_dia_ip " & _
     ", nvl(sum(case when b.ting_ccod=31 and a.inst_ccod=2  then ding_mdetalle else 0 end),0) as d_al_empresa_ip " & _
     ", nvl(sum(case when b.ting_ccod=76 and a.inst_ccod=2  then ding_mdetalle else 0 end),0) as fact_intercia_ip " & _
     ", nvl(sum(case when b.ting_ccod=31 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as d_al_empresa_cft " & _
     ", nvl(sum(case when b.ting_ccod=76 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as fact_intercia_cft " & _
     ", nvl(sum(case when b.ting_ccod=6 and a.inst_ccod=2 and ding_fdocto > ingr_fpago then ding_mdetalle else 0 end),0) as ch_fecha_ip " & _
      ", nvl(sum(case when b.ting_ccod=6 and a.inst_ccod=6 and ding_fdocto > ingr_fpago then ding_mdetalle else 0 end),0) as ch_fecha_ca " & _
      ", nvl(sum(case when b.ting_ccod=84 and a.inst_ccod=6 then ding_mdetalle else 0 end),0) as dep_banco_ca " & _
    ", nvl(sum(case when b.ting_ccod in (7,50) and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as cedentes_ip " & _
     ", nvl(sum(case when b.ting_ccod=8 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as efectivo2_ip " & _
     ", nvl(sum(case when b.ting_ccod=9 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as ncargo_sede_ip " & _
     ", nvl(sum(case when b.ting_ccod=72 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as mtransbank_ip " & _
     ", nvl(sum(case when b.ting_ccod=10 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as pago_normal_ip " & _
     ", nvl(sum(case when b.ting_ccod=11 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as remesa_ip " & _
     ", nvl(sum(case when b.ting_ccod=12 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as ncargo_osede_ip " & _
     ", nvl(sum(case when b.ting_ccod=13 and a.inst_ccod=6 then ding_mdetalle else 0 end),0) as tcredito_ca " & _
     ", nvl(sum(case when b.ting_ccod=13 and a.inst_ccod=2 then ding_mdetalle else 0 end),0) as tcredito_ip " & _
     ", nvl(sum(case when a.inst_ccod=6 then ding_mdetalle else 0 end),0) as total_ca " & _
     ", nvl(sum(case when a.inst_ccod=2 then ding_mdetalle else 0 end),0) as total_ip " & _
	 ", nvl(sum(case when b.ting_ccod=1 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as boletas_cft " & _
     ", nvl(sum(case when b.ting_ccod=2 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as cupones_cft " & _
     ", nvl(sum(case when b.ting_ccod=3 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as facturas_cft " & _
     ", nvl(sum(case when b.ting_ccod in (4,52) and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as nc_cft " & _
     ", nvl(sum(case when b.ting_ccod =17 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as vvista_cft " & _
     ", nvl(sum(case when b.ting_ccod =74 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as arecp_cft " & _
     ", nvl(sum(case when b.ting_ccod=5 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as nd_cft " & _
     ", nvl(sum(case when b.ting_ccod=6 and a.inst_ccod=1 and ding_fdocto <= ingr_fpago then ding_mdetalle else 0 end),0) as ch_dia_cft " & _
     ", nvl(sum(case when b.ting_ccod=6 and a.inst_ccod=1 and ding_fdocto > ingr_fpago then ding_mdetalle else 0 end),0) as ch_fecha_cft " & _
     ", nvl(sum(case when b.ting_ccod in (7,50) and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as cedentes_cft " & _
     ", nvl(sum(case when b.ting_ccod=8 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as efectivo2_cft " & _
     ", nvl(sum(case when b.ting_ccod=9 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as ncargo_sede_cft " & _
     ", nvl(sum(case when b.ting_ccod=72 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as mtransbank_cft " & _
     ", nvl(sum(case when b.ting_ccod=10 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as pago_normal_cft " & _
     ", nvl(sum(case when b.ting_ccod=11 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as remesa_cft " & _
     ", nvl(sum(case when b.ting_ccod=12 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as ncargo_osede_cft " & _
     ", nvl(sum(case when b.ting_ccod=13 and a.inst_ccod=1 then ding_mdetalle else 0 end),0) as tcredito_cft " & _
     ", nvl(sum(case when a.inst_ccod=1 then ding_mdetalle else 0 end),0) as total_cft " & _
     ", nvl(sum(ding_mdetalle),0) as total " & _
   " from " & _
   "  (select a.ting_ccod, a.ingr_ncorr,a.mcaj_ncorr,a.ingr_fpago, max(b.inst_ccod) as inst_ccod,a.eing_ccod from ingresos a, abonos b where a.ingr_ncorr = b.ingr_ncorr group by a.ting_ccod, a.ingr_ncorr,a.mcaj_ncorr,a.ingr_fpago,a.eing_ccod) a, detalle_ingresos b " & _
   "where " & _
   "  a.ingr_ncorr=b.ingr_ncorr and a.eing_ccod=1 " & _
   "  and a.mcaj_ncorr= " & mcaj_ncorr
   
'response.Write(mov_cons)

fCuadre.consultar mov_cons
fCuadre.siguiente
total = fCuadre.obtenerValor("total") + efectivo
total_f = "$ " & formatNumber(total,0,-1,0,-1)

%>


<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ver_doctos(boton){
 if(boton == 1){
  location.href='inf_vvista.asp?mcaj_ncorr=<%=mcaj_ncorr%>' ;
  return;
 }
 if(boton == 2){ 
 location.href='inf_cheques.asp?mcaj_ncorr=<%=mcaj_ncorr%>' ;  
 return;
}
 if(boton == 3){
  location.href='inf_ingresos.asp?mcaj_ncorr=<%=mcaj_ncorr%>' ;
    return;
}
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="732" border="0" cellpadding="0" cellspacing="0">
  <tr>
  </tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Cuadratura
                          de Caja</font></div></td>
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
				    &nbsp;
				    <form name="edicion">
			        <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="center"> 
    <td> <h2>Cuadratura de caja<br>
      </h2></td>
	  
  </tr>
</table>
<table width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td width="62%">&nbsp;</td>
    <td width="6%"><%botonera.dibujaboton "salir"%>
    </td>
    <td width="9%"><%botonera.dibujaboton "ver_doctos"%>
    </td>
    <td width="6%"><%botonera.dibujaboton "ver_cheques"%>
    </td>
    <td width="6%"><%botonera.dibujaboton "ver_ingresos"%>
    </td>
    <td width="11%"><%botonera.dibujaboton "imprimir"%>
    </td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="6" align="right">&nbsp;    </td>
  </tr>
  <tr> 
    <td width="90" colspan="3" align="right">Cajero :</td>
    <td width="337"> <%formulario.dibujaCampo("cajero")%> </td>
    <td width="136" align="right">Folio :</td>
    <td width="200" nowrap> <%formulario.dibujaCampo("mcaj_ncorr_paso")%> </td>
  </tr>
  <tr> 
    <td colspan="3" align="right">Rut :</td>
    <td> <%formulario.dibujaCampo("pers_nrut")%> </td>
    <td align="right">Apertura :</td>
    <td> <%formulario.dibujaCampo("mcaj_finicio")%> </td>
  </tr>
  <tr> 
    <td colspan="3" align="right">&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right" nowrap>Cierre :</td>
    <td> <%formulario.dibujaCampo("mcaj_ftermino")%> </td>
  </tr>
  <tr> 
    <td colspan="3" align="right">&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right" nowrap>Fecha emisi&oacute;n :</td>
    <td> <%formulario.dibujaCampo("fecha_emision")%> </td>
  </tr>
</table>
<hr noshade>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2 align="center">Estado de caja</h2></td>
  </tr>
  <tr>
    <td> 
      <table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr bgcolor="#CCCCCC"> 
          <th><font size="2">UAS</font></th>
          </tr>
        <tr> 
          <td>
<table width="100%" border="0" align="center">
              <tr> 
                <th width="59%" align="right">Total cedentes</th>
                <td width="5%" align="center">:</td>
                <td width="36%" align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("cedentes_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total remesas</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("remesa_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total de cheques al d&iacute;a</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("ch_dia_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total de tarjetas de cr&eacute;dito</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("tcredito_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total cheques a fecha</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("ch_fecha_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Boletas</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("boletas_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Facturas</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("facturas_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Notas de d&eacute;bito</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("nd_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Vale Vista</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("vvista_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Notas de cr&eacute;dito</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("nc_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Mandato Transbank</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("mtransbank_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Notas de cargo</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("ncargo_sede_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Comprobantes de ingreso </th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("cingreso_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right">Total Documento (Alumno Empresa)</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("d_al_empresa_ip")%>
                  </div></td>
              </tr>
              <tr> 
                <th align="right" nowrap>Total de Factura Intercompa&ntilde;&iacute;a</th>
                <td align="center">:</td>
                <td align="right"> <div align="left"> 
                    <%fcuadre.dibujaCampo("fact_intercia_ip")%>
                  </div></td>
              </tr>
              <tr>
                <th align="right">Total Abono por Reconoc. de Pago</th>
                <td align="center">:</td>
                <td>
                  <%fcuadre.dibujaCampo("arecp_ip")%>
                </td>
              </tr>
              <tr> 
                <th align="right"><font size="2">Total</font></th>
                <td align="center"><font size="2">:</font></td>
                <td><font size="2"> 
                  <%fcuadre.dibujaCampo("total_ip")%>
                  </font></td>
              </tr>
            </table></td>
          </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr align="center"> 
          <td><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <th align="right">&nbsp;</th>
                <td width="3%">&nbsp;</td>
                <td width="48%">&nbsp;</td>
              </tr>
              <tr> 
                <th width="49%" align="right"><font size="2">Total efectivo </font></th>
                <td align="right" nowrap><div align="center"><font size="2">:</font></div></td>
                <td align="right" nowrap> <div align="left"><font size="2"> <%= efectivo_f %> </font></div></td>
              </tr>
              <tr> 
                <th height="18" align="right"><font size="2">Total documentos 
                  </font></th>
                <td align="right" nowrap><div align="center"><font size="2">:</font></div></td>
                <td align="right" nowrap> <div align="left"><font size="2"> 
                    <%fcuadre.dibujaCampo("total_ip")%>
                    </font></div></td>
              </tr>
              <tr> 
                <th align="right" nowrap><strong><font size="4">Total rendici&oacute;n 
                  </font></strong></th>
                <td align="right" nowrap><div align="center"><font size="4">:</font></div></td>
                <td align="right" nowrap><div align="left"><strong><font size="4"> 
                    <%=total_f%> </font></strong></div></td>
              </tr>
            </table></td>
        </tr>
      </table>
      
    </td>
  </tr>
</table>
				    </form>
				    <hr noshade>
                    <br>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><h2 align="center">Rendici&oacute;n Cajero</h2>
                        </td>
                      </tr>
                      <tr>
                        <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
                            <tr align="center">
                              <td width="49%" bgcolor="#CECECE"><font size="2"><strong>UAS</strong></font></td>
                            </tr>
                            <tr>
                              <td><table width="100%" border="0" align="center">
                                  <tr>
                                    <th width="394" align="right">Total cedentes</th>
                                    <td width="25" align="center">:</td>
                                    <td width="233" align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_cedentes_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total remesas</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_remesas_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total de cheques al d&iacute;a</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_cheques_dia_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total de tarjetas de cr&eacute;dito</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_tarj_credito_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total Vale Vista</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_vvista_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total Nota de Cr&eacute;dito</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_ncredito_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right" nowrap>Total Mandato Transbank</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_transbank_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right" nowrap>Total de Documento
                                      (Alumno Empresa)</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_d_al_empresa_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right" nowrap>Total de Factura
                                      Intercompa&ntilde;&iacute;a</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_df_intercia_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total Abono por Reconoc.
                                      de Pago</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_arp_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right"><font size="2">Total disponible</font></th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("t_disponible_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Total cheques a fecha</th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("mcaj_mrend_cheques_fecha_ip")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right"><font size="2">Total documentos</font></th>
                                    <td align="center">:</td>
                                    <td align="left">
                                      <%formulario.dibujaCampo("t_rend1_ip")%>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td align="center">&nbsp;                                </td>
                            </tr>
                            <tr>
                              <td> <br>
                                  <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                      <th align="right"><div align="right"></div>
                                      </th>
                                      <td width="3%">&nbsp;</td>
                                      <td width="48%"><div align="left"></div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th width="49%" align="left"><div align="right"><font size="2">Total
                                            efectivo </font></div>
                                      </th>
                                      <td align="center"><strong>:</strong></td>
                                      <td align="right" nowrap>
                                        <div align="left"><font size="2">
                                          <%formulario.dibujaCampo("mcaj_mrend_efectivo")%>
                                        </font></div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th align="left"><div align="right"><font size="2">Total
                                            documentos </font></div>
                                      </th>
                                      <td align="center"><strong>:</strong></td>
                                      <td align="right" nowrap>
                                        <div align="left"><font size="2">
                                          <%formulario.dibujaCampo("t_rend1_ip1")%>
                                        </font></div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th align="left" nowrap><div align="right"><strong><font size="4">Total
                                              rendici&oacute;n </font></strong></div>
                                      </th>
                                      <td align="center"><strong>:</strong></td>
                                      <td align="right" nowrap><div align="left"><strong><font size="4">
                                          <%formulario.dibujaCampo("t_rend1")%>
                                        </font></strong></div>
                                      </td>
                                    </tr>
                                  </table>
                                  <br>
                              </td>
                            </tr>
                            <tr>
                              <th bgcolor="#CCCCCC">CONTROL DE CORRELATIVOS</th>
                            </tr>
                            <tr align="center">
                              <td bgcolor="#CECECE"><font size="2"><strong>UAS</strong></font></td>
                            </tr>
                            <tr>
                              <td><table border="0">
                                  <tr>
                                    <td width="100">&nbsp;</td>
                                    <td width="10">&nbsp;</td>
                                    <th width="60" align="right">Monto</th>
                                    <th width="60" align="right">Desde</th>
                                    <th width="60" align="right">Hasta</th>
                                  </tr>
                                  <tr>
                                    <th align="right">Boletas</th>
                                    <td align="center">:</td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_mrend_boletas_ip")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nboletas_ip_desde")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nboletas_ip_hasta")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Notas de d&eacute;bito</th>
                                    <td align="center">:</td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_mrend_notas_debito_ip")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nnotas_debito_ip_desde")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nnotas_debito_ip_hasta")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Notas de cr&eacute;dito</th>
                                    <td align="center">:</td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_mrend_notas_credito_ip")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nnotas_credito_ip_desde")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nnotas_credito_ip_hasta")%>
                                    </td>
                                  </tr>
                                  <tr>
                                    <th align="right">Notas de cargo</th>
                                    <td align="center">:</td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_mrend_notas_cargo_ip")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nnotas_cargo_ip_desde")%>
                                    </td>
                                    <td align="right">
                                      <%formulario.dibujaCampo("mcaj_nnotas_cargo_ip_hasta")%>
                                    </td>
                                  </tr>
                                </table>
                                  <table width="312" border="0">
                                    <tr>
                                      <th align="right">&nbsp;</th>
                                      <td align="center">&nbsp;</td>
                                      <th width="60" align="right">Monto</th>
                                      <th width="60" align="right">Cantidad</th>
                                    </tr>
                                    <tr>
                                      <th align="right" nowrap>Facturas (Alumno
                                        Empresa)</th>
                                      <td align="center">:</td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("mcaj_mrend_d_al_empresa_ip")%>
                                      </td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("mcaj_nfacturas_ae_ip")%>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th align="right">Factura Intercompa&ntilde;ia</th>
                                      <td align="center">:</td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("mcaj_mrend_f_intercia_ip")%>
                                      </td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("mcaj_nfintercia_ip")%>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th width="100" align="right">Facturas</th>
                                      <td width="10" align="center">:</td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("mcaj_mrend_facturas_ip")%>
                                      </td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("mcaj_nfacturas_ip")%>
                                      </td>
                                    </tr>
                                    <tr>
                                      <th align="right">Total rendido</th>
                                      <td align="center">&nbsp;</td>
                                      <td align="right">
                                        <%formulario.dibujaCampo("t_rend2_ip")%>
                                      </td>
                                      <td align="right">&nbsp;</td>
                                    </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>                    <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="101%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="81" bgcolor="#D8D8DE">&nbsp;</td>
                  <td width="576" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="20" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
