<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Gestión mensajeria alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "mensajeria_interna.xml", "botonera"

'---------------------------------------------------------------------------------------------------
usuario = negocio.obtenerUsuario
origen  = conexion.consultaUno("select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&usuario&"'")

pers_ncorr_origen  = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

pers_ncorr_destino = Request.QueryString("pers_ncorr")
carr_ccod = Request.QueryString("carr_ccod")
tipo = Request.QueryString("tipo")
secc_ccod = Request.QueryString("secc_ccod")
sms = Request.QueryString("sms")
mepe_ncorr = Request.QueryString("mepe_ncorr")

if tipo = "1" then
	destino  = conexion.consultaUno("select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
else
	destino = conexion.consultaUno("select 'Todos los alumnos y docentes de '+protic.initCap(asig_tdesc)+' '+protic.initCap(secc_tdesc) from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar)='"&secc_ccod&"'")
end if

periodo = negocio.obtenerPeriodoAcademico("Planificacion")
respuesta = request.QueryString("respuesta")
email_destino = conexion.consultaUno("select lower(email_nuevo) from cuentas_email_upa where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
carrera  = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
fecha_vencimiento = conexion.consultaUno("select protic.trunc(getdate()+10) as fecha_vencimiento")

if mepe_ncorr <> "" then
     c_update = "update mensajes_entre_personas set estado='Leído' where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
	 conexion.ejecutaS c_update

	 consulta = " select mepe_ncorr,pers_ncorr_origen,pers_ncorr_destino,fecha_emision,fecha_vencimiento, " & vbCrLf &_
				" 'Re: '+ ltrim(rtrim(titulo)) as titulo,'--->' + ltrim(rtrim(contenido)) as contenido, " & vbCrLf &_
				" tipo_origen,audi_tusuario,audi_fmodificacion,estado  " & vbCrLf &_
    			" from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
	 pers_ncorr_origen = conexion.consultaUno("select pers_ncorr_destino from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
	 origen = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_origen&"'")
	 pers_ncorr_destino = conexion.consultaUno("select pers_ncorr_origen from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
	 destino = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
     titulo  = conexion.consultaUno("select ltrim(rtrim(titulo)) from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
	 contenido = conexion.consultaUno("select ltrim(rtrim(contenido)) from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
	 fecha_vencimiento = conexion.consultaUno("select protic.trunc(fecha_vencimiento) from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
	 fecha_emision = conexion.consultaUno("select fecha_emision from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
end if 'modificar

'end if
q_pers_nrut = conexion.consultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")	
else
    nombre_foto = ""
end if
'response.Write(nombre_foto)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Mensajería interna</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cerrar()
{
opener.location.reload();
close();
}

contenido_textarea = ""; 
var sms = '<%=sms%>';
if (sms == 'si' )
   { num_caracteres_permitidos = 160; }
else
   { num_caracteres_permitidos = 1000; }	

function valida_longitud()
{ 
   num_caracteres = document.forms[0].contenido.value.length; 

   if (num_caracteres > num_caracteres_permitidos)
   { 
      document.forms[0].contenido.value = contenido_textarea; 
   }
   else
   { 
      contenido_textarea = document.forms[0].contenido.value; 
   } 

   if (num_caracteres >= num_caracteres_permitidos)
   { 
      document.forms[0].caracteres.style.color="#ff0000"; 
   }
   else{ 
      document.forms[0].caracteres.style.color="#000000"; 
   } 
   cuenta(); 
} 
function cuenta(){ 
   document.forms[0].caracteres.value= num_caracteres_permitidos - document.forms[0].contenido.value.length; 
} 


</script>

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
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="550">
	<tr>
		<td width="100%" align="center" bgcolor="#EAEAEA">
		<br>
		<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
			<tr>
			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
		  </tr>
		  <tr>
			<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
			<td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td><%pagina.DibujarLenguetas Array("Gestor de mensajes"), 1 %></td>
			  </tr>
			  <tr>
				<td height="2" background="../imagenes/top_r3_c2.gif"></td>
			  </tr>
			  <tr>
				<td>
					<form name="edicion">
						<input type="hidden" name="tipo" value="<%=tipo%>">
						<input type="hidden" name="email_destino" value="<%=email_destino%>">
						<input type="hidden" name="pers_ncorr_origen" value="<%=pers_ncorr_origen%>">
						<input type="hidden" name="pers_ncorr_destino" value="<%=pers_ncorr_destino%>">
						<input type="hidden" name="carrera" value="<%=carrera%>">
						<input type="hidden" name="seccion" value="<%=secc_ccod%>">
					<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
						<td>
						     <table width="100%" border="0">
								<%if mepe_ncorr <> "" then%>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Recibido</strong></font></td>
									<td><strong>:</strong></td>
									<td><%=fecha_emision%></td>
								</tr>
								<%end if%>
								<%if nombre_foto <> "" then%>
								<tr valign="top">
									<td colspan="3" align="left">
										<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td width="80%" align="left">
												<table width="100%" cellpadding="0" cellspacing="0">
												<tr valign="top"> 
													<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>De</strong></font></td>
													<td><strong>:</strong></td>
													<td><%=origen%><input type="hidden" name="m[0][pers_ncorr_origen]" value="<%=pers_ncorr_origen%>"> </td>
												</tr>
												<tr valign="top"> 
													<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Para</strong></font></td>
													<td><strong>:</strong></td>
													<td><%=destino%>
														<input type="hidden" name="m[0][pers_ncorr_destino]" value="<%=pers_ncorr_destino%>"> 
													</td>
												</tr>
												</table>											
											</td>
											<td width="20%" align="center">
												<img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
											</td>
										</tr>
										</table>
									</td>
								</tr>
								<%else%>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>De</strong></font></td>
									<td><strong>:</strong></td>
									<td><%=origen%><input type="hidden" name="m[0][pers_ncorr_origen]" value="<%=pers_ncorr_origen%>"> </td>
								</tr>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Para</strong></font></td>
									<td><strong>:</strong></td>
								    <td><%=destino%>
                                        <input type="hidden" name="m[0][pers_ncorr_destino]" value="<%=pers_ncorr_destino%>"> 
                                    </td>
								</tr>
								<%end if%>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asunto</strong></font></td>
									<td><strong>:</strong></td>
									<td><input type='text'  name='titulo' value='<%=titulo%>' size='50'  maxlength='50'  id='TO-N' ></td>
								</tr>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Contenido</strong></font></td>
									<td><strong>:</strong></td>
									<td><textarea  cols='60'  rows='10'  id='TO-N' name='contenido' onKeyDown="valida_longitud()" onKeyUp="valida_longitud()"><%=contenido%></textarea><input type="text" name="caracteres" size="4"></td>
								</tr>
								<tr> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Expiración</strong></font></td>
									<td><strong>:</strong></td>
									<td><input type='text'  name='fecha_vencimiento' value='<%=fecha_vencimiento%>' size=''  maxlength=''  id='FE-N' > (dd/mm/aaaa) </td>
								</tr>
								<tr> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Dejar copia</strong></font></td>
									<td><strong>:</strong></td>
									<td><input type='CHECKBOX' name='mandar_copia' value='1'></td>
								</tr>
								<tr>
									<td colspan="3" align="center" bgcolor="#CCFFCC"><font size="2" face="Georgia, Times New Roman, Times, serif"><strong>Enviar copia a email&nbsp;</strong></font><input type="checkbox" name="copia_email" value="1"></td>
								</tr>
							  </table>
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
				<td width="38%" height="20"><div align="center">
				  <table width="90%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td><div align="center"><%if mepe_ncorr = "" then 
					                                botonera.dibujaboton "enviar"
											    end if%></div>
					  </td>
					  <td><div align="center"><%botonera.dibujaboton "cerrar"%></div></td>
					  <td><div align="center">&nbsp;</div>
					  </td>
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
		</td>
	</tr>
	<tr>
		
      <td width="100%" align="center">&nbsp; </td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>