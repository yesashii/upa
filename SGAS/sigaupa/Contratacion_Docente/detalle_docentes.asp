<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

tipo = request.QueryString("tipo")
jornada = request.QueryString("jornada")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")
sede = request.QueryString("sede")

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar

periodo = negocio.obtenerPeriodoAcademico("Postulacion")


set pagina = new CPagina

'response.Write("tipo "&tipo&" jornada "&jornada)

set botonera =  new CFormulario
botonera.carga_parametros "titulos_jornada.xml","botonera"
tituloPag = "Docentes"

if tipo="2" then 
	tituloPag = tituloPag + " Profesionales"
	filtro1 = " and b1.grac_ccod=2 "
	filtro2 = " "
end if	
if tipo="1" then 
	tituloPag = tituloPag + " Técnicos"
	filtro1 = " and b1.grac_ccod=1"	
	filtro2 = " and not exists(select 1 from curriculum_docente r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=2) "
end if
if tipo="0" then 
	tituloPag = tituloPag + " Sin Título"
	filtro1 = " and isnull(b1.grac_ccod,0)= 0 "
	filtro2 = " and not exists(select 1 from curriculum_docente r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) "
end if	

tituloPag = tituloPag + " con jornada"

if jornada = "1" then 
	tituloPag = tituloPag + " Completa"
	filtro3= " and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') > 31"
end if	
if jornada = "2" then 
	tituloPag = tituloPag + " Media"
	filtro3= " and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 20 and 31"
end if	
if jornada = "3"  then 
	tituloPag = tituloPag + " por Horas"
	filtro3= " and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') between 1 and 19"
end if	

pagina.Titulo = tituloPag

'response.Write(tituloPag)

set f_docentes = new cformulario
f_docentes.carga_parametros "titulos_jornada.xml","f_docentes"
f_docentes.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"' order by nombre asc"
end if
consulta=""		

' asigna valores nulos
'if espe_ccod="" then espe_ccod=0 end if
'if sede="" then sede=0 end if

consulta = " select distinct a1.pers_ncorr, cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut,"& vbCrLf &_
           " c.pers_tape_paterno as ap_paterno,c.pers_tape_materno as ap_materno,c.pers_tnombre as nombre,"&vbCrLf &_
		   " (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "  where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.peri_ccod as varchar)='"&periodo&"' and cast(hdc.sede_ccod as varchar)='"&sede&"') as horas"& vbCrLf &_
		   " from carreras_docente a1,curriculum_docente b1, personas c  "& vbCrLf &_
		   " where cast(a1.carr_ccod as varchar)='"&carr_ccod&"' and cast(a1.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " and a1.pers_ncorr=b1.pers_ncorr  and b1.pers_ncorr=c.pers_ncorr"& vbCrLf &_
		   " " & filtro1 & " "& vbCrLf &_
		   " " & filtro2 & " "& vbCrLf &_
		   " and (select sum(prof_nhoras) from horas_docentes_carrera hdc "& vbCrLf &_
		   "         where hdc.carr_ccod=a1.carr_ccod and hdc.pers_ncorr=a1.pers_ncorr and cast(hdc.jorn_ccod as varchar)='"&jorn_ccod&"'"& vbCrLf &_
		   " " & filtro3 &" order by c.pers_tape_paterno"


'response.Write("<hr><pre>"&consulta&"</pre>")
'response.Flush()


f_docentes.Consultar consulta
cantidad_lista=f_docentes.nroFilas
'f_matriculados.Siguiente

url_excel="detalle_docentes_excel.asp?tipo="&tipo&"&jornada="&jornada&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&sede="&sede
carrera = conectar.consultaUno("Select carr_tdesc from  carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
sede_tdesc = conectar.consultaUno("Select sede_tdesc from  sedes where cast(sede_ccod as varchar)='"&sede&"'")
jorn_tdesc = conectar.consultaUno("Select jorn_tdesc from  jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")

'response.End()

%>
<html>
<head>
<title>Alumnos Matriculados</title>
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
						  <td><%=sede_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Carrera</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=carrera%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Jornada</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=jorn_tdesc%></td>
                        </tr>
						<tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%f_docentes.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%f_docentes.dibujatabla()%> </td>
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
            <td width="38%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url","TITULOS_JORNADA.ASP?busqueda[0][carr_ccod]="&carr_ccod&"&busqueda[0][jorn_ccod]="&jorn_ccod&"&busqueda[0][sede_ccod]="&sede
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center">
                            <% botonera.dibujaboton("lanzadera") %>
                          </div></td>
				  <td> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", url_excel
										   botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
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
