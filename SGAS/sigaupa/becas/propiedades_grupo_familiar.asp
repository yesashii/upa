<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% pers_ncorr =session("pers_ncorr_alumno")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "4.- Propiedades"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------Datos alumno---
nombre_alumno = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_alumno = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "propiedades_grupo_familiar.xml", "botonera"
'---------------------------------------------------------------------------------------------------

periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr=session("post_ncorr_alumno") 'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")

'---------------buscamos el tipo de propietario que se ha ingresaro en la postulacion a la beca
tipo_propietario = conexion.consultaUno("select pobe_tipo_propietario from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'")
'------------------------------------------------------------------------------------

Sql_parientes = "  Select pp.pers_ncorr, protic.initcap(pp.pers_tnombre)+' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, " & VBCRLF  	& _
			    "  protic.initCap(pa.pare_tdesc) as Parentesco, protic.format_rut(pp.pers_nrut) as rut, prpe_nrol as rol, prpe_navaluo as avaluo,prpe_ncorr" & VBCRLF  	& _
				"  from postulantes pos join  grupo_familiar gf  " & VBCRLF  	& _
			    "    on pos.post_ncorr = gf.post_ncorr  " & VBCRLF  	& _
			    "  join  personas_postulante pp  " & VBCRLF  	& _
			    "    on gf.pers_ncorr = pp.pers_ncorr  " & VBCRLF  	& _
				"  left outer join propiedades_personas pr "&vbcrlf &_
				"	 on pp.pers_ncorr = pr.pers_ncorr " &vbcrlf &_  
			    " join parentescos pa " & VBCRLF  	& _
			    "    on gf.pare_ccod = pa.pare_ccod" & VBCRLF  	& _
				" Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
				" and isnull(gf.grup_nindependiente,0)= 0 " & VBCRLF  	& _
				" and gf.pare_ccod not in (0) " & VBCRLF  	& _
				" union all " & VBCRLF  	& _
				" select pp.pers_ncorr, protic.initcap(pp.pers_tnombre) +' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, " & VBCRLF  	& _
				" 'Alumno' as Parentesco,protic.format_rut(pp.pers_nrut) as rut, prpe_nrol as rol, prpe_navaluo as avaluo,prpe_ncorr" & VBCRLF  	& _
			    " from personas_postulante pp   left outer join propiedades_personas pr "&vbcrlf &_
				"	 on pp.pers_ncorr = pr.pers_ncorr " &vbcrlf &_
			    " where cast(pp.pers_ncorr as varchar)='"&pers_ncorr&"'"

'response.Write("<pre>"&Sql_parientes&"</pre>")
set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "propiedades_grupo_familiar.xml", "grilla_bienes"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.Consultar Sql_parientes

lenguetas_postulacion = Array(Array("Datos Personales", "datos_alumno.asp"), Array("Ant. Grupo Familiar", "grupo_familiar.asp"), Array("Ingresos Grupo Familiar", "ingresos_grupo_familiar.asp"), Array("Propiedades", "propiedades_grupo_familiar.asp"), Array("Ant. de Salud", "ant_salud_familiar.asp"))

