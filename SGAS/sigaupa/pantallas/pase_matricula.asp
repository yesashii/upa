<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Pase Matricula"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "documentacion_matricula.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "documentacion_matricula.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

'consulta = "select a.post_ncorr, a.doma_ccod, a.doma_tdesc, decode(b.doma_ccod, null, 'N', 'S') as bentregado " & vbCrLf &_
'           "from (select b.post_ncorr, c.doma_ccod, c.doma_tdesc " & vbCrLf &_
'		   "      from personas_postulante a, postulantes b, documentos_matricula c " & vbCrLf &_
'		   "	  where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
'		   "	    and b.epos_ccod = 2 " & vbCrLf &_
'		   "		and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
'		   "		and a.pers_nrut = '" & q_pers_nrut & "') a, documentos_postulantes b " & vbCrLf &_
'		   "where a.post_ncorr = b.post_ncorr (+) " & vbCrLf &_
'		   "  and a.doma_ccod = b.doma_ccod (+)"
		   
'consulta = "select a.pers_ncorr, a.doma_ccod, a.doma_tdesc, decode(b.doma_ccod, null, 'N', 'S') as bentregado " & vbCrLf &_
'           "from (select a.pers_ncorr, b.doma_ccod, b.doma_tdesc " & vbCrLf &_
'		   "      from personas_postulante a, documentos_matricula b " & vbCrLf &_
'		   "	  where a.pers_nrut = '" & q_pers_nrut & "') a, documentos_postulantes b " & vbCrLf &_
'		   "where a.pers_ncorr = b.pers_ncorr (+) " & vbCrLf &_
'		   "  and a.doma_ccod = b.doma_ccod (+)"
v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")		   

periodo=164
sede=1		

'--------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "pase_escolar"
fc_datos.Inicializar conexion

'consulta = "select a.pers_nrut || ' - ' || a.pers_xdv as rut, a.pers_tnombre || ' ' || a.pers_tape_paterno || ' ' || a.pers_tape_materno as nombre_completo " & vbCrLf &_
'           "from personas_postulante a " & vbCrLf &_
'		   "where a.pers_nrut = '" & q_pers_nrut & "'"
		   
if q_pers_nrut <> "" and q_pers_xdv <> "" then
	filtro = " and  b.pers_nrut ='" & q_pers_nrut & "' and b.pers_xdv='" & q_pers_xdv & "'"  
else
	filtro = " "
end if
		   
consulta = "select a.pers_ncorr, pers_tape_paterno + ' ' +  pers_tape_materno + ' ' + pers_tnombre as alumno," & vbCrLf &_
			"    espe_tdesc,f.carr_ccod, cast(pers_nrut as varchar)  + '-' + pers_xdv as rut, alum_fmatricula " & vbCrLf &_
			" from alumnos a,personas b,postulantes c,ofertas_academicas d,especialidades e,carreras f" & vbCrLf &_
			" where a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
			"    and a.post_ncorr = c.post_ncorr" & vbCrLf &_
			"    and a.ofer_ncorr = d.ofer_ncorr" & vbCrLf &_
			"    and d.espe_ccod = e.espe_ccod" & vbCrLf &_
			"    and e.carr_ccod = f.carr_ccod" & vbCrLf &_
			"    and emat_ccod = '1'" & vbCrLf &_
			"    and c.peri_ccod = '" & periodo &  "' " & vbCrLf &_
			"    and cast(d.sede_ccod as varchar) = isnull('" & sede &  "',d.sede_ccod)" & vbCrLf &_
			"" & filtro & ""
'response.Write("<pre>"&consulta&"</pre>")
'response.End()		   
fc_datos.Consultar consulta
fc_datos.Siguiente
'response.Write(fc_datos.nrofilas)
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
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;
	
}
function InicioPagina(formulario)
{

}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../matricula/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="50%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
	<br><% if q_pers_nrut <>"" and fc_datos.nrofilas > 0 then %>
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
              <%pagina.DibujarTituloPagina%><br>              
                </div>
				<br><%pagina.DibujarSubtitulo "Informacion Alumno"%>	<br>
				<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="14%" height="25"><strong>Rut Alumno</strong></td>
                  <td width="2%"><strong>:</strong></td>
                  <td width="84%"><%=fc_datos.DibujaCampo("rut")%></td>
                </tr>
				  <tr>
                  <td width="14%" height="25"><strong>Nombre</strong></td>
                  <td width="2%"><strong>:</strong></td>
                  <td width="84%"><%=fc_datos.DibujaCampo("alumno")%></td>
                </tr>
				  <tr>
                  <td width="14%" height="25"><strong>Carreras</strong></td>
                  <td width="2%"><strong>:</strong></td>
                  <td width="84%"><%=fc_datos.DibujaCampo("carr_ccod")%></td>
                </tr>
				<tr>
                  <td width="14%" height="25"><strong>Pase Matricula</strong></td>
                  <td width="2%"><strong>:</strong></td>
                  <td width="84%"><select>
				  <option value="">Hasta 2 Asignaturas</option>
				  <option value="">Desde 3 Asignaturas</option>
				  <option value="">Práctica Profesional</option>
				  <option value="">Títulacion Pendiente</option>
				  <option value="">Alumno Terminal 29-07-2005</option>
				  </select></td>
                </tr>
              </table>
              <form name="edicion">
              
                          <br>
            </form></td></tr>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("guardar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
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
    </table><%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
