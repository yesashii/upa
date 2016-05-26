<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:08/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *=
'LINEA			:75 - 121
'********************************************************************
q_pers_nrut = request.QueryString("q_pers_nrut")
post_ncorr = request.QueryString("post_ncorr")
ofer_ncorr = request.QueryString("ofer_ncorr")

viene = request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Examen Postulante "
set botonera =  new CFormulario
botonera.carga_parametros "busca_examen_postulante.xml", "btn_actualiza_examen"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'debemos generar el cargo apra ver si esta pagado lo de enefermería
pers_ncorr = conectar.consultaUno("select pers_ncorr from postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"'")
pagado = true

periodo = conectar.consultaUno("select peri_ccod from postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"'")

'consulta = "select a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut, " & vbCrLf &_
'			"       protic.initCap(a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno) as nombre_completo, " & vbCrLf &_
'			"       e.carr_tdesc + '-' + d.espe_tdesc as carrera,f.ofer_ncorr,d.espe_ccod,e.carr_ccod,a.pers_tfono + ' - cel: ' + a.pers_tcelular as fono, lower(a.pers_temail)as email, " & vbCrLf &_
'			"       f.eepo_ccod,f.post_ncorr,h.area_tdesc as escuela,f.dpos_tobservacion, f.dpos_ncalificacion " & vbCrLf &_
'			"from personas_postulante a, postulantes b,ofertas_academicas c,especialidades d,carreras e," & vbCrLf &_
'			"     detalle_postulantes f, estado_examen_postulantes g,areas_academicas h" & vbCrLf &_
'			"where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
'			"  and f.post_ncorr = b.post_ncorr" & vbCrLf &_
'			"  and f.eepo_ccod *= g.eepo_ccod" & vbCrLf &_
'			"  and f.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
'			"  and c.espe_ccod = d.espe_ccod" & vbCrLf &_
'			"  and d.carr_ccod = e.carr_ccod" & vbCrLf &_
'			"  and e.area_ccod = h.area_ccod " & vbCrLf &_
'			"  and cast(b.peri_ccod as varchar) = '"&periodo&"'" & vbCrLf &_
'			"  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'" & vbCrLf &_
'			"  and f.post_ncorr = " & post_ncorr & "" & vbCrLf &_
'			"  and f.ofer_ncorr = " & ofer_ncorr & "" & vbCrLf &_						
'			"  and not exists (select 1 " & vbCrLf &_
'			"                  from alumnos a2 " & vbCrLf &_
'			"				  where a2.post_ncorr = b.post_ncorr " & vbCrLf &_
'			"				    and a2.emat_ccod = 1)"

consulta = "select a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut, " & vbCrLf &_
			"       protic.initCap(a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno) as nombre_completo, " & vbCrLf &_
			"       e.carr_tdesc + '-' + d.espe_tdesc as carrera,f.ofer_ncorr,d.espe_ccod,e.carr_ccod,a.pers_tfono + ' - cel: ' + a.pers_tcelular as fono, lower(a.pers_temail)as email, " & vbCrLf &_
			"       f.eepo_ccod,f.post_ncorr,h.area_tdesc as escuela,f.dpos_tobservacion, f.dpos_ncalificacion " & vbCrLf &_
			"from personas_postulante a INNER JOIN postulantes b " & vbCrLf &_
			"  ON a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
			"  INNER JOIN detalle_postulantes f " & vbCrLf &_
			"  ON f.post_ncorr = b.post_ncorr " & vbCrLf &_
			"  LEFT OUTER JOIN estado_examen_postulantes g " & vbCrLf &_
			"  ON f.eepo_ccod = g.eepo_ccod " & vbCrLf &_
			"  INNER JOIN ofertas_academicas c " & vbCrLf &_
			"  ON f.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
			"  INNER JOIN especialidades d " & vbCrLf &_
			"  ON c.espe_ccod = d.espe_ccod " & vbCrLf &_
			"  INNER JOIN carreras e " & vbCrLf &_
			"  ON d.carr_ccod = e.carr_ccod " & vbCrLf &_
			"  INNER JOIN areas_academicas h " & vbCrLf &_
			"  ON e.area_ccod = h.area_ccod " & vbCrLf &_
			"  WHERE cast(b.peri_ccod as varchar) = '"&periodo&"'" & vbCrLf &_
			"  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'" & vbCrLf &_
			"  and f.post_ncorr = " & post_ncorr & "" & vbCrLf &_
			"  and f.ofer_ncorr = " & ofer_ncorr & "" & vbCrLf &_						
			"  and not exists (select 1 " & vbCrLf &_
			"                  from alumnos a2 " & vbCrLf &_
			"				  where a2.post_ncorr = b.post_ncorr " & vbCrLf &_
			"				    and a2.emat_ccod = 1)"
			'response.Write("<pre>"&consulta&"</pre>")
set formulario 		= 		new cFormulario
formulario.carga_parametros	"busca_examen_postulante.xml",	"tabla_valores"
formulario.inicializar		conectar
formulario.consultar 		consulta

carr_ccod = conectar.consultaUno("select ltrim(rtrim(carr_ccod)) from ofertas_academicas a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
if carr_ccod = "840" then
	formulario.agregaCampoParam "eepo_ccod","destino","(select eepo_ccod,eepo_tdesc from estado_examen_postulantes)aa"
else
	formulario.agregaCampoParam "eepo_ccod","destino","(select eepo_ccod,eepo_tdesc from estado_examen_postulantes where eepo_ccod <> 7 )aa"
end if

formulario.siguientef
filas = formulario.nrofilas

'---------------------------------------------------------------------------------------------------



resultado_examen = conectar.consultaUno("select eepo_ccod from detalle_postulantes where cast(post_ncorr as varchar)='"&post_ncorr&"' and cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'")
if resultado_examen <> "1" and resultado_examen <> "5" then
'consulta = " select '- Resultado examen ingresado por ' + protic.initcap(b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno) '+ ' el día ' + protic.trunc(a.audi_fmodificacion) " &_
'		   " from detalle_postulantes a, personas b "&_
'		   " where cast(post_ncorr as varchar)='"&post_ncorr&"' and cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'" &_
'		   " and a.audi_tusuario *= cast(b.pers_nrut as varchar)"

consulta = " select '- Resultado examen ingresado por ' + protic.initcap(b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno) + ' el día ' + protic.trunc(a.audi_fmodificacion) " &_
		   " from detalle_postulantes a LEFT OUTER JOIN personas b "&_
		   " ON cast(post_ncorr as varchar)='"&post_ncorr&"' and cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'" &_
		   " WHERE a.audi_tusuario = cast(b.pers_nrut as varchar)"
'response.Write(consulta)		   
mensaje_culpable = conectar.consultaUno(consulta)
else
mensaje_culpable= ""
end if


usuario_sesion = negocio.obtenerUsuario

tcar_ccod = conectar.consultaUno("select tcar_ccod from ofertas_academicas a, especialidades b, carreras c where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
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
function agregar(formulario){
	formulario.action = 'proc_edita_examen.asp';
  	if(preValidaFormulario(formulario)){	
	formulario.submit();
	}
 }
function salir(){
viene ='<%=viene%>'
if (viene !=1){
	self.opener.location.reload();
}
else{
	self.opener.close();
	self.opener.opener.location.reload();
}	
window.close();
}
function Habilita(opcion){
objeto_nota=document.editar.elements["em[0][dpos_ncalificacion]"];
	if ((opcion==2)||(opcion==3)){
		objeto_nota.disabled=false;
	}
	else{
		objeto_nota.value="";
		objeto_nota.disabled=true;
	}
}
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function mandar_email(formulario)
{
	formulario.action = 'http://admision.upacifico.cl/postulacion/www/proc_edita_examen.php';
  	if(preValidaFormulario(formulario))
	{
	formulario.elements["eepo_ccod"].value = formulario.elements["em[0][eepo_ccod]"].value;
	formulario.elements["dpos_ncalificacion"].value = formulario.elements["em[0][dpos_ncalificacion]"].value;
	formulario.elements["dpos_tobservacion"].value = formulario.elements["em[0][dpos_tobservacion]"].value;	
	formulario.elements["post_ncorr"].value = formulario.elements["em[0][post_ncorr]"].value;
	formulario.elements["ofer_ncorr"].value = formulario.elements["em[0][ofer_ncorr]"].value;
	formulario.submit();
	}
 }
</script>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br>
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
            <td><%pagina.DibujarLenguetas Array("Examen Postulante"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Examen Postulante"%>
           
			  <form name="editar" method="post">
                <input type="hidden" name="audi_tusuario" value="<%=negocio.obtenerUsuario%>">
				<input type="hidden" name="eepo_ccod" value="">
				<input type="hidden" name="dpos_ncalificacion" value="">
				<input type="hidden" name="dpos_tobservacion" value="">
				<input type="hidden" name="post_ncorr" value="">
				<input type="hidden" name="ofer_ncorr" value="">
                <table width="90%" border="0" align="c<%response.Write(carr_ccod)%>enter">
                  <tr>
                    <td width="31%"><font color="#CC3300">&nbsp;</font> Rut</td>
                    <td width="69%">: <strong><%formulario.dibujacampo("rut")%></strong></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Nombre</td>
                    <td>:<%formulario.dibujacampo("nombre_completo")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Escuela</td>
                    <td>:<%formulario.dibujacampo("escuela")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Carrera</td>
                    <td>:<%formulario.dibujacampo("carrera")%></td>
                  </tr>
				  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Fono</td>
                    <td>:<%formulario.dibujacampo("fono")%></td>
                  </tr>
				  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Email</td>
                    <td>:<%formulario.dibujacampo("email")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Examen</td>
                    <td>:<%formulario.dibujacampo("eepo_ccod")%></td>
                  </tr>
				   <tr>
                    <td><font color="#CC3300">&nbsp;</font> Calificacion</td>
                    <td>:<%formulario.dibujacampo("dpos_ncalificacion")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">&nbsp;</font> Observaciones</td>
                    <td>:<%formulario.dibujacampo("dpos_tobservacion")%></td>
                  </tr>
                  <tr>
                    <td><%formulario.dibujacampo("post_ncorr")%>
					    <%formulario.dibujacampo("ofer_ncorr")%>
					</td>
                    <td>&nbsp;</td>
                  </tr>
				  <%if mensaje_culpable <> "" then %>
				  <tr>
                    <td colspan="2" align="center"><%=mensaje_culpable%></td>
                  </tr>
				  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
				  <%else%>
				  <tr>
                    <td colspan="2" align="center">&nbsp;
						<!--<table width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="#CC0000">
							<tr><td width="100%" bgcolor="#FFFFFF"><font size="2" color="#CC0000"><strong>Atención:<br>
                                </strong>Utilice el botón &quot;Guardar&quot;, 
                                solamente cuando el alumno ya tiene la ficha larga 
                                completada y la postulación enviada. (No utilizar 
                                este botón para ficha previa WEB)</font></td>
                            </tr>
						</table>-->
					</td>
                  </tr>
				  <%end if%>
				  <%if pagado = false then%>
				  	<tr>
						<td colspan="2"><font size="2" color="#0033FF">El (La) postulante aún no cancela el carga de "derecho de inscripción", una vez cancelado podrá ingresar el estado del test.</font></td>
					</tr>
				  <%end if%>
                </table>
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
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%    'if pagado = false then
																												  'botonera.agregaBotonParam "GUARDAR","deshabilitado","true"
																											  'end if 
																											  if tcar_ccod <> "2" and carr_ccod <> "600" then
																												  botonera.agregaBotonParam "GUARDAR","deshabilitado","true"
																											  end if 
																											  if carr_ccod = "500" then
																											  	botonera.dibujaboton "GUARDAR"
																											  end if	
																									   %>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "SALIR"%>
                  </font> </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%  if pagado = false then
				                                                                                              botonera.agregaBotonParam "ENVIAR_MAIL","deshabilitado","true"
																										  end if 
																										  if tcar_ccod = "2" or carr_ccod = "600" then
				                                                                                              botonera.agregaBotonParam "ENVIAR_MAIL","deshabilitado","true"
																										  end if 
				                                                                                          botonera.dibujaboton "ENVIAR_MAIL"%>
                  </font> </div></td>
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
