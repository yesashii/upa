<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
 
encu_ncorr = request.querystring("encu_ncorr")
pers_ncorr = request.querystring("pers_ncorr")
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

if cantidad_encuestas=0 then
encu_ncorr=""
end if
nombre_encuesta=conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
instruccion=conectar.consultaUno("Select encu_tinstruccion from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")

pagina.Titulo = nombre_encuesta



set botonera = new CFormulario
botonera.Carga_Parametros "m_ver.xml", "botonera"
cantidad_encuestas=cInt(cantidad_encuestas)
if cantidad_encuestas=0 then
	mensaje="El Alumno no registra ninguna encuesta a contestar"
else
	'mensaje="El usuario tienes "&cantidad_encuestas&" encuesta(s) a contestar"
    if cantidad_encuestas=1 then
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


set escala= new cformulario
escala.carga_parametros "tabla_vacia.xml","tabla"
escala.inicializar conectar
Query_escala = "select  resp_ncorr,resp_tabrev,resp_tdesc from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by resp_norden"
escala.consultar Query_escala
cantid = escala.nroFilas

set criterios= new cformulario
criterios.carga_parametros "tabla_vacia.xml","tabla"
criterios.inicializar conectar
Query_criterios = "select  crit_ncorr,crit_tdesc from criterios where cast(encu_ncorr as varchar)='"&encu_ncorr&"' order by crit_norden"
criterios.consultar Query_criterios
cantid_criterios = criterios.nroFilas

'response.Write("pers_ncorr "&pers_ncorr)
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
function volver()
{
   location.href ="m_encuestas2.asp";
}

function direccionar(valor)
{var cadena;
location.href="contestar_encuesta2.asp?encu_ncorr="+valor;
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
    { document.edicion.method = "POST";
      document.edicion.action = "grabar_respuestas2.asp";
      document.edicion.submit();
    }
  else
   alert("Debe responder la encuesta antes de grabar");
  }
  else
     alert("Esta encuesta no ha sido creada completamente aún, No la puede contestar");

}

