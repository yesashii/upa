<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set pagina = new CPagina
pagina.Titulo = "Detalle de Letras del envío"
'-------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'-------------------------------------------------------------------------------------------
set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------------------
'para que me puedea entregar ultima postulacion del alumno 
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Envios_banco.xml", "botonera"

'-------------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
rut_alumno = request.Form("busqueda[0][pers_nrut]")
rut_alumno_digito = request.Form("busqueda[0][pers_xdv]")
v_pago 			 = Request.QueryString("pago")
'------------------------------------------------------------------------- 

set f_sub_busqueda = new CFormulario
f_sub_busqueda.Carga_Parametros "Envios_Banco.xml", "f_sub_busqueda"
f_sub_busqueda.Inicializar conexion
consulta = "select ''"
f_sub_busqueda.Consultar consulta
f_sub_busqueda.siguiente
f_sub_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
f_sub_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
'-------------------------------------------------------------------------

set f_envio = new CFormulario
f_envio.Carga_Parametros "Envios_Banco.xml", "f_envios"
f_envio.Inicializar conexion
consulta = "SELECT envios.eenv_ccod, envios.envi_ncorr, envios.envi_fenvio, envios.inen_ccod, "& vbCrLf &_
			 "instituciones_envio.inen_tdesc, envios.plaz_ccod, plazas.plaz_tdesc, cuentas_corrientes.ccte_tdesc "& vbCrLf &_
			"FROM envios, instituciones_envio, plazas, cuentas_corrientes "& vbCrLf &_
			"WHERE ((envios.inen_ccod = instituciones_envio.inen_ccod) "& vbCrLf &_
			 "AND (envios.plaz_ccod = plazas.plaz_ccod)) "& vbCrLf &_
			 "AND envios.ccte_ccod = cuentas_corrientes.ccte_ccod "& vbCrLf &_
			 "AND envios.envi_ncorr=" & folio_envio 
 'response.Write("<pre>"&consulta&"</pre>")
 f_envio.Consultar consulta
 f_envio.siguiente
 estado_envio =  f_envio.obtenervalor("eenv_ccod")
 banco = f_envio.obtenervalor("inen_ccod")

'----------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Banco.xml", "f_detalle_envio"
f_detalle_envio.Inicializar conexion

consulta = "select a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ,b.ding_ndocto,"& vbCrLf &_
			"        c.ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,"& vbCrLf &_
			"        c.ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,"& vbCrLf &_
			"        cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,  "& vbCrLf &_
			"        protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado "& vbCrLf &_
			"    from envios a,detalle_envios b,detalle_ingresos c,estados_detalle_ingresos c1,"& vbCrLf &_
			"    ingresos d,personas e,personas f"& vbCrLf &_
			"    where a.envi_ncorr = b.envi_ncorr"& vbCrLf &_
			"    and b.ting_ccod = c.ting_ccod  "& vbCrLf &_
			"    and b.ding_ndocto = c.ding_ndocto  "& vbCrLf &_
			"    and b.ingr_ncorr = c.ingr_ncorr"& vbCrLf &_
			"    and c.edin_ccod = c1.edin_ccod "& vbCrLf &_
			"    and c.ingr_ncorr = d.ingr_ncorr"& vbCrLf &_
			"    and d.pers_ncorr = e.pers_ncorr"& vbCrLf &_
			"    and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr"& vbCrLf &_
			"    and c.DING_NCORRELATIVO = 1"& vbCrLf &_
			"    and cast(a.envi_ncorr as varchar) ='" & folio_envio & "'"
			
				  if rut_alumno <> "" then
				    consulta = consulta &  " and cast(e.pers_nrut as varchar) ='" & rut_alumno & "' "
				  end if
				  
'response.Write("<pre>"&consulta&"</pre>")			 


'response.Write("<PRE>" & consulta & "</PRE>")
if v_pago="S" then
consulta="select a.envi_ncorr, a.ting_ccod,b.ding_ndocto as c_ding_ndocto,a.ingr_ncorr,b.ding_ndocto,"& vbCrLf &_
				"b.ding_mdocto,protic.trunc(ingr_fpago) as ingr_fpago, "& vbCrLf &_
				"b.ding_fdocto,d.edin_ccod,case when d.edin_ccod=1 then 'EN CARTERA (abonada)' else d.edin_tdesc end as edin_tdesc,"& vbCrLf &_
				"protic.obtener_rut(pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno,"& vbCrLf &_
				"protic.obtener_rut(pers_ncorr_codeudor) as rut_apoderado, protic.obtener_nombre_completo(pers_ncorr_codeudor,'n') as nombre_apoderado "& vbCrLf &_
				"from detalle_envios a, detalle_ingresos b, ingresos c, estados_detalle_ingresos d "& vbCrLf &_
				"where a.envi_ncorr in ('" & folio_envio & "')"& vbCrLf &_
				"and a.ingr_ncorr=b.ingr_ncorr"& vbCrLf &_
				"and b.ingr_ncorr=c.ingr_ncorr"& vbCrLf &_
				"and protic.documento_pagado_x_otro(a.ingr_ncorr,'S','P')>0"& vbCrLf &_
				"and b.edin_ccod=d.edin_ccod"
end if
f_detalle_envio.Consultar consulta

v_inen_ccod = conexion.ConsultaUno("select inen_ccod from envios where envi_ncorr = '" & folio_envio & "'")

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
function Validar()
{
	formulario = document.edicion;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	 {
	   if (!valida_rut(rut_alumno))
	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		 return false;
	   }
	 }
	/*else
	  {
	    alert('Ingrese el numero de RUT');
		formulario.elements["busqueda[0][pers_nrut]"].focus();
		formulario.elements["busqueda[0][pers_nrut]"].select();
		return false;
	  }*/
	return true;
}


