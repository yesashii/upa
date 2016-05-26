<%
q_origen = Request.QueryString("origen")
if(q_origen="1") then
	q_rut = Request.QueryString("rut")
	q_peri = Request.QueryString("peri")
	q_sede = Request.QueryString("sede")
	session("sede")=q_sede
	session("_periodo")=q_peri
	session("rut_usuario")=q_rut
'response.End()
end if
%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Depósitos"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()

if v_usuario="8533344" or v_usuario="12234131"  then
		'or v_usuario="15785003" if v_usuario="15785003" or v_usuario="13582834" or v_usuario="14205430" or v_usuario="12366148" then
	comentario=""
else
	comentario="--"
end if
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Depositos.xml", "botonera"
'-----------------------------------------------------------------------
 deposito 			= request.querystring("busqueda[0][envi_ncorr]")
 fecha 				= request.querystring("busqueda[0][envi_fenvio]")
 cuenta_corriente 	= request.querystring("busqueda[0][ccte_tdesc]")
 eenv_ccod 			= request.querystring("busqueda[0][eenv_ccod]")

 fecha_url=fecha
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Depositos.xml", "busqueda_depositos"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "envi_ncorr", deposito
 f_busqueda.AgregaCampoCons "envi_fenvio", fecha
 f_busqueda.AgregaCampoCons "ccte_tdesc", cuenta_corriente
 f_busqueda.AgregaCampoCons "eenv_ccod", eenv_ccod
 
 '----------------------------------------------------------------------------------
set f_depositos = new CFormulario
f_depositos.Carga_Parametros "depositos.xml", "f_depositos"
f_depositos.Inicializar conexion

	  
consulta = "select a.ENVI_MEFECTIVO,a.tdep_ccod,a.envi_ncorr, a.envi_ncorr as c_envi_ncorr, a.envi_ncorr as c2_envi_ncorr,"& vbCrLf &_
			"        b.inen_tdesc, c.CCTE_TDESC, a.envi_fenvio, d.eenv_tdesc, a.envi_tdescripcion, "& vbCrLf &_
			"        protic.cantidad_documentos_envio(a.envi_ncorr) as cant_doc, a.eenv_ccod, "& vbCrLf &_
			"        case a.tdep_ccod when 3 then a.ENVI_MEFECTIVO else protic.total_valor_envio(a.envi_ncorr) end as total "& vbCrLf &_
			"			    From envios a "& vbCrLf &_
			"    join instituciones_envio b "& vbCrLf &_
			"        on a.inen_ccod = b.inen_ccod "& vbCrLf &_
			"    join cuentas_corrientes c "& vbCrLf &_
			"        on a.CCTE_CCOD = c.ccte_ccod "& vbCrLf &_
			"    join estados_envio d "& vbCrLf &_
			"        on a.eenv_ccod = d.eenv_ccod "& vbCrLf &_
			"    left outer join detalle_envios f "& vbCrLf &_
			"        on a.envi_ncorr = f.envi_ncorr "& vbCrLf &_
			"    left outer join detalle_ingresos g "& vbCrLf &_
			"        on f.ting_ccod = g.ting_ccod "& vbCrLf &_
			"        and f.ding_ndocto = g.ding_ndocto "& vbCrLf &_   
			"        and f.ingr_ncorr = g.ingr_ncorr "& vbCrLf &_
			"    left outer join ingresos h "& vbCrLf &_
			"        on g.ingr_ncorr = h.ingr_ncorr "& vbCrLf &_
			"    left outer join personas i "& vbCrLf &_
			"        on h.pers_ncorr = i.pers_ncorr "& vbCrLf &_
			"    left outer join personas j "& vbCrLf &_
			"        on g.PERS_NCORR_CODEUDOR = j.pers_ncorr "& vbCrLf &_
			"   Where a.tenv_ccod = 2 "& vbCrLf &_
			"    "&comentario&" and a.audi_tusuario like '%"&v_usuario&"%' "& vbCrLf &_
			"    and b.TINE_CCOD = 1"
			

				 if  deposito <> ""  then 
				    consulta = consulta & "and a.envi_ncorr = '" & deposito & "' "
				  end if
				  
		  	    if fecha  <> "" then 
				  	consulta = consulta & "and convert(datetime,a.envi_fenvio,103)  ='" & fecha & "' "
				  end if
				
				 if cuenta_corriente  <> "" then 
				  	consulta = consulta & "and c.ccte_tdesc  ='" & cuenta_corriente & "' "
				  end if
				  
				  if eenv_ccod  <> "" then 
				  	consulta = consulta & "and a.eenv_ccod  ='" & eenv_ccod & "' "
				  end if
								
			 	consulta = consulta & "group by a.envi_ncorr,  b.inen_tdesc, c.CCTE_TDESC, a.envi_fenvio, d.eenv_tdesc ,a.ENVI_MEFECTIVO,a.tdep_ccod, a.envi_tdescripcion, a.eenv_ccod"& vbCrLf &_
				"order by a.envi_ncorr DESC "			
  
  
  'response.Write("<pre>" & consulta & "</pre>")
  'response.End()
  if Request.QueryString <> "" then
	  f_depositos.consultar consulta
  else
	f_depositos.consultar "select '' where 1=2"
	f_depositos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta&"</pre>")				 
