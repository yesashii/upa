<!-- #include file = "../biblioteca/_conexion.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores


 dia  = request.QueryString("dia")
 mes  = request.QueryString("mes")
 anio = request.QueryString("anio")
 pers_ncorr = request.QueryString("codigo")
 
set f_evaluaciones = new CFormulario
f_evaluaciones.Carga_Parametros "tabla_vacia.xml", "tabla"
f_evaluaciones.Inicializar conexion
consulta =  "  select g.asig_tdesc as asignatura, protic.trunc(e.cali_fevaluacion) as fecha,cali_nponderacion as porcentaje, "& vbCrLf &_	
			"  teva_tdesc as tipo  "& vbCrLf &_	
			"  from alumnos a, ofertas_academicas b, periodos_academicos c, cargas_academicas d,  "& vbCrLf &_	
			"  calificaciones_seccion e, secciones f, asignaturas g, tipos_evaluacion h "& vbCrLf &_	
			"  where a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_	
			"  and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_	
			"  and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&anio&"' "& vbCrLf &_	
			"  and cast(datepart(day,cali_fevaluacion) as varchar)='"&dia&"' and cast(datepart(month,cali_fevaluacion) as varchar)='"&mes&"' "& vbCrLf &_
			"  and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod "& vbCrLf &_	
			"  and d.secc_ccod=f.secc_ccod and f.asig_ccod=g.asig_ccod "& vbCrLf &_	
			"  and e.teva_ccod =h.teva_ccod "& vbCrLf &_	
			"  order by cali_fevaluacion asc "

f_evaluaciones.Consultar consulta 
 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Evaluaciones Programadas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
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
</style>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function cerrar ()
{
	window.close;

}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">

<table align="left" width="250">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="300" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="90%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr><td><font size="3" face="Courier New, Courier, mono" color="#496da6"><strong>Evaluaciones Programadas</strong></font></td></tr>
										<tr><td>&nbsp;</td></tr>
										<%while f_evaluaciones.siguiente%>
										<tr><td align="left"><font size="2" face="Courier New, Courier, mono" color="#e41712"><strong><%=f_evaluaciones.obtenerValor("asignatura")%></strong></font></td></tr>
										<tr><td align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_evaluaciones.obtenerValor("fecha")%></font></td></tr>
										<tr><td align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_evaluaciones.obtenerValor("tipo")%></font></td></tr>
										<tr><td align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6">Porcentaje <%=f_evaluaciones.obtenerValor("porcentaje")%>%</font></td></tr>
										<tr><td align="left"><hr style="border-color:#003366"></td></tr>
										<%wend%>
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
</table>
</body>
</html>

