<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set pagina = new CPagina


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion


'------------------------------------------------------------------------------------------------
post_ncorr = Request.QueryString("post_ncorr")
nro_t = Request.QueryString("nro_t")
if nro_t="" then
    nro_t=1
end if	
 	select case nro_t
		case 1
		 visible1 ="style=""VISIBILITY: visible"""
		case 2
			 visible2 ="style=""VISIBILITY: visible"""
		case 3
			 visible3 ="style=""VISIBILITY: visible"""	 
		case 4
			 visible4 ="style=""VISIBILITY: visible"""	 
		end select
sede = negocio.ObtenerSede
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "genera_contrato_4.xml", "btn_genera_contrato_4"

'--------------------------------DATOS IMPRESORA -----------------------------------------------
set f_impresora = new CFormulario
f_impresora.Carga_Parametros "genera_contrato_4.xml", "f_impresora"
f_impresora.Inicializar conexion

cc_impresora ="select impr_truta from impresoras where sede_ccod='" & sede & "'"

f_impresora.Consultar cc_impresora

'-----------------------------------DATOS CONTRATO---------------------------------------------
		set f_detalle_contrato = new CFormulario
		f_detalle_contrato.Carga_Parametros "genera_contrato_4.xml", "f_detalle_contrato"
		f_detalle_contrato.Inicializar conexion


		
		 consulta_con = "select cc.cont_ncorr nro_contrato, "&_
		"		to_char(cc.CONT_FCONTRATO, 'DD/MM/YYYY') f_contrato, "&_
		"		ec.ECON_TDESC estado "&_
		"from contratos cc, estados_contrato ec "&_
		"where cc.post_ncorr= "& post_ncorr & " and  "&_
		"		cc.econ_ccod=ec.econ_ccod and "&_
		"		cc.econ_ccod<>3   "
		'response.Write(consulta_con)
		f_detalle_contrato.Consultar consulta_con
		f_detalle_contrato.siguiente
'-----------------------------------DATOS PAGARE---------------------------------------------
		set f_detalle_pagare = new CFormulario
		f_detalle_pagare.Carga_Parametros "genera_contrato_4.xml", "f_detalle_pagare"
		f_detalle_pagare.Inicializar conexion



						
	consulta_p = " select bba.PAGA_NCORR, bba.BENE_MMONTO_COLEGIATURA monto_actual, " &_
				 " 			   nvl(bbp.BENE_MMONTO_ACUM_COLEGIATURA,0) monto_anterior, " &_
				 " 			   (nvl(bba.BENE_MMONTO_ACUM_COLEGIATURA, 0)) suma " &_
				 " 							   from contratos cc, beneficios bba ,stipos_descuentos stda,   " &_
				 " 							   	 beneficios bbp " &_
				 " 							   where cc.POST_NCORR="& post_ncorr &"  	    " &_
				 " 							   	  and cc.CONT_NCORR=bba.CONT_NCORR   " &_
				 " 							   	 and bba.STDE_CCOD=stda.STDE_CCOD " &_
				 " 							   	  and stda.TBEN_CCOD = 1  " &_
				 " 								  and cc.econ_ccod<>3     " &_
				 " 							   	  and bba.EBEN_CCOD <>3  " &_
				 " 								  and bba.PAGA_NCORR_ANTERIOR = bbp.PAGA_NCORR (+)   " &_
				 " 								  and bba.stde_ccod = bbp.stde_ccod (+) " &_
				 " 							   	  and bbp.EBEN_CCOD <>3 " 									

		'response.Write(consulta_p)
		f_detalle_pagare.Consultar consulta_p
        f_detalle_pagare.siguiente
'-----------------------------------DATOS POSTULANTE--------------------------------------------
		
		set f_detalle_post = new CFormulario
		f_detalle_post.Carga_Parametros "genera_contrato_4.xml", "f_detalle_post"
		f_detalle_post.Inicializar conexion
		
		 consulta = "select pp.pers_tnombre ||' '|| pp.pers_tape_paterno || ' ' || pp.pers_tape_materno  as nombre_post, "&_
		"	   pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post, "&_
		"	   to_char(sysdate, 'DD/MM/YYYY') as fecha_hoy, "&_
		"	   cc.carr_tdesc as carrera "&_
		"from postulantes p,personas_postulante pp,ofertas_academicas oa, "&_
		"	 especialidades ee, carreras cc  "&_
		"where p.pers_ncorr=pp.pers_ncorr and "&_
		"	  p.post_ncorr= " & post_ncorr &" and "&_
		"	  p.ofer_ncorr=oa.ofer_ncorr and "&_
		"	  oa.espe_ccod=ee.espe_ccod and "&_
		"	  ee.carr_ccod=cc.carr_ccod "
		
		f_detalle_post.Consultar consulta
		'response.Write(consulta)
		f_detalle_post.siguiente
		
