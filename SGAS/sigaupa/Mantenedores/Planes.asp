<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Planes de Estudio"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Planes.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
espe_ccod = request.querystring("busqueda[0][espe_ccod]")

carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
especialidad = conexion.consultauno("SELECT espe_tdesc FROM especialidades WHERE espe_ccod = '" & espe_ccod & "'")

'response.Write(espe_ccod & ":"& especialidad & "<BR><BR>")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Planes.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 	if  EsVacio(espe_ccod) then
  		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "carr_ccod ='"&carr_ccod&"'"
		 f_busqueda.AgregaCampoCons "espe_ccod", espe_ccod 
	end if
  
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 

 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
 set f_planes = new CFormulario
 f_planes.Carga_Parametros "Planes.xml", "f_planes"
 f_planes.Inicializar conexion
 consulta = "SELECT a.plan_ccod, a.espe_ccod, a.epes_ccod,b.epes_tdesc, a.plan_tdesc, a.plan_ncorrelativo, convert(varchar,a.plan_fcreacion,103) as plan_fcreacion, convert(varchar,a.plan_ftermino,103) as plan_ftermino,a.plan_tcoduas as c_plan_tcoduas, a.plan_nresolucion, plan_duracion_semestres " & vbCrLf &_
            "FROM planes_estudio a, estados_plan_estudio b " & vbCrLf &_
		    "WHERE espe_ccod ='" & espe_ccod & "'" & vbCrLf &_
			" AND a.epes_ccod = b.epes_ccod " & vbCrLf &_
			"ORDER BY plan_ncorrelativo"
 'response.Write("<pre>"&consulta&"</pre>")
 f_planes.Consultar consulta
		 
'-------------------------------------------------------------

Subtitulo = "<table width=""100%""  border=""0"" cellpadding=""0"" cellspacing=""0"">" & vbCrLf &_
		         "  <tr>" & vbCrLf &_
				 "     <td>" & vbCrLf &_ 	
		"<table width=""99%"" border=""0"" align=""left"" cellpadding=""0"" cellspacing=""0""> " & vbCrLf &_
		         "    <tr> " & vbCrLf &_
				 "      <td><font face=""Verdana, Arial, Helvetica, sans-serif"" size=""1""><b><font color=""#666677"" size=""2"">Carrera: " & carrera & "</font></b></font></td> " & vbCrLf &_
				 "    </tr> " & vbCrLf &_
				  "    <tr> " & vbCrLf &_
				 "      <td><font face=""Verdana, Arial, Helvetica, sans-serif"" size=""1""><b><font color=""#666677"" size=""2"">Especialidad: " & especialidad & "</font></b></font></td> " & vbCrLf &_
				 "    </tr> " & vbCrLf &_
				 "    <tr> " & vbCrLf &_
				 "      <td width=""0"" height=""0""><font color=""#666677""><img src=""../imagenes/linea.gif"" width=""100%"" height=""9""></font></td> " & vbCrLf &_
				 "    </tr> " & vbCrLf &_
				 "</table>" & vbCrLf &_				 
		"</tr>" & vbCrLf &_
		                  "</table>"



consulta = "SELECT espe_ccod, espe_tdesc, carr_ccod  FROM especialidades"
conexion.Ejecuta consulta
set rec_especialidades = conexion.ObtenerRS



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
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}


arr_especialidades = new Array();

<%
rec_especialidades.MoveFirst
i = 0
while not rec_especialidades.Eof
%>
arr_especialidades[<%=i%>] = new Array();
arr_especialidades[<%=i%>]["espe_ccod"] = '<%=rec_especialidades("espe_ccod")%>';
arr_especialidades[<%=i%>]["espe_tdesc"] = '<%=rec_especialidades("espe_tdesc")%>';
arr_especialidades[<%=i%>]["carr_ccod"] = '<%=rec_especialidades("carr_ccod")%>';
<%	
	rec_especialidades.MoveNext
	i = i + 1
wend
%>

function CargarEspecialidades(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][espe_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Especialidad";
	formulario.elements["busqueda[0][espe_ccod]"].add(op)
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["busqueda[0][espe_ccod]"].add(op)			
		 }
	}	
}

function inicio()
{
  <%if carr_ccod <> "" then%>
    CargarEspecialidades(buscador, <%=carr_ccod%>);
	buscador.elements["busqueda[0][espe_ccod]"].value ='<%=espe_ccod%>'; 
  <%end if%>
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
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
                            <table width="100%" border="0">
                              <tr> 
                                <td><div align="left">Carrera</div></td>
                                <td><div align="center">:</div></td>
                                <td>
                                  <% f_busqueda.dibujaCampo ("carr_ccod") %>
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%"><div align="left">Especialidad</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="81%"><% f_busqueda.dibujaCampo ("espe_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><div align="center">
                    <br> <%if carrera <> "" then%>
                    <table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=carrera%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Especialidad</font></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=especialidad%></font></b></font></td>
  </tr>
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table> <%end if%>
                    <br>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_planes.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <% f_planes.DibujaTabla()%>
                          </div></td>
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
                  <td><div align="center"> 
                            <% if carr_ccod <> "" and  espe_ccod <> "" and  espe_ccod <> "-1" then
							      botonera.AgregaBotonParam "nueva" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "nueva" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "nueva", "url", "Planes_Agregar.asp?espe_ccod=" & espe_ccod
							   botonera.DibujaBoton "nueva"
							%>
                          </div></td>
                  <td><div align="center">
                            <% if carr_ccod <> ""  and  espe_ccod <> "" and  espe_ccod <> "-1" then
							      botonera.AgregaBotonParam "eliminar" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar" , "deshabilitado", "TRUE"
							   end if
							   botonera.DibujaBoton "eliminar"%>				  
                          </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
