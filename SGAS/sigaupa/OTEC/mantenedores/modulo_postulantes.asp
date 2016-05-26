
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")
q_leng 			= 	Request.QueryString("leng")
v_peri_cta		=	Request.QueryString("v_peri_cta")

if EsVacio(q_leng) then
	q_leng = "1"
end if

existe = ""

set pagina = new CPagina
pagina.Titulo = "Revisión datos Postulante"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "modulo_postulantes.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "modulo_postulantes.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
pers_ncorr = v_pers_ncorr

if v_pers_ncorr <> "" then
'---------------------------------------------------------------------------------------------------
set f_comentarios = new CFormulario
f_comentarios.Carga_Parametros "modulo_postulantes.xml", "lista_comentarios"
f_comentarios.Inicializar conexion
sql_comentarios ="Select comp_ncorr,protic.trunc(COMP_FCOMENTARIO) as COMP_FCOMENTARIO, SUBSTRING(COMP_TCOMENTARIO,1,100)+'...' as COMP_TCOMENTARIO,TICO_tdesc from COMENTARIOS_POSTULANTE_OTEC cpo,tipos_comentarios tc where cpo.TICO_ccod = tc.TICO_ccod and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
f_comentarios.Consultar sql_comentarios
'--------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "modulo_postulantes.xml", "datos_postulante"
formulario.Inicializar conexion
consulta ="Select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,pers_nrut,cast(pers_nrut as varchar)+'-'+pers_xdv as rut from personas p,postulacion_otec po where p.pers_ncorr=po.pers_ncorr and p.pers_ncorr='"&v_pers_ncorr&"'"
formulario.Consultar consulta
formulario.Siguiente
'--------------------------------------------------------------------------------------------------

set f_cursos = new CFormulario
f_cursos.Carga_Parametros "modulo_postulantes.xml", "f_cursos_postulante"
f_cursos.Inicializar conexion
consulta_curso ="select b.dgso_ncorr,dcur_tdesc , sede_tdesc, protic.trunc(b.dgso_finicio) as fecha_inicio,protic.trunc(b.dgso_ftermino) as fecha_termino, '<a href=""javascript:verEmpresa('+ cast((select pers_nrut from personas x where x.pers_ncorr =a.pers_ncorr ) as varchar)+','+cast(c.dcur_ncorr as varchar)+','+cast(b.dgso_ncorr as varchar)+')"">'+ f.fpot_tdesc + '</a>' as fpot_tdesc, epot_tdesc "& vbCrLf &_
				"from postulacion_otec a, datos_generales_secciones_otec b, diplomados_cursos c, sedes d,forma_pago_otec f, estados_postulacion_otec epo "  & vbCrLf &_
				"where a.pers_ncorr='"&v_pers_ncorr&"'"& vbCrLf &_
				"and a.dgso_ncorr= b.dgso_ncorr"& vbCrLf &_
				"and b.dcur_ncorr=c.dcur_ncorr"& vbCrLf &_
				"and a.fpot_ccod=f.fpot_ccod"& vbCrLf &_
				"and b.sede_ccod=d.sede_ccod"& vbCrLf &_
				"and a.epot_ccod = epo.epot_ccod"& vbCrLf &_
				"UNION "& vbCrLf &_
				"select b.dgso_ncorr,dcur_tdesc , sede_tdesc, protic.trunc(b.dgso_finicio) as fecha_inicio,protic.trunc(b.dgso_ftermino) as fecha_termino, '<a href=""javascript:verEmpresa('+ cast((select pers_nrut from personas x where x.pers_ncorr =a.pers_ncorr ) as varchar)+','+cast(c.dcur_ncorr as varchar)+','+cast(b.dgso_ncorr as varchar)+')"">'+ f.fpot_tdesc + '</a>' as fpot_tdesc, epot_tdesc + ' (ASOCIADA)' as epot_tdesc "& vbCrLf &_
				"from postulacion_asociada_otec a, datos_generales_secciones_otec b, diplomados_cursos c, sedes d,forma_pago_otec f, estados_postulacion_otec epo "  & vbCrLf &_
				"where a.pers_ncorr='"&v_pers_ncorr&"'"& vbCrLf &_
				"and a.dgso_ncorr= b.dgso_ncorr"& vbCrLf &_
				"and b.dcur_ncorr=c.dcur_ncorr"& vbCrLf &_
				"and a.fpot_ccod=f.fpot_ccod"& vbCrLf &_
				"and b.sede_ccod=d.sede_ccod"& vbCrLf &_
				"and a.epot_ccod = epo.epot_ccod"

