<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 150000 

set pagina = new CPagina
pagina.Titulo = "Pareo alumnos con CAE"

set botonera =  new CFormulario
'botonera.carga_parametros "alumnos_con_cae.xml", "btn_adm_carreras"

q_anos_ccod	=	request.QueryString("b[0][anos_ccod]")
q_taca_ccod	=	request.QueryString("b[0][taca_ccod]")

 if q_anos_ccod="" then
	 q_anos_ccod= request.querystring("anos_ccod")
 end if
 
 if q_taca_ccod="" then
	 q_taca_ccod= request.querystring("taca_ccod")
 end if
 
nro_t		= 	request.querystring("nro_t")
 
botonera.carga_parametros "pareo_alumnos_con_cae.xml", "btn_adm_carreras"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set errores = new CErrores

'---------------------------------------------------------------------------------------------------

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pareo_alumnos_con_cae.xml", "busqueda2"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "anos_ccod",q_anos_ccod
f_busqueda.AgregaCampoCons "taca_ccod",q_taca_ccod

if q_taca_ccod<>"" then
	filtro_ingresa	=	"	and a.taca_ccod="&q_taca_ccod&""
	if q_taca_ccod=1 then
		filtro_sga		=	"	and scc.socc_brenovante=2"
	else
		filtro_sga		=	"	and scc.socc_brenovante=1"
	end if
end if

set formulario 		= 		new cFormulario

if Request.QueryString <> "" and q_anos_ccod<>"" then
	  
	  if nro_t="" then
	  	nro_t=1
	  end if

select case (nro_t)
		case 1:

			formulario.carga_parametros	"pareo_alumnos_con_cae.xml",	"tabla_generica"
		
			consulta= "select distinct protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tape_paterno, b.pers_tape_materno,b.pers_tnombre, " & vbCrlf & _ 
						"	isnull(a.arancel_solicitado,0) as monto_solicitado, c.nom_carrera_ing as carrera, d.taca_tdesc as tipo_cae " & vbCrlf & _ 
						"	from ufe_alumnos_cae a  " & vbCrlf & _ 
						"	join personas b " & vbCrlf & _ 
						"		on a.RUT=b.pers_nrut  " & vbCrlf & _ 
						"	join ufe_carreras_ingresa c " & vbCrlf & _ 
						"		 on a.CARRERA=c.car_ing_ncorr " & vbCrlf & _
						"	join ufe_tipo_alumnos_cae d " & vbCrlf & _
						"		on a.taca_ccod=d.taca_ccod " & vbCrlf & _						 
						"	where a.anos_ccod="&q_anos_ccod&" " & vbCrlf & _ 
						" "&filtro_ingresa&" "& vbCrlf & _ 
						" order by b.pers_tape_paterno desc "
						
		
		case 2:
		
			formulario.carga_parametros	"pareo_alumnos_con_cae.xml",	"tabla_generica"
		
			consulta=   "select protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tape_paterno,b.pers_tape_materno,b.pers_tnombre,  " & vbCrlf & _
						"  isnull(scc.socc_mmonto_solicitado,0) as monto_solicitado, " & vbCrlf & _
						" protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') as carrera,case scc.socc_brenovante when 1 then 'RENOVANTE' else 'LICITADO' end  as tipo_cae " & vbCrlf & _
						" from solicitud_credito_cae scc  " & vbCrlf & _
						" join alumnos al " & vbCrlf & _
						"	on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _
						"	and al.emat_ccod in (1) " & vbCrlf & _
						" "&filtro_sga&" "& vbCrlf & _ 
						" join ofertas_academicas oa " & vbCrlf & _
						"	on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _
						"	and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _
						" join personas b " & vbCrlf & _
						"	on al.PERS_NCORR=b.PERS_NCORR " & vbCrlf & _ 
						" order by b.pers_tape_paterno desc "
						
						
						
		case 3:
			
			formulario.carga_parametros	"pareo_alumnos_con_cae.xml",	"tabla_generica"
			consulta= "select distinct protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tape_paterno, b.pers_tape_materno,b.pers_tnombre, " & vbCrlf & _ 
						"	isnull(a.arancel_solicitado,0) as monto_solicitado, c.nom_carrera_ing as carrera, d.taca_tdesc as tipo_cae " & vbCrlf & _ 
						"	from ufe_alumnos_cae a  " & vbCrlf & _ 
						"	join personas b " & vbCrlf & _ 
						"		on a.RUT=b.pers_nrut  " & vbCrlf & _ 
						"	join ufe_carreras_ingresa c " & vbCrlf & _ 
						"		 on a.CARRERA=c.car_ing_ncorr " & vbCrlf & _
						"	join ufe_tipo_alumnos_cae d " & vbCrlf & _
						"		on a.taca_ccod=d.taca_ccod " & vbCrlf & _						 
						"	where a.anos_ccod="&q_anos_ccod&" " & vbCrlf & _
						" "&filtro_ingresa&" "& vbCrlf & _  
						"	and rut not in ( " & vbCrlf & _ 
						"				select distinct b.pers_nrut " & vbCrlf & _ 
						"				from solicitud_credito_cae scc  " & vbCrlf & _ 
						"				join alumnos al " & vbCrlf & _ 
						"					on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _ 
						"					and al.emat_ccod in (1) " & vbCrlf & _
						"				join ofertas_academicas oa " & vbCrlf & _ 
						"					on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _ 
						"					and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _ 
						"				join personas b " & vbCrlf & _ 
						"					on al.PERS_NCORR=b.PERS_NCORR " & vbCrlf & _ 
						"	) " & vbCrlf & _ 
						" order by b.pers_tape_paterno desc "	



		case 4:


			formulario.carga_parametros	"pareo_alumnos_con_cae.xml",	"tabla_generica"
			
			consulta=   "select protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tape_paterno,b.pers_tape_materno,b.pers_tnombre,  " & vbCrlf & _
						"  isnull(scc.socc_mmonto_solicitado,0) as monto_solicitado, " & vbCrlf & _
						" protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') as carrera, case scc.socc_brenovante when 1 then 'RENOVANTE' else 'LICITADO' end  as tipo_cae " & vbCrlf & _
						" from solicitud_credito_cae scc  " & vbCrlf & _
						" join alumnos al " & vbCrlf & _
						"	on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _
						"	and al.emat_ccod in (1) " & vbCrlf & _
						" "&filtro_sga&" "& vbCrlf & _
						" join ofertas_academicas oa " & vbCrlf & _
						"	on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _
						"	and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _
						" join personas b " & vbCrlf & _
						"	on al.PERS_NCORR=b.PERS_NCORR " & vbCrlf & _
						" where b.pers_nrut not in ( " & vbCrlf & _
						"					select distinct pers_nrut " & vbCrlf & _
						"					from ufe_alumnos_cae a  " & vbCrlf & _
						"					join personas b " & vbCrlf & _
						"						on a.RUT=b.pers_nrut  " & vbCrlf & _
						"					where a.anos_ccod="&q_anos_ccod&"  " & vbCrlf & _
						" ) "& vbCrlf & _
						" order by b.pers_tape_paterno desc "	

		case 5:
		
		
			formulario.carga_parametros	"pareo_alumnos_con_cae.xml",	"tabla_mixta"
			
			consulta="select distinct tabla_1.rut_alumno, tabla_1.pers_tape_paterno,tabla_1.pers_tape_materno,tabla_1.pers_tnombre,tabla_1.tipo_cae as tipo_ingresa,tabla_2.tipo_cae as tipo_sga, " & vbCrlf & _
						"	tabla_1.monto_solicitado as monto_solictado_1,tabla_1.carrera as carrera_1, tabla_2.monto_solicitado as monto_solicitado_2,tabla_2.carrera as carrera_2   " & vbCrlf & _
						"	from  " & vbCrlf & _
						"	(select distinct protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno, b.pers_tape_materno, isnull(a.arancel_solicitado,0) as monto_solicitado, c.nom_carrera_ing as carrera, d.taca_tdesc as tipo_cae " & vbCrlf & _
						"	from ufe_alumnos_cae a  " & vbCrlf & _
						"	join personas b " & vbCrlf & _
						"		on a.RUT=b.pers_nrut  " & vbCrlf & _
						" "&filtro_ingresa&" "& vbCrlf & _
						"	join ufe_carreras_ingresa c " & vbCrlf & _
						"		 on a.CARRERA=c.car_ing_ncorr " & vbCrlf & _
						"	join ufe_tipo_alumnos_cae d " & vbCrlf & _
						"		on a.taca_ccod=d.taca_ccod " & vbCrlf & _
						"	where a.anos_ccod="&q_anos_ccod&") as tabla_1  " & vbCrlf & _
						"	join  " & vbCrlf & _
						"	(select protic.obtener_rut(b.pers_ncorr) rut_alumno,b.pers_tnombre,b.pers_tape_paterno, b.pers_tape_materno, isnull(scc.socc_mmonto_solicitado,0) as monto_solicitado, " & vbCrlf & _
						"	protic.obtener_nombre_carrera(oa.ofer_ncorr,'C') as carrera,case scc.socc_brenovante when 1 then 'RENOVANTE' else 'LICITADO' end  as tipo_cae " & vbCrlf & _
						"	from solicitud_credito_cae scc  " & vbCrlf & _
						"	join alumnos al " & vbCrlf & _
						"		on scc.post_ncorr=al.POST_NCORR " & vbCrlf & _
						"		and al.emat_ccod in (1) " & vbCrlf & _
						" "&filtro_sga&" "& vbCrlf & _ 
						"	join ofertas_academicas oa " & vbCrlf & _
						"		on al.ofer_ncorr=oa.ofer_ncorr " & vbCrlf & _
						"		and oa.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod="&q_anos_ccod&") " & vbCrlf & _
						"	join personas b " & vbCrlf & _
						"		on al.PERS_NCORR=b.PERS_NCORR) as tabla_2 " & vbCrlf & _
						"	on tabla_1.rut_alumno =tabla_2.rut_alumno " & vbCrlf & _
						" order by tabla_1.pers_tape_paterno desc "																					
		
	end select	
else
	consulta="select ''"
	formulario.carga_parametros	"pareo_alumnos_con_cae.xml",	"tabla_generica"
end if
 
'response.write "<pre>"&consulta&"</pre>"
'response.end()
			

formulario.inicializar		conectar
formulario.consultar 		consulta
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
				  <td width="15%">&nbsp;</td>
				  <td width="66%">
				    <table width="99%">
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
				      </table></td>
				  <td width="19%"><%botonera.DibujaBoton("buscar")%></td>
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
    <%if request.QueryString()<>"" then %>
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
            <td><div align="center"><br><%pagina.DibujarTituloPagina%><br></div>
   
   
   <table width="632"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td> 
                              <%pagina.DibujarLenguetasFClaro Array(array("Ingresa","pareo_alumnos_con_cae.asp?anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod&"&nro_t=1"),array("SGA","pareo_alumnos_con_cae.asp?anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod&"&nro_t=2"),array("Ingresa no SGA","pareo_alumnos_con_cae.asp?anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod&"&nro_t=3"),array("SGA no Ingresa","pareo_alumnos_con_cae.asp?anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod&"&nro_t=4"),array("Ingresa y SGA","pareo_alumnos_con_cae.asp?anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod&"&nro_t=5")), nro_t %>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
                            <td>
                                <table width="650" border="0">
                                  <tr> 
                                    <td width="116">&nbsp;</td>
                                    <td width="511"><div align="right">P&aacute;ginas: &nbsp;<%formulario.AccesoPagina%></div></td>
                                    <td width="24"> <div align="right"> </div></td>
                                  </tr>
                                </table>
                            <br/>
							<% 
							select case (nro_t)
							case 1:
							%>
								<font>Alumnos CAE segun informa Ingresa</font>
								<br/>
                                <div align="center"><%formulario.dibujatabla()%></div>
							  <form name="solicitud">
							  </form>
							  <%case 2:%>
								<font>Alumnos CAE que hicieron solicitud SGA</font>
								<br/>
                                <div align="center"><%formulario.dibujatabla()%></div>
							  <form name="solicitud">
							  </form>
							  <%case 3:%>
								<font>COMPARATIVA: Alumnos Ingresa que no solicitaron en SGA</font>
								<br/>
                                <div align="center"><%formulario.dibujatabla()%></div>
							  <form name="solicitud">
							  </form>
							  <%case 4:%>
								<font>COMPARATIVA: Alumnos solicitan en SGA y no se figuran en Ingresa</font>
								<br/>
                                <div align="center"><%formulario.dibujatabla()%></div>
							  <form name="solicitud">
							  </form>
							  <%case 5:%>
								<font>COMPARATIVA: Alumnos conciden con ambas solicitudes </font>
								<br/>
                                <div align="center"><%formulario.dibujatabla()%></div>
							  <form name="solicitud">
							  </form>
							  <% end select %>
							<br/>
							<br/>
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td width="47%" height="20"><div align="center"> 
                                		<table width="94%"  border="0" cellspacing="0" cellpadding="0">
										  	<tr> 
	
												<td width="100%">
													<%
													select case (nro_t)
													case 1:
														botonera.agregabotonparam "excel_pareo", "url", "pareo_alumnos_con_cae_excel.asp?nro_t="&nro_t&"&anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod
													case 2:
														botonera.agregabotonparam "excel_pareo", "url", "pareo_alumnos_con_cae_excel.asp?nro_t="&nro_t&"&anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod
													case 3:
														botonera.agregabotonparam "excel_pareo", "url", "pareo_alumnos_con_cae_excel.asp?nro_t="&nro_t&"&anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod
													case 4:
														botonera.agregabotonparam "excel_pareo", "url", "pareo_alumnos_con_cae_excel.asp?nro_t="&nro_t&"&anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod
													case 5:
														botonera.agregabotonparam "excel_pareo", "url", "pareo_alumnos_con_cae_excel.asp?nro_t="&nro_t&"&anos_ccod="&q_anos_ccod&"&taca_ccod="&q_taca_ccod
													end select
													botonera.DibujaBoton ("excel_pareo")
													%>
												</td>

										  	</tr>
                                		</table>
                              </div></td>
								<td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							<!-- hasta aca 
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
							<td align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
   
   
   
   
          </td></tr>
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
                  <td><div align="center">
                    <%botonera.dibujaboton "salir"%>
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
    <%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
