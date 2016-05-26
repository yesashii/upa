<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Asistente de Postulaciones."
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'--------------------------------------------------------------------------
'para que cuando presionen salir los envie  a la ventana de inicio del alumnos asistente.
session("alumno_asistente")= "1"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "apoyo_postulacion.xml", "busqueda_usuarios"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "apoyo_postulacion.xml", "botonera"
'--------------------------------------------------------------------------
set datos_personales = new CFormulario
datos_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_personales.Inicializar conexion
consulta_datos =  " select a.pers_ncorr,protic.format_rut(pers_nrut) as rut, "& vbCrLf &_
				  " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, "& vbCrLf &_
				  " b.sexo_tdesc as sexo,c.pais_tdesc as pais "& vbCrLf &_
				  " from personas_postulante a,sexos b,paises c "& vbCrLf &_
				  " where cast(a.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
				  " and a.sexo_ccod *=b.sexo_ccod "& vbCrLf &_
				  " and a.pais_ccod=c.pais_ccod"

datos_personales.Consultar consulta_datos
datos_personales.siguiente

codigo = datos_personales.obtenerValor("pers_ncorr")
rut_completo = datos_personales.obtenerValor("rut")
nombre = datos_personales.obtenerValor("nombre")
sexo = datos_personales.obtenerValor("sexo")
pais = datos_personales.obtenerValor("pais")

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de postulaciones del alumno
set datos_postulacion = new CFormulario
datos_postulacion.Carga_Parametros "apoyo_postulacion.xml", "postulaciones"
datos_postulacion.Inicializar conexion
consulta_postulacion =  "  select distinct protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,  "& vbCrLf &_
						"  case a.epos_ccod when 1 then 'No enviada' when 2 then 'Enviada' end as estado_pos, protic.initcap(i.eepo_tdesc) as estado_examen, "& vbCrLf &_
						"  protic.initcap(eopo_tdesc) as estado,isnull(obpo_tobservacion,'--') as observacion "& vbCrLf &_
						"  from postulantes a join detalle_postulantes b "& vbCrLf &_
						"    on  a.post_ncorr = b.post_ncorr "& vbCrLf &_
						"  join ofertas_academicas c "& vbCrLf &_
						"    on  b.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
						"  join especialidades d "& vbCrLf &_
						"    on  c.espe_ccod  = d.espe_ccod "& vbCrLf &_
						"  join carreras e "& vbCrLf &_
						"    on  d.carr_ccod  = e.carr_ccod "& vbCrLf &_
						"  join sedes g "& vbCrLf &_
						"    on  c.sede_ccod  = g.sede_ccod "& vbCrLf &_
						"  join jornadas h "& vbCrLf &_
					    "    on  c.jorn_ccod  = h.jorn_ccod "& vbCrLf &_
						"  join estado_examen_postulantes i  "& vbCrLf &_
					    "    on  b.eepo_ccod  = i.eepo_ccod "& vbCrLf &_
						"  left outer join observaciones_postulacion j "& vbCrLf &_
						"    on  b.post_ncorr= j.post_ncorr and b.ofer_ncorr = j.ofer_ncorr    "& vbCrLf &_
						"  left outer join estado_observaciones_postulacion k "& vbCrLf &_
						"    on  isnull(j.eopo_ccod,1) = k.eopo_ccod    "& vbCrLf &_
						" where cast(a.pers_ncorr as varchar)='"&codigo&"' "& vbCrLf &_
						" and cast(a.peri_ccod as varchar)='"&periodo&"' "
						
'response.Write("<pre>"&consulta_postulacion&"</pre>")
datos_postulacion.Consultar consulta_postulacion
'----------------------------------------------------------FAMILIARES-------------------------------------------------------------
Sql_parientes = "  Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar, " & VBCRLF  	& _
					    " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, pp.pers_fnacimiento as fecha_nacimiento,  " & VBCRLF  	& _
					    " pare.pare_tdesc as parentesco " & VBCRLF  	& _
						" from postulantes pos join  grupo_familiar gf " & VBCRLF  	& _
						"    on pos.post_ncorr = gf.post_ncorr " & VBCRLF  	& _
					    " join  personas_postulante pp  " & VBCRLF  	& _
				        "    on gf.pers_ncorr = pp.pers_ncorr " & VBCRLF  	& _
						" join  parentescos pare  " & VBCRLF  	& _
				        "    on pare.pare_ccod = gf.pare_ccod " & VBCRLF  	& _
					    " left outer join antecedentes_personas ap " & VBCRLF  	& _
					    "    on pp.pers_ncorr= ap.pers_ncorr " & VBCRLF  	& _
					    " Where cast(pos.pers_ncorr as varchar) = '"&codigo&"' " & VBCRLF  	& _
						" and cast(pos.peri_ccod as varchar) = '"&periodo&"' " 
'response.Write("<pre>"&Sql_parientes&"</pre>")

set f_grupo_familiar = new CFormulario
f_grupo_familiar.Carga_Parametros "apoyo_postulacion.xml", "grilla_familiares"
f_grupo_familiar.Inicializar conexion
f_grupo_familiar.Consultar Sql_parientes