'-----------------DETALLES CHEQUES------------------------------------
		set f_detalle_cheque_2 = new CFormulario
		f_detalle_cheque_2.Carga_Parametros "genera_contrato_4.xml", "f_detalle_cheque_2"
		f_detalle_cheque_2.Inicializar conexion


		
	
		consulta_c = "select p.post_ncorr,  "&_
	 				"dii.TING_CCOD,   "&_
	 				"dii.ding_ndocto ,  "&_
	 				"dii.ingr_ncorr ,   "&_
	 				"dii.ding_ndocto  nro_doc,  dii.ding_tcuenta_corriente,   "&_
	 				"tii.ting_tdesc tipo_doc,   "&_
	 				"bn.BANC_TDESC banco,   "&_
	 				"pl.plaz_tdesc plaza,  "&_
	 				"to_char(cps.COMP_FDOCTO,'DD/MM/YYYY') f_emision,   "&_
	 				"to_char(dii.DING_FDOCTO,'DD/MM/YYYY') f_vencimiento,  "&_
	 				"dii.DING_MDETALLE monto  "&_
 				"from postulantes p,   "&_
	  				"contratos cc, compromisos cps , detalle_compromisos dc,   "&_
	  				"abonos bb, ingresos ii, detalle_ingresos dii,   "&_
	 				" tipos_ingresos tii,bancos bn, tipos_compromisos tcps, plazas pl  "&_
  				"where p.post_ncorr=" & post_ncorr &" and  "&_
	  					"cc.post_ncorr=p.post_ncorr and   "&_
						"cc.cont_ncorr=cps.comp_ndocto and   "&_
	 					"cps.ecom_ccod <> 3 and   "&_
						"cc.econ_ccod <> 3 and    "&_
	  					"cps.comp_ndocto=dc.comp_ndocto and   "&_
						"cps.tcom_ccod=dc.tcom_ccod and   "&_
						"cps.tcom_ccod=tcps.tcom_ccod and   "&_
	  
						"bb.comp_ndocto=dc.comp_ndocto and   "&_ 
						"bb.tcom_ccod=dc.tcom_ccod and    "&_
						"bb.dcom_ncompromiso=dc.dcom_ncompromiso and    "&_
	  
						"bb.ingr_ncorr=ii.ingr_ncorr and    "&_
						"ii.eing_ccod <> 3 and    "&_
						"dii.ingr_ncorr (+)= ii.ingr_ncorr and    "&_
						"dii.ting_ccod =3 and   "&_
						"dii.ting_ccod =tii.ting_ccod (+) and    "&_
						"dii.banc_ccod = bn.banc_ccod (+) and    "&_
						"dii.plaz_ccod=pl.plaz_ccod   "
		
		
		
		f_detalle_cheque_2.Consultar consulta_c

