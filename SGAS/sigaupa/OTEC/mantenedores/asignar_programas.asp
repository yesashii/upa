<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
detalle = request.querystring("detalle")
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/asignar_programas.asp?dcur_ncorr="&dcur_ncorr
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Asignar participantes a Programas"

set botonera =  new CFormulario
botonera.carga_parametros "asignar_programas.xml", "btn_busca_asignaturas"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "asignar_programas.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 f_busqueda.AgregaCampoCons "DCUR_NCORR", DCUR_NCORR
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "asignar_programas.xml", "seleccionar_programa"
formulario.inicializar conexion

consulta = "select '' as dcur_ncorr"

formulario.consultar consulta 
formulario.siguiente

c_diplomados = "(select distinct dcur_ncorr as dcur_ncorr_a_emular,dcur_tdesc "&_
			   " from diplomados_cursos a "&_
			   " where (select count(*) from mallas_otec tt where tt.dcur_ncorr = a.dcur_ncorr) > 1 "&_
			   " and not exists (select 1 from programas_asociados tt where tt.dcur_ncorr_origen = a.dcur_ncorr) "&_
			   " and cast(a.dcur_ncorr as varchar) <> '"&DCUR_NCORR&"') ta "
			   
formulario.agregaCampoParam "dcur_ncorr_a_emular","destino",c_diplomados

'-----------------------------------------Relación de programas----------------------------------------------------------
set formulario_relaciones = new cformulario
formulario_relaciones.carga_parametros "asignar_programas.xml", "f_relaciones"
formulario_relaciones.inicializar conexion

consulta =" select b.dcur_ncorr, b.dcur_tdesc, 'N' as orden, " & vbCrlf & _
          " (select count(*)  " & vbCrlf & _
 		  " from datos_generales_secciones_otec tt, postulacion_otec t2  " & vbCrlf & _
		  " where tt.dcur_ncorr = b.dcur_ncorr and tt.dgso_ncorr=t2.dgso_ncorr and t2.epot_ccod=4) as matriculados  " & vbCrlf & _
		  " from diplomados_cursos b where cast(b.dcur_ncorr as varchar) = '"&DCUR_NCORR&"' " & vbCrlf & _
		  "	union " & vbCrlf & _
		  "	select b.dcur_ncorr, b.dcur_tdesc,cast(a.DCUR_NORDEN as varchar) as orden, " & vbCrlf & _
		  " (select count(*)  " & vbCrlf & _
		  " from datos_generales_secciones_otec tt, postulacion_otec t2  " & vbCrlf & _
		  " where tt.dcur_ncorr = b.dcur_ncorr and tt.dgso_ncorr=t2.dgso_ncorr and t2.epot_ccod=4) as matriculados  " & vbCrlf & _
		  "	from programas_asociados a, diplomados_cursos b " & vbCrlf & _
		  "	where a.dcur_ncorr_origen = b.dcur_ncorr " & vbCrlf & _
		  "	and cast(a.dcur_ncorr as varchar)= '"&DCUR_NCORR&"' " & vbCrlf & _
		  "	order by orden " 

'response.write("<pre>"&consulta&"</pre>")
formulario_relaciones.consultar consulta 

'-----------------------------------------programas del diplomado o curso----------------------------------------------------------
set formulario_alumnos = new cformulario
formulario_alumnos.carga_parametros "asignar_programas.xml", "f_alumnos"
formulario_alumnos.inicializar conexion

