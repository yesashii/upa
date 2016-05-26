<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------

q_leng 			= 	Request.QueryString("leng")
v_peri_cta		=	Request.QueryString("v_peri_cta")

if EsVacio(q_leng) then
	q_leng = "1"
end if


set pagina = new CPagina
pagina.Titulo = "Revisión de Cuenta Corriente"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cuenta_corriente_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cuenta_corriente_alumno.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
pers_ncorr = v_pers_ncorr

v_peri_ccod_pos = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_peri_ccod_18  = negocio.ObtenerPeriodoAcademico("CLASES18")
'response.Write("peri postulacion: "&v_peri_ccod_pos&" <br> Peri Calses18: "&v_peri_ccod_18)
if cint(v_peri_ccod_pos) < cint(v_peri_ccod_18) then
	v_peri_ccod = v_peri_ccod_18
else
	v_peri_ccod = v_peri_ccod_pos
end if
periodo = v_peri_ccod

' AGREGADO PARA MOSTRAR LAS CARRERAS A LAS QUE HA PERTENECIDO EL ALUMNO
'---------------------------------------------------------------------------------------------------

				   
consulta_carreras = " select d.carr_tdesc as salida ,d.carr_ccod " & vbcrlf & _
				   " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbcrlf & _
				   " where cast(a.pers_ncorr as varchar)='" & v_pers_ncorr & "' " & vbcrlf & _
                   " and a.emat_ccod=1 " & vbcrlf & _
				   " and a.ofer_ncorr=b.ofer_ncorr " & vbcrlf & _
				   " and b.espe_ccod=c.espe_ccod " & vbcrlf & _
				   " and c.carr_ccod=d.carr_ccod " & vbcrlf & _
                   " group by d.carr_ccod,d.carr_tdesc "				   



'---------------------------------------------------------------------------------------------------
set f_periodos = new CFormulario
f_periodos.Carga_Parametros "cuenta_corriente_alumno.xml", "periodos_cta_cte"
f_periodos.Inicializar conexion
sql_periodos="select distinct peri_ccod from periodos_academicos "
f_periodos.Consultar sql_periodos

if v_pers_ncorr <> "" then
	f_periodos.AgregaCampoParam "peri_ccod", "filtro", " anos_ccod >= protic.ANO_INGRESO_UNIVERSIDAD("&v_pers_ncorr&")"
	f_periodos.AgregaCampoCons "peri_ccod", v_peri_cta
	
	sql_total_periodos=conexion.ConsultaUno("select count(*) from periodos_academicos where anos_ccod>= protic.ANO_INGRESO_UNIVERSIDAD("&v_pers_ncorr&")")
	
else

	f_periodos.AgregaCampoParam "peri_ccod", "filtro", "1=2"
	'f_periodos.AgregaCampoCons "peri_tdesc", "Seleccione "
	
end if
f_periodos.siguienteF


'---------------------------------------------------------------------------------------------------
set f_comentarios = new CFormulario
f_comentarios.Carga_Parametros "cuenta_corriente_alumno.xml", "lista_comentarios"
f_comentarios.Inicializar conexion
sql_comentarios ="Select come_ncorr,COME_FCOMENTARIO, SUBSTRING(COME_TCOMENTARIO,1,100)+'...' as COME_TCOMENTARIO,TICO_CCOD from comentarios where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
f_comentarios.Consultar sql_comentarios
'---------------------------------------------------------------------------------------------------



set cuenta_corriente = new CCuentaCorriente
cuenta_corriente.Inicializar conexion, q_pers_nrut, v_peri_cta
if v_peri_cta <> "" then
	filtro="SI"
else
	filtro="NO"
end if
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
url_leng_1 = "cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=1&v_peri_cta="&v_peri_cta
url_leng_2 = "cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=2&v_peri_cta="&v_peri_cta
url_leng_3 = "cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=" & q_pers_nrut & "&buscador[0][pers_xdv]=" & q_pers_xdv & "&leng=3&v_peri_cta="&v_peri_cta

'---------------------------------------------------------------------------------------------------

if v_peri_cta="" then
	v_peri_cta=v_peri_ccod
end if
'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno

 
'if EsVacio(persona.ObtenerMatrNCorr(v_peri_cta)) then
'	set f_datos = persona
'else
'	alumno.Inicializar conexion, persona.ObtenerMatrNcorr(v_peri_cta)
'	set f_datos = alumno
'end if

es_alumno = false

if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_cta)) then
	'set f_datos = persona
	'set f_datos = persona
	'persona="SI"
		
' obtiene el periodo de la ultima matricula existente
	sql_ultima_matricula="select max(peri_ccod) from postulantes a, alumnos b where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"'"
	v_peri_ant=conexion.ConsultaUno(sql_ultima_matricula)
	'response.Write("<hr>"&sql_ultima_matricula&"<br> Periodo ultimo: "&v_peri_ant&"<hr>")
	'response.End() 
	if EsVacio(v_peri_ant) then ' no existe matricula para ningun periodo
		set f_datos = persona
		persona="SI"
	else ' busca matricula correspondiante a ultimo periodo cursado
		if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_ant)) then
			set f_datos = persona
			persona="SI"
		else
			es_alumno = true
			alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_ant), v_peri_ant,v_peri_cta
			set f_datos = alumno
			persona="NO&periodo="&v_peri_ant&"&filtro="&filtro&"&peri_sel="&v_peri_cta
			'persona="NO&matr_ncorr="&persona.ObtenerMatriculaPeriodo(v_peri_ant)
		end if
	end if
	
