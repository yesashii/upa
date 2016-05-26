<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
matr_ncorr = request.QueryString("matr_ncorr")
if matr_ncorr = "" then
	matr_ncorr="0"
end if

set conexion = new cConexion
set z = new cHorario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

session("sede") = conexion.consultaUno("select top 1 b.sede_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "' ")

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion

consulta = 	"select a.matr_ncorr, cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, " & vbCrLf &_
			"protic.initCap(d.pers_tape_paterno + ' ' + d.pers_tape_materno + ', ' + d.pers_tnombre) as alumno, " & vbCrLf &_
			"protic.initCap(sede_tdesc) as sede, protic.initCap(carr_tdesc) as carrera, protic.initCap(g.peri_tdesc) as periodo,g.peri_ccod " & vbCrLf &_
			"from alumnos a, ofertas_academicas b, especialidades c, personas d, carreras e, sedes f, periodos_academicos g " & vbCrLf &_
			"where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod " & vbCrLf &_
			"and a.pers_ncorr=d.pers_ncorr " & vbCrLf &_
			"and b.sede_ccod=f.sede_ccod and c.carr_ccod=e.carr_ccod  " & vbCrLf &_
			"and b.peri_ccod=g.peri_ccod " & vbCrLf &_
			"and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
			"order by alumno" 
			
'response.Write("<pre>"&consulta&"</pre>")	       
f_alumnos.Consultar consulta
cantidad = f_alumnos.nroFilas


consulta_fecha = " select 'Santiago, '+cast(datepart(day,getdate()) as varchar)+ ' de ' + protic.initcap(mes_tdesc) "&_
				 " + ' de ' + cast(datepart(year,getdate()) as varchar) as fecha"&_
				 " from meses "&_
				 " where mes_ccod = datepart(month,getdate()) "

fecha_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha2 = " select getDate() "

fecha_impresion2 = conexion.consultaUno(consulta_fecha2)

%>
<html>
<head>
<title>Carga Académica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicio.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript1.2" src="tabla.js"></script>
<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<style type="text/css">
<!--
td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 8px;
}
h1 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 16px;
}
-->
</style>
</head>
<body bgcolor="#ffffff">
<%     contador = 0
       while f_alumnos.siguiente
	    contador = contador + 1
		matr_ncorr = f_alumnos.obtenerValor("matr_ncorr")
		sede = f_alumnos.obtenerValor("sede")
		alumno = f_alumnos.obtenerValor("alumno")
		rut_alumno = f_alumnos.obtenerValor("rut")
		semestre = f_alumnos.obtenerValor("periodo")
		carrera = f_alumnos.obtenerValor("carrera")
		
		peri_actual = f_alumnos.obtenerValor("peri_ccod")
		
		set f_consulta = new CFormulario
		f_consulta.Carga_Parametros "consulta.xml", "consulta"
		f_consulta.Inicializar conexion
		
		consulta = 	"select convert(datetime,min(a.bloq_finicio_modulo), 103) as finicio, convert(datetime,max(a.bloq_ftermino_modulo),103) as ftermino " & vbCrLf &_
					"	from bloques_horarios a, secciones b, periodos_academicos c , cargas_Academicas d " & vbCrLf &_
					"	where a.secc_ccod = b.secc_ccod  and  b.peri_ccod = c.peri_ccod" & vbCrLf &_
					"	and d.secc_ccod=b.secc_ccod and cast(d.matr_ncorr as varchar)='" & matr_ncorr & "'" & vbCrLf &_
					"	and cast(c.peri_ccod as varchar) = '"& peri_actual &"' "
		'response.Write("<pre>"&consulta&"</pre>")	       
		f_consulta.Consultar consulta
		f_consulta.Siguiente
	
		finicio = f_consulta.ObtenerValor("finicio")
		ftermino = f_consulta.ObtenerValor("ftermino")
		
		z.inicializa conexion
		z.generaHorario matr_ncorr,finicio,ftermino,"alumno"
