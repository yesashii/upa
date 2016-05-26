<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_inacap.asp" -->
<%
set inacap = new cInacap
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "siga"
formulario.carga_parametros "parametros.xml", "comp_rendicion_de_cajas"
formulario.inicializar conectar
inacap.inicializa conectar
sede=inacap.obtenerSede

usuario = inacap.obtenerUsuario
cajero_cons = "select caje_ccod from personas a, cajeros b where a.pers_ncorr=b.pers_ncorr and  pers_nrut=" & usuario & " and sede_ccod=" & sede

cajero = conectar.consultaUno(cajero_cons)

mcaj_ncorr_cons = "select mcaj_ncorr from movimientos_cajas where caje_ccod='" & cajero & "' " & _
				" and sede_ccod=" & sede & " and eren_ccod=1"

mcaj_ncorr = conectar.consultaUno(mcaj_ncorr_cons)
if isnull(mcaj_ncorr) then
	session("mensajeError") = "ERROR:\nNo puede rendir una caja si no existe una abierta"
	response.Redirect("portada.asp")
else
	rendicion_cons = "select sysdate as mcaj_ftermino, 2 as eren_ccod, mcaj_ncorr as mcaj_ncorr_paso, a.* , sysdate as fecha_emision, pers_nrut || '-' || pers_xdv as pers_nrut, pers_tape_paterno || ' ' || pers_tape_materno || ', ' || pers_tnombre as cajero " & _ 
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0) + nvl(mcaj_mrend_df_intercia_ip,0) + nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+ nvl(mcaj_mrend_arp_ip,0)+ nvl(mcaj_mrend_ncredito_ip,0)+ nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) as t_disponible_ip " & _
					",  nvl(mcaj_mrend_tarj_credito_ca,0) +  nvl(mcaj_mrend_dep_banco_ca,0) + nvl(mcaj_mrend_cheques_dia_ca,0) as t_disponible_ca " & _
					", nvl(mcaj_mrend_tarj_credito_ca,0)+  nvl(mcaj_mrend_dep_banco_ca,0)  + nvl(mcaj_mrend_cheques_dia_ca,0) + nvl(mcaj_mrend_cheques_fecha_ca,0) as t_rend1_ca " & _
					", nvl(mcaj_mrend_tarj_credito_ca,0) + nvl(mcaj_mrend_dep_banco_ca,0) + nvl(mcaj_mrend_cheques_dia_ca,0) + nvl(mcaj_mrend_cheques_fecha_ca,0) as t_rend1_ca1 " & _
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0) + nvl(mcaj_mrend_df_intercia_ip,0) +  nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+  nvl(mcaj_mrend_arp_ip,0)+ nvl(mcaj_mrend_ncredito_ip,0)+nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) + nvl(mcaj_mrend_cheques_fecha_ip,0) as t_rend1_ip " & _
					", nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0) + nvl(mcaj_mrend_df_intercia_ip,0) + nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0) +  nvl(mcaj_mrend_arp_ip,0)+ nvl(mcaj_mrend_ncredito_ip,0)+nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) + nvl(mcaj_mrend_cheques_fecha_ip,0) as t_rend1_ip1 " & _
					", nvl(mcaj_mrend_boletas_ip,0) + nvl(mcaj_mrend_facturas_ip ,0)+ nvl(mcaj_mrend_facturas_ae_ip ,0) + nvl(mcaj_mrend_f_intercia_ip,0) + nvl(mcaj_mrend_notas_debito_ip,0) + nvl(mcaj_mrend_notas_credito_ip,0) + nvl(mcaj_mrend_notas_cargo_ip,0) as t_rend2_ip " & _
					", nvl(mcaj_mrend_boletas_ca,0) + nvl(mcaj_mrend_facturas_ca ,0) as t_rend2_ca " & _
					", nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_df_intercia_cft,0) + nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0) + nvl(mcaj_mrend_ncredito_cft,0)+nvl(mcaj_mrend_tarj_credito_cft,0) + nvl(mcaj_mrend_cheques_dia_cft,0) as t_disponible_cft " & _
					", nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_df_intercia_cft,0) + nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0) + nvl(mcaj_mrend_ncredito_cft,0)+ nvl(mcaj_mrend_tarj_credito_cft,0) + nvl(mcaj_mrend_cheques_dia_cft,0) + nvl(mcaj_mrend_cheques_fecha_cft,0) as t_rend1_cft " & _
					", nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_df_intercia_cft,0) + nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0) + nvl(mcaj_mrend_ncredito_cft,0)+ nvl(mcaj_mrend_tarj_credito_cft,0) + nvl(mcaj_mrend_cheques_dia_cft,0) + nvl(mcaj_mrend_cheques_fecha_cft,0) as t_rend1_cft1 " & _
					", nvl(mcaj_mrend_boletas_cft,0) + nvl(mcaj_mrend_facturas_cft ,0)+ nvl(mcaj_mrend_facturas_ae_cft ,0)+  nvl(mcaj_mrend_f_intercia_cft ,0)+ nvl(mcaj_mrend_notas_debito_cft,0) + nvl(mcaj_mrend_notas_credito_cft,0) + nvl(mcaj_mrend_notas_cargo_cft,0) as t_rend2_cft " & _
					",  nvl(mcaj_mrend_tarj_credito_ca,0) +  nvl(mcaj_mrend_dep_banco_ca,0) + nvl(mcaj_mrend_cheques_dia_ca,0) + nvl(mcaj_mrend_cheques_fecha_ca,0) " & _
					" + nvl(mcaj_mrend_cedentes_ip,0) + nvl(mcaj_mrend_remesas_ip,0)+ nvl(mcaj_mrend_d_al_empresa_ip,0) + nvl(mcaj_mrend_df_intercia_ip,0) + nvl(mcaj_mrend_transbank_ip,0) + nvl(mcaj_mrend_vvista_ip,0)+  nvl(mcaj_mrend_arp_ip,0)+ nvl(mcaj_mrend_ncredito_ip,0)+ nvl(mcaj_mrend_tarj_credito_ip,0) + nvl(mcaj_mrend_cheques_dia_ip,0) + nvl(mcaj_mrend_cheques_fecha_ip,0) " & _
					"+ nvl(mcaj_mrend_cedentes_cft,0) + nvl(mcaj_mrend_remesas_cft,0) + nvl(mcaj_mrend_d_al_empresa_cft,0) + nvl(mcaj_mrend_df_intercia_cft,0) + nvl(mcaj_mrend_transbank_cft,0) + nvl(mcaj_mrend_vvista_cft,0)+ nvl(mcaj_mrend_arp_cft,0) + nvl(mcaj_mrend_ncredito_cft,0)+nvl(mcaj_mrend_tarj_credito_cft,0) + nvl(mcaj_mrend_cheques_dia_cft,0) + nvl(mcaj_mrend_cheques_fecha_cft,0) + nvl(mcaj_mrend_efectivo,0) as t_rend1 " & _
					" from movimientos_cajas a, cajeros b, personas c where a.caje_ccod=b.caje_ccod and a.sede_ccod=b.sede_ccod and b.pers_ncorr=c.pers_ncorr and mcaj_ncorr = " & mcaj_ncorr				
	formulario.consultar rendicion_cons
	formulario.siguiente
	formulario.consultar rendicion_cons
	formulario.siguiente	

