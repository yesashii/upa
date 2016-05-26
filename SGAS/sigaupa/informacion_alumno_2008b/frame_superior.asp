<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

q_pers_nrut = negocio.obtenerUsuario
periodo_defecto="228"
consulta_matr = " Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
		        " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1) "&_
		        " and cast(c.peri_ccod as varchar)='"&periodo_defecto&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
matr_ncorr= conexion.consultaUno(consulta_matr)	
carr_ccod = conexion.consultaUno("Select ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")
sede_ccod = conexion.consultaUno("Select ltrim(rtrim(sede_ccod)) from alumnos a, ofertas_Academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
tiene_matricula_anio_2008 = conexion.consultaUno("select count(matr_ncorr)  from alumnos a, postulantes b where a.post_ncorr=b.post_ncorr and peri_ccod=210 and a.pers_ncorr=protic.obtener_pers_ncorr1("&q_pers_nrut&")")

contesto_encuesta=conexion.consultaUno("select count(*) from encuesta_biblioteca a, alumnos b,postulantes c where a.post_ncorr=b.post_ncorr and b.post_ncorr=c.post_ncorr and peri_ccod=214 and b.pers_ncorr=protic.obtener_pers_ncorr1("&q_pers_nrut&")")

ano_ingreso = conexion.consultaUno("select isnull(protic.ano_ingreso_carrera (pers_ncorr,'"&carr_ccod&"'),2010) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")		
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
v_anio_actual	= 	Year(now())
habilitar = "N"
if carr_ccod = "45" then 
	if ano_ingreso <="2005" and v_mes_actual=07 and v_dia_actual = 28 then
		habilitar = "S"
	elseif  ano_ingreso ="2006" and v_mes_actual=07 and v_dia_actual = 29 then
		habilitar = "S"
	elseif  ano_ingreso ="2007" and v_mes_actual=07 and v_dia_actual = 30 then
		habilitar = "S"
	elseif  ano_ingreso ="2008" and v_mes_actual=07 and v_dia_actual = 31 then
		habilitar = "S"
	elseif  ano_ingreso ="2008" and v_mes_actual=08 and v_dia_actual = 01 then
		habilitar = "S"	
	elseif v_mes_actual=08 and (v_dia_actual = 02 or v_dia_actual = 03) then
		habilitar = "S"
	else
		habilitar = "N"
	end if
else
    if sede_ccod <> "4" then
		if v_mes_actual=08 and v_dia_actual >=04 and v_dia_actual <=10  then
			habilitar = "S"
		else
			habilitar = "N"
		end if
	else 'en caso de ser Melipilla
		if v_mes_actual=08 and v_dia_actual >=11 and v_dia_actual <=17  then
			habilitar = "S"
		else
			habilitar = "N"
		end if
	end if	
end if 'publicidad

'habilitar segunda vuelta evaluación docente
if v_mes_actual=08 and v_dia_actual >=11 and v_dia_actual <=22  then
	habilitar_encuesta = "N"
else
	habilitar_encuesta = "N"
end if
autorizacion_carga_2009 = session("autorizacion_carga_2009")
 c_alumno_nuevo="select case count(*) when 0 then 'N' else 'S' end from personas a, alumnos b, ofertas_academicas c"& vbCrLf &_
		  "where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' "& vbCrLf &_
		  "and a.pers_ncorr=b.pers_ncorr and b.emat_ccod = 1 "& vbCrLf &_
		  "and b.ofer_ncorr=c.ofer_ncorr and c.peri_ccod in(select peri_ccod from periodos_academicos where anos_ccod>2010)"& vbCrLf &_
          "and c.post_bnuevo='S'"
alumno_nuevo=conexion.consultaUno(c_alumno_nuevo)


c_alumno_nuevo2="select case count(*) when 0 then 'N' else 'S' end from personas a, alumnos b, ofertas_academicas c"& vbCrLf &_
		  "where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' "& vbCrLf &_
		  "and a.pers_ncorr=b.pers_ncorr and b.emat_ccod = 1 "& vbCrLf &_
		  "and b.ofer_ncorr=c.ofer_ncorr and c.peri_ccod in(select peri_ccod from periodos_academicos where anos_ccod>2009)"& vbCrLf &_
          "and c.post_bnuevo='S'"
alumno_nuevo2=conexion.consultaUno(c_alumno_nuevo)
es_fecha_mis_datos=conexion.consultaUno("select case when convert(datetime,getdate(),103) < convert(datetime,'01/10/2010',103)  then 'S' else 'N' end ")





fecha=conexion.consultaUno("select protic.trunc(getdate())")
fecha2="20/03/2011"'response.Write(fecha)





pasa_fecha2 = conexion.consultaUno("select case when convert(datetime,protic.trunc(getDate()),103) < convert(datetime,'12/08/2009',103) then 'S' else 'N' end")
 if pasa_fecha2 = "N" then 
 	activar_ocultos2 = false
 else
 	activar_ocultos2 = true
 end if	
 
 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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
background-color:red;
color: white;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#84a6d3" background="imagenes/fondo.jpg">
<center>
<table align="center" width="1000">
	<tr valign="top">
		<td align="100%">
			<table cellpadding="0" cellspacing="0" align="left" border="0">
				<tr>
					<td width="388" height="73"><img width="388" height="73" src="imagenes/banner1.jpg"></td>
					<td width="612" height="73"><img width="612" height="73" src="imagenes/banner2.jpg"></td>
				</tr>
				<tr valign="top">
					<td width="388" height="50" bgcolor="#4b73a6"><img width="388" height="49" src="imagenes/banner3.jpg"></td>
					<td width="612" height="50" bgcolor="#4b73a6">
					  <table width="100%" height="58" cellpadding="0" cellspacing="0">
					  	<tr valign="middle">
							<td align="left" width="100%">
							<div id="menu"><div class="barraMenu">
								<a class="botonMenu" href="ficha_alumno.asp" target="central">Datos Personales</a>
								<a class="botonMenu" href="cuenta_corriente_alumno.asp" target="central">Cta. Corriente</a>
								<a class="botonMenu" href="carga_alumno.asp" target="central">Horario</a>
								<a class="botonMenu" href="notas_parciales_alumno.asp" target="central">Calificaciones</a>
								<a class="botonMenu" href="solicitud_reporte_alumno.asp" target="central">Certificados</a>
								<!--<a class="botonMenu" href="cambiar_clave.asp" target="central">Cambiar Clave</a>-->
								<a class="botonMenu" href="curriculum.asp" target="central" >
<script language="JavaScript1.2" type="text/javascript">

var message="* * Arma tu CV  * *"
var neonbasecolor="yellow"
var neontextcolor="orange"
var flashspeed=50  //in milliseconds

///No need to edit below this line/////

var n=0
if (document.all||document.getElementById){
document.write('<font color="'+neonbasecolor+'">')
for (m=0;m<message.length;m++)
document.write('<span id="neonlight'+m+'">'+message.charAt(m)+'</span>')
document.write('</font>')
}
else
document.write(message)

function crossref(number){
var crossobj=document.all? eval("document.all.neonlight"+number) : document.getElementById("neonlight"+number)
return crossobj
}

function neon(){

//Change all letters to base color
if (n==0){
for (m=0;m<message.length;m++)
//eval("document.all.neonlight"+m).style.color=neonbasecolor
crossref(m).style.color=neonbasecolor
}

//cycle through and change individual letters to neon color
crossref(n).style.color=neontextcolor

if (n<message.length-1)
n++
else{
n=0
clearInterval(flashing)
setTimeout("beginneon()",500)
return
}
}

function beginneon(){
if (document.all||document.getElementById)
flashing=setInterval("neon()",flashspeed)
}
beginneon()

function Abrir_hora_sicologo()
{
	window.open('http://admision.upacifico.cl/peticion_horas/www/home.php?usuario_asp=<%=negocio.obtenerUsuario()%>','popup','width=1240,height=768')
}

function Abrir_mis_datos()
{
	window.open('mis_datos.asp','popup','width=1240,height=768')
}

</script></a>
							</div></div>
							</td>
						</tr>
						<tr valign="middle">
							<td width="100%" height="43" align="left">
							<div id="menu"><div class="barraMenu">
								<!--<a class="botonMenu" href="mensajes.asp" target="central">Ev. Docente</a>-->
								<%if activar_ocultos2 then%>
								<a class="botonMenu" href="../informacion_alumno_2008_evaluacion/seleccionar_docente_2008.asp" target="central">Evaluación Docente</a>
								<%end if%>
								<%if autorizacion_carga_2009 then%>
								<a class="botonMenu" href="inicio_toma_carga_2008.asp" target="central">Toma de Ramos</a>
								<%end if%>
								<%if tiene_matricula_anio_2008 > 0 and contesto_encuesta = 0 then%>
									<a class="botonMenu" href="../encuesta_biblioteca/encuesta.asp" target="central">Encuesta Biblioteca</a>
                                <%end if%>				
								<%if alumno_nuevo="S" then%>
								<a class="botonMenu" href="../evalua/test.asp?porta_alumno=N" target="central">Tests  de Kolb</a>
								<%if cdate(fecha) > cdate(fecha2) then%>
								<a class="botonMenu" href="javascript:irA('http://admision.upacifico.cl/encuesta_alumnos/www/portada.php', '1', 1240, 768)" target="central">Encuesta Alumnos Nuevos</a>
								<%end if%>
								<%end if%>
								<a class="botonMenu" href="javascript:irA('http://admision.upacifico.cl/peticion_horas/www/home.php?usuario_asp=<%=negocio.obtenerUsuario()%>', '1', 1240, 768)" target="central">Tomar Hora Sicólogo</a>
								<%if es_fecha_mis_datos="S" then%>
								<a class="botonMenu" href="javascript:irA('mis_datos.asp', '1', 1240, 768)"  target="central">Mis Datos</a>
								<%end if%>
								<a class="botonMenu" href="cerrar_sesion.asp" target="central">Cerrar Sesión</a>
							</div></div>
						  </td>
						</tr>
					  </table>
						
					</td>
				</tr>
			</table>
		
		</td>
	</tr>
</table>
</center>
</body>
</html>