'response.End()
cantidad= f_depositos.nroFilas
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
function validar_deposito_pendiente(form){

v_valida=valida_depositos(form);

	if (v_valida==true) {
		v_check=verifica_check(form,1);
		if (v_check==true){
			return true;	
		}else{
			return false;
		}
	}else{return false;}
}	

function validar_deposito_enviado(form){

//v_valida=valida_envios(form);
v_valida=true;
	if (v_valida==true) {
		v_check=verifica_check(form,2);
		if (v_check==true){
			return true;	
		}else{
			return false;
		}
	}else{return false;}
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
			 v_estado=form.elements["depositos["+indice+"][eenv_ccod]"].value;
			 	if ((v_estado==4)||(v_estado==1)){ 
			 		num += 1;
				}	
		  }
	   }
	   
   		if( num > 0 ) {
			alert('Ud. ha seleccionado '+ num +' registros no estan en estado enviado. \nSeleccione solo los envios en estado ENVIADO para conciliar');
			return false;
		}
		else{
			return true;
		}
 }
 
 function valida_depositos(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
		  	 indice=extrae_indice(str);
			 v_estado=form.elements["depositos["+indice+"][eenv_ccod]"].value;
			 	if (v_estado!=1){ 
			 		num += 1;
				}	
		  }
	   }
   		if( num > 0 ) {
			alert('Ud. ha seleccionado '+ num +' registros no estan en estado Pendiente. \nSeleccione solo los envios en estado PENDIENTE para depositar');
			return false;
		}
		else{return true;}
 }


function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

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
              <td><%pagina.DibujarLenguetas Array("Búsqueda de depósitos"), 1%></td>
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
                      <td width="81%"><br>                        
                            <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr>
                          <td width="24%">N&ordm; Dep&oacute;sito </td>
                          <td width="3%"><div align="center">:</div></td>
                          <td width="28%">
                            <div align="left">
                              <% f_busqueda.dibujaCampo ("envi_ncorr")%>
                            </div></td>
                          <td width="2%">&nbsp;</td>
                          <td width="11%">Fecha</td>
                          <td width="3%"><div align="center">:</div></td>
                          <td width="29%"><% f_busqueda.dibujaCampo ("envi_fenvio")%>
						  <%calendario.DibujaImagen "fecha_oculta_envi_fenvio","1","buscador" %>(dd/mm/aaaa) 
                        </tr>
                        <tr>
                          <td>Cuenta Corriente </td>
                          <td><div align="center">:</div></td>
                          <td>
                            <div align="left">
                             <% f_busqueda.dibujaCampo ("ccte_tdesc")%>
                            </div></td>
                          <td>&nbsp;</td>
                          <td>Estado</td>
                          <td><div align="center">:</div></td>
                          <td><% f_busqueda.dibujaCampo ("eenv_ccod")%></td>
                        </tr>
                      </table></td>
                      <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center"><BR> 
                    <%pagina.DibujarTituloPagina%>
                    <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_depositos.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
                    <div align="center"> 
								<% f_depositos.DibujaTabla()%>
                    </div>
				    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="153" bgcolor="#D8D8DE"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="14%"> <div align="left">
                          <% botonera.DibujaBoton "nuevo_deposito"  %>
                        </div></td>
                      <td width="14%"> <div align="left">
                          <% botonera.AgregaBotonParam "eliminar","url","Depositos_Eliminar.asp"
						     botonera.DibujaBoton "eliminar" %>
                        </div></td>
                      <td width="16%">
<!--
                        <%  botonera.AgregaBotonParam "depositar","url","proc_Depositos.asp"
						     if cint(cantidad)=0 then
						        botonera.agregabotonparam "depositar", "deshabilitado" ,"TRUE"
						     end if
						     botonera.DibujaBoton ("depositar")
						%>
-->
                      </td>
					   <td width="14%"> <div align="left">
					   
                          <%  botonera.AgregaBotonParam "excel","url","Deposito_excel.asp?envi_ncorr="&deposito&"&envi_fenvio="&fecha_url&"&ccte_tdesc="&cuenta_corriente&"&eenv_ccod="&eenv_ccod 
						     if cint(cantidad)=0 then
						     botonera.agregabotonparam "excel", "deshabilitado" ,"TRUE"
							 end if
							 botonera.DibujaBoton ("excel")
							 %>
                        </div></td>
					  
                      <td > 
                        	<% ' Botón 
							botonera.DibujaBoton "conciliacion"
							%> 
                      </td>
					  <td>	<% botonera.DibujaBoton "lanzadera"%></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="202" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