'response.Write(rendicion_cons)

%>
<html>
<head>
<title>Rendicion de cajas</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="../biblioteca/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="../biblioteca/funciones.js"> </SCRIPT>

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
						case 'mcaj_nboletas_ca_desde' :
							mcaj_nboletas_ca_desde = valor;
							break;
						case 'mcaj_nboletas_ca_hasta' :
							mcaj_nboletas_ca_hasta = valor;
							break;
						case 'mcaj_nboletas_ip_desde' :
							mcaj_nboletas_ip_desde = valor;
							break;
						case 'mcaj_nboletas_ip_hasta' :
							mcaj_nboletas_ip_hasta = valor;
							break;
						case 'mcaj_nboletas_cft_desde' :
							mcaj_nboletas_cft_desde = valor;
							break;
						case 'mcaj_nboletas_cft_hasta' :
							mcaj_nboletas_cft_hasta = valor;
							break;
						case 'mcaj_nnotas_credito_ip_desde' :
							mcaj_nnotas_credito_ip_desde = valor;
							break;
						case 'mcaj_nnotas_credito_ip_hasta' :
							mcaj_nnotas_credito_ip_hasta = valor;
							break;
						case 'mcaj_nnotas_credito_cft_desde' :
							mcaj_nnotas_credito_cft_desde = valor;
							break;
						case 'mcaj_nnotas_credito_cft_hasta' :
							mcaj_nnotas_credito_cft_hasta = valor;
							break;
						case 'mcaj_nnotas_cargo_ip_desde' :
							mcaj_nnotas_cargo_ip_desde = valor;
							break;
						case 'mcaj_nnotas_cargo_ip_hasta' :
							mcaj_nnotas_cargo_ip_hasta = valor;
							break;
						case 'mcaj_nnotas_cargo_cft_desde' :
							mcaj_nnotas_cargo_cft_desde = valor;
							break;
						case 'mcaj_nnotas_cargo_cft_hasta' :
							mcaj_nnotas_cargo_cft_hasta = valor;
							break;
						case 'mcaj_nnotas_debito_ip_desde' :
							mcaj_nnotas_debito_ip_desde = valor;
							break;
						case 'mcaj_nnotas_debito_ip_hasta' :
							mcaj_nnotas_debito_ip_hasta = valor;
							break
						case 'mcaj_nnotas_debito_cft_desde' :
							mcaj_nnotas_debito_cft_desde = valor;
							break;
						case 'mcaj_nnotas_debito_cft_hasta' :
							mcaj_nnotas_debito_cft_hasta = valor;
							break;
						case 't_rend1_ip' :
							t_rend1_ip = formulario.elements[i].value;
							break;
						case 't_rend1_ca' :
							t_rend1_ca = formulario.elements[i].value;
							break;
						case 't_rend1_cft' :
							t_rend1_cft = formulario.elements[i].value;
							break;
						case 't_rend2_ip' :
							t_rend2_ip = formulario.elements[i].value;
							break;
						case 't_rend2_ca' :
							t_rend2_ca = formulario.elements[i].value;
							break;
						case 't_rend2_cft' :
							t_rend2_cft = formulario.elements[i].value;
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
	if(mcaj_nboletas_cft_desde>mcaj_nboletas_cft_hasta){
		error += 'Inicio de correlativo de boletas CFT no puede ser mayor que término\n';
		flag = false;
	}
	if(mcaj_nnotas_debito_ip_desde>mcaj_nnotas_debito_ip_hasta){
		error += 'Inicio de correlativo de notas de débito IP no puede ser mayor que término\n';
		flag = false;
	}
	if(mcaj_nnotas_debito_cft_desde>mcaj_nnotas_debito_cft_hasta){
		error += 'Inicio de correlativo de notas de débito CFT no puede ser mayor que término\n';
		flag = false;
	}
	if(mcaj_nnotas_cargo_ip_desde>mcaj_nnotas_cargo_ip_hasta){
		error += 'Inicio de correlativo de notas de cargo IP no puede ser mayor que término\n';
		flag = false;
	}
	if(mcaj_nnotas_cargo_cft_desde>mcaj_nnotas_cargo_cft_hasta){
		error += 'Inicio de correlativo de notas de cargo CFT no puede ser mayor que término\n';
		flag = false;
	}
	if(mcaj_nnotas_credito_ip_desde>mcaj_nnotas_credito_ip_hasta){
		error += 'Inicio de correlativo de notas de crédito IP no puede ser mayor que término\n';
		flag = false;
	}
	if(mcaj_nnotas_credito_cft_desde>mcaj_nnotas_credito_cft_hasta){
		error += 'Inicio de correlativo de notas de crédito CFT no puede ser mayor que término\n';
		flag = false;
	}
	if(Number(t_rend2_ip) + Number(t_rend2_cft) + Number(t_rend2_ca) != Number(t_rend1)) {
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
	suma7 = 0;
	suma8 = 0;
	suma9 = 0;
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
						// capacitacion  
						case 'mcaj_mrend_cheques_fecha_ca' :
							suma7 += valor;
							break;
						case 'mcaj_mrend_cheques_dia_ca' :
						case 'mcaj_mrend_tarj_credito_ca' :
						case 'mcaj_mrend_dep_banco_ca' :
							suma8 += valor;
							break;
						case 'mcaj_mrend_boletas_ca' :
						case 'mcaj_mrend_facturas_ca' :
							suma9 += valor;
							break;
						// capacitacion
						case 'mcaj_mrend_cheques_fecha_ip' :
							suma2 += valor;
							break
						case 'mcaj_mrend_cedentes_ip' :
						case 'mcaj_mrend_remesas_ip' :
						case 'mcaj_mrend_cheques_dia_ip' :
						case 'mcaj_mrend_tarj_credito_ip' :
						case 'mcaj_mrend_d_al_empresa_ip' :
						case 'mcaj_mrend_df_intercia_ip':
						case 'mcaj_mrend_transbank_ip' :
						case 'mcaj_mrend_vvista_ip':
						case 'mcaj_mrend_arp_ip':
						case 'mcaj_mrend_ncredito_ip':
							suma1 += valor;
							break;
						case 'mcaj_mrend_boletas_ip' :
						case 'mcaj_mrend_facturas_ip' :
						case 'mcaj_mrend_facturas_ae_ip' :
						case 'mcaj_mrend_f_intercia_ip' :
						case 'mcaj_mrend_notas_debito_ip' :
						case 'mcaj_mrend_notas_credito_ip' :
						case 'mcaj_mrend_cupones_ip' :
						case 'mcaj_mrend_notas_cargo_ip' :
						case 'mcaj_mrend_comp_ingresos_ip' :
							suma3 += valor;
							break;
						case 'mcaj_mrend_cheques_fecha_cft' :
							suma5 += valor;
							break
						case 'mcaj_mrend_cedentes_cft' :
						case 'mcaj_mrend_remesas_cft' :
						case 'mcaj_mrend_cheques_dia_cft' :
						case 'mcaj_mrend_tarj_credito_cft' :
						case 'mcaj_mrend_d_al_empresa_cft' :
						case 'mcaj_mrend_df_intercia_cft':
						case 'mcaj_mrend_transbank_cft' :
						case 'mcaj_mrend_vvista_cft' :
						case 'mcaj_mrend_arp_cft' :
						case 'mcaj_mrend_ncredito_cft' :
							suma4 += valor;
							break;
						case 'mcaj_mrend_boletas_cft' :
						case 'mcaj_mrend_facturas_cft' :
						case 'mcaj_mrend_facturas_ae_cft' :
						case 'mcaj_mrend_f_intercia_cft':
						case 'mcaj_mrend_notas_debito_cft' :
						case 'mcaj_mrend_notas_credito_cft' :
						case 'mcaj_mrend_cupones_cft' :
						case 'mcaj_mrend_notas_cargo_cft' :
						case 'mcaj_mrend_comp_ingresos_cft' :
							suma6 += valor;
							break;
						case 't_disponible_ip' :
							t_disponible_ip = formulario.elements[i];
							break;
						case 't_disponible_ca' :
							t_disponible_ca = formulario.elements[i];
							break;
						case 't_disponible_cft' :
							t_disponible_cft = formulario.elements[i];
							break;
						case 't_rend1_ip' :
							t_rend1_ip = formulario.elements[i];
							break;
						case 't_rend1_ca' :
							t_rend1_ca = formulario.elements[i];
							break;
						case 't_rend1_cft' :
							t_rend1_cft = formulario.elements[i];
							break;
						case 't_rend2_ip' :
							t_rend2_ip = formulario.elements[i];
							break;
						case 't_rend2_ca' :
							t_rend2_ca = formulario.elements[i];
							break;
						case 't_rend2_cft' :
							t_rend2_cft = formulario.elements[i];
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
						case 't_disponible_ca' :
							_t_disponible_ca = formulario.elements[i];
							break;
						case 't_disponible_cft' :
							_t_disponible_cft = formulario.elements[i];
							break;
						case 't_rend1_ip' :
							_t_rend1_ip = formulario.elements[i];
							break;
						case 't_rend1_ca' :
							_t_rend1_ca = formulario.elements[i];
							break;
						case 't_rend1_cft' :
							_t_rend1_cft = formulario.elements[i];
							break;
						case 't_rend1_ip1' :
							_t_rend1_ip1 = formulario.elements[i];
							break;
						case 't_rend1_ca1' :
							_t_rend1_ca1 = formulario.elements[i];
							break;
						case 't_rend1_cft1' :
							_t_rend1_cft1 = formulario.elements[i];
							break;
						case 't_rend2_ip' :
							_t_rend2_ip = formulario.elements[i];
							break;
						case 't_rend2_ca' :
							_t_rend2_ca = formulario.elements[i];
							break;
						case 't_rend2_cft' :
							_t_rend2_cft = formulario.elements[i];
							break;
						case 't_rend1' :
							_t_rend1 = formulario.elements[i];
							break;				
					}
				}
			}
		}
	}
