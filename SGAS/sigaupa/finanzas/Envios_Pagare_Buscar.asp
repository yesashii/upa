<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

 folio_envio = request.querystring("folio_envio")
 tipo_empresa = request.querystring("tipo_empresa")
set pagina = new CPagina
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

cc_empresa_envio="select tine_tdesc from tipos_instituciones_envio where tine_ccod = " & tipo_empresa
'response.write cc_empresa_envio
'response.end()
tipo_empresa_envio=conexion.consultaUno(cc_empresa_envio)
'-----------------------------------------------------------------------
 set botonera = new CFormulario
 botonera.Carga_Parametros "envios_pagare_buscar.xml", "btn_envios_pagare_buscar"
 '-----------------------------------------------------------------------------------------
 '-----------------------------------------------------------------------
   pagina.Titulo = "Agregar Pagares a Envio Notaría"

'-----------------------------------------------------------------------

 inicio = request.querystring("busqueda[-1][inicio]")
 termino = request.querystring("busqueda[-1][termino]")
 rut_alumno = request.querystring("busqueda[-1][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[-1][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[-1][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[-1][code_xdv]")
 num_pagare = request.querystring("busqueda[-1][paga_ncorr]")
 

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "envios_pagare_buscar.xml", "busqueda_letras"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "SELECT * FROM PERSONAS p WHERE p.PERS_NCORR <> p.PERS_NCORR"
 f_busqueda.Siguiente
 

 f_busqueda.AgregaCampoCons "inicio", inicio
 f_busqueda.AgregaCampoCons "termino", termino
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
 f_busqueda.AgregaCampoCons "paga_ncorr", num_pagare
 
 

'---------------------------------
 set f_letras = new CFormulario
 f_letras.Carga_Parametros "envios_pagare_buscar.xml", "listado_letras"
 f_letras.Inicializar conexion

				
'response.Write(" "&rut_alumno&" aca1<br>")			
'response.Write(" "&rut_apoderado&" aca2<br>")			

estado = true
consulta = " SELECT " & folio_envio &" AS ENVI_NCORR,"& vbCrLf &_
			"di.DING_NDOCTO,"& vbCrLf &_
			"di.DING_NDOCTO AS DING_NDOCTO2,"& vbCrLf &_
			"'N° '+CONVERT(VARCHAR,dc.DCOM_NCOMPROMISO) AS cuota," & vbCrLf &_
			"di.DING_Mdocto,"& vbCrLf &_
			"di.DING_FDOCTO,"& vbCrLf &_
			"es.EDIN_TDESC,"& vbCrLf &_
			"es.EDIN_ccod,"& vbCrLf &_
			"i.TING_CCOD,"& vbCrLf &_
			"protic.obtener_rut(p.PERS_NCORR) AS pers_nrut,"& vbCrLf &_
			"i.INGR_NCORR"& vbCrLf &_
			" FROM INGRESOS i "& vbCrLf &_
			"	INNER JOIN personas p"& vbCrLf &_
			"		ON p.PERS_NCORR = i.PERS_NCORR"
			
if rut_alumno <> "" then	
	estado = false
	consulta = consulta  & "		AND p.PERS_NRUT = " & rut_alumno 
end if
				
if rut_apoderado <> "" then
	estado = false
	consulta = consulta  &"	INNER JOIN CODEUDOR_POSTULACION cp"& vbCrLf &_
							"		ON cp.AUDI_TUSUARIO = '" & rut_apoderado & "'"& vbCrLf &_
							"		AND i.PERS_NCORR=cp.PERS_NCORR"
end if
								
if num_pagare <> "" OR incio <> "" OR termino <> "" then
	estado = false
	consulta = consulta  &"	INNER JOIN CODEUDOR_POSTULACION cp"& vbCrLf &_
							"		ON i.PERS_NCORR = cp.PERS_NCORR"
end if
consulta = consulta  &"	INNER JOIN DETALLE_INGRESOS di "& vbCrLf &_
						"		ON di.INGR_NCORR= i.INGR_NCORR"& vbCrLf &_
						"	INNER JOIN ESTADOS_DETALLE_INGRESOS es"& vbCrLf &_
						"		ON di.EDIN_CCOD = es.EDIN_CCOD"& vbCrLf &_
						"	INNER JOIN ABONOS a"& vbCrLf &_
						"		ON a.INGR_NCORR = i.INGR_NCORR"& vbCrLf &_
						"	INNER JOIN DETALLE_COMPROMISOS dc"& vbCrLf &_
						"		ON a.COMP_NDOCTO = dc.COMP_NDOCTO "& vbCrLf &_
						"		AND a.DCOM_NCOMPROMISO = dc.DCOM_NCOMPROMISO"& vbCrLf &_
						"		AND a.TCOM_CCOD = dc.TCOM_CCOD"& vbCrLf &_
						"		AND a.INST_CCOD = dc.INST_CCOD"
if num_pagare <> "" then
	consulta =  consulta &"	WHERE di.DING_NDOCTO = " & num_pagare & " AND es.EDIN_CCOD=1"
end if
if inicio <> "" AND termino <> ""then
	estado = false
	consulta =  consulta &"	WHERE di.DING_FDOCTO BETWEEN CONVERT(DATETIME, '" & inicio & "',103) AND CONVERT(DATETIME, '" & termino & "',103) AND es.EDIN_CCOD=1"

ElseIF inicio <> "" then
	estado = false
	consulta =  consulta &"	WHERE di.DING_FDOCTO >= CONVERT(DATETIME, '" & inicio & "',103) AND es.EDIN_CCOD=1"
