<!--Versión 1.0 creada por Sinezio da Silva fecha 22-05-2015 supervisionada por Michael Shaw
hay tres paginas que estan viculadas a este XML cambio_asignatura.xml, modifica_asignatura y proc_cambio_asignatura.asp todos los archivos estan dentro del directorio "docencia"-->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_secc_ccod	= 	Request.QueryString("buscador[0][secc_ccod]")

set pagina = new CPagina
pagina.Titulo = "Cambio de Asignatura (Día, Bloque y Sala)"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambio_asignatura.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cambio_asignatura.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "secc_ccod", q_secc_ccod
f_busqueda.Siguiente

if q_secc_ccod <> "" then

v_secc_ccod = conexion.ConsultaUno("select  count(*) from secciones where secc_ccod ="&q_secc_ccod)


end if
if v_secc_ccod = 1 then
'---------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "cambio_asignatura.xml", "datos_asignatura"
formulario.Inicializar conexion
sql_comentarios ="select A.ASIG_CCOD, A.ASIG_TDESC, C.CARR_TDESC, SD.SEDE_TDESC from"& vbCrLf &_ 				
				"SECCIONES SC " & vbCrLf &_
 				"INNER JOIN ASIGNATURAS A" & vbCrLf &_
 				"ON  SC.ASIG_CCOD = A.ASIG_CCOD" & vbCrLf &_
				"INNER JOIN CARRERAS C" & vbCrLf &_
 				"ON SC.CARR_CCOD = C.CARR_CCOD" & vbCrLf &_
 				"INNER JOIN SEDES SD" & vbCrLf &_
 				"ON SC.SEDE_CCOD = SD.SEDE_CCOD" & vbCrLf &_
 				"WHERE SC.SECC_CCOD = "&q_secc_ccod
formulario.Consultar sql_comentarios
formulario.Siguiente
'---------------------------------------------------------------------------------------------------
set datos = new CFormulario
datos.Carga_Parametros "cambio_asignatura.xml", "detalle_ingreso"
datos.Inicializar conexion
consulta_documento ="SELECT  CAST(SC.SECC_CCOD AS NUMERIC) AS SECC_CCOD,A.ASIG_CCOD,"& vbCrLf &_
" A.ASIG_TDESC, C.CARR_TDESC, SD.SEDE_TDESC,  BH.SEDE_CCOD,"& vbCrLf &_ 
"SUBSTRING (CONVERT(CHAR(16),HS.HORA_HINICIO,121), 12,8)as HORA_HINICIO,"& vbCrLf &_
"SUBSTRING (CONVERT(CHAR(16),HS.HORA_HTERMINO,121), 12,8)as HORA_HTERMINO,BH.HORA_CCOD,"& vbCrLf &_
"DS.DIAS_TDESC, S.SALA_TDESC,"& vbCrLf &_
"CAST(cast(BH.HORA_CCOD as varchar) +' ('+  SUBSTRING" & vbCrLf &_
"(CONVERT(CHAR(16),HS.HORA_HINICIO,121), 12,8)+' '+"& vbCrLf &_
"+' a '++' '+ SUBSTRING (CONVERT(CHAR(16),HS.HORA_HTERMINO,121), 12,8)+') '  as varchar) as"& vbCrLf &_
" blocke, BH.BLOQ_CCOD, DS.DIAS_CCOD, S.SALA_CCOD, BH.SSEC_NCORR, BH.SECC_CCOD " & vbCrLf &_
"FROM SECCIONES SC" & vbCrLf &_ 
"INNER JOIN ASIGNATURAS A" & vbCrLf &_
"ON SC.ASIG_CCOD = A.ASIG_CCOD" & vbCrLf &_
"INNER JOIN CARRERAS C" & vbCrLf &_
"ON SC.CARR_CCOD = C.CARR_CCOD" & vbCrLf &_
"INNER JOIN SEDES SD" & vbCrLf &_
"ON SC.SEDE_CCOD = SD.SEDE_CCOD" & vbCrLf &_
"INNER JOIN BLOQUES_HORARIOS BH" & vbCrLf &_
"ON SC.SECC_CCOD= BH.SECC_CCOD" & vbCrLf &_
"INNER JOIN DIAS_SEMANA DS" & vbCrLf &_
"ON BH.DIAS_CCOD = DS.DIAS_CCOD" & vbCrLf &_
"INNER JOIN SALAS S" & vbCrLf &_
"ON S.SALA_CCOD = BH.SALA_CCOD" & vbCrLf &_
"INNER JOIN HORARIOS_SEDES HS" & vbCrLf &_
"ON HS.HORA_CCOD = BH.HORA_CCOD" & vbCrLf &_
"WHERE SC.SECC_CCOD ="&q_secc_ccod&" AND HS.SEDE_CCOD = BH.SEDE_CCOD" 



datos.Consultar consulta_documento
'--------------------------------------------------------------------------------------------------


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
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}


function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td><div align="right"><strong>Ingrese C&oacute;digo de Asignatura</strong></div></td>
                        <td width="2%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("secc_ccod")%></td>
                      </tr>
                    </table>
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                     
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
              <%pagina.DibujarTituloPagina%>
              <br>	
              <br>	
</div>		
	<%if q_secc_ccod <> "" then%>
			<form name="edicion">
			  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <td width="23%"><strong>Carrera</strong></td>
                    <td width="3%"><strong>:</strong></td>
                    <td width="74%"><%formulario.dibujaCampo("CARR_TDESC")%></td>
                </tr>
				<tr>
                    <td><strong>Codigo Asignatura</strong></td>
                    <td><strong>:</strong></td>
                    <td><%formulario.dibujaCampo("ASIG_CCOD")%></td>
                </tr>
                <tr>
                  <td><strong>Nombre Asignatura</strong></td>
                  <td><strong>:</strong></td>
                  <td><%formulario.dibujaCampo("ASIG_TDESC")%></td></tr>
                <tr>
                  <td><strong>Sede</strong></td>
                  <td><strong>:</strong></td>
                  <td><%formulario.dibujaCampo("SEDE_TDESC")%></td></tr>
                <tr><td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td></tr>
                <tr><td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td></tr>
                <tr><td colspan="3">&nbsp;</td></tr>
               

              </table> 
              <table width="60%" border="0" align="center">
                      <tr>
                        <td align="center"><%datos.DibujaTabla%></td>
                      </tr>
                     
                    </table>
              <p align="center"><strong>Para hacer modificaciones seleccione una Asignatura.</strong></p>
              <table>
              </table>
              
              
            </form>  
            <%end if%>          
            </td></tr>            
      </table>
		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="45%">&nbsp;</td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="70%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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