//capacitacion
	_t_disponible_ca.value = suma8;
	_t_rend1_ca.value = suma8 + suma7;
	_t_rend1_ca1.value = suma8 + suma7;
	_t_rend2_ca.value = suma9;
	enMascara(_t_disponible_ca,'MONEDA',0);
	enMascara(_t_rend1_ca,'MONEDA',0);
	enMascara(_t_rend1_ca1,'MONEDA',0);
	enMascara(_t_rend2_ca,'MONEDA',0);
//capacitacion
	_t_disponible_ip.value = suma1;
	_t_rend1_ip.value = suma1 + suma2;
	_t_rend1_ip1.value = suma1 + suma2;
	_t_rend2_ip.value = suma3;
	_t_disponible_cft.value = suma4;
	_t_rend1_cft.value = suma4 + suma5;
	_t_rend1_cft1.value = suma4 + suma5;
	_t_rend2_cft.value = suma6;
	_t_rend1.value = suma1 + suma2 + suma4 + suma5  + efectivo + suma7 + suma8 ;
	enMascara(_t_disponible_ip,'MONEDA',0);
	enMascara(_t_rend1_ip,'MONEDA',0);
	enMascara(_t_rend1_ip1,'MONEDA',0);
	enMascara(_t_rend2_ip,'MONEDA',0);
	enMascara(_t_disponible_cft,'MONEDA',0);
	enMascara(_t_rend1_cft,'MONEDA',0);
	enMascara(_t_rend1_cft1,'MONEDA',0);
	enMascara(_t_rend2_cft,'MONEDA',0);
	enMascara(_t_rend1,'MONEDA',0);
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



