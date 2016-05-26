<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

pers_ncorr = request.QueryString("personas[0][pers_ncorr]")

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar



set pagina = new CPagina

set errores 	= new cErrores

set botonera =  new CFormulario
botonera.carga_parametros "listado_postulaciones.xml","botonera"

tituloPag = "Detalle de postulación alumno"


pagina.Titulo = tituloPag
periodo=negocio.ObtenerPeriodoAcademico("POSTULACION")


set f_postulaciones = new cformulario
f_postulaciones.carga_parametros "listado_postulaciones.xml","f_detalle"
f_postulaciones.inicializar conectar

if pers_ncorr <> "" then

consulta =  "  select a.post_ncorr,b.ofer_ncorr,protic.initcap(d.sede_tdesc) as sede,protic.initcap(f.carr_tdesc) + ' (' + case g.jorn_ccod when 1 then 'D' else 'V' end + ')' as carrera,protic.initcap(g.jorn_tdesc) as jornada," & vbCrLf &_
			" (select case count(*) when 0 then 'No' else 'Sí' end  from alumnos alu where a.post_ncorr=alu.post_ncorr and b.ofer_ncorr = alu.ofer_ncorr and emat_ccod = 1) as matriculado, " & vbCrLf &_
			" case isnull(b.eepo_ccod,1) when 2 then '<font color=''#2d5bc7''><strong>' +protic.initcap(h.eepo_tdesc)+ '</strong></font>' " & vbCrLf &_
			" when 7 then '<font color=''#0ea02f''><strong>' +protic.initcap(h.eepo_tdesc)+ '</strong></font>' " & vbCrLf &_
			" when 3 then '<font color=''#f54415''><strong>' +protic.initcap(h.eepo_tdesc)+ '</strong></font>' " & vbCrLf &_
			" else protic.initcap(h.eepo_tdesc) end as estado_examen, " & vbCrLf &_
			" isnull(i.obpo_tobservacion,'') as obpo_tobservacion,isnull(i.eopo_ccod,1) as eopo_ccod, fecha_llamado as fecha_llamado  " & vbCrLf &_
			" from postulantes a join detalle_postulantes b " & vbCrLf &_
			"    on a.post_ncorr=b.post_ncorr  " & vbCrLf &_
			" join ofertas_academicas c " & vbCrLf &_
			"    on b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
			" join sedes d " & vbCrLf &_
			"    on c.sede_ccod=d.sede_ccod" & vbCrLf &_
			" join especialidades e " & vbCrLf &_
		    "    on c.espe_ccod=e.espe_ccod " & vbCrLf &_
			" join carreras f " & vbCrLf &_
			"    on e.carr_ccod=f.carr_ccod " & vbCrLf &_
			" join jornadas g " & vbCrLf &_
		    "    on c.jorn_ccod=g.jorn_ccod " & vbCrLf &_
			" join estado_examen_postulantes h  " & vbCrLf &_
		    "    on b.eepo_ccod=h.eepo_ccod and h.eepo_ccod not in (3,4)" & vbCrLf &_
			" left outer join observaciones_postulacion i " & vbCrLf &_
			"    on b.post_ncorr = i.post_ncorr and b.ofer_ncorr = i.ofer_ncorr    " & vbCrLf &_
			" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
		    " and cast(a.peri_ccod as varchar)='"&periodo&"'"


'response.Write("<pre>"&consulta&"</pre>")
end if

f_postulaciones.Consultar consulta
cantidad_lista=f_postulaciones.nroFilas

