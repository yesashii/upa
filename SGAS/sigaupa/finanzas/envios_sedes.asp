<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Envíos de documentos entre Sedes"
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
botonera.Carga_Parametros "envios_sedes.xml", "botonera"
'---------------------------------------------------------------------------------------------------
 folio = request.querystring("busqueda[0][esed_ncorr]")
 sede_origen = request.querystring("busqueda[0][sede_origen]")
 sede_destino = request.querystring("busqueda[0][sede_destino]")
 fecha = request.querystring("busqueda[0][esed_fenvio]")
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "envios_sedes.xml", "busqueda_envios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "esed_ncorr", folio
 f_busqueda.AgregaCampoCons "sede_origen", sede_origen
 f_busqueda.AgregaCampoCons "sede_destino", sede_destino
 f_busqueda.AgregaCampoCons "esed_fenvio", fecha
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito

'----------------------------------------------------------------------------------
set f_envios = new CFormulario
f_envios.Carga_Parametros "envios_sedes.xml", "f_envios"
f_envios.Inicializar conexion

 
consulta =  " select a.esed_ncorr, a.eenv_ccod, d.eenv_tdesc,a.esed_ncorr as c_esed_ncorr, a.esed_ncorr as c2_esed_ncorr, "& vbCrLf &_
			"        b.sede_tdesc as sede_origen,z.sede_tdesc as sede_destino, a.esed_fenvio, "& vbCrLf &_
			"        protic.cantidad_documentos_envio_sedes(a.esed_ncorr) as cant_doc "& vbCrLf &_
			" from "& vbCrLf &_
			" envios_sedes a join sedes b"& vbCrLf &_
			"    on a.sede_origen = b.sede_ccod"& vbCrLf &_
			" join sedes z"& vbCrLf &_
			"    on a.sede_destino = z.sede_ccod"& vbCrLf &_
			" join estados_envio d "& vbCrLf &_
			"    on a.eenv_ccod = d.eenv_ccod"& vbCrLf &_
			" left outer join detalle_envios_sedes f "& vbCrLf &_
			"    on  a.esed_ncorr = f.esed_ncorr "& vbCrLf &_
			" left outer join detalle_ingresos g "& vbCrLf &_
			"    on g.ting_ccod = f.ting_ccod "& vbCrLf &_
			"	 and g.ding_ndocto = f.ding_ndocto "& vbCrLf &_
			"	 and g.ingr_ncorr = f.ingr_ncorr "& vbCrLf &_
			" left outer join ingresos h"& vbCrLf &_
			"    on g.ingr_ncorr = h.ingr_ncorr"& vbCrLf &_
			" left outer join personas i"& vbCrLf &_
			"    on i.pers_ncorr = h.pers_ncorr"& vbCrLf &_
			" left outer join personas j "& vbCrLf &_
			"    on g.PERS_NCORR_CODEUDOR = j.pers_ncorr "& vbCrLf &_
			" where 1=1 "


			  if  rut_alumno <> ""  then 
				    consulta = consulta & " and i.pers_nrut= '" & rut_alumno & "' "
	    	  end if
				  
				  if  rut_apoderado <> ""  then 
				    consulta = consulta &  " and j.pers_nrut = '" & rut_apoderado & "' "
				  end if
				  
				  if  folio <> ""  then 
				    consulta = consulta & " and a.esed_ncorr = '" & folio & "' "
				  end if
				  
				   if fecha  <> "" then 
				  	consulta = consulta & " and convert(datetime,a.envi_fenvio,103) = '" & fecha & "'"
				  end if
				  			  
				 if sede_destino <> "" then
 				     consulta = consulta & " and cast(a.sede_destino as varchar) = '" & sede_destino &  "' "
				  end if
				 if sede_origen <> "" then
 				     consulta = consulta & " and cast(a.sede_origen as varchar) = '" & sede_origen &  "' "
				  end if				  				
			 	consulta = consulta & " group by a.esed_ncorr,  b.sede_tdesc, z.sede_tdesc, a.esed_fenvio,d.eenv_tdesc,a.eenv_ccod  "& vbCrLf &_
				"order by a.esed_ncorr DESC "
 
'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()
 if Request.QueryString <> "" then
	  f_envios.consultar consulta
  else
	f_envios.consultar "select '' where 1 = 2"
	f_envios.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

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


 function valida_depositos(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
		  	 indice=extrae_indice(str);
			 v_estado=form.elements["envios["+indice+"][eenv_ccod]"].value;
			 	if (v_estado!=1){ 
			 		num += 1;
				}	
		  }
	   }
   		if( num > 0 ) {
			alert('Ud. ha seleccionado '+ num +' registros no estan en estado Pendiente. \nSeleccione solo los envios en estado PENDIENTE para Enviar');
			return false;
		}
		else{return true;}
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                          de Env&iacute;os a Sedes </font></div></td>
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
                      <td width="81%"><table width="524" border="0">
                        <tr>
                          <td width="86" height="20">N&ordm; Folio</td>
                          <td width="17">:</td>
                          <td width="151"><% f_busqueda.DibujaCampo("esed_ncorr") %></td>
                          <td width="93">Fecha</td>
                          <td width="12">:</td>
                          <td width="139"><% f_busqueda.dibujaCampo ("esed_fenvio")%>
						  <%calendario.DibujaImagen "fecha_oculta_envi_fenvio","1","buscador" %>(dd/mm/aaaa)
                          </td>
                        </tr>
                        <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <%f_busqueda.DibujaCampo("pers_nrut") %>
                            -
                            <%f_busqueda.DibujaCampo("pers_xdv")%>
</font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td>Rut Apoderado</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                            <%f_busqueda.DibujaCampo("code_nrut")%>
                            -
                            <%f_busqueda.DibujaCampo("code_xdv")%>
</font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                        </tr>
                        <tr>
                          <td>Sede Origen </td>
                          <td>:</td>
                          <td><% f_busqueda.dibujaCampo ("sede_origen") %>
                          </td>
                          <td>Sede Destino </td>
                          <td>:</td>
                          <td><% f_busqueda.dibujaCampo ("sede_destino") %></td>
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
                          de Env&iacute;os
                          a Sedes </font></div>
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
                        <%   botonera.agregabotonparam "eliminar", "url", "envios_sede_eliminar.asp"
						     botonera.dibujaboton "eliminar"%>
                      </td>
                      <td width="12%"> <div align="left">
                          <%
						   botonera.agregabotonparam "enviar_folio", "url", "proc_envios_sede.asp"
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