<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "parametros.xml", "btn_rendicion_cajas"

set negocio = new cNegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "desauas"
formulario.carga_parametros "parametros.xml", "comp_rendicion_de_cajas"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

usuario = negocio.obtenerUsuario
cajero_cons = "select caje_ccod from personas a, cajeros b where a.pers_ncorr=b.pers_ncorr and  pers_nrut=" & usuario & " and sede_ccod=" & sede

cajero = conectar.consultaUno(cajero_cons)

mcaj_ncorr_cons = "select mcaj_ncorr from movimientos_cajas where caje_ccod='" & cajero & "' " & _
				" and sede_ccod=" & sede & " and eren_ccod=1"
mcaj_ncorr = conectar.consultaUno(mcaj_ncorr_cons)
if isnull(mcaj_ncorr) then
	session("mensajeError") = "ERROR:\nNo puede rendir una caja si no existe una abierta"
	response.Redirect("../lanzadera/lanzadera.asp")
else
	rendicion_cons = "select sysdate as mcaj_ftermino, 2 as eren_ccod, mcaj_ncorr as mcaj_ncorr_paso, a.* , sysdate as fecha_emision, pers_nrut || '-' || pers_xdv as pers_nrut, pers_tape_paterno || ' ' || pers_tape_materno || ', ' || pers_tnombre as cajero " & _ 
					", nvl(mcaj_mrend_cupones_can_ip,0) +nvl(mcaj_mrend_sd_saes_ip,0) + nvl(mcaj_mrend_reco_beca_ip,0)+nvl(mcaj_mrend_sinsoluto_ip,0)+ nvl(mcaj_mrend_reco_seguro_ip,0) + nvl(mcaj_mrend_abono_bech_ip,0) + nvl(mcaj_mrend_ncredito_ip,0) as t_disponible_ip " & _
					", nvl(mcaj_mrend_cupones_can_ip,0) +nvl(mcaj_mrend_sd_saes_ip,0) + nvl(mcaj_mrend_reco_beca_ip,0)+nvl(mcaj_mrend_sinsoluto_ip,0)+ nvl(mcaj_mrend_reco_seguro_ip,0) + nvl(mcaj_mrend_abono_bech_ip,0) + nvl(mcaj_mrend_ncredito_ip,0) as t_rend1_ip " & _
					", nvl(mcaj_mrend_cupones_can_ip,0) +nvl(mcaj_mrend_sd_saes_ip,0) + nvl(mcaj_mrend_reco_beca_ip,0)+nvl(mcaj_mrend_sinsoluto_ip,0)+ nvl(mcaj_mrend_reco_seguro_ip,0) + nvl(mcaj_mrend_abono_bech_ip,0) + nvl(mcaj_mrend_ncredito_ip,0) as t_rend1_ip1 " & _
					", nvl(mcaj_mrend_boletas_ip,0) + nvl(mcaj_mrend_facturas_ip ,0)+ nvl(mcaj_mrend_facturas_ae_ip ,0)+ nvl(mcaj_mrend_notas_debito_ip,0) + nvl(mcaj_mrend_notas_credito_ip,0) + nvl(mcaj_mrend_notas_cargo_ip,0) as t_rend2_ip " & _
					", nvl(mcaj_mrend_cupones_can_ip,0) +nvl(mcaj_mrend_sd_saes_ip,0) + nvl(mcaj_mrend_reco_beca_ip,0)+nvl(mcaj_mrend_sinsoluto_ip,0)+ nvl(mcaj_mrend_reco_seguro_ip,0) + nvl(mcaj_mrend_abono_bech_ip,0)  + nvl(mcaj_mrend_ncredito_ip,0) " & _
					" from movimientos_cajas a, cajeros b, personas c where a.caje_ccod=b.caje_ccod and a.sede_ccod=b.sede_ccod and b.pers_ncorr=c.pers_ncorr and mcaj_ncorr = " & mcaj_ncorr				
	formulario.consultar rendicion_cons
	formulario.siguiente
	formulario.consultar rendicion_cons
	formulario.siguiente
%>


