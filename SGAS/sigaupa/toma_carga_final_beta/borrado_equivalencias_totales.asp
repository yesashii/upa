<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_conexion_alumnos_02.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
q_peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Borrado de equivalencias totales"

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "borrado_equivalencias_totales.xml", "botonera"

set botonera = new CFormulario
botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "borrado_equivalencias_totales.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod
v_peri_ccod = q_peri_ccod

session("_actividad")= 7
session("_periodo_TOMACARGA") 	= v_peri_ccod
session("_periodo")= v_peri_ccod
		
usur= negocio.obtenerUsuario

'----------------------Si el periodo es segundo semestre debemos crear la matricula del alumno para tomarle ramos.
if not EsVacio(q_pers_nrut) then
    pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")

rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "borrado_equivalencias_totales.xml", "carga_tomada"
f_alumno.Inicializar conexion

consulta = " select distinct ltrim(rtrim(c.asig_ccod)) + '--' + c.asig_tdesc as asignatura_cursada,  " & vbCrLf &_
		   " ltrim(rtrim(asi.asig_ccod)) + '--' + asi.asig_tdesc as asignatura_plan,a.matr_ncorr,a.secc_ccod,  " & vbCrLf &_
		   " '<a href=""javascript:liberar('+ cast(a.matr_ncorr as varchar) + ',' + cast(a.secc_ccod as varchar) + ')"">Liberar</a>'  as liberar,"& vbCrLf &_
		   " '<a href=""javascript:eliminar('+ cast(a.matr_ncorr as varchar) + ',' + cast(a.secc_ccod as varchar) + ')"">Eliminar TODO</a>'  as eliminar"& vbCrLf &_
		   " from cargas_academicas a, secciones b, asignaturas c, alumnos d, personas e, ofertas_academicas f,  " & vbCrLf &_
		   " equivalencias eq, malla_curricular mc, asignaturas asi   " & vbCrLf &_
		   " where a.secc_ccod=b.secc_ccod and a.matr_ncorr=d.matr_ncorr and d.pers_ncorr=e.pers_ncorr   " & vbCrLf &_
		   " and cast(e.pers_nrut as varchar)='"&q_pers_nrut&"'   " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod and d.ofer_ncorr=f.ofer_ncorr and cast(f.peri_ccod as varchar)='"&v_peri_ccod&"'  " & vbCrLf &_
		   " and eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod  " & vbCrLf &_
		   " and eq.mall_ccod=mc.mall_ccod and mc.asig_ccod=asi.asig_ccod " 
'response.Write("<pre>"&consulta&"</pre>")		   
f_alumno.Consultar consulta

set f_erradas = new CFormulario
f_erradas.Carga_Parametros "borrado_equivalencias_totales.xml", "erradas"
f_erradas.Inicializar conexion

consulta = "  select (select ltrim(rtrim(t2.asig_ccod)) + '--' + t2.asig_tdesc  " & vbCrLf &_
		   "         from secciones tt, asignaturas t2 where tt.secc_ccod=a.secc_ccod and tt.asig_ccod=t2.asig_ccod) as asignatura_cursada,  " & vbCrLf &_
		   " '<a href=""javascript:liberar('+ cast(a.matr_ncorr as varchar) + ',' + cast(a.secc_ccod as varchar) + ')"">Liberar</a>'  as liberar,"& vbCrLf &_
		   " ltrim(rtrim(c.asig_ccod)) + '--' + c.asig_tdesc as asignatura_plan,a.matr_ncorr,a.secc_ccod           " & vbCrLf &_
		   " from equivalencias a, malla_curricular b, asignaturas c, alumnos d, personas e, ofertas_academicas f  " & vbCrLf &_
		   " where a.mall_ccod=b.mall_ccod and a.asig_ccod=b.asig_ccod and b.asig_ccod=c.asig_ccod  " & vbCrLf &_
		   " and a.matr_ncorr=d.matr_ncorr and d.pers_ncorr=e.pers_ncorr   " & vbCrLf &_
		   " and d.ofer_ncorr=f.ofer_ncorr  " & vbCrLf &_
		   " and not exists (select 1 from cargas_academicas t3 where t3.matr_ncorr=a.matr_ncorr and t3.secc_ccod=a.secc_ccod)  " & vbCrLf &_
		   " and cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' and cast(f.peri_ccod as varchar)='"&v_peri_ccod&"'  "

'response.Write("<pre>"&consulta&"</pre>")		   
f_erradas.Consultar consulta

session("pers_ncorr_alumno") = pers_ncorr_temporal

url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&ocultar=1"

tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")	
else
    nombre_foto = "user.png"
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

<script language="JavaScript">
function dibujar(formulario)
{
	  formulario.submit();
}
function ver_notas()
{
	  self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario()
{
	  self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function imprimir() 
{
	  var direccion;
	  direccion="impresion_carga.asp";
	  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
}
function liberar(matricula,seccion)
{
	  var formulario = document.edicion;
	  formulario.action = "borrado_equivalencias_totales_liberar.asp?matr_ncorr="+matricula+"&secc_ccod="+seccion;
	  if (confirm("L I B E R A R\n¿Está seguro que desea liberar ésta equivalencia?\nSi lo hace podrá volver a asignar la carga a otra asignatura del plan"))
	  {
	      formulario.submit();
	  }	  
}
function eliminar(matricula,seccion)
{
	  var formulario = document.edicion;
	  formulario.action = "borrado_equivalencias_totales_eliminar.asp?matr_ncorr="+matricula+"&secc_ccod="+seccion;
	  if (confirm("----E L I M I N A R   T O D O----\n¿Está seguro que desea eliminar por completo ésta equivalencia?\nSi lo hace se eliminará la CARGA, NOTAS PARCIALES, FINALES y la equivalencia correspondiente"))
	  {
	      formulario.submit();
	  }	  
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Toma de Asignaturas Escuela"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                      </tr>
					  <tr>
                        <td><div align="right"><strong>Périodo</strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DIbujaCampo("peri_ccod")%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<br>
	<%IF q_pers_nrut <> "" then %>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				 <tr valign="top">
				 	<td colspan="3">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="85%" align="left">
									<table width="100%" cellpadding="0" cellspacing="0">
									 <tr>
										<td colspan="3">
											<div align="center"><br>
											  <%pagina.Titulo = "Equivalencias Registradas <br>(" &peri_tdesc&")"
												pagina.DibujarTituloPagina%><br>
											</div>
										</td>
									  </tr>
									  <tr>
										<td colspan="3">&nbsp;<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
										<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
										</td>
									  </tr>
									  <tr>
										<td colspan="3">&nbsp;</td>
									  </tr>
									  <%if q_pers_nrut <> "" then %>
									  <tr>
										<td width="13%"><strong>Rut</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td width="86%"><%=rut%></td>
									  </tr>
									  <tr>
										<td width="13%"><strong>Nombre</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td><%=nombre%></td>
									  </tr>
									  <%end if%>
									</table>
								</td>
								<td width="15%" align="center">
									<br><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
								</td>
							</tr>
						</table>
					</td>
				 </tr>
                  
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%'if f_alumno.nroFilas > 0 then %>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Equivalencias Registradas"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">Pagina <%f_alumno.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <%'end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%'if f_erradas.nroFilas > 0 then %>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Equivalencias mal borradas"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">Pagina <%f_erradas.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_erradas.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <%'end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				</table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  <td><div align="center">
                    <% botonera.DibujaBoton "NOTAS"%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<%end if ' para ocultar el cuadro cuando no han ingresado el Rut%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
