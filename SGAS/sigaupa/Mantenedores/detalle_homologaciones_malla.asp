<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Detalles Homologaciones"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_homologaciones_malla.xml", "botonera"

'-----------------------------------------------------------------------
'homo_ccod = request.querystring("homo_ccod")
homo_nresolucion2 = request.querystring("homo_nresolucion")
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
espe_ccod = request.querystring("busqueda[0][espe_ccod]")
plan_ccod = request.querystring("busqueda[0][plan_ccod]")

carr_ccod_destino = request.querystring("busqueda[0][carr_ccod_destino]")
espe_ccod_destino = request.querystring("busqueda[0][espe_ccod_destino]")
plan_ccod_destino = request.querystring("busqueda[0][plan_ccod_destino]")


'----------------------------------------------------------------------- 
'set f_homo = new CFormulario
'f_homo.Carga_Parametros "consulta.xml", "consulta"
'f_homo.Inicializar conexion	
'SQL = " Select homo_fresolucion,esho_tdesc,thom_tdesc,homo_nresolucion " & vbcrlf & _
'    " from homologacion a, tipos_homologaciones b, estados_homologacion c " & vbcrlf & _
'    " where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion2 & "' and a.thom_ccod=b.thom_ccod " & vbcrlf & _
'	" and a.esho_ccod=c.esho_ccod group by homo_nresolucion,homo_fresolucion,esho_tdesc,thom_tdesc "
'f_homo.Consultar SQL
'f_homo.Siguiente

set f_homo = new CFormulario
f_homo.Carga_Parametros "m_homologaciones_malla.xml", "f_nuevo"
f_homo.Inicializar conexion
SQL = " Select homo_fresolucion,esho_ccod,thom_ccod,homo_nresolucion " & vbcrlf & _
    " from homologacion a " & vbcrlf & _
    " where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion2 & "' " & vbcrlf & _
	" group by homo_nresolucion,homo_fresolucion,esho_ccod,thom_ccod "
f_homo.Consultar SQL

f_homo.Agregacampoparam "homo_nresolucion","permiso","LECTURA"
f_homo.Agregacampoparam "homo_fresolucion","permiso","LECTURA"
f_homo.Agregacampoparam "thom_ccod","permiso","LECTURA"

'f_homo.Siguiente

 
 
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_homologaciones_malla.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

 sql_verif_plan_fuente = "select max(plan_ccod_fuente) as plan_ccod_fuente from homologacion " & vbcrlf & _
					   " where cast(homo_nresolucion as varchar)='" & homo_nresolucion2 & "'"
					   
sql_verif_plan_destino = "select max(plan_ccod_destino) as plan_ccod_destino from homologacion " & vbcrlf & _
					   " where cast(homo_nresolucion as varchar)='" & homo_nresolucion2& "'"
					   
verif_plan_fuente = conexion.consultaUno(sql_verif_plan_fuente)
verif_plan_destino = conexion.consultaUno(sql_verif_plan_destino)

if	EsVacio(verif_plan_fuente) and EsVacio(verif_plan_destino) then

    '------ > ORIGEN
 	if  EsVacio(espe_ccod) then
  		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , " carr_ccod ='"&carr_ccod&"'"
		 f_busqueda.AgregaCampoCons "espe_ccod", espe_ccod 
	end if
	if  EsVacio(plan_ccod) then
  		f_busqueda.Agregacampoparam "plan_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "plan_ccod", "filtro" , " espe_ccod ='"&espe_ccod&"'"
		 f_busqueda.AgregaCampoCons "plan_ccod", plan_ccod 
	end if
	'----- > DESTINO
	if  EsVacio(espe_ccod_destino) then
  		f_busqueda.Agregacampoparam "espe_ccod_destino", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "espe_ccod_destino", "filtro" , " carr_ccod ='"&carr_ccod_destino&"'"
		 f_busqueda.AgregaCampoCons "espe_ccod_destino", espe_ccod_destino 
	end if
	if  EsVacio(plan_ccod_destino) then
  		f_busqueda.Agregacampoparam "plan_ccod_destino", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "plan_ccod_destino", "filtro" , " espe_ccod ='"&espe_ccod_destino&"'"
		 f_busqueda.AgregaCampoCons "plan_ccod_destino", plan_ccod_destino
	end if
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.AgregaCampoCons "carr_ccod_destino", carr_ccod_destino
 f_homo.Agregacampoparam "homo_nresolucion", "permiso", "LECTURAESCRITURA"