'-----------------DETALLES LETRAS------------------------------------
		set f_detalle_letra = new CFormulario
		f_detalle_letra.Carga_Parametros "genera_contrato_4.xml", "f_detalle_letra"
		f_detalle_letra.Inicializar conexion

	consulta_t ="select p.post_ncorr, "&_
	 				"dii.TING_CCOD,  "&_
	 				"dii.ding_ndocto , "&_
	 				"dii.ingr_ncorr ,  "&_
	 				"dii.ding_ndocto  nro_doc, "&_
	 				"tii.ting_tdesc tipo_doc,  "&_
	 
	 				"to_char(cps.COMP_FDOCTO,'DD/MM/YYYY') f_emision,  "&_
	 				"to_char(dii.DING_FDOCTO,'DD/MM/YYYY') f_vencimiento, "&_
	 				"dii.DING_MDETALLE monto "&_
	 
				"from postulantes p, contratos cc,  "&_
	 				"compromisos cps , detalle_compromisos dc,  "&_
	 				"abonos bb, ingresos ii, detalle_ingresos dii,  "&_
	 				"tipos_ingresos tii, tipos_compromisos tcps "&_
				"where p.post_ncorr=" & post_ncorr &" and "&_
					"cc.post_ncorr=p.post_ncorr and    "&_
					"cc.cont_ncorr=cps.comp_ndocto and    "&_
					"cps.ecom_ccod <> 3 and    "&_
					"cc.econ_ccod <> 3 and     "&_
					"cps.comp_ndocto=dc.comp_ndocto and   "&_ 
					"cps.tcom_ccod=dc.tcom_ccod and    "&_
					"cps.tcom_ccod=tcps.tcom_ccod and   "&_ 
	  
					"bb.comp_ndocto=dc.comp_ndocto and   "&_ 
					"bb.tcom_ccod=dc.tcom_ccod and     "&_
					"bb.dcom_ncompromiso=dc.dcom_ncompromiso and  "&_   
	  
					"bb.ingr_ncorr=ii.ingr_ncorr and     "&_
					"ii.eing_ccod <> 3 and    "&_ 
					"dii.ingr_ncorr (+)= ii.ingr_ncorr and    "&_
					"dii.ting_ccod =4 and   "&_ 
					"dii.ting_ccod =tii.ting_ccod (+) "
		
		'response.Write(consulta_t)
		f_detalle_letra.Consultar consulta_t
		
'-------------------------------------------------------
set postulante = new CPostulante
postulante.Inicializar conexion, post_ncorr		
		
%>


<html>
<head>
<title>Imprimir Documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function Anterior4()
{
  location.replace("Forma_Pago3.asp");
}



function Deshabilita(loc){

   /*tabla = new CTabla("envios");
   
   for (var i = 0; i < tabla.filas.length; i++) {
   		alert(tabla.ObtenerValor(i, "imprimir_d"));
   }*/
   
   //return false;

 nro_elemento="";

 

for (var i=0;i<document.edicion_c.elements.length;i ++) {

	if (document.edicion_c.elements[i].type == 'checkbox') {
           
		    if(document.edicion_c.elements[i]!=loc)
			{			         
					 document.edicion_c.elements[i].checked=false;
					 //alert(document.edicion_c.elements[i].checked);
					 //cambiaOculto(document.edicion_c.elements[i], '1', '0');
					 //document.edicion_c.elements[i].value=0;
					   //alert (document.edicion_c.elements);
			           //checktest(i);
			}			
			
			cambiaOculto(document.edicion_c.elements[i], '1', '0');
			
   		}
   
   }




}
function validar_cheque(){


 nro_elemento=0;

 

for (var i=0;i<document.edicion_c.elements.length;i ++) {

	if (document.edicion_c.elements[i].checked==true) {
          nro_elemento++;
			
   		}
   
   }

if (nro_elemento==0) {
   alert( "debe seleccionar uno");
}


}
function Abrir()
{
 resultado = window.open("ver_cheque.asp","","toolbar=no, resizable=no,left=200,top=150,width=415,height=175");
  
}
</script>
<script language="JavaScript">
function abrir()
 { 
  location.reload("Envios_Banco_Agregar1.asp") 
 }
</script>
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<script>

var currentSlide = 1;
//var numSlides = 12; // change to your total number of pics
var numSlides_tabla = 5; // change to your total number of pics
//var captions = new Array(10); //change to total number of pics
var IE4 = (document.all && !document.getElementById) ? true : false; //identifies IE 4
var NS4 = (document.layers) ? true : false; //identifies Navigator 4
var N6 = (document.getElementById && !document.all) ? true : false; //identifies Navigator 6 and IE 5 and up


function switchSlides_tabla(nro_tabla)
{
     // newSlide= "image_mapa"+newSlide;
       //alert (nro_mapa);
	   if (nro_tabla==""){
	       nro_tabla == 1;}
		   
       newSlide= "image_tabla"+nro_tabla;
       //alert ( newSlide)
    if (NS4 == true) {
            for (var i=1; i< numSlides_tabla; i++){
                var oldSlide="image_tabla"+i;
              
                if (newSlide == oldSlide)
		       document.layers[newSlide].visibility="show";
                else 
		       document.layers[oldSlide].visibility="hide";
              
            }
	
	}
	else if (IE4 == true) {
            for (var i=1; i< numSlides_tabla; i++){
                var oldSlide="image_tabla"+i;
               
                if (newSlide == oldSlide)
		       document.all[newSlide].style.visibility="visible";
                else 
	             document.all[oldSlide].style.visibility="hidden";
                
            }
        }
	else {
                for (var i=1; i< numSlides_tabla; i++){
                 var oldSlide="image_tabla"+i;
               
                  if (newSlide == oldSlide)
		     document.getElementById(newSlide).style.visibility="visible";
                  else 
	             document.getElementById(oldSlide).style.visibility="hidden";
                  
                }
	
             }
}




