<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: GESTION ESCUELA 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:22/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			: ORDER BY
'LINEA			:82
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Control de mensajería docente y alumnos"
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
botonera.Carga_Parametros "mensajeria_interna.xml", "botonera_mensajes"
'-------------------------------------------------------------------------------
 carr_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 'response.Write("carr_ccod "&carr_ccod)
 asig_ccod	=	request.querystring("busqueda[0][asig_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	=	request.querystring("busqueda[0][sede_ccod]")
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 if (todas = "" or todas="N") and (sin_alumnos="" or sin_alumnos="N") and (sin_cerrar="" or sin_cerrar="N") then
 	asig_tdesc = conexion.consultaUno("select 'S'+substring(b.secc_tdesc,1,1)+' :'+a.asig_ccod + ' --> '+ asig_tdesc from asignaturas a, secciones b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar) ='"&asig_ccod&"'")
 else
    asig_tdesc = "<< Todas las Asignaturas >>"
 end if	
 codigo = asig_ccod

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listado_evaluaciones.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 'sede = negocio.obtenerSede
 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas,'"&sin_alumnos&"' as sin_alumnos,'"&sin_cerrar&"' as sin_cerrar "
 f_busqueda.consultar consulta

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


' consulta = "select distinct f.sede_ccod,f.sede_tdesc,ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc, b.secc_ccod as asig_ccod,'S'+substring(b.secc_tdesc,1,1)+' :'+' - '+ d.asig_tdesc + ' - '+cast(d.asig_ccod as varchar) as asig_tdesc " & vbCrLf & _
'		   " from carreras a,secciones b, asignaturas d,jornadas e,sedes f, especialidades es " & vbCrLf & _
'		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
'		   " and b.asig_ccod=d.asig_ccod and b.sede_ccod=f.sede_ccod " & vbCrLf & _
'		   " and b.jorn_ccod=e.jorn_ccod  and a.carr_ccod = es.carr_ccod" & vbCrLf &_
'		   " and b.secc_tdesc <>'Poblamiento' " & vbCrLf & _
'		   " and es.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
'		   " and cast(b.peri_ccod as varchar)='"&peri&"' order by f.sede_tdesc,a.carr_tdesc,d.asig_tdesc,d.asig_ccod asc" 

 consulta = "select distinct f.sede_ccod,f.sede_tdesc,ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc, b.secc_ccod as asig_ccod,'S'+substring(b.secc_tdesc,1,1)+' :'+' - '+ d.asig_tdesc + ' - '+cast(d.asig_ccod as varchar) as asig_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, asignaturas d,jornadas e,sedes f, especialidades es " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod and b.sede_ccod=f.sede_ccod " & vbCrLf & _
		   " and b.jorn_ccod=e.jorn_ccod  and a.carr_ccod = es.carr_ccod" & vbCrLf &_
		   " and b.secc_tdesc <>'Poblamiento' " & vbCrLf & _
		   " and es.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   " and cast(b.peri_ccod as varchar)='"&peri&"' order by f.sede_tdesc,a.carr_tdesc, asig_tdesc, asig_ccod asc" 

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente

if carr_ccod <> "" and asig_ccod <> "" then 
	set f_mensajes = new CFormulario
	f_mensajes.Carga_Parametros "mensajeria_interna.xml", "mensajes"
	f_mensajes.Inicializar conexion
	
	 c_mensajes = " select mepe_ncorr, protic.trunc(fecha_emision) as fecha, " & vbCrLf &_
				  "	pers_tnombre + ' ' + pers_tape_paterno as de, " & vbCrLf &_
				  "	titulo, case when a.pers_ncorr_origen=a.pers_ncorr_destino then 'Copia envio' else 'Alumno' end as origen, " & vbCrLf &_
				  "	fecha_emision, b.pers_ncorr,tipo_origen, " & vbCrLf &_
				  " case isnull(estado,'Sin leer') when 'Sin leer' then '<img src=""../imagenes/sin_leer.jpg"" width=""17"" height=""15"" border=""0"" alt=""Sin Leer"">' " & vbCrLf &_
				  " else '<img src=""../imagenes/leidos.jpg"" width=""17"" height=""15"" border=""0"" alt=""Leídos"">' end as foto " & vbCrLf &_
				  "	from mensajes_entre_personas a, personas b " & vbCrLf &_
				  "	where a.pers_ncorr_origen = b.pers_ncorr " & vbCrLf &_
				  "	and convert(datetime,protic.trunc(fecha_vencimiento),103) >= convert(datetime,protic.trunc(getDate()),103) " & vbCrLf &_
				  "	and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_encargado&"' and isnull(estado,'Activo') <> 'Eliminado' " & vbCrLf &_
				  "	order by fecha_emision desc"
	 f_mensajes.Consultar c_mensajes
	 'response.Write("<pre>"&c_mensajes&"</pre>")
 
	set f_alumnos = new CFormulario
	f_alumnos.Carga_Parametros "mensajeria_interna.xml", "listado_alumnos"
	f_alumnos.Inicializar conexion
	
	c_alumnos =" select e.carr_ccod,c.pers_ncorr, cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut,  " & vbCrLf &_
			   " c.pers_tape_paterno + ' ' + pers_tape_materno + ', '+pers_tnombre as alumno,  " & vbCrLf &_
			   " d.emat_tdesc as estado  " & vbCrLf &_
			   " from cargas_academicas a (nolock), alumnos b (nolock), personas c (nolock), estados_matriculas d, secciones e  " & vbCrLf &_
			   " where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr and b.emat_ccod=d.emat_ccod and a.secc_ccod=e.secc_ccod  " & vbCrLf &_
			   " and cast(a.secc_ccod as varchar)='"&asig_ccod&"'  " & vbCrLf &_
			   " order by alumno asc "
	
	f_alumnos.Consultar c_alumnos

	set f_docentes = new CFormulario
	f_docentes.Carga_Parametros "mensajeria_interna.xml", "listado_docentes"
	f_docentes.Inicializar conexion
	
	c_docentes = " select distinct d.carr_ccod,c.pers_ncorr, cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, " & vbCrLf &_
				 " c.pers_tape_paterno + ' ' + pers_tape_materno + ', '+pers_tnombre as docente, " & vbCrLf &_
				 " case b.tpro_ccod when 1 then 'Profesor' else 'Ayudante' end as tipo " & vbCrLf &_
				 " from bloques_horarios a, bloques_profesores b, personas c (nolock), secciones d " & vbCrLf &_
				 " where a.bloq_ccod=b.bloq_ccod and b.pers_ncorr=c.pers_ncorr  and a.secc_ccod=d.secc_ccod " & vbCrLf &_
				 " and cast(a.secc_ccod as varchar)='"&asig_ccod&"' " & vbCrLf &_
				 " order by docente asc"
	
	f_docentes.Consultar c_docentes
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
			formulario.action ="mensajeria_interna.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
function enviar_a_todos() 
{
	var seccion = '<%=asig_ccod%>';
	var carrera = '<%=carr_ccod%>';
	if (seccion != '')
	{
		direccion = "editar_mensaje_interno.asp?pers_ncorr=&tipo=2&carr_ccod="+carrera+"&secc_ccod="+seccion;
		resultado=window.open(direccion, "ventana1","width=600,height=440,scrollbars=yes");
	}	
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
                                <td width="13%"> <div align="left">Período</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="54%"><strong><%=periodo_tdesc%> (TOMA DE CARGA)</strong></td>
								<td width="31%">&nbsp;</td>
                              </tr>
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
                                <td width="13%"> <div align="left">Asignatura</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
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
	<%if carr_ccod <> "" and asig_ccod <> "" then%>
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
                        <td width="9%">Asignatura</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=asig_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=periodo_tdesc%> (Seleccionado de la actividad Toma de Carga)</td>
                      </tr>
					  <tr>
					  	<td colspan="3">&nbsp;</td>
					  </tr>
  					  <tr>
						<td colspan="3"><%pagina.DibujarSubtitulo "Mensajes"%>
                        <div align="right">P&aacute;ginas :<%f_mensajes.accesopagina%> </div></td>
					  </tr>
					  <tr>
						<td colspan="3"><div align="center"></div></td>
					  </tr>
					  <tr>
						<td colspan="3">
						    <div align="center">
							<%f_mensajes.dibujatabla()%>
						    </div>
						</td>
					  </tr>
					  <tr>
					  	<td colspan="3">&nbsp;</td>
					  </tr>
  					  <tr>
						<td colspan="3"><%pagina.DibujarSubtitulo "Alumnos"%>
                                        <div align="right">P&aacute;ginas :<%f_alumnos.accesopagina%> </div></td>
					  </tr>
					  <tr>
						<td colspan="3"><div align="center"></div></td>
					  </tr>
					  <tr>
						<td colspan="3">
						    <div align="center">
							<%f_alumnos.dibujatabla()%>
						    </div>
						</td>
					  </tr>
					  <tr>
						<td colspan="3" align="right"><font color="#990000">Haga Clic sobre el alumno al que desea enviar el mensaje</font></td>
					  </tr>
					  <tr>
					  	<td colspan="3">&nbsp;</td>
					  </tr>
  					  <tr>
						<td colspan="3"><%pagina.DibujarSubtitulo "Docentes"%>
                        <div align="right">P&aacute;ginas :<%f_docentes.accesopagina%> </div></td>
					  </tr>
					  <tr>
						<td colspan="3"><div align="center"></div></td>
					  </tr>
					  <tr>
						<td colspan="3">
						    <div align="center">
							<%f_docentes.dibujatabla()%>
						    </div>
						</td>
					  </tr>
					  <tr>
						<td colspan="3" align="right"><font color="#990000">Haga Clic sobre el docente al que desea enviar el mensaje</font></td>
					  </tr>
					  <%end if%>
                    </table>
                  </div>
              </td></tr>
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
						<td><div align="center"><%if f_alumnos.nroFilas <= 0  and f_docentes.nroFilas <=0 then
						                           	   botonera.agregaBotonParam "mensaje_todos","deshabilitado","true"
												  end if    
												  botonera.dibujaBoton "mensaje_todos"%></div></td>
						<td><div align="center"><%if carr_ccod <> "" then
						                           	   botonera.agregaBotonParam "excel_profesores", "url", "../reg_def_evaluaciones/listado_correos_docentes.asp?carr_ccod="&carr_ccod&"&sede_ccod="&sede_ccod&"&jorn_ccod="&jorn_ccod
												       botonera.dibujaBoton "excel_profesores" 
												  end if %></div></td>
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
	<%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