else
	f_homo.Agregacampoparam "homo_nresolucion", "permiso", "LECTURAESCRITURA"

	plan_ccod_aux_fuente=conexion.ConsultaUno("select plan_ccod from planes_estudio where plan_ccod=" & verif_plan_fuente)   
	plan_ccod_aux_destino=conexion.ConsultaUno("select plan_ccod from planes_estudio where plan_ccod=" & verif_plan_destino)   
	f_busqueda.Agregacampoparam "plan_ccod", "filtro" , " cast(plan_ccod as varchar)='"&plan_ccod_aux_fuente&"'"
	f_busqueda.Agregacampoparam "plan_ccod", "anulable", "false"
	f_busqueda.Agregacampoparam "plan_ccod_destino", "filtro" , " cast(plan_ccod as varchar)='"&plan_ccod_aux_destino&"'"
	f_busqueda.Agregacampoparam "plan_ccod_destino", "anulable", "false"
		
	espe_ccod_aux_fuente=conexion.ConsultaUno("select b.espe_ccod from planes_estudio a, especialidades b where a.plan_ccod=" & verif_plan_fuente & " and a.espe_ccod=b.espe_ccod")   
	espe_ccod_aux_destino=conexion.ConsultaUno("select b.espe_ccod from planes_estudio a, especialidades b where a.plan_ccod=" & verif_plan_destino & " and a.espe_ccod=b.espe_ccod")   
	f_busqueda.Agregacampoparam "espe_ccod", "filtro" , " cast(espe_ccod as varchar)='"&espe_ccod_aux_fuente&"'"
	f_busqueda.Agregacampoparam "espe_ccod", "anulable", "false"
	f_busqueda.Agregacampoparam "espe_ccod", "deshabilitado", "TRUE"
	f_busqueda.Agregacampoparam "espe_ccod_destino", "filtro" , " cast(espe_ccod as varchar)='"&espe_ccod_aux_destino&"'"
	f_busqueda.Agregacampoparam "espe_ccod_destino", "anulable", "false"
	f_busqueda.Agregacampoparam "espe_ccod_destino", "deshabilitado", "TRUE"
	
	carr_ccod_aux_fuente=conexion.ConsultaUno("select carr_ccod from especialidades where espe_ccod=" & espe_ccod_aux_fuente)   
	carr_ccod_aux_destino=conexion.ConsultaUno("select carr_ccod from especialidades where espe_ccod=" & espe_ccod_aux_destino)   
	f_busqueda.Agregacampoparam "carr_ccod", "filtro" , " cast(carr_ccod as varchar)='"&carr_ccod_aux_fuente&"'"
	f_busqueda.Agregacampoparam "carr_ccod", "anulable", "false"
	f_busqueda.Agregacampoparam "carr_ccod", "deshabilitado", "TRUE"
	f_busqueda.Agregacampoparam "carr_ccod_destino", "filtro" , " cast(carr_ccod as varchar)='"&carr_ccod_aux_destino&"'"
	f_busqueda.Agregacampoparam "carr_ccod_destino", "anulable", "false"
	f_busqueda.Agregacampoparam "carr_ccod_destino", "deshabilitado", "TRUE"
	
	'response.Write("plan :" & plan_ccod_aux_fuente & " espe : " & espe_ccod_aux_fuente & " carr : " & carr_ccod_aux_fuente)
	'response.Write("plan des:" & plan_ccod_aux_destino & " espe des: " & espe_ccod_aux_destino & " carr des: " & carr_ccod_aux_destino)
end if
f_homo.Siguiente
 f_busqueda.Siguiente

'-------------------------------------------------------------
consulta = " SELECT espe_ccod, espe_tdesc, carr_ccod  FROM especialidades order by espe_tdesc "
conexion.Ejecuta consulta
set rec_especialidades = conexion.ObtenerRS

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion	
SQL = " SELECT plan_ccod, plan_tdesc, espe_ccod  FROM planes_estudio order by plan_tdesc "
f_consulta.Consultar SQL