'---------------------------ahora para los vehículos de los familiares
Sql_vehiculos = "  Select pp.pers_ncorr, protic.initcap(pp.pers_tnombre)+' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar, vepe_ncorr," & VBCRLF  	& _
			    "  protic.initCap(pa.pare_tdesc) as Parentesco, protic.format_rut(pp.pers_nrut) as rut, vepe_nano as ano, vepe_tmarca as marca,vepe_npatente as patente, vepe_navaluo as avaluo, case vepe_cuso when 1 then 'Particular' when 2 then 'Comercial' when 3 then 'No vigente' else '' end  as uso" & VBCRLF  	& _
				"  from postulantes pos join  grupo_familiar gf  " & VBCRLF  	& _
			    "    on pos.post_ncorr = gf.post_ncorr  " & VBCRLF  	& _
			    "  join  personas_postulante pp  " & VBCRLF  	& _
			    "    on gf.pers_ncorr = pp.pers_ncorr  " & VBCRLF  	& _
				"  left outer join vehiculos_personas pr "&vbcrlf &_
				"	 on pp.pers_ncorr = pr.pers_ncorr " &vbcrlf &_  
			    " join parentescos pa " & VBCRLF  	& _
			    "    on gf.pare_ccod = pa.pare_ccod" & VBCRLF  	& _
				" Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
				" and isnull(gf.grup_nindependiente,0)= 0 " & VBCRLF  	& _
				" and gf.pare_ccod not in (0) " & VBCRLF  	& _
				" union all " & VBCRLF  	& _
				" select pp.pers_ncorr, protic.initcap(pp.pers_tnombre) +' '+ protic.initcap(pp.pers_tape_paterno) +' '+ protic.initcap(pp.pers_tape_materno) as Nom_familiar,vepe_ncorr, " & VBCRLF  	& _
				" 'Alumno' as Parentesco,protic.format_rut(pp.pers_nrut) as rut, vepe_nano as ano, vepe_tmarca as marca,vepe_npatente as patente, vepe_navaluo as avaluo, case vepe_cuso when 1 then 'Particular' when 2 then 'Comercial' when 3 then 'No vigente' else '' end  as uso" & VBCRLF  	& _
			    " from personas_postulante pp   left outer join vehiculos_personas pr "&vbcrlf &_
				"	 on pp.pers_ncorr = pr.pers_ncorr " &vbcrlf &_
			    " where cast(pp.pers_ncorr as varchar)='"&pers_ncorr&"'"

'response.Write("<pre>"&Sql_parientes&"</pre>")
set f_vehiculos = new CFormulario
f_vehiculos.Carga_Parametros "propiedades_grupo_familiar.xml", "grilla_vehiculos"
f_vehiculos.Inicializar conexion
f_vehiculos.Consultar Sql_vehiculos

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
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>

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
				pagina.DibujarLenguetas lenguetas_postulacion, 4
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  	<td><div align="center"><br><br>
                      <%pagina.DibujarTitulo "4.- PROPIEDADES" %>
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
				  <tr>
                    <td><%pagina.dibujarSubtitulo "A.- PROPIEDADES"%><br>
					    <strong>Vivienda que ocupa</strong>,debe anotar el tipo de propiedad que corresponde a la casa que habita el grupo familiar<br><br>              
						  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								  <td  width="20%" align="left"><strong>Tipo de propietario :</strong></td>
								  <td  width="80%" align="left"><select name='tipo_propietario' id="TO-N">
																 <%if tipo_propietario = "" then%>
																 <option value='' selected>Seleccione</option>
																 <%else%>
																 <option value=''>Seleccione</option>
																 <%end if%>
																 <%if tipo_propietario = "1" then%>
																 <option value='1' selected>Propietario V. Pagada</option>
																 <%else%>
																 <option value='1'>Propietario V. Pagada</option>
																 <%end if%>
																 <%if tipo_propietario = "2" then%>
																 <option value='2' selected>Propietario V. en Pago</option>
																 <%else%>
																 <option value='2'>Propietario V. en Pago</option>
																 <%end if%>
																 <%if tipo_propietario = "3" then%>
																 <option value='3' selected>Arrendatario</option>
																 <%else%>
																 <option value='3'>Arrendatario</option>
																 <%end if%>
																 <%if tipo_propietario = "4" then%>
																 <option value='4' selected>Usufructuario</option>
																 <%else%>
																 <option value='4'>Usufructuario</option>
																 <%end if%>
																 <%if tipo_propietario = "5" then%>
																 <option value='5' selected>Allegado</option>
																 <%else%>
																 <option value='5'>allegado</option>
																 <%end if%>
																</select>
								  </td> 
							</tr>
							<tr>
							  <td align="center" colspan="2">&nbsp;</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <br><br>
                  <tr>
                    <td><%pagina.dibujarSubtitulo "B.- TENENCIA DE BIENES RAICES"%><br>
					    Si es propietario o adquiriente de vivienda que ocupa u otro bien ra&iacute;z, coloque en primer lugar la que ocupa <br><br>              
						  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_grupo_familiar.DibujaTabla() %>
								</td>
							</tr>
							<tr>
							  <td align="center">&nbsp;</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <br><br>
				  <tr>
                    <td><%pagina.dibujarSubtitulo "C.- TENENCIA DE VEH&Iacute;CULOS"%>					    
						  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_vehiculos.DibujaTabla() %>
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
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>
                  <td><div align="center">
				 		<%f_botonera.DibujaBoton("salir")%>
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
