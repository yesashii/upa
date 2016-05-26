<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
 
encu_ncorr = request.querystring("encu_ncorr")
pers_ncorr = request.querystring("pers_ncorr")
secc_ccod = request.querystring("secc_ccod")
pers_ncorr_profesor = request.querystring("pers_ncorr_docente")
'response.Write(encu_ncorr)

'--------------------------------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if pers_ncorr = "" then
	pers_nrut= negocio.obtenerUsuario()
	pers_ncorr= conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
	'encu_ncorr=""
end if



consulta_cantidad_encuestas= " select count(distinct b.encu_ncorr) " &_
                             " from sis_roles_usuarios a, roles_encuestas b "&_
							 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' "&_
                             " and a.srol_ncorr=b.srol_ncorr"
cantidad_encuestas=conectar.consultaUno(consulta_cantidad_encuestas)
'response.Write(consulta_cantidad_encuestas)
if cantidad_encuestas = "0" then
encu_ncorr=""
end if


set botonera = new CFormulario
botonera.Carga_Parametros "m_ver.xml", "botonera"
cantidad_encuestas=cInt(cantidad_encuestas)
if cantidad_encuestas = "0" then
	mensaje="Aún no existen encuestas disponibles para ser completadas por Usted."
else
	'mensaje="El usuario tienes "&cantidad_encuestas&" encuesta(s) a contestar"
    if cantidad_encuestas = "1" then
	    consulta_encuestas= " select distinct b.encu_ncorr " &_
                             " from sis_roles_usuarios a, roles_encuestas b "&_
							 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' "&_
                             " and a.srol_ncorr=b.srol_ncorr"
		encu_ncorr=conectar.consultaUno(consulta_encuestas)
	else
		set encuestas= new cformulario
		encuestas.carga_parametros "tabla_vacia.xml","tabla"
		encuestas.inicializar conectar
		Query_encuestas= " select distinct c.encu_ncorr,c.encu_ccod,c.encu_ttitulo " &_
                             " from sis_roles_usuarios a, roles_encuestas b,encuestas c "&_
							 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' "&_
                             " and a.srol_ncorr=b.srol_ncorr and b.encu_ncorr = c.encu_ncorr"
		'Query_encuestas = "Select a.encu_ncorr, b.encu_ccod, b.encu_ttitulo from universos a, encuestas b where a.encu_ncorr=b.encu_ncorr and a.pers_ncorr_encuestada ='"&pers_ncorr&"'"
		encuestas.consultar Query_encuestas
   end if
end if

nombre_encuesta = conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conectar.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
pagina.Titulo = nombre_encuesta



set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conectar
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas

set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conectar
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
carrera=conectar.consultaUno("select protic.initCap(carr_tdesc) from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")

asignatura=conectar.consultaUno("select ltrim(rtrim(b.asig_ccod))+' ' + protic.initCap(b.asig_tdesc) from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'") 

seccion=conectar.consultaUno("select secc_tdesc from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
'response.Write("select carr_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'   .................")
carr_ccod=conectar.consultaUno("select carr_ccod from secciones a where cast(a.secc_ccod as varchar)='"&secc_ccod&"'")

'response.Write("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
ano_ingreso = conectar.consultaUno("select protic.ano_ingreso_carrera("&pers_ncorr&",'"&carr_ccod&"')")
'response.End()
profesor = conectar.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_profesor&"'")

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
function volver()
{
   location.href ="seleccionar_docente.asp";
}

function direccionar(valor)
{var cadena;
 var secc_ccod='<%=secc_ccod%>';
 var pers_ncorr_profesor='<%=pers_ncorr_profesor%>';
 location.href="contestar_encuesta2.asp?encu_ncorr="+valor+"&secc_ccod="+secc_ccod+"&pers_ncorr_docente="+pers_ncorr_profesor;
}


function validar()
{ var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=<%=cantid%>;
  //alert("divisor= "+divisor);
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  //alert("nombre= "+elemento.name+" tipo "+elemento.type+" valor "+elemento.value);
  	if (elemento.type=="radio")
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
  if (divisor!=0)
  {
  if (contestada==(cant_radios/divisor))
  { 
	 if(confirm("Está seguro que desea grabar la Evaluación.\n\nUna vez guardada la encuesta, no podrá realizar cambio alguno en ella.")) 
     { document.edicion.method = "POST";
	   document.edicion.action = "grabar_respuestas2.asp";
       document.edicion.submit();
	 }  
  }
  else
   alert("Debe responder la encuesta antes de grabar,\n aún faltan preguntas por responder.");
  }
  else
     alert("Esta encuesta no ha sido creada completamente aún, No la puede contestar");

}

</script>


