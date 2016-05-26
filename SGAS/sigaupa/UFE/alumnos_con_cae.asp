<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 150000 
carr_tdesc = request.QueryString("carr_tdesc")
set pagina = new CPagina
pagina.Titulo = "Alumnos con CAE"

set botonera =  new CFormulario
'botonera.carga_parametros "alumnos_con_cae.xml", "btn_adm_carreras"
botonera.carga_parametros "homologaciones_listado.xml", "btn_adm_carreras"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "homologaciones_listado.xml", "busqueda2"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
'---------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
'consulta ="  select a.carr_ccod,a.carr_tdesc,area_tdesc,inst_trazon_social,d.ecar_tdesc,e.facu_tdesc,f.tcar_tdesc  " & vbCrlf & _
'			" from carreras a,areas_academicas b, instituciones c,estados_de_carreras d,facultades e,tipos_carrera f " & vbCrlf & _
'			" where a.area_ccod = b.area_ccod  " & vbCrlf & _
'			" and a.inst_ccod = c.inst_ccod " & vbCrlf & _
'			" and a.ecar_ccod = d.ecar_ccod " & vbCrlf & _
'			" and a.inst_ccod = e.inst_ccod " & vbCrlf & _
'			" and b.facu_ccod = e.facu_ccod " & vbCrlf & _	
'			" and a.tcar_ccod *= f.tcar_ccod " & vbCrlf & _						
'			" and a.carr_tdesc like '%"&carr_tdesc&"%' " & vbCrlf & _
'			" order  by carr_tdesc" 


'SOLUCIONAR PROBLEMAS CON ESTA CONSULTA OJOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO NO LISTA MAS DE 400
'-----------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------
'response.write "<pre>"&consulta&"</pre>"
'response.end() 			


'response.write "<pre>"&registros&"</pre>"
'response.end() 


rutt= request.QueryString("rut")

if rutt<>"" then

consulta= "select  protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno," & vbCrlf & _  
"emat_tdesc as estado_matricula, protic.ano_ingreso_carrera(b.pers_ncorr,d.carr_ccod) as promocion, " & vbCrlf & _ 
"sede_tdesc as sede,(select carr_tdesc from carreras t where t.carr_ccod = d.carr_ccod) as carrera,  jorn_tdesc as jornada," & vbCrlf & _ 
"case when c.post_bnuevo='S' then 'NUEVO' else 'ANTIGUO' end as Tipo_Alumno," & vbCrlf & _ 
"(select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr)) as tenia_cae_anteriores," & vbCrlf & _ 
"case when (select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr))>=1 then 'RENOVANTE' else 'NUEVO CAE' end as tipo_cae" & vbCrlf & _ 
"from sdescuentos a, alumnos b , ofertas_academicas c, especialidades d, estados_matriculas e, jornadas f, sedes g " & vbCrlf & _ 
"where a.post_ncorr=b.post_ncorr " & vbCrlf & _ 
"and a.ofer_ncorr=b.ofer_ncorr " & vbCrlf & _ 
"and a.esde_ccod = 1 " & vbCrlf & _ 
"and a.stde_ccod=1402 " & vbCrlf & _ 
"and a.ofer_ncorr=c.ofer_ncorr " & vbCrlf & _ 
"and c.peri_ccod=222 " & vbCrlf & _ 
"and c.espe_ccod=d.espe_ccod " & vbCrlf & _ 
"and b.emat_ccod not  in (9) " & vbCrlf & _ 
"and b.emat_ccod=e.emat_ccod " & vbCrlf & _ 
"and c.jorn_ccod=f.jorn_ccod " & vbCrlf & _ 
"and c.sede_ccod=g.sede_ccod" & vbCrlf & _ 
"and  protic.obtener_rut(b.pers_ncorr)='" & rutt &"'"

Else
consulta= "select  protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno," & vbCrlf & _  
"emat_tdesc as estado_matricula, protic.ano_ingreso_carrera(b.pers_ncorr,d.carr_ccod) as promocion, " & vbCrlf & _ 
"sede_tdesc as sede,(select carr_tdesc from carreras t where t.carr_ccod = d.carr_ccod) as carrera,  jorn_tdesc as jornada," & vbCrlf & _ 
"case when c.post_bnuevo='S' then 'NUEVO' else 'ANTIGUO' end as Tipo_Alumno," & vbCrlf & _ 
"(select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr)) as tenia_cae_anteriores," & vbCrlf & _ 
"case when (select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr))>=1 then 'RENOVANTE' else 'NUEVO CAE' end as tipo_cae" & vbCrlf & _ 
"from sdescuentos a, alumnos b , ofertas_academicas c, especialidades d, estados_matriculas e, jornadas f, sedes g " & vbCrlf & _ 
"where a.post_ncorr=b.post_ncorr " & vbCrlf & _ 
"and a.ofer_ncorr=b.ofer_ncorr " & vbCrlf & _ 
"and a.esde_ccod = 1 " & vbCrlf & _ 
"and a.stde_ccod=1402 " & vbCrlf & _ 
"and a.ofer_ncorr=c.ofer_ncorr " & vbCrlf & _ 
"and c.peri_ccod=222 " & vbCrlf & _ 
"and c.espe_ccod=d.espe_ccod " & vbCrlf & _ 
"and b.emat_ccod not  in (9) " & vbCrlf & _ 
"and b.emat_ccod=e.emat_ccod " & vbCrlf & _ 
"and c.jorn_ccod=f.jorn_ccod " & vbCrlf & _ 
"and c.sede_ccod=g.sede_ccod"

end if

'response.write "<pre>"&consulta&"</pre>"
'response.end()
			
set formulario 		= 		new cFormulario
formulario.carga_parametros	"alumnos_con_cae.xml",	"tabla"
formulario.inicializar		conectar
formulario.consultar 		consulta
registros = formulario.nrofilas

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

function cerrar()
 {
	window.close();
 
}


function enviar(formulario){
formulario.submit();
}
function agrega_carrera_antiguo(formulario){

	direccion="agregar_carrera.asp?carr_ccod ="
	resultado=window.open(direccion, "ventana1","width=700,height=400,scrollbars=yes, left=0, top=0");
}
function agrega_carrera(formulario) {
	direccion = "consultar_carrera.asp";
	resultado=window.open(direccion, "ventana1","width=250,height=100,scrollbars=no, left=380, top=350");
	
 // window.close();
}


</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
   <%pagina.DibujarEncabezadoUfe()%>   
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
                   <td><form name="buscador" method="get">
              <table width="100%" border="0">
                <tr>
                  <td width="29%">
                      <div align="center">
                        &nbsp;&nbsp;&nbsp;&nbsp;</div></td>
                  <td width="39%">
                        <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="18%"><strong>Rut  :</strong></td>
					
					<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%botonera.DibujaBoton("buscar")%></div></td
					></tr>
					</table>
                        </td>
                  <td width="28%"><%'botonera.dibujaboton "buscar"%></td>
                  <td width="4%" nowrap>&nbsp;</td>
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
              <%pagina.DibujarTituloPagina%><br>
                    <table width="650" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
			  <input name="registros" type="hidden" value="<%=registros%>">
                <div align="center"><%formulario.dibujatabla()%><br>
                </div>
              </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="14%"> <div align="center">  <%botonera.dibujaboton "excel"%></div></td>
				  <td width="14%"> <div align="center">  <%botonera.dibujaboton "excel_general"%></div></td>
                  <td><div align="center">
                    <%botonera.dibujaboton "SALIR"%>
                  </div></td>
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
