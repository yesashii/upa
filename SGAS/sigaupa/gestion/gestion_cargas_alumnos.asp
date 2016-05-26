<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:06/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:132
'********************************************************************
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

sede = request.QueryString("sede_ccod")
espe_ccod = request.QueryString("espe_ccod")
emat_ccod = request.QueryString("emat_ccod")
nuevo = request.QueryString("nuevo")

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar



set pagina = new CPagina


set botonera =  new CFormulario
botonera.carga_parametros "gestion_matricula.xml","botones_carga"
tituloPag = "Nómina de Alumnos"

if nuevo="S" then tituloPag = tituloPag + " Nuevos"
if nuevo="N" then tituloPag = tituloPag + " Antiguos"
tituloPag = tituloPag + " por Carrera"

tituloPag = tituloPag + " Matriculados a la fecha, según Nro de Asignaturas Inscritas"

pagina.Titulo = tituloPag



set f_matriculados = new cformulario
f_matriculados.carga_parametros "gestion_matricula.xml","matriculados_carga"
f_matriculados.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"'"
end if
consulta="select '' as pers_ncorr"		

' asigna valores nulos
'if espe_ccod="" then espe_ccod=0 end if
'if sede="" then sede=0 end if

if emat_ccod = "1" then

'	consulta = " select distinct tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut, " & vbCrLf &_
'			 " tabla.nombre,a.matr_ncorr, " & vbCrLf &_
'			 " count(a.matr_ncorr) as suma_total,case count(a.matr_ncorr) when 0 then 'Sin Inscripción' else '' end as estado," & vbCrLf &_
'			 " isnull(protic.ANO_INGRESO_CARRERA(tabla.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr " & vbCrLf &_
'	   		 " From alumnos where matr_ncorr=a.matr_ncorr order by matr_ncorr desc),'CC'))) ,  " & vbCrLf &_
'	         " protic.ANO_INGRESO_UNIVERSIDAD(tabla.pers_ncorr) )as ano_ingreso" & vbCrLf &_
'			 " from cargas_academicas a, " & vbCrLf &_
'			 " (select distinct a.pers_ncorr, e.carr_ccod, c.peri_ccod, " & vbCrLf &_
'			 " cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut, " & vbCrLf &_
'			 " pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre, " & vbCrLf &_
'			 "   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo, " & vbCrLf &_
'			 "   d.matr_ncorr " & vbCrLf &_
'			 " from personas a, ofertas_academicas c, alumnos d,especialidades e" & vbCrLf &_
'			 " where a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
'			 " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
'			 " and c.espe_ccod  = e.espe_ccod " & vbCrLf &_
'			 " and c.peri_ccod = '"&periodo&"' " & vbCrLf &_
'			 " and e.espe_ccod = '"&espe_ccod&"' " & vbCrLf &_
'			 " and c.sede_ccod = '"&sede&"' " & vbCrLf &_
'			 " and d.emat_ccod = 1 " & vbCrLf &_
'			 " and d.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
'			 "		    'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
'			 "          'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
'			 "          'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNota3Nuevo','AgregaNotaProtix','AgregaNotaprotix1') " & vbCrLf  & _
'			 " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, " & vbCrLf &_
'			 "          pers_tape_materno,pers_fnacimiento,d.matr_ncorr " & vbCrLf &_
'			 " "&filtro_nuevo & " ) as tabla " & vbCrLf &_
'			 " where tabla.matr_ncorr *= a.matr_ncorr " & vbCrLf &_
'			 " group by tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut,tabla.nombre,tabla.pers_fnacimiento,tabla.nuevo, " & vbCrLf &_
'			 "         a.matr_ncorr " & vbCrLf &_
'			 " order by tabla.nombre asc"				

	consulta = " select distinct tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut, " & vbCrLf &_
			 " tabla.nombre,a.matr_ncorr, " & vbCrLf &_
			 " count(a.matr_ncorr) as suma_total,case count(a.matr_ncorr) when 0 then 'Sin Inscripción' else '' end as estado," & vbCrLf &_
			 " isnull(protic.ANO_INGRESO_CARRERA(tabla.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr " & vbCrLf &_
	   		 " From alumnos where matr_ncorr=a.matr_ncorr order by matr_ncorr desc),'CC'))) ,  " & vbCrLf &_
	         " protic.ANO_INGRESO_UNIVERSIDAD(tabla.pers_ncorr) )as ano_ingreso" & vbCrLf &_
			 " from " & vbCrLf &_
			 " ( " & vbCrLf &_
			 " select distinct a.pers_ncorr, e.carr_ccod, c.peri_ccod, " & vbCrLf &_
			 " cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut, " & vbCrLf &_
			 " pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre, " & vbCrLf &_
			 "   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo, " & vbCrLf &_
			 "   d.matr_ncorr " & vbCrLf &_
			 " from personas a " & vbCrLf &_
			 " INNER JOIN alumnos d " & vbCrLf &_
			 " ON a.pers_ncorr = d.pers_ncorr  and d.emat_ccod = 1 " & vbCrLf &_
			 " and d.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46', " & vbCrLf &_
			 " 'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp', " & vbCrLf &_
			 " 'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80', " & vbCrLf &_
			 " 'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNota3Nuevo','AgregaNotaProtix','AgregaNotaprotix1') " & vbCrLf &_
			 " INNER JOIN ofertas_academicas c " & vbCrLf &_
			 " ON c.ofer_ncorr = d.ofer_ncorr and c.peri_ccod = '"&periodo&"'  and c.sede_ccod = '"&sede&"' " & vbCrLf &_
			 " INNER JOIN especialidades e " & vbCrLf &_
			 " ON c.espe_ccod  = e.espe_ccod " & vbCrLf &_
			 " and e.espe_ccod = '"&espe_ccod&"' " & vbCrLf &_
			 " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, " & vbCrLf &_
			 "          pers_tape_materno,pers_fnacimiento,d.matr_ncorr " & vbCrLf &_
			 " "&filtro_nuevo & " ) as tabla " & vbCrLf &_
			 " LEFT OUTER JOIN cargas_academicas a " & vbCrLf &_
			 " ON tabla.matr_ncorr = a.matr_ncorr  " & vbCrLf &_
			 " group by tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut,tabla.nombre,tabla.pers_fnacimiento,tabla.nuevo, " & vbCrLf &_
			 "         a.matr_ncorr " & vbCrLf &_
			 " order by tabla.nombre asc"	

	'response.Write("<pre>"&consulta&"</pre>")
	
end if

'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()


f_matriculados.Consultar consulta
'f_matriculados.Siguiente

url_excel="gestion_cargas_alumnos_excel.asp?sede="&sede&"&espe_ccod="&espe_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo

carrera = conectar.consultaUno("Select carr_tdesc from especialidades a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.espe_ccod as varchar)='"&espe_ccod&"'")
especialidad = conectar.consultaUno("Select espe_tdesc from especialidades a where cast(a.espe_ccod as varchar)='"&espe_ccod&"'")

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
function salir()
{
window.close();
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="650" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                          <td width="10%"><strong>Especialidad</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=especialidad%></td>
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
                            <% botonera.dibujaboton("salir") %>
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