</head>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
	<br>
	<%if cantidad_encuestas <> "1"  then%>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
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
              
            </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="left"><%
						if cantidad_encuestas = "0" then
						response.Write("<center><h3>"&mensaje&"</h3></center>")
						botonera.dibujaBoton "Volver"
						else%>
						<strong>Seleccione una encuesta : </strong> 
						<select name="nombre" onChange="direccionar(this.value)">
						<option value="">Encuestas</option>
						<%while encuestas.siguiente
								ncorr = encuestas.obtenervalor("encu_ncorr")
								codigo= encuestas.obtenervalor("encu_ccod")
								titulo1= encuestas.obtenervalor("encu_ttitulo")%>
								<option value="<%=ncorr%>"><%=codigo&"-"&titulo1%></option>	
						<%wend%>
						
						 </select>
						 		
						<%
						end if
						%> 
                      </div>
					  </td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<%end if 'fin del if que muestra el selesct de las encuestas%>
	<br>
	<%if encu_ncorr <> "" then%>
	<form name="edicion">
		<% 'response.Write("Select Count(*) from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  contestada = conectar.consultaUno("Select Count(*) from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  
		%>
	<input name="encu_ncorr" type="hidden" value="<%=encu_ncorr%>">
	<input name="pers_ncorr" type="hidden" value="<%=pers_ncorr%>">
	<input name="pers_ncorr_profesor" type="hidden" value="<%=pers_ncorr_profesor%>">
	<input name="secc_ccod" type="hidden" value="<%=secc_ccod%>">
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
              </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  
				     <div align="center">
                      <%pagina.DibujarTituloPagina%>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3">
							<table width="100%" border="0">
								  <tr> 
									<td width="18%" align="left"><strong>Escuela</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td width="38%" align="left"><font color="#CC0000"><%=carrera%></font></td>
									<td width="14%" align="right"><strong>Secci&oacute;n</strong></td>
									<td width="2%"><strong>:</strong></td>
									<td colspan="3" align="left"><font color="#CC0000"><%=seccion%></font></td>
								  </tr>
  								  <tr> 
									<td width="18%" align="left"><strong>Asignatura</strong></td>
									<td width="1%"><strong>:</strong></td>
									<td width="38%" align="left"><font color="#CC0000"><%=asignatura%></font></td>
									<td width="14%" align="right"><strong>A&ntilde;o de ingreso </strong></td>
									<td width="2%"><strong>:</strong></td>
									<td width="27%" align="left"><font color="#CC0000"><%=ano_ingreso%></font></td>
    							  </tr>
								   <tr> 
									<td width="18%" align="left"><strong>Profesor</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td colspan="6" align="left"><strong><font color="#CC0000"><%=profesor%></font></strong></td>
								  </tr>
						    </table>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
                          <td colspan="3"><strong>INSTRUCCIONES : </strong>Estimado Alumno (a):</td>
						</tr>
						<tr>  
						  <td colspan="3"><%=instruccion%></td>
						</tr>
						<tr>  
						  <td colspan="3" height="20"></td>
						</tr> 
						<%if cantid > "0" then
						  while escala.siguiente
								abrev = escala.obtenervalor("resp_tabrev")
								texto= escala.obtenervalor("resp_tdesc")						
						%> 
						<tr>  
						   <td width="3%"><div align="left"><strong><%=abrev%></strong></div></td>
  						   <td width="3%"><strong><center>:</center></strong></td>
						   <td width="94%"><div align="left"><strong><%=texto%></strong></div></td>
						</tr>
						<%
						wend
						end if
						%>
						
                      </table>
                   <table width="100%" border="0">
						  <tr> 
							<td width="5%"> 
							</td>
							<td width="6%">&nbsp; </td>
							<td width="75%">&nbsp;</td>
							<td width="14%">&nbsp;</td>
						  </tr>
						</table>
                       <table width="100%"  border="0" align="center">
                       <%if cantid_criterios >"0" then
					        contador=1
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
							<tr> 
                          		<td colspan="3"><strong><%=titulo%></strong></td>
						  		
						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><strong><center>
						  				<%response.Write(abrev)		
										%></center></strong>
										</td>
									<%wend
								end if%>
							<td width="2">&nbsp;</td>	
							</tr>
							<%
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,preg_ccod,protic.initCap(preg_tdesc) as preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
							preguntas.consultar Query_preguntas
							cantid_preguntas = preguntas.nroFilas
							'response.Write("ncorr= "&ncorr&" cantidad_preguntas "&cantid_preguntas)
								if cantid_preguntas >"0" then
						  			while preguntas.siguiente
									    'response.Write("sql= "&Query_preguntas)
										orden = preguntas.obtenervalor("preg_norden")
										pregunta= preguntas.obtenervalor("preg_tdesc")						
										ccod=preguntas.obtenervalor("preg_ccod")						
										preg_ncorr=preguntas.obtenervalor("preg_ncorr")						
										%>  
										<tr> 
                          				<td width="18" align="right"><strong><%=contador%></strong></td>
										<td width="17"><%=".-"%></td>
										<td width="591"><%=pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
						  					while escala.siguiente%>
											 <td width="20"><center>
											   <%if contestada <> 0 then
											     'response.Write("Select resp_ncorr from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"'")
												  respuesta = conectar.consultaUno("Select resp_ncorr from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"'")  
												   'response.Write("enca "&respuesta)
												   if respuesta <> "" and not esVacio(respuesta) then	
														if cInt(respuesta) = cInt(escala.obtenervalor("resp_ncorr")) then%>
												 			<input type="radio" name="<%=preg_ncorr%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
												 		<%else%>
															<input type="radio" name="<%=preg_ncorr%>" value="<%=escala.obtenervalor("resp_ncorr")%>" disabled>
												 		<%end if
												   end if%>
											   <%else%>
						  							<input type="radio" name="<%=preg_ncorr%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
						  					  <%end if%>
											  </center></td>
											<%wend
									    end if%>
										<td width="2">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									wend
								end if
								Query_preguntas=""%>
								
							<tr>
							<td colspan="5">&nbsp;</td>
							</tr>
							<%wend 
							end if
							%>
                         </table> 
                    <BR>
                  </div>
				</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="50%"><% botonera.dibujaBoton "Volver" %></td>
                      <td width="50%"><% if contestada = 0 then
						botonera.dibujaBoton "grabar"
						end if  %> </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>
	  </form>
	  <%end if%>	
   </td>
  </tr>  
</table>
</body>
</html>
