<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
  q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
  usuario = q_pers_nrut
 
 nombre_alumno = conexion.consultaUno("Select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno) from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
 pers_ncorr    = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")

 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "mensajes.xml", "botonera"
 
 
 
set f_mensajes = new CFormulario
f_mensajes.Carga_Parametros "mensajes.xml", "mensajes"
f_mensajes.Inicializar conexion

 c_mensajes = " select mepe_ncorr, protic.trunc(fecha_emision) as fecha, " & vbCrLf &_
			  "	pers_tnombre + ' ' + pers_tape_paterno as de, tipo_origen," & vbCrLf &_
			  "	titulo, case when pers_ncorr_origen = pers_ncorr_destino then 'Auto Mensaje' else (case tipo_origen when 1 then 'Compañero' else 'Profesor' end) end as origen, " & vbCrLf &_
			  "	fecha_emision, b.pers_ncorr, " & vbCrLf &_
			  " case isnull(estado,'Sin leer') when 'Sin leer' then '<img src=""imagenes/sin_leer.jpg"" width=""17"" height=""15"" border=""0"" alt=""Sin Leer"">' " & vbCrLf &_
              " else '<img src=""imagenes/leidos.jpg"" width=""17"" height=""15"" border=""0"" alt=""Leídos"">' end as foto " & vbCrLf &_
			  "	from mensajes_entre_personas a, personas b " & vbCrLf &_
			  "	where a.pers_ncorr_origen = b.pers_ncorr " & vbCrLf &_
			  "	and convert(datetime,protic.trunc(fecha_vencimiento),103) >= convert(datetime,protic.trunc(getDate()),103) " & vbCrLf &_
			  "	and cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"'  and isnull(estado,'Activo') <> 'Eliminado' " & vbCrLf &_
			  "	order by fecha_emision desc"
 f_mensajes.Consultar c_mensajes

total = f_mensajes.nroFilas
'response.Write(total)


  c_es_profesor = " Select count(*) from bloques_profesores a, bloques_horarios b, secciones c "&_
                  " where a.bloq_ccod=b.bloq_ccod and b.secc_ccod=c.secc_ccod and c.peri_ccod=214 "&_
				  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='21' "
  es_profesor = conexion.consultaUno(c_es_profesor)

  c_es_alumno = " Select count(*) from alumnos a, ofertas_academicas b, especialidades c"&_
                " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
				" and a.emat_ccod <> 9 and b.peri_ccod=214 and c.carr_ccod='21' "&_
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"
  es_alumno = conexion.consultaUno(c_es_alumno)
  
  c_es_administrativo = " Select count(*) from personas where pers_nrut in (9498228,7013653,8099825) "&_
                        " and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
  es_administrativo = conexion.consultaUno(c_es_administrativo)  
  
  bloqueo = true
  total_help = 0
  if es_alumno = "0" and es_profesor="0" and es_administrativo="0" then
  	bloqueo = false
  else
  	total_help = 1
	total = total + 1	
  end if
  
  

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

<script language="JavaScript1.2">

function mensaje_companero(formulario)
{
	 direccion="editar_mensaje.asp?pers_ncorr=" + "<%=pers_ncorr%>" + "&tipo=1";
     resultado=window.open(direccion, "ventana1","width=600,height=440,scrollbars=yes, left=0, top=0");
}
function mensaje_profesor(formulario)
{
	 direccion="editar_mensaje.asp?pers_ncorr=" + "<%=pers_ncorr%>" + "&tipo=2";
     resultado=window.open(direccion, "ventana1","width=600,height=440,scrollbars=yes, left=0, top=0");
}

function eliminar_(formulario)
{
	if (vcheck_eliminar(formulario)!=0)
	{
		formulario.method="post";
		formulario.target="_self"
		formulario.action = 'mensajes_eliminar_proc.asp'
		formulario.submit();
	}
	else 
	{
			alert('No ha seleccionado ningún mensaje a eliminar');
	}
}

function vcheck_eliminar(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		//alert(formulario.elements[i].name);
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("mepe_ncorr","em");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c==1){
		valor=1;
	}
	else {
		if (c==0){
			valor=0;
		}
		else{
			valor=2;
		}
	}
return(valor);	
}	

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa función de mensajería implementada para pacífico online contempla el envío de mensajes hacia compañeros y docentes pertenecientes a los cursos que el alumno tenga durante el año.\nEstos mensajes sólo admiten texto, pero entregan un medio fácil de comunicación entre alumnos y profesores.\n\n\n" +
	       	  "ENVIAR A COMPAÑERO: A través de este botón accedes a una nueva ventana donde podrás crear un mensaje para el compañero que elijas, este mensaje llegará al momento y se mantendrá disponible mientras dure la fecha de expiración o bien el destinatario no lo borre.\n"+
		      "ENVIAR A PROFESOR : A través de este botón accedes a una nueva ventana donde podrás crear un mensaje para el profesor que elijas, este mensaje se mantendrá activo mientras no se cumpla la fecha de caducidad o bien el profesor no lo borre.\n"+
		      "ELIMINAR          : Este botón eliminará de tu bandeja todos aquellos mensajes que tengas seleccionados.\n\n\nPara ver el contenido de un mensaje del listado debes hacer clic sobre el, también podrás responderlo dando clic en el botón correspondiente...";
		   
		   
	alert(mensaje);
}
/*
Shock Wave Text script- By ejl@worldmailer.com
Submitted to and featured on Dynamic Drive (www.dynamicdrive.com)
For full source code, usage terms, and 100's more DHTML scripts, visit http://dynamicdrive.com
*/

