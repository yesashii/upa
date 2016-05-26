<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next
Server.ScriptTimeout = 6500 

sede = request.QueryString("sede_ccod")
espe_ccod = request.QueryString("espe_ccod")
epos_ccod = request.QueryString("epos_ccod")
emat_ccod = request.QueryString("emat_ccod")
nuevo = request.QueryString("nuevo")
carr_ccod = request.QueryString("carr_ccod")
jorn_ccod = request.QueryString("jorn_ccod")

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

periodo=negocio.ObtenerPeriodoAcademico("postulacion")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	'filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"'  order by nombre asc"
	if epos_ccod <> "" then
		filtro_nuevo = "  having (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=b.post_ncorr) = '"&nuevo&"'  order by nombre asc"
	elseif emat_ccod = "1" then
		filtro_nuevo = "  having (select isnull(post_bnuevo,'N') from postulantes where post_ncorr=d.post_ncorr) = '"&nuevo&"'  order by nombre asc"
	end if
' and c.peri_ccod=max(g.peri_ccod) 
' AGREGADO PARA FILTRAR LOS ALUMNOS DEL PRIMER Y SEGUNDO SEMESTRE Y ASI INCLUIR ALUMNOS DE TODO EL AÑO
' PERO TRAE SOLO LA ULTIMA MATRICULA ACTIVA EN CASO DE TENER 2 MATRICULAS)
' NO FUNCIONA PARA CAMBIOS DE CARRERA (FALTA REVISAR,  MRIFFO)
end if
consulta=""		


if espe_ccod <> "" then
	filtro_espe=" And e.espe_ccod="&espe_ccod
end if

if epos_ccod <> "" then
		
'###########################################################################################
'###########################	VERSION SEPARADA POR CARRERA Y JORNADA #####################
'###########################################################################################

consulta2 =  " select a.pers_ncorr, e.carr_ccod, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut," & vbCrLf &_
			"  pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre  as nombre," & vbCrLf &_
			"   pers_fnacimiento,protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) as ano_ingreso" & vbCrLf &_
			" from personas_postulante a, postulantes b, ofertas_academicas c, especialidades e, detalle_postulantes f " & vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
			"   and b.post_ncorr=f.post_ncorr " & vbCrLf &_
			"   and c.ofer_ncorr=f.ofer_ncorr " & vbCrLf &_			
			"   and c.espe_ccod = e.espe_ccod " & vbCrLf &_
			"   and b.epos_ccod='" & epos_ccod & "' " & vbCrLf &_
			"   and e.carr_ccod='" & carr_ccod & "' " & vbCrLf &_
			"   and c.jorn_ccod='" & jorn_ccod & "' " & vbCrLf &_
			"   and c.peri_ccod='" & periodo & "' " & vbCrLf &_
			"   and c.sede_ccod='" & sede & "' "  & vbCrLf &_
			" "&filtro_espe&" "& vbCrLf &_
			"   and b.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49'," & vbCrLf &_
			"   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', " & vbCrLf &_
			"   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88'," & vbCrLf &_
			"   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') " & vbCrLf &_
  			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento, b.post_ncorr " & vbCrLf & _
			filtro_nuevo 			
			
			
elseif emat_ccod = "1" then
		
'###########################################################################################
'###########################	VERSION SEPARADA POR CARRERA Y JORNADA #####################
'###########################################################################################

				
		consulta2 =  "   select a.pers_ncorr, e.carr_ccod, c.peri_ccod, cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut,  " & vbCrLf &_
			"   pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre,  " & vbCrLf &_
			"   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo,  " & vbCrLf &_
			"   isnull(protic.ANO_INGRESO_CARRERA(a.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr   " & vbCrLf &_
	   		"   From alumnos where matr_ncorr=d.matr_ncorr order by matr_ncorr desc),'CC'))) ,    " & vbCrLf &_
            "   protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr) )as ano_ingreso  " & vbCrLf &_
			" from personas a, ofertas_academicas c, alumnos d,especialidades e   " & vbCrLf &_
			" where a.pers_ncorr = d.pers_ncorr   " & vbCrLf &_
			"   and c.ofer_ncorr= d.ofer_ncorr   " & vbCrLf &_
			"   and c.espe_ccod = e.espe_ccod " & vbCrLf &_
            "   and c.jorn_ccod='" & jorn_ccod & "'   " & vbCrLf &_
			"   and e.carr_ccod='" & carr_ccod & "'  " & vbCrLf &_
			"   and c.sede_ccod='" & sede & "'  " & vbCrLf &_
			" 	"&filtro_espe&" "& vbCrLf &_ 
			"   and d.emat_ccod in (1,4,8,2,15,16)  and d.audi_tusuario not like '%ajunte matricula%'  " & vbCrLf &_
	        "   and protic.afecta_estadistica(d.matr_ncorr) > 0   " & vbCrLf &_
			"	and c.peri_ccod=protic.retorna_max_periodo_matricula(a.pers_ncorr,'" & periodo & "',e.carr_ccod)  " & vbCrLf &_
			"   and isnull(d.alum_nmatricula,0) not in (7777) "& vbCrLf  & _
			"	and d.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42',  " & vbCrLf &_
			"                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno',   " & vbCrLf &_
			"                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65',   " & vbCrLf &_
			"                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN',   " & vbCrLf &_
			"                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2',   " & vbCrLf &_
			"                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')   " & vbCrLf &_
			" group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, pers_tape_materno,pers_fnacimiento,d.matr_ncorr, d.post_ncorr  " & vbCrLf & _
			filtro_nuevo
				
	url_carga="gestion_cargas_alumnos.asp?sede_ccod="&sede&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&nuevo="&nuevo&"&emat_ccod="&emat_ccod

end if

'response.Write("<pre>"&consulta2&"</pre>")
'response.Flush()


f_matriculados.Consultar consulta2
cantidad_lista=f_matriculados.nroFilas

if espe_ccod <> "" then
	url_excel="listado_gestion_matricula_2.asp?sede="&sede&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&epos_ccod="&epos_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo&"&espe_ccod="&espe_ccod
else
	url_excel="listado_gestion_matricula_2.asp?sede="&sede&"&carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&epos_ccod="&epos_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo
end if
url_anterior="gestion_matricula_1.asp?sede_ccod="&sede

carrera = conectar.consultaUno("Select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
jornada = conectar.consultaUno("Select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")


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

function ver_resumen()
{
//alert("muestra historico de notas");
self.open('<%=url_carga%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

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
                  <%pagina.dibujartitulopagina %>
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
                          <td width="10%"><strong>Carrera</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=carrera%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Jornada</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=jornada%></td>
                        </tr>
                        <tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%f_matriculados.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%f_matriculados.dibujatabla()%> </td>
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
							botonera.agregabotonparam "anterior","url",url_anterior 'request.ServerVariables("HTTP_REFERER")
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center">
                            <% botonera.dibujaboton("cancelar") %>
                          </div></td>
				  <td> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", url_excel
										   botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
				  <td> <div align="center">  <% if not EsVacio(emat_ccod) and cantidad_lista > 0 then 
					                       			'botonera.agregabotonparam "cargas", "url", url_excel
										   			botonera.dibujaboton "cargas"
										   		end if
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