<html>
<head>
<title>Rendicion de cajas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function valida(formulario) {
	nroElementos = formulario.elements.length;
	for( i = 0; i < nroElementos; i++ ) {
		er = /(\w+)/gi;
		s = formulario.elements[i].name;
		if((m = s.match(er))!=null) {
			if(m.length==3) {
				if(!(valor=Number(formulario.elements[i].value))) {
					valor=0;
				}
				if(m[0].substr(0,1)!='_' ){
					switch(m[2]) {
						case 'mcaj_nboletas_ip_desde' :
							mcaj_nboletas_ip_desde = valor;
							break;
						case 'mcaj_nboletas_ip_hasta' :
							mcaj_nboletas_ip_hasta = valor;
							break
						case 'mcaj_nnotas_cargo_ip_desde' :
							mcaj_nnotas_cargo_ip_desde = valor;
							break;
						case 'mcaj_nnotas_cargo_ip_hasta' :
							mcaj_nnotas_cargo_ip_hasta = valor;
							break
						case 't_rend1_ip' :
							t_rend1_ip = formulario.elements[i].value;
							break;
						case 't_rend2_ip' :
							t_rend2_ip = formulario.elements[i].value;
							break;
						case 't_rend1' :
							t_rend1 = formulario.elements[i].value;
							break;				
					}
				}
			}
		}
	}
	flag = true;
	error = '';
//	if(t_rend1_ip>t_rend2_ip){
//		error += 'Total de ingresos en documentos IP no puede ser mayor que el total en documentos emitidos\n';
//		flag = false;
//	}
//	if(t_rend1_cft>t_rend2_cft){
//		error += 'Total de ingresos en documentos CFT no puede ser mayor que el total en documentos emitidos\n';
//		flag = false;
//	}
	if(mcaj_nboletas_ip_desde>mcaj_nboletas_ip_hasta){
		error += 'Inicio de correlativo de boletas IP no puede ser mayor que término\n';
		flag = false;
	}
	if(Number(t_rend2_ip) != Number(t_rend1)) {
		error += 'El total de ingresos no cuadra con el total en documentos';
		flag = false;
	}
	if(!flag) {
		alert(error);
	}
	return(flag);
}

function totaliza(elemento) {
	formulario = elemento.form;
	nroElementos = formulario.elements.length;
	suma1 = 0;
	suma2 = 0;
	suma3 = 0;
	suma4 = 0;
	suma5 = 0;
	suma6 = 0;
	for( i = 0; i < nroElementos; i++ ) {
		er = /(\w+)/gi;
		s = formulario.elements[i].name;
		if((m = s.match(er))!=null) {
			if(m.length==3) {
				if(!(valor=Number(formulario.elements[i].value))) {
					valor=0;
				}
				if(m[0].substr(0,1)!='_' ){
					switch(m[2]) {
						case 'mcaj_mrend_efectivo' :
							efectivo = valor;
							break;
						case 'mcaj_mrend_cheques_fecha_ip' :
							suma2 += valor;
							break
						case 'mcaj_mrend_cupones_can_ip' :
						case 'mcaj_mrend_reco_beca_ip' :
						case 'mcaj_mrend_reco_seguro_ip' :
						case 'mcaj_mrend_sinsoluto_ip' :
						case 'mcaj_mrend_abono_bech_ip' :
							suma1 += valor;
							break;
						case 'mcaj_mrend_boletas_ip' :
						case 'mcaj_mrend_facturas_ip' :
						case 'mcaj_mrend_facturas_ae_ip' :
						case 'mcaj_mrend_cupones_ip' :
						case 'mcaj_mrend_comp_ingresos_ip' :
							suma3 += valor;
							break;
						case 't_disponible_ip' :
							t_disponible_ip = formulario.elements[i];
							break;
						case 't_rend1_ip' :
							t_rend1_ip = formulario.elements[i];
							break;
						case 't_rend2_ip' :
							t_rend2_ip = formulario.elements[i];
							break;
						case 't_rend1' :
							t_rend1 = formulario.elements[i];
							break;				
					}
				}
				else{
					switch(m[2]) {
						case 't_disponible_ip' :
							_t_disponible_ip = formulario.elements[i];
							break;
						case 't_rend1_ip' :
							_t_rend1_ip = formulario.elements[i];
							break;
						case 't_rend1_ip1' :
							_t_rend1_ip1 = formulario.elements[i];
							break;
						case 't_rend2_ip' :
							_t_rend2_ip = formulario.elements[i];
							break;
						case 't_rend1' :
							_t_rend1 = formulario.elements[i];
							break;				
					}
				}
			}
		}
	}
	_t_disponible_ip.value = suma1;
	_t_rend1_ip.value = suma1 + suma2;
	_t_rend1_ip1.value = suma1 + suma2;
	_t_rend2_ip.value = suma3;
	_t_rend1.value = suma1 + suma2 + efectivo;
	enMascara(_t_disponible_ip,'MONEDA',0);
	enMascara(_t_rend1_ip,'MONEDA',0);
	enMascara(_t_rend1_ip1,'MONEDA',0);
	enMascara(_t_rend2_ip,'MONEDA',0);
	enMascara(_t_rend1,'MONEDA',0);
}