else
	es_alumno = true
	alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_cta), v_peri_cta,v_peri_cta
	set f_datos = alumno
	persona="NO&periodo="&v_peri_cta&"&filtro="&filtro&"&peri_sel="&v_peri_cta
	'persona="NO&matr_ncorr="&persona.ObtenerMatriculaPeriodo(v_peri_cta)
end if

'response.Write(cuenta_corriente.ObtenerSql ("DETALLE_COMPROMISOS"))

'if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_ccod)) then
'	persona="SI"
'else
'	persona="NO"	
'end if
	'response.End() 
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
var t_busqueda;

function InicioPagina()
{
	t_busqueda = new CTabla("buscador");
}


function Ficha_Alumno(){
	window.open("../MATRICULA/FICHA_ANTEC_PERSONALES.ASP?busqueda[0][pers_nrut]=<%=q_pers_nrut%>&busqueda[0][pers_xdv]=<%=q_pers_xdv%>&traspaso=1","nombre_pagina","scrollbars,  toolbar=false, resizable ");
}

function periodo_academico(periodo){
var v_peri;
v_peri=periodo;
	location.href="cuenta_corriente_alumno.asp?buscador[0][pers_nrut]=<%=q_pers_nrut%>&buscador[0][pers_xdv]=<%=q_pers_xdv%>&leng=<%=q_leng%>&v_peri_cta="+v_peri+"";
}

function nuevo_comentario(){
	window.open("crea_comentarios.asp?pers_ncorr=<%=v_pers_ncorr%>","nuevo_comentario"," width=750, height=400,scrollbars,  toolbar=false, resizable");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <form name="buscador">
		  <tr>
		      <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%><%f_busqueda.DibujaCampo("pers_xdv")%>
               </td>
          </tr>
		  </form>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
			  <% if v_pers_ncorr <> "" then %>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%f_datos.DibujaDatos%></td>
				  <td> <%'f_botonera.DibujaBoton("ficha_alumno")%></td>
                </tr>
				<tr>
					<td colspan="2"><%	if 	es_alumno = true then
											f_datos.DibujaDatos2
										end if
										%></td>
				</tr>
				<tr>
					<td colspan="2">
					<% if sql_total_periodos > 0 then %>
					<form name="periodo">
						<table width="100%">
						
						
							<tr>
								<td colspan="2"><br><hr></td>
							</tr>
							<tr>
								<td width="">
								<b>Periodo academico :</b><%=f_periodos.DibujaCampo("peri_ccod")%>
								
								</td>
								<td align="left"></td>
							</tr>
							<tr>
								<td colspan="2"><hr></td>
							</tr>
						
						</table>
						</form>
						<% end if %>
						
										
					</td>
				</tr>
				
              </table>
			  <%end if%>	
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
                          <td><%pagina.DibujarLenguetasFClaro Array(Array("Detalle de compromisos", url_leng_1), Array("Becas y descuentos", url_leng_2), Array("Comentarios", url_leng_3)), CInt(q_leng) %></td>
                        </tr>
                        <tr>
                          <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                        </tr>
                        <tr>
                          <td> 
                            <div align="left"><br>
							<%
							select case q_leng
								case "1"
									pagina.DibujarSubtitulo "Resumen"
									%>
									<table width="98%" cellpadding="0" cellspacing="0" align="center">
									<tr><td><%cuenta_corriente.DibujaResumenCompromisos%></td></tr>
									</table>
									<%
							end select
							%>
                              <br>
							<%
							select case q_leng
								case "1"
									pagina.DibujarSubtitulo("Detalle de compromisos")
								case "2"
									pagina.DibujarSubtitulo("Becas y descuentos")
								'case "3"
									'pagina.DibujarSubtitulo("Créditos")
							end select
							%>
                            </div>                            
                            <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td><div align="center">
                                        <%
										select case q_leng
											case "1"
												cuenta_corriente.DibujaDetalleCompromisos												
											case "2"
												cuenta_corriente.DibujaBecasDescuentos
											case "3"%>
												<div align="right"><%f_comentarios.AccesoPagina%></div>
												<%
												f_comentarios.DibujaTabla
										end select
										%>
                                  </div></td>
                                </tr>
                                                        </table>                            <br>	
							<%' if q_leng="3" then   f_botonera.DibujaBoton("nuevo_comentario") end if %>
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
            </form></td></tr>
        </table></td>
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
                          <%
							select case q_leng
							case "1"
							   if cuenta_corriente.NroFilasDibujadas = 0 then
							   	f_botonera.AgregaBotonParam "imprimir", "deshabilitado", "TRUE"
							   end if
							   f_botonera.AgregaBotonParam "imprimir","url", "../REPORTESNET/CuentaCorriente.aspx?pers_ncorr=" & pers_ncorr &"&persona="&persona
							   'f_botonera.AgregaBotonParam "imprimir","url", "http://localhost/reportes/CuentaCorriente/CuentaCorriente.aspx?pers_ncorr=" & pers_ncorr & "&periodo=" & periodo
							   f_botonera.DibujaBoton("imprimir")
							end select
							
							%>
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
