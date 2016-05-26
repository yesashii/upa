<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Análisis de resultados encuesta Otec"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	periodo = negocio.obtenerPeriodoAcademico("CLASES18")
end if

'Sede = negocio.ObtenerSede()
'sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "analisis_encuestas_otec.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	=	request.querystring("busqueda[0][sede_ccod]")
 todas	=	request.querystring("busqueda[0][todas]")
 
 'response.Write("carr "&carr_ccod&" jorn "&jorn_ccod&" sede "&sede_ccod&" todas "&todas )
 
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
 f_busqueda.Carga_Parametros "analisis_encuestas_otec.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 'sede = negocio.obtenerSede
 
 anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")

 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas "
 f_busqueda.consultar consulta

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = "select distinct f.sede_ccod,f.sede_tdesc,ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, asignaturas d,jornadas e,sedes f, especialidades es --, bloques_horarios c " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " --and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod and b.sede_ccod=f.sede_ccod " & vbCrLf & _
		   " and b.jorn_ccod=e.jorn_ccod  and a.carr_ccod = es.carr_ccod" & vbCrLf &_
		   " and b.secc_tdesc <>'Poblamiento' and a.carr_ccod in ('193','39','7')" & vbCrLf & _
		   " and es.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   " and cast(b.peri_ccod as varchar)='"&peri&"' order by f.sede_tdesc,a.carr_tdesc asc" 

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "analisis_encuestas_otec.xml", "formu_carga"
f_asignaturas.Inicializar conexion

 if carr_ccod= "" then
    codigo = "  "
	f_asignaturas.consultar "select '' "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if

if (todas = "" or todas="N") then
 	 filtro_asignaturas = ""
else
	filtro_asignaturas = "  and (select case count(distinct pers_ncorr_encuestado) when 0 then 'No' else 'Sí por '+cast(count(distinct pers_ncorr_encuestado) as varchar) + ' Alumno(s)' end  "& vbCrLf &_
		                 "  from encuestas_otec aa where aa.secc_ccod=a.secc_ccod and aa.pers_ncorr_destino=d.pers_ncorr) <> 'No' "
end if	
   
 consulta = "  Select distinct e.asig_ccod,e.asig_tdesc, a.secc_ccod,d.pers_ncorr,a.secc_tdesc, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as docente,"& vbCrLf &_
			"  (select count(*) from cargas_Academicas aa where a.secc_ccod = aa.secc_ccod) as cantidad_alumnos, "& vbCrLf &_
			"  (select case count(distinct pers_ncorr_encuestado) when 0 then 'No' else 'Sí por '+cast(count(distinct pers_ncorr_encuestado) as varchar) + ' Alumno(s)' end  "& vbCrLf &_
		    "  from encuestas_otec aa where aa.secc_ccod=a.secc_ccod and aa.pers_ncorr_destino=d.pers_ncorr) as evaluado  "& vbCrLf &_
 			"  from secciones a, bloques_horarios b, bloques_profesores c, personas d, asignaturas e,periodos_Academicos f "& vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod "& vbCrLf &_
			"  and b.bloq_ccod = c.bloq_ccod "& vbCrLf &_
		    " and c.pers_ncorr = d.pers_ncorr and c.tpro_ccod = 1 "& vbCrLf &_
			" and a.asig_ccod = e.asig_ccod "& vbCrLf &_
			" and a.peri_ccod = f.peri_ccod "& vbCrLf &_
			" and (select count(*) from cargas_Academicas aa where a.secc_ccod = aa.secc_ccod) <> 0 "& vbCrLf &_
			" and cast(f.anos_ccod as varchar)='"&anos_ccod&"' "& filtro_asignaturas& vbCrLf &_
			" and cast(a.sede_ccod as varchar)='"&sede_ccod&"' and cast(a.carr_ccod as varchar)='"&carr_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' "


			
'response.Write("<pre>"&consulta&"</pre>")			   
'response.End()
  if Request.QueryString <> "" then
     f_asignaturas.consultar consulta & " ORDER BY e.asig_tdesc, a.secc_tdesc " 
  else
	f_asignaturas.consultar "select * from secciones where 1=2 "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

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
			formulario.action ="analisis_encuestas_otec.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
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
                                <td width="13%"> <div align="left">Sede</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="54%"><% f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar"%></div> </td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Carrera</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Jornada</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Sólo encuestadas</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><%f_busqueda.dibujaCampo("todas")%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
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
                        <td width="9%">Sede</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Carrera</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Jornada</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=jorn_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=periodo_tdesc%> (Seleccionado de la actividad Toma de Carga)</td>
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
            <td width="12%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td><div align="center"><% ' botonera.agregaBotonParam "excel","url","encuestas_carrera_excel.asp?carr_ccod="&carr_ccod&"&sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod
						                           ' botonera.dibujaBoton "excel"%></div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="88%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
