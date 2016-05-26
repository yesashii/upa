<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
codigo = Request.QueryString("codigo")

set errores = new CErrores
 
encu_ncorr = "28"

set conectar = new cconexion
conectar.inicializar "upacifico"

set botonera = new CFormulario
botonera.Carga_Parametros "encuesta_administrativos.xml", "botonera"

nombre_encuesta = conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion = conectar.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")

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

set datos_extras= new cformulario
datos_extras.carga_parametros "encuesta_administrativos.xml","datos_adicionales_profesionales"
datos_extras.inicializar conectar
if codigo = "" then
Query_datos = " select '' as nombres,'' as apellidos, '' as preg_a_otro, "&_
			  " '' as preg_e_otro, '' as preg_f_otro"
else
Query_datos = " select isnull(nombres,'') as nombres,isnull(apellidos,'') as apellidos, isnull(preg_a_otro,'') as preg_a_otro, "&_
			  " isnull(preg_e_otro,'') as preg_e_otro, isnull(preg_f_otro,0) as preg_f_otro,preg_a,preg_b,preg_c,preg_d,preg_e,preg_f "&_
			  " from encuestas_administrativos where cast(eadm_ncorr as varchar)='"&codigo&"'"
end if
datos_extras.consultar Query_datos
datos_extras.siguiente


preg_a=datos_extras.obtenerValor("preg_a")
preg_b=datos_extras.obtenerValor("preg_b")
preg_c=datos_extras.obtenerValor("preg_c")
preg_d=datos_extras.obtenerValor("preg_d")
preg_e=datos_extras.obtenerValor("preg_e")
preg_f=datos_extras.obtenerValor("preg_f")

select case preg_a
case "1": 
	preg_a_1="checked"
case "2": 
	preg_a_2="checked"
case "3": 
	preg_a_3="checked"
case "4": 
	preg_a_4="checked"	
end select
	
select case preg_b
case "1": 
	preg_b_1="checked"
case "2": 
	preg_b_2="checked"
case "3": 
	preg_b_3="checked"
case "4": 
	preg_b_4="checked"	
end select

select case preg_c
case "1": 
	preg_c_1="checked"
case "2": 
	preg_b_2="checked"
end select

select case preg_d
case "1": 
	preg_d_1="checked"
case "2": 
	preg_d_2="checked"
case "3": 
	preg_d_3="checked"
case "4": 
	preg_d_4="checked"	
end select

select case preg_e
case "1": 
	preg_e_1="checked"
case "2": 
	preg_e_2="checked"
case "3": 
	preg_e_3="checked"
case "4": 
	preg_e_4="checked"	
end select

select case preg_f
case "1": 
	preg_f_1="checked"
case "2": 
	preg_f_2="checked"
case "3": 
	preg_f_3="checked"
case "4": 
	preg_f_4="checked"	
end select

%>

<html>
<head>
<title>CUESTIONARIO DE EVALUACIÓN DE LA ACTUAL ESTRUCTURA ORGANIZACIONAL DE LA UNIVERSIDAD DEL PACÍFICO</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
var t_busqueda;

function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv")
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function volver()
{
   location.href ="menu_alumno.asp";
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
  	if ((elemento.type=="radio")&&((elemento.name=="p[0][preg_1]")||(elemento.name=="p[0][preg_2]")||(elemento.name=="p[0][preg_3]")||(elemento.name=="p[0][preg_4]")||(elemento.name=="p[0][preg_5]")||(elemento.name=="p[0][preg_6]")||(elemento.name=="p[0][preg_7]")||(elemento.name=="p[0][preg_8]")||(elemento.name=="p[0][preg_9]")||(elemento.name=="p[0][preg_10]")||(elemento.name=="p[0][preg_11]")||(elemento.name=="p[0][preg_12]")||(elemento.name=="p[0][preg_13]")||(elemento.name=="p[0][preg_14]")||(elemento.name=="p[0][preg_15]")||(elemento.name=="p[0][preg_16]")||(elemento.name=="p[0][preg_17]")||(elemento.name=="p[0][preg_18]")||(elemento.name=="p[0][preg_19]")||(elemento.name=="p[0][preg_20]")||(elemento.name=="p[0][preg_21]")||(elemento.name=="p[0][preg_22]")||(elemento.name=="p[0][preg_23]")||(elemento.name=="p[0][preg_24]")||(elemento.name=="p[0][preg_25]")||(elemento.name=="p[0][preg_26]")||(elemento.name=="p[0][preg_27]")||(elemento.name=="p[0][preg_28]")||(elemento.name=="p[0][preg_29]") ))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
  
  if (divisor!=0)
  {
  //alert(cant_radios);
   //alert(contestada);
  if ((contestada) == ((cant_radios)/divisor) )
  { 
	 if(confirm("Está seguro que desea grabar la Evaluación.?")) 
     { document.edicion.method = "POST";
	   document.edicion.action = "encuesta_administrativos_proc.asp";
       document.edicion.submit();
	 }  
  }
  else
   alert("Debe responder la encuesta antes de grabar,\n aún restan preguntas de selección por responder.");
  }
  else
     alert("Esta encuesta no ha sido creada completamente aún, No la puede contestar");

}
function InicioPagina()
{
	t_busqueda = new CTabla("b");
}
</script>