consulta =" select b.pers_ncorr,b.pote_ncorr,cast(c.pers_nrut as varchar) + '-' + c.pers_xdv as Rut, " & vbCrlf & _
		  " c.pers_tape_paterno + ' ' +  c.pers_tape_materno + ', ' + c.pers_tnombre as alumno,'P' as tipo  " & vbCrlf & _
		  " from datos_generales_secciones_otec a, postulacion_otec b, personas c  " & vbCrlf & _
		  " where a.dgso_ncorr=b.dgso_ncorr and b.pers_ncorr=c.pers_ncorr   " & vbCrlf & _
		  " and cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"' " & vbCrlf & _
		  " and b.epot_ccod = 4  " & vbCrlf & _
		  " union " & vbCrlf & _
		  " select b.pers_ncorr,max(b.pote_ncorr) as pote_ncorr,cast(c.pers_nrut as varchar) + '-' + c.pers_xdv as Rut,  " & vbCrlf & _
		  " c.pers_tape_paterno + ' ' +  c.pers_tape_materno + ', ' + c.pers_tnombre as alumno,'D' as tipo  " & vbCrlf & _
		  " from datos_generales_secciones_otec a, postulacion_otec b, personas c  " & vbCrlf & _
		  " where a.dgso_ncorr=b.dgso_ncorr and b.pers_ncorr=c.pers_ncorr   " & vbCrlf & _
		  " and a.dcur_ncorr in (select tt.dcur_ncorr_origen from programas_asociados tt where cast(tt.dcur_ncorr as varchar)= '"&DCUR_NCORR&"') " & vbCrlf & _
		  " and b.epot_ccod = 4 " & vbCrlf & _
		  " and not exists (select 1  " & vbCrlf & _
		  "	  			    from datos_generales_secciones_otec tr, postulacion_otec te " & vbCrlf & _
		  "				    where tr.dgso_ncorr=te.dgso_ncorr and te.pers_ncorr=b.pers_ncorr and te.epot_ccod = 4 " & vbCrlf & _
	      "				    and cast(tr.dcur_ncorr as varchar)='"&DCUR_NCORR&"') " & vbCrlf & _
		  "	group by b.pers_ncorr,c.pers_nrut, c.pers_xdv, c.pers_tape_paterno, c.pers_tape_materno, c.pers_tnombre " & vbCrlf & _
		  " order by alumno " 

'response.write("<pre>"&consulta&"</pre>")
formulario_alumnos.consultar consulta

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")

