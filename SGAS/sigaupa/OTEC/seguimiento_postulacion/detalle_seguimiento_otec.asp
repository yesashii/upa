<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next
'response.End()
pers_nrut = request.querystring("b[0][pers_nrut]")
pers_xdv = request.querystring("b[0][pers_xdv]")
pers_ncorr= request.QueryString("pers_ncorr")
'response.Write("pers_ncorr "&pers_ncorr)
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Detalle de Postulaciones a Programas OTEC"


set botonera =  new CFormulario
botonera.carga_parametros "seguimiento_otec.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores


usu=negocio.ObtenerUsuario()
'response.Write(carr_ccod)

set botonera =  new CFormulario
botonera.carga_parametros "seguimiento_otec.xml","botonera"


'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "seguimiento_otec.xml", "f_busqueda_persona"
 f_busqueda.Inicializar conexion

 consulta =  "select ''"
 
 f_busqueda.consultar  consulta
 f_busqueda.Siguiente
 f_busqueda.agregaCampoCons "pers_nrut",pers_nrut
 f_busqueda.agregaCampoCons "pers_xdv",pers_xdv
'---------------------------------------------------------------------------------------------------

nombre_alumno = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_alumno = conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
fono_alumno = conexion.consultaUno("select pers_tfono from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
celular_alumno = conexion.consultaUno("select pers_tcelular from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
email_alumno = conexion.consultaUno("select lower(pers_temail) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
direccion_alumno = conexion.consultaUno("select protic.obtener_direccion('"&pers_ncorr&"',1,'CNPB')")
comuna_alumno = conexion.consultaUno("select protic.obtener_direccion('"&pers_ncorr&"',1,'C-C')")
nombre   = conexion.consultauno("SELECT protic.initCap(pers_tnombre) FROM personas WHERE cast(pers_ncorr as varchar) = '"&pers_ncorr&"'")

'response.Write("nombre "&nombre_alumno)
'response.End()


set f_postulaciones = new cformulario
f_postulaciones.carga_parametros "seguimiento_otec.xml","f_detalle"
f_postulaciones.inicializar conexion

if pers_ncorr <> "" then

consulta = " select a.dgso_ncorr,a.pote_ncorr,protic.initcap(sede_tdesc) as sede," & vbCrLf &_
 "protic.initcap(dcur_tdesc) programa,epot_tdesc as estado_postulacion," & vbCrLf &_
"isnull(f.obpo_tobservacion,'') as obpo_tobservacion," & vbCrLf &_
 "isnull(f.eopo_ccod,1) as eopo_ccod, " & vbCrLf &_
 "protic.trunc(fecha_llamado) as fecha_llamado," & vbCrLf &_  
 "protic.trunc(fecha_entrevista) as fecha_entrevista" & vbCrLf &_
 "from postulacion_otec a" & vbCrLf &_
 "join datos_generales_secciones_otec b" & vbCrLf &_
 "on a.dgso_ncorr=b.dgso_ncorr" & vbCrLf &_
 " and a.epot_ccod<>5" & vbCrLf &_
 "join diplomados_cursos c" & vbCrLf &_
 "on b.dcur_ncorr=c.DCUR_NCORR" & vbCrLf &_
 "join sedes d" & vbCrLf &_
 "on b.sede_ccod=d.SEDE_CCOD" & vbCrLf &_
 "join estados_postulacion_otec e" & vbCrLf &_
 "on a.epot_ccod=e.epot_ccod" & vbCrLf &_
 "left outer join observaciones_postulacion_otec f" & vbCrLf &_
 "on a.pote_ncorr=f.pote_ncorr" & vbCrLf &_
 "and a.dgso_ncorr=f.dgso_ncorr" & vbCrLf &_
 "join ofertas_otec g" & vbCrLf &_
 "on b.dgso_ncorr=g.dgso_ncorr" & vbCrLf &_
 "and g.anio_admision=datepart(yyyy,getdate())" & vbCrLf &_
 "join responsable_unidad h" & vbCrLf &_
 "on g.udpo_ccod=h.udpo_ccod" & vbCrLf &_
 " and h.esre_ccod=1" & vbCrLf &_
 "join responsable_programa i" & vbCrLf &_
 "on h.reun_ncorr=i.reun_ncorr" & vbCrLf &_
 "and b.dgso_ncorr=i.dgso_ncorr" & vbCrLf &_
 "where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf &_
 "and h.pers_ncorr=protic.Obtener_pers_ncorr("&usu&")"



'response.Write("<pre>"&consulta&"</pre>")
end if

'response.Write(consulta)
'response.End()
f_postulaciones.Consultar consulta
'cantidad_lista=f_postulaciones.nroFilas


set f_historico = new cformulario
f_historico.carga_parametros "seguimiento_otec.xml","f_historico_postulaciones"
f_historico.inicializar conexion

if pers_ncorr <> "" then

consulta_historico = " select a.dgso_ncorr,a.pote_ncorr,protic.initcap(sede_tdesc) as sede," & vbCrLf &_
 "protic.initcap(dcur_tdesc) programa,epot_tdesc as estado_postulacion," & vbCrLf &_
"isnull(f.obpo_tobservacion,'') as obpo_tobservacion," & vbCrLf &_
 "(select eopo_tdesc from estado_observaciones_postulacion aa where aa.eopo_ccod=f.eopo_ccod) as estado, " & vbCrLf &_
 "protic.trunc(fecha_llamado) as fecha_llamado," & vbCrLf &_  
 "protic.trunc(fecha_entrevista) as fecha_entrevista," & vbCrLf &_
  "protic.trunc(f.audi_fmodificacion) as fecha_modificacion" & vbCrLf &_
 "from postulacion_otec a" & vbCrLf &_
 "join datos_generales_secciones_otec b" & vbCrLf &_
 "on a.dgso_ncorr=b.dgso_ncorr" & vbCrLf &_
 " and a.epot_ccod<>5" & vbCrLf &_
 "join diplomados_cursos c" & vbCrLf &_
 "on b.dcur_ncorr=c.DCUR_NCORR" & vbCrLf &_
 "join sedes d" & vbCrLf &_
 "on b.sede_ccod=d.SEDE_CCOD" & vbCrLf &_
 "join estados_postulacion_otec e" & vbCrLf &_
 "on a.epot_ccod=e.epot_ccod" & vbCrLf &_
 "join observaciones_postulacion_log_otec f" & vbCrLf &_
 "on a.pote_ncorr=f.pote_ncorr" & vbCrLf &_
 "and a.dgso_ncorr=f.dgso_ncorr" & vbCrLf &_
 "join ofertas_otec g" & vbCrLf &_
 "on b.dgso_ncorr=g.dgso_ncorr" & vbCrLf &_
 "and g.anio_admision=datepart(yyyy,getdate())" & vbCrLf &_
 "join responsable_unidad h" & vbCrLf &_
 "on g.udpo_ccod=h.udpo_ccod" & vbCrLf &_
 " and h.esre_ccod=1" & vbCrLf &_
 "join responsable_programa i" & vbCrLf &_
 "on h.reun_ncorr=i.reun_ncorr" & vbCrLf &_
 "and b.dgso_ncorr=i.dgso_ncorr" & vbCrLf &_
 "where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf &_
 "and h.pers_ncorr=protic.Obtener_pers_ncorr("&usu&")" & vbCrLf &_
 "order by f.audi_fmodificacion desc"
'
'response.Write("<pre>"&consulta_historico&"</pre>")
end if
'
f_historico.Consultar consulta_historico

'response.End()
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
function evaluar_indicador(campo)
{
	var indice = extrae_indice(campo.name);
	var valor = campo.value;
	if (valor == "16")
	{
		document.edicion.elements["alumnos["+indice+"][fecha_entrevista]"].id="FE-N";
		document.edicion.elements["alumnos["+indice+"][fecha_entrevista]"].disabled=false;
		//document.edicion.elements["alumnos["+indice+"][htes_ccod]"].id="TO-N";
		//document.edicion.elements["alumnos["+indice+"][htes_ccod]"].disabled=false;
		
	}
	else
	{
		document.edicion.elements["alumnos["+indice+"][fecha_entrevista]"].id="FE-S";
		document.edicion.elements["alumnos["+indice+"][fecha_entrevista]"].value="";
		document.edicion.elements["alumnos["+indice+"][fecha_entrevista]"].disabled=true;
		//document.edicion.elements["alumnos["+indice+"][htes_ccod]"].id="TO-S";
		//document.edicion.elements["alumnos["+indice+"][htes_ccod]"].disabled=true;
	}
	
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="702" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Listado Postulantes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				  <tr>
				  	<td>
						<table width="98%" align="center">
									<tr>
									  <td width="10%"><strong>Nombre</strong></td>
									  <td width="3%"><strong>:</strong></td>
									  <td><%=nombre_alumno%></td>
									</tr>
									<tr>
									  <td width="10%"><strong>Rut</strong></td>
									  <td width="3%"><strong>:</strong></td>
									  <td><%=rut_alumno%></td>
									</tr>
									<tr>
									  <td width="10%"><strong>Fono</strong></td>
									  <td width="3%"><strong>:</strong></td>
									  <td><%=fono_alumno%>  ---> <strong>Celular : </strong><%=celular_alumno%></td>
									</tr>
									<tr>
									  <td width="10%"><strong>E-mail</strong></td>
									  <td width="3%"><strong>:</strong></td>
									  <td><%=email_alumno%></td>
									</tr>
									<tr>
									  <td width="10%"><strong>direcci&oacute;n</strong></td>
									  <td width="3%"><strong>:</strong></td>
									  <td><%=direccion_alumno%></td>
									</tr>
									<tr>
									  <td width="10%"><strong>Ciudad</strong></td>
									  <td width="3%"><strong>:</strong></td>
									  <td><%=comuna_alumno%></td>
									</tr>
									
								</table>
					</td>
				  </tr>
				  <tr>
					  <td><div align="right">&nbsp;</div></td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td colspan="2">
					  			<table width="98%" align="center">
									<tr>
									  <td align="center" colspan="3">&nbsp;</td>
									</tr>
									<form name="edicion">
									<tr>
									  <td align="center" colspan="3">
											<script language='javaScript1.2'> 
													 colores = Array(3);   colores[0] = ''; 
													 colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; 
											</script>
											<table class="v1" width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#999999" bgcolor="#ADADAD" id="tb_alumnos">
												<tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="15%"><font color='#333333'>Sede</font></th>
													<th width="30%"><font color='#333333'>Programa</font></th>
													<th width="23%"><font color='#333333'>Estado</font></th>
													<!--<th width="32%"><font color='#333333'>Matriculado</font></th>-->
												</tr>
												<%f_postulaciones.primero
												  posicion = 0
												  while f_postulaciones.siguiente%>
												 
												<tr bgcolor="#FFFFFF"><%f_postulaciones.dibujaCampo("dgso_ncorr")%>
												  <%f_postulaciones.dibujaCampo("pote_ncorr")%>
																	  <%'debemos ver si el alumno selecciono que viene a entrevista para desbloquear o bloquear los cuadros
																		   eopo_ccod = f_postulaciones.obtenerValor("eopo_ccod")
																		   ofer_ncorr_a = f_postulaciones.obtenerValor("ofer_ncorr")
																		   post_ncorr_a = f_postulaciones.obtenerValor("post_ncorr")
																		   if eopo_ccod = "16" then
																				f_postulaciones.agregaCampoParam "fecha_entrevista","id","FE-N"
																				f_postulaciones.agregaCampoParam "fecha_entrevista","deshabilitado","false"
																				f_postulaciones.agregaCampoParam "htes_ccod","id","TO-N"
																				f_postulaciones.agregaCampoParam "htes_ccod","deshabilitado","false"		
																		   else
																				f_postulaciones.agregaCampoParam "fecha_entrevista","id","FE-S"
																				f_postulaciones.agregaCampoParam "fecha_entrevista","deshabilitado","true"
																				f_postulaciones.agregaCampoParam "htes_ccod","id","TO-S"
																				f_postulaciones.agregaCampoParam "htes_ccod","deshabilitado","true"
																		   end if	
																		%>
												  					
												   <td class='noclick' bgcolor='#C4D7FF'><font color="#990000"><strong><%f_postulaciones.dibujaCampo("sede")%></strong></font></td>
												   <td class='noclick' bgcolor='#C4D7FF'><font color="#990000"><strong><%f_postulaciones.dibujaCampo("programa")%></strong></font></td>
												   <td class='noclick' bgcolor='#C4D7FF'><font color="#990000"><strong><%f_postulaciones.dibujaCampo("estado_postulacion")%></strong></font></td>
												   <!--<td class='noclick' bgcolor='#C4D7FF'><font color="#990000"><strong><%'f_postulaciones.dibujaCampo("matriculado")%></strong></font></td>-->
												   
												</tr>
												<tr>
													<td colspan="5" align="right" bgcolor="#FFFFFF">
														<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF">
															<tr>
																<th align="center"><font color='#333333'><strong>Estado</strong></font></th>
																<th align="center"><font color='#333333'><strong>Observación</strong></font></th>
																<th align="center"><font color='#333333'><strong>llamar el día</strong></font></th>
																<th align="center"><font color='#333333'><strong>Fecha entrevista</strong></font></th>
																<!--<th align="center"><font color='#333333'><strong>Hora</strong></font></th>-->
															</tr>
															<tr>
																<td align="center"><%f_postulaciones.dibujaCampo("eopo_ccod")%></td>
																<td align="center"><%f_postulaciones.dibujaCampo("obpo_tobservacion")%></td>
																<td align="center"><%f_postulaciones.dibujaCampo("fecha_llamado")%></td>
																<td align="center"><%f_postulaciones.dibujaCampo("fecha_entrevista")%></td>
																<!--<td align="center"><%'f_postulaciones.dibujaCampo("htes_ccod")%></td>-->
															</tr>
														</table>
													</td>
												</tr>
												<% posicion = posicion + 1
												   wend%>
											</table>
								</td>
						</tr>
									</form>
						<tr> 
                          <td align="right" colspan="3"><font color="#990000"><strong>CT: Contactado Telefónicamente</strong></font></td>
                        </tr>
						<tr>
						  <td align="center" colspan="3"><hr></td>	
						</tr>
						<tr><td align="left" colspan="3"> <%pagina.DibujarSubtitulo "Seguimiento postulación alumno"%></td></tr>
						<tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%f_historico.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%f_historico.dibujatabla()%> </td>
                        </tr>
                      </table>
					  </td>
				  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <tr>
				  	<td align="right"><%' url_excel = "seguimiento_otec_excel.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&b[0][epot_ccod]="&epot_ccod&"&b[0][f_inicio]="&f_inicio&"&b[0][f_termino]="&f_termino
					                     'botonera.agregaBotonParam "excel","url",url_excel
										 'botonera.dibujaBoton "excel"%></td>
				  </tr>
				   <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="13">
			<table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="35%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url","seguimiento_otec.asp"
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
				  <td> <div align="center">  <%botonera.dibujaboton "guardar"
										%>
					 </div>  
                  </td>
				</tr>
              </table>
			
            </div></td>
            <td width="65%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table>
		</td>
       <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
