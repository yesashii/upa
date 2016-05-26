<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 150000 
carr_tdesc = request.QueryString("carr_tdesc")
set pagina = new CPagina
pagina.Titulo = "Alumnos con CAE"

set botonera =  new CFormulario
'botonera.carga_parametros "alumnos_con_cae.xml", "btn_adm_carreras"
q_pers_nrut=request.QueryString("b[0][pers_nrut]")
q_pers_xdv=request.QueryString("b[0][pers_xdv]")
q_anos_ccod=request.QueryString("b[0][anos_ccod]")
q_taca_ccod=request.QueryString("b[0][taca_ccod]")
botonera.carga_parametros "alumnos_con_cae.xml", "btn_adm_carreras"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores

'---------------------------------------------------------------------------------------------------

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "alumnos_con_cae.xml", "busqueda2"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "anos_ccod",q_anos_ccod
f_busqueda.AgregaCampoCons "taca_ccod",q_taca_ccod

rutt= request.QueryString("rut")

if q_pers_nrut<>"" then

  filtro1=filtro1&"and a.pers_nrut="&q_pers_nrut&""

end if

if q_taca_ccod<>"" then
filtro2=filtro2&"and b.taca_ccod="&q_taca_ccod&""
end if

if q_anos_ccod<>"" then
consulta="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut," & vbCrlf & _ 
"pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre_alumno," & vbCrlf & _ 
"(select top 1 emat_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod order by matr_ncorr desc)as estado_matricula," & vbCrlf & _ 
"c.taca_tdesc as tipo_cae," & vbCrlf & _ 
"(select top 1 isnull(protic.ANO_INGRESO_CARRERA_EGRESA2(aa.pers_ncorr,ff.CARR_CCOD),protic.ANO_INGRESO_UNIVERSIDAD(a.pers_ncorr))as promocion from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod order by matr_ncorr desc)as promocion," & vbCrlf & _ 
"(select top 1 carr_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod  order by matr_ncorr desc)as carrera," & vbCrlf & _ 
"(select top 1 jorn_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg,jornadas hh, periodos_academicos ii  where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.jorn_ccod=hh.jorn_ccod and cc.PERI_CCOD=ii.PERI_CCOD and ii.ANOS_CCOD=b.anos_ccod order by matr_ncorr desc)as jornada," & vbCrlf & _ 
"(select top 1 case post_bnuevo when 'S' then 'NUEVO' else 'ANTIGUO' end from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg, periodos_academicos hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.PERI_CCOD=hh.PERI_CCOD and hh.ANOS_CCOD=b.anos_ccod  order by matr_ncorr desc)as tipo_alumno," & vbCrlf & _   
"(select top 1 sede_tdesc from alumnos aa,estados_matriculas bb,ofertas_academicas cc,especialidades dd,carreras ee,ufe_carreras_homologadas ff,ufe_carreras_ingresa gg,sedes hh where aa.PERS_NCORR=a.PERS_NCORR and aa.EMAT_CCOD=bb.EMAT_CCOD and aa.emat_ccod <>9 and aa.OFER_NCORR=cc.OFER_NCORR and cc.ESPE_CCOD=dd.ESPE_CCOD and dd.CARR_CCOD=ee.carr_ccod and ee.carr_ccod=ff.carr_ccod COLLATE Modern_Spanish_CI_AS and ff.car_ing_ncorr=gg.car_ing_ncorr and gg.cod_carrera_ing=b.carrera and cc.sede_ccod=hh.sede_ccod order by matr_ncorr desc)as sede"& vbCrlf & _  
"from personas a," & vbCrlf & _ 
"ufe_alumnos_cae b," & vbCrlf & _ 
"ufe_tipo_alumnos_cae c" & vbCrlf & _ 
"where a.PERS_NRUT=b.RUT" & vbCrlf & _ 
"and b.esca_ccod=1"& vbCrlf & _ 
"and b.anos_ccod="&q_anos_ccod&""& vbCrlf & _ 
""&filtro1&""& vbCrlf & _ 
""&filtro2&""& vbCrlf & _ 
"and b.taca_ccod=c.taca_ccod"
else
consulta="select ''"
end if 
'response.write "<pre>"&consulta&"</pre>"

			
set formulario 		= 		new cFormulario
formulario.carga_parametros	"alumnos_con_cae.xml",	"tabla"
formulario.inicializar		conectar
formulario.consultar 		consulta
registros = formulario.nrofilas
'response.end()
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
                   <td><form name="buscador" method="get">
              <table width="100%" border="0">
                <tr>
                  <td width="29%">&nbsp;</td>
                  <td width="67%">
                        <table width="100%"  border="0" align="center">
							<tr>
								<td width="24%"><strong>Rut  :</strong></td>
							  <td width="8%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
								<td width="2%">-</td>
							  <td width="6%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%></div></td>
							  <td width="20%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
								<td width="16%"></div></td>
							  <td width="24%"><div align="center"><%botonera.DibujaBoton("buscar")%></div></td>
							</tr>
					    </table>
                   </td>
                  <td width="4%">&nbsp;</td>
                </tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<table width="100%">
							<tr>
								<td width="21%"><strong>A&ntilde;os Academicos:</strong></td>
								<td width="79%">
									<%f_busqueda.DibujaCampo("anos_ccod")%>
							  </td>
							</tr>
							<tr>
								<td width="21%"><strong>Tipo Alumno Cae :</strong></td>
								<td width="79%">
									<%f_busqueda.DibujaCampo("taca_ccod")%>
							  </td>
							</tr>
						</table>
					</td>
					<td>&nbsp;</td>
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
                  <td width="14%"> <div align="center">  <% botonera.dibujaboton "excel"%></div></td>
				  <td width="14%"> <div align="center">  <%'botonera.dibujaboton "excel_general"%></div></td>
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
