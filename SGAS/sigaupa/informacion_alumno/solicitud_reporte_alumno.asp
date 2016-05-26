<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Solicitud de Certificados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

q_peri_ccod = conexion.consultaUno("select max(c.peri_ccod) from personas a, alumnos b, ofertas_academicas c,periodos_academicos d where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (1,4,8) and b.ofer_ncorr=c.ofer_ncorr and c.peri_ccod = d.peri_ccod and d.anos_ccod >= 2008 ")
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "solicitud_reporte_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "solicitud_reporte_alumno.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.siguiente

if not esVacio(q_pers_nrut) then
	pers_ncorr_temporal=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "solicitud_reporte_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if not esVacio(carrera) then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  --and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
consulta_carrera= "(select distinct d.carr_ccod , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  and a.emat_ccod in (1,4,8)" & vbCrLf &_
				  " and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"')s"
 				 
'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
				 

email = conexion.consultaUno("select pers_temail from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", carr_ccod
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

nombre_carrera=f_encabezado.obtenerValor("carrera")

tiene_matricula_2007 = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and emat_ccod=1")
carrera_respaldo = conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b,especialidades c  where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and emat_ccod=1 and b.espe_ccod=c.espe_ccod")

if pers_ncorr_temporal <> "" then
	es_moroso = conexion.consultaUno("select protic.es_moroso('"&pers_ncorr_temporal&"',getDate())")
	titulado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.emat_ccod='8'")
end if
'response.Write(titulado)

if pers_ncorr_temporal = "22960" then
	titulado = "N"
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

var t_parametros;

function Inicio()
{
	t_parametros = new CTabla("p")
}

function asigna_carrera(texto)
{
//alert(texto);
document.edicion.elements["nombre_carrera"].value = texto;
}
function asigna_motivo(texto)
{
//alert(texto);
document.edicion.elements["motivo"].value = texto;
}
function asigna_certificado(texto)
{
//alert(texto);
document.edicion.elements["tipo_certificado"].value = texto;
}
function asignar_valor(texto,valor,tipo)
{ var tipo_certificado; 
  var motivo;
  var tiene_matricula_2007 = '<%=tiene_matricula_2007%>';
  var es_moroso = '<%=es_moroso%>';
  var titulado = '<%=titulado%>';
if (tipo == 1)
	{
		document.edicion.elements["tipo_certificado"].value = texto;
	}
else
	{
		document.edicion.elements["motivo"].value = texto;
	}
//--------------------------------ahora debemos validar para emitir certificado gratuito--------------
tipo_certificado = document.edicion.elements["certificado"].value;
motivo = document.edicion.elements["enca[0][tdes_ccod]"].value;
//alert ("tiene_matricula_2007 " + tiene_matricula_2007 + " es_moroso " + es_moroso);

if (tipo_certificado == "1" )
	{
		if ((motivo=="1")||(motivo=="9")||(motivo=="10")||(motivo=="11")||(motivo=="12")||(motivo=="13")||(motivo=="4")||(motivo=="5")||(motivo=="18")||(motivo=="6")||(motivo=="7")||(motivo=="8")||(motivo=="2")||(motivo=="6")||(motivo=="14"))
		{
		    if ((tiene_matricula_2007=='S') && (es_moroso=='N') && (titulado=='N'))
			{
			 	document.getElementById("tabla_certificado").style.visibility = "visible" ;
			}
			else
			{   alert("La impresión de certificados online requiere que el alumno tenga matrícula activa\n y que no presente morosidad en su Cuenta Corriente"); 
			 	document.getElementById("tabla_certificado").style.visibility = "hidden" ;
			}	
		}
		else
		{   
		    if (motivo!="")
			 {
			   alert("Este tipo de certificado requiere ser solicitado directamente en La Universidad");  
			 }
			document.getElementById("tabla_certificado").style.visibility = "hidden" ;
		}
	}
	else
	{
	        if (motivo!="")
			{
			  alert("Este tipo de certificado requiere ser solicitado directamente en La Universidad");
			} 
			document.getElementById("tabla_certificado").style.visibility = "hidden" ;
	}

	
}
function certificado_1(){
   var codigo_carrera = document.edicion.elements["enca[0][carreras_alumno]"].value;
   var formulario=document.edicion;
   var valor=document.edicion.elements["enca[0][tdes_ccod]"].value;
   if (codigo_carrera == "")
   {
   	codigo_carrera = '<%=carrera_respaldo%>';
   }
   direccion = 'certificado_1.asp?carr_ccod='+codigo_carrera+'&pers_nrut=<%=q_pers_nrut%>&tdes_ccod='+ valor;
   //alert(direccion);
   self.open(direccion,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')

}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF"><br>
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
            <td>
			<form name="edicion" action="notas_alumno.asp">
			 <div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
			   <%if not esVacio(q_pers_nrut) then%>
			   <table width="98%"  border="0">
                <tr>
                  <td width="68" align="left"><strong>RUT</strong></td>
				  <td width="10"  align="center"><strong>:</strong></td>
				  <td  align="left" colspan="4"><%f_encabezado.DibujaCampo("rut")%></td>
				</tr>
				<tr>
                  <td width="68" align="left"><strong>Nombre</strong></td>
				  <td width="10"  align="center"><strong>:</strong></td>
				          <td  align="left" colspan="4">
                            <%f_encabezado.DibujaCampo("nombre")%>
                          </td>
			    </tr>
				<tr>
                  <td width="68" align="left"><strong>Carrera</strong></td>
				  <td width="10"  align="center"><strong>:</strong></td>
				          <td  align="left" colspan="4">
                            <%f_encabezado.DibujaCampo("carreras_alumno")%>
                          </td>
			    </tr>
				 <tr>
                  <td width="68" align="left"><strong>Certificado solicitado</strong></td>
				  <td width="10"  align="center"><strong>:</strong></td>
				  <td width="187"  align="left"><select name="certificado" id="TO-N" onchange="asignar_valor(this.options[this.selectedIndex].text, this.value,1);">
											  <option value="">Seleccione</option>
											  <option value="1">Certificado de Alumno regular</option>
											  <option value="2">Concentraci&oacute;n de Notas</option>
											</select> 
				  </td>
				  <td width="118" align="right"><strong>Motivo de extenci&oacute;n</strong></td>
				  <td width="8"  align="center"><strong>:</strong></td>
				          <td width="235"  align="left"><%f_encabezado.DibujaCampo("tdes_ccod")%></td>
                </tr>
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6" align="center">
				         <table width="90%">
						 		<tr><td align="center">
							                         <table width="100%" border="1" id="tabla_certificado" style="visibility:hidden" bordercolor="#990000">
													 <tr><td align="center"><font size="3" color="#0000FF" face="Times New Roman, Times, serif"><strong>NUEVO: </strong></font>
													                    <font size="3" color="#990000" face="Times New Roman, Times, serif">
																			<strong>Desde ahora puedes emitir este tipo de certificados directamente desde Internet presionando en el siguiente botón.</strong>
																		</font>
													      </td>
												      </tr>
													  <tr><td align="center"><%f_botonera.dibujaBoton "certificado_online"%></td></tr>
													 </table>
							    
								</td>
							</tr>
						 </table>
			        </td>
				</tr>
              </table>
			  <%end if%>
			  </div>
              <br>
			  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
              <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
			  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
			  <input name="nombre_alumno" type="hidden" value="<%=f_encabezado.obtenerValor("nombre")%>">
			  <input name="rut" type="hidden" value="<%=q_pers_nrut&"-"&q_pers_xdv%>">
			  <input name="motivo" type="hidden" value="">
			  <input name="nombre_carrera" type="hidden" value="">
			  <input name="tipo_certificado" type="hidden" value="">
			  <input name="email" type="hidden" value="<%=email%>">
			 </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="24%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%'f_botonera.agregaBotonParam "solicitar","deshabilitado","TRUE"
				                            f_botonera.DibujaBoton "solicitar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="76%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