' direccion para ver asignaturas por malla
url= "homologaciones_mallas_asignaturas.asp?homo_nresolucion=" & homo_nresolucion2  

set f_asig_resolucion = new CFormulario
f_asig_resolucion.Carga_Parametros "m_homologaciones_malla.xml", "f_asig_resolucion"
f_asig_resolucion.Inicializar conexion
SQL_asig_resolucion = " select a.homo_ccod,c.asig_ccod as asig_ccod_origen,b.asig_ccod as asig_ccod_destino,c.asig_ccod, " & vbcrlf & _
					  " (Select asig_tdesc from asignaturas where asig_ccod=c.asig_ccod) as asig_origen, " & vbcrlf & _
		    		  " (Select asig_tdesc from asignaturas where asig_ccod=b.asig_ccod) as asig_destino " & vbcrlf & _
					  "    from homologacion a, homologacion_destino b, homologacion_fuente c " & vbcrlf & _
					  "    where cast(a.homo_nresolucion as varchar)='" & homo_nresolucion2 & "' and a.homo_ccod=b.homo_ccod " & vbcrlf & _
					  "    and a.homo_ccod=c.homo_ccod and b.homo_ccod=c.homo_ccod"
f_asig_resolucion.Consultar SQL_asig_resolucion

verif_planCcodDestino = conexion.ConsultaUno("Select max(plan_ccod_destino) from homologacion where cast(homo_nresolucion as varchar)='" & homo_nresolucion2 & "'")
verif_planCcodFuente = conexion.ConsultaUno("Select max(plan_ccod_fuente) from homologacion where cast(homo_nresolucion as varchar)='" & homo_nresolucion2 & "'")
verif_eshoCcod = conexion.ConsultaUno("select esho_ccod from homologacion where cast(homo_nresolucion as varchar)='" & homo_nresolucion2 & "' group by homo_nresolucion,esho_ccod")
'response.Write(SQL_asig_resolucion)
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
function verificar_seleccion()
{
var formulario = document.forms["origen_destino"];
if	(preValidaFormulario(formulario))
	{
	formulario.submit();
	}
}
function enviar_datos(){
var formulario = document.forms["origen_destino"];
if	(preValidaFormulario(formulario))
	{
	plan_origen = formulario.elements["busqueda[0][plan_ccod]"].value;
	plan_destino = formulario.elements["busqueda[0][plan_ccod_destino]"].value;
	resultado = open('<%=url%>'+'&plan_origen='+plan_origen+'&plan_destino='+plan_destino,'horario_carrera','width=750px, height=600px, scrollbars=yes, resizable=yes, status=yes');
	resultado.focus();
	}
}
function ver_detalle_homo(homo_ccod)
{
pagina="Detalle_Caja_Doctos_L.asp?homo_ccod="+homo_ccod
resultado = open(pagina,'wAgregar','width='+750+'px, height='+500+'px, scrollbars=yes, resizable=yes');
resultado.focus();
}
function irA_homo(homo_ccod,area_ccod,ancho, alto){
pagina="m_homologaciones_agregar.asp?homo_ccod="+homo_ccod+"&area_ccod="+area_ccod;
resultado = open(pagina,'wAgregar','width='+ancho+'px, height='+alto+'px, scrollbars=yes, resizable=yes');
resultado.focus();
}
arr_especialidades = new Array();
<%
rec_especialidades.MoveFirst
i = 0
while not rec_especialidades.Eof
%>
arr_especialidades[<%=i%>] = new Array();
arr_especialidades[<%=i%>]["espe_ccod"] = '<%=rec_especialidades("espe_ccod")%>';
arr_especialidades[<%=i%>]["espe_tdesc"] = '<%=rec_especialidades("espe_tdesc")%>';
arr_especialidades[<%=i%>]["carr_ccod"] = '<%=rec_especialidades("carr_ccod")%>';
<%	
	rec_especialidades.MoveNext
	i = i + 1
wend
%>
arr_planes = new Array();
<%
i = 0
while f_consulta.Siguiente
%>
arr_planes[<%=i%>] = new Array();
arr_planes[<%=i%>]["plan_ccod"] = '<%=f_consulta.ObtenerValor("plan_ccod")%>';
arr_planes[<%=i%>]["plan_tdesc"] = '<%=f_consulta.ObtenerValor("plan_tdesc")%>';
arr_planes[<%=i%>]["espe_ccod"] = '<%=f_consulta.ObtenerValor("espe_ccod")%>';
<%	
	i = i + 1