%>
 <table width="672" border="0" cellspacing="0" cellpadding="0">
  <TR>
	  <TD align="left">
	  		<table width="672">
				<tr valign="middle">
					<td width="54" height="56" align="right"><div align="right"><img src="imagenes_certificado/logo_upa.jpg" width="52" height="56"></div></td>

					<td width="214" height="56"><div align="left"><img src="imagenes_certificado/membrete_upa.jpg" width="162" height="56"></div></td>
					<td width="404" align="center">&nbsp;
					    
					</td>
				</tr>
			</table>
	  </TD>
  </TR>
  <tr><td align="left" width="672">
  			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="33" height="33" align="right"><img src="imagenes_certificado/izquierda_sup.jpg" width="33" height="33"></td>
					<td width="550"><img src="imagenes_certificado/superior.jpg" width="600" height="33"></td>
					<td width="39" height="33" align="left"><img src="imagenes_certificado/derecha_sup.jpg" width="35" height="33"></td>
				</tr>
				<tr valign="top">
					<td width="33" align="right" background="imagenes_certificado/izquierda_lado.jpg">&nbsp;</td>
				  <td bgcolor="#FFFFFF" width="600">
						<table width="100%" cellpadding="0" cellspacing="0">
						  <tr><td width="100%" align="center"><font size="4" face="Times New Roman, Times, serif"><strong>CARGA SEMESTRAL</strong></font></td></tr>
						  <tr><td width="100%"><font size="2" face="Times New Roman, Times, serif">&nbsp;</font></td></tr>
						  <tr>
						     <td width="95%" align="center">
						  		<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr> 
									<td width="14%" widt="10"><font size="2"><strong>Alumno</strong></font></td>
									<td width="49%"><font size="2">: <%=alumno%></font></td>
									<td width="7%" widt="10"><font size="2"><strong>RUT</strong></font></td>
									<td width="30%"><font size="2">: <%=rut_alumno%></font></td>
								  </tr>
								  <form name="edicion" method="get">
								  <tr> 
									<td><font size="2"><strong>Semestre</strong></font></td>
									<td><font size="2">: <%=semestre%></font></td>
									<td><font size="2"><strong>Sede</strong></font></td>
									<td><font size="2">: <%=sede%></font></td>
								  </tr>
								  </form>
								  <tr>
									<td><font size="2"><strong>Carrera</strong></font></td>
									<td><font size="2">: <%=carrera%></font></td>
									<td><font size="2"><strong>Fecha</strong></font></td>
									<td><font size="2">: <%=fecha_impresion2%></font></td>
								  </tr>
								</table>
								<div align="right" class="noprint">
								<button name="Button" value="Imprimir Horario" onClick="print()" >
								Imprimir
								</button>
								</div>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr> 
									<td><font color="000000" size="1">&quot;Te informamos que esta carga acad&eacute;mica 
									  est&aacute; sujeta a eventuales modificaciones.&quot;</font></td>
								  </tr>
								  <tr> 
									<td>&nbsp;</td>
								  </tr>
								</table>
								<%  
								z.dibuja
								%>
								<br>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
								   <tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
								  <tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
									<tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
									<tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
									<tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
									<tr> 
									<td width="20%" align="center">&nbsp;</td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center">&nbsp;</td>
								  </tr>
								  
								  <tr> 
									<td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif"><strong>____________________________________</strong></font></td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif"><strong>____________________________________</strong></font></td>
								  </tr>
								  <tr> 
									<td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif" size="2"><strong>Encargado Escuela</strong></font></td>
									<td width="60%" align="center">&nbsp;</td>
									<td width="20%" align="center"><font color="#000000" face="Arial, Helvetica, sans-serif" size="2"><strong>Alumno</strong></font></td>
								  </tr>
								</table>
						  	 </td>
						  </tr>
						  <tr valign="bottom"><td width="100%" height="50"><font size="1" face="Times New Roman, Times, serif"><%=fecha_impresion%></font></td></tr>
						</table>
					</td>
					<td width="39" align="left" background="imagenes_certificado/derecha_lado.jpg">&nbsp;</td>
				</tr>
				<tr valign="top">
					<td width="33" height="36" align="right"><img src="imagenes_certificado/izquierda_inf.jpg" width="33" height="36"></td>
					<td width="550" bgcolor="#FFFFFF" height="36"><img width="600" height="36" src="imagenes_certificado/inferior.jpg"></td>
					<td width="39" height="36" align="left"><img src="imagenes_certificado/derecha_inf.jpg" width="35" height="36"></td>
				</tr>
				<TR>
					<TD colspan="3" align="center"><font size="2" face="Times New Roman, Times, serif">Página <%=contador%> de <%=cantidad%></font></TD>
				</TR>
				<TR>
					<TD colspan="3"><hr></TD>
				</TR>
				<TR>
					<TD colspan="3" align="center"><font size="1">Casa Central: Av. Las Condes 11.121 Fono:366 5300 - Sede Providencia: Av. Ricardo Lyon 227 Fono 378 9259</font></TD>
				</TR>
				<TR>
					<TD colspan="3" align="center"><font size="1">Sede Baquedano Av. Ramón Carnicer 65 Fono 634 3393 - Sede Melipilla Andres Bello 0383-A Fono 831 7991</font></TD>
				</TR>
			</table>
      </td>
  </tr>
  </table>
  <%wend%>
</body>
</html>
