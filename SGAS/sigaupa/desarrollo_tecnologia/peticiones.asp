<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 sede_ccod = request.querystring("b[0][sede_ccod]")
 tpus_ccod= request.querystring("b[0][tpus_ccod]")

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina
pagina.Titulo = "Solicitudes de Soporte"

set botonera = new CFormulario
botonera.carga_parametros "solicita_soporte.xml", "botonera"


 set f_solicitudes = new CFormulario
f_solicitudes.Carga_Parametros "solicita_soporte.xml", "solicitudes"
f_solicitudes.Inicializar conexion


if sede_ccod <>"" then
filtro="and a.sede_ccod="&sede_ccod&""
else
filtro=""
end if

if tpus_ccod <>"" then
filtro3="and c.tpus_ccod="&tpus_ccod&""
else
filtro3=""
end if

usu=negocio.ObtenerUsuario()

sedes=conexion.consultaUno("select protic.obtener_sedes_sistema_usuario(protic.obtener_pers_ncorr("&usu&"))")
'sql_descuentos= "select a.inci_ccod,"&sedes&" as pers_ncorr_responsable,a.inci_ccod as inci_ccod2,protic.trunc(FECHA_INCIDENTE)as FECHA_INCIDENTE,folio,peso_tfono,peso_temail,(select sede_tdesc from sedes aaa where aaa.sede_ccod=a.sede_ccod)as sede, (select pers_tnombre+' '+pers_tape_paterno from personas aa where aa.pers_ncorr=a.pers_ncorr )as persona_solicitante,peso_tdescripcion as solicitud,(select tpus_tdesc from info_usuarios_soporte aa,tipos_prioridad_usuarios bb where aa.tpus_ccod=bb.tpus_ccod and aa.pers_ncorr=a.pers_ncorr)as tpus_tdesc,peso_tcargo,peso_tdepto,peso_tubicacion from peticion_soporte a, incidentes b where  a.inci_ccod=b.inci_ccod and  a.sede_ccod in ("&sedes&") and pers_ncorr_responsable is null and protic.trunc(FECHA_INCIDENTE)=protic.trunc(getdate()) "&filtro&""

sql_descuentos="select a.inci_ccod,"&sedes&" as pers_ncorr_responsable,"& vbCrLf &_
"a.inci_ccod as inci_ccod2,"& vbCrLf &_
"protic.trunc(FECHA_INCIDENTE)as FECHA_INCIDENTE,"& vbCrLf &_
"folio,"& vbCrLf &_
"peso_tfono,"& vbCrLf &_
"peso_temail,"& vbCrLf &_
"sede_tdesc as sede, "& vbCrLf &_
"(select pers_tnombre+' '+pers_tape_paterno from personas aa where aa.pers_ncorr=a.pers_ncorr )as persona_solicitante,"& vbCrLf &_
"peso_tdescripcion as solicitud,tpus_tdesc,"& vbCrLf &_
"peso_tcargo,"& vbCrLf &_
"peso_tdepto,"& vbCrLf &_
"peso_tubicacion "& vbCrLf &_
"from peticion_soporte a "& vbCrLf &_
" join incidentes b "& vbCrLf &_
" on a.inci_ccod=b.inci_ccod "& vbCrLf &_
" left outer join info_usuarios_soporte c"& vbCrLf &_
" on a.pers_ncorr=c.pers_ncorr"& vbCrLf &_
" left outer join tipos_prioridad_usuarios d"& vbCrLf &_
" on c.tpus_ccod=d.tpus_ccod"& vbCrLf &_
" join sedes e"& vbCrLf &_
" on a.sede_ccod=e.sede_ccod"& vbCrLf &_
"where  a.sede_ccod in ("&sedes&") and pers_ncorr_responsable is null and protic.trunc(FECHA_INCIDENTE)=protic.trunc(getdate()) "&filtro&" "&filtro3&""

'response.Write(sql_descuentos)
f_solicitudes.Consultar sql_descuentos

'response.Write(sql_descuentos)


set formulario_filtro = new cformulario
formulario_filtro.carga_parametros "solicita_soporte.xml", "filtra_solicitudes"
formulario_filtro.inicializar conexion
consulta="select ''"
formulario_filtro.consultar consulta 
consulta_sede="(select sede_ccod,sede_tdesc from sedes where sede_ccod in ("&sedes&"))a"
formulario_filtro.siguiente
formulario_filtro.agregacampoparam "sede_ccod", "destino", consulta_sede
formulario_filtro.AgregaCampoCons "sede_ccod", sede_ccod
formulario_filtro.AgregaCampoCons "tpus_ccod", tpus_ccod


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
function filtrar()
{
	document.forms['filtrado'].action = "peticiones.asp";
	document.forms['filtrado'].method = "get";
	document.forms['filtrado'].submit();
}

function alcargar()
{
sede='<%=sede_ccod%>'	
document.filtrado.elements['b[0][sede_ccod]'].value=sede
}


function Validar_asignacion(){
nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ )
    {
		  comp = document.edicion.elements[i];
		  str  = document.edicion.elements[i].name;
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
		  {
			 num += 1;
		  }
	}
	if (num>0) 
	{
		return true;
	}
	else
	{
		alert('Debes seleccionar al menos una peticion')
		return false;
	}
}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="alcargar();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">

<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
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
				<td><%lenguetas=Array(Array("Peticiones del Día","peticiones.asp"),Array("Peticiones Pendientes","peticiones_pendientes.asp"))
						pagina.DibujarLenguetas lenguetas, 1 %>
				</td>
		  </tr>
		  <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				<table align="center">
					<tr>
						<td>
							<%pagina.DibujarTituloPagina%>
						</td>
					</tr>
				</table>
				<br/>
				<form name="filtrado">
				<table align="center">
					<tr>
						<td>Sede</td>
						<td><%formulario_filtro.dibujaCampo("sede_ccod")%></td>
					</tr>
					<tr>
						<td>Prioridades</td>
						<td><%formulario_filtro.dibujaCampo("tpus_ccod")%></td>
					</tr>
					<tr>
						<td colspan="2" align="right"><%botonera.DibujaBoton "buscar2"%></td>
					</tr>
				</table>
				</form>
				<br/>
				<form name="edicion">
				<table align="center">
					<tr>
                             <td align="right">P&aacute;gina:
                                 <%f_solicitudes.accesopagina%>
                             </td>
                      </tr>
					<tr>
						<td>
							<%f_solicitudes.DibujaTabla()%>
						</td>
					</tr>
				</table>
				</form>
				</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
    <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%botonera.DibujaBoton"tomar_solicitud" %></div></td>
					<td><div align="center">
                    
					<%botonera.DibujaBoton"salir" %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
	
	<br>
	<br>
	</td>
  </tr>  
</table> 
</body>
</html>