<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Prestamo y Devolución de libros de clases"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set errores 	= new cErrores

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Planificacion")
'peri = negocio.obtenerPeriodoAcademico("CLASES18")
'periodo="200"
ano_seleccionado = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
ano_actual = conexion.consultaUno("Select datepart(year,getDate())")
peri = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_seleccionado&"' and plec_ccod=1 ")

'response.Write(ano_seleccionado&" -- "&ano_actual)

if cint(ano_seleccionado)=cint(ano_actual) then
	correcto="S"
else
	correcto="N"
end if
'response.Write(correcto)		

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------



 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "asignaturas_diarias.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
 'response.End()
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "asignaturas_diarias.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "asignaturas_diarias.xml", "listado_diario"
formulario.Inicializar conexion 

consulta = " select a.pers_ncorr,d.secc_ccod,f.carr_tdesc as carrera, ltrim(rtrim(e.asig_ccod)) +' --> '+e.asig_tdesc as asignatura, "& vbcrlf & _
		   " g.dias_tdesc as dia,h.sala_tdesc+' - '+ i.sede_tdesc as sala,l.hora_tdesc as modulo, d.secc_tdesc as seccion, "& vbcrlf & _
		   " cast(isnull(j.libr_ncorr,0) as varchar) as libr_ncorr, case isnull(j.libr_ncorr,0) when 0 then '<b>Sin crear</b>' else k.esli_tdesc end as estado, "& vbcrlf & _
		   " cast(datepart(hh,hs.hora_hinicio) as varchar)+':'+cast(datepart(mi,hs.hora_hinicio) as varchar)+'--'+cast(datepart(hh,hs.hora_htermino) as varchar)+':'+cast(datepart(mi,hs.hora_htermino) as varchar) as horario,b.bloq_ccod"& vbcrlf & _
		   " from "& vbcrlf & _
		   "	 personas a join bloques_profesores b "& vbcrlf & _
		   " 	    on a.pers_ncorr=b.pers_ncorr  "& vbcrlf & _
		   "	 join bloques_horarios c "& vbcrlf & _
		   "	    on b.bloq_ccod=c.bloq_ccod "& vbcrlf & _
		   "	 join secciones d "& vbcrlf & _
		   "	    on c.secc_ccod=d.secc_ccod "& vbcrlf & _
		   "	 join asignaturas e "& vbcrlf & _
		   "	    on d.asig_ccod=e.asig_ccod "& vbcrlf & _
		   "	 join carreras f "& vbcrlf & _
		   "	    on d.carr_ccod=f.carr_ccod "& vbcrlf & _
		   "	 join dias_semana g "& vbcrlf & _
		   "	    on c.dias_ccod=g.dias_ccod "& vbcrlf & _
		   "	 join salas h "& vbcrlf & _
		   "	    on c.sala_ccod=h.sala_ccod "& vbcrlf & _
		   "	 join sedes i "& vbcrlf & _
		   "	    on h.sede_ccod= i.sede_ccod "& vbcrlf & _
		   "	 join horarios l "& vbcrlf & _
		   "	    on c.hora_ccod= l.hora_ccod "& vbcrlf & _
		   "	 join horarios_sedes hs "& vbcrlf & _
		   "	    on c.hora_ccod= hs.hora_ccod and d.sede_ccod=hs.sede_ccod  "& vbcrlf & _
		   "	 left outer join libros_clases j "& vbcrlf & _
		   "	    on d.secc_ccod=j.secc_ccod and d.sede_ccod=j.sede_ccod and d.carr_ccod=j.carr_ccod and d.jorn_ccod=j.jorn_ccod "& vbcrlf & _
		   "	    and d.asig_ccod=j.asig_ccod and b.pers_ncorr=j.pers_ncorr and d.peri_ccod=j.peri_ccod "& vbcrlf & _
		   "	 left outer join estado_libros k "& vbcrlf & _
		   "	    on  k.esli_ccod = 1 --isnull(j.libr_nestado,1) = k.esli_ccod "& vbcrlf & _
		   "	 where cast(a.pers_nrut as varchar)='"&rut&"' "& vbcrlf & _
		   "	 and datePart(weekday,getDate())=c.dias_ccod "& vbcrlf & _
		   "	 and cast(d.peri_ccod as varchar)= case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end"& vbcrlf & _
		   "     and not exists (select 1 from prestamos_libros cc where cc.bloq_ccod = c.bloq_ccod and cc.libr_ncorr = j.libr_ncorr and cc.pres_fdevolucion is null and cc.pres_estado_devolucion is null) " &vbcrlf &_
		   " union "& vbcrlf & _
		   " select a.pers_ncorr,d.secc_ccod,e.carr_tdesc as carrera,ltrim(rtrim(f.asig_ccod))+' --> '+ f.asig_tdesc as asignatura, "& vbcrlf & _
		   "        h.dias_tdesc as dia,i.sala_tdesc +' - ' + j.sede_tdesc as sala,k.hora_tdesc as modulo,d.secc_tdesc as seccion, "& vbcrlf & _
		   "        cast(b.libr_ncorr as varchar) as libr_ncorr,case b.libr_ncorr when null then 'Sin crear' else l.esli_tdesc end as estado,"& vbcrlf & _
		   "        cast(datepart(hh,m.hora_hinicio) as varchar)+':'+cast(datepart(mi,m.hora_hinicio) as varchar)+'--'+cast(datepart(hh,m.hora_htermino) as varchar)+':'+cast(datepart(mi,m.hora_htermino) as varchar) as horario,g.bloq_ccod"& vbcrlf & _
		   " from personas a,libros_clases b, prestamos_libros c,secciones d,carreras e,asignaturas f,bloques_horarios g, "& vbcrlf & _
		   "      dias_semana h,salas i, sedes j,horarios k,estado_libros l,horarios_sedes m "& vbcrlf & _
		   " where cast(a.pers_nrut as varchar)='"&rut&"' "& vbcrlf & _
		   " and a.pers_ncorr=b.pers_ncorr "& vbcrlf & _
		   " and b.libr_ncorr=c.libr_ncorr and c.pres_fdevolucion is null and c.pres_estado_devolucion is null "& vbcrlf & _
		   " and b.secc_ccod=d.secc_ccod "& vbcrlf & _
		   " and d.carr_ccod=e.carr_ccod "& vbcrlf & _
		   " and d.asig_ccod=f.asig_ccod "& vbcrlf & _
		   " and c.bloq_ccod=g.bloq_ccod "& vbcrlf & _
		   " and g.dias_ccod=h.dias_ccod "& vbcrlf & _
		   " and g.sala_ccod=i.sala_ccod "& vbcrlf & _
		   " and i.sede_ccod=j.sede_ccod "& vbcrlf & _
		   " and g.hora_ccod=k.hora_ccod "& vbcrlf & _
		   " and g.hora_ccod=m.hora_ccod and d.sede_ccod=m.sede_ccod "& vbcrlf & _
		   " and case isnull(cast(c.pres_estado_devolucion as varchar),'--') when '--' then 2 else isnull(b.libr_nestado,1) end = l.esli_ccod "& vbcrlf & _
		   " and cast(d.peri_ccod as varchar)= case f.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end "& vbcrlf & _
		   " order by modulo"		   
		   
