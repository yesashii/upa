<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio_admision.asp" -->

<%
Server.ScriptTimeOut = 150000
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Renovante Historicos por Estado"

pers_nrut=request.QueryString("busqueda[0][pers_nrut]")
pers_xdv=request.QueryString("busqueda[0][pers_xdv]")
esre_ccod=request.QueryString("busqueda[0][esre_ccod]")
esre_timportancia=request.QueryString("busqueda[0][esre_timportancia]")
'response.Write("pers_nrut="&pers_nrut&"<br>")
'response.Write("esre_timportancia= "&esre_timportancia)
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "renovantes_historicos_estado.xml", "botonera"
'response.End()
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "renovantes_historicos_estado.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv"

 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "esre_ccod",esre_ccod


'response.Write("pers_nrut="&pers_nrut&"<br>")
 if pers_nrut<>""  then
filtro=filtro&"and a.rut="&pers_nrut&""
end if

 if esre_ccod<>""  then
filtro=filtro&"and a.estado_renovante="&esre_ccod&""
end if

 if esre_timportancia<>""  then
filtro=filtro&"and b.esre_timportancia='"&esre_timportancia&"'"
end if


 set f_listado = new CFormulario
 f_listado.Carga_Parametros "renovantes_historicos_estado.xml", "f_listado"
 f_listado.Inicializar conexion
 
 if pers_nrut<>"" or esre_ccod <>"" or esre_timportancia<>"" then
 select_reno="select cast(rut as varchar)+'-'+dv as rut,nombres+' '+paterno+' '+materno as nombre,b.esre_ccod ,"& vbCrLf &_
"b.esre_tdesc,esre_timportancia,case when b.esre_timportancia='BAJA' then '<img src="&CHR(034)&"imagenes/sem_verde.png"&CHR(034)&" width="&CHR(034)&"25"&CHR(034)&" height="&CHR(034)&"25"&CHR(034)&"/>' when b.esre_timportancia='MEDIA' then '<img src="&CHR(034)&"imagenes/sem_amarillo.png"&CHR(034)&" width="&CHR(034)&"25"&CHR(034)&" height="&CHR(034)&"25"&CHR(034)&"/>'"& vbCrLf &_
 "when b.esre_timportancia='ALTA' then '<img src="&CHR(034)&"imagenes/sem_rojo.png"&CHR(034)&" width="&CHR(034)&"25"&CHR(034)&" height="&CHR(034)&"25"&CHR(034)&"/>' end as importancia,esre_tprocedimiento "& vbCrLf &_
"from ufe_renovantes_historicos a,UFE_estados_renovantes b"& vbCrLf &_
"where a.estado_renovante=b.esre_ccod "& vbCrLf &_
""&filtro&""

	
else
select_reno="select ''"
end if
'response.Write(select_reno)

 f_listado.Consultar select_reno

' f_listado.Siguiente

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../../biblioteca/validadores.js"></script>

<script language="JavaScript">

function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="renovantes_historicos_estado_admision.asp";
			formulario.submit();
}


function seleciona_importancia()
{
	document.buscador.elements["busqueda[0][esre_timportancia]"].value='<%=esre_timportancia%>';
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../../imagenes/botones/buscar_f2.gif','../../images/bot_deshabilitar_f2.gif','../../images/agregar2_f2_p.gif','../im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../../imagenes/botones/cargar_f2.gif','../../imagenes/botones/continuar_f2.gif'),seleciona_importancia();" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado2()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
          <!--  -->
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
							  <tr> 
                                <td width="25%"><div align="left">Rut de alumno</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="72%"><%f_busqueda.dibujaCampo("pers_nrut")%>
												- 
												<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                              </tr>
							   <tr> 
                                <td width="25%"><div align="left">Estados</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="72%"><%f_busqueda.dibujaCampo("esre_ccod")%></td>
                              </tr>
							  <tr> 
                                <td width="25%"><div align="left">Importancia</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="72%"><select name="busqueda[0][esre_timportancia]"  id="TO-S">
													<option value="">Seleccione</option>
													<option value="ALTA">ALTA</option>
													<option value="MEDIA">MEDIA</option>
													<option value="BAJA">BAJA</option>
												</select>
                                                
                                         </td>
                                                
                              </tr>
							  <tr> 
                                <td colspan="3" align="left"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere
                                       un momento mientras se realiza la
                                      busqueda...</font></div></td>
                              </tr>
                            </table>
                          </div></td>
                </tr>
				<tr>
					<td width="19%" align="right"><div align="right"><%botonera.DibujaBoton "buscar"%></div></td>
				</tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
         <tr>
		  	<td align="center"><%pagina.DibujarTituloPagina%></td>
		  </tr>
		  <tr>
		  	<td>&nbsp;</td>
		  </tr>
		  <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
		  
          <tr>
            <td height="2" background="../../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
			  <div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_listado.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
                    <td><%=f_listado.Dibujatabla()%></td>
				  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../../imagene s/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><% 'botonera.AgregaBotonParam "excel", "url", "renovantes_historicos_estado_excel_admision.asp"
							'   botonera.AgregaBotonParam "excel","texto","Reporte Excel"
							   'botonera.DibujaBoton "excel"
					%></td>
                  <td><div align="center"><%botonera.AgregaBotonParam "lanzadera","url","../../lanzadera/lanzadera.asp"
				  botonera.DibujaBoton "lanzadera"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="82%" rowspan="2" background="../../imagenes/abajo_r1_c4.gif"><img src="../../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