nombre_alumno = conectar.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' +pers_tape_materno) from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
rut_alumno = conectar.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
fono_alumno = conectar.consultaUno("select pers_tfono from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
celular_alumno = conectar.consultaUno("select pers_tcelular from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
email_alumno = conectar.consultaUno("select pers_temail from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
direccion_alumno = conectar.consultaUno("select protic.obtener_direccion_letra('"&pers_ncorr&"',1,'CNPB')")
comuna_alumno = conectar.consultaUno("select protic.obtener_direccion_letra('"&pers_ncorr&"',1,'C-C')")


set f_historico = new cformulario
f_historico.carga_parametros "listado_postulaciones.xml","f_historico_postulaciones"
f_historico.inicializar conectar

if pers_ncorr <> "" then

consulta_historico = "Select * from ("  & vbCrLf &_
            "   select distinct a.post_ncorr,b.ofer_ncorr,protic.initcap(d.sede_tdesc) as sede,protic.initcap(f.carr_tdesc) as carrera,protic.initcap(g.jorn_tdesc) as jornada, " & vbCrLf &_
			" (select case count(*) when 0 then 'No' else 'Sí' end  from alumnos alu where a.post_ncorr=alu.post_ncorr and b.ofer_ncorr = alu.ofer_ncorr and emat_ccod = 1) as matriculado, " & vbCrLf &_
			" protic.initcap(h.eepo_tdesc) as estado_examen,isnull(i.obpo_tobservacion,'') as obpo_tobservacion, eopo_tdesc as estado, isnull(protic.trunc(fecha_llamado),'') as fecha_llamado,   " & vbCrLf &_
			" protic.trunc(i.audi_fmodificacion) as fecha_modificacion,i.audi_fmodificacion " & vbCrLf &_
			" from postulantes a join detalle_postulantes b " & vbCrLf &_
			"    on a.post_ncorr=b.post_ncorr  " & vbCrLf &_
			" join ofertas_academicas c " & vbCrLf &_
			"    on b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
			" join sedes d " & vbCrLf &_
			"    on c.sede_ccod=d.sede_ccod" & vbCrLf &_
			" join especialidades e " & vbCrLf &_
			"    on c.espe_ccod=e.espe_ccod " & vbCrLf &_
			" join carreras f " & vbCrLf &_
			"    on e.carr_ccod=f.carr_ccod " & vbCrLf &_
			" join jornadas g " & vbCrLf &_
			"    on c.jorn_ccod=g.jorn_ccod " & vbCrLf &_
			" join estado_examen_postulantes h  " & vbCrLf &_
			"    on b.eepo_ccod=h.eepo_ccod and h.eepo_ccod not in (3,4)" & vbCrLf &_
			" join observaciones_postulacion i " & vbCrLf &_
			"    on b.post_ncorr = i.post_ncorr and b.ofer_ncorr = i.ofer_ncorr    " & vbCrLf &_
			" join estado_observaciones_postulacion j" & vbCrLf &_
			"    on j.eopo_ccod   = i.eopo_ccod" & vbCrLf &_
			" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
			" and cast(a.peri_ccod as varchar)='"&periodo&"'" & vbCrLf &_
			" UNION "  & vbCrLf &_
			"   select distinct a.post_ncorr,b.ofer_ncorr,protic.initcap(d.sede_tdesc) as sede,protic.initcap(f.carr_tdesc) as carrera,protic.initcap(g.jorn_tdesc) as jornada, " & vbCrLf &_
			" (select case count(*) when 0 then 'No' else 'Sí' end  from alumnos alu where a.post_ncorr=alu.post_ncorr and b.ofer_ncorr = alu.ofer_ncorr and emat_ccod = 1) as matriculado, " & vbCrLf &_
			" protic.initcap(h.eepo_tdesc) as estado_examen,isnull(i.obpo_tobservacion,'') as obpo_tobservacion, eopo_tdesc as estado, isnull(protic.trunc(fecha_llamado),'') as fecha_llamado,   " & vbCrLf &_
			" protic.trunc(i.audi_fmodificacion) as fecha_modificacion,i.audi_fmodificacion " & vbCrLf &_
			" from postulantes a join detalle_postulantes b " & vbCrLf &_
			"    on a.post_ncorr=b.post_ncorr  " & vbCrLf &_
			" join ofertas_academicas c " & vbCrLf &_
			"    on b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
			" join sedes d " & vbCrLf &_
			"    on c.sede_ccod=d.sede_ccod" & vbCrLf &_
			" join especialidades e " & vbCrLf &_
			"    on c.espe_ccod=e.espe_ccod " & vbCrLf &_
			" join carreras f " & vbCrLf &_
			"    on e.carr_ccod=f.carr_ccod " & vbCrLf &_
			" join jornadas g " & vbCrLf &_
			"    on c.jorn_ccod=g.jorn_ccod " & vbCrLf &_
			" join estado_examen_postulantes h  " & vbCrLf &_
			"    on b.eepo_ccod=h.eepo_ccod and h.eepo_ccod not in (3,4)" & vbCrLf &_
			" join observaciones_postulacion_log i " & vbCrLf &_
			"    on b.post_ncorr = i.post_ncorr and b.ofer_ncorr = i.ofer_ncorr    " & vbCrLf &_
			" join estado_observaciones_postulacion j" & vbCrLf &_
			"    on j.eopo_ccod   = i.eopo_ccod" & vbCrLf &_
			" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
			" and cast(a.peri_ccod as varchar)='"&periodo&"'" & vbCrLf &_
			" ) table1 order by audi_fmodificacion desc"


'response.Write("<pre>"&consulta_historico&"</pre>")
end if

f_historico.Consultar consulta_historico


%>
<html>
<head>
<title>detalle postulaciones</title>
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
                      <%if RegistrosN > 0 then%>
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
                      <table width="98%" align="center">
					    <tr>
                          <td width="10%"><strong>Nombre</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=nombre_alumno%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Rut</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=rut_alumno%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Fono</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=fono_alumno%>  ---> <strong>Celular : </strong><%=celular_alumno%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>E-mail</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=email_alumno%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>direcci&oacute;n</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=direccion_alumno%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Ciudad</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=comuna_alumno%></td>
                        </tr>
                        <tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%f_postulaciones.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%f_postulaciones.dibujatabla()%> </td>
                        </tr>
						<tr> 
                          <td align="right" colspan="3"><font color="#990000"><strong>CT: Contactado Telefónicamente</strong></font></td>
                        </tr>
						<tr>
						  <td align="center" colspan="3"><hr></td>	
						</tr>
						<tr><td align="left" colspan="3"> <%pagina.DibujarSubtitulo "Seguimiento postulación alumno"%></td></tr>
						<tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%f_historico.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%f_historico.dibujatabla()%> </td>
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
							botonera.agregabotonparam "anterior","url","listado_postulaciones.asp?busqueda[0][pers_nrut]="&session("rut_postulacion")&"&busqueda[0][pers_xdv]="&session("digito_postulacion")&"&busqueda[0][sede_ccod]="&session("sede_postulacion")&"&selecciono_carrera="&session("s_c_postulacion")&"&ingreso_familia="&session("i_f_postulacion")&"&postulacion_enviada="&session("p_e_postulacion")&"&test_rendido="&session("t_r_postulacion")&"&matriculado="&session("m_postulacion")&"&revisar="&session("r_postulacion")
							botonera.dibujaboton("anterior") %>
                          </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center">
                            <% botonera.dibujaboton("salir") %>
                          </div></td>
				  <td> <div align="center">  <%botonera.dibujaboton "guardar"
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
