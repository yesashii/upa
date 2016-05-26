<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Homologaciones"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_homologaciones_malla.xml", "botonera"


usuario = negocio.obtenerUsuario
'-----------------------------------------------------------------------
'facu_ccod = request.querystring("busqueda[0][facu_ccod]")
'area_ccod = request.querystring("busqueda[0][area_ccod]")
homo_nresolucion = request.querystring("homo_nresolucion")
carr_ccod = request.querystring("b[0][carr_ccod]")

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_homologaciones_malla.xml", "combo_carrera"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 consulta_carreras = "(select distinct a.carr_ccod,a.carr_tdesc from carreras a "&_
					 " where exists (select 1 from ofertas_academicas b, especialidades c where b.espe_ccod=c.espe_ccod and a.carr_ccod=c.carr_ccod))a"
					 
 f_busqueda.Agregacampoparam "carr_ccod", "destino" , consulta_carreras
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 

 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
 set f_homologacion = new CFormulario
 f_homologacion.Carga_Parametros "m_homologaciones_malla.xml", "f_homologacion"
 f_homologacion.Inicializar conexion
 consulta = "SELECT '<a href=""javascript:ver_detalle_homo(' +  cast(a.homo_ccod as varchar) + ')"" title=""Ver homologaciones"">' + b.thom_tdesc + '</a>' as thom_tdesc, a.area_ccod,a.homo_ccod, " & vbCrLf &_
            " '<a href=""javascript:irA_homo('+cast(a.homo_ccod as varchar)+','+cast(a.area_ccod as varchar)+', 767, 320)"" title=""Editar Homologacion"">'+ cast(a.homo_ccod as varchar)+'</a>' as codigo" & vbCrLf &_
			"FROM homologacion a, tipos_homologaciones b " & vbCrLf &_
		    " WHERE cast(a.area_ccod as varchar)='" & area_ccod & "'" & vbCrLf &_
			" and a.thom_ccod*=b.thom_ccod "& vbCrLf &_
			" ORDER BY homo_ccod"
consulta = "SELECT '<a href=""Detalle_homologaciones.asp?homo_ccod=' +  cast(a.homo_ccod as varchar) + '"" title=""Ver homologaciones"" >' + b.thom_tdesc + '</a>' as thom_tdesc, a.area_ccod,a.homo_ccod, " & vbCrLf &_
            " '<a href=""javascript:irA_homo('+cast(a.homo_ccod as varchar)+','+cast(a.area_ccod as varchar)+', 767, 320)"" title=""Editar Homologacion"">'+ cast(a.homo_ccod as varchar)+'</a>' as codigo" & vbCrLf &_
			"FROM homologacion a, tipos_homologaciones b " & vbCrLf &_
		    " WHERE cast(a.area_ccod as varchar)='" & area_ccod & "'" & vbCrLf &_
			" and a.thom_ccod*=b.thom_ccod "& vbCrLf &_
			" ORDER BY homo_ccod"
			
consulta = " Select homo_fresolucion,esho_tdesc,thom_tdesc, " & vbCrLf &_
		   " '<a href=""Detalle_homologaciones_malla.asp?homo_ccod=' +  cast(a.homo_ccod as varchar) + '&homo_nresolucion=" & homo_nresolucion & " "" title=""Ver homologación"">' + cast(homo_nresolucion as varchar) + '</a>' as homo_nresolucion " & vbCrLf &_
		   " from homologacion a, tipos_homologaciones b, estados_homologacion c "	& vbCrLf &_
		   " where a.thom_ccod=b.thom_ccod and a.esho_ccod=c.esho_ccod group by a.homo_nresolucion " & vbCrLf
consulta = " Select min(a.homo_ccod) as homo_ccod,homo_fresolucion,esho_tdesc,thom_tdesc," & vbCrLf &_
		   "  homo_nresolucion,homo_nresolucion as homo_nresolucion_aux,  " & vbCrLf &_
		   "(Select plan_tdesc from planes_estudio where plan_ccod=a.plan_ccod_fuente) as plan_tdesc_fuente, " & vbCrLf &_
           " (Select plan_tdesc from planes_estudio where plan_ccod=a.plan_ccod_destino) as plan_tdesc_destino, " & vbCrLf &_
           " (select carr_tdesc from carreras aa,especialidades b,planes_estudio c " & vbCrLf &_
           " where c.plan_ccod=a.plan_ccod_fuente " & vbCrLf &_
           " and c.espe_ccod=b.espe_ccod " & vbCrLf &_
           " and b.carr_ccod=aa.carr_ccod) as carr_tdesc_fuente, " & vbCrLf &_
           " (select carr_tdesc from carreras aa,especialidades b,planes_estudio c " & vbCrLf &_
           " where c.plan_ccod=a.plan_ccod_destino " & vbCrLf &_
           " and c.espe_ccod=b.espe_ccod " & vbCrLf &_
           " and b.carr_ccod=aa.carr_ccod) as carr_tdesc_destino " & vbCrLf &_
    	   " from homologacion a, tipos_homologaciones b, estados_homologacion c " & vbCrLf &_
		   " where a.thom_ccod=b.thom_ccod and a.esho_ccod=c.esho_ccod " & vbCrLf     
	
if	homo_nresolucion <> ""  then		   
	consulta = consulta & " and cast(a.homo_nresolucion as varchar)='" & homo_nresolucion & "'"
end if		   

if carr_ccod <> "" then
    consulta = consulta & " and  ((select count(*) from planes_estudio pe, especialidades es where pe.plan_ccod=a.plan_ccod_fuente and pe.espe_ccod=es.espe_ccod and es.carr_ccod='"&carr_ccod&"') " & vbCrLf &_
						  "       + " & vbCrLf &_
					      "      (select count(*) from planes_estudio pe, especialidades es where pe.plan_ccod=a.plan_ccod_destino and pe.espe_ccod=es.espe_ccod and es.carr_ccod='"&carr_ccod&"'))<> 0 "
end if
consulta = consulta & " group by homo_nresolucion,homo_fresolucion,esho_tdesc,thom_tdesc,a.plan_ccod_fuente,a.plan_ccod_destino"
'response.Write("<pre>"&consulta&"</pre>")
 f_homologacion.Consultar consulta
		 
'-------------------------------------------------------------

'consulta = "SELECT area_ccod, area_tdesc, facu_ccod  FROM areas_academicas order by area_tdesc "
'conexion.Ejecuta consulta
'set rec_especialidades = conexion.ObtenerRS


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
function ver_detalle_homo(homo_ccod)
{
pagina="Detalle_homologaciones_malla.asp?homo_ccod="+homo_ccod
resultado = open(pagina,'wAgregar','width='+750+'px, height='+500+'px, scrollbars=yes, resizable=yes');
resultado.focus();
}
function irA_homo(homo_ccod)
{
pagina="m_homologaciones_malla_agregar.asp?homo_ccod="+homo_ccod;
resultado = open(pagina,'wAgregar','width='+767+'px, height='+325+'px, scrollbars=yes, resizable=yes');
resultado.focus();
}
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador" method="get">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="27%"><div align="left"><strong>N&ordm; Resoluci&oacute;n</strong></div></td>
                                <td width="2%"><div align="center">:</div></td>
                                <td width="71%"><input type="text" name="homo_nresolucion" maxlength="20" size="20" id="TO-S" value="<%=homo_nresolucion%>"></td>
    						   </tr>
							   <tr> 
									<td width="27%"><div align="left">Carrera</div></td>
									<td width="2%"><div align="center">:</div></td>
									<td width="71%"><%f_busqueda.dibujaCampo ("carr_ccod") %></td>
							   </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">

                    <br>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_homologacion.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <% f_homologacion.DibujaTabla()%>
                          </div></td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% 'if area_ccod <> "" then
							  '    botonera.AgregaBotonParam "nueva" , "deshabilitado", "FALSE"
							   'else
							    ' botonera.AgregaBotonParam "nueva" , "deshabilitado", "TRUE"
							   'end if
							    if usuario <> "7812832" then 
							   botonera.AgregaBotonParam "nueva", "url", "m_homologaciones_malla_Agregar.asp"
							   botonera.DibujaBoton "nueva"
							   end if
							%>
                          </div></td>
                  <td><div align="center">
                            <% if f_homologacion.nroFilas <> 0 then
							      botonera.AgregaBotonParam "eliminar" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar" , "deshabilitado", "TRUE"
							   end if
							   if usuario <> "7812832" then 
							   botonera.AgregaBotonParam "eliminar", "url", "Proc_homologaciones_mallas_eliminar.asp"
							   botonera.DibujaBoton "eliminar"
							   end if%>				  
                          </div></td>
				 <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
				 <td><div align="center">
                            <% botonera.AgregaBotonParam "excel", "url", "listado_homologaciones.asp?homo_nresolucion="&homo_nresolucion&"&carr_ccod="&carr_ccod
							   botonera.DibujaBoton "excel"%>				  
                          </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>