</head>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
		<br>
	    <br>

	<%if encu_ncorr <> "" then%>
	<form name="edicion">
		<% 'response.Write("Select Count(*) from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
		  contestada = conectar.consultaUno("select count(*) from encuestas_administrativos where cast(eadm_ncorr as varchar)='"&codigo&"'")
		  
		%>
	<input name="p[0][encu_ncorr]" type="hidden" value="<%=encu_ncorr%>">
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
                      <font face="Verdana, Arial, Helvetica, sans-serif"><span style="color:#42424A; font-weight: bold; font-size: 17px">CUESTIONARIO DE EVALUACIÓN ACTUAL ESTRUCTURA ORGANIZACIONAL <br>UNIVERSIDAD DEL PACÍFICO</span></font>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td colspan="3">&nbsp;</td>
						</tr>
						 <%if codigo <> "" then%>
								  <tr>
								  	<td colspan="3"><font color="#FFFFFF">&nbsp;</font></td>
								  </tr>
								  <tr>
								  	<td colspan="3" bgcolor="#000066" align="center"><font color="#FFFFFF" size="4">La Encuesta fue grabada correctamente en el sistema, muchas gracias por su colaboración.</font></td>
								  </tr>
						<%end if%>
						<tr>
							<td colspan="3">
							<table width="100%" border="0">
								  <tr> 
									<td width="18%" align="left"><strong>Nombre</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td align="left"><font color="#CC0000">&nbsp;<input type="text" name="p[0][nombres]" size="50" maxlength="50" id="TO-N" value="<%=datos_extras.obtenerValor("nombres")%><%=preg_a%>"></font></td>
    							  </tr>
								  <tr> 
									<td width="18%" align="left"><strong>Apellidos</strong> </td>
									<td width="1%"><strong>:</strong></td>
									<td align="left"><font color="#CC0000">&nbsp;<input type="text" name="p[0][apellidos]" size="50" maxlength="50" id="TO-N" value="<%=datos_extras.obtenerValor("apellidos")%>"></font></td>
    							  </tr>
  								  <tr> 
									<td colspan="3"><strong>a)	Función o cargo:</strong> </td>
    							  </tr>
								  <tr> 
									<td colspan="3" align="center">
										<table width="90%" border="1">
											<tr valign="top">
												<td width="20%" align="center">Directivo<br>Superior</td>
												<td width="20%" align="center">Jefe de<br>Departamento<br>o Dirección<br>Administrativa</td>
												<td width="20%" align="center">Director de<br>Escuela</td>
												<td width="20%" align="center">Coordinador<br>académico</td>
												<td width="20%" align="center">Otro<br>(Especificar)</td>
											</tr>
											<tr valign="top">
												<td width="20%" align="center"><input type="radio" name="p[0][preg_a]" value="1" <%=preg_a_1%> ></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_a]" value="2" <%=preg_a_2%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_a]" value="3" <%=preg_a_3%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_a]" value="4" <%=preg_a_4%>></td>
												<td width="20%" align="center"><input type="text"  name="p[0][preg_a_otro]" size="25" maxlength="50" value="<%=datos_extras.obtenerValor("preg_a_otro")%>"></td>
											</tr>
										</table>
									</td>
    							  </tr>
								  <tr> 
									<td colspan="3"><strong>b)	Rango de edad: </strong> </td>
    							  </tr>
								  <tr> 
									<td colspan="3" align="center">
										<table width="90%" border="1">
											<tr valign="top">
												<td width="25%" align="center">Menor de 30 años</td>
												<td width="25%" align="center">Entre 31 y 40 años</td>
												<td width="25%" align="center">Entre 41 y 50 años</td>
												<td width="25%" align="center">Mayor de 50 años</td>
											</tr>
											<tr valign="top">
												<td width="25%" align="center"><input type="radio" name="p[0][preg_b]" value="1" <%=preg_b_1%>></td>
												<td width="25%" align="center"><input type="radio" name="p[0][preg_b]" value="2" <%=preg_b_2%>></td>
												<td width="25%" align="center"><input type="radio" name="p[0][preg_b]" value="3" <%=preg_b_3%>></td>
												<td width="25%" align="center"><input type="radio" name="p[0][preg_b]" value="4" <%=preg_b_4%>></td>
											</tr>
										</table>
									</td>
    							  </tr>
								  <tr> 
									<td colspan="3"><strong>c)	Sexo:  </strong> </td>
    							  </tr>
								  <tr> 
									<td colspan="3" align="center">
										<table width="45%" border="1">
											<tr valign="top">
												<td width="50%" align="center">Masculino</td>
												<td width="50%" align="center">Femenino</td>
											</tr>
											<tr valign="top">
												<td width="50%" align="center"><input type="radio" name="p[0][preg_c]" value="1" <%=preg_c_1%>></td>
												<td width="50%" align="center"><input type="radio" name="p[0][preg_c]" value="2" <%=preg_c_2%>></td>
											</tr>
										</table>
									</td>
    							  </tr>
								  <tr> 
									<td colspan="3"><strong>d)	Año de Ingreso a la Universidad:</strong> </td>
    							  </tr>
								  <tr> 
									<td colspan="3" align="center">
										<table width="90%" border="1">
											<tr valign="top">
												<td width="25%" align="center">2004 o antes</td>
												<td width="25%" align="center">2005</td>
												<td width="25%" align="center">2006</td>
												<td width="25%" align="center">2007</td>
											</tr>
											<tr valign="top">
												<td width="25%" align="center"><input type="radio" name="p[0][preg_d]" value="1" <%=preg_d_1%>></td>
												<td width="25%" align="center"><input type="radio" name="p[0][preg_d]" value="2" <%=preg_d_2%>></td>
												<td width="25%" align="center"><input type="radio" name="p[0][preg_d]" value="3" <%=preg_d_3%>></td>
												<td width="25%" align="center"><input type="radio" name="p[0][preg_d]" value="4" <%=preg_d_4%>></td>
											</tr>
										</table>
									</td>
    							  </tr>
								   <tr> 
									<td colspan="3"><strong>e)	Unidad de Dependencia:</strong> </td>
    							  </tr>
								  <tr> 
									<td colspan="3" align="center">
										<table width="90%" border="1">
											<tr valign="top">
												<td width="20%" align="center">Rectoría</td>
												<td width="20%" align="center">Vicerrectoría<br>Académica</td>
												<td width="20%" align="center">Vicerrectoría<br>de<br>Administración<br>y Finanzas</td>
												<td width="20%" align="center">Vicerrectoría<br>de<br>Planificación<br>y Desarrollo</td>
												<td width="20%" align="center">Otra<br>(Especificar)</td>
											</tr>
											<tr valign="top">
												<td width="20%" align="center"><input type="radio" name="p[0][preg_e]" value="1" <%=preg_e_1%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_e]" value="2" <%=preg_e_2%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_e]" value="3" <%=preg_e_3%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_e]" value="4" <%=preg_e_4%>></td>
												<td width="20%" align="center"><input type="text"  name="p[0][preg_e_otro]" size="25" maxlength="50" value="<%=datos_extras.obtenerValor("preg_e_otro")%>"></td>
											</tr>
										</table>
									</td>
    							  </tr>
								   <tr> 
									<td colspan="3"><strong>f)	Grado Académico:</strong> </td>
    							  </tr>
								  <tr> 
									<td colspan="3" align="center">
										<table width="90%" border="1">
											<tr valign="top">
												<td width="20%" align="center">Técnico</td>
												<td width="20%" align="center">Profesional</td>
												<td width="20%" align="center">Profesionala<br>con Postitulo<br>o Diplomado</td>
												<td width="20%" align="center">Profesional con<br>Postgrado (Magíster<br>o Doctorado)</td>
												<td width="20%" align="center">Otro<br>(Especificar)</td>
											</tr>
											<tr valign="top">
												<td width="20%" align="center"><input type="radio" name="p[0][preg_f]" value="1" <%=preg_f_1%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_f]" value="2" <%=preg_f_2%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_f]" value="3" <%=preg_f_3%>></td>
												<td width="20%" align="center"><input type="radio" name="p[0][preg_f]" value="4" <%=preg_f_4%>></td>
												<td width="20%" align="center"><input type="text"  name="p[0][preg_f_otro]" size="25" maxlength="50" value="<%=datos_extras.obtenerValor("preg_f_otro")%>"></td>
											</tr>
										</table>
									</td>
    							  </tr>
								 
						    </table>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
                          <td colspan="3"><strong>INSTRUCCIONES : </strong></td>
						</tr>
						<tr>  
						  <td colspan="3"><div align="justify"><%=instruccion%></div></td>
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
							<tr bgcolor="#990000"> 
                          		<td colspan="3"><font color="#FFFFFF"><strong><%=titulo%></strong></font></td>
						  		
						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="20"><font color="#FFFFFF"><strong><center>
						  				<%response.Write(abrev)		
										%></center></strong></font>
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
											     'response.Write("Select preg_"&contador2&"_"&contador&" from encuestas_disenio where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"'")
												  respuesta = conectar.consultaUno("Select preg_"&contador&" from encuestas_administrativos where cast(eadm_ncorr as varchar)='"&codigo&"'")  
												   'response.Write("enca "&respuesta)
												   if respuesta <> "" then 'and not esVacio(respuesta) then	
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
								Query_preguntas=""
								'contador = 1
								'contador2 = contador2 + 1%>
								
							<tr>
							<td colspan="5">&nbsp;</td>
							</tr>
							<%wend 
							
							end if
							%>
							<tr>
                          		<td colspan="5"><div align="center"><strong>PREGUNTAS DE DESARROLLO</strong></div></td>
                           </tr>
						   <tr>
                          		<td colspan="5"><div align="center"><strong>&nbsp;</strong></div></td>
                           </tr>
							<tr>
                          		<td colspan="5"><div align="left"><strong>30 .- En su opinión, ¿cuáles fueron los cambios estructurales más beneficiosos para el desarrollo de la Universidad?</strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                           <td colspan="5"><div align="center">
						                                <%respuesta = conectar.consultaUno("Select preg_30 from encuestas_administrativos where cast(eadm_ncorr as varchar)='"&codigo&"'")%>
						                          		<textarea name="p[0][preg_30]" cols="100" rows="4" id="TO-N"><%=respuesta%></textarea>
             							  </div>
						  </td>
                          </tr>
						  <tr>
                          		<td colspan="5"><div align="center"><strong>&nbsp;</strong></div></td>
                          </tr>
						  <tr>
                          		<td colspan="5"><div align="left"><strong>31 .- De los cambios estructurales que se realizaron; ¿cuáles considera usted resultarán más complejos de implementarse o requerirán un mayor tiempo de ajuste para producir los resultados esperados?</strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                           <td colspan="5"><div align="center">
						                                <%respuesta = conectar.consultaUno("Select preg_31 from encuestas_administrativos where cast(eadm_ncorr as varchar)='"&codigo&"'")%>
						                          		<textarea name="p[0][preg_31]" cols="100" rows="4" id="TO-N"><%=respuesta%></textarea>
             							  </div>
						  </td>
                          </tr>
						  <tr>
                          		<td colspan="5"><div align="center"><strong>&nbsp;</strong></div></td>
                          </tr>
						  <tr>
                          		<td colspan="5"><div align="left"><strong>32 .- ¿Qué otros ajustes a la estructura considera usted deberían hacerse en el mediano plazo para potenciar el desarrollo de la Universidad? </strong></div></td>
                           </tr>
						   <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                           </tr>
						   <tr>
                           <td colspan="5"><div align="center">
						                                <%respuesta = conectar.consultaUno("Select preg_31 from encuestas_administrativos where cast(eadm_ncorr as varchar)='"&codigo&"'")%>
						                          		<textarea name="p[0][preg_32]" cols="100" rows="4" id="TO-N"><%=respuesta%></textarea>
             							  </div>
						  </td>
                          </tr>
						  <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                          </tr>
						  <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                          </tr>
						  <tr>
                                <td colspan="5"><div align="center">&nbsp;</div></td>
                          </tr>
						  <tr>
                                <td colspan="5"><div align="center">¡MUCHAS GRACIAS POR SU COOPERACIÓN!</div></td>
                          </tr>
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
                      <td width="50%">&nbsp;</td>
                      <td width="50%"><% if contestada = 0 then
						botonera.dibujaBoton "guardar_encuesta"
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
