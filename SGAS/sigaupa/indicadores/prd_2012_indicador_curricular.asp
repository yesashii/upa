<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Indicador Curricular"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "indicadores_alumnos.xml", "botonera_curricular"
'-------------------------------------------------------------------------------
 carr_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 'response.Write("carr_ccod "&carr_ccod)
 asig_ccod	=	request.querystring("busqueda[0][asig_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	=	request.querystring("busqueda[0][sede_ccod]")
 anos_ccod	=	request.querystring("busqueda[0][anos_ccod]")
 todas	=	request.querystring("busqueda[0][todas]")
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 if (todas = "" or todas="N") and (sin_alumnos="" or sin_alumnos="N") and (sin_cerrar="" or sin_cerrar="N") then
 	asig_tdesc = conexion.consultaUno("select asig_ccod + ' --> '+ asig_tdesc from asignaturas where cast(asig_ccod as varchar) ='"&asig_ccod&"'")
 else
    asig_tdesc = "<< Todas las Asignaturas >>"
 end if	
 codigo = asig_ccod

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "indicadores_alumnos.xml", "busqueda_curricular"
 f_busqueda.Inicializar conexion
 peri = periodo'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 'sede = negocio.obtenerSede
 
 consulta="Select '"&anos_ccod&"' as anos_ccod,'"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas,'"&sin_alumnos&"' as sin_alumnos,'"&sin_cerrar&"' as sin_cerrar "
 f_busqueda.consultar consulta

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = "select distinct pea.anos_ccod,f.sede_ccod,f.sede_tdesc,ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc,ltrim(rtrim(d.asig_ccod))as asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc " & vbCrLf &_
			" from carreras a,secciones b, asignaturas d,jornadas e,sedes f, especialidades es,periodos_academicos pea " & vbCrLf &_
			" where a.carr_ccod=b.carr_ccod  " & vbCrLf &_
			" and b.asig_ccod=d.asig_ccod and b.sede_ccod=f.sede_ccod  " & vbCrLf &_
			" and b.jorn_ccod=e.jorn_ccod  and a.carr_ccod = es.carr_ccod " & vbCrLf &_
			" and b.peri_ccod=pea.peri_ccod " & vbCrLf &_
			" and pea.anos_ccod >= 2005 " & vbCrLf &_
			" and b.secc_tdesc <>'Poblamiento' " & vbCrLf &_
			" and a.tcar_ccod=1" & vbCrLf &_
			" and exists( select 1 from cargas_academicas aca where aca.secc_ccod=b.secc_ccod)" & vbCrLf &_
			" and es.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
			" order by pea.anos_ccod,f.sede_tdesc,a.carr_tdesc,d.asig_tdesc,d.asig_ccod asc" 

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "nombre_asig", nombre
 'f_busqueda.AgregaCampoCons "codigo_asig", codigo

'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "indicadores_alumnos.xml", "f_asignaturas"
f_asignaturas.Inicializar conexion


 if asig_ccod = "" and carr_ccod= "" then
    codigo = "  "
	f_asignaturas.consultar "select '' "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if
 
 if (todas = "" or todas="N") and (sin_alumnos="" or sin_alumnos="N") and (sin_cerrar="" or sin_cerrar="N") then
 	filtro_asignaturas = "and (cast(a.asig_ccod as varchar) = '"&asig_ccod&"' or '"&asig_ccod&"' is null )"
 else
	filtro_asignaturas = ""
 end if	
   
 consulta = " select peri_ccod, peri_tdesc,asig_ccod + ' ' + asig_tdesc as asignatura, secc_tdesc,nive_ccod,estado,cant_alumnos, "& vbCrLf	&_
			" aprobados, cast((aprobados * 100.00) / cant_alumnos as decimal(5,2)) as porc_aprobados, "& vbCrLf	&_
			" reprobados, cast((reprobados * 100.00) / cant_alumnos as decimal(5,2)) as porc_reprobados, "& vbCrLf	&_
			" faltantes, cast((faltantes * 100.00) / cant_alumnos as decimal(5,2)) as porc_faltantes, "& vbCrLf	&_
			" cast(promedio as decimal (2,1)) as promedio, "& vbCrLf	&_
			" menor_a_4, mayor_o_igual_a_4 "& vbCrLf	&_
			" from "& vbCrLf	&_
			" ( "& vbCrLf	&_
			" SELECT distinct d.peri_ccod,d.peri_tdesc,a.ASIG_CCOD, a.ASIG_TDESC ,secc_tdesc ,b.secc_ccod,e.nive_ccod, "& vbCrLf	&_
			" case isnull(b.estado_cierre_ccod,1) when 1 then 'Sin Cerrar' else 'Cerrada' end as estado,  "& vbCrLf	&_
			" (select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb  "& vbCrLf	&_
			"  where aa.matr_ncorr=bb.matr_ncorr  "& vbCrLf	&_
			" and aa.secc_ccod = b.secc_ccod  "& vbCrLf	&_
			" and aa.carg_nsence is  null  "& vbCrLf	&_
			" and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod)  "& vbCrLf	&_
			" and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_alumnos, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa, situaciones_finales bb  "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and aa.sitf_ccod=bb.sitf_ccod and sitf_baprueba='S') as aprobados, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa, situaciones_finales bb  "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and aa.sitf_ccod=bb.sitf_ccod and sitf_baprueba='N') as reprobados, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and isnull(sitf_ccod,'N')='N') as faltantes, "& vbCrLf	&_
			" (select avg(carg_nnota_final) from cargas_academicas aa "& vbCrLf	&_
            "			                where aa.secc_ccod=b.secc_ccod and isnull(carg_nnota_final,0.0) <> 0.0) as promedio, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and carg_nnota_final < 4.0 and isnull(carg_nnota_final,0.0)<>0.0) as menor_a_4, "& vbCrLf	&_
			" (select count(matr_ncorr) from cargas_academicas aa "& vbCrLf	&_
			"                           where aa.secc_ccod=b.secc_ccod and carg_nnota_final >= 4.0 and isnull(carg_nnota_final,0.0)<>0.0) as mayor_o_igual_a_4 "& vbCrLf	&_
			" FROM asignaturas a, secciones b, bloques_horarios c, periodos_academicos d, malla_curricular e "& vbCrLf	&_
			" WHERE a.asig_ccod=b.asig_ccod and b.secc_ccod  = c.secc_ccod "& vbCrLf	&_
			" and b.asig_ccod=e.asig_ccod and b.mall_ccod = e.mall_ccod "& vbCrLf	&_
			" and b.peri_ccod = d.peri_ccod and cast(d.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf	&_
			" and cast(b.sede_ccod as varchar) = '"&sede_ccod&"' "& vbCrLf	&_
			" and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' "&filtro_asignaturas& vbCrLf	&_
			" and cast(b.carr_ccod as varchar)='"&carr_ccod&"' "& vbCrLf	&_
			" )tabla_a "& vbCrLf	&_
			" where cant_alumnos > 0 "

	