wend
%>

function CargarEspecialidades(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][espe_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione una Especialidad";
	formulario.elements["busqueda[0][espe_ccod]"].add(op);
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["busqueda[0][espe_ccod]"].add(op);			
		 }
	}	
}
function CargarPlanes(formulario, espe_ccod)
{
	formulario.elements["busqueda[0][plan_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione un Plan";
	formulario.elements["busqueda[0][plan_ccod]"].add(op);
	for (i = 0; i < arr_planes.length; i++)
	  { 
		if (arr_planes[i]["espe_ccod"] == espe_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_planes[i]["plan_ccod"];
			op.text = arr_planes[i]["plan_tdesc"];
			formulario.elements["busqueda[0][plan_ccod]"].add(op);			
		 }
	}	
}
function CargarEspecialidadesDestino(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][espe_ccod_destino]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione una Especialidad";
	formulario.elements["busqueda[0][espe_ccod_destino]"].add(op);
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["busqueda[0][espe_ccod_destino]"].add(op);			
		 }
	}	
}
function CargarPlanesDestino(formulario, espe_ccod)
{
	formulario.elements["busqueda[0][plan_ccod_destino]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione un Plan";
	formulario.elements["busqueda[0][plan_ccod_destino]"].add(op);
	for (i = 0; i < arr_planes.length; i++)
	  { 
		if (arr_planes[i]["espe_ccod"] == espe_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_planes[i]["plan_ccod"];
			op.text = arr_planes[i]["plan_tdesc"];
			formulario.elements["busqueda[0][plan_ccod_destino]"].add(op);			
		 }
	}	
}

function inicio()
{
  <%if carr_ccod <> "" then%>
    CargarEspecialidades(buscador, <%=carr_ccod%>);
	buscador.elements["busqueda[0][espe_ccod]"].value ='<%=espe_ccod%>'; 
  <%end if%>
  <%if espe_ccod <> "" then%>
    CargarPlanes(buscador, <%=espe_ccod%>);
	buscador.elements["busqueda[0][plan_ccod]"].value ='<%=plan_ccod%>'; 
  <%end if%>
  
  <%if carr_ccod_destino <> "" then%>
    CargarEspecialidadesDestino(buscador, <%=carr_ccod_destino%>);
	buscador.elements["busqueda[0][espe_ccod_destino]"].value ='<%=espe_ccod_destino%>'; 
  <%end if%>
  <%if espe_ccod_destino <> "" then%>
    CargarPlanesDestino(buscador, <%=espe_ccod_destino%>);
	buscador.elements["busqueda[0][plan_ccod_destino]"].value ='<%=plan_ccod_destino%>'; 
  <%end if%>
}
</script>
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
	<!-- origen-->
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
            <td><%pagina.DibujarLenguetas Array("Detalle Homologación"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">

                    <br>
                  </div>
              <form name="origen_destino" method="post" action="Proc_Detalles_homologaciones_malla_agregar.asp">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%'pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
							  <tr> 
                                <td width="21%"><div align="left">N&ordm; Resoluci&oacute;n</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="75%" colspan="3"><strong><%f_homo.DibujaCampo("homo_nresolucion") %><input type="hidden" name="homo_nresolucion" value="<%=homo_nresolucion2%>"></strong></td>
                              </tr>
							  <tr>
							  	<td><div align="left">Fecha Resoluci&oacute;n</div></td>
								<td><div align="center">:</div></td>
								<td colspan="3"><strong><%f_homo.DibujaCampo("homo_fresolucion")%></strong></td>
							  </tr>
							  <tr>
							  	<td><div align="left">Tipo Homologaci&oacute;n</div></td>
								<td><div align="center">:</div></td>
								<td colspan="3"><strong><%f_homo.DibujaCampo("thom_ccod")%></strong></td>
							  </tr>
							  <tr>
							  	<td><div align="left">Estado Homologaci&oacute;n</div></td>
								<td><div align="center">:</div></td>
								<td><strong><%f_homo.DibujaCampo("esho_ccod")%></strong></td>
								<td align="right" colspan="2"><%  botonera.agregabotonparam "anterior", "url", "m_homologaciones_malla.asp?homo_nresolucion=" & homo_nresolucion2
						      botonera.DibujaBoton "anterior"  %></td>
							  </tr>	
                              <tr> 
                                <td width="55">Origen</td>
								<td width="5">:</td>
								<td width="196"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                                <td width="196"><% f_busqueda.dibujaCampo ("espe_ccod") %></td>
                                <td width="198"><% f_busqueda.dibujaCampo ("plan_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="55">Destino</td>
								<td width="5">:</td>
								<td width="196"><% f_busqueda.dibujaCampo ("carr_ccod_destino") %></td>
                                <td width="196"><% f_busqueda.dibujaCampo ("espe_ccod_destino") %></td>
                                <td width="198"><% f_busqueda.dibujaCampo ("plan_ccod_destino") %></td>
                              </tr>
                            </table>                          
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% if	cint(verif_eshoCcod) = 2 then ' homologacion CERRADA
								     botonera.AgregaBotonParam "buscar_mallas" , "deshabilitado", "TRUE"
							   else
							   		 if  EsVacio(verif_planCcodDestino) and EsVacio(verif_planCcodFuente) then
										 botonera.AgregaBotonParam "buscar_mallas" , "deshabilitado", "TRUE"
								     else
							     	 	 botonera.AgregaBotonParam "buscar_mallas" , "deshabilitado", "FALSE"
									end if
							   end if
							   'botonera.AgregaBotonParam "buscar_mallas", "url", "homologacion_fuente_agregar.asp?homo_ccod=" & homo_ccod  
							   botonera.DibujaBoton "buscar_mallas"
							%>
                          </div></td> 
                  <td><div align="center"> 
                            <% if	cint(verif_eshoCcod) = 1 then ' homologacion ACTIVA
									botonera.AgregaBotonParam "guardar_nueva" , "deshabilitado", "FALSE"
							   else
							   		botonera.AgregaBotonParam "guardar_nueva" , "deshabilitado", "TRUE"		
							   end if
							   if usuario <> "7812832" then 	
								   botonera.agregaBotonParam "guardar_nueva", "accion", "JAVASCRIPT"
								   botonera.agregaBotonParam "guardar_nueva", "funcion", "verificar_seleccion()"
								   botonera.agregaBotonParam "guardar_nueva", "formulario", "origen_destino"
								   botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Detalles_homologaciones_malla_agregar.asp"
								   botonera.dibujaBoton "guardar_nueva"
							   end if
							%>
                          </div></td>
                  <td><div align="center"><%'botonera.DibujaBoton "lanzadera"%></div></td>
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
	<br><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Asignaturas homologadas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">

                    <br>
                  </div>
              <form name="edicion_destino">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%'pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_asig_resolucion.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <% f_asig_resolucion.DibujaTabla()%>
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% if 	f_asig_resolucion.NroFilas() > 0 then 
									botonera.AgregaBotonParam "reporte_homologacion" , "deshabilitado", "FALSE"
									if	cint(verif_eshoCcod) = 2 then ' homologacion CERRADA
										botonera.AgregaBotonParam "eliminar_destino" , "deshabilitado", "TRUE"
									else
							      		botonera.AgregaBotonParam "eliminar_destino" , "deshabilitado", "FALSE"
									end if
							   else
							   		botonera.AgregaBotonParam "eliminar_destino" , "deshabilitado", "TRUE"
							   end if
							    if usuario <> "7812832" then 
								   botonera.agregaBotonParam "eliminar_destino", "url", "Proc_homologaciones_mallas_asignaturas_eliminar.asp"
								   botonera.agregaBotonParam "eliminar_destino", "formulario", "edicion_destino"
								   botonera.DibujaBoton "eliminar_destino"
							   end if%>
                          </div></td>
                  <td><div align="center"><%'botonera.DibujaBoton "lanzadera"%></div></td>
				  <td><div align="center"><% botonera.agregaBotonParam "reporte_homologacion", "url", "homologaciones_reporte.asp?homo_nresolucion="+homo_nresolucion2 
				  							 botonera.DibujaBoton "reporte_homologacion"%></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>