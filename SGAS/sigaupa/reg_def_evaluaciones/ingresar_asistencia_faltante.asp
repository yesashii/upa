<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso de asistencia tardía"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set errores 	= new cErrores
secc_ccod = request.querystring("secc_ccod")
fecha = request.querystring("fecha")
set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Planificacion")

ano_seleccionado = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
ano_actual = conexion.consultaUno("Select datepart(year,getDate())")
peri = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_seleccionado&"' and plec_ccod=1 ")
dias_tdesc = conexion.consultaUno("select dias_tdesc + ' ("&fecha&")' from dias_semana where dias_ccod=datePart(weekday,convert(datetime,'"&fecha&"',103))")

'---------------------------------------------------------------------------------------------------

'response.write(fecha)

'--------------------------------------------------------------------------
asignatura = conexion.consultaUno("select ltrim(rtrim(b.asig_ccod)) +' --> '+b.asig_tdesc from secciones a, asignaturas b where  a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")
'dias_tdesc = conexion.consultaUno("select dias_tdesc from dias_semana where dias_ccod=datePart(weekday,getDate())")
seccion = conexion.consultaUno("select secc_tdesc from secciones where  cast(secc_ccod as varchar)='"&secc_ccod&"'")
total_alumnos = conexion.consultaUno("select count(*) from cargas_academicas where cast(secc_ccod as varchar)='"&secc_ccod&"'")
total_bloques = conexion.consultaUno("select count(*) from bloques_horarios where  cast(secc_ccod as varchar)='"&secc_ccod&"' and dias_ccod = datePart(weekday,getDate())")
rut = conexion.consultaUno("select pers_nrut from bloques_horarios a, bloques_profesores b,personas c where cast(a.secc_ccod as varchar)='"&secc_ccod&"' and a.bloq_ccod=b.bloq_ccod and b.pers_ncorr=c.pers_ncorr and b.tpro_ccod=1")
nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&rut&"'")
'response.Write(total_bloques)
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "seleccionar_curso_asistencia.xml", "botonera"
'--------------------------------------------------------------------------
'response.End()
libro_abierto = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from asistencia_diaria where cast(secc_ccod as varchar)='"&secc_ccod&"' and protic.trunc(fecha_ingreso)='"&fecha&"'")
'response.Write("select case count(*) when 0 then 'NO' else 'SI' end from asistencia_diaria where cast(secc_ccod as varchar)='"&secc_ccod&"' and protic.trunc(fecha_ingreso)='"&fecha&"'")
'response.End()
if libro_abierto = "NO" then
	adia_ncorr = conexion.consultaUno("select isnull(max(adia_ncorr),0) + 1 from asistencia_diaria")
	c_insert = " insert into asistencia_diaria (adia_ncorr,secc_ccod,fecha_ingreso,estado_registro,observacion_abrir)"&_
	           " values ("&adia_ncorr&","&secc_ccod&",convert(datetime,'"&fecha&"',103),1,'ajuste faltante')"
	conexion.ejecutaS (c_insert)	
else
	adia_ncorr = conexion.consultaUno("select adia_ncorr from asistencia_diaria where cast(secc_ccod as varchar)='"&secc_ccod&"' and protic.trunc(fecha_ingreso)='"&fecha&"'")		   
end if

set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion 

consulta = "  select distinct c.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, " &vbcrlf &_
		   "  c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', '+c.pers_tnombre as alumno " &vbcrlf &_
		   "  from cargas_academicas a, alumnos b, personas c " &vbcrlf &_
		   "  where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr " &vbcrlf &_
		   "  and cast(secc_ccod as varchar)='"&secc_ccod&"' " &vbcrlf &_
		   "  order by alumno "
		   
formulario.Consultar consulta

set formulario_bloques = new CFormulario
formulario_bloques.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario_bloques.Inicializar conexion 

consulta2 = "  select hora_ccod , bloq_ccod " &vbcrlf &_
		   "  from bloques_horarios " &vbcrlf &_
		   "  where cast(secc_ccod as varchar)='"&secc_ccod&"' " &vbcrlf &_
   		   "  and dias_ccod  =  datePart(weekday,convert(datetime,'"&fecha&"',103))" &vbcrlf &_
		   "  order by hora_ccod asc "

formulario_bloques.Consultar consulta2

grabado = conexion.consultaUno("Select count(*) from detalle_asistencia_diaria where cast(adia_ncorr as varchar)='"&adia_ncorr&"'")

