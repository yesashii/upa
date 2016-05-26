<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Depósitos de cuotas Multidebito"
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "depositos_multidebito.xml", "botonera"
'---------------------------------------------------------------------------------------------------
 folio 		= request.querystring("busqueda[0][envi_ncorr]")
 fecha 		= request.querystring("busqueda[0][envi_fenvio]")
 eenv_ccod	= request.querystring("busqueda[0][eenv_ccod]")
  
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "depositos_multidebito.xml", "busqueda_envios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "envi_ncorr", folio
 f_busqueda.AgregaCampoCons "envi_fenvio", fecha
 f_busqueda.AgregaCampoCons "eenv_ccod", eenv_ccod
'----------------------------------------------------------------------------------
set f_envios = new CFormulario
f_envios.Carga_Parametros "depositos_multidebito.xml", "f_envios"
f_envios.Inicializar conexion

				 
consulta = "select a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, a.envi_ncorr as c2_envi_ncorr, "& vbCrLf &_
			"        b.inen_tdesc,a.envi_fenvio, d.eenv_tdesc, c.CCTE_TDESC, a.eenv_ccod,"& vbCrLf &_
			"        protic.cantidad_documentos_envio(a.envi_ncorr) as cant_doc, "& vbCrLf &_
			" max(a.envi_tdescripcion) as envi_tdescripcion, "& vbCrLf &_
			" protic.total_valor_envio_pagare(a.envi_ncorr)-case when a.envi_ncorr = '49776' then 6000 else 0 end as total "& vbCrLf &_
			" from "& vbCrLf &_
			" envios a join instituciones_envio b"& vbCrLf &_
			"    on a.inen_ccod = b.inen_ccod"& vbCrLf &_
			" left outer join cuentas_corrientes c "& vbCrLf &_
			"        on a.CCTE_CCOD = c.ccte_ccod "& vbCrLf &_
			" join estados_envio d "& vbCrLf &_
			"    on a.eenv_ccod = d.eenv_ccod "& vbCrLf &_
			" left outer join detalle_envios f "& vbCrLf &_
			"    on  a.envi_ncorr = f.envi_ncorr "& vbCrLf &_
			" left outer join detalle_ingresos g "& vbCrLf &_
			"    on g.ting_ccod = f.ting_ccod  "& vbCrLf &_
			"    and g.ding_ndocto = f.ding_ndocto  "& vbCrLf &_
			"    and g.ingr_ncorr = f.ingr_ncorr "& vbCrLf &_
			" left outer join ingresos h "& vbCrLf &_
			"    on g.ingr_ncorr = h.ingr_ncorr "& vbCrLf &_
			" left outer join personas i "& vbCrLf &_
			"    on i.pers_ncorr = h.pers_ncorr"& vbCrLf &_
			" left outer join personas j"& vbCrLf &_
			"    on g.PERS_NCORR_CODEUDOR = j.pers_ncorr"& vbCrLf &_
			" where a.tenv_ccod = 8 "
			
'" and b.TINE_CCOD = 4"			
			 	  
				  if  folio <> ""  then 
				    consulta = consulta & "and a.envi_ncorr = '" & folio & "' "
				  end if

				  if eenv_ccod  <> "" then 
				  	consulta = consulta & "and a.eenv_ccod  ='" & eenv_ccod & "' "
				  end if
				  
				  if fecha  <> "" then 
				  	consulta = consulta & "and convert(datetime,a.envi_fenvio,103) = '" & fecha & "'"
				  end if
				  			  
  				
			 	consulta = consulta  &  " group by a.envi_ncorr,  b.inen_tdesc, a.envi_fenvio, d.eenv_tdesc,c.CCTE_TDESC, a.eenv_ccod "& vbCrLf &_
										" order by a.envi_ncorr DESC "
 
 if Request.QueryString <> "" then
	  f_envios.consultar consulta
  else
	f_envios.consultar "select '' where 1 = 2"
	f_envios.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
 cantidad=f_envios.nroFilas
'----------------------------------------------------------------------- 
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
	function Mensaje(){
	<% if session("mensaje_error")<>"" then%>
	alert("<%=session("mensaje_error")%>");
	<%
	session("mensaje_error")=""
	end if%>
	}
	

function validar_deposito_enviado(form){

v_valida=valida_envios(form);

	if (v_valida==true) {
		v_check=verifica_check(form,2);
		if (v_check==true){
			return true;	
		}else{
			return false;
		}
	}else{	
		return false;
	}
}	

function valida_envios(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
		  //	alert(str);
		  	 indice=extrae_indice(str);
			 //alert("Indice:"+indice);
			 v_estado=form.elements["envios["+indice+"][eenv_ccod]"].value;
			 	if (v_estado==4){ 
			 		num += 1;
				}	
		  }
	   }
	   
   		if( num > 0 ) {
			alert('Ud. ha seleccionado '+ num +' registros que ya fueron CONCILIADOS. \nSeleccione solo los envios en estado PENDIENTES');
			return false;
		}
		else{
			return true;
		}
 }
 
	
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][envi_fenvio]","1","buscador","fecha_oculta_envi_fenvio"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="14" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="208" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          dep&oacute;sitos multidebito</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="430" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table border="0" width="100%">
                              <tr> 
                                <td width="50" height="20"><strong>N&ordm; Folio</strong></td>
                                <td width="13"><strong>:</strong></td>
                                <td width="129"><% f_busqueda.DibujaCampo("envi_ncorr") %></td>
                                <td width="34"><strong>Fecha</strong></td>
                                <td width="11"><strong>:</strong></td>
                                <td width="261"><% f_busqueda.dibujaCampo ("envi_fenvio")%> <%calendario.DibujaImagen "fecha_oculta_envi_fenvio","1","buscador" %>
                                  (dd/mm/aaaa) </td>
                              </tr>
                              <tr>
                                <td><strong>Estado</strong></td>
                                <td><strong>:</strong></td>
                                <td><% f_busqueda.dibujaCampo ("eenv_ccod")%></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                            </table></td>
                      <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          dep&oacute;sitos multidebito</font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
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
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <table width="665" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_envios.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
                    <div align="center">
                      <%f_envios.DibujaTabla %>
                    </div>
                  </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="195" bgcolor="#D8D8DE"><table width="41%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="8%"><div align="center"> 
                          <% botonera.dibujaboton "agregar_envio" %>
                        </div></td>
                      <td width="9%">
                        <%   botonera.agregabotonparam "eliminar", "url", "depositos_multidebito_eliminar.asp"
						     botonera.dibujaboton "eliminar"%>
                      </td>
                      <td width="12%"> <div align="left">
                          <%
						   'botonera.agregabotonparam "enviar_folio", "url", "proc_Envios_Tarjetas.asp"
						   botonera.agregabotonparam "enviar_folio", "url", "proc_conciliacion_deposito_multidebito.asp"
						   if cint(cantidad)=0 then
						        botonera.agregabotonparam "enviar_folio", "deshabilitado" ,"TRUE"
						   end if
						   botonera.dibujaboton "enviar_folio" %>
                        </div></td>
                      <td width="71%"> <div align="left"> 
                          <% botonera.DibujaBoton "lanzadera" %>
                        </div></td>
                    </tr>
                  </table>
                </td>
                <td width="167" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>