'----------------------------------------------------------CODEUDOR-------------------------------------------------------------
Sql_codeudor = "  Select pp.pers_ncorr, pp.pers_tnombre+' '+ pp.pers_tape_paterno+' '+pp.pers_tape_materno as nombre_familiar, " & VBCRLF  	& _
					    " cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as rut_familiar, pp.pers_fnacimiento as fecha_nacimiento,  " & VBCRLF  	& _
					    " pare.pare_tdesc as parentesco " & VBCRLF  	& _
						" from postulantes pos join  codeudor_postulacion gf " & VBCRLF  	& _
						"    on pos.post_ncorr = gf.post_ncorr " & VBCRLF  	& _
					    " join  personas_postulante pp  " & VBCRLF  	& _
				        "    on gf.pers_ncorr = pp.pers_ncorr " & VBCRLF  	& _
						" join  parentescos pare  " & VBCRLF  	& _
				        "    on pare.pare_ccod = gf.pare_ccod " & VBCRLF  	& _
					    " Where cast(pos.pers_ncorr as varchar) = '"&codigo&"' " & VBCRLF  	& _
						" and cast(pos.peri_ccod as varchar) = '"&periodo&"' " 
'response.Write("<pre>"&Sql_parientes&"</pre>")

set f_codeudor = new CFormulario
f_codeudor.Carga_Parametros "apoyo_postulacion.xml", "grilla_familiares"
f_codeudor.Inicializar conexion
f_codeudor.Consultar Sql_codeudor

'---------------obtenemos los valores de identificacion del alumno
set f_valores_usuario = new CFormulario
f_valores_usuario.Carga_Parametros "tabla_vacia.xml", "tabla"
f_valores_usuario.Inicializar conexion

if codigo<>"" then
	f_valores_usuario.Consultar "select * from usuarios where cast(pers_ncorr as varchar)= '"&codigo&"'"
	f_valores_usuario.Siguiente
	usuario = f_valores_usuario.obtenervalor("usua_tusuario")
	clave   = f_valores_usuario.obtenervalor("usua_tclave")
end if

tiene_postulacion = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from postulantes where cast(pers_ncorr as varchar)='"&codigo&"' and cast(peri_ccod as varchar)='"&periodo&"'")
semestre = conexion.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
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

<script language="JavaScript">

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Alumno</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<%if rut <> "" then%>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
                  <%if rut <> "" and (usuario <> "" and clave <>"") then%>
				  <table width="100%" border="0">
                    <tr> 
                      <td align="left" colspan="3">&nbsp;</td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>R.U.T.</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=rut_completo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Nombre</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=nombre%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Sexo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=sexo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Pa&iacute;s</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pais%></td>
					</tr>
                  </table>
				  <%end if%>
				  <table width="100%" border="0">
                    <tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<form name="edicion">
					  <input type="hidden" name="usuario" value="<%=usuario%>">
					  <input type="hidden" name="clave" value="<%=clave%>">
					  <input type="hidden" name="pers_ncorr" value="<%=codigo%>">
					<%if usuario<>"" and clave<>"" and tiene_postulacion = "S"  then%>
					<tr> 
                      <td align="left">- Informaci&oacute;n de postulaciones de la persona.</td>
                    </tr>
					<tr> 
						<td>
							<div align="center">
							  <%datos_postulacion.DibujaTabla %>
							</div>
						 </td>
                    </tr>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">- Integrantes del grupo Familiar ingresados.</td>
                    </tr>
					<tr> 
						<td>
							<div align="center">
							  <%f_grupo_familiar.DibujaTabla %>
							</div>
						 </td>
                    </tr>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">- Sostenedor econ&oacute;mico.</td>
                    </tr>
					<tr> 
						<td>
							<div align="center">
							  <%f_codeudor.DibujaTabla %>
							</div>
						 </td>
                    </tr>
					<% botonera.agregaBotonParam "siguiente","url","../matricula/proc_apoyo_postulacion.asp"
					   end if
					%>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					</form>
					<%if usuario="" or clave="" then
					  botonera.agregaBotonParam "siguiente","url","../postulacion/inicio.asp?tipo=1&peri=2"%>
					<tr> 
                      <td align="Center"><font color="#0000FF" size="2">Esta Persona no se encuentra registrada en el sistema</font></td>
                    </tr>
					<% end if%>
					<%if tiene_postulacion="N" then
					  botonera.agregaBotonParam "siguiente","url","../postulacion/inicio.asp?tipo=1&peri=2"%>
					<tr> 
                      <td align="Center"><font color="#0000FF" size="2">La Persona no presenta postulación para el semestre consultado (<%=semestre%>)</font></td>
                    </tr>
					<% end if%>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
                  </table> 
                  
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="94%"> <%  botonera.dibujaboton "salir"%>
                      </td>
					  <td><div align="center"><%botonera.DibujaBoton("siguiente")%></div></td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<%end if%>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