//window.onload=switchSlides_tabla(<%=nro_t%>);

</script>
</head>
<body onBlur="revisaVentana()" bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <tr>
    <td valign="top" bgcolor="#EAEAEA"> <br>
      <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="0"> <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                <td> 
                  <%pagina.dibujarLenguetas array (array("Formas de Pago","genera_contrato_2.asp?post_ncorr="& post_ncorr),array("Generar Contrato","genera_contrato_3.asp?post_ncorr="& post_ncorr),array("Imprimir","genera_contrato_4.asp?post_ncorr="& post_ncorr)),3 %>
                </td>
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
                  <td width="9" height="100" align="left" background="../imagenes/izq.gif"></td>
                  
                <td align="center" valign="top" bgcolor="#D8D8DE"><BR>
                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center"><%postulante.DibujaDatos%></div></td>
                    </tr>
                  </table>
                  <BR>                  
                    <table width="632" border="0" align="center">
                      <tr>
                        <td colspan="3"><%pagina.DibujarSubtitulo("Imprimir Documentos")%>
                        </td>
                      </tr>
                      <tr>
                        <td width="94"><font size="2">Impresora</font></td>
                        <td width="19">:</td>
                        <td width="505"><select name="select">
                          <option>\\servidor\Impresora_1</option>
                          <option>\\servidor\Impresora_2</option>
                          <option>Impresora Local</option>
                        </select>
                      </td>
                      </tr>
                    </table>
                    
                  <br>
                  <table width="632"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td> 
                              <%pagina.DibujarLenguetasFClaro Array(array("Contratos","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=1"), array("Pagaré","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=2"), array("Cheque","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=3"), array("Letra","genera_contrato_4.asp?post_ncorr="& post_ncorr &"&nro_t=4")), nro_t %>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
                            <td> <%if (nro_t=1) then %>
                              <table width="273" border="0">
                                <tr> 
                                  <td width="46%"><font size="2">Contrato</font></td>
                                  <td width="6%"><font size="2">:</font></td>
                                  <td width="29%"><font size="1"> 
                                    <% f_detalle_contrato.DibujaCampo("nro_contrato") %>
                                    </font></td>
                                  <td width="19%">&nbsp;</td>
                                </tr>
                                <tr> 
                                  <td><font size="2">Fecha</font></td>
                                  <td><font size="2">:</font></td>
                                  <td><font size="1"> 
                                    <% f_detalle_contrato.DibujaCampo("f_contrato") %>
                                    </font></td>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr> 
                                  <td><font size="2">Estado</font></td>
                                  <td><font size="2">:</font></td>
                                  <td><font size="1"> 
                                      <% f_detalle_contrato.DibujaCampo("estado") %>
                                      </font></td>
                                  <td>&nbsp;</td>
                                </tr>
                              </table>
                              <%end if %> <%if (nro_t=2) then %>
						
						<table width="273" border="0">
                                          <tr>
                            <td width="46%"><font size="2">Pagar&eacute;</font></td>
                            <td width="6%"><font size="2">:</font></td>
                                    <td width="29%"><font size="1">
                                      <% f_detalle_pagare.DibujaCampo("PAGA_NCORR") %>
                                      </font></td>
                            <td width="19%">&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto Anterior</font></td>
                                  <td><font size="2">:U.F</font></td>
                            <td><div align="right"><font size="1">
                                        <% f_detalle_pagare.DibujaCampo("monto_anterior") %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Monto del A&ntilde;o</font></td>
                                  <td><font size="2">:U.F</font></td>
                            <td><div align="right"><font size="1"> 
                                        <% f_detalle_pagare.DibujaCampo("monto_actual") %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td><font size="2">Total</font></td>
                                  <td><font size="2">:U.F</font></td>
                            <td><div align="right"><font size="1">
                                        <% f_detalle_pagare.DibujaCampo("suma") %>
                                        </font></div></td>
                            <td>&nbsp;</td>
                          </tr>
                        </table>
                               <%end if %>
						 <%if (nro_t=3) then %>
						<table width="90%" border="0">
                                    <tr> 
                                      <td width="99">&nbsp;</td>
                                      <td width="444"><div align="right">P&aacute;ginas: 
                                          &nbsp; 
                                          <%f_detalle_cheque_2.AccesoPagina%>
                                        </div></td>
                                      <td width="20"> <div align="right"> </div></td>
                                    </tr>
                              </table>
						        <form name="edicion_c" id="edicion_c">
                                  <table width="600" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center"> 
                                        <% f_detalle_cheque_2.DibujaTabla%>
                                      </td>
                                    </tr>
                                  </table>
                                </form>
						<%end if %><%if (nro_t=4) then %>
						 <table width="90%" border="0">
                                    <tr> 
                                      <td width="116">&nbsp;</td>
                                      <td width="511"><div align="right">P&aacute;ginas: 
                                          &nbsp; 
                                          <%f_detalle_letra.AccesoPagina%>
                                        </div></td>
                                      <td width="24"> <div align="right"> </div></td>
                                    </tr>
                              </table>
						       
                                <form name="edicion_l" id="edicion_l">
                                  <table width="600" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center"> 
                                        <% f_detalle_letra.DibujaTabla%>
                                      </td>
                                    </tr>
                                  </table>
                                </form>  
						<%end if %></td>
                          </tr>
                        </table></td>
                      <td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td width="9" height="28"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
                      <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="34%" height="20"><div align="center"> 
                                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td><div align="center"> 
                                        <%if (nro_t=1) then %>
                                        <% botonera.agregabotonparam "imprimir_contrato", "url", "/REPORTESNET/imprimir_contrato.aspx?post_ncorr=" &  post_ncorr  
										     botonera.dibujaboton "imprimir_contrato" %>
                                        <%end if %>
                                        <%if (nro_t=2) then %>
                                        <% botonera.agregabotonparam "imprimir_pagare", "url", "/REPORTESNET/imprimir_pagare.aspx?post_ncorr=" &  post_ncorr  
										     botonera.dibujaboton "imprimir_pagare" %>
                                      
                                        <%end if %>
                                        <%if (nro_t=3) then %>
                                        <%    
									         botonera.agregabotonparam "imprimir_c", "url", "imprimir_cheque_1.asp"
										     
										     botonera.dibujaboton "imprimir_c" %>
                                        <%end if %>
                                        <%if (nro_t=4) then %>
                                        <%    botonera.agregabotonparam "imprimir_l", "url", "/REPORTESNET/imprimir_letra.aspx"
										     botonera.dibujaboton "imprimir_l" %>
                                        <%end if %>
                                      </div></td>
                                    <td><%if (nro_t=2) then %> 
									
									<% 'botonera.agregabotonparam "imprimir_pagare_string", "url", "imprimir_pagare.asp?post_ncorr=" &  post_ncorr 
									    botonera.agregabotonparam "imprimir_pagare_string", "url", "/REPORTESNET/Imp_Pagare.aspx?post_ncorr=" &  post_ncorr   
										     botonera.dibujaboton "imprimir_pagare_string" %> 
									<%end if %> <%if (nro_t=1) then %>
                                        <% botonera.agregabotonparam "imprimir_alumno", "url", "/REPORTESNET/ficha_alumno.aspx?post_ncorr=" &  post_ncorr  
										     botonera.dibujaboton "imprimir_alumno" %>
                                        <%end if %></td>
                                  </tr>
                                </table>
                              </div></td>
                            <td width="66%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          </tr>
                          <tr> 
                            <td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          </tr>
                        </table></td>
                      <td width="7" height="28"><img src="../imagenes/marco_claro/16.gif" width="7" height="28"></td>
                    </tr>
                  </table> <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="214" bgcolor="#D8D8DE"> <div align="right">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="2%">&nbsp;</td>
                        <td width="49%" align="center">
                       <%    botonera.agregabotonparam "anterior", "url", "genera_contrato_3.asp?post_ncorr=" & post_ncorr
                             botonera.dibujaboton "anterior" %>
                        </td>
                        <td width="49%" align="center">&nbsp; </td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="148" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
    
    <br>
    </td>
  </tr>  
</table>
</body>
</html>
