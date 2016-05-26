<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

v_pers_ncorr = session("pers_ncorr_alumno") 'request.Form("persona[0][pers_ncorr]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "1.- Antecedentes del Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "inicio_becas.xml", "botonera_datos_alumno"

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
v_anio_anterior = "2006"

'---------------------------------------------------------------------------------------------------
set f_datos_personales = new CFormulario
f_datos_personales.Carga_Parametros "inicio_becas.xml", "datos_personales"
f_datos_personales.Inicializar conexion

sql_carrera_postulante =   " SELECT distinct d.carr_ccod + '/' + cast(isnull(protic.ano_ingreso_carrera(aa.pers_ncorr,d.carr_ccod),2006) as varchar) as carr_ccod ,D.CARR_TDESC +' '+ C.ESPE_TDESC as carr_tdesc  " &vbcrlf & _
							" from postulantes aa,detalle_postulantes a, ofertas_academicas b, " &vbcrlf & _
							" especialidades c,carreras d,periodos_academicos pea " &vbcrlf & _
							" where aa.post_ncorr = a.post_ncorr "&vbcrlf &_
							" and cast(aa.pers_ncorr as varchar)='"&v_pers_ncorr&"'" &vbcrlf &_ 
							" and aa.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)='"&v_anio_anterior&"'" &vbcrlf &_ 
							" and a.ofer_ncorr = b.ofer_ncorr " &vbcrlf & _
							" and b.espe_ccod = c.espe_ccod " &vbcrlf & _
							" and c.carr_ccod = d.carr_ccod " 

'response.Write("<pre>"&sql_carrera_postulante&"</pre>")
'---------------------------buscamos los valores por defecto para mostrar en los campos desabilitados--------------------------
ano_primer_ingreso =   " SELECT distinct aa.pers_ncorr,c.carr_ccod " &vbcrlf & _
							" from postulantes aa,detalle_postulantes a, ofertas_academicas b, " &vbcrlf & _
							" especialidades c,periodos_academicos pea" &vbcrlf & _
							" where aa.post_ncorr = a.post_ncorr "&vbcrlf &_
							" and cast(aa.pers_ncorr as varchar)='"&v_pers_ncorr&"'" &vbcrlf &_ 
							" and aa.peri_ccod=pea.peri_ccod and cast(anos_ccod as varchar)='"&v_anio_anterior&"'" &vbcrlf &_ 
							" and a.ofer_ncorr = b.ofer_ncorr " &vbcrlf & _
							" and b.espe_ccod = c.espe_ccod "
							
ano_carrera = conexion.consultaUno("select isnull(isnull(protic.ano_ingreso_carrera(a.pers_ncorr,a.carr_ccod),protic.ano_ingreso_universidad(a.pers_ncorr)),2006)  from ("&ano_primer_ingreso&")a")
carrera_beca = conexion.consultaUno("select a.carr_ccod  from ("&ano_primer_ingreso&")a")

estado_civil = conexion.consultaUno("select isnull(eciv_ccod,1) from personas_postulante where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")


consulta = "  select top 1 b.pers_nrut, b.pers_xdv, b.pers_tape_paterno, b.pers_tape_materno, b.pers_tnombre, b.pers_ncorr," & vbCrLf &_
"   b.pers_fnacimiento, b.eciv_ccod," & vbCrLf &_
"   (select dire_tcalle from direcciones_publica f " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as dire_tcalle_academico, " & vbCrLf &_
"   (select dire_tnro from direcciones_publica f " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as dire_tnro_academico, " & vbCrLf &_
"   (select dire_tpoblacion from direcciones_publica f " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as dire_tpoblacion_academico, " & vbCrLf &_
"   (select ciud_ccod from direcciones_publica f " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as ciud_ccod_academico, " & vbCrLf &_
"   (select dire_tfono from direcciones_publica f " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as dire_tfono_academico,  " & vbCrLf &_
"   (select dire_tblock from direcciones_publica f " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as dire_tblock_academico, " & vbCrLf &_
"   (select regi_ccod from direcciones_publica f, ciudades g " & vbCrLf &_
"    where f.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"    and f.ciud_ccod = g.ciud_ccod " & vbCrLf &_
"    and f.tdir_ccod  = 2 ) as regi_ccod_academico,b.pers_nano_egr_media as ano_paa   " & vbCrLf &_
" from  postulantes a, personas_postulante b,periodos_academicos pea " & vbCrLf &_
"  where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
"  and cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "'"& vbCrLf &_
"  and a.peri_ccod=pea.peri_ccod and cast(pea.anos_ccod as varchar)= '" & v_anio_anterior & "'"
'response.Write("<pre>"&consulta&"</pre>")
f_datos_personales.Consultar consulta
f_datos_personales.agregaCampoParam "carr_ccod1", "destino","("&sql_carrera_postulante&")a"
f_datos_personales.agregaCampoParam "eciv_ccod", "destino", "(select eciv_ccod,eciv_tdesc from estados_civiles where eciv_ccod <> 0 )a"
f_datos_personales.Siguiente


