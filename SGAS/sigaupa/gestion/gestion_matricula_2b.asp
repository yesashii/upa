<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

sede = request.QueryString("sede_ccod")
espe_ccod = request.QueryString("espe_ccod")
epos_ccod = request.QueryString("epos_ccod")
emat_ccod = request.QueryString("emat_ccod")
nuevo = request.QueryString("nuevo")

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar



set pagina = new CPagina


set botonera =  new CFormulario
botonera.carga_parametros "gestion_matricula.xml","botones_rep_matriculados"
tituloPag = "Alumnos"

if nuevo="S" then tituloPag = tituloPag + " Nuevos"
if nuevo="N" then tituloPag = tituloPag + " Antiguos"
tituloPag = tituloPag + " por Carrera"

if epos_ccod = "1" then tituloPag = tituloPag + " (en Proceso)"
if epos_ccod = "2" then tituloPag = tituloPag + " (Enviados)"
if epos_ccod = ""  then tituloPag = tituloPag + " (Matriculados)"

pagina.Titulo = tituloPag



set f_matriculados = new cformulario
f_matriculados.carga_parametros "gestion_matricula.xml","matriculados_2"
f_matriculados.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"'"
end if
consulta=""		

' asigna valores nulos
'if espe_ccod="" then espe_ccod=0 end if
'if sede="" then sede=0 end if

if epos_ccod <> "" then

consulta =  " select a.pers_ncorr, e.carr_ccod, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut," & vbCrLf &_
			"   pers_tnombre + ' '+ pers_tape_paterno + ' ' + pers_tape_materno as nombre," & vbCrLf &_
			"   pers_fnacimiento" & vbCrLf &_
			" from personas_postulante a, postulantes b, ofertas_academicas c, especialidades e" & vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
			"   and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
			"   and c.espe_ccod = e.espe_ccod " & vbCrLf &_
			"   and b.epos_ccod='" & epos_ccod & "' " & vbCrLf &_
			"   and c.espe_ccod='" & espe_ccod & "' " & vbCrLf &_
			"   and c.peri_ccod='" & periodo & "' " & vbCrLf &_
			"   and c.sede_ccod='" & sede & "' "  & vbCrLf &_			
  			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento " & vbCrLf & _
			filtro_nuevo 
elseif emat_ccod = "1" then

	consulta =  " select a.pers_ncorr, e.carr_ccod, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut," & vbCrLf &_
			"   cast(pers_tnombre as varchar)+' '+cast(pers_tape_paterno as varchar)+' '+cast(pers_tape_materno as varchar) as nombre," & vbCrLf &_
			"   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo" & vbCrLf &_
			" from personas a, ofertas_academicas c, alumnos d,especialidades e" & vbCrLf &_
			" where a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
			"   and c.ofer_ncorr= d.ofer_ncorr " & vbCrLf &_
			"   and c.espe_ccod = e.espe_ccod " & vbCrLf &_
			"   and c.peri_ccod='" & periodo & "'" & vbCrLf &_
			"   and e.espe_ccod='" & espe_ccod & "'" & vbCrLf &_
			"   and c.sede_ccod='" & sede & "'" & vbCrLf &_
			"   and d.emat_ccod= 1 " & vbCrLf & _
  			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento "& vbCrLf &_
				filtro_nuevo
end if

'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()

f_matriculados.Consultar consulta

'f_matriculados.Siguiente


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
                      <%if RegistrosN>0 then%>
                      <tr> 
                        <td align="center">&nbsp; </td>
                      </tr>
                      <%end if%>
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
                          <td align="center"> <div align="right">P&aacute;ginas: 
                              <%f_matriculados.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center">&nbsp; <%f_matriculados.dibujatabla()%> </td>
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
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url",request.ServerVariables("HTTP_REFERER")
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center">
                            <% botonera.dibujaboton("cancelar") %>
                          </div></td>
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