var size = 20;
var speed_between_messages=3000  //in miliseconds


var tekst = new Array()
{
tekst[0] = "CEE  presenta...";
tekst[1] = "El Nuevo CV digital UPA";
tekst[2] ="Te ayudará en tus primeras búsquedas laborales ";
tekst[3] =  "y a incorporarte en nuestra base de datos de la Universidad";
}
var klaar = 0;
var s = 0;
var veran =0;
var tel = 0;
function bereken(i,Lengte)
{
return (size*Math.abs( Math.sin(i/(Lengte/3.14))) );
}

function motor(p)
{
var output = "";
for(w = 0;w < tekst[s].length - klaar+1; w++)
{
q = bereken(w/2 + p,16);
if (q > size - 0.5)
{klaar++;}
if (q < 5)
{tel++;
if (tel > 1)
{
tel = 0;
if (veran == 1)
{
veran = 0;
s++;
if ( s == tekst.length)
{s = 0;}
p = 0;
if (window.loop)
{clearInterval(loop)}
loop = motor();
}
}
}
output += "<font color='yellow' face='Georgia, Times New Roman, Times, serif' style='font-size: "+ q +"pt'>" +tekst[s].substring(w,w+1)+ "</font>";	
}
for(k=w;k<klaar+w;k++)
{ 
output += "<font   color='yellow' face='Georgia, Times New Roman, Times, serif' style='font-size: " + size + "pt'>" +tekst[s].substring(k,k+1)+ "</font>";
}
idee.innerHTML = output;	
}

function startmotor(p){
if (!document.all)
return
var loop = motor(p); 
if (window.time)
{clearInterval(time)}
if (klaar == tekst[s].length)
{
klaar = 0;
veran = 1;
tel = 0;
var time = setTimeout("startmotor(" +(p+1) + ")", speed_between_messages);
}else
{	
var time =setTimeout("startmotor(" +(p+1) + ")", 50);
}

}

function abrir_votacion()
{
	irA("../web_votacion/resultados.asp", "1", 700, 550)
}

</script>
</head>

