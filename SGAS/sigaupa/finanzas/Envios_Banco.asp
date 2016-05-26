<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Envíos a Banco"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
sede = negocio.ObtenerSede
v_usuario = negocio.ObtenerUsuario()

'or v_usuario="15785003"
if v_usuario="8533344" or v_usuario="10536373" or v_usuario="12234131"  then
	comentario=""
else
	comentario="--"
end if
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Envios_Banco.xml", "botonera"
'-----------------------------------------------------------------------
 'sede = request.querystring("busqueda[0][sede_ccod]")
 folio = request.querystring("busqueda[0][envi_ncorr]")
 plaza = request.querystring("busqueda[0][plaz_ccod]")
 banco = request.querystring("busqueda[0][inen_ccod]")
 inicio = request.querystring("busqueda[0][envi_fenvio]")
 termino = request.querystring("busqueda[0][envio_termino]") 
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Envios_banco.xml", "busqueda_envios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente

 f_busqueda.AgregaCampoCons "sede_ccod", sede
 f_busqueda.AgregaCampoCons "envi_ncorr", folio
 f_busqueda.AgregaCampoCons "plaz_ccod", plaza
 f_busqueda.AgregaCampoCons "inen_ccod", banco
 f_busqueda.AgregaCampoCons "envi_fenvio", inicio
 f_busqueda.AgregaCampoCons "envio_termino", termino
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito

'----------------------------------------------------------------------------------
set f_envios = new CFormulario
f_envios.Carga_Parametros "Envios_Banco.xml", "f_envios"
f_envios.Inicializar conexion

			  
consulta = "select a.envi_ncorr,k.tins_tdesc as tins_tdesc,"& vbCrLf &_
			"		a.envi_ncorr as c_envi_ncorr, a.envi_ncorr as c2_envi_ncorr, "& vbCrLf &_
			"        b.inen_tdesc, c.CCTE_TDESC, a.envi_fenvio, d.eenv_tdesc, e.plaz_tdesc, "& vbCrLf &_
			"        protic.cantidad_documentos_envio(a.envi_ncorr) as cant_doc, a.tcob_ccod "& vbCrLf &_
			" from "& vbCrLf &_
			"envios a join instituciones_envio b"& vbCrLf &_
			"    on a.inen_ccod = b.inen_ccod"& vbCrLf &_
			"join cuentas_corrientes c"& vbCrLf &_
			"    on a.CCTE_CCOD = c.ccte_ccod"& vbCrLf &_
			"join estados_envio d"& vbCrLf &_
			"    on a.eenv_ccod = d.eenv_ccod"& vbCrLf &_
			"join  plazas e"& vbCrLf &_
			"    on a.plaz_ccod = e.plaz_ccod"& vbCrLf &_
			"left outer join detalle_envios f"& vbCrLf &_
			"    on a.envi_ncorr = f.envi_ncorr"& vbCrLf &_
			"left outer join detalle_ingresos g"& vbCrLf &_
			"    on g.ting_ccod = f.ting_ccod and g.ding_ndocto = f.ding_ndocto and g.ingr_ncorr = f.ingr_ncorr "& vbCrLf &_
			"left outer join ingresos h"& vbCrLf &_
			"    on g.ingr_ncorr = h.ingr_ncorr"& vbCrLf &_
			"left outer join personas i"& vbCrLf &_
			"    on i.pers_ncorr=h.pers_ncorr"& vbCrLf &_
			"left outer join personas j"& vbCrLf &_
			"    on g.PERS_NCORR_CODEUDOR = j.pers_ncorr"& vbCrLf &_
			"join tipos_instrumentos k"& vbCrLf &_
			"    on a.tins_ccod = k.tins_ccod "& vbCrLf &_
			" where  a.tenv_ccod = 1"& vbCrLf &_
			" "&comentario&" and a.audi_tusuario like '%"&v_usuario&"%'"& vbCrLf &_
			" and b.TINE_CCOD = 1"& vbCrLf &_
			" --and cast(c.sede_ccod as varchar) = '" & sede & "'"& vbCrLf
				  

				  if banco <> "" then
 				     consulta = consulta & "and cast(a.inen_ccod as varchar) = '" & banco &  "' "
				  end if
				  
				  if  rut_apoderado <> ""  then 
				    consulta = consulta &  "and cast(j.pers_nrut as varchar) = '" & rut_apoderado & "' "
				  end if
				  
				  if  folio <> ""  then 
				    consulta = consulta & "and cast(a.envi_ncorr as varchar) = '" & folio & "' "
				  end if
				  
				  if  plaza <> ""  then 
				    consulta = consulta & "and cast(a.plaz_ccod as varchar) = '" & plaza & "' "
				  end if
				  
				  if  rut_alumno <> ""  then 
				    consulta = consulta & "and cast(i.pers_nrut as varchar) = '" & rut_alumno & "' "
				  end if
				  
				  if inicio  <> ""  or  termino <> "" then 
				  	consulta = consulta & "and convert(datetime,a.envi_fenvio,103)  BETWEEN isnull(convert(datetime,'" & inicio & "',103), convert(datetime,a.envi_fenvio,103)) AND  isnull(convert(datetime,'" & termino & "',103), convert(datetime,a.envi_fenvio,103)) "
				  end if
				
			 	consulta = consulta & "group by a.envi_ncorr,  b.inen_tdesc, c.CCTE_TDESC, a.envi_fenvio, d.eenv_tdesc, e.plaz_tdesc, k.tins_tdesc, a.eenv_ccod ,a.tcob_ccod"& vbCrLf &_
				"order by a.envi_ncorr DESC "			

  if Request.QueryString <> "" then
     'response.Write("<PRE>" & consulta & "</PRE>")
     'response.End()
	 f_envios.Consultar consulta
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

