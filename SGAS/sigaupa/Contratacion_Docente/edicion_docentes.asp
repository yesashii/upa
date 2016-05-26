<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de docentes de la asignatura"
'-------------------------------------------------------------------------------
set errores = new CErrores
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
secc_ccod = request.querystring("secc_ccod")

Periodo = negocio.ObtenerPeriodoAcademico("CLASES18")
Sede = negocio.ObtenerSede()
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='" & Sede & "'")

'-------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "horas_docente.xml", "botonera"

'-------------------------------------------------------------------------------
asignatura = conexion.consultaUno ("select ltrim(rtrim(asig_ccod)) from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
carrera = conexion.consultaUno ("select ltrim(rtrim(cast(carr_ccod as varchar))) from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
jornada = conexion.consultaUno ("select jorn_ccod from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.inicializar conexion

	 sql =  "select top 1 c.asig_ccod, a.secc_tdesc, b.peri_tdesc, c.asig_tdesc, d.sede_tdesc, e.jorn_tdesc, f.carr_tdesc,c.asig_nhoras "& vbCrLf &_
			"from secciones a , periodos_academicos b, asignaturas c, sedes d, jornadas e,carreras f "& vbCrLf &_
			"where a.peri_ccod = b.peri_ccod  "& vbCrLf &_
			"  and a.asig_ccod = c.asig_ccod  "& vbCrLf &_
			"  and a.sede_ccod = d.sede_ccod "& vbCrLf &_
			"  and a.jorn_ccod = e.jorn_ccod "& vbCrLf &_
			"  and a.carr_ccod = f.carr_ccod "& vbCrLf &_
			"  and cast(a.secc_ccod as varchar) = '" & secc_ccod & "'"& vbCrLf

f_consulta.consultar sql
f_consulta.siguiente
'------------------------------------------------------------------------------------

set f_docentes = new CFormulario
f_docentes.Carga_Parametros "horas_docente.xml", "f_docentes"
f_docentes.inicializar conexion

	  'sql = " select distinct a.secc_ccod, b.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
		'    " c.pers_tape_paterno as ap_paterno, c.pers_tape_materno as ap_materno, c.pers_tnombre as nombres, "& vbCrLf &_
		'	 " protic.horario_seccion_docente(a.secc_ccod,c.pers_ncorr)  as horario "& vbCrLf &_
		'    " from bloques_horarios a, bloques_profesores b, personas c "& vbCrLf &_
		'    " where cast(a.secc_ccod as varchar)= '"&secc_ccod&"'"& vbCrLf &_
		'	 " and a.bloq_ccod=b.bloq_ccod "& vbCrLf &_
		'	 " and b.pers_ncorr=c.pers_ncorr "
			
  	  sql = " select distinct a.secc_ccod, b.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut,"& vbCrLf &_
		    " c.pers_tape_paterno as ap_paterno, c.pers_tape_materno as ap_materno, c.pers_tnombre as nombres, "& vbCrLf &_
			" protic.horario_seccion_docente(a.secc_ccod,c.pers_ncorr)  as horario, isnull(d.hopr_nhoras,0) as hopr_nhoras,d.hopr_tresolucion "& vbCrLf &_
			" from bloques_horarios a join bloques_profesores b "& vbCrLf &_
		    "    on a.bloq_ccod=b.bloq_ccod "& vbCrLf &_
			"    and b.tpro_ccod=1 "& vbCrLf &_
			" join personas c "& vbCrLf &_
			"    on b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" left outer join horas_profesores d "& vbCrLf &_
			"    on a.secc_ccod = d.secc_ccod and b.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			"where cast(a.secc_ccod as varchar)='"&secc_ccod&"'"

f_docentes.consultar sql
cantidad_docentes = f_docentes.nroFilas
'response.Write("cantidad_docentes "&cantidad_docentes)
horas_asignatura = f_consulta.obtenerValor("asig_nhoras")
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
function validar_horas(){
var num_registros=<%=cantidad_docentes%>;
var horas_totales= <%=horas_asignatura%>;
var formulario= document.edicion;
var valor_hora;
var horas_asignadas = 0;
var contador = 0;
var i=0;
for( i = 0; i < num_registros; i++ ) {
    valor_hora = formulario.elements["docentes["+i+"][hopr_nhoras]"].value
	horas_asignadas = horas_asignadas + (valor_hora * 1);
	if (valor_hora =="0")
		{contador = contador + 1;}
}
//	alert("valor "+ horas_asignadas);

	if (contador > 0 )
	{
	 	alert("No puede dejar docentes con horas en cero");
		return false;
	} 
	
	if (horas_totales < horas_asignadas)
	{alert("El total de horas asignadas a docentes supera el máximo de ("+horas_totales+" hrs) de la asignatura");	
	return false;}
	else
	{//alert("todo esta ok");
	return true;}
	

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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><BR><BR>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="20%"><strong>Asignatura</strong></td>
                        <td width="3%"><div align="center"><strong>:</strong></div></td>
                        <td width="41%"><%= f_consulta.obtenerValor("asig_ccod") & " --> "  & f_consulta.obtenerValor("asig_tdesc")%></td>
                        <td width="9%"><strong>Sede</strong></td>
                        <td width="3%"><div align="center"><strong>:</strong></div></td>
                        <td width="24%"><%=f_consulta.obtenerValor("sede_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td><strong>Carrera</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("carr_tdesc")%></td>
                        <td><strong>Periodo</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("peri_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td><strong>Secci&oacute;n</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("secc_tdesc")%></td>
                        <td><strong>Jornada</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("jorn_tdesc")%></td>
                      </tr>
					  <tr> 
                        <td><strong>Horas Asignatura</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td colspan="4"><%=f_consulta.obtenerValor("asig_nhoras")%></td>
                     </tr>
                    </table>
                       <BR>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_docentes.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Listado de docentes de la asignatura"%>
                      <br>
					  <% f_docentes.dibujaTabla()%>
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
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="48%"> <% botonera.AgregaBotonParam "anterior", "url", "horas_docente.asp?busqueda[0][asig_ccod]=" & asignatura &"&busqueda[0][carr_ccod]="&carrera&"&busqueda[0][jorn_ccod]="&jornada
						  botonera.dibujaBoton "anterior"
						  %> </td>
						  <td width="48%"> <% if cantidad_docentes = "0" then
						                      		botonera.agregabotonParam "guardar","deshabilitado","TRUE"
											  end if
						  botonera.dibujaBoton "guardar"
						  %> </td>
                       </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