'response.Write("<pre>"&consulta&"</pre>")		   
formulario.Consultar consulta

nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&rut&"'")
existe_foto = conexion.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&rut&"' and pers_nrut in (6182724,6376895,6555419,7994624,8053780,8534150,8712234,9908394,9942779,13254304)")
if existe_foto > 0 then
	foto_docente= conexion.consultaUno("Select '''../profes/'+ltrim(rtrim(cast('"&rut&"' as varchar)))+'.jpg''' as ruta")
else
	foto_docente= "'../profes/sin_foto.gif'"
end if
'response.Write(foto_docente)
  
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
                                      <td width="98">Rut Docente</td>
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
							  <tr>
							  	  <td colspan="2">&nbsp;</td>
							  </tr>
							  <tr>
							    <td colspan="2">Para acceder a los libros de un profesor puede hacerlo a través del código del libro con la pistola lectora o escribiendo directamente el Rut en el recuadro correspondiente.</td>
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
                  <%if correcto = "S" then%>
				  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
					<br><br>
                  </div>
                  <table  width="100%" border="0">
				   <%if not esVacio(rut) then%>
                    <tr> 
                      <td colspan="3" align="left">
					     <%if not esVacio(rut) then%>
					     <img name="foto" src=<%=foto_docente%> width="80" height="80" border="1">
						 <%end if%>
					  </td>
					</tr>
					<tr> 
                      <td width="15%"><strong>R.U.T.</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><%=rut +"-"+digito%></td>
                    </tr>
					<tr> 
                      <td width="15%"><strong>Nombre Docente</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><%=nombre_docente%></td>
                    </tr>
					<%end if%>
					
					<tr> 
                      <td colspan="3"><div align="right">P&aacute;ginas: &nbsp; 
                          <%formulario.AccesoPagina%>
                        </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
                    <div align="center">
                      <% formulario.DibujaTabla %>
                    </div>
                  </form>
				  <br></td>
				  <%else%>
				  <td bgcolor="#D8D8DE" align="center"><br><font size="2" color="#0000FF"><strong>El periodo de planificación seleccionado no corresponde al año en curso haga el favor de salir de esta funcionalidad y seleccionar el correcto antes de continuar.</strong></font><br><br></td>
				  <%end if%>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="65" nowrap bgcolor="#D8D8DE"><table width="53%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="94%">
                        <%  botonera.dibujaboton "salir"%>
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
