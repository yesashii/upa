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
botonera.Carga_Parametros "mensajes.xml", "botonera"

'---------------------------------------------------------------------------------------------------
mepe_ncorr = Request.QueryString("mepe_ncorr")
pers_ncorr_origen = Request.QueryString("pers_ncorr")
tipo = Request.QueryString("tipo")
origen  = conexion.consultaUno("select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_origen&"'")
periodo = negocio.obtenerPeriodoAcademico("Planificacion")
respuesta = request.QueryString("respuesta")

set formulario = new CFormulario
if tipo = "1" then
	formulario.Carga_Parametros "mensajes.xml", "edita_mensaje"
else
	formulario.Carga_Parametros "mensajes.xml", "editar_mensaje_seccion"
end if
formulario.Inicializar conexion
destino = ""
if mepe_ncorr <> "" then
     c_update = "update mensajes_entre_personas set estado='Leído' where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
	 conexion.ejecutaS c_update
	 
	 if respuesta <> "1" then
		 consulta = "select * from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
		 pers_ncorr_destino = conexion.consultaUno("select pers_ncorr_destino from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
		 destino = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
     else
		 consulta = " select mepe_ncorr,pers_ncorr_origen,pers_ncorr_destino,fecha_emision,fecha_vencimiento, " & vbCrLf &_
					" 'Re: '+ ltrim(rtrim(titulo)) as titulo,'--->' + ltrim(rtrim(contenido)) as contenido, " & vbCrLf &_
					" tipo_origen,audi_tusuario,audi_fmodificacion,estado  " & vbCrLf &_
					" from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
		 pers_ncorr_origen = conexion.consultaUno("select pers_ncorr_destino from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
		 origen = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_origen&"'")
		 pers_ncorr_destino = conexion.consultaUno("select pers_ncorr_origen from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
		 destino = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
	 end if
else  'modificar
  	 consulta = " select ''"
	 pers_ncorr_destino=""
end if
'response.Write(destino)
formulario.Consultar consulta
if tipo = "1" then
	c_destino = " (select distinct f.pers_ncorr as pers_ncorr_destino,f.pers_tape_paterno+ ' ' +f.pers_tape_materno + ', ' + f.pers_tnombre as nombre " & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, cargas_academicas d, alumnos e, personas f " & vbCrLf &_
					" where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
					" and a.secc_ccod=d.secc_ccod and d.matr_ncorr=e.matr_ncorr  " & vbCrLf &_
					" and e.pers_ncorr=f.pers_ncorr " & vbCrLf &_
					" and cast(a.peri_ccod as varchar)='"&periodo&"' and cast(c.pers_ncorr as varchar)='"&pers_ncorr_origen&"'  and c.tpro_ccod=1 " & vbCrLf &_
				" ) a   "
	titulo = "Enviar mensaje a alumno"			
elseif tipo="2"  then
	c_listados = " select distinct d.sede_ccod,protic.initcap(d.sede_tdesc) as sede_tdesc,e.carr_ccod,protic.initCap(e.carr_tdesc) as carr_tdesc, " & vbCrLf &_
				 " f.jorn_ccod,protic.initCap(f.jorn_tdesc) as jorn_tdesc, " & vbCrLf &_
				 " a.secc_ccod,protic.initCap(ltrim(rtrim(g.asig_tdesc))+ ' :' +a.secc_tdesc) as secc_tdesc   " & vbCrLf &_
				 " from secciones a, bloques_horarios b, bloques_profesores c, sedes d, carreras e, jornadas f, asignaturas g " & vbCrLf &_
				 " where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
				 " and cast(c.pers_ncorr as varchar)='"&pers_ncorr_origen&"' and cast(a.peri_ccod as varchar)='"&periodo&"' and c.tpro_ccod=1 " & vbCrLf &_
				 " and a.sede_ccod=d.sede_ccod and a.carr_ccod=e.carr_ccod " & vbCrLf &_
				 " and a.jorn_ccod = f.jorn_ccod and a.asig_ccod=g.asig_ccod "
				 
	 formulario.inicializaListaDependiente "lBusqueda", c_listados
	 formulario.Siguiente			 
	 titulo = "Crear mensaje a Profesor"
end if
			
'response.Write("<pre>"&c_destino&"</pre>")
formulario.agregaCampoParam "pers_ncorr_destino","destino",c_destino
'formulario.agregaCampoCons "pers_ncorr_destino", pers_ncorr_destino
formulario.Siguiente

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=titulo%></title>
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
<% if tipo = "2" then
   		formulario.generaJS 
   end if%>
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
						<%formulario.DibujaCampo("pers_ncorr")  %>
						<%formulario.DibujaCampo("come_ncorr")  %>
						<input type="hidden" name="tipo" value="<%=tipo%>">
					<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
						<td>
						     <table width="100%" border="0">
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>De</strong></font></td>
									<td><strong>:</strong></td>
									<td><%=origen%><input type="hidden" name="m[0][pers_ncorr_origen]" value="<%=pers_ncorr_origen%>"> </td>
								</tr>
								<%if tipo = "1" or tipo="4"  or tipo="3" then%>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Para</strong></font></td>
									<td><strong>:</strong></td>
									<td><% if destino <> "" then 
									           response.Write(destino) %>
											   <input type="hidden" name="m[0][pers_ncorr_destino]" value="<%=pers_ncorr_destino%>">
										   <%else 
										       formulario.DibujaCampo("pers_ncorr_destino") 
										   end if%></td>
								</tr>
								<%else%>
								<tr valign="top"> 
								    <td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Para</strong></font></td>
									<td colspan="2">
										<table width="100%" cellpadding="0" cellpadding="0" border="1" bordercolor="#666666">
											<tr>
											   <td width="20%"><strong>Sede</strong></td>
											   <td><%formulario.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
											</tr>
											<tr>
											   <td width="20%"><strong>Carrera</strong></td>
											   <td><%formulario.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
											</tr>
											<tr>
											   <td width="20%"><strong>Jornada</strong></td>
											   <td><%formulario.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
											</tr>
											<tr>
											   <td width="20%"><strong>Asignatura</strong></td>
											   <td><%formulario.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
											</tr>
										</table>
									</td>
								</tr>								
								<%end if%>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asunto</strong></font></td>
									<td><strong>:</strong></td>
									<td><%formulario.DibujaCampo("titulo")  %> </td>
								</tr>
								<tr valign="top"> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Contenido</strong></font></td>
									<td><strong>:</strong></td>
									<td><%formulario.DibujaCampo("contenido")  %> </td>
								</tr>
								<tr> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Expiración</strong></font></td>
									<td><strong>:</strong></td>
									<td><%formulario.DibujaCampo("fecha_vencimiento")  %> (dd/mm/aaaa) </td>
								</tr>
								<tr> 
									<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Dejar copia</strong></font></td>
									<td><strong>:</strong></td>
									<td><%formulario.DibujaCampo("mandar_copia")  %></td>
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
					  <td><div align="center"><%if mepe_ncorr = "" or respuesta="1" then
										               botonera.dibujaboton "enviar"
												end if%></div>
					  </td>
					  <td><div align="center"><%botonera.dibujaboton "cerrar"%></div></td>
					  <td><div align="center"><%if mepe_ncorr <> "" and  tipo = "1" then
					                                if clng(pers_ncorr_origen) <> clng(pers_ncorr_destino) and pers_ncorr_destino <> "" and respuesta="" then
					  									botonera.agregaBotonParam "responder","url","editar_mensaje.asp?mepe_ncorr="&mepe_ncorr&"&pers_ncorr="&pers_ncorr_origen&"&tipo="&tipo&"&respuesta=1"
					                                	botonera.dibujaboton "responder"
													end if 
												end if
					                           %>
					      </div>
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