<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<!-- Fireworks MX Dreamweaver MX target.  Created Wed Oct 30 14:14:24 GMT+0100 (Hora estándar romance) 2002-->
</head>
<body bgcolor="#21559C" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/modificar_f2.gif','../imagenes/botones/salir_f2.gif')">
<br>
<table border="0" cellpadding="0" cellspacing="0" width="754" align="center">
  <!-- fwtable fwsrc="portada.png" fwbase="portada.gif" fwstyle="Dreamweaver" fwdocid = "863525517" fwnested="0" -->
  <tr> 
    <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="14" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="175" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="535" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="21" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="2"><img name="portada_r2_c1" src="../images/portada_r2_c1.gif" width="23" height="26" border="0" alt=""></td>
    <td><img name="portada_r2_c3" src="images/cajero.gif" width="175" height="26" border="0" alt=""></td>
    <td align="right" background="../images/portada_r2_c4.gif"><!-- #BeginLibraryItem "/Library/usuario.lbi" -->
<strong><font color="#FFFFFF"> <%=inacap.obtenerNombreUsuario%> - <%=inacap.obtenerNombreSede%> 
- <%=inacap.obtenerFechaActual%> </font> </strong><!-- #EndLibraryItem --></td>
    <td><img name="portada_r2_c5" src="../images/portada_r2_c5.gif" width="21" height="26" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="26" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="2" rowspan="2" background="../images/portada_r3_c1.gif">&nbsp;</td>
    <td rowspan="2" colspan="2" bgcolor="#2359A3"> <div align="center"> 
        <form action="rendicion_cajas_proc.asp" method="post" name="editar">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
            <!-- fwtable fwsrc="marco ancho.png" fwbase="int_ancha.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
            <tr> 
              <td><img src="../images/spacer.gif" width="6" height="1" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="463" height="1" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="19" height="1" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="198" height="1" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
            </tr>
            <tr> 
              <td colspan="5" bgcolor="#F1F1E4"> <table width="100%" border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
                  <tr bordercolor="#FFFFFF"> 
                    <td bgcolor="#F1F1E4"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
                      <img src="../images/flecha2.gif" width="7" height="7"> <b><font color="#CC3300">RENDICI&Oacute;N 
                      DE CAJA</font></b></font></td>
                  </tr>
                </table></td>
              <td><img src="../images/spacer.gif" width="1" height="21" border="0" alt=""></td>
            </tr>
            <tr> 
              <td background="../images/int_ancha_r2_c5.gif">&nbsp;</td>
              <td colspan="3" bgcolor="#F1F1E4"> <p align="center"><font size="+1">Rendici&oacute;n 
                  de caja</font></p>
                <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#FBFBF7">
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
                                      <td bgcolor="#CECECE"><font size="2"><strong>IP</strong></font></td>
                                      <td bgcolor="#CECECE"><font size="2"><strong>CFT 
                                        </strong></font></td>
                                    </tr>
                                    <tr> 
                                      <td><table border="0">
                                          <tr> 
                                            <th align="right">Total cedentes</th>
                                            <td align="center">:</td>
                                            <td width="100" align="right"> <%formulario.dibujaCampo("mcaj_mrend_cedentes_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total remesas</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_remesas_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total de cheques 
                                              al d&iacute;a</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_cheques_dia_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total de tarjetas 
                                              de cr&eacute;dito</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_tarj_credito_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Vale Vista</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_vvista_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Nota de Cr&eacute;dito</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_ncredito_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Total Mandato 
                                              Transbank </th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_transbank_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Total de 
                                              Documento (Alumno Empresa)</th>
                                            <td align="center">:</td>
                                            <td align="right"><%formulario.dibujaCampo("mcaj_mrend_d_al_empresa_ip")%></td>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Total de 
                                              Factura Intercompa&ntilde;&iacute;a</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_df_intercia_ip")%> </td>
                                          </tr>
                                          <tr>
                                            <th align="right">Total Abono por 
                                              Reconoc. de Pago</th>
                                            <td align="center">:</td>
                                            <td align="right">
                                              <%formulario.dibujaCampo("mcaj_mrend_arp_ip")%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              disponible</font></th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_disponible_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total cheques a 
                                              fecha</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_cheques_fecha_ip")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              documentos</font></th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_rend1_ip")%> </td>
                                          </tr>
                                        </table></td>
                                      <td align="right"> <table border="0">
                                          <tr> 
                                            <th align="right">Total cedentes</th>
                                            <td align="center">:</td>
                                            <td width="100" align="right"> <%formulario.dibujaCampo("mcaj_mrend_cedentes_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total remesas</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_remesas_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total de cheques 
                                              al d&iacute;a</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_cheques_dia_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total de tarjetas 
                                              de cr&eacute;dito</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_tarj_credito_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Vale Vista</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_vvista_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Nota de Cr&eacute;dito</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_ncredito_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Total Mandato 
                                              Transbank </th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_transbank_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Total de 
                                              Documento (Alumno Empresa) </th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_d_al_empresa_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Factura Intercompa&ntilde;ia</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_df_intercia_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total Abono por 
                                              Reconoc. de Pago</th>
                                            <td align="center">:</td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_mrend_arp_cft")%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              disponible</font></th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_disponible_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total cheques a 
                                              fecha</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_cheques_fecha_cft")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              documentos</font></th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_rend1_cft")%> </td>
                                          </tr>
                                        </table></td>
                                    </tr>
									<tr>
									  <td colspan="2" align="center" bgcolor="#CECECE"><font size="2"><strong>CAPACITACI&Oacute;N</strong></font> 
                                      <td>
									</tr>
									<tr> 
                                      <td colspan="2">