'response.Write("<pre>"&consulta&"  order by peri_ccod, asignatura, secc_tdesc</pre>")			   
'response.End()
  if Request.QueryString <> "" then
     f_asignaturas.consultar consulta & " order by peri_ccod, asignatura, secc_tdesc" 
  else
	f_asignaturas.consultar "select * from secciones where 1=2 "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

url = "indicador_curricular_excel.asp?carr_ccod="&carr_ccod&"&asig_ccod="&asig_ccod&"&jorn_ccod="&jorn_ccod&"&sede_ccod="&sede_ccod&"&anos_ccod="&anos_ccod&"&todas="&todas
'response.Write(url)

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
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="indicador_curricular.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
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
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="21%"> <div align="left">Años Disponibles</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "anos_ccod"%></td>
							  </tr>
							  <tr> 
                                <td width="21%"> <div align="left">Sede</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="46%"><% f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar"%></div> </td>
                              </tr>
							  <tr> 
                                <td width="21%"> <div align="left">Carrera</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="21%"> <div align="left">Jornada</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="21%"> <div align="left">Asignatura</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="21%"> <div align="left">Todas las asignaturas</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><%f_busqueda.dibujaCampo("todas")%></td>
                              </tr>
							  <tr> 
                                <td width="21%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="2"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <%if Request.QueryString <> "" then%>
					  <tr> 
                        <td width="9%"><strong>Sede</strong></td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%"><strong>Carrera</strong></td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%"><strong>Jornada</strong></td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=jorn_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%"><strong>Asignatura</strong></td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=asig_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%"><strong>Año</strong></td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=anos_ccod%></td>
                      </tr>
					  <%end if%>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                        <td><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_asignaturas.AccesoPagina%>
                          </div></td>
                  </tr>
				  <tr>
                    <td>
                      <br>
					  <%f_asignaturas.dibujaTabla()%>
					  </td>
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
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td width="49%"> <div align="left">  
				                                       <%'response.Write("indicador_curricular_excel.asp?carr_ccod="&carr_ccod&"&asig_ccod="&asig_ccod&"&jorn_ccod="&jorn_ccod&"&sede_ccod="&sede_ccod&"&anos_ccod="&anos_ccod&"&todas="&todas)
													     botonera.agregaBotonParam "excel","url",url
													     botonera.dibujaboton "excel"%>
						 </div>
					  </td>
						</tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
