<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
dias_ccod = request.QueryString("busqueda[0][dias_ccod]")
hora_ccod = request.QueryString("busqueda[0][hora_ccod]")
sede_ccod = request.QueryString("busqueda[0][sede_ccod]")
set pagina = new CPagina
pagina.Titulo = "Salas libres de la Universidad"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

peri_ccod = negocio.obtenerPeriodoAcademico("Planificacion")
set botonera = new CFormulario
botonera.Carga_Parametros "salas_libres.xml", "botonera"

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "salas_libres.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.AgregaCampoCons "dias_ccod", dias_ccod 
 f_busqueda.AgregaCampoCons "hora_ccod", hora_ccod 
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod 
 f_busqueda.Siguiente

dias_tdesc = conexion.consultaUno("Select dias_tdesc from dias_semana where cast(dias_ccod as varchar)='"&dias_ccod&"'")
hora_tdesc = conexion.consultaUno("Select hora_tdesc from horarios where cast(hora_ccod as varchar)='"&hora_ccod&"'")  
peri_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
if sede_ccod <> "" then
	sede_tdesc = conexion.consultaUno("Select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
	filtro_sede = " and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" 
else
	sede_tdesc = "Todas las sedes"
	filtro_sede = " " 	
end if
plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
if plec_ccod <> "1" then
	anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
	primer_periodo = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1 ")
else
	primer_periodo= peri_ccod
end if
'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de salas libres para el horario consultado
set salas = new CFormulario
salas.Carga_Parametros "salas_libres.xml", "salas"
salas.Inicializar conexion
if dias_ccod <> "" and hora_ccod <> "" then
	consulta_salas =  " select sala_ccod, sala_tdesc as sala,c.tsal_tdesc as tipo,sala_ncupo as cupo,b.sede_tdesc as sede " & vbCrLf &_ 
					  "	from salas a, sedes b,tipos_sala c " & vbCrLf &_
					  "	where sala_ccod not in (select sala_ccod from bloques_horarios a, secciones b,asignaturas c " & vbCrLf &_
					  "	where cast(a.hora_ccod as varchar)='"&hora_ccod&"' and a.secc_ccod = b.secc_ccod and b.asig_ccod = c.asig_ccod" & vbCrLf &_
					  "	and cast(b.peri_ccod as varchar)= case duas_ccod when 3 then '"& primer_periodo &"' else '"&peri_ccod&"' end  and cast(dias_ccod as varchar)='"&dias_ccod&"') " & vbCrLf &_
					  "	and a.sede_ccod=b.sede_ccod and a.tsal_ccod=c.tsal_ccod "&filtro_sede & vbCrLf &_
					  "	and exists (select 1 from bloques_horarios bh where bh.sala_ccod=a.sala_ccod) " & vbCrLf &_
					  "	order by sala_tdesc asc "
else
	consulta_salas = " select sala_ccod,sala_tdesc from salas where 1=2 "
end if				  

'response.Write("<pre>"&consulta_salas&"</pre>")
'response.End()
salas.Consultar consulta_salas


'------------------------------------------------------------------------------------------------------
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
                                      <td width="98"><strong>Día de la Semana</strong></td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("dias_ccod") %>
                                        </font></td>
                                    </tr>
									<tr> 
                                      <td width="98"><strong>Bloque Horario</strong></td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("hora_ccod") %>
                                        </font></td>
                                    </tr>
									<tr> 
                                      <td width="98"><strong>Sede</strong></td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("sede_ccod") %>
                                        </font></td>
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
                 
				  <table width="100%" border="0">
				  <%if dias_ccod <> "" and hora_ccod <> "" then %>
                    <tr><td colspan="3">&nbsp;</td></tr>
				    <tr> 
                      <td align="left" width="15%"><strong>Día</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td width="83%" align="left"><%=dias_tdesc%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Bloque</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=hora_tdesc%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Sede</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=sede_tdesc%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Periodo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td width="83%" align="left"><%=peri_tdesc%></td>
					</tr>
				 <%end if%>	
				 <table width="100%" border="0">
                    <tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">- Listado de Salas libres en el horario seleccinado.</td>
                    </tr>
					<tr><td align="right">Página: <%salas.AccesoPagina%></td></tr>
					<tr> 
						<td><form name="edicion">
							<div align="center">
							  <% salas.DibujaTabla %>
							</div>
						  </form>
						 </td>
                    </tr>
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
					   <td width="6%"><%botonera.agregabotonparam "excel", "url", "salas_libres_excel.asp?dias_ccod="&dias_ccod&"&hora_ccod="&hora_ccod&"&sede_ccod="&sede_ccod
								  botonera.dibujaboton "excel"%></td>
                       <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<%'end if%>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
