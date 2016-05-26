<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 300000
set pagina = new CPagina
pagina.Titulo = "Estad�sticas egresados, titulados y graduados"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

upa_pregrado  =  request.Form("upa_pregrado")
upa_postgrado =  request.Form("upa_postgrado")
instituto     =  request.Form("instituto")

egresados  	  =  request.Form("egresados")
titulados     =  request.Form("titulados")
graduados     =  request.Form("graduados")
salidas_int   =  request.Form("salidas_int")

femenino      =  request.Form("femenino")
masculino     =  request.Form("masculino")

facu_ccod      =  request.Form("a[0][facu_ccod]")
carr_ccod      =  request.Form("a[0][carr_ccod]")

if facu_ccod = "" then
	facu_ccod = 0
end if
if carr_ccod = "" then
	carr_ccod = "0"
end if

check_pregrado  = ""
check_postgrado = ""
check_instituto = ""

check_egresados  = ""
check_titulados  = ""
check_graduados  = ""
check_salidas_int= ""

check_femenino  = ""
check_masculino = ""

set botonera = new CFormulario
botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"
'-------------------------------------------------------------------------------
'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next

'----------------------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "estadisticas_egreso_titulacion.xml", "buscador"
f_busqueda.inicializar conexion


consulta="Select '"&facu_ccod&"' as facu_ccod, '"&carr_ccod&"' as carr_ccod"
f_busqueda.consultar consulta

consulta = " select '0' as carr_ccod, ' TODAS' as carr_tdesc, 0 as facu_ccod, ' TODAS' as facu_tdesc " & vbCrLf & _
		   " union " & vbCrLf & _	
           " select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,c.facu_ccod,c.facu_tdesc " & vbCrLf & _
		   " from carreras a,areas_academicas b, facultades c " & vbCrLf & _
		   " where a.area_ccod = b.area_ccod and b.facu_ccod = c.facu_ccod " & vbCrLf & _
		   " and c.facu_ccod <> 7 " & vbCrLf & _
		   " order by c.facu_tdesc,a.carr_tdesc asc" 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()	
f_busqueda.inicializaListaDependiente "lBusqueda", consulta
f_busqueda.siguiente


set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion

consulta =  "select a.sede_ccod,a.sede_tdesc as sede  "
            if upa_pregrado = "1" then
				check_pregrado  = "checked"
				if egresados = "1" then
				    check_egresados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','UEG',"&facu_ccod&",'"&carr_ccod&"') as egresados_U_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','UEG',"&facu_ccod&",'"&carr_ccod&"') as egresados_U_mujeres  "
					end if
				end if
				if titulados = "1" then
				    check_titulados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','UTI',"&facu_ccod&",'"&carr_ccod&"') as titulados_U_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','UTI',"&facu_ccod&",'"&carr_ccod&"') as titulados_U_mujeres   "
					end if
				end if
				if graduados = "1" then
				    check_graduados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','PRG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PR_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','PRG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PR_mujeres  "
					end if
				end if
				if salidas_int = "1" then
				    check_salidas_int  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','SIE',"&facu_ccod&",'"&carr_ccod&"') as SIE_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','SIE',"&facu_ccod&",'"&carr_ccod&"') as SIE_mujeres  "
					end if
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','SIT',"&facu_ccod&",'"&carr_ccod&"') as SIT_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','SIT',"&facu_ccod&",'"&carr_ccod&"') as SIT_mujeres  "
					end if
				end if
            end if
			if instituto = "1" then
				check_instituto  = "checked"
				if egresados = "1" then
				    check_egresados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,1,'I','IEG',"&facu_ccod&",'"&carr_ccod&"'),0) as egresados_I_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,2,'I','IEG',"&facu_ccod&",'"&carr_ccod&"'),0) as egresados_I_mujeres  "
					end if
				end if
				if titulados = "1" then
				    check_titulados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,1,'I','ITI',"&facu_ccod&",'"&carr_ccod&"'),0) as titulados_I_hombres  "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",isnull(protic.estadistica_titulados(a.sede_ccod,2,'I','ITI',"&facu_ccod&",'"&carr_ccod&"'),0) as titulados_I_mujeres  "
					end if
				end if
			end if
			if upa_postgrado = "1" then
				check_postgrado  = "checked"
				if graduados = "1" then
				    check_graduados  = "checked"
					if masculino = "1" then
					    check_masculino = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,1,'U','POG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PO_hombres "
					end if
					if femenino = "1" then
					    check_femenino  = "checked"
						consulta = consulta & ",protic.estadistica_titulados(a.sede_ccod,2,'U','POG',"&facu_ccod&",'"&carr_ccod&"') as graduados_PO_mujeres "
					end if
				end if	
			end if
			
			consulta = consulta & " from sedes a  "& vbCrLf &_
								  " order by sede_tdesc asc "

