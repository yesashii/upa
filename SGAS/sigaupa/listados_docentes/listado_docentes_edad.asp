<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
edad = request.QueryString("edad")
sede_ccod = request.QueryString("sede_ccod")
carr_ccod = request.QueryString("carr_ccod")

'response.Write("<hr>sede_ccod = "&sede_ccod&", carr_ccod="&carr_ccod&" <hr>")
set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar

'sede_ccod = conectar.consultaUno("select sede_ccod from sedes where sede_tdesc='"&sede_ccod&"'")
'carr_ccod = conectar.consultaUno("select carr_ccod from carreras where carr_tdesc='"&carr_ccod&"'")

'response.Write("<hr>sede_ccod = "&sede_ccod&", carr_ccod="&carr_ccod&" <hr>")



set pagina = new CPagina

set botonera =  new CFormulario
botonera.carga_parametros "docentes_facultad_carrera.xml","botonera"

'----------------------------------------------------------------------------------------------
'-----------a modo de unificar el listado debemos sacar el periodo y el año que se esta consultando---------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
ano_consulta = conectar.consultaUno("Select anos_ccod from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(ano_consulta)
'-------------------------------------------------------------------------------------------------------------------------

tituloPag = "Listado docentes "


if edad= "30" then
	filtro_edad = "  and datediff(year,f.pers_fnacimiento,getDate()) <= 30"
	tituloPag = tituloPag & " cuya edad sea igual o inferior a 30 años"
elseif edad= "40" then
	filtro_edad = "  and datediff(year,f.pers_fnacimiento,getDate()) > 30 and datediff(year,f.pers_fnacimiento,getDate()) <= 40"
	tituloPag = tituloPag & " cuya edad sea mayor a 30 años y menor o igual a 40 años"	
elseif edad= "50" then
	filtro_edad = "  and datediff(year,f.pers_fnacimiento,getDate()) > 40 and datediff(year,f.pers_fnacimiento,getDate()) <= 50"
	tituloPag = tituloPag & " cuya edad sea mayor a 40 años y menor o igual a 50 años"		
elseif edad= "60" then
	filtro_edad = "  and datediff(year,f.pers_fnacimiento,getDate()) > 50 and datediff(year,f.pers_fnacimiento,getDate()) <= 60"
	tituloPag = tituloPag & " cuya edad sea mayor a 50 años y menor o igual a 60 años"
elseif edad= "70" then
	filtro_edad = "  and datediff(year,f.pers_fnacimiento,getDate()) > 60 and datediff(year,f.pers_fnacimiento,getDate()) <= 70"
	tituloPag = tituloPag & " cuya edad sea mayor a 60 años y menor o igual a 70 años"
elseif edad= "80" then
	filtro_edad = "  and datediff(year,f.pers_fnacimiento,getDate()) > 70"
	tituloPag = tituloPag & " cuya edad sea mayor a 70 años "					
end if


consulta =  "  select distinct c.pers_ncorr,cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ' ' + f.pers_tnombre as docente,datediff(year,f.pers_fnacimiento,getDate()) as edad " & vbCrLf &_
			"  from secciones a, bloques_horarios b, bloques_profesores c, carreras e, personas f,asignaturas g,periodos_academicos pa  " & vbCrLf &_
			"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)  " & vbCrLf &_
			"  and tpro_ccod=1  and c.pers_ncorr = f.pers_ncorr "& filtro_edad & vbCrLf &_
			"  and a.carr_ccod=e.carr_ccod and e.tcar_ccod=1 and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_
			"  and cast(a.carr_ccod as varchar)='"&carr_ccod&"' and a.peri_ccod= pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&ano_consulta&"'"

pagina.Titulo = tituloPag

'response.Write("<pre>"&consulta&"</pre>")
set docentes = new cformulario
docentes.carga_parametros "docentes_facultad_carrera.xml","lista_docentes"
docentes.inicializar conectar
docentes.Consultar consulta &" order by docente"
cantidad_lista= conectar.consultaUno("select count(distinct a.pers_ncorr) from ("&consulta&")a")


carrera = conectar.consultaUno("Select protic.initcap(carr_tdesc) from  carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
sede = conectar.consultaUno("Select protic.initcap(sede_tdesc) from  sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")

%>
<html>
<head>
<title>LISTADO DOCENTES</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                <td>
                  <%'pagina.dibujartitulopagina %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    <table width="100%" border="0">
                      <tr> 
                        <td align="center"><strong>
                        <%pagina.DibujarSubtitulo pagina.titulo%>
</strong></td>
                      </tr>
                    </table>
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
					    <tr>
                          <td width="10%"><strong>Sede</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=sede%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Carrera</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=carrera%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Año</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=ano_consulta%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Cantidad</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=cantidad_lista%> docente(s)</td>
                        </tr>
						<tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%docentes.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%docentes.dibujatabla()%> </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28">
		 <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url","docentes_edad.ASP"
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td> <div align="center">  <%
					                       'botonera.agregabotonparam "excel", "url", url_excel
										   'botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
				  </tr>
              </table>
			
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