lenguetas_postulacion = Array(Array("Datos Personales", "datos_alumno.asp"), Array("Ant. Grupo Familiar", "grupo_familiar.asp"), Array("Ingresos Grupo Familiar", "ingresos_grupo_familiar.asp"), Array("Propiedades", "propiedades_grupo_familiar.asp"), Array("Ant. de Salud", "ant_salud_familiar.asp"))


pais=f_datos_personales.Obtenervalor("pais_ccod")

'------------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------------------
set f_beca = new CFormulario
f_beca.Carga_Parametros "tabla_vacia.xml", "tabla"
f_beca.Inicializar conexion

consulta = " select pobe_nfolio, carr_ccod,ano_ingr_carrera,pobe_nnivel,eciv_ccod  "& vbCrLf &_
           " from postulacion_becas  "& vbCrLf &_
		   " where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' "& vbCrLf &_
		   "	and cast(carr_ccod as varchar)='"&carrera_beca&"' "& vbCrLf &_
		   "	and cast(peri_ccod as varchar)='"&periodo&"'" 
f_beca.consultar consulta
f_beca.siguiente
if f_beca.nroFilas > 0 then
 folio =f_beca.obtenerValor("pobe_nfolio")
 carrera_beca = f_beca.obtenerValor("carr_ccod")
 ano_carrera = f_beca.obtenerValor("ano_ingr_carrera")
 nivel = f_beca.obtenerValor("pobe_nnivel")
 estado_civil = f_beca.obtenerValor("eciv_ccod")
end if 


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
function mostrar_estado(valor)
{var formulario;
     formulario = document.edicion;
	 formulario.elements["cod_estado"].value = valor;
	 formulario.elements["cod_estado_nuevo"].value = valor;
}

function mostrar_ano_carrera(valor)
{ var ano = valor.split('/');

  document.edicion.elements["ano_ingr_carrera"].value = ano[1];
  document.edicion.elements["carrera_beca"].value = ano[0];
  
}


</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "dp[0][pers_fnacimiento]","1","edicion","fecha_oculta_fnacimiento"
	calendario.FinFuncion
