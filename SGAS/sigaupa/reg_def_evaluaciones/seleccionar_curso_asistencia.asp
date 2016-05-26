<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Selección de cursos para ingreso de <br>asistencia diaria"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set errores 	= new cErrores

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Planificacion")

ano_seleccionado = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
ano_actual = conexion.consultaUno("Select datepart(year,getDate())")
peri = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_seleccionado&"' and plec_ccod=1 ")

dias_tdesc = conexion.consultaUno("select dias_tdesc from dias_semana where dias_ccod=datePart(weekday,getDate())")

'---------------------------------------------------------------------------------------------------
rut = "7229257" 'request.querystring("busqueda[0][pers_nrut]")
digito = "K"  'request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------

'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "seleccionar_curso_asistencia.xml", "botonera"
'--------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "seleccionar_curso_asistencia.xml", "listado_diario"
formulario.Inicializar conexion 

consulta = "  Select distinct ltrim(rtrim(e.asig_ccod)) +' --> '+e.asig_tdesc as asignatura,d.secc_tdesc as seccion, " &vbcrlf &_
           "  f.carr_tdesc as carrera, d.secc_ccod, " &vbcrlf &_
		   " (select count(*) from bloques_horarios tt where tt.secc_ccod=d.secc_ccod " &vbcrlf &_
		   "                  and tt.dias_ccod=c.dias_ccod) as total_bloques, " &vbcrlf &_
		   "  protic.horario(d.secc_ccod) as horario, " &vbcrlf &_
           "  (select min(hora_ccod) from bloques_horarios tt where tt.secc_ccod=d.secc_ccod " &vbcrlf &_
		   "                         and tt.dias_ccod=c.dias_ccod) as min_hora " &vbcrlf &_
		   " from personas a, bloques_profesores b, bloques_horarios c,secciones d, asignaturas e,carreras f " &vbcrlf &_
		   " where cast(a.pers_nrut as varchar)='"&rut&"' and a.pers_ncorr=b.pers_ncorr " &vbcrlf &_
		   " and b.bloq_ccod=c.bloq_ccod and c.secc_ccod=d.secc_ccod " &vbcrlf &_
		   " and d.asig_ccod=e.asig_ccod and d.carr_ccod=f.carr_ccod " &vbcrlf &_
		   " and cast(d.peri_ccod as varchar)= case e.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end " &vbcrlf &_
		   " and c.dias_ccod = datePart(weekday,getDate()) " &vbcrlf &_
           " order by min_hora "  
		   
formulario.Consultar consulta

nombre_docente= conexion.consultaUno("select pers_tnombre +' ' +pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&rut&"'")
  
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
                      <td width="15%"><strong>R.U.T.</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><%=rut +"-"+digito%></td>
                    </tr>
					<tr> 
                      <td width="15%"><strong>Nombre Docente</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><%=nombre_docente%></td>
                    </tr>
                    <tr> 
                      <td width="15%"><strong>Día</strong></td>
					  <td width="1%"><strong>:</strong></td>
					  <td><%=dias_tdesc%></td>
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
