<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
codigo= request.QueryString("asig_ccod")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Asignaturas"

set botonera =  new CFormulario
botonera.carga_parametros "editar_asignatura.xml", "btn_edita_asignaturas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "editar_asignatura.xml", "edicion_asig"
formulario.inicializar conexion

consulta= "SELECT asig.ASIG_CCOD, asig.TASG_CCOD, asig.EASI_CCOD, asig.ASIG_TDESC, " & vbCrlf & _
		  " asig.ASIG_NHORAS, asig.CRED_CCOD, asig.AREA_CCOD, " & vbCrlf & _
		  " convert(varchar,asig_fini_vigencia,103) as ASIG_FINI_VIGENCIA, " & vbCrlf & _
		  " convert(varchar,asig_ffin_vigencia,103) as ASIG_FFIN_VIGENCIA, " & vbCrlf & _
		  " asig.AUDI_TUSUARIO,asig.AUDI_FMODIFICACION, easig.easi_tdesc,asig.duas_ccod, " & vbCrlf & _
		  " tasig.tasg_tdesc,asig.asig_nnivel_ayudante, isnull(asig.clas_ccod,1) as clas_ccod," & vbCrlf & _
		  " asig_nhoras_laboratorio,asig_nhoras_terreno,asig_nhoras_ayudantia,asig_nhoras_elearning " & vbCrlf & _
          " FROM asignaturas asig, estado_asignatura easig, tipos_asignatura tasig" & vbCrlf & _
          " WHERE " & vbCrlf & _
		  " asig.asig_ccod = '" & codigo & "' and   easig.easi_ccod = asig.easi_ccod and asig.tasg_ccod = tasig.tasg_ccod" 


'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 
if codigo <> "" then
	formulario.agregacampocons "asig_ccod", codigo
	formulario.agregacampocons "codigo", codigo
end if
formulario.siguiente

lenguetas_masignaturas = Array(Array("Datos De La Asignatura", "editar_asignatura.asp?asig_ccod="&codigo), Array("Programa De La Asignatura", "programa_asignatura.asp?asig_ccod="&codigo))
', Array("Programa De La Asignatura", "programa_asignatura.asp?asig_ccod="&codigo)
consulta_bloqueos= " select isnull(count(*),0) " & vbCrlf & _
				   " from secciones a, bloques_horarios b, bloques_profesores c " & vbCrlf & _
				   " where a.secc_ccod=b.secc_ccod " & vbCrlf & _
				   " and b.bloq_ccod=c.bloq_ccod " & vbCrlf & _
			 	   " and cast(a.peri_ccod as varchar)='"&periodo&"'" & vbCrlf & _
				   " and cast(a.asig_ccod as varchar)='"&codigo&"' " & vbCrlf & _
				   " and bloq_anexo is not null"
 'response.Write("<pre>"&consulta_bloqueos&"</pre>")
 bloqueos_asignatura= conexion.consultaUno(consulta_bloqueos)
 horas_asignatura= formulario.obtenerValor ("asig_nhoras")
 duracion_asignatura= formulario.obtenerValor ("duas_ccod")
 'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)
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
function guardar(formulario){
 var bloqueos = <%=bloqueos_asignatura%>;
 var horas = '<%=horas_asignatura%>';
 var duracion = '<%=duracion_asignatura%>';
 var formulario = document.edicion;
 var horas2 = formulario.elements["m[0][asig_nhoras]"].value;
 var duracion2 = formulario.elements["m[0][duas_ccod]"].value;
 //alert("horas "+horas+" duracion "+duracion+" horas2 "+horas2+" duracion2 "+duracion2);
 if ((bloqueos !=0)&&((horas!=horas2)||(duracion!=duracion2))) 
 {
 alert ("No se puede modificar la asignatura, ya es parte de un Contrato de docente");
 }
 else
 {
	if(preValidaFormulario(formulario)){	
    	formulario.action ='actualizar_asignaturas.asp';
		formulario.submit();
	}
  }	
}
function volver(){
	window.navigate("busca_asignaturas.asp?asig_ccod="+"<%=codigo%>")
}

function validaCambios(){
	alert("..");
	return false;
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "m[0][asig_fini_vigencia]","1","edicion","fecha_oculta_asig_fini_vigencia"
	calendario.MuestraFecha "m[0][asig_ffin_vigencia]","2","edicion","fecha_oculta_asig_ffin_vigencia"
	calendario.FinFuncion
	
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>

<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
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
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post"><table width="100%"  border="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><%pagina.DibujarSubtitulo "Datos De La Asignatura"%></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr> 
  <td colspan="4" align="left" nowrap><font color="#CC3300">*</font> 
                            Campos Obligatorios</td>
  </tr>
</table>

                    <table width="90%" align="center">
                      <tr> 
                        <td width="29%"><font color="#CC3300">*</font><strong>C&oacute;digo</strong></td>
                        <td width="61%">:<%=formulario.dibujaCampo("asig_ccod")%><%=formulario.obtenerValor("asig_ccod")%></td>
                      </tr>
                      <tr> 
                        <td><font color="#CC3300">*</font><strong>Nombre </strong></td>
                        <td>:<%=formulario.dibujaCampo("asig_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Estado 
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("easi_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Regimen 
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("tasg_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Horas 
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_nhoras")%> </td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Horas Laboratorio
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_nhoras_laboratorio")%> </td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Horas Terreno
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_nhoras_terreno")%> </td>
                      </tr>					  
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Horas Ayudantía
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_nhoras_ayudantia")%> </td>
                      </tr>
					  <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Horas Elearning
                          </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_nhoras_elearning")%> </td>
                      </tr>					  					  
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Creditos</strong></td>
                        <td nowrap>:<%=formulario.dibujaCampo("cred_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Areas</strong></td>
                        <td nowrap>:<%=formulario.dibujaCampo("area_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><font color="#CC3300">*</font><strong>Fecha 
                          Inicio </strong></td>
                        <td width="50%" nowrap>: <%=formulario.dibujaCampo("asig_fini_vigencia")%> <%calendario.DibujaImagen "fecha_oculta_asig_fini_vigencia","1","edicion" %>
                          (dd/mm/yyyy) </td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Fecha Termino </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_ffin_vigencia")%> <%calendario.DibujaImagen "fecha_oculta_asig_ffin_vigencia","2","edicion" %>
                          (dd/mm/yyyy) </td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Duración </strong></td>
                        <td >:<%=formulario.dibujaCampo("duas_ccod")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Max. Nivel Ayudant&iacute;a </strong></td>
                        <td >:<%=formulario.dibujaCampo("asig_nnivel_ayudante")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Tipo</strong></td>
                        <td >:<%=formulario.dibujaCampo("clas_ccod")%></td>
                      </tr>
                      <tr> 
                        <td valign="top">&nbsp;</td>
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
                  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "volver"%></div></td>
                  <td><div align="center"></div></td>
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
