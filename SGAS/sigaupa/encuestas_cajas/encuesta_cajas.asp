<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

v_pers_ncorr=request.QueryString("cod_encuesta")

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_rr_pp.xml", "botonera"

if v_pers_ncorr="" then
	valor="disabled"
	mensaje="<div class='MsgOk'>Usuario no autorizado para realizar encuesta, gracias por su opinión.</div>"
	v_pers_ncorr=0
else
	sql_existe_cajero="select count(*) from cajeros where pers_ncorr="&v_pers_ncorr
	v_existe=conexion.ConsultaUno(sql_existe_cajero)
	if v_existe=0 then
		valor="disabled"
		mensaje="<div class='MsgOk'>Usuario NO registrado como cajero, contacte a personal de informatica.</div>"
	else
		cajero_encuesta=conexion.ConsultaUno("select protic.obtener_nombre_completo("&v_pers_ncorr&",'n') as nombre_cajero")
		cajero_encuesta="<b>Bienvenido:</b> <font color='#3366FF'>"&cajero_encuesta&"</font>"
	end if
end if


q_pers_nrut=conexion.ConsultaUno("select pers_nrut from personas where pers_ncorr="&v_pers_ncorr)
'q_pers_nrut=negocio.obtenerUsuario
'response.Write(q_pers_nrut)
'response.End()
set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "encuesta_rr_pp.xml", "encuesta"
f_encuesta.Inicializar conexion

consulta = " select * from encuesta_cajas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'" 
		   
		   

'response.Write("<pre>"&consulta&"</pre>")
f_encuesta.Consultar consulta
f_encuesta.Siguiente

if f_encuesta.nrofilas >0 then
	valor="disabled"
	mensaje="<div class='MsgOk'>Usted ya ha realizado esta encuesta satisfactoriamente, gracias por su opinion.</div>"
end if



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Encuesta de Satisfación</title>
<style type="text/css">
<!--
body {
	background-color: #dae4fa;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }

/* MENSAJES  DE DIALOGO */
.MsgError{
        font-size : 14px;
        width : 350px;
        border : 3px solid Red;
        text-align : center;
        background: Yellow;
}
.MsgOk{
        font-size : 14px;
        width : 350px;
        border : 3px solid #778899;
        text-align : center;
        background: #F2FFFF;
}
/* FIN MENSAJES  DE DIALOGO */
-->
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function ValidarMarcados(){



  var cantidad;
  var elemento;
  var contestada;
  var i,cont; 

  cantidad=11;
  	for(cont=1;cont<=cantidad;cont++){
		contestada=0;	
		for(i=0;i<=3;i++){
			elemento=eval("document.edicion.pregunta_"+cont+"["+i+"]");
			//alert(eval("document.edicion.pregunta_"+cont+"["+i+"]"));
			//alert(elemento.checked);alert(elemento.name);
			if(elemento.checked){
				contestada++;
			}
		}
	//	alert("contador: "+cont+ "contestada: "+contestada);
		if(contestada==0){
		 	alert("Debes selecionar una opcion en la pregunta "+cont+".");
			return false;
		}
		
  	}
	if(!document.edicion.pregunta_12.value){
		alert("Debes escribir una descripcion para la pregunta 12");
		return false;
	}
	//alert("contador: "+cont+ "contestada: "+contestada);
	return true;
 
}



</script>
</head>

<body>
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<p align="center"><span class="Estilo34"> </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion" onSubmit="return ValidarMarcados();" action="encuesta_cajas_proc.asp" method="post">
<input type="hidden" name="encu[0][pers_nrut]" value="<%=q_pers_nrut%>">



<table width="700" border="0" cellpadding="0" cellspacing="0">

<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="763" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td width="723" align="left">
			
			    <% if contestada <> "S" then %>
			<center>
			  <p align="center"><font size="+1"><strong><u>Encuesta de satisfacci&oacute;n (nuevo sistema de contrataci&oacute;n)</u></strong></font></p>
			</center>
			 <center><%=mensaje%></center>
			 <div align="left"><%=cajero_encuesta%></div>
			  <br />
 
 			  
							<hr align="left" width="100%" size="1" noshade="noshade" />
							<p class="Estilo42">En el siguiente cuadro usted encontrará una serie de criterios para evaluar el impacto del nuevo sistema de contratacion generado por el departamento de informatica en el marco de la implemetacion de mejoras para los procesos de admision 2009.</p>
							<p class="Estilo42"> <strong>Agradeceremos asigne un valor de acuerdo a su experiencia a cada una de las siguientes aseveraciones asignado 1 al menor valor(desacuerdo) y 4 al maximo valor(acuerdo).</strong> </p>
			<table width="100%" border="1" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
				   <tr>
					
					<td width="79%" align="center" valign="top" bgcolor="#FFFFFF"class="Estilo31"><strong><font size="2" color="#000000">ASPECTOS A EVALUAR.</font></strong></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#FFFFFF" class="Estilo31"><strong><font size="2" color="#000000">1</font></strong></td>
					<td width="3%" align="center" valign="top" bgcolor="#FFFFFF" class="Estilo31"><strong><font size="2" color="#000000">2</font></strong></td>
					<td width="3%" align="center" valign="top" bgcolor="#FFFFFF" class="Estilo31"><strong><font size="2" color="#000000">3</font></strong></td>
					<td width="3%" align="center" valign="top" bgcolor="#FFFFFF" class="Estilo31"><strong><font size="2" color="#000000">4</font></strong></td>
					</tr>
				 
				 <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31"><font size="2" color="#000000"><strong>1. </strong>&iquest;El sistema se caracterizo por ser m&aacute;s r&aacute;pido  respecto del a&ntilde;o pasado al realizar las transacciones solicitadas?</font></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input type="radio" name="pregunta_1"  value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input type="radio" name="pregunta_1"  value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top"  bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input type="radio" name="pregunta_1"  value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top"  bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input type="radio" name="pregunta_1"  value="4" <%=valor%> />
					</p></td>
				</tr>
			 	<tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF"class="Estilo31"><font size="2" color="#000000"><strong>2. </strong></font>&iquest;El sistema no reportaba errores sin control?</td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_2" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_2" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_2" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_2" type="radio" value="4" <%=valor%> />
					</p></td>
				</tr>
				<tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF"class="Estilo31"><font size="2" color="#000000"><strong>3. </strong></font>&iquest;El sistema no se ca&iacute;a repentinamente?</td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_3" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_3" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_3" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_3" type="radio" value="4" <%=valor%> />
					</p></td>
				</tr>
				<tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF"class="Estilo31"><font size="2" color="#000000"><strong>4. </strong></font>&iquest;El sistema no sufr&iacute;a detenciones inesperadas?</td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_4" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_4" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_4" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_4" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>				  				  						
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF"class="Estilo31"><font size="2" color="#000000"><strong>5. </strong></font>&iquest;Los procesos y pantallas eran intuitivos para  realizar acciones no mec&aacute;nicas del proceso de contrataci&oacute;n, por ejemplo  (modificar letras despu&eacute;s de haberlas generado, aplicar descuentos por cero  pesos, etc...)?</td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_5" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_5" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_5" type="radio" value="3"  <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_5" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31"><font size="2" color="#000000"><strong>6. </strong>&iquest;El comportamiento del sistema en &eacute;pocas de cargas cr&iacute;ticas  sufr&iacute;a demoras?</font></td>
				  	<td width="3%" align="center" valign="top"bgcolor="#CCCCCC"  class="Estilo31"><p align="center">
						<input name="pregunta_6" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_6" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_6" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_6" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31"><font size="2" color="#000000"><strong>7.</strong> &iquest;Al tener todos sus procesos englobados en un solo flujo  (simulaci&oacute;n, activaci&oacute;n, seguro escolar), el sistema nuevo facilitaba la labor de  caja?</font></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_7" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_7" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_7" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_7" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31"><font size="2" color="#000000"><strong> 8. </strong></font>&iquest;El sistema tenia un buen manejo de errores y control de  validaciones en todas sus etapas?<font size="2" color="#000000">&nbsp;  </font></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_8" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_8" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_8" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_8" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31"><font size="2" color="#000000"><strong>9. </strong>&iquest;El sistema era de f&aacute;cil comprensi&oacute;n en cada uno de  los pasos de la simulaci&oacute;n? </font></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_9" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_9" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_9" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_9" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31" ><font size="2" color="#000000"><strong>10. </strong>&iquest;Superaba       la velocidad del SGA en los procesos cotidianos de contrataci&oacute;n?</font></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_10" type="radio" value="1" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_10" type="radio" value="2" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_10" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_10" type="radio" value="4" <%=valor%> />
					</p></td>
					  </tr>
				  <tr>
				 <td width="79%" align="left" valign="top" bgcolor="FFFFFF" class="Estilo31"><font size="2" color="#000000"><strong>11. </strong></font>&iquest;Los errores reportados a inform&aacute;tica fueron  corregidos en un plazo menor a 24 horas?<font size="2" color="#000000">&nbsp;  </font></td>
				  	<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_11" type="radio" value="1" <%=valor%>  />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_11" type="radio" value="2" <%=valor%>  />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_11" type="radio" value="3" <%=valor%> />
					</p></td>
						<td width="3%" align="center" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="pregunta_11" type="radio" value="4" <%=valor%>  />
					</p></td>
					  </tr>
				</table>
			  <br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><br />
				 </p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" >
				  <tr>
				  	<td width="100%" align="left" valign="top" class="Estilo31" ><p>Escriba un breve comentario del sistema en general,  sus pro y sus contras, como tambi&eacute;n sus posibles mejoras que usted considera  utilies.</p></td>
					
				  </tr>
				  <tr><td width="88%" align="center" valign="top" class="Estilo31" ><textarea cols="80" rows="5" name="pregunta_12" <%=valor%> ></textarea></td></tr>
			  </table>
				 <br />
			   <br />
				  <table width="100%">
			   <tr>
					<td align="center" valign="top" class="Estilo31"><input type="submit" name="Enviar" value="Enviar" <%=valor%> /></td>
				  </tr>
			  </table>
			  <%end if%>
			  <br /></td>
		  </tr>
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
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br /></p>
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