ElseIF termino <> "" then
	estado = false
	consulta =  consulta &"	WHERE di.DING_FDOCTO <= CONVERT(DATETIME, '" & termino & "',103) AND es.EDIN_CCOD=1"
end if
consulta = consulta &"AND di.TING_CCOD=66 AND i.INGR_NCORR NOT IN (SELECT INGR_NCORR FROM DETALLE_ENVIOS de INNER JOIN ENVIOS e ON e.ENVI_NCORR = de.ENVI_NCORR) ORDER BY DING_FDOCTO"
if estado then
	consulta = "SELECT ''"
end if
			
			
'response.Write("<pre>" & consulta & "</pre>")
'response.end()
f_letras.consultar consulta


'-------------------------------------------------------------------------------------
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

<%
set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[-1][inicio]","1","buscador","fecha_inicio"
	calendario.MuestraFecha "busqueda[-1][termino]","2","buscador","fecha_termino"
	calendario.FinFuncion
%>
<script language="JavaScript">
function Validar()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["busqueda[-1][pers_nrut]"].value + "-" + formulario.elements["busqueda[-1][pers_xdv]"].value;	
	if (formulario.elements["busqueda[-1][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[-1][pers_xdv]"].focus();
		formulario.elements["busqueda[-1][pers_xdv]"].select();
		return false;
	  }
	
	rut_apoderado = formulario.elements["busqueda[-1][code_nrut]"].value + "-" + formulario.elements["busqueda[-1][code_xdv]"].value;	
    if (formulario.elements["busqueda[-1][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[-1][code_xdv]"].focus();
		formulario.elements["busqueda[-1][code_xdv]"].select();
		return false;
	   }
	return true;
}



function obtener_fecha(objeto)
{
 if (objeto == "1") 
	{
		var fecha = document.buscador.elements["fecha_inicio"].value;
	  document.buscador.elements["busqueda[-1][inicio]"].value = fecha; 
    }
  else if (objeto=="2")
    {
		var fecha = document.buscador.elements["fecha_termino"].value;
      document.buscador.elements["busqueda[-1][termino]"].value = fecha;
    }
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
                    <td width="203" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                          de Pagares</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="445" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                      <table width="660" border="0" align="left">
                        <tr> 
                          <td width="92"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                              Alumno </font></div></td>
                          <td width="10">:</td>
                          <td width="140"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("pers_nrut") %>
                            - 
                            <% f_busqueda.DibujaCampo ("pers_xdv") %>
                            </font><a href="javascript:buscar_persona('busqueda[-1][pers_nrut]', 'busqueda[-1][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td width="9">&nbsp;</td>
                          <td width="101"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                            Apoderado</font></td>
                          <td width="8">:</td>
                          <td width="147"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                              <% f_busqueda.DibujaCampo ("code_nrut") %>
                              - 
                              <% f_busqueda.DibujaCampo ("code_xdv") %>
                              </font><a href="javascript:buscar_persona('busqueda[-1][code_nrut]', 'busqueda[-1][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                          <td width="120" rowspan="3"><div align="center"></div>
                            <div align="center"> 
                              <%botonera.DibujaBoton "buscar" %>
                            </div></td>
                        </tr>
						<tr> 
						<td width="92">Fecha Inicio</td>
                                <td width="10">:</td>
                                <td width="140">
                                  <% f_busqueda.dibujaCampo ("inicio")%>
								  <% calendario.DibujaImagen "fecha_inicio","1","buscador" %>
                        </a>(DD/MM/YYYY) 
                        <input type="hidden" name="fecha">
                                </td>
								<td width="9">&nbsp;</td>
                                <td width="101">Fecha Termino</td>
                                <td width="8">:</td>
                                <td><% f_busqueda.dibujaCampo ("termino") %>
                                  <% calendario.DibujaImagen "fecha_termino","2","buscador" %>
                                (dd/mm/aaaa) </td>
                        </tr>
                        <tr> 
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">N&ordm; 
                              Pagare</font></div></td>
                          <td>:</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("paga_ncorr") %>
                            <input type="hidden" name="folio_envio" value="<%=folio_envio%>">
                            <input name="tipo_empresa" type="hidden" id="tipo_empresa2" value="<%=tipo_empresa%>">
                            </font></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle 
                          Pagares Encontrados</font></div></td>
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
                  
                <td bgcolor="#D8D8DE"><form name="edicion"><br>
                  <div align="center">
                    <%pagina.DibujarTituloPagina%>
                    <br>
                    <BR>
                  </div>
                  <table width="100%" border="0">
                      <tr>
                        <td width="12%">N&ordm; Folio</td>
                        <td width="3%">:</td>
                        <td width="21%"><%=folio_envio%></td>
                        <td width="6%">Tipo</td>
                        <td width="3%">:</td>
                        
                      <td><%=tipo_empresa_envio%></td>
                      </tr>
                    </table>
					
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_letras.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table>
                  <br>
                  <form name="edicion">
				    <table width="100%" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>
				   <div align="center">
			          <% f_letras.DibujaTabla() %>
			         </div>
				   </td>
                      </tr>
                    </table></form><br><br>
                    				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center">
                          <% if ( f_letras.nrofilas >0) then 
						      botonera.AgregaBotonParam "guardar_pagare","deshabilitado","FALSE"
							  
						  else 
						      botonera.AgregaBotonParam "guardar_pagare","deshabilitado","TRUE"
						  end if 
						  %>
                          <% botonera.DibujaBoton "guardar_pagare"%>
                        </div></td>
                      <td><div align="center"> 
                          <% botonera.DibujaBoton "cancelar" %>
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
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