%>
<style type="text/css">
<!--
.style3 {color: #FF0000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" >
<%calendario.ImprimeVariables%>
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
            <td><%pagina.DibujarLenguetas lenguetas_postulacion, 1				  
				%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTitulo "1.- ANTECEDENTES DEL ALUMNO" %>
              <br>
              <br>
              
                </div>
              <form name="edicion">
			  
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td> 
					  <br>
					  <br> 
                        <table width="98%"  border="1" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="15%"><strong>R.U.T.</strong><br>                              
                              <%f_datos_personales.DibujaCampo("pers_nrut")%> - <%f_datos_personales.DibujaCampo("pers_xdv")%></td>
                           <td width="25%"><strong>Apellido paterno </strong><br>                              
                              <%f_datos_personales.DibujaCampo("pers_tape_paterno")%>                              </td>
                          <td width="25%"><strong> Apellido materno </strong><br>
                           <%f_datos_personales.DibujaCampo("pers_tape_materno")%>
                          </td>
                          <td width="30%"><strong>Nombres</strong><br>
                           <%f_datos_personales.DibujaCampo("pers_tnombre")%>
						   <input type="hidden" name="dp[0][pers_ncorr]" value="<%=v_pers_ncorr%>">
                          </td>   
                        </tr>
                      </table>
					  <br>
					  <center><strong>Direcci&oacute;n del Alumno en Per&iacute;odo Acad&eacute;mico</strong></center>
					  <br>
					  <table width="98%"  border="1" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50%" colspan="2"><strong>Regi&oacute;n</strong><strong>
                            <br><%f_datos_personales.DibujaCampo("regi_ccod_academico")%>
                             </strong><br></td>
                              <td width="50%" colspan="3"><strong>Ciudad</strong><br>
                              <strong><%f_datos_personales.DibujaCampo("ciud_ccod_academico")%>
							  </strong></td>
                        </tr>
						<tr> 
                              <td width="24%"><strong>Calle</strong><br>
                                <strong><%f_datos_personales.DibujaCampo("dire_tcalle_academico")%>
                                </strong></td>
                              <td width="17%"><strong>Nº</strong><br>
                                <strong><%f_datos_personales.DibujaCampo("dire_tnro_academico")%>
                                </strong></td>
                              <td width="15%"><strong>Depto.</strong><br>
                                  <strong><%f_datos_personales.DibujaCampo("dire_tblock_academico")%>
                                  </strong></td>
                              <td width="22%"><strong>Condominio/Conjunto</strong><br>
                                  <strong><%f_datos_personales.DibujaCampo("dire_tpoblacion_academico")%>
                                  </strong></td>
                              <td width="22%"><strong>Tel&eacute;fono</strong><br> 
                                <strong><%f_datos_personales.DibujaCampo("dire_tfono_academico")%></strong></td>
                         </tr>
                      </table>
					   <br>
                      <table width="98%"  border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td width="40%"><strong>Fecha nacimiento </strong><br> <strong> 
                                <%f_datos_personales.DibujaCampo("pers_fnacimiento")%>
                                <a style='cursor:hand;' onClick='PopCalendar.show(document.edicion.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                                </a> 
                                <%calendario.DibujaImagen "fecha_oculta_fnacimiento","1","edicion" %>
                                </strong></td>
                                <td width="40%"><strong>Estado civil</strong> <br> <strong> 
                                <%f_datos_personales.DibujaCampo("eciv_ccod")%>
                                </strong> </td>
								<td width="20%"><strong>Cod. estado</strong> <br> <strong> 
                                <input type="hidden" name="cod_estado" value="<%=estado_civil%>"  maxlength="2" size="2">
								<input type="text" name="cod_estado_nuevo" value="<%=estado_civil%>"  maxlength="2" size="2" disabled>
                                </strong> </td>
                            </tr>
                          </table>
                      <br>
					  <center><strong>Carrera</strong></center>
					  <br>
					      <table width="98%"  border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr>
                              <td align="center"><br><strong>Nombre de la Carrera</strong> <br> <strong> 
                                <%f_datos_personales.DibujaCampo("carr_ccod1")%>
								<input type="hidden" name="carrera_beca" value="<%=carrera_beca%>" size="3" maxlength="3">
                                </strong> </td>
							  <td align="center"><br><strong>Año Egreso Colegio</strong> <br> <strong> 
                                <%f_datos_personales.DibujaCampo("ano_paa")%>
                                </strong> </td>
							  <td align="center"><br><strong>Año Ingreso Carrera</strong> <br> <strong> 
                                <input type="text" name="ano_ingr_carrera" size="4" maxlength="4"  value="<%=ano_carrera%>">
                                </strong> </td>	
							 <td align="center"><br><strong>Nivel</strong> <br> <strong> 
                                <input type="text" name="pobe_nnivel" size="2" maxlength="2" value="<%=nivel%>" id="NU-S">
                                </strong> </td>		
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
                  <td><div align="center"><%
				  if v_post_antiguo=true or v_matriculado=true then f_botonera.agregabotonparam "anterior", "url", "postulacion_antiguo.asp" end if
				  f_botonera.DibujaBoton "anterior"
				  %>
				  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("siguiente")%>
                  </div></td>
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