function subBuscar()
{
   if (Validar() == true )
   {   
      edicion.method="post";
	  edicion.action="Envios_Banco_Agregar1.asp?folio_envio=<%=folio_envio%>"
	  edicion.submit();
   }
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                <td><%pagina.dibujarLenguetas array (array("Detalle Letras","Envios_Banco_Agregar1.asp"),array("Letras por Apoderado","Envios_Banco_Agregar2.asp?folio_envio="& folio_envio)),1 %>
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
                    <BR>
                  </div>
                  <form name="edicion" method="post" action="">
                    <table width="100%" border="0">
                      <tr> 
                        <td><strong>N&ordm; Folio</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <% f_envio.DibujaCampo("envi_ncorr") %>
                          </font></td>
                        <td><strong>Fecha</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <% f_envio.DibujaCampo("envi_fenvio") %>
                          </font></td>
                      </tr>
                      <tr>
                        <td><strong>Banco</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <% f_envio.DibujaCampo("inen_tdesc") %>
                          </font></td>
                        <td><strong>Plaza</strong></td>
                        <td><strong>:</strong></td>
                        <td><font size="2"> 
                          <% f_envio.DibujaCampo("plaz_tdesc") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td width="9%"><strong>Cta. Cte</strong></td>
                        <td width="3%"><strong>:</strong></td>
                        <td width="37%"><font size="2"> 
                          <% f_envio.DibujaCampo("ccte_tdesc") %>
                          </font></td>
                        <td width="10%">&nbsp;</td>
                        <td width="2%">&nbsp;</td>
                        <td width="39%">&nbsp;</td>
                      </tr>
                    </table><BR><BR>
					<%pagina.dibujarsubtitulo "Búsqueda de letras en el envío"%>
					<div align="center">
                      <table width="100%" border="0">
                        <tr> 
                          <td width="16%"><strong>Rut Alumno</strong></td>
                          <td width="4%"><strong>:</strong></td>
                          <td width="55%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <%f_sub_busqueda.DibujaCampo("pers_nrut")%>
                            - 
                            <%f_sub_busqueda.DibujaCampo("pers_xdv")%>
                            </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td width="25%">
                            <% botonera.DibujaBoton "sub_buscar" %>
                          </td>
                        </tr>
                      </table>
                      <BR>
                     
                    </div>
                    <table width="665" border="0">
                      <tr>
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp;
                                <%f_detalle_envio.AccesoPagina%>
                          </div>
                        </td>
                        <td width="24">
                          <div align="right"> </div>
                        </td>
                      </tr>
                    </table>
                    <div align="center"><BR>
                      <% f_detalle_envio.DibujaTabla%>
                    </div>
                    </form>
                    
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="459" bgcolor="#D8D8DE">
				  <table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="12%"> <div align="left"> 
                          <%  'botonera.agregabotonparam "anterior", "url", "Envios_Banco.asp?busqueda[0][envi_ncorr]="& folio_envio
						      botonera.agregabotonparam "anterior", "url", "Envios_Banco.asp?envi_ncorr="& folio_envio
						      botonera.DibujaBoton "anterior"  %>
                        </div></td>
                      <td width="14%"><%  if estado_envio = "2" then
					                        botonera.agregabotonparam "agregar_letras", "deshabilitado" ,"TRUE"
										 end if
										 botonera.agregabotonparam "agregar_letras", "url" ,"Envios_Banco_Buscar.asp?folio_envio="& folio_envio 
										 botonera.DibujaBoton "agregar_letras"
									  %> </td>
                      <td width="19%"><%if estado_envio = "2" then
					                       botonera.agregabotonparam "eliminar", "deshabilitado" ,"TRUE"
										end if
					                       botonera.agregabotonparam "eliminar", "url", "Envios_Banco_Eliminar_Letra.asp"
						                   botonera.dibujaboton "eliminar"
										 %> </td>
                      <td width="19%">
                        <%  botonera.agregabotonparam "imprimir", "url", "../REPORTESNET/detalle_envio_banco.aspx?folio_envio=" & folio_envio & "&periodo=" & Periodo 
 		                    botonera.dibujaboton "imprimir"
										 %>
					</td>
					<td width="20%"><% 
					'response.Write(v_inen_ccod)
							if v_inen_ccod = "1" or v_inen_ccod = "2" or v_inen_ccod = "3" or v_inen_ccod = "4" or v_inen_ccod = "17" then 'archivos de texto
					  			SELECT CASE v_inen_ccod
									CASE "1":
										botonera.agregabotonparam "archivo_texto", "url", "carta_guia_bci.asp"
									CASE "2":
										botonera.agregabotonparam "archivo_texto", "url", "carta_guia_chile.asp"
									CASE "3":
										botonera.agregabotonparam "archivo_texto", "url", "carta_guia_santander.asp"
									CASE "4":
										botonera.agregabotonparam "archivo_texto", "url", "carta_guia_scotiabank.asp"
									CASE "17":
										botonera.agregabotonparam "archivo_texto", "url", "carta_guia_corpbanca.asp"		
									END SELECT	
								botonera.AgregaBotonUrlParam "archivo_texto", "envi_ncorr", folio_envio
								botonera.AgregaBotonUrlParam "archivo_texto", "todos", "SI"
								botonera.DibujaBoton ("archivo_texto") 
							end if
							%>
                      </td>
					  <td width="16%">
					  					    <%									
						 botonera.agregabotonparam "ver_pagadas", "url", "Envios_Banco_Agregar1.asp?folio_envio="& folio_envio&"&pago=S" 
 		                 botonera.dibujaboton "ver_pagadas"
										 %>
					  </td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="81" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="137" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