sede_ccod=conexion.consultaUno("select sede_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
jorn_ccod=conexion.consultaUno("select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
carr_ccod=conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")

url_retorno = "registro_asistencias_pasadas.asp?busqueda[0][SEDE_CCOD]="&sede_ccod&"&busqueda[0][CARR_CCOD]="&carr_ccod&"&busqueda[0][JORN_CCOD]="&jorn_ccod&"&busqueda[0][SECC_CCOD]="&secc_ccod&""  
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
 colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; 
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

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
   if (rut.length==7) rut = '0' + rut; 

   //alert(rut);
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["busqueda[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
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
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Carga de asignaturas diarias</font></div></td>
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
					<br><br>
                  </div>
                  <table  width="100%" border="0">
				   <%if not esVacio(rut) then%>
					<tr> 
                      <td width="15%"><strong>Nombre Docente</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><font color="#993300"><%=nombre_docente%></font></td>
                    </tr>
                    <tr> 
                      <td width="15%"><strong>Asignatura</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><font color="#993300"><%=asignatura%></font></td>
                    </tr>
                    <tr> 
                      <td width="15%"><strong>Sección</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><font color="#993300"><%=seccion%></font></td>
                    </tr>
                    <tr> 
                      <td width="15%"><strong>Total Alumnos</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><font color="#993300"><%=total_alumnos%></font></td>
                    </tr>
                    <tr> 
                      <td width="15%"><strong>Día</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><font color="#993300"><strong><%=dias_tdesc%></strong></font></td>
                    </tr>
					<%end if%>
                    <tr>
                    	<td colspan="3" align="center">&nbsp;</td>
                    </tr> 
                    <tr>
                    	<td colspan="3" align="center" bgcolor="#993300">
                            <font color="#FFFFFF" size="2">
                            	<strong>
                                 DESMARQUE los alumnos que NO asistieron a clases.-
                            	</strong>
                            </font>
                        </td>
                    </tr>   
                    <tr>
                    	<td colspan="3" align="center">
                        <form name="edicion">
                            <input type="hidden" name="secc_ccod" value="<%=secc_ccod%>">
                            <input type="hidden" name="adia_ncorr" value="<%=adia_ncorr%>">
                            <input type="hidden" name="fecha" value="<%=fecha%>">
                            <div align="center">
                              <%
                                response.Write("<table align='center' width='90%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>")
                                response.Write("<tr borderColor=#999999 bgColor=#c4d7ff>")
								response.Write("  <TH><FONT color=#333333>N°</FONT></TH>")
                                response.Write("  <TH><FONT color=#333333>Rut</FONT></TH>")
                                response.Write("  <TH><FONT color=#333333>Nombre_alumno</FONT></TH>")
                                while formulario_bloques.siguiente
									hora = formulario_bloques.obtenerValor("hora_ccod")
                                    response.Write("<TH><FONT color=#333333>Módulo<hr>"&hora&"</FONT></TH>")
                                wend
								formulario_bloques.primero
                                response.Write("</tr>")
								contador = 1
								while formulario.siguiente
									pers_ncorr = formulario.obtenerValor("pers_ncorr")
									rut = formulario.obtenerValor("rut")
									nombre = formulario.obtenerValor("alumno")
									response.Write("<tr bgColor=#ffffff>")
									response.Write("  <td class='click' onmouseover='resaltar(this);' onmouseout='desResaltar(this);'>"&contador&"</td>")
									response.Write("  <td class='click' onmouseover='resaltar(this);' onmouseout='desResaltar(this);'>"&rut&"</td>")
									response.Write("  <td class='click' onmouseover='resaltar(this);' onmouseout='desResaltar(this);'>"&nombre&"</td>")
									while formulario_bloques.siguiente
									    bloque=formulario_bloques.obtenerValor("bloq_ccod")
										valor_grabado = conexion.consultaUno("select asiste from detalle_asistencia_diaria where cast(adia_ncorr as varchar)='"&adia_ncorr&"' and cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(bloq_ccod as varchar)='"&bloque&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
										if valor_grabado="0" then 
											response.Write("<td align='center' class='click' onmouseover='resaltar(this);' onmouseout='desResaltar(this);'><input type='checkbox' name='asiste_"&pers_ncorr&"_"&bloque&"' value='1'></td>")
										else
											response.Write("<td align='center' class='click' onmouseover='resaltar(this);' onmouseout='desResaltar(this);'><input type='checkbox' name='asiste_"&pers_ncorr&"_"&bloque&"' value='1' checked></td>")
										end if	
									wend
									formulario_bloques.primero
									response.Write("</tr>")
									contador = contador + 1
								wend
                                response.Write("</table>")
                               %>	
                            </div>
                          
                                
                        </td> 
                    </tr>
                    <tr><td colspan="3"><font color="#993300"><strong>Haga el favor de ingresar en el siguiente recuadro una breve descripción de las actividades desarrolladas durante el transcurso de la clase</strong></font></td></tr>
                    <tr>
                        <td colspan="3" align="center">
                           <%actividades = conexion.consultaUno(" select actividades_desarrolladas from asistencia_diaria where cast(adia_ncorr as varchar)='"&adia_ncorr&"'")%>
                           <TEXTAREA COLS="100" ROWS="5" NAME="actividades_desarrolladas" id="TO-N"><%=actividades%> 
                           </TEXTAREA>
                        </td>
                    </tr>
                    </form>
                  </table> 
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="65" nowrap bgcolor="#D8D8DE"><table width="53%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="33%">
                        <%  botonera.agregabotonParam "volver","url",url_retorno
						    botonera.dibujaboton "volver"%>
                      </td>
                      <td width="34%">
                        <%  botonera.dibujaboton "guardar_faltante"%>
                      </td>
                      <td width="33%">
                        <% if grabado <> "0" then
						     botonera.agregaBotonParam "excel","url","reporte_ingresar_asistencia_excel.asp?secc_ccod="&secc_ccod 
						     botonera.dibujaboton "excel"
						   end if%>
                      </td>
                    </tr>
                  </table></td>
                  <td width="345" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
