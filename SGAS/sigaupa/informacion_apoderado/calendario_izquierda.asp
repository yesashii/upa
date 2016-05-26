<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_apoderado.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
'conexión a servidor de producción consultas que requieran actualización al minuto
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
 
 set negocio = new CNegocio
 negocio.Inicializa conexion

  nombre_alumno = conexion.consultaUno("Select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno) from personas_postulante where cast(pers_nrut as varchar)='"&session("rut_apoderado")&"'")

  pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&session("rut_usuario")&"'")
  'response.Write("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&usuario&"'")
  tiene_foto = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&session("rut_usuario")&"'")
  'response.Write(tienen_foto)
  'response.End()
  if tiene_foto="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&session("rut_apoderado")&"'")
  else
    nombre_foto = "user.png"
  end if

	nombre_foto="user.png" 
	
v_peri_ccod_pos = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_peri_ccod_18  = negocio.ObtenerPeriodoAcademico("CLASES18")
'response.Write("peri postulacion: "&v_peri_ccod_pos&" <br> Peri Calses18: "&v_peri_ccod_18)

if cint(v_peri_ccod_pos) < cint(v_peri_ccod_18) then
	v_peri_ccod = v_peri_ccod_18
else
	v_peri_ccod =v_peri_ccod_pos
end if
periodo = v_peri_ccod
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumno.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
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
	color: white;
}
        .calFondoCalendario {background-color:#84a6d3}
		.calEncabe {font-family:Arial, Helvetica, sans-serif; font-size:11px; color:white}
		.calFondoEncabe {background-color:#4b73a6}
		.calDias {font-family:Arial, Helvetica, sans-serif; font-size:11px; font-weight:900}
		.calSimbolo {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:500; color:white}
		.calResaltado {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:700}
		.calCeldaResaltado {background-color:lightyellow}
		.calEvaluado {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:700; color:white}
		.calCeldaEvaluado {background-color:#e41712}

a:hover {
	color:#CC6600;
}		
</style>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script>
function ImprimirMorosidad(){
  direccion="../tesorero/imprimir_morosidad.asp?pers_ncorr=<%=pers_ncorr%>";
  window.open(direccion ,"reporte_morosidad","width=790,height=450,left=50,top=20,scrollbars=yes, resizable");

}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="270">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="270" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="90%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="40%">
									<table width="95%" border="1" align="center" bordercolor="#cccccc">
										<tr valign="middle">
											<td><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>"></td>
										</tr>
									</table>
								</td>
								<td width="60%" align="center">
									<table width="100%">
										<tr><td><font size="3" face="Courier New, Courier, mono" color="#496da6"><strong>Bienvenido</strong></font></td></tr>
										<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=nombre_alumno%></font></td></tr>
										<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=Date%></font></td></tr>
									</table>
								</td>
								
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="270" cellpadding="0" cellspacing="0" border="0" bgcolor="#84a6d3" class="horario">
				<tr valign="middle">
			      <td width="100%" align="center">&nbsp;</td>
				</tr>
				<tr><td><li><a href="#" onClick="javascript:ImprimirMorosidad();">Consultar Morosidad</a></li>
						<li><a href="../REPORTESNET/CuentaCorriente.aspx?pers_ncorr=<%=pers_ncorr%>&persona=NO&periodo=<%=periodo%>&filtro=NO&peri_sel=<%=periodo%>" target="new" >Descargar PDF cuenta corriente</a></li>
				</td></tr>				
			</table>
		</td>
	</tr>
</table>
</center>
</body>
</html>