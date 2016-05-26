<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
tipo = Request.QueryString("tipo")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()

'response.Write("e_empr_nrut "&e_empr_nrut)
session("url_actual")="../mantenedores/habilitar_relator.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Habilitación de Relatores"

set botonera =  new CFormulario
botonera.carga_parametros "habilitar_relator.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
'----------------------------------------------------------------------- 
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "habilitar_relator.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

if q_pers_nrut <> "" and q_pers_xdv <> "" then

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
rut = q_pers_nrut&"-"&q_pers_xdv 
	set f_datos = new CFormulario
	f_datos.Carga_Parametros "habilitar_relator.xml", "f_relatores"
	f_datos.Inicializar conexion
	
	consulta =  " select a.dgso_ncorr,a.pers_ncorr,a.anos_ccod,dcur_tdesc as programa, dcur_nsence as sence,a.anos_ccod as anio,tcat_tdesc  " & vbCrLf &_
				" from relatores_programa a,tipos_categoria tc , " & vbCrLf &_
				" datos_generales_secciones_otec b,  " & vbCrLf &_
				" diplomados_cursos c  " & vbCrLf &_
				" where a.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_
				" and b.dcur_ncorr=c.dcur_ncorr  and a.tcat_ccod=tc.tcat_ccod" & vbCrLf &_
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
				" and a.anos_ccod = datepart(year,getDate()) " 
	'response.Write("<pre>"&consulta&"</pre>")
	'response.End()
	f_datos.Consultar consulta
	

'-------------------------buscamos todos los programas en que el alumno no relator no este asociado para el periodo.
set f_nuevo = new CFormulario
f_nuevo.Carga_Parametros "habilitar_relator.xml", "f_nuevo"
f_nuevo.Inicializar conexion
f_nuevo.Consultar "select '' "
f_nuevo.Siguiente
anos_ccod = conexion.consultaUno("select datePart(year,getDate())")

f_nuevo.AgregaCampoCons "pers_ncorr", pers_ncorr
f_nuevo.AgregaCampoCons "anos_ccod", anos_ccod

consulta_programas = " (select b.dgso_ncorr,c.sede_tdesc+ ' : ' + dcur_tdesc as programa  " & vbCrLf &_
					 " from diplomados_cursos a, " & vbCrLf &_
					 " datos_generales_secciones_otec b,sedes c " & vbCrLf &_
					 " where a.dcur_ncorr=b.dcur_ncorr and esot_ccod<>3 " & vbCrLf &_
					 " and b.sede_ccod=c.sede_ccod " & vbCrLf &_
					 " and not exists (select 1 from relatores_programa cc where cc.dgso_ncorr=b.dgso_ncorr  " & vbCrLf &_
				     "                and cast(cc.pers_ncorr as varchar)='"&pers_ncorr&"' and cc.anos_ccod = datepart(year,getDate())) " & vbCrLf &_
					 " )a"


consulta_categorias = "(select tcat_ccod,tcat_tdesc+'  $'+cast(tcat_valor as varchar)as total from tipos_categoria where anos_ccod="&anos_ccod&")as d "
'response.Write("<pre>"&consulta_categorias&"</pre>")


f_nuevo.AgregaCampoParam "dgso_ncorr", "destino",consulta_programas	

f_nuevo.AgregaCampoParam "tcat_ccod", "destino",consulta_categorias

end if

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
function Validar_rut()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		formulario.elements["b[0][pers_nrut]"].focus();
		formulario.elements["b[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}


</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); ">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="68%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Rut</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td width="50%"><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")
							  pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
					<td align="right"><%botonera.dibujaboton "buscar"%></td>
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
	</td>
	</tr>
	</table>
	</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Habilitar Relatores"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if q_pers_nrut <> "" and q_pers_xdv <> "" then %>
				  
				  <tr>
				  	<td align="center">
						<form name="edicion">
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						   <tr>
						  <td>
						  Nombre:<strong><%=nombre%></strong>
						  </td>
						  </tr>
						   <tr>
						  <td >
						  Rut: <strong><%=rut%><strong>				  </td>
						  </tr>
						    <tr>
						  <td height="24">
						 
						  </td>
						  </tr>
						  <tr>
							<td><%pagina.DibujarSubtitulo "Listado de programas en donde esta habilitado el relator"%>
							  <br>
							                    
							  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
								<tr>
								<td><div align="right"><strong>P&aacute;ginas :</strong>                          
								  <%f_datos.accesopagina%>
								</div></td>
							  </tr>
							  <tr>
								<td align="right">&nbsp;</td>
							  </tr>
							  <tr>
								<td><div align="center">
									  <%f_datos.dibujatabla()%>
								</div></td>
							  </tr>
							  <tr>
								<td align="right"><%botonera.dibujaboton "eliminar"%></td>
							  </tr>
							  </table>
							</td>
						  </tr>
						 
						</table>
                          <br>
     					</form>
					</td>
				  </tr>
				  <br>
				  <tr>
				  	<td align="center">
						<form name="edicion2">
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						  <tr>
							<td><%pagina.DibujarSubtitulo "Habilitar Relator a Programa"%>
							  <br>
							                    
							  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
								<tr>
								  <td colspan="3"><%f_nuevo.dibujacampo("pers_ncorr")%><%f_nuevo.dibujacampo("anos_ccod")%></td>
							    </tr>
							    <tr>
								  <td width="19%"><strong>Nuevo Programa a Habilitar</strong></td>
								  <td width="1%"><strong>:</strong></td>
								  <td width="80%"><%f_nuevo.dibujacampo("dgso_ncorr")%></td>
							    </tr>
								<tr> 
								<td width="19%"></td>
								</tr>
								
								<tr>
								<td width="19%"><strong>Categoria Profesor</strong></td>
								  <td width="1%"><strong>:</strong></td>
								  <td width="80%"><%f_nuevo.dibujacampo("tcat_ccod")%></td>
								</tr>
								<tr>
								  <td width="19%">&nbsp;</td>
								  <td width="1%">&nbsp;</td>
								  <td width="80%" align="right"><%botonera.dibujaboton "agregar_programa"%></td>
							    </tr>
							  </table>
							</td>
						  </tr>
						</table>
                          <br>
     					</form>
					</td>
				  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
