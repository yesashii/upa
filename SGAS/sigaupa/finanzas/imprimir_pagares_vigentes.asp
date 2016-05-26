<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Imprimir  Pagares Vigentes"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'----------------------------------------------------------------------
'set cajero = new CCajero
'cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'if not cajero.TieneCajaAbierta then
 ' session("mensajeerror")= "No puede ingresar cedentes sin tener una caja abierta"
 ' response.Redirect("../lanzadera/lanzadera.asp") 
' end if
 
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Imprimir_Pagare_finanza.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 num_doc = request.querystring("busqueda[0][paga_ncorr]")
  
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Imprimir_Pagare_finanza.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "paga_ncorr", num_doc
' -----------------------------------------------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "Imprimir_Pagare_finanza.xml", "f_letras"
 f_letras.Inicializar conexion
 
 '----------PAGARES PARA SER PACTADOS O PRORROGADOS, VIGENTES SIN ESTAR ASOCIADOS A UN ENVIO O LEGALIZADOS ----
	   
sql ="select pag.enpa_ncorr, pag.paga_fpagare,pag.paga_finicio_pago, bba.bene_ncorr, pag.PAGA_NCORR, pag.epag_ccod,pag.PAGA_NCORR nro_pagare, epag.EPAG_TDESC,"& vbCrLf &_
"	   	   	(nvl(bba.BENE_MMONTO_ACUM_MATRICULA,0) + nvl(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar,"& vbCrLf &_
"	   	   	(nvl(bba.BENE_MMONTO_ACUM_MATRICULA,0) + nvl(bba.BENE_MMONTO_ACUM_COLEGIATURA,0)) as valor_pagar_c,"& vbCrLf &_
"			 pp.PERS_NRUT ||'-'||pp.PERS_XDV as rut_post, pp.PERS_NCORR,cc.INST_CCOD, "& vbCrLf &_
"			 ppc.PERS_NRUT ||'-'||ppc.PERS_XDV as rut_codeudor "& vbCrLf &_
"			 from postulantes p,personas_postulante pp, "& vbCrLf &_
"			 personas_postulante ppc, "& vbCrLf &_
"			 codeudor_postulacion cp,  "& vbCrLf &_
"			 beneficios bba, ofertas_academicas oa,   "& vbCrLf &_
"			 especialidades ee, carreras cc,  "& vbCrLf &_
"			 contratos con, pagares pag,estados_pagares epag "& vbCrLf &_
"			 where p.pers_ncorr=pp.pers_ncorr   "& vbCrLf &_
"			 and con.post_ncorr=p.post_ncorr "& vbCrLf &_
"			 and pag.EPAG_CCOD=1 "& vbCrLf &_
"			  and pag.EPAG_CCOD=epag.EPAG_CCOD   "& vbCrLf &_
"			 and con.CONT_NCORR=pag.CONT_NCORR  "& vbCrLf &_
"			 and pag.PAGA_NCORR=bba.PAGA_NCORR  "& vbCrLf &_
"			 and bba.EBEN_CCOD =1  "& vbCrLf &_
"			 and con.econ_ccod=1   "& vbCrLf &_
"			 and p.post_ncorr=cp.post_ncorr  "& vbCrLf &_
"			 and cp.pers_ncorr =ppc.pers_ncorr  "& vbCrLf &_
"			and p.ofer_ncorr=oa.ofer_ncorr  "& vbCrLf &_
"			 and oa.espe_ccod=ee.espe_ccod  "& vbCrLf &_
"			 and ee.carr_ccod=cc.carr_ccod "& vbCrLf &_	
"			and  pp.pers_nrut = nvl('" & rut_alumno & "',pp.pers_nrut)   "& vbCrLf &_
"			and  ppc.pers_nrut = nvl('" & rut_apoderado & "',ppc.pers_nrut) "& vbCrLf &_
"			and  pag.PAGA_NCORR = nvl('" & num_doc & "',pag.PAGA_NCORR )"	   

sql="select  pag.enpa_ncorr, pag.paga_fpagare,pag.paga_finicio_pago,  pag.paga_ncorr, pag.epag_ccod,"& vbCrLf &_
	      	" com.comp_mdocumento as valor_pagar, com.comp_mdocumento as  valor_pagar_c,pag.paga_ncorr nro_pagare, epag.epag_tdesc,"& vbCrLf &_
			 " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_post, pp.pers_ncorr,cc.inst_ccod, "& vbCrLf &_
			 " cast(ppc.pers_nrut as varchar)+'-'+cast(ppc.pers_xdv as varchar) as rut_codeudor "& vbCrLf &_
			 " From postulantes p,personas_postulante pp, "& vbCrLf &_
			 " personas_postulante ppc, "& vbCrLf &_
			 " codeudor_postulacion cp,  "& vbCrLf &_
			 " compromisos com, ofertas_academicas oa,"& vbCrLf &_   
			 " especialidades ee, carreras cc,  "& vbCrLf &_
			 " contratos con, pagares pag,estados_pagares epag "& vbCrLf &_
			 " Where p.pers_ncorr=pp.pers_ncorr   "& vbCrLf &_
			 " and con.post_ncorr=p.post_ncorr "& vbCrLf &_
			 " and pag.epag_ccod=1 "& vbCrLf &_
			 " and pag.epag_ccod=epag.epag_ccod"& vbCrLf &_   
			 " and con.cont_ncorr=pag.cont_ncorr  "& vbCrLf &_
			 " and con.cont_ncorr=com.comp_ndocto  "& vbCrLf &_
			 " and com.tcom_ccod=2 "& vbCrLf &_  
			 " and com.ecom_ccod <>3 "& vbCrLf &_
			 " and con.econ_ccod=1"& vbCrLf &_   
			 " and p.post_ncorr=cp.post_ncorr "& vbCrLf &_ 
			 " and cp.pers_ncorr =ppc.pers_ncorr"& vbCrLf &_  
			 " and p.ofer_ncorr=oa.ofer_ncorr"& vbCrLf &_  
			 " and oa.espe_ccod=ee.espe_ccod"& vbCrLf &_  
			 " and ee.carr_ccod=cc.carr_ccod" 

	if rut_alumno <> "" then
		consulta = consulta &  "	and  pp.pers_nrut = '"&rut_alumno&"'   "
	end if
	if rut_apoderado <> "" then
		consulta = consulta &  "	and  ppc.pers_nrut  = '"&rut_apoderado&"'   "
	end if
	if num_doc <> "" then
		consulta = consulta &  "	and  pag.PAGA_NCORR  = '"&num_doc&"'   "
	end if

 'f_letras.consultar sql
