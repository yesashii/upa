<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Análisis resultados encuesta de Desarrollo."
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario
'response.Write(usuario)

c_autorizado = " select case count(*) when 0 then 'N' else 'S' end from personas a, sis_roles_usuarios b "&_
			   " where cast(a.pers_nrut as varchar)='"&usuario&"' and a.pers_ncorr=b.pers_ncorr "&_
               " and b.srol_ncorr='107'"

autorizado = conexion.consultaUno(c_autorizado)			   

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "analisis_encuesta_caracteristicas.xml", "botonera"

facu_ccod = request.querystring("busqueda[0][facu_ccod]")
'-----------------------------------------------------------------------
if facu_ccod="" then
	carr_ccod = request.querystring("busqueda[0][carr_ccod]")
	carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
end if
facultad = conexion.consultauno("SELECT facu_tdesc FROM facultades WHERE facu_ccod = '" & facu_ccod & "'")

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "analisis_encuesta_caracteristicas.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 
 c_carrera = "(select distinct b.carr_ccod,b.carr_tdesc "& vbCrLf &_
             " from respuestas_encuesta_desarrollo a, carreras b "& vbCrLf &_
			 " where a.carr_ccod= b.carr_ccod "& vbCrLf
 if autorizado = "N" then 			 
 c_carrera = c_carrera & "  and b.carr_ccod in  (select distinct carr_ccod  "& vbCrLf &_
						 "                       from personas aa, sis_especialidades_usuario ab, especialidades ac "& vbCrLf &_
						 "						where cast(aa.pers_nrut as varchar)='"&usuario&"' "& vbCrLf &_
						 "						and aa.pers_ncorr=ab.pers_ncorr and ab.espe_ccod=ac.espe_ccod) "& vbCrLf 
 end if
c_carrera = c_carrera &	 " )aa"
 
 f_busqueda.AgregaCampoParam "carr_ccod","destino",c_carrera
 
 if facu_ccod = "" then 
 	f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod
 end if
 f_busqueda.AgregaCampoCons "facu_ccod", facu_ccod
 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "analisis_encuesta_caracteristicas.xml", "f_lista"
f_lista.Inicializar conexion
 consulta = " select distinct cast(pers_nrut as varchar)+'-'+pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre, "& vbCrLf &_
			" c.carr_tdesc as carrera, cast((suma_positivos - (suma_negativos * -1 )) / suma_positivos as decimal(3,2))as puntaje "& vbCrLf &_
			" from respuestas_encuesta_desarrollo a, personas b,carreras c "& vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr       "& vbCrLf &_
			" and a.carr_ccod=c.carr_ccod "
			
			if carr_ccod <> "" and facu_ccod= "" then 
				consulta = consulta & " and c.carr_ccod='"&carr_ccod&"'"
			end if
			
			if facu_ccod <> "" then 
				consulta = consulta & "  and exists (select 1 from areas_academicas aa where aa.area_ccod=c.area_ccod and cast(aa.facu_ccod as varchar)='"&facu_ccod&"')"
			end if
			
			if autorizado = "N" then 
			consulta = consulta &  "  and c.carr_ccod in ( select distinct carr_ccod  "& vbCrLf &_
								   "                       from personas aa, sis_especialidades_usuario ab, especialidades ac "& vbCrLf &_
 			                       "  					   where cast(aa.pers_nrut as varchar)='"&usuario&"' "& vbCrLf &_
 			                       "					   and aa.pers_ncorr=ab.pers_ncorr and ab.espe_ccod=ac.espe_ccod) "
			end if					   
'response.write("<pre>"&consulta&" order by nombre, carrera</pre>")
f_lista.Consultar consulta & " order by nombre, carrera"

'---------------------------------------------------------------------------------------------------

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
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                             <%if autorizado="S" then%>
							  <tr> 
                                <td width="20%"><div align="left">Facultad</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="75%"><% f_busqueda.dibujaCampo ("facu_ccod") %></td>
                              </tr>
							  <tr> 
                                <td colspan="3"><hr></td>
                              </tr>
							  <%end if%>
							  <tr> 
                                <td width="20%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="75%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
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
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
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
                                    <%f_lista.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%f_lista.DibujaTabla()%>
                          </div></td>
                  </tr>
                </table>
                          <br>
            </form>
		</td></tr>
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
                            <% botonera.AgregaBotonParam "excel", "url", "analisis_encuesta_caracteristicas_excel.asp?carr_ccod=" & carr_ccod &"&facu_ccod="&facu_ccod
							   botonera.DibujaBoton "excel"
							%>
                          </div></td>
                  <td><div align="center"> <% botonera.AgregaBotonParam "excel22", "url", "analisis_cualitativo_encuesta_caracteristicas_excel.asp?carr_ccod=" & carr_ccod &"&facu_ccod="&facu_ccod
							  				 botonera.DibujaBoton "excel22"
											%></div>
				  </td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