dim arreglo_colores(21) 
arreglo_colores(0)="#F8E0E0"
arreglo_colores(1)="#E0F8E0"
arreglo_colores(2)="#E0E0F8"
arreglo_colores(3)="#F8E0E0"
arreglo_colores(4)="#E0F8E0"
arreglo_colores(5)="#E0ECF8"

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
function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=650,height=450,scrollbars=yes, left=380, top=150");
	
 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=650,height=450,scrollbars=yes, left=380, top=100");
	
 // window.close();
}
function enviar2(formulario) {
	//direccion = "m_diplomados_curso.asp?detalle=1";
	//alert("direccion "+direccion);
	formulario.elements["detalle"].value="1";
	//formulario.action = direccion;
	formulario.submit();
}
function salir(){
window.close()
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>

<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="95%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Programa</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("dcur_ncorr") %></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center">&nbsp;</td>
										<td width="50%" align="center"><%botonera.dibujaboton "buscar"%></td>
									  </tr>
				                  </table>
			       </td>
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
	</td>
	</tr>
	</table>
	</td></tr>
	
	
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
    <%if DCUR_NCORR <> "" then %>
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                    </tr>
  
				  <%if (dcur_ncorr <> "" ) and detalle = "2"  then %>
                  <form name="edicion_relacion">
                  <tr>
                    <td align="left"><strong>PROGRAMAS ASOCIADOS</strong></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="left">
                    	<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
							<table class=v1 width='98%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_em'>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<th><font color='#333333'>Programa destino</font></th>
								<th><font color='#333333'>N°</font></th>
								<th><font color='#333333'>Matriculados</font></th>
								<th><font color='#333333'>Color</font></th>
							</tr>
							<%fila=0
							  color_celda = "#FFFFFF"
							  while formulario_relaciones.siguiente
							  dcur_tdesc = formulario_relaciones.obtenerValor("dcur_tdesc")
							  orden = formulario_relaciones.obtenerValor("orden")
							  matriculados   = formulario_relaciones.obtenerValor("matriculados")
							  color_celda = arreglo_colores(fila)
							  fila = fila + 1
							  %>
							<tr bgcolor="#FFFFFF">
							    <td class='click'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=dcur_tdesc%></td>
								<td class='click'align='CENTER' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=orden%></td>
								<td class='click'align='CENTER' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=matriculados%></td>
								<td width='10' align='center' bgcolor="<%=color_celda%>">&nbsp;</td>
							</tr>
							<%wend%>
							</table>
                    </td>
                  </tr>
                  </form>
                  <tr>
                    <td align="right">&nbsp;</td>
                  </tr>
                  <form name="edicion_programas">
                  <input type="hidden" name="dcur_ncorr" value="<%=dcur_ncorr%>">
                  <tr>
                    <td align="left"><strong>Alumnos asociados y por asociar</strong></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td align="left">
                    	<table class=v1 width='98%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_eme'>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<th><font color='#333333'>Rut</font></th>
								<th><font color='#333333'>Nombre alumno</font></th>
                                <%fila=0
								  color_celda = "#FFFFFF"
								  formulario_relaciones.primero
								  while formulario_relaciones.siguiente
								  orden_i = formulario_relaciones.obtenerValor("orden")
								  color_celda = arreglo_colores(fila)
								  fila = fila + 1
								%>
								  <th align="center" bgcolor="<%=color_celda%>"><font color='#333333'>Programa<br><%=orden_i%></font></th>
								 <%wend%>
							</tr>
							<%fila=0
							  color_celda = "#FFFFFF"
							  while formulario_alumnos.siguiente
							  rut = formulario_alumnos.obtenerValor("rut")
							  nombre = formulario_alumnos.obtenerValor("alumno")
							  pers = formulario_alumnos.obtenerValor("pers_ncorr")
							  pote = formulario_alumnos.obtenerValor("pote_ncorr")
							  tipo = formulario_alumnos.obtenerValor("tipo")
							  color_celda = arreglo_colores(fila)
							  fila = fila + 1
							  %>
							<tr bgcolor="#FFFFFF">
							    <td class='click'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=rut%></td>
								<td class='click'align='LEFT' width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><%=nombre%><input type="hidden" name="pote_ncorr" value="<%=pote%>"></td>
                                <%fila=0
								  color_celda = "#FFFFFF"
								  formulario_relaciones.primero
								  cumple = 0
								  while formulario_relaciones.siguiente
								    dc = formulario_relaciones.obtenerValor("dcur_ncorr")
									orden_j = formulario_relaciones.obtenerValor("orden")
									color_celda = arreglo_colores(fila)
									fila = fila + 1
									matriculado = conexion.consultaUno("select count(*) from datos_generales_secciones_otec a, postulacion_otec b where a.dgso_ncorr=b.dgso_ncorr and cast(b.pers_ncorr as varchar)='"&pers&"' and cast(a.dcur_ncorr as varchar)='"&dc&"' and b.epot_ccod=4 ")
									matriculado_2 = conexion.consultaUno("select count(*) from datos_generales_secciones_otec a, postulacion_asociada_otec b where a.dgso_ncorr=b.dgso_ncorr and cast(b.pers_ncorr as varchar)='"&pers&"' and cast(a.dcur_ncorr as varchar)='"&dc&"' and b.epot_ccod=4 ")
									if matriculado <> "0" or matriculado_2 <> "0" then
										chequeado = "checked"
										if orden_j <> "N" then
											cumple    = cumple + 1
										end if
									else
										chequeado = ""
									end if
									
									bloqueado = ""
									if cumple < formulario_relaciones.nroFilas -1 and tipo="D" and orden_j = "N" then
										bloqueado = "Disabled"	
									end if
									
									if matriculado = "0" and matriculado_2 = "0" and orden_j <> "N" and tipo="D" then
										bloqueado = "Disabled"
									end if
									
									color_check = color_celda
									if matriculado <> "0" then
									 color_check = "#FFFF66;"
									end if
								
								   %>
								   <td class='click'align='CENTER' bgcolor="<%=color_celda%>" width='' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'>
											  		<input type="checkbox" name="m[<%=pers%>][prog_<%=dc%>]" value="<%=orden_j%>" <%=chequeado%> <%=bloqueado%> style="background:<%=color_check%>;">

								   </td>
								  <% matriculado   = ""
								     matriculado_2 = ""
								wend%>
							</tr>
							<%wend%>
						</table>
                    </td>
                  </tr>
                  </form>
                  <tr>
                    <td align="right"><font color="#0000CC">* Marque los programas en que desea asociar al alumno.</font></td>
                  </tr>
                  <tr>
                    <td align="right"><font color="#0000CC">Las casillas bloqueadas indican que el alumno no cumple los requisitos para ser asociado.</font></td>
                  </tr>
                  <tr>
                    <td align="right"><%botonera.dibujaboton "guardar"%></td>
                  </tr>
				  <%end if%>
                </table>
                          <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%'botonera.dibujaboton "salir"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
    <%end if%>
    
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