function editar_envio(envi_ncorr)
{
  resultado = open("editar_envio_banco.asp?envi_ncorr=" + envi_ncorr,"", "top=100, left=100, width=510, height=270, scrollbars=yes");	
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][envi_fenvio]","1","buscador","fecha_oculta_envi_fenvio"
	calendario.MuestraFecha "busqueda[0][envio_termino]","2","buscador","fecha_oculta_envio_termino"	
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
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="210" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Env&iacute;os a Banco</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                          <!--<td><div align="left">Sede</div>
                          </td>
                          <td>:</td>
                          <td><% 'f_busqueda.dibujaCampo ("sede_ccod") %>
                          </td>-->
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td>Periodo Inicio</td>
                          <td>:</td>
                          <td><div align="left"></div>
                              <% f_busqueda.dibujaCampo ("envi_fenvio")%>
							  <%calendario.DibujaImagen "fecha_oculta_envi_fenvio","1","buscador" %>(dd/mm/aaaa)
                          </td>
                          <td>T&eacute;rmino</td>
                          <td>:</td>
                          <td><div align="left">
                              <%f_busqueda.dibujacampo("envio_termino") %>
							  <%calendario.DibujaImagen "fecha_oculta_envio_termino","2","buscador" %>(dd/mm/aaaa)
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td>Banco</td>
                          <td>:</td>
                          <td><% f_busqueda.dibujaCampo ("inen_ccod") %></td>
                          <td>Plaza</td>
                          <td>:</td>
                          <td><% f_busqueda.dibujaCampo ("plaz_ccod") %>
                          </td>
                        </tr>
                        <tr>
                          <td height="20">N&ordm; Folio</td>
                          <td>:</td>
                          <td><% f_busqueda.dibujaCampo ("envi_ncorr")%></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
<%f_busqueda.DibujaCampo("pers_nrut") %>-
<%f_busqueda.DibujaCampo("pers_xdv")%>
                          </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                              Apoderado</font></td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
    <%f_busqueda.DibujaCampo("code_nrut")%>-<%f_busqueda.DibujaCampo("code_xdv")%>    
                            </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                          </td>
                        </tr>
                      </table></td>
                      <td width="19%"><div align="center">
                        <%botonera.DibujaBoton "buscar" %>
                      </div></td>
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
                          a Banco</font></div>
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
                  </div>
                  <table width="665" border="0">
                    <tr>
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_envios.AccesoPagina%>
                      </div></td>
                      <td width="24">
                        <div align="right">                          </div></td>
                    </tr>
                  </table>
                     <form name="edicion">
                    <div align="center">
                      <% f_envios.DibujaTabla %>                 
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
                <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="8%">
                        <div align="left">
                          <% botonera.dibujaboton "agregar_envio" %>
                          </div></td>
                      <td width="8%">
                        <div align="left">
                          <% botonera.agregabotonparam "eliminar", "url", "Envios_Banco_Eliminar.asp"
						     botonera.dibujaboton "eliminar"%>
                          </div></td>
                      <td width="11%"><div align="left">
                          <%
						   botonera.agregabotonparam "enviar_folio", "url", "proc_Envios_Banco.asp"
						   if cint(cantidad)=0 then
						        botonera.agregabotonparam "enviar_folio", "deshabilitado" ,"TRUE"
						   end if
						   botonera.dibujaboton "enviar_folio" %>
                        </div></td>
                      <td width="73%">
                        <div align="left"> 
                          <%botonera.dibujaboton "lanzadera" %>
                        </div></td>
                    </tr>
                  </table>
                </td>
                <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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