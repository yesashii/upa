<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'*******************************************************************
'DESCRIPCION		: Mantenedor de Cursos Diplomado
'FECHA CREACIÓN		: 12/11/2013
'CREADO POR 		: Michael Shaw Rojas
'ENTRADA		:NA
'SALIDA			:NA
'MODULO OTEC
'*******************************************************************
set errores= new CErrores

q_buscar 	= 	Request.QueryString("buscador[0][buscar]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Programas Habilitados a entidades Externas"

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "mantenedor_diplomado_cursos.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "buscar", q_buscar
f_busqueda.Siguiente

if q_buscar <> ""then 
	
	filtro = "and c.dcur_tdesc LIKE '%"&q_buscar&"%'"

end if

set botonera = new CFormulario
botonera.carga_parametros "mantenedor_diplomado_cursos.xml", "botonera"
 
set curso_diplomado = new CFormulario
curso_diplomado.Carga_Parametros "mantenedor_diplomado_cursos.xml", "diplomado_cursos"
curso_diplomado.Inicializar conexion

sql_diplomado= "select mdcu_ncorr,dcur_tdesc,dc.dcur_ncorr,case mdcu_estado when 1 then 'Activo' else 'Inactivo' end  as mdcu_estado,(select protic.obtener_nombre(p.pers_ncorr,'n') from personas p where cast(p.pers_nrut as varchar) = dc.audi_tusuario ) as AUDI_TUSUARIO from mantenedor_diplomados_cursos dc, diplomados_cursos c " &_
"where dc.dcur_ncorr = c.DCUR_NCORR "& vbCrLf &_
""&filtro&""

curso_diplomado.Consultar sql_diplomado
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">

function ingresa_cc(){
	direccion = "agrega_curso_diplomado.asp";
	resultado=window.open(direccion, "ventana1","width=800,height=200,scrollbars=no, left=380, top=350");
	//window.open("agrega_curso_diplomado.asp","Agregar Curso","left=90,top=100,width=755,height=300");
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

</script>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onBlur="revisaVentana();">
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
	<table width="90%">
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
                    <td width="20%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.DibujaCampo("buscar")%></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
										<td width="50%" align="right"><%botonera.dibujaboton "buscar"%></td>
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
            <td><%pagina.DibujarLenguetas Array("Programas habilitados externos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td> <div align="center"><br><%pagina.DibujarTituloPagina%> <br><br></div>
                      <table align="center">
											<tr>
												<td align="right">P&aacute;ginas: 
															&nbsp; 
															<%curso_diplomado.AccesoPagina%>												  
												</td>
											</tr>
											<tr>
												<td align="center" >
													<%curso_diplomado.DibujaTabla()%>
												</td>
											</tr>
										</table></td></tr>
                </table>
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
                  <td><div align="center"><%botonera.DibujaBoton("agregar")%></div></td>
                  <!--<td><div align="center"><%botonera.DibujaBoton("salir")%></div></td>-->
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
	<br>	</td>
  </tr>  
</table></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>