f_cursos.Consultar consulta_curso
'f_cursos.Siguiente
'response.write(consulta_curso)
existe = conexion.ConsultaUno("Select count(*) as existe from personas p,postulacion_otec po where p.pers_ncorr=po.pers_ncorr and p.pers_ncorr='"&v_pers_ncorr&"'")

v_rut = formulario.obtenerValor("pers_nrut")
end if
url_leng_1 = "modulo_postulantes.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=1"
url_leng_2 = "modulo_postulantes.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=2"


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

function nuevo_comentario(){
	window.open("crea_comentario_postulantes.asp?pers_ncorr=<%=v_pers_ncorr%>","nuevo_comentario"," width=750, height=400,scrollbars,  toolbar=false, resizable");
}


function verEmpresa(pers_nrut,dcur_ncorr,dgso_ncorr){
	window.open("datos_modulo_postulante.asp?pers_nrut="+pers_nrut+"&dcur_ncorr="+dcur_ncorr+"&dgso_ncorr="+dgso_ncorr,"nuevo_comentario"," width=800, height=470,scrollbars,  toolbar=false, resizable");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="32%"><div align="right">R.U.T.</div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
                      </tr>
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
        <td>
        <% 
		response.write(rut)
		if q_pers_nrut <> "" and v_rut <>"" then%>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
			<form name="edicion">
			  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                  <tr>
                    <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                    <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                    <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                  </tr>
                  <tr>
                    <td width="9" background="../imagenes/marco_claro/9.gif"></td>
                    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td><%pagina.DibujarLenguetasFClaro Array(Array("Datos Postulante", url_leng_1), Array("Comentarios", url_leng_2)), CInt(q_leng) %></td>
                        </tr>
                        <tr>
                          <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                        </tr>
                        <tr>
                          <td> 
                            <div align="left"><br>							
                              <br>
							<%
							select case q_leng
								case "1"
									pagina.DibujarSubtitulo("Datos Postulante")									
								case "2"
									pagina.DibujarSubtitulo("Comentarios")
							end select
							%>
                            </div>                            
                            <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td><div align="center">
												<table>
													<tr>
													<td width="10%" align="left"><strong>RUT:</strong>&nbsp;&nbsp;</td>
													<td width="50%"><%=formulario.dibujacampo("rut")%></td>
													</tr>
													<tr>
													<td width="10%" align="left"><strong>Nombre:</strong>&nbsp;&nbsp;</td>
													<td width="50%"><%=formulario.dibujacampo("nombre")%></td>
													</tr>
												</table>
                                        <%select case q_leng
											case "1"%>														
												<div align="right"><%f_cursos.AccesoPagina%></div>
												<%
												f_cursos.DibujaTabla
											case "2"%>												
												<br>
												<div align="right"><%f_comentarios.AccesoPagina%></div>
												<%
												f_comentarios.DibujaTabla
										end select
										%>
                                  </div></td>
                                </tr>
                            </table><br>
							<% if q_leng="1" then   
							
							end if %>
							<% if q_leng="2" then %>
                            <table>
                            <tr>
							<td><%f_botonera.DibujaBoton("nuevo_comentario") %></td>
							<td><%f_botonera.DibujaBoton ("eliminar")%></td>
                            </tr>
                            </table>							
							<%end if %>
                          </td>
                        </tr>
                    </table></td>
                    <td width="7" background="../imagenes/marco_claro/10.gif"></td>
                  </tr>
                  <tr>
                    <td width="9" height="13"><img src="../imagenes/marco_claro/base1.gif" width="9" height="13"></td>
                    <td height="13" background="../imagenes/marco_claro/15.gif"></td>
                    <td width="7" height="13"><img src="../imagenes/marco_claro/base3.gif" width="7" height="13"></td>
                  </tr>
                </table>
                <br>
            </form>            
            </td></tr>            
        </table>
		<% end if %>
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="45%"> 
                          
                        </td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
<%if existe = 0 then %>
<script language="JavaScript">
  alert("No existe este postulante en los cursos..")
</script><%end if%>