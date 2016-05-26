<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000
set pagina = new CPagina
pagina.Titulo = "Reporte Eventos"

v_fecha_inicio 		= request.querystring("busqueda[0][even_fevento]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_teve_ccod	 		= request.querystring("busqueda[0][teve_ccod]")
v_caev_ccod 		= request.querystring("busqueda[0][caev_ccod]")
v_ciud_ccod 		= request.querystring("busqueda[0][ciud_ccod]")
v_pcol_ccod 		= request.querystring("busqueda[0][pcol_ccod]")
v_carrera 			= request.querystring("busqueda[0][carrera]")
v_carre_ccod 		= request.querystring("busqueda[0][carre_ccod]")


set botonera = new CFormulario
botonera.carga_parametros "reporte_eventos.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reporte_eventos.xml", "busqueda_eventos"
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente


 f_busqueda.AgregaCampoCons "even_fevento", v_fecha_inicio
 f_busqueda.AgregaCampoCons "fecha_termino", v_fecha_termino
 f_busqueda.AgregaCampoCons "teve_ccod", v_teve_ccod
 f_busqueda.AgregaCampoCons "caev_ccod", v_caev_ccod
 f_busqueda.AgregaCampoCons "ciud_ccod", v_ciud_ccod
 f_busqueda.AgregaCampoCons "pcol_ccod", v_pcol_ccod
 f_busqueda.AgregaCampoCons "carrera", v_carrera
 f_busqueda.AgregaCampoCons "carre_ccod", v_carre_ccod



formulario.carga_parametros "reporte_eventos.xml", "datos_eventos"
formulario.inicializar conectar
negocio.inicializa conectar
sede=negocio.obtenerSede

'response.Write("v_fecha_inicio :"&v_fecha_inicio)
'response.Write("v_fecha_termino :"&v_fecha_termino)

if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
	sql_adicional= sql_adicional + " and  protic.trunc(c.even_fevento)='"&v_fecha_inicio&"' "& vbCrLf
end if
if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
	sql_adicional= sql_adicional + " and convert(datetime,c.even_fevento,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
end if

if v_fecha_inicio <> "" and v_fecha_termino <> "" then
	sql_adicional= sql_adicional + " and convert(datetime,c.even_fevento,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
end if


if v_teve_ccod <> "" then
	sql_adicional= sql_adicional + " and c.teve_ccod ="&v_teve_ccod& vbCrLf 
end if

if v_caev_ccod <> "" then
	sql_adicional= sql_adicional + " and a.caev_ccod ="&v_caev_ccod& vbCrLf 
end if

if v_ciud_ccod <> "" then
	sql_adicional= sql_adicional + " and c.ciud_ccod_origen ="&v_ciud_ccod& vbCrLf 
end if

if v_pcol_ccod <> "" then
	sql_adicional= sql_adicional + " and c.pcol_ccod ="&v_pcol_ccod& vbCrLf 
end if

if v_carrera <> "" then
	'sql_adicional= sql_adicional + " and c.pcol_ccod ="&v_carrera& vbCrLf 
	sql_adicional= sql_adicional + " and (b.carrera_1 like '%"&v_carrera&"%' or  b.carrera_2 like '%"&v_carrera&"%' or  b.carrera_3 like '%"&v_carrera&"%')" & vbCrLf 
	sql_adicional= sql_adicional + " and PATINDEX('%@%',a.pers_temail)>0 "

	select_add= select_add + " ,case when carrera_1 like '%"&v_carrera&"%' then cast(1 as varchar)+'ª' "
	select_add= select_add + " when carrera_2 like '%"&v_carrera&"%' then cast(2 as varchar)+'ª' "
	select_add= select_add + " when carrera_3 like '%"&v_carrera&"%' then cast(3 as varchar)+'ª' end as opcion_carrera "

end if

if v_carre_ccod <> "" then
select_add=""

	'sql_adicional= sql_adicional + " and c.pcol_ccod ="&v_carrera& vbCrLf 
	sql_adicional= sql_adicional + " and (b.carre_ccod_1="&v_carre_ccod&" or  b.carre_ccod_2="&v_carre_ccod&" or  b.carre_ccod_3="&v_carre_ccod&")" & vbCrLf 
	sql_adicional= sql_adicional + " and PATINDEX('%@%',a.pers_temail)>0 "

	select_add= select_add + ",(select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_1) as carrera_1, "
	select_add= select_add + "(select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_2) as carrera_2, "
	select_add= select_add + "(select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_3) as carrera_3, "

	select_add= select_add + " case when carre_ccod_1 = "&v_carre_ccod&" then cast(1 as varchar)+'ª' "
	select_add= select_add + " when carre_ccod_2 ="&v_carre_ccod&" then cast(2 as varchar)+'ª' "
	select_add= select_add + " when carre_ccod_3 ="&v_carre_ccod&" then cast(3 as varchar)+'ª' end as opcion_carrera "
else
	select_add= select_add + ",(select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_1) as carrera_1, "
	select_add= select_add + "(select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_2) as carrera_2, "
	select_add= select_add + "(select carre_tdesc from carreras_eventos where carre_ccod=carre_ccod_3) as carrera_3 "
end if

'response.Write("Sql Adicional :<pre>"&sql_adicional&"</pre>")
if request.QueryString <> "" then
	sql_datos_eventos = "select a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, "& vbCrLf &_
							" a.pers_tdireccion,g.ciud_tcomuna as ciudad_alumno, g.ciud_tdesc as comuna_alumno, "& vbCrLf &_
							" a.pers_temail,a.pers_tfono,a.pers_tcelular, "& vbCrLf &_
							" e.teve_tdesc as tipo_evento,d.pest_tdesc as preferencia_estudio, "& vbCrLf &_
							" f.cole_tdesc as colegio_alumno,i.ciud_tdesc as comuna_colegio, i.ciud_tcomuna as ciudad_colegio, "& vbCrLf &_
							" h.caev_tdesc as curso_alumno,(select cole_tdesc  from colegios where cole_ccod=c.cole_ccod) as colegio_evento "& vbCrLf &_
							" ,c.* "&select_add&" "& vbCrLf &_
							" from personas_eventos_upa a, "& vbCrLf &_
							" eventos_alumnos b,  "& vbCrLf &_
							" eventos_upa c,  "& vbCrLf &_
							" preferencia_estudio d,  "& vbCrLf &_
							" tipo_evento e,  "& vbCrLf &_
							" colegios f, "& vbCrLf &_
							" ciudades g, "& vbCrLf &_
							" cursos_alumnos_eventos h, "& vbCrLf &_
							" ciudades i "& vbCrLf &_
							" where a.pers_ncorr_alumno=b.pers_ncorr_alumno   "& vbCrLf &_
							" "&sql_adicional&" "& vbCrLf &_
							" and b.pest_ccod=d.pest_ccod "& vbCrLf &_
							" and b.even_ncorr=c.even_ncorr "& vbCrLf &_
							" and c.teve_ccod=e.teve_ccod "& vbCrLf &_
							" and a.cole_ccod=f.cole_ccod "& vbCrLf &_
							" and a.ciud_ccod=g.ciud_ccod "& vbCrLf &_
							" and a.caev_ccod=h.caev_ccod "& vbCrLf &_
							" and f.ciud_ccod=i.ciud_ccod "& vbCrLf &_
							" order by a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno"

else
	sql_datos_eventos="select '' where 1=2 " 
end if			 

'response.Write("<pre>"&sql_datos_eventos&"</pre>")
'response.End()				 


formulario.consultar sql_datos_eventos


%>


<html>
<head>
<title>Reporte Eventos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">



</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
        
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
			<td>
			<table cellspacing="0"  cellpadding="0" >
			<form name="buscador">
				<tr>
					<td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
					<td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
					<td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              	</tr>
				<tr>
					<td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
								<td width="209" valign="middle" background="../imagenes/fondo1.gif"><div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Filtro de busqueda</font></div></td>
								<td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
							</tr>
						</table></td>
					<td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              	</tr>
				<tr>
					<td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
					<td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
					<td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              	</tr>
				<tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
				  <td bgcolor="#D8D8DE">				  <table width="100%">
                    <tr>
                      <td width="17%"><strong> Eventos desde </strong></td>
                      <td width="2%"><strong>:</strong></td>
                      <td width="24%"> <%f_busqueda.dibujaCampo("even_fevento")%>  (dd/mm/aaaa)</td>
                      <td width="13%"><strong>Eventos Hasta</strong></td>
                      <td width="3%"><strong>:</strong></td>
                      <td colspan="3"><%f_busqueda.dibujaCampo("fecha_termino")%>   (dd/mm/aaaa) </td>
                    </tr>
                    <tr>
                      <td><strong> Curso</strong></td>
                      <td><strong>:</strong></td>
                      <td>
                        <%f_busqueda.dibujaCampo("caev_ccod")%></td>
                      <td><strong> Tipo Evento</strong></td>
                      <td><strong>:</strong></td>
                      <td width="18%"><%f_busqueda.dibujaCampo("teve_ccod")%></td>
                      <td width="23%" colspan="2" rowspan="4"><%botonera.DibujaBoton "buscar_eventos"%></td>
                    </tr>
                    <tr>
                      <td><strong>Comuna Evento </strong></td>
                      <td><strong>:</strong></td>
					  <td> <%f_busqueda.dibujaCampo("ciud_ccod")%></td>
                      <td><strong>Perfil Colegio </strong></td>
					  <td><strong>:</strong></td>
                      <td><%f_busqueda.dibujaCampo("pcol_ccod")%></td>
                    </tr>
                    <tr>
                      <td><strong>Carrera</strong>(anterior al 2006)</td>
					  <td><strong>:</strong></td>
                      <td colspan="4"><%f_busqueda.dibujaCampo("carrera")%> (escribir patron mas comun ej: comercial, para ingenieria comercial)</td>
                    </tr>
					 <tr>
						<td><strong>Carreras</strong></td>
					   	<td><strong>:</strong></td>
                      	<td colspan="4"><%f_busqueda.dibujaCampo("carre_ccod")%></td>
					</tr>
                  </table></td>
				  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
				<tr>
                	<td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                  	<td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                	<td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              	</tr> 
			  </form>
			</table>

			</td>
		</tr>
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">R</font><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">eporte
                          de alumnos por eventos </font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>
                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
                      <table width="100%" border="0">
                        <tr> 
                          <td>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td align="right"><strong><font color="000000" size="1"> 
                            <% formulario.pagina%></font></strong>
                            &nbsp;&nbsp;&nbsp;&nbsp; 
                            <% formulario.accesoPagina%>
                            </td>
                        </tr>
                        <tr> 
                          <td align="center"><strong><font color="000000" size="1"> 
                            <% formulario.dibujaTabla%>
                            </font></strong></td>
                        </tr>
                        <tr>
                              <td align="right">&nbsp; </td>
                        </tr>
                      </table>
                      <strong><font color="000000" size="1"> </font></strong></td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="100%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"> <%botonera.dibujaboton "salir"%> </td>
					  <td><%botonera.dibujaboton "excel"%></td>
                    </tr>
                  </table>                    
                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
  
   </td>
  </tr>  
</table>
</body>
</html>