function guardar(formulario){
 if(valida(formulario)){
	  formulario.submit();
 }
 else{
	 formulario.submit();
	}
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

//-->

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
//-->
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Rendici&oacute;n
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
        <form action="rendicion_cajas_proc.asp" method="post" name="editar">
			          <div align="center">
			            <p><font size="+1">Rendici&oacute;n de caja</font>
	</p>
			          </div>
			          <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
                      <table width="100%" border="0">
                        <tr> 
                          <td> <table width="100%" border="0">
                              <tr> 
                                <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td align="right">Cajero :</td>
                                      <td> <%formulario.dibujaCampo("cajero")%> </td>
                                      <td width="200" align="right">Folio :</td>
                                      <td width="200" nowrap> <%formulario.dibujaCampo("mcaj_ncorr_paso")%> </td>
                                    </tr>
                                    <tr> 
                                      <td align="right">Rut :</td>
                                      <td> <%formulario.dibujaCampo("pers_nrut")%> </td>
                                      <td align="right">Apertura :</td>
                                      <td> <%formulario.dibujaCampo("mcaj_finicio")%> </td>
                                    </tr>
                                    <tr> 
                                      <td align="right">&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td align="right" nowrap>Fecha emisi&oacute;n 
                                        :</td>
                                      <td> <%formulario.dibujaCampo("fecha_emision")%> </td>
                                    </tr>
                                  </table></td>
                              </tr>
                              <tr> 
                                <th><p>&nbsp;</p>
                                  <p><strong><font size="3">DETALLE DE DINERO 
                                    RECIBIDO</font></strong></p></th>
                              </tr>
                              <tr> 
                                <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
                                    <tr align="center"> 
                                      <td bgcolor="#CECECE"><font size="2"><strong>UAS</strong></font></td>
                                      </tr>
                                    <tr> 
                                      <td><table border="0">
                                          <tr> 
                                            <th align="right">Total Cupones Cancelados</th>
                                            <td align="center">:</td>
                                            <td width="100" align="right"> <%formulario.dibujaCampo("mcaj_mrend_cupones_can_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Falta Reconoer 
                                              Beca </th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_reco_beca_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Falta Reconoer 
                                              Seguro</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_reco_seguro_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Abono Saldo 
                                              Insoluto </th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_sinsoluto_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              disponible</font></th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_disponible_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              documentos</font></th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_rend1_ip")%> </td>
                                          </tr>
                                        </table></td>
                                      </tr>
                                    <tr> 
                                      <td> <br> <table width="401" border="1" align="center" cellpadding="0" cellspacing="0">
                                          <tr> 
                                            <td width="397"><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr> 
                                                  <th align="right">&nbsp;</th>
                                                  <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <th width="50%" align="right"><font size="2">Total 
                                                    efectivo :</font></th>
                                                  <td align="right"> <font size="2"> 
                                                    <%formulario.dibujaCampo("mcaj_mrend_efectivo")%>
                                                    </font></td>
                                                </tr>
                                                <tr> 
                                                  <th align="right"><font size="2">Total
                                                      documentos :</font></th>
                                                  <td align="right"> <font size="2"> 
                                                    <%formulario.dibujaCampo("t_rend1_ip1")%>
                                                    </font></td>
                                                </tr>
                                                <tr> 
                                                  <th align="right" nowrap><strong><font color="#000000" size="4">Total 
                                                    rendici&oacute;n : </font></strong></th>
                                                  <td align="right"><strong><font size="4"> 
                                                    <%formulario.dibujaCampo("t_rend1")%>
                                                    </font></strong></td>
                                                </tr>
                                                <tr> 
                                                  <th align="right">&nbsp;</th>
                                                  <td>&nbsp;</td>
                                                </tr>
                                              </table></td>
                                          </tr>
                                        </table>
                                        <br>
</td>
                                    </tr>
                                    <tr> 
                                      <th bgcolor="#CCCCCC">CONTROL 
                                        DE CORRELATIVOS</th>
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
                                        </table>
                                        <table border="0">
                                          <tr> 
                                            <th align="right">&nbsp;</th>
                                            <td align="center">&nbsp;</td>
                                            <th width="60" align="right">Monto</th>
                                            <th width="60" align="right">Cantidad</th>
                                          </tr>
                                          <tr> 
                                            <th width="100" align="right">Facturas</th>
                                            <td width="10" align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_facturas_ip")%> </td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_nfacturas_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total rendido</th>
                                            <td align="center">&nbsp;</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_rend2_ip")%> </td>
                                            <td align="right">&nbsp;</td>
                                          </tr>
                                        </table></td>
                                      </tr>
                                  </table></td>
                              </tr>
                            </table>
                            <%formulario.dibujaCampo("mcaj_ncorr")%>
                            <%formulario.dibujaCampo("eren_ccod")%>
                            <%formulario.dibujaCampo("mcaj_ftermino")%>
                          </td>
                        </tr>
                        <tr> 
                          <td align="right"><%botonera.dibujaboton "guardar"%>
                          </td>
                        </tr>
                      </table>
                      <strong><font color="000000" size="1"> </font></strong></td>
                  </tr>
                </table>
				    </form>
				 </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="106" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="37%"><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="256" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
<%
end if
%>