' f_letras.nrofilas
 
 if Request.QueryString <> "" then
	  f_letras.consultar sql
  else
	f_letras.consultar "select '' from sexos where 1 = 2"
	f_letras.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if
'response.Write("<pre>"&sql&"</pre>")
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

<script language='JavaScript'> 
function Validar()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	rut_apoderado = formulario.elements["busqueda[0][code_nrut]"].value + "-" + formulario.elements["busqueda[0][code_xdv]"].value;	
    if (formulario.elements["busqueda[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][code_xdv]"].focus();
		formulario.elements["busqueda[0][code_xdv]"].select();
		return false;
	   }
	return true;
	}

   function procesar_click()
  {
   // var tabla = new CTabla("letras");
    var valor;	
	for (i = 0; i < tabla.filas.length; i++) 
     {  	    
	  	valor = document.edicion.elements["_letras[" + i + "][check]"].checked;	     
		if (valor == true) 
		  {
		    document.edicion.elements["letras[" + i + "][epag_ccod]"].setAttribute("disabled", false);
		 	document.edicion.elements["letras[" + i + "][oculto]"].value =document.edicion.elements["letras[" + i + "][paga_ncorr]"].value
			//procesar_tabla();
		  }
		 else
		 {
   		    document.edicion.elements["letras[" + i + "][oculto]"].value ="";
		    document.edicion.elements["letras[" + i + "][epag_ccod]"].setAttribute("disabled", true);
  		    
		    //document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true)
		 }
	  }	  
  }
  
 function procesar_tabla()
  {
    //var tabla = new CTabla("letras");
    var valor;	
	for (i = 0; i < tabla.filas.length; i++) 
     {  	    
	   valor = document.edicion.elements["_letras[" + i + "][check]"].checked;
	   if (valor = true)	 
	     {
	          estado = tabla.ObtenerValor(i, "epag_ccod");
			  //if (estado == 6)
			      //document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", false);			      
			  //else
			     //document.edicion.elements["letras[" + i + "][nueva_fecha]"].setAttribute("disabled", true)
	     }
	}  
  }

var tabla;
//var cant_filas;

function inicio()
{
   tabla = new CTabla("letras");
   
 //cant_filas=tabla.filas.length;
//return cant_filas
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="inicio();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de documentos"), 1%></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="84%"><div align="center">
                        <table width="524" border="0">
                          <tr>
                                  <td>N&ordm; Pagare</td>
                            <td>:</td>
                                  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                    <% f_busqueda.DibujaCampo ("paga_ncorr") %>
                                    </font></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                          </tr>
                          <tr>
                            <td>Rut Alumno</td>
                            <td>:</td>
                                  <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - 
                                    <% f_busqueda.DibujaCampo ("pers_xdv") %>
                                    </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                    </font></td>
                            <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                                Apoderado</font></td>
                            <td>:</td>
                            <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                      <% f_busqueda.DibujaCampo ("code_nrut") %>
                                      - 
                                      <% f_busqueda.DibujaCampo ("code_xdv") %>
                                      </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                            </td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="16%"><div align="center"><% botonera.DibujaBoton ("buscar")%></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
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
                <td> 
                  <%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1%>
                </td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <% f_letras.AccesoPagina %>
                          </div></td>
                        <td width="3%"> 
                          <div align="right"> </div></td>
                      </tr>
                    </table>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td> <div align="center">
                            <% f_letras.DibujaTabla()%>
                            <br>
                          </div></td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="30%" height="20"><div align="center"> 
                    <table width="65%"  border="0" align="left" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td width="32%"><div align="center">
						
						  
						  <% if ( f_letras.nrofilas >0) then 
						      botonera.AgregaBotonParam "imprimir","deshabilitado","FALSE"
							 
							  
						  else 
						      botonera.AgregaBotonParam "imprimir","deshabilitado","TRUE"
						  end if 
						  %>
						  
						 
                            <% botonera.DibujaBoton ("imprimir") %>
							
							
                          </div></td>
                        <td width="56%"><div align="center">
                            <% botonera.DibujaBoton ("lanzadera")%>
                          </div></td>
                        <td width="12%"><div align="center"></div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="70%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>
