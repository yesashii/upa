<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% pers_ncorr =session("pers_ncorr_alumno")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "2.- ANTECEDENTES DEL GRUPO FAMILIAR"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------Datos alumno---
nombre_alumno = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_alumno = conexion.consultaUno("Select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "grupo_familiar.xml", "botonera"
'---------------------------------------------------------------------------------------------------

periodo = negocio.ObtenerPeriodoAcademico("Postulacion")
v_post_ncorr= session("post_ncorr_alumno") 'conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"' and epos_ccod=2")

Sql_parientes_mayores = "  Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar,pp.eciv_ccod as estado_civil, " & VBCRLF  	& _
					    " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, datepart(year,pp.pers_fnacimiento) as ano_nacimiento,  " & VBCRLF  	& _
					    " gf.pare_ccod, pos.post_ncorr, " & VBCRLF  	& _
						" case gf.pare_ccod when 1 then 1 when 5 then 2 when 2 then 3 when 6 then 4 when 3 then 5 when 7 then 6 " & VBCRLF  	& _
				        "                   when 8 then 7 when 9 then 8 when 10 then 9 when 11 then 10 when 12 then 11  " & VBCRLF  	& _
					    "                   when 13 then 12 when 14 then 13 when 4 then 14 end as cod_parentesco, " & VBCRLF  	& _
					    " ap.nied_ccod as codigo_nivel,ap.prev_ccod as cod_prevision,ap.prsa_ccod as cod_prev_salud, " & VBCRLF  	& _
						" ap.acti_ccod as cod_actividad, ap.pers_tprofesion as profesion    " & VBCRLF  	& _
						" from postulantes pos join  grupo_familiar gf " & VBCRLF  	& _
						"    on pos.post_ncorr = gf.post_ncorr " & VBCRLF  	& _
					    " join  personas_postulante pp  " & VBCRLF  	& _
				        "    on gf.pers_ncorr = pp.pers_ncorr " & VBCRLF  	& _
					    " left outer join antecedentes_personas ap " & VBCRLF  	& _
					    "    on pp.pers_ncorr= ap.pers_ncorr " & VBCRLF  	& _
					    " Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
						" and isnull(gf.grup_nindependiente,0) = 0 " & VBCRLF  	& _
						" And datediff(year, pp.pers_fnacimiento,getDate()) >= 18 "
'response.Write("<pre>"&Sql_parientes_mayores&"</pre>")

set f_grupo_familiar_mayor = new CFormulario
f_grupo_familiar_mayor.Carga_Parametros "grupo_familiar.xml", "grilla_familiares"
f_grupo_familiar_mayor.Inicializar conexion
f_grupo_familiar_mayor.Consultar Sql_parientes_mayores
'------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------

Sql_parientes_menores = "  Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar,pp.eciv_ccod as estado_civil, " & VBCRLF  	& _
					    " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, datepart(year,pp.pers_fnacimiento) as ano_nacimiento,  " & VBCRLF  	& _
					    " gf.pare_ccod, pos.post_ncorr, " & VBCRLF  	& _
						" case gf.pare_ccod when 1 then 1 when 5 then 2 when 2 then 3 when 6 then 4 when 3 then 5 when 7 then 6 " & VBCRLF  	& _
				        "                   when 8 then 7 when 9 then 8 when 10 then 9 when 11 then 10 when 12 then 11  " & VBCRLF  	& _
					    "                   when 13 then 12 when 14 then 13 when 4 then 14 end as cod_parentesco, " & VBCRLF  	& _
					    " ap.nied_ccod as codigo_nivel,ap.prev_ccod as cod_prevision,ap.prsa_ccod as cod_prev_salud, " & VBCRLF  	& _
						" ap.acti_ccod as cod_actividad, ap.pers_tprofesion as profesion    " & VBCRLF  	& _
						" from postulantes pos join  grupo_familiar gf " & VBCRLF  	& _
						"    on pos.post_ncorr = gf.post_ncorr " & VBCRLF  	& _
					    " join  personas_postulante pp  " & VBCRLF  	& _
				        "    on gf.pers_ncorr = pp.pers_ncorr " & VBCRLF  	& _
					    " left outer join antecedentes_personas ap " & VBCRLF  	& _
					    "    on pp.pers_ncorr= ap.pers_ncorr " & VBCRLF  	& _
					    " Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
						" And datediff(year, pp.pers_fnacimiento,getDate()) < 18 "

set f_grupo_familiar_menor = new CFormulario
f_grupo_familiar_menor.Carga_Parametros "grupo_familiar.xml", "grilla_menores"
f_grupo_familiar_menor.Inicializar conexion
f_grupo_familiar_menor.Consultar Sql_parientes_menores

'-----------------------------------------------------------------------------------------------------------
'response.Write("select count(*) from grupo_familiar where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and pare_ccod=1")
busca_padre = conexion.consultaUno("select count(*) from grupo_familiar where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and pare_ccod=1")
Sql_parientes_padre_independiente = "  Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar,pp.eciv_ccod as estado_civil, " & VBCRLF  	& _
					    " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, datepart(year,pp.pers_fnacimiento) as ano_nacimiento,  " & VBCRLF  	& _
					    " gf.pare_ccod, pos.post_ncorr, " & VBCRLF  	& _
						" case gf.pare_ccod when 1 then 1 when 5 then 2 when 2 then 3 when 6 then 4 when 3 then 5 when 7 then 6 " & VBCRLF  	& _
				        "                   when 8 then 7 when 9 then 8 when 10 then 9 when 11 then 10 when 12 then 11  " & VBCRLF  	& _
					    "                   when 13 then 12 when 14 then 13 when 4 then 14 end as cod_parentesco, " & VBCRLF  	& _
					    " ap.nied_ccod as codigo_nivel,ap.prev_ccod as cod_prevision,ap.prsa_ccod as cod_prev_salud, " & VBCRLF  	& _
						" ap.acti_ccod as cod_actividad, ap.pers_tprofesion as profesion    " & VBCRLF  	& _
						" from postulantes pos join  grupo_familiar gf " & VBCRLF  	& _
						"    on pos.post_ncorr = gf.post_ncorr " & VBCRLF  	& _
					    " join  personas_postulante pp  " & VBCRLF  	& _
				        "    on gf.pers_ncorr = pp.pers_ncorr " & VBCRLF  	& _
					    " left outer join antecedentes_personas ap " & VBCRLF  	& _
					    "    on pp.pers_ncorr= ap.pers_ncorr " & VBCRLF  	& _
					    " Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
						" and isnull(gf.grup_nindependiente,0) <> 0 and gf.pare_ccod = 1"

set f_grupo_familiar_padre = new CFormulario
f_grupo_familiar_padre.Carga_Parametros "grupo_familiar.xml", "grilla_padre"
f_grupo_familiar_padre.Inicializar conexion
f_grupo_familiar_padre.Consultar Sql_parientes_padre_independiente
'------------------------------------------------------------------------------------------------------------------
busca_madre = conexion.consultaUno("select count(*) from grupo_familiar where cast(post_ncorr as varchar)='"&v_post_ncorr&"' and pare_ccod=2")
Sql_parientes_madre_independiente =  "  Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar,pp.eciv_ccod as estado_civil, " & VBCRLF  	& _
					    " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, datepart(year,pp.pers_fnacimiento) as ano_nacimiento,  " & VBCRLF  	& _
					    " gf.pare_ccod, pos.post_ncorr, " & VBCRLF  	& _
						" case gf.pare_ccod when 1 then 1 when 5 then 2 when 2 then 3 when 6 then 4 when 3 then 5 when 7 then 6 " & VBCRLF  	& _
				        "                   when 8 then 7 when 9 then 8 when 10 then 9 when 11 then 10 when 12 then 11  " & VBCRLF  	& _
					    "                   when 13 then 12 when 14 then 13 when 4 then 14 end as cod_parentesco, " & VBCRLF  	& _
					    " ap.nied_ccod as codigo_nivel,ap.prev_ccod as cod_prevision,ap.prsa_ccod as cod_prev_salud, " & VBCRLF  	& _
						" ap.acti_ccod as cod_actividad, ap.pers_tprofesion as profesion    " & VBCRLF  	& _
						" from postulantes pos join  grupo_familiar gf " & VBCRLF  	& _
						"    on pos.post_ncorr = gf.post_ncorr " & VBCRLF  	& _
					    " join  personas_postulante pp  " & VBCRLF  	& _
				        "    on gf.pers_ncorr = pp.pers_ncorr " & VBCRLF  	& _
					    " left outer join antecedentes_personas ap " & VBCRLF  	& _
					    "    on pp.pers_ncorr= ap.pers_ncorr " & VBCRLF  	& _
					    " Where cast(pos.post_ncorr as varchar) = '"&v_post_ncorr&"' " & VBCRLF  	& _
						" and isnull(gf.grup_nindependiente,0) <> 0 and gf.pare_ccod = 2"

set f_grupo_familiar_madre = new CFormulario
f_grupo_familiar_madre.Carga_Parametros "grupo_familiar.xml", "grilla_madre"
f_grupo_familiar_madre.Inicializar conexion
f_grupo_familiar_madre.Consultar Sql_parientes_madre_independiente

'###############	VERIFICA QUE EXISTA ALMENOS UN PARIENTE ANTES DE ENVIAR LA POSTULACION	###################
Sql_parientes_minimos = " Select count(*) as total " & VBCRLF  	& _
				" from postulantes pos, grupo_familiar gf, personas_postulante pp, parentescos pa " & VBCRLF  	& _
				" Where pos.post_ncorr='"&v_post_ncorr&"' " & VBCRLF  	& _
				" And pos.post_ncorr=gf.post_ncorr " & VBCRLF  	& _
				" And gf.pers_ncorr=pp.pers_ncorr " & VBCRLF  	& _
				" And gf.pare_ccod=pa.pare_ccod " & VBCRLF  	& _
				" And isnull(gf.grup_nindependiente,0) <> 1 " & VBCRLF  	& _
				" And gf.pare_ccod not in (0) "
'response.Write("<pre>"&Sql_parientes_minimos&"<pre>")				
v_parientes = conexion.ConsultaUno(Sql_parientes_minimos)
v_parientes = cint(v_parientes) + 1
'response.Write(v_parientes)
'v_parientes="1"' descomentar para dejarlo pasar sin parientes
'-------------------------------------------------------------------------------------


lenguetas_postulacion = Array(Array("Datos Personales", "datos_alumno.asp"), Array("Ant. Grupo Familiar", "grupo_familiar.asp"), Array("Ingresos Grupo Familiar", "ingresos_grupo_familiar.asp"), Array("Propiedades", "propiedades_grupo_familiar.asp"), Array("Ant. de Salud", "ant_salud_familiar.asp"))

'--------------------------------------------revisar datos de la postulación a la beca -------------------------------------------
'---------------------------------------------------------msandoval---------------------------------------------------------------
set f_datos_generales = new CFormulario
f_datos_generales.Carga_Parametros "grupo_familiar.xml", "datos_generales"
f_datos_generales.Inicializar conexion

consulta_datos = " Select pobe_ncorr,pers_ncorr,repa_ccod, povi_ccod, pobe_temail_alumno, pobe_num_grupo from postulacion_becas " &_
		 	     " where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&periodo&"'"
'response.Write(consulta_datos)
f_datos_generales.Consultar consulta_datos
f_datos_generales.agregaCampoCons "pobe_num_grupo",v_parientes
f_datos_generales.siguiente
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
function agregar_familiar( valor){
	//alert("levantar ventana familiares...");
	if (valor==1)
	window.open("agregar_grupo_familiar.asp?grupo=1&grup_nindependiente=0","familiares_1"," width=770,height=580, scrollbars=yes, top=10,left=10,  resizable=yes");
	
	if (valor==2)
	window.open("agregar_grupo_familiar.asp?grupo=2&grup_nindependiente=0","familiares_2"," width=770,height=580, scrollbars=yes, top=10,left=10,  resizable=yes");
	
	if (valor==3)
	window.open("agregar_grupo_familiar.asp?grupo=3&grup_nindependiente=1","familiares_3"," width=770,height=580, scrollbars=yes, top=10,left=10,  resizable=yes");

    if (valor==4)
	window.open("agregar_grupo_familiar.asp?grupo=4&grup_nindependiente=1","familiares_4"," width=770,height=580, scrollbars=yes, top=10,left=10,  resizable=yes");

	
}
function eliminar_familiar(form){
	form.submit
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
				pagina.DibujarLenguetas lenguetas_postulacion, 2
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  	<td><div align="center"><br><br>
                      <%pagina.DibujarTitulo "2.- ANTECEDENTES DEL GRUPO FAMILIAR" %>
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
                    <td><%pagina.DibujarSubtitulo "Grupo familiar mayores de 18 años"%>                      
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_grupo_familiar_mayor.DibujaTabla() %>
								</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <tr>
				  	<td>
					<table width="100%" >
					<tr>
						<td width="80%"></td>
						<td><div align="right"> <%f_botonera.DibujaBoton("agregar_familiar")%></div></td>
					</tr>
					</table>
					</td>
				  </tr>
				  <br><br>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Grupo familiar menores de 18 años"%>                      
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_grupo_familiar_menor.DibujaTabla() %>
								</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <tr>
				  	<td>
					<table width="100%" >
					<tr>
						<td width="80%"></td>
						<td><div align="right"> <%f_botonera.DibujaBoton("agregar_familiar_menor")%></div></td>
					</tr>
					</table>
					</td>
					</tr>
					<br><br>
					<tr>
				  	   <td>
					       <table width="100%" >
					       <tr>
						       <td>Total de Integrantes del grupo Familiar <br> incluyendo al Alumno <%f_datos_generales.dibujaCampo("pobe_num_grupo")%></td>
						       <td>Relaci&oacute;n de los Padres <%f_datos_generales.dibujaCampo("repa_ccod")%></td>
					       </tr>
						   <tr>
						       <td>El postulante vive con <%f_datos_generales.dibujaCampo("povi_ccod")%> <input type="hidden" value="<%=f_datos_generales.obtenerValor("pobe_ncorr")%>" name="pobe_ncorr"></td>
						       <td>E-mail Alumno <%f_datos_generales.dibujaCampo("pobe_temail_alumno")%></td>
					       </tr>
						   <tr>
						       <td colspan="2">&nbsp;</td>
  				           </tr>
					      </table>
					   </td>
					</tr>
					<br><br>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Padre no integrante del grupo familiar"%>                      
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_grupo_familiar_padre.DibujaTabla() %>
								</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <tr>
				  	<td>
					<table width="100%" >
					<tr>
						<td width="80%"></td>
						<td><div align="right"> <% if busca_padre > "0" then
												  		f_botonera.agregaBotonParam "agregar_familiar_padre","deshabilitado","TRUE" 
												   end if
 						                          f_botonera.DibujaBoton("agregar_familiar_padre")%></div></td>
					</tr>
					</table>
					</td>
				  </tr>
				  <br><br>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Madre no integrante del grupo familiar"%>                      
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td align="center">
							  <% f_grupo_familiar_madre.DibujaTabla() %>
								</td>
							</tr>
						  </table>
						  <br>
         	 		</td>
                  </tr>
				  <tr>
				  	<td>
					<table width="100%" >
					<tr>
						<td width="80%"></td>
						<td><div align="right"> <%if busca_madre <>"0" then
												  		f_botonera.agregaBotonParam "agregar_familiar_madre","deshabilitado","TRUE" 
												   end if
						                          f_botonera.DibujaBoton("agregar_familiar_madre")%></div></td>
					</tr>
                </table>
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