<table width="100%" border="0">
                                          <tr> 
                                            <th width="323" align="right">Total 
                                              de cheques al d&iacute;a</th>
                                            <td width="15" align="center">:</td>
                                            <td width="319"> <%formulario.dibujaCampo("mcaj_mrend_cheques_dia_ca")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total de tarjetas 
                                              de cr&eacute;dito</th>
                                            <td align="center">:</td>
                                            <td> <%formulario.dibujaCampo("mcaj_mrend_tarj_credito_ca")%> </td>
                                          </tr>
                                          <tr>
                                            <th align="right">Total de Dep&oacute;sitos 
                                              Bancos </th>
                                            <td align="center">:</td>
                                            <td>
                                              <%formulario.dibujaCampo("mcaj_mrend_dep_banco_ca")%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              disponible</font></th>
                                            <td align="center">:</td>
                                            <td> <%formulario.dibujaCampo("t_disponible_ca")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total cheques a 
                                              fecha</th>
                                            <td align="center">:</td>
                                            <td> <%formulario.dibujaCampo("mcaj_mrend_cheques_fecha_ca")%> </td>
                                          </tr>
                                          <tr> 
                                            <th align="right"><font size="2">Total 
                                              documentos</font></th>
                                            <td align="center">:</td>
                                            <td> <%formulario.dibujaCampo("t_rend1_ca")%> </td>
                                          </tr>
                                        </table></td>
                                    <tr>
                                    <tr> 
                                      <td colspan="2"><br> <br> <table width="401" border="1" align="center" cellpadding="0" cellspacing="0">
                                          <tr> 
                                            <td width="397"><table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr> 
                                                  <th align="right">&nbsp;</th>
                                                  <td align="center">&nbsp;</td>
                                                  <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <th width="50%" align="left"><font size="2">Total 
                                                    efectivo </font></th>
                                                  <td align="center"><strong>:</strong></td>
                                                  <td align="right"> <font size="2"> 
                                                    <%formulario.dibujaCampo("mcaj_mrend_efectivo")%>
                                                    </font></td>
                                                </tr>
                                                <tr> 
                                                  <th align="left"><font size="2">Total 
                                                    documentos IP </font></th>
                                                  <td align="center"><strong>:</strong></td>
                                                  <td align="right"> <font size="2"> 
                                                    <%formulario.dibujaCampo("t_rend1_ip1")%>
                                                    </font></td>
                                                </tr>
                                                <tr> 
                                                  <th align="left" nowrap><font size="2">Total 
                                                    documentos CFT</font></th>
                                                  <td align="center"><strong>:</strong></td>
                                                  <td align="right"> <font size="2"> 
                                                    <%formulario.dibujaCampo("t_rend1_cft1")%>
                                                    </font></td>
                                                </tr>
                                                <tr> 
                                                  <th align="left" nowrap><font size="2">Total 
                                                    documentos CAPACITACI&Oacute;N</font></th>
                                                  <td align="center"><strong>:</strong></td>
                                                  <td align="right"><font size="2"> 
                                                    <%formulario.dibujaCampo("t_rend1_ca1")%>
                                                    </font></td>
                                                </tr>
                                                <tr> 
                                                  <th align="left" nowrap><strong><font color="#000000" size="4">Total 
                                                    rendici&oacute;n </font></strong></th>
                                                  <td align="center"><font size="4"><strong>:</strong></font></td>
                                                  <td align="right"><strong><font size="4"> 
                                                    <%formulario.dibujaCampo("t_rend1")%>
                                                    </font></strong></td>
                                                </tr>
                                              </table></td>
                                          </tr>
                                        </table>
                                        <br> <br> </td>
                                    </tr>
                                    <tr> 
                                      <th colspan="2" bgcolor="#CCCCCC">CONTROL 
                                        DE CORRELATIVOS</th>
                                    </tr>
                                    <tr align="center"> 
                                      <td bgcolor="#CECECE"><font size="2"><strong>IP</strong></font></td>
                                      <td bgcolor="#CECECE"><font size="2"><strong>CFT 
                                        </strong></font></td>
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
                                        <table border="0">
                                          <tr> 
                                            <th align="right">&nbsp;</th>
                                            <td align="center">&nbsp;</td>
                                            <th width="60" align="right">Monto</th>
                                            <th width="60" align="right">Cantidad</th>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Factura (Alumno 
                                              Empresa)</th>
                                            <td align="center">:</td>
                                            <td align="right"><%formulario.dibujaCampo("mcaj_mrend_facturas_ae_ip")%></td>
                                            <td align="right"><%formulario.dibujaCampo("mcaj_nfacturas_ae_ip")%></td>
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
                                      <td align="right"><table border="0">
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
                                              <%formulario.dibujaCampo("mcaj_mrend_boletas_cft")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nboletas_cft_desde")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nboletas_cft_hasta")%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Notas de d&eacute;bito</th>
                                            <td align="center">:</td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_mrend_notas_debito_cft")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nnotas_debito_cft_desde")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nnotas_debito_cft_hasta")%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Notas de cr&eacute;dito</th>
                                            <td align="center">:</td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_mrend_notas_credito_cft")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nnotas_credito_cft_desde")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nnotas_credito_cft_hasta")%>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Notas de cargo</th>
                                            <td align="center">:</td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_mrend_notas_cargo_cft")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nnotas_cargo_cft_desde")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nnotas_cargo_cft_hasta")%>
                                            </td>
                                          </tr>
                                        </table>
                                        <table border="0">
                                          <tr> 
                                            <th align="right">&nbsp;</th>
                                            <td align="center">&nbsp;</td>
                                            <th width="60" align="right">Monto</th>
                                            <th width="60" align="right">Cantidad</th>
                                            <th width="60" align="right">&nbsp;</th>
                                          </tr>
                                          <tr> 
                                            <th align="right" nowrap>Factura (Alumno 
                                              Empresa)</th>
                                            <td align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_facturas_ae_cft")%> </td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_nfacturas_ae_cft")%> </td>
                                            <td align="right">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <th align="right">Factura Intercompa&ntilde;ia</th>
                                            <td align="center">:</td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_mrend_f_intercia_cft")%>
                                            </td>
                                            <td align="right"> 
                                              <%formulario.dibujaCampo("mcaj_nfintercia_cft")%>
                                            </td>
                                            <td align="right">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <th width="100" align="right">Facturas</th>
                                            <td width="10" align="center">:</td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_mrend_facturas_cft")%> </td>
                                            <td align="right"> <%formulario.dibujaCampo("mcaj_nfacturas_cft")%> </td>
                                            <td align="right">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <th align="right">Total rendido</th>
                                            <td align="center">&nbsp;</td>
                                            <td align="right"> <%formulario.dibujaCampo("t_rend2_cft")%> </td>
                                            <td align="right">&nbsp;</td>
                                            <td align="right">&nbsp;</td>
                                          </tr>
                                        </table></td>
                                    </tr>
									<tr>
									  <td colspan="2" align="center" bgcolor="#CECECE"><font size="2"><strong>CAPACITACI&Oacute;N</strong></font> 
                                      </td>
									</tr>
 									<tr> 
                                      <td colspan="2">