</script>
</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onBlur="revisaVentana();">
<table width="100%"  border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#396DA5" bgcolor="#E7E7DE" id="dos">
  <tr> 
    <td width="100%" align="center" valign="top" bgcolor="#E7E7DE"><BR>
      <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="6"><img src="img/m2_1.gif" width="6" height="6"></td>
          <td><img src="img/m2_2.gif" width="100%" height="6"></td>
          <td width="6"><img src="img/m2_3.gif" width="6" height="6"></td>
        </tr>
        
        <tr> 
          <td background="img/m2_6.gif">&nbsp;</td>
          <td bgcolor="#FFFFF7"><div align="center"></div>
           <br>
		   <%if cantidad_encuestas <> 1 then%>
		   <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
              <tr> 
                <td width="1%"><img src="img/m3_1.gif" width="8" height="8"></td>
                <td width="98%"><img src="img/m3_2.gif" width="100%" height="8"></td>
                <td width="1%"><img src="img/m3_3.gif" width="6" height="8"></td>
              </tr>
              <tr> 
                <td width="5" background="img/m3_4.gif">&nbsp;</td>
                <td bgcolor="#FFFFFF"><div align="center">
                     <table width="100%"  border="0" align="center">
                    	<tr>  
						  
                        <td width="100%" height="15"><%
						if cantidad_encuestas=0 then
						response.Write("<center><h3>"&mensaje&"</h3></center>")
						botonera.dibujaBoton "Volver"
						else%>
						<strong>Seleccione una encuesta : </strong> 
						
						<select name="nombre" onChange="direccionar(this.value)">
						<%if cantidad_sedes > "0" then%>
						<option value="">Encuestas</option>
						<%while encuestas.siguiente
								ncorr = encuestas.obtenervalor("encu_ncorr")
								codigo= encuestas.obtenervalor("encu_ccod")
								titulo1= encuestas.obtenervalor("encu_ttitulo")%>
								
						<option value="<%=ncorr%>"><%=codigo&"-"&titulo1%></option>		
						<%wend%>
						
						 </select>
						 		
						<%end if
						end if
						%></td>
						</tr> 
				     </table>
               
                  </div></td>
                <td background="img/m3_5.gif">&nbsp;</td>
              </tr>
              <tr> 
                <td height="8"><img src="img/m3_6.gif" width="8" height="8"></td>
                <td><img src="img/m3_7.gif" width="100%" height="7"></td>
                <td><img src="img/m3_8.gif" width="6" height="7"></td>
              </tr>
            </table>
			<%end if%>
		    <br>
			<%if encu_ncorr<>"" then%>
			<form name="edicion">
			<%'univ_ncorr=conectar.consultaUno("Select univ_ncorr from universos where encu_ncorr='"&encu_ncorr&"' and pers_ncorr_encuestada='"&pers_ncorr&"'")
			'contestada=conectar.consultaUno("Select Count(*) from resultados_encuestas where univ_ncorr='"&univ_ncorr&"'")
			'response.Write("universo "&univ_ncorr&" Contestada "&contestada)
			%>
			
			<input name="encu_ncorr" type="hidden" value="<%=encu_ncorr%>">
			<input name="univ_ncorr" type="hidden" value="<%=univ_ncorr%>">
			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
              <tr> 
                <td width="1%"><img src="img/m3_1.gif" width="8" height="8"></td>
                <td width="98%"><img src="img/m3_2.gif" width="100%" height="8"></td>
                <td width="1%"><img src="img/m3_3.gif" width="6" height="8"></td>
              </tr>
              <tr> 
                <td width="5" background="img/m3_4.gif">&nbsp;</td>
                <td bgcolor="#FFFFFF"><div align="center">
                        <div align="center"> 
                        <%pagina.DibujarTituloPagina%>
                      </div>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td colspan="3"><strong>INSTRUCCIONES:</strong>Estimado Alumno (a):</td>
						</tr>
						<tr>  
						  <td colspan="3"><%=instruccion%></td>
						</tr>
						<tr>  
						  <td colspan="3" height="21"></td>
						</tr> 
						<%if cantid >"0" then
						  while escala.siguiente
								abrev = escala.obtenervalor("resp_tabrev")
								texto= escala.obtenervalor("resp_tdesc")						
						%> 
						<tr>  
						  <td width="3%"><div align="left"><strong><%=abrev%></strong></div></td>
						  <td width="3%"><strong><center>:</center></strong></td>
						  <td width="94%"><div align="left"><%=texto%></div></td>
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
                    <BR>
                  </div></td>
                <td background="img/m3_5.gif">&nbsp;</td>
              </tr>
              <tr> 
                <td height="8"><img src="img/m3_6.gif" width="8" height="8"></td>
                <td><img src="img/m3_7.gif" width="100%" height="7"></td>
                <td><img src="img/m3_8.gif" width="6" height="7"></td>
              </tr>
            </table>
            <BR>
			<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
              <tr> 
                <td width="1%"><img src="img/m3_1.gif" width="8" height="8"></td>
                <td width="98%"><img src="img/m3_2.gif" width="100%" height="8"></td>
                <td width="1%"><img src="img/m3_3.gif" width="6" height="8"></td>
              </tr>
              <tr> 
                <td width="5" background="img/m3_4.gif">&nbsp;</td>
                <td bgcolor="#FFFFFF"><div align="center">
                      <BR>
                      <table width="100%"  border="0" align="center">
                       <%if cantid_criterios >"0" then
					        contador=1
						  	while criterios.siguiente
									ncorr = criterios.obtenervalor("crit_ncorr")
									'response.Write("ncorr= "&ncorr&" ")
									titulo= criterios.obtenervalor("crit_tdesc")						
							%>  
							<tr> 
                          		<td width="70%"><strong><%=titulo%></strong></td>
						  		
						  		<%if cantid >"0" then
						  			escala.Primero
						  			while escala.siguiente
										abrev = escala.obtenervalor("resp_tabrev")%>
										<td width="40"><strong><center>
						  				<%response.Write(abrev)		
										%></center></strong>
										</td>
									<%wend
								end if%>
							<td width="*">&nbsp;</td>	
							</tr>
							<%
							set preguntas= new cformulario
							preguntas.carga_parametros "tabla_vacia.xml","tabla"
							preguntas.inicializar conectar
							Query_preguntas = "select  preg_ncorr,preg_ccod,preg_tdesc,preg_norden from preguntas where cast(crit_ncorr as varchar)='"&ncorr&"' order by preg_norden"
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
                          				<td width="70%"><%=contador&".-"&pregunta%></td>
						  
						  				<%if cantid >"0" then
						  					escala.Primero
						  					while escala.siguiente%>
											 <td width="40"><center>
											   <%if contestada <> 0 then
											     'response.Write("contestada "&contestada)
												 esca=""'conectar.consultaUno("Select resp_ncorr from resultados_encuestas where univ_ncorr='"&univ_ncorr&"' and preg_ncorr='"&preg_ncorr&"'")  
												   if esca<>"" then	
														if cInt(esca)=cInt(escala.obtenervalor("resp_ncorr")) then%>
												 			<input type="radio" name="<%=preg_ncorr%>" value="<%=escala.obtenervalor("resp_ncorr")%>" checked>
												 		<%else%>
															<input type="radio" name="<%=preg_ncorr%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
												 		<%end if
												   end if%>
											   <%else%>
						  							<input type="radio" name="<%=preg_ncorr%>" value="<%=escala.obtenervalor("resp_ncorr")%>">
						  					  <%end if%>
											  </center></td>
											<%wend
									    end if%>
										<td width="*">&nbsp;</td>	
										</tr>
									<%contador=contador+1 
									wend
								end if
								Query_preguntas=""%>
								
							<tr>
							<td colspan="2">&nbsp;</td>
							</tr>
							<%wend 
							end if
							%>
						
						
						
                      </table>
                   
					
                    
                    <table width="100%" border="0">
                      <tr> 
                        <td width="3%"><% botonera.dibujaBoton "Volver"  %>
                        </td>
                        <td width="8%">&nbsp;<% if contestada = 0 then
						botonera.dibujaBoton "grabar"
						end if  %> </td>
                        <td width="75%">&nbsp;</td>
                        <td width="14%">&nbsp;</td>
                      </tr>
                    </table>
					
                    <BR>
                  </div></td>
                <td background="img/m3_5.gif">&nbsp;</td>
              </tr>
              <tr> 
                <td height="8"><img src="img/m3_6.gif" width="8" height="8"></td>
                <td><img src="img/m3_7.gif" width="100%" height="7"></td>
                <td><img src="img/m3_8.gif" width="6" height="7"></td>
              </tr>
            </table>
			</form>
			<%end if%>
			<br></td>
          <td background="img/m2_7.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td><img src="img/m2_8.gif" width="6" height="6"></td>
          <td><img src="img/m2_9.gif" width="100%" height="6"></td>
          <td><img src="img/m2_10.gif" width="6" height="6"></td>
        </tr>
      </table>      
      <br>      
    </td>
  </tr>
</table>
</body>
</html>