<body onLoad="startmotor(0)"; leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="730">
	<tr>
		<td width="100%" align="center"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Bienvenido a Pacífico Online.<br><br>
        <div align="justify">Desde acá podrás revisar tus horarios de clase, evaluaciones 
          programadas, calificaciones ingresadas, solicitar certificados o imprimirlos 
          directamente, contestar la evaluación docente, tomar carga, comunicarte 
          con profesores y compañeros, y muchas cosas más.</div></strong></font></td>
	</tr>
	<!--<tr>
		<td width="100%" align="center">
			<table width="95%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
				<tr valign="top">
					<td width="100%" align="left" bgcolor="#e41712">
						<div align="justify">
							<font size="2" face="Georgia, Times New Roman, Times, serif" color="#FFFFFF">
							  <strong>
							  		Estimado alumno:<br>
									Te recordamos que ya se encuentra abierto el proceso de evaluación docente 
									1er semestre 2008, esta opción estará disponible hasta el día 20 de julio y 
									es pre requisito para la inscripción de asignaturas del 2do semestre 2008;
									te invitamos a contestar tus evaluaciones con anticipación.
							  </strong>
							</font>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>-->
	<tr>
		<td width="100%" align="center"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>
           <div align="justify">Te invitamos a navegar por las diversas opciones del menú y sacarle el máximo provecho a tu intranet.
		   </div></strong></font>
		</td>
		
	</tr>   
	<%if bloqueo then%>
	<tr>
		<td width="100%" align="center"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>
           <div align="justify">&nbsp;</div></strong></font>
		</td>
	</tr>	
	<tr>
		<td width="100%" align="center"><font size="3" color="#FFFF66"><strong>Ver Resultados del Concurso...</strong></font><br>
                                           <a href="javascript:abrir_votacion();" title="Seleccionar Afiche"><img width="147" height="55" src="../imagenes/boton_chico_res.jpg" border="0"></a>
		</td>
	</tr>		
   <%end if%>
	<tr>
		<td width="100%" align="center">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
                 <tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="carga_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="185"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Mensajes Recibidos</strong></font></td>
										   <td width="441"><hr></td>
										   <td width="38" height="38">
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=total_help%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=total_help%>].src='imagenes/ayuda1.png';return true ">
												
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
										   
										   </td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
										  <td><div align="center"></div></td>
										</tr>
										<tr>
										  <td><div align="right">P&aacute;ginas :<%f_mensajes.accesopagina%> </div></td>
										</tr>
										<tr>
										  <td><div align="center">
										  </div>
											<div align="center"></div></td>
										</tr>
										<tr>
										  <td><div align="center">
												<%f_mensajes.dibujatabla()%>
										  </div></td>
										</tr>
										<tr>
											<td align="center">
												<table width="50%">
													<tr>
														<td width="33%" align="center"><%'f_botonera.DibujaBoton("mensaje_companero")%></td>
														<td width="34%" align="center"><%'f_botonera.DibujaBoton("mensaje_profesor")%></td>
														<td width="33%" align="center"><%'f_botonera.DibujaBoton("eliminar")%></td>
													</tr>
													<tr valign="middle">
														<td width="33%" align="center">
															<a href="javascript:mensaje_companero(document.edicion);"
																onmouseover="window.status='botón pulsado';document.images[<%=total + 1%>].src='imagenes/ENVIAR_COMPA2.png';return true "
																onmouseout="window.status='';document.images[<%=total + 1%>].src='imagenes/ENVIAR_COMPA1.png';return true ">
																<img src="imagenes/ENVIAR_COMPA1.png" border="0" width="70" height="70" alt="Enviar Mensaje a compañero"> 
															</a>
														</td>
														<td width="34%" align="center">
															<a href="javascript:mensaje_profesor(document.edicion);"
																onmouseover="window.status='botón pulsado';document.images[<%=total + 2%>].src='imagenes/ENVIAR_PROFE2.png';return true "
																onmouseout="window.status='';document.images[<%=total + 2%>].src='imagenes/ENVIAR_PROFE1.png';return true ">
																<img src="imagenes/ENVIAR_PROFE1.png" border="0" width="70" height="70" alt="Enviar Mensaje a profesor"> 
															</a>
														</td>
														<td width="33%" align="center">
															<a href="javascript:_Eliminar(this, document.forms['edicion'], 'eliminar_mensajes_proc.asp', '', 'TRUE');"
																onmouseover="window.status='botón pulsado';document.images[<%=total + 3%>].src='imagenes/Eliminar2.png';return true "
																onmouseout="window.status='';document.images[<%=total + 3%>].src='imagenes/Eliminar1.png';return true ">
																<img src="imagenes/Eliminar1.png" border="0" width="70" height="70" alt="Eliminar mensajes seleccionados"> 
															</a>
														</td>
													</tr>
												</table>
											</td>
										</tr>
								  </table>
                               </td>
							</tr>
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		
		</td>
	</tr>
</table>
 <td width="100%" height="38">
   											    </td>

<div aling="center "ID="idee"></div>
<a><img src="imagenes/logoceechico.png" border="0" width="151" height="299" ></a>
<div ></div>
</center>

</body>
</html>
