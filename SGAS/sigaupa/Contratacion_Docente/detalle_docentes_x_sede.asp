<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

sede = request.QueryString("sede_ccod")
grado = request.QueryString("grado")
tipo_jornada = request.QueryString("tipo_jornada")
sexo = request.QueryString("sexo")

if session("pagina_anterior")= "2" then
	url_anterior = "docentes_x_sede_y_grado.asp?busqueda[0][sede_ccod]="&sede
else
    url_anterior = "docentes_x_sede.asp?busqueda[0][sede_ccod]="&sede
end if

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar



set pagina = new CPagina


set botonera =  new CFormulario
botonera.carga_parametros "docentes_x_sede.xml","botonera"
tituloPag = "Listado docentes "




set docentes = new cformulario
docentes.carga_parametros "docentes_x_sede.xml","lista_docentes_horas"
docentes.inicializar conectar

'-------------------------------------------------------------------------------------------------------------------------
if grado= 5 then
	filtro_estricto = " "
	tituloPag = tituloPag + " con grado académico de Doctor"
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
		tituloPag = tituloPag + " con grado académico de Magíster"
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
	tituloPag = tituloPag + " con grado académico de Licenciado"    
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 
		tituloPag = tituloPag + " con Título Profesional "	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
	tituloPag = tituloPag + " Técnicos de nivel súperior"
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
	tituloPag = tituloPag + " sin título ni grado académico"
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 33"  
	tituloPag = tituloPag + " y en Jornada Completa"
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 32"  
	tituloPag = tituloPag + " y en Media Jornada"
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 19"  
	tituloPag = tituloPag + " y en Jornada Hora"
end if

pagina.Titulo = tituloPag

if sede = 2 then
	filtro_sede= " in ('1','2')"
else
	filtro_sede= " = '"&sede&"'"
end if

if grado > 2 then
docentes.agregaCampoParam "grado", "descripcion","Grado Académico"
consulta = " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, gpro_tdescripcion as grado, "& vbCrLf &_ 
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) as horas_semanales	 "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"& grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"'" 

elseif grado > 0 and grado <= 2 then
docentes.agregaCampoParam "grado", "descripcion","Título"
consulta = " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, d.cudo_titulo as grado,  "& vbCrLf &_
                    " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod ) as horas_semanales	 "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"'  and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " and cast(e.sexo_ccod as varchar)='"&sexo&"'"

else
docentes.agregaCampoParam "grado", "descripcion","Información"
consulta = " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, ' Sin título ni grado académico' as grado,  "& vbCrLf &_ 
           " (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod ) as horas,"& vbCrLf &_
			" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod ) as horas_semanales	 "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto1& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"& vbCrLf &_
					" union " & vbCrLf &_
				    " select distinct c.pers_ncorr, cast(e.pers_nrut as varchar)+'-'+ e.pers_xdv as rut, e.pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre, ' Sin título ni grado académico' as grado, "& vbCrLf &_
					" (select cast(isnull(sum(horas * 45 / 60),0) as numeric) from horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=e.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod ) as horas,"& vbCrLf &_
					" (select cast(sum(prof_nhoras) as numeric) from horas_docentes_carrera_final hdc "& vbCrLf &_
				    "  where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) as horas_semanales	 "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"		

end if

'--------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")
sede_tdesc = conectar.consultaUno("select protic.initCap(sede_tdesc) from sedes where cast(sede_ccod as varchar)='"&sede&"'")
sexo_tdesc = conectar.consultaUno("select protic.initCap(sexo_tdesc) from sexos where cast(sexo_ccod as varchar)='"&sexo&"'")

'response.Write("<pre>"&consulta&" order by nombre</pre>")
docentes.Consultar consulta &" order by nombre"
cantidad_lista= conectar.consultaUno("select count(distinct a.pers_ncorr) from ("&consulta&")a")

url_excel="listado_gestion_matricula_2.asp?sede="&sede&"&espe_ccod="&espe_ccod&"&epos_ccod="&epos_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo

%>
<html>
<head>
<title>Listado Docentes</title>
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
                          <td width="10%"><strong>Sede</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=sede_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Genero</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=sexo_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Total</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=cantidad_lista%> Docente(s)</td>
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
            <td width="38%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 
							botonera.agregabotonparam "anterior","url",url_anterior
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
				  <td> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "detalle_docentes_x_sede_excel.asp?sede_ccod="&sede&"&grado="&grado&"&tipo_jornada="&tipo_jornada&"&sexo="&sexo
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
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
