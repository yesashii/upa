<!-- #include file = "../biblioteca/de_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Tus Datos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
encu_ncorr = "29"
if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
ruta = "test.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta2 = "asi_soy_yo.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta3 = "tus_datos.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b "&_
				 " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' and a.emat_ccod in (1)" &_
				 " and a.ofer_ncorr = b.ofer_ncorr "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)

'response.Write(consulta_matr)
carrera = conexion.consultaUno("Select carr_tdesc from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")
instruccion = conexion.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")

cod_carrera = conexion.consultaUno("Select d.carr_ccod from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

post_ncorr= conexion.consultaUno("select post_ncorr from postulantes where pers_ncorr='"&pers_ncorr&"'and peri_ccod=210")
codeudor=conexion.consultaUno("select pers_ncorr from codeudor_postulacion where post_ncorr in(select post_ncorr from postulantes p,personas a where p.pers_ncorr='"&pers_ncorr&"' and peri_ccod= 210 )")



c_contestadas = " select case count (*) when 0 then 'N' else 'S' end " & vbCrLf &_
		     " from encuesta_estilo_aprendizaje b  " & vbCrLf &_
		     " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'" 
contestadas = conexion.consultaUno(c_contestadas)
'persona_existe=conexion.consultaUno("select case count (*) when 0 then 'NO' else 'SI' end  from personas where pers_ncorr =protic.obtener_pers_ncorr1(isnull('"&z1_pers_nrut&"',0))"
'contestadas="N"


c_contestada = " select case count (*) when 0 then 'N' else 'Si' end " & vbCrLf &_
		     " from encuesta_asi_soy_yo b  " & vbCrLf &_
		     " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'" 
contestada = "N"
		   
'response.Write("<pre>"&post_ncorr&"</pre>")
'response.End()		   
'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "tus_datos.xml", "botonera"

pers_ncorr_temporal=pers_ncorr

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tus_datos.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = " select p.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, " & vbCrLf &_
		   " pers_tnombre as nombres, pers_tape_paterno as ap_paterno, pers_tape_materno as ap_materno, pers_temail,pais_ccod," & vbCrLf &_
		   " datediff(year,pers_fnacimiento,getDate()) as edad, " & vbCrLf &_
		   " pers_tfono, pers_tcelular, dire_tcalle+' #'+dire_tnro as dir " & vbCrLf &_
		   " from personas p,direcciones d  " & vbCrLf &_
		   " where cast(p.pers_ncorr as varchar)= '" & pers_ncorr & "' and p.pers_ncorr=d.pers_ncorr and tdir_ccod=1"
		   

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
'----------------------------------------------------------------------------------------------------
set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conexion
Query_escala = "select  resp_ncorr,resp_tabrev,protic.initcap(resp_tdesc) as resp_tdesc from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.Consultar Query_escala
cantid = escala.nroFilas
'response.Write("<pre>"&Query_escala&"</pre>")
set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conexion
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.Consultar Query_criterios
cantid_criterios = criterios.nroFilas


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Tus Datos - Encuesta Universidad del Pac&iacute;fico</title>
<style type="text/css">
<!--
.Estilo25 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
body {
	background-color: #dae4fa;
}
.Estilo26 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
}
.Estilo27 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo35 {
	font-weight: bold;
	font-size: 36px;
	font-style: italic;
	color: #FF7F00;
}
.Estilo36 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; }
.Estilo37 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; font-weight: bold; }
.Estilo39 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo43 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #333333; }
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
.Estilo46 {
	color: #FF6600;
	font-weight: bold;
}
-->
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function validar()
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") )
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 return true;
  }
  else
  {
   alert("Debe responder la encuesta antes de grabar,\n aún faltan preguntas por contestar.");
   return false;
  }
}

//-->
</script>
</head>

<body >
<p align="center" class="Estilo35">&quot;Encuesta &quot;</p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=cod_carrera%>">

<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign="bottom">
				<td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta2%>">Así soy yo</a></font></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta%>"> Test</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>

				<td width="100" height="24" background="images/borde_superior.jpg"><span class="Estilo46">Chaea</span></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				
					

				<td bgcolor="#FFFFFF">&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="29" height="24" bgcolor="#FFFFFF">&nbsp;</td>
</tr>
<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="18" height="24" src="images/borde_superior.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="646" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td align="left"><p class="Estilo27">::  Encuesta </p>
				<p class="Estilo31">&nbsp;</p>
			    <table width="90%" border="0" bgcolor="#FFFFFF">
				  <tr>
					<td class="Estilo31" width="20%">Nombres</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("nombres")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Apellido Paterno</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("ap_paterno")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Apellido Materno</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("ap_materno")%></td>
				  </tr>
				  
				  <tr>
					<td class="Estilo31" width="20%">Carrera</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%=carrera%></td>
				  </tr>
			  </table>
			   <% if contestadas = "N" then %>
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
							preguntas.inicializar conexion
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
											   <%if contestada = "S" then
											     'response.Write("Select resp_ncorr from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"' and preg_ncorr='"&preg_ncorr&"'")
												  'respuesta = conexion.consultaUno("Select preg_"&contador&" from encuestas_otec where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"')  
												   'response.Write("enca "&respuesta)
												   if respuesta <> "" and not esVacio(respuesta) then	
														if cInt(respuesta) = cInt(escala.obtenervalor("resp_ncorr")) then%>
												 			<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
												 		<%else%>
															<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>" disabled>
												 		<%end if
												   end if%>
											   <%else%>
						  							<input type="radio" name="<%="p[0][preg_"&contador&"]"%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
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
							<tr>
                          		<td colspan="5"><div align="center"><strong>Escriba sus comentarios, observaciones y/o sugerencias:</strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                           <td colspan="5"><div align="center">
						                                
						                          		<textarea name="p[0][observaciones]" cols="70" rows="10" id="TO-N"><%=respuesta%></textarea>
             							  </div>
						  </td>
                          </tr>
                    </table>
			   
			  
			    <tr>
			<td width="617">
			<p align="center" class="Estilo31">
			
			  <%f_botonera.dibujaBoton "guardar2"%>
			</p></td>
		  </tr>
				  
				  <%else%>
				  <tr><td colspan="3" align="center"><p class="Estilo31"><span class="Estilo27">Tus Respuestas fueron grabadas Correctamente.<br> Muchas Gracias.</span></p></td></tr>
				  <%end if%>
			  
			  
			  
			   	
			   			    
            




</table>
</td>
	<td width="29" background="images/lado_derecha.gif"></td>
</tr>
<tr>
	<td width="25" height="27" background="images/borde_inferior.jpg"><img width="25" height="27" src="images/inferior_izquierda.jpg"></td>
	<td width="646" height="27" background="images/borde_inferior.jpg">&nbsp;</td>
	<td width="29" height="27"><img width="29" height="27" src="images/inferior_derecha.jpg"></td>
</tr>
</table>

</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  Para conversar los temas de la  encuesta y resolver dudas ac&eacute;rcate a la <br />
  <span class="Estilo46">DAE (Direcci&oacute;n de Asuntos  Estudiantiles)</span> en el 3er piso o llamando al 3665366-3665350</span></p>
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
