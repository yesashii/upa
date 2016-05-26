<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% pers_ncorr =session("pers_ncorr_alumno")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "5.- ANTECEDENTES DE SALUD"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------Datos alumno---
nombre_alumno = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_alumno = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "ant_salud_familiar.xml", "botonera"
'---------------------------------------------------------------------------------------------------

periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr= session("post_ncorr_alumno") 'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")

Sql_parientes = "  Select enfp_ncorr,pp.pers_ncorr, protic.initcap(pp.pers_tnombre)+' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, " & VBCRLF  	& _
			    "  protic.initCap(pa.pare_tdesc) as Parentesco,enfp_ncosto, enfp_tdiagnostico" & VBCRLF  	& _
				"  from postulantes pos join  grupo_familiar gf  " & VBCRLF  	& _
			    "    on pos.post_ncorr = gf.post_ncorr  " & VBCRLF  	& _
			    "  join  personas_postulante pp  " & VBCRLF  	& _
			    "    on gf.pers_ncorr = pp.pers_ncorr  " & VBCRLF  	& _
				"  join enfermedades_persona pr "&vbcrlf &_
				"	 on pp.pers_ncorr = pr.pers_ncorr " &vbcrlf &_  
			    " join parentescos pa " & VBCRLF  	& _
			    "    on gf.pare_ccod = pa.pare_ccod" & VBCRLF  	& _
				" Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
				" and isnull(grup_nindependiente,0)= 0 " & VBCRLF  	& _
				" and gf.pare_ccod not in (0) " & VBCRLF  	& _
				" union all " & VBCRLF  	& _
				" select enfp_ncorr,pp.pers_ncorr, protic.initcap(pp.pers_tnombre) +' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, " & VBCRLF  	& _
				" 'Alumno' as Parentesco, enfp_ncosto, enfp_tdiagnostico" & VBCRLF  	& _
			    " from personas_postulante pp join enfermedades_persona pr "&vbcrlf &_
				"	 on pp.pers_ncorr = pr.pers_ncorr " &vbcrlf &_
			    " where cast(pp.pers_ncorr as varchar)='"&pers_ncorr&"'"

'response.Write("<pre>"&Sql_parientes&"</pre>")
set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "ant_salud_familiar.xml", "grilla_enfermos"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.Consultar Sql_parientes

lenguetas_postulacion = Array(Array("Datos Personales", "datos_alumno.asp"), Array("Ant. Grupo Familiar", "grupo_familiar.asp"), Array("Ingresos Grupo Familiar", "ingresos_grupo_familiar.asp"), Array("Propiedades", "propiedades_grupo_familiar.asp"), Array("Ant. de Salud", "ant_salud_familiar.asp"))
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
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function abrir(){
		
		direccion = "agregar_enfermo.asp";
		resultado=window.open(direccion, "salud","scrollbars=yes,resizable,width=550,height=330");
}
</script>

<style type="text/css">
<!--
.style1 {color: #FF0000}
.Estilo2 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); " >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%				
				pagina.DibujarLenguetas lenguetas_postulacion, 5
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  	<td><div align="center"><br><br>
                      <%pagina.DibujarTitulo "5.- ANTECEDENTES DE SALUD" %>
					  <br><br>
              </div>
			</td>
		  </tr>
          <tr>
            <td valign="top">
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
				  	<td>
					<table width="100%" >
					<tr>
						<td width="10%"><strong>Alumno</strong></td>
						<td align="left"><strong>:</strong> <%=nombre_alumno%></td>
					</tr>
					<tr>
						<td width="10%"><strong>R.U.T.</strong></td>
						<td align="left"><strong>:</strong> <%=rut_alumno%></td>
					</tr>
					<tr>
						<td colspan="2"><br><br></td>
					</tr>
					</table>
					</td>
				  </tr>
				  <br><br>
                  <tr>
                    <td>Existen antecedentes de enfermedades en el grupo familiar que demanden un alto costo por este concepto<br><br>              
						  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_grupo_familiar.DibujaTabla() %>
								</td>
							</tr>
							<tr>
							  <td align="center">&nbsp;</td>
							</tr>
							<tr>
							  <td align="right">
							  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
													<tr>
													  <td width="70%"><div align="center">&nbsp;</div></td> 
													  <td width="15%"><div align="center"><%f_botonera.DibujaBoton("eliminar")%></div></td>
													  <td width="15%"><div align="center"><%f_botonera.DibujaBoton("nuevo")%></div></td>
													</tr>
							  </table>
							 </td>
							</tr>
							<tr>
							  <td align="center">&nbsp;</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  </table>
            </form>
			
			
			</td></tr>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("anterior")%></div></td>
                  <td><div align="center">
				  	  <% f_botonera.agregaBotonParam "salir","url","menu_alumno.asp"
					     f_botonera.DibujaBoton("salir")%>
                  </div></td>
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
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