<table width="4%" border="0">
                                          <tr align="right"> 
                                            <td width="167" nowrap>&nbsp;</td>
                                            <td width="10" nowrap>&nbsp;</td>
                                            <th width="139" nowrap>Monto</th>
                                            <th width="128" nowrap>Desde</th>
                                            <th width="206" nowrap>Hasta</th>
                                          </tr>
                                          <tr align="right"> 
                                            <th nowrap>Boletas</th>
                                            <td nowrap>:</td>
                                            <td nowrap> 
                                              <%formulario.dibujaCampo("mcaj_mrend_boletas_ca")%> </td>
                                            <td nowrap> 
                                              <%formulario.dibujaCampo("mcaj_nboletas_ca_desde")%> </td>
                                            <td nowrap> 
                                              <%formulario.dibujaCampo("mcaj_nboletas_ca_hasta")%> </td>
                                          </tr>
                                          <tr align="right"> 
                                            <th nowrap>&nbsp;</th>
                                            <td nowrap>&nbsp;</td>
                                            <td nowrap><strong>Monto</strong> 
                                            </td>
                                            <td nowrap><strong>Cantidad</strong> 
                                            </td>
                                            <td nowrap>&nbsp;</td>
                                          </tr>
                                          <tr align="right"> 
                                            <th nowrap>Facturas</th>
                                            <td nowrap>:</td>
                                            <td nowrap> 
                                              <%formulario.dibujaCampo("mcaj_mrend_facturas_ca")%>
                                            </td>
                                            <td nowrap> 
                                              <%formulario.dibujaCampo("mcaj_nfacturas_ca")%>
                                            </td>
                                            <td nowrap>&nbsp;</td>
                                          </tr>
                                          <tr align="right"> 
                                            <th nowrap>Total rendido</th>
                                            <td nowrap>:</td>
                                            <td nowrap> 
                                              <%formulario.dibujaCampo("t_rend2_ca")%>
                                            </td>
                                            <td nowrap>&nbsp;</td>
                                            <td nowrap>&nbsp;</td>
                                          </tr>
                                        </table>
                                        
                                      </td>
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
                          <td align="right"><input name="imageField" type="image" src="../images/guardar2.gif" width="66" height="20" border="0" onClick="return valida(this.form)"></td>
                        </tr>
                      </table>
                      <strong><font color="000000" size="1"> </font></strong></td>
                  </tr>
                </table>
                
                <div align="center"></div></td>
              <td background="../images/int_ancha_r2_c5.gif" >&nbsp;</td>
              <td><img src="../images/spacer.gif" width="1" height="147" border="0" alt=""></td>
            </tr>
          </table>
          <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
            <!-- fwtable fwsrc="marco.png" fwbase="botonera.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
            <tr> 
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="4" height="1" border="0" alt=""></td>
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="318" height="1" border="0" alt=""></td>
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="19" height="1" border="0" alt=""></td>
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="65" height="1" border="0" alt=""></td>
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="67" height="1" border="0" alt=""></td>
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="66" height="1" border="0" alt=""></td>
              <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
            </tr>
            <tr> 
              <td rowspan="4" bgcolor="#F1F1E4"><img name="botonera_r1_c1" src="../images/botonera_r1_c1.gif" width="4" height="31" border="0" alt=""></td>
              <td rowspan="2" bgcolor="#F1F1E4">&nbsp;</td>
              <td rowspan="4"><img name="botonera_r1_c3" src="../images/botonera_r1_c3.gif" width="19" height="31" border="0" alt=""></td>
              <td colspan="3" background="../images/botonera_r1_c4.gif"><img name="botonera_r1_c4" src="../images/botonera_r1_c4.gif" width="198" height="4" border="0" alt=""></td>
              <td rowspan="4" bgcolor="B2B2B2"><img name="botonera_r1_c7" src="../images/botonera_r1_c7.gif" width="9" height="31" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="1" height="4" border="0" alt=""></td>
            </tr>
            <tr> 
              <td rowspan="2" bgcolor="B2B2B2">&nbsp;</td>
              <td rowspan="2" bgcolor="B2B2B2">&nbsp;</td>
              <td rowspan="2" bgcolor="B2B2B2"><a href="portada.asp" target="_top" onClick="MM_nbGroup('down','group1','salir','',1)" onMouseOver="MM_nbGroup('over','salir','../imagenes/botones/salir_f2.gif','',1)" onMouseOut="MM_nbGroup('out')"><img src="../imagenes/botones/salir.gif" name="salir" width="67" height="20" border="0"></a></td>
              <td><img src="../images/spacer.gif" width="1" height="15" border="0" alt=""></td>
            </tr>
            <tr> 
              <td rowspan="2" background="../images/botonera_r3_c2.gif"><img name="botonera_r3_c2" src="../images/botonera_r3_c2.gif" width="462" height="12" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="1" height="5" border="0" alt=""></td>
            </tr>
            <tr> 
              <td colspan="3" background="../images/botonera_r4_c4.gif"><img name="botonera_r4_c4" src="../images/botonera_r4_c4.gif" width="198" height="7" border="0" alt=""></td>
              <td><img src="../images/spacer.gif" width="1" height="7" border="0" alt=""></td>
            </tr>
          </table>
        </form>
      </div></td>
    <td rowspan="2" background="../images/portada_r3_c5.gif"><img name="portada_r3_c5" src="../images/portada_r3_c5.gif" width="21" height="336" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="160" border="0" alt=""></td>
  </tr>
  <tr> 
    <td><img src="../images/spacer.gif" width="1" height="176" border="0" alt=""></td>
  </tr>
</table>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>
<%
end if
%>
