<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Gestión de Solicitudes de certificados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "gestion_solicitudes_certificados.xml", "botonera"

set errores 	= new cErrores

nombre = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
fono = conexion.consultaUno("select pers_tfono from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
celular = conexion.consultaUno("select pers_tcelular from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
email = conexion.consultaUno("select lower(pers_temail) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
rut = q_pers_nrut&"-"&q_pers_xdv 

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "gestion_solicitudes_certificados.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------------------------------------------------------------------------------------------------
pers_ncorr=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "gestion_solicitudes_certificados.xml", "listado"
f_alumno.Inicializar conexion
'response.End()
consulta =  " select a.sctg_ncorr as codigo,a.tctg_ccod,a.sctg_ncorr,a.pers_ncorr,protic.initCap(tctg_tdesc)+ '<br>(' + d.sede_tdesc+')' as tipo,protic.trunc(sctg_fsolicitud) fecha_solicitud, "& vbCrLf &_ 
			" protic.trunc(sctg_fmodificacion) as actualizado, a.esctg_ccod, "& vbCrLf &_ 
			" lower(observacion) as observacion,sctg_fsolicitud, isnull((select protic.initCap(carr_tdesc) from carreras tr where tr.carr_ccod collate Modern_Spanish_CI_AS =a.carr_ccod ),(select protic.initCap(saca_tdesc) from salidas_carrera tr where cast(tr.saca_ncorr as varchar)=a.carr_ccod)) as carrera,  "& vbCrLf &_ 
			" case a.tctg_ccod when 5 then '<a href=""javascript:mostrar_asignaturas('+ cast(a.pers_ncorr as varchar)+','+a.carr_ccod+');"">*</a>' else '' end as asterisco  "& vbCrLf &_
			" from solicitud_certificados_tyg a join tipos_certificados_tyg b  "& vbCrLf &_ 
			"	on	a.tctg_ccod=b.tctg_ccod  "& vbCrLf &_ 
			"  join estados_solicitud_certificados_tyg c  "& vbCrLf &_ 
			"  	on a.esctg_ccod=c.esctg_ccod  "& vbCrLf &_ 
			"  join sedes d  "& vbCrLf &_ 
			"  	on a.sede_ccod=d.sede_ccod  "& vbCrLf &_ 
			"  left outer join carreras e   "& vbCrLf &_ 
			"   on a.carr_ccod=e.carr_ccod COLLATE SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_ 
			" where  cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_ 
			" and a.ESCTG_CCOD <> 7 "& vbCrLf &_ 
			" order by sctg_fsolicitud, tipo "
'response.Write("<pre>"&consulta&"</pre>")			
f_alumno.Consultar consulta
nro_solicitudes = f_alumno.nroFilas
'---------------------------------------------------------------------------------------------------------------

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "gestion_solicitudes_certificados.xml", "listado_asignaturas"
f_asignaturas.Inicializar conexion
consulta =  " select sctg_ncorr as codigo, b.carr_tdesc as carrera, c.plan_tdesc as plan_estudio,  "& vbCrLf &_ 
			" d.nive_ccod as nivel, ltrim(rtrim(e.asig_ccod)) + ': ' + e.asig_tdesc as asignatura,a.ACER_ENVIADA as enviada   "& vbCrLf &_ 
			" from ASIGNATURAS_CERTIFICADO a, carreras b, planes_estudio c,malla_curricular d, asignaturas e  "& vbCrLf &_  
			" where cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"'  "& vbCrLf &_ 
			" and a.carr_ccod collate Modern_Spanish_CI_AS = b.carr_ccod and a.plan_ccod = c.plan_ccod  "& vbCrLf &_ 
			" and a.mall_ccod = d.mall_ccod and d.asig_ccod=e.asig_ccod  "& vbCrLf &_ 
			" order by a.ACER_FSOLICITUD desc,nivel asc, asignatura asc "
f_asignaturas.Consultar consulta


'---------------------------------------------------------------------------------------------------------------


set f_historico = new CFormulario
f_historico.Carga_Parametros "gestion_solicitudes_certificados.xml", "historico"
f_historico.Inicializar conexion
'response.End()
consulta =  " select a.tctg_ccod,a.sctg_ncorr,a.pers_ncorr,protic.initCap(tctg_tdesc)+ '<br>(' + d.sede_tdesc+')' as tipo,protic.trunc(sctg_fsolicitud) fecha_solicitud, "& vbCrLf &_ 
			" protic.trunc(sctg_fmodificacion) as actualizado, case c.esctg_ccod when 3 then 'RETIRAR EN DOS DÍAS HÁBILES A PARTIR DE '+ protic.trunc(sctg_fmodificacion) else c.esctg_tdesc end as estado, "& vbCrLf &_ 
			" lower(observacion) as observacion,sctg_fsolicitud, isnull((select protic.initCap(carr_tdesc) from carreras tr where tr.carr_ccod collate Modern_Spanish_CI_AS =a.carr_ccod ),(select protic.initCap(saca_tdesc) from salidas_carrera tr where cast(tr.saca_ncorr as varchar)=a.carr_ccod)) as carrera  "& vbCrLf &_ 
			" from historico_solicitud_certificados_tyg a join tipos_certificados_tyg b  "& vbCrLf &_ 
			"    on a.tctg_ccod=b.tctg_ccod  "& vbCrLf &_ 
			"  join estados_solicitud_certificados_tyg c  "& vbCrLf &_ 
			"  	on a.esctg_ccod=c.esctg_ccod  "& vbCrLf &_ 
			"  join sedes d  "& vbCrLf &_ 
			"  	on a.sede_ccod=d.sede_ccod  "& vbCrLf &_ 
 			"  left outer join carreras e   "& vbCrLf &_ 
			"  	on a.carr_ccod=e.carr_ccod COLLATE SQL_Latin1_General_CP1_CI_AS "& vbCrLf &_ 
			" where  cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_ 
			" order by sctg_fsolicitud,sctg_fmodificacion, tipo desc "
'response.Write("<pre>"&consulta&"</pre>")			
f_historico.Consultar consulta

usuario = negocio.obtenerUsuario
pers_temporal = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

'response.Write(usuario&" pers_ncorr "&pers_temporal)
es_de_registro_curricular = conexion.consultaUno("select count(*) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_temporal&"'")

set errores = new CErrores

tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")	
else
    nombre_foto = "user.png"
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
var t_busqueda;

function ValidaBusqueda()
{
	rut=document.buscador.elements['b[0][pers_nrut]'].value+'-'+document.buscador.elements['b[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['b[0][pers_nrut]'].focus()
		document.buscador.elements['b[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

function validaMorosidad()
{
	var estado = '<%=v_es_moroso%>';
	//alert("Estado "+estado);
	//var valor = formulario.elements["alumno[0][emat_ccod]"].value;
	nro = document.edicion.elements.length;
    num =0;
    for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  fila=extrae_indice(str);
	  valor=document.edicion.elements["alumno["+fila+"][emat_ccod]"].value;
	  if ((estado == 'S') && ((valor=="4")|| (valor=="8")))
		{
		alert('No se puede cambiar el estado del alumno, ya que se encuentra Moroso.');		
		return false;
		}
	}	

return true;	
}

function InicioPagina()
{
	t_busqueda = new CTabla("b");
}

function habilitarCondicional(valor,nombre)
{ //var estado = '<%=v_es_moroso%>';
  fila = extrae_indice(nombre);
  //alert(fila);
  if ((valor=="3")|| (valor=="5")||(valor=="7")||(valor=="10"))
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = false;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-N";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = true;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].value = "";
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-S";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-S";
		}
 
}

function deshabilita_inicial(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'text'){
	     num += 1;
		 fila=extrae_indice(str);
		 valor=document.edicion.elements["alumno["+fila+"][emat_ccod]"].value;
		 ajuste=document.edicion.elements["alumno["+fila+"][ajustado]"].value;
		 
		 if ((valor=="3")|| (valor=="5")||(valor=="7")||(valor=="10"))
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = false;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-N";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = true;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].value = "";
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-S";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-S";
		}
		if(ajuste=="S")
		{
		  document.edicion.elements["alumno["+fila+"][emat_ccod]"].disabled = true;
		  document.edicion.elements["alumno["+fila+"][emat_ccod]"].id = "TO-S";
		}
	  }
   }
}
function mostrar_asignaturas(pers,carr)
{
	irA("mostrar_asignaturas_certificado.asp?pers_ncorr="+pers+"&carr_ccod="+carr, "1", 600, 390);
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno</strong></div></td>
                        <td width="40"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="100%" align="left">
				  <%if q_pers_nrut <> "" then %>
				  <table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="80%" align="left">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="17%" align="left"><strong>Rut</strong></td>
									<td width="3%" align="center"><strong>:</strong></td>
									<td width="80%" align="left"><%=rut%></td>
								</tr>
								<tr>
									<td width="17%" align="left"><strong>Nombre</strong></td>
									<td width="3%" align="center"><strong>:</strong></td>
									<td width="80%" align="left"><%=nombre%></td>
								</tr>
								<tr>
									<td width="17%" align="left"><strong>Email</strong></td>
									<td width="3%" align="center"><strong>:</strong></td>
									<td width="80%" align="left"><%=email%></td>
								</tr>
								<tr>
									<td width="17%" align="left"><strong>Teléfono</strong></td>
									<td width="3%" align="center"><strong>:</strong></td>
									<td width="80%" align="left"><%=fono%></td>
								</tr>
								<tr>
									<td width="17%" align="left"><strong>Celular</strong></td>
									<td width="3%" align="center"><strong>:</strong></td>
									<td width="80%" align="left"><%=celular%></td>
								</tr>
							</table>
						  </td>
						  <td width="20%" align="center">
							  <img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
						  </td>
					</tr>
				  </table>
				   <%end if%>
                  </td>
                </tr>
				<%if mensaje_moroso <> "" and q_pers_nrut <> "" then%>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center"><font size="2" color="#0000FF"><strong><%=mensaje_moroso%></strong></font></td>
				</tr>
				<%end if%>
              </table>
                </div>
              <form name="edicion">
			    <input type="hidden" name="nro_solicitudes" value="<%=nro_solicitudes%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Solicitudes Realizadas"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
							<Td><%pagina.DibujarSubtitulo "Solicitudes Realizadas"%></Td>
						</tr>
						<tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
						<tr>
							<Td>&nbsp;</Td>
						</tr>
						<tr>
							<Td align="right"><% if nro_solicitudes > 0 then 
							                       f_botonera.DibujaBoton("guardar")
												 end if%></div></Td>
						</tr>
						<tr>
							<Td>&nbsp;</Td>
						</tr>
						<tr>
							<Td><%pagina.DibujarSubtitulo "Asignaturas Solicitadas"%></Td>
						</tr>
						<tr>
                          <td><div align="center"><%f_asignaturas.DibujaTabla%></div></td>
                        </tr>
						<tr>
							<Td>&nbsp;</Td>
						</tr>
						<tr>
							<Td>&nbsp;</Td>
						</tr>
						<tr>
							<Td><%pagina.DibujarSubtitulo "Histórico de solicitudes"%></Td>
						</tr>
						<tr>
                          <td><div align="center"><%f_historico.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="center">&nbsp;</td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
				  <td><div align="center">
                    <%f_botonera.agregaBotonParam "excel", "url", "gestion_solicitudes_certificados_excel.asp"
					  f_botonera.DibujaBoton("excel")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