'consulta = " select * from sexos"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_lista.Consultar consulta 
			

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
function enviar(formulario){
           	formulario.action ="estadisticas_egreso_titulacion.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
		  <form name="buscador" method="post">
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="15%"><strong>Instituci&oacute;n:</strong></td>
								  <td width="3%" align="center"><input type="checkbox" name="upa_pregrado" value="1" <%=check_pregrado%>></td>
								  <td width="15%" align="left">UPA Pregrado</td>
								  <td width="3%" align="center"><input type="checkbox" name="upa_postgrado" value="1" <%=check_postgrado%>></td>
								  <td width="15%" align="left">UPA Postgrado</td>
								  <td width="3%" align="center"><input type="checkbox" name="instituto" value="1" <%=check_instituto%>></td>
								  <td width="15%" align="left">Instituto Profesional</td>
								  <td width="3%" align="center">&nbsp;</td>
								  <td width="28%" align="left">&nbsp;</td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="15%"><strong>Estado:</strong></td>
								  <td width="3%" align="center"><input type="checkbox" name="egresados" value="1" <%=check_egresados%>></td>
								  <td width="15%" align="left">Egresados</td>
								  <td width="3%" align="center"><input type="checkbox" name="titulados" value="1" <%=check_titulados%>></td>
								  <td width="15%" align="left">Titulados</td>
								  <td width="3%" align="center"><input type="checkbox" name="graduados" value="1" <%=check_graduados%>></td>
								  <td width="15%" align="left">Graduados</td>
								  <td width="3%" align="center"><input type="checkbox" name="salidas_int" value="1" <%=check_salidas_int%>></td>
								  <td width="28%" align="left">Salidas Intermedias</td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="15%"><strong>Facultad:</strong></td>
								  <td colspan="8" align="left"><%f_busqueda.dibujaCampoLista "lBusqueda", "facu_ccod" %></td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="15%"><strong>Carrera:</strong></td>
								  <td colspan="8" align="left"><%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod" %></td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="15%"><strong>G�nero:</strong></td>
								  <td width="3%" align="center"><input type="checkbox" name="Femenino" value="1" <%=check_femenino%>></td>
								  <td width="15%" align="left">Femenino</td>
								  <td width="3%" align="center"><input type="checkbox" name="Masculino" value="1" <%=check_masculino%>></td>
								  <td width="15%" align="left">Masculino</td>
								  <td width="3%" align="center">&nbsp;</td>
								  <td width="15%" align="left">&nbsp;</td>
								  <td width="3%" align="center">&nbsp;</td>
								  <td width="28%" align="left">&nbsp;</td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
		  <tr>
            <td align="right">
			 <table width="30%">
			 	<tr>
					<td width="50%" align="center"><%botonera.dibujaboton "rut_alumni"%></td>
					<td width="50%" align="center"><%botonera.dibujaboton "buscar"%></td>
				</tr>
			 </table>
			</td>
          </tr>
		  </form>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la b�squeda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
			  </div>
            </td>
		  </tr>
		  <tr>
            <td align="right" height="30">&nbsp;</td>
		  </tr>
		  <form name="edicion">
		  <tr>
		  	<td align="center">
				<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
				<table class='v1' width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_secciones'>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<%if upa_pregrado = "1" then%>
						<th colspan="10"><font color='#333333'>Universidad Pregrado</font></th>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<th colspan="2"><font color='#333333'>Universidad Postgrado</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th colspan="4"><font color='#333333'>Instituto</font></th>
					<%end if%>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>Sede</font></th>
					<%if upa_pregrado = "1" then%>
						<th colspan="2"><font color='#333333'>Egresados</font></th>
						<th colspan="2"><font color='#333333'>Titulados</font></th>
						<th colspan="2"><font color='#333333'>Grados</font></th>
						<th colspan="2"><font color='#333333'>S.I.E</font></th>
						<th colspan="2"><font color='#333333'>S.I.T</font></th>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<th colspan="2"><font color='#333333'>Grados</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th colspan="2"><font color='#333333'>Egresados</font></th>
						<th colspan="2"><font color='#333333'>Titulados</font></th>
					<%end if%>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<%if upa_pregrado = "1" then%>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
					<%end if%>
					<%if instituto = "1" then%>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
						<th><font color='#333333'>H</font></th>
						<th><font color='#333333'>M</font></th>
					<%end if%>
				</tr>
				<%  TEUH = 0
					TEUM = 0
					TTUH = 0
					TTUM = 0
					TGPH = 0
					TGPM = 0
					TESH = 0
					TESM = 0
					TTSH = 0
					TTSM = 0
					TEIH = 0
					TEIM = 0
					TTIH = 0
					TTIM = 0
					TGGH = 0
					TGGM = 0
				  while f_lista.siguiente
				    sede_ccod = f_lista.obtenerValor("sede_ccod")
					sede      = f_lista.obtenerValor("sede")
					if upa_pregrado = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								EUH       = f_lista.obtenerValor("egresados_U_hombres")
								TEUH = TEUH + cint(EUH)
							end if
							if femenino = "1" then
								EUM       = f_lista.obtenerValor("egresados_U_mujeres")
								TEUM = TEUM + cint(EUM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								TUH       = f_lista.obtenerValor("titulados_U_hombres")
								TTUH = TTUH + cint(TUH)
							end if
							if femenino = "1" then
								TUM       = f_lista.obtenerValor("titulados_U_mujeres")
								TTUM = TTUM + cint(TUM) 
							end if
						end if
						if graduados = "1" then
						    if masculino = "1" then
								GPH       = f_lista.obtenerValor("graduados_PR_hombres")
								TGPH = TGPH + cint(GPH)
							end if
							if femenino = "1" then
								GPM       = f_lista.obtenerValor("graduados_PR_mujeres")
								TGPM = TGPM + cint(GPM)
							end if
						end if
						if salidas_int = "1" then
						    if masculino = "1" then	
								ESH       = f_lista.obtenerValor("SIE_hombres")
								TESH = TESH + cint(ESH)
							end if
							if femenino = "1" then
								ESM       = f_lista.obtenerValor("SIE_mujeres")
								TESM = TESM + cint(ESM)
							end if
							if masculino = "1" then
								TSH       = f_lista.obtenerValor("SIT_hombres")
								TTSH = TTSH + cint(TSH)
							end if
							if femenino = "1" then
								TSM       = f_lista.obtenerValor("SIT_mujeres")
								TTSM = TTSM + cint(TSM)
							end if
						end if
					end if
					if instituto = "1" then
					    if egresados = "1" then
						    if masculino = "1" then
								EIH       = f_lista.obtenerValor("egresados_I_hombres")
								TEIH = TEIH + cint(EIH)
							end if
							if femenino = "1" then
								EIM       = f_lista.obtenerValor("egresados_I_mujeres")
								TEIM = TEIM + cint(EIM)
							end if
						end if
						if titulados = "1" then
						    if masculino = "1" then
								TIH       = f_lista.obtenerValor("titulados_I_hombres")
								TTIH = TTIH + cint(TIH)
							end if
							if femenino = "1" then
								TIM       = f_lista.obtenerValor("titulados_I_mujeres")
								TTIM = TTIM + cint(TIM)
							end if
						end if
					end if
					if upa_postgrado = "1" then
					    if graduados = "1" then
						    if masculino = "1" then
								GGH       = f_lista.obtenerValor("graduados_PO_hombres")
								TGGH = TGGH + cint(GGH)
							end if
							if femenino = "1" then
								GGM       = f_lista.obtenerValor("graduados_PO_mujeres")
								TGGM = TGGM + cint(GGM)
							end if
						end if
					end if					
%>
				<tr bgcolor="#FFFFFF">
					<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=sede%></td>
					<%if upa_pregrado = "1" then%>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EUM%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TUM%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GPM%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=ESM%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TSM%></td>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=GGM%></td>
					<%end if%>
					<%if instituto = "1" then%>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=EIM%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIH%></td>
						<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_carreras.asp?sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><%=TIM%></td>
					<%end if%>
				</tr>
				<%wend%>
				<tr bgcolor="#FFFFFF">
					<td align='right' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' >TOTALES</td>
					<%if upa_pregrado = "1" then%>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TEUH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TEUM%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TTUH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TTUM%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TGPH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TGPM%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TESH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TESM%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TTSH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TTSM%></strong></td>
					<%end if%>
					<%if upa_postgrado = "1" then%>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TGGH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TGGM%></strong></td>
					<%end if%>
					<%if instituto = "1" then%>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TEIH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TEIM%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TTIH%></strong></td>
						<td align='CENTER' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><strong><%=TTIM%></strong></td>
					<%end if%>
				</tr>
			   </table>
			</td>
		  </tr>
		  </form>
		  <tr>
            <td align="right">* Presione sobre el n&uacute;mero de inter&eacute;s para visualizar el dato a un detalle mayor.</td>
		  </tr>
		  <tr>
            <td align="right" height="50">&nbsp;</td>
		  </tr>
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
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td><div align="center">
						    <% 
							   url_2 = "estadisticas_egreso_titulacion_excel.asp?upa_pregrado="&upa_pregrado&"&upa_postgrado="&upa_postgrado&"&instituto="&instituto&"&egresados="&egresados&"&titulados="&titulados&"&graduados="&graduados&"&salidas_int="&salidas_int&"&femenino="&femenino&"&masculino="&masculino&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod
 							   'response.Write(url_2)
							   botonera.agregaBotonParam "excel","url",url_2
							   botonera.dibujaBoton "excel"
							%>
							</div>
						</td>
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
