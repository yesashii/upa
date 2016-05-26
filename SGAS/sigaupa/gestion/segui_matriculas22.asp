<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sede_ccod = Request.QueryString("sede")
jorn_ccod = Request.QueryString("jornada")
carr_ccod = Request.QueryString("carrera")
estado_ccod = Request.QueryString("estado_ccod")
busqueda=request.QueryString("paso")
'response.Write("jornada= "&jorn_ccod)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Seguimiento de Matriculas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "lista_matriculas.xml", "botonera"
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")


set f_sedes = new CFormulario
f_sedes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_sedes.Inicializar conexion
consulta_sedes = "select distinct b.sede_tdesc as tdesc,b.sede_ccod as ccod from ofertas_academicas a, sedes b where cast(peri_ccod as varchar)='"&v_peri_ccod&"' and a.sede_ccod=b.sede_ccod "
f_sedes.Consultar consulta_sedes
f_sedes.agregacampoCons "sede_ccod",sede_ccod
cantidad_sedes=f_sedes.nroFilas
'f_sedes.Siguiente

set f_carreras = new CFormulario
f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
f_carreras.Inicializar conexion
consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
                    " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					" where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    " and a.post_bnuevo='S'" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_ 
                    " and b.carr_ccod=c.carr_ccod" 
             
if sede_ccod="" then
consulta_carreras=consulta_carreras & " and 1=2"
end if
consulta_carreas=consulta_carreras & " order by carr_tdesc"
					  
f_carreras.Consultar consulta_carreras
cantidad_carreras=f_carreras.nroFilas
'f_carreras.Siguiente

set lista = new CFormulario
lista.carga_parametros "lista_matriculas.xml", "list_alumnos"
lista.inicializar conexion

if estado_ccod="1" then
consulta=" select protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, a.pers_temail as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas_postulante a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h,estado_examen_postulantes i " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" then
         	consulta= consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
         consulta= consulta& " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" then
		 consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" then
         	consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
		 " and protic.buscar_pagados(cast(a.pers_ncorr as varchar),"&v_peri_ccod&")=0"& vbCrLf &_
		 " and i.eepo_ccod=1 "&vbCrlf &_
         " and c.eepo_ccod = i.eepo_ccod " & vbCrLf &_ 
         " and b.epos_ccod = 2 " & vbCrLf &_ 
         " and b.tpos_ccod = 1 "
end if
if estado_ccod="2" then
consulta=" select protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, a.pers_temail as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h,estado_examen_postulantes i " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
         " and d.espe_ccod = e.espe_ccod " 
		 if carr_ccod<>"" then
            consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if	
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  " 
		 if jorn_ccod<>"" then
		 	consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
		 if sede_ccod<>"" then
             consulta=consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " --and protic.buscar_pagados(cast(a.pers_ncorr as varchar),"&v_peri_ccod&")=1"& vbCrLf &_
		 " and i.eepo_ccod=1 "&vbCrlf &_
         " and c.eepo_ccod = i.eepo_ccod " & vbCrLf &_ 
         " and b.epos_ccod = 2 " & vbCrLf &_ 
         " and b.tpos_ccod = 1 "
end if
if estado_ccod="3" then
consulta=" select protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, a.pers_temail as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h,estado_examen_postulantes i " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" then
               consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'"
		 end if	   
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  " 
		 if jorn_ccod<>"" then
		 		consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod " 
         if sede_ccod<>"" then
         consulta=consulta &" and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta &" and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " --and protic.buscar_pagados(cast(a.pers_ncorr as varchar),"&v_peri_ccod&")=1"& vbCrLf &_
		 " and i.eepo_ccod=2 "&vbCrlf &_
         " and c.eepo_ccod = i.eepo_ccod " & vbCrLf &_ 
         " and b.epos_ccod = 2 " & vbCrLf &_ 
         " and b.tpos_ccod = 1 "& vbCrLf &_
		 " and not exists (select 1 from alumnos al where b.post_ncorr=al.post_ncorr and al.emat_ccod=1 )"
		 'response.Write("<pre>"&consulta&"</pre>")
end if
if estado_ccod="4" then
consulta=" select protic.FORMAT_RUT(cast(a.pers_nrut as varchar(10))) as rut," & vbCrLf &_ 
         " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre," & vbCrLf &_ 
         " a.pers_tfono as fono, a.pers_temail as email,g.jorn_tdesc as jornada" & vbCrLf &_ 
         " from  " & vbCrLf &_ 
         " personas a,postulantes b,detalle_postulantes c, " & vbCrLf &_ 
         " ofertas_academicas d,especialidades e,carreras f,jornadas g, " & vbCrLf &_ 
         " sedes h,estado_examen_postulantes i " & vbCrLf &_ 
         " where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_ 
         " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
         " and b.post_ncorr = c.post_ncorr " & vbCrLf &_ 
         " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_ 
         " and d.espe_ccod = e.espe_ccod "
		 if carr_ccod<>"" then 
	         consulta=consulta & " and cast(f.carr_ccod as varchar)= '"&carr_ccod&"'" 
		 end if
         consulta=consulta & " and e.carr_ccod = f.carr_ccod  "
		 if jorn_ccod<>"" then
		 	consulta=consulta&" and cast(d.jorn_ccod as varchar)='"&jorn_ccod&"'"
		 end if
         consulta=consulta & " and d.jorn_ccod = g.jorn_ccod "
     	 if sede_ccod<>"" then
         	consulta= consulta & " and cast(h.sede_ccod as varchar)= '"&sede_ccod&"'"
		 end if
         consulta=consulta & " and d.sede_ccod = h.sede_ccod " & vbCrLf &_ 
	 	 " --and protic.buscar_pagados(cast(a.pers_ncorr as varchar),"&v_peri_ccod&")=1"& vbCrLf &_
		 " and i.eepo_ccod=2 "&vbCrlf &_
         " and c.eepo_ccod = i.eepo_ccod " & vbCrLf &_ 
         " and b.epos_ccod = 2 " & vbCrLf &_ 
         " and b.tpos_ccod = 1 "& vbCrLf &_
		 " and  exists (select 1 from alumnos al where b.post_ncorr=al.post_ncorr and al.emat_ccod=1 )"
end if

if busqueda="" or estado_ccod="" then
consulta = "select  pers_ncorr, cast(a.pers_nrut as varchar) as rut,  " &_
            "a.PERS_TAPE_PATERNO+' '+a.PERS_TAPE_MATERNO+' '+a.PERS_TNOMBRE as nombre  " &_ 
            "from personas a  where 1=2"
end if 
'response.Write("<pre>"&consulta&"</pre>") 
'response.End()
lista.consultar consulta
cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
'response.Write("Cantidad de alumnos "&cantidad_encontrados)

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
function filtrarFacultades(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="segui_matriculas.asp";
formulario.submit();
}
function filtrarCarreras(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="segui_matriculas.asp";
formulario.submit();
}
function enviar(formulario)
{
document.buscador.paso.value="1";
document.buscador.method="get";
document.buscador.action="segui_matriculas.asp";
document.buscador.submit();
}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
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
            <td><form name="buscador" method="get" action="">
              <br><input type="hidden" name="paso" value="">
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="61"><div align="left"><strong>Sede </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td width="426"><%'f_sedes.DibujaCampo("sede_ccod")%> 
						               <select name="sede" onChange="filtrarFacultades(this.form);">
									   <%If cantidad_sedes>"0" then%>
						               <option value="">Seleccione una sede</option>
						               <%while f_sedes.siguiente
									       ccod = f_sedes.obtenervalor("ccod")
										   tdesc= f_sedes.obtenervalor("tdesc")
										   		if cstr(ccod)=cstr(sede_ccod) then%>
								           			<option value="<%=ccod%>" selected><%=tdesc%></option>
										   		<%else%>
										   			<option value="<%=ccod%>"><%=tdesc%></option>		
										  		 <%end if
										   wend
										   else%>
										  <option value="">No existen sedes Disponibles</option> 
										  <%end if%>
						                </select>
					  </tr>
					  <tr>
                        <td><div align="left"><strong>Jornada </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td><%'f_carreras.DibujaCampo("carr_ccod")%> 
						    <select name="jornada" onChange="filtrarCarreras(this.form);">
							<%if jorn_ccod="" then%>
							<option value="" selected>Seleccione una Jornada</option>
							<%else%>
							<option value="">Seleccione una Jornada</option>
							<%end if%>
							<%if jorn_ccod="1" then%>
 						    <option value="1" selected>DIURNA</option>
							<%else%>
							<option value="1">DIURNA</option>
							<%end if%>
							<%if jorn_ccod="2" then%>
							<option value="2"selected>VESPERTINA</option>
							<%else%>
							<option value="2">VESPERTINA</option>
							<%end if%>
							</select>
                      </tr>
					  <tr>
                        <td><div align="left"><strong>Carrera </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td><%'f_carreras.DibujaCampo("carr_ccod")%> 
						    <select name="carrera" onChange="filtrarCarreras(this.form);">
									   <%If cantidad_carreras>"0" then%>
						               <option value="">Seleccione una Carrera</option>
						               <%while f_carreras.siguiente
									       ccod3 = f_carreras.obtenervalor("carr_ccod")
										   tdesc3= f_carreras.obtenervalor("carr_tdesc")
										   		if cstr(ccod3)=cstr(carr_ccod) then%>
								           			<option value="<%=ccod3%>" selected><%=tdesc3%></option>
										   		<%else%>
										   			<option value="<%=ccod3%>"><%=tdesc3%></option>		
										  		 <%end if
										   wend
										   else%>
										  <option value="">No existen Carreras Disponibles</option> 
										  <%end if%>
						    </select>
                      </tr>
					  <tr>
                        <td><div align="left"><strong>Estado </strong></div></td>
                        <td width="20"><div align="center">:</div></td>
                        <td><select name='estado_ccod' onChange="filtrarFacultades(this.form);">
						    <%if estado_ccod="" then%>
                            <option value='' selected>Seleccione un estado</option>
							<%else%>
							<option value=''>Seleccione un estado</option>
							<%end if%>
							<%if estado_ccod="1" then%>
							<option value='1' selected>POSTULANTES SIN EXAMEN PAGADO</option>
							<%else%>
							<option value='1' >POSTULANTES SIN EXAMEN PAGADO</option>
							<%end if%>
							<%if estado_ccod="2" then%>
                            <option value='2' selected>POSTULANTES SIN RENDIR EXAMEN</option>
							<%else%>
							<option value='2' >POSTULANTES SIN RENDIR EXAMEN</option>
							<%end if%>
							<%if estado_ccod="3" then%>
                            <option value='3' selected>POSTULANTES SIN MATRICULA</option>
							<%else%>
							<option value='3' >POSTULANTES SIN MATRICULA</option>
							<%end if%>
							<%if estado_ccod="4" then%>
                            <option value='4' selected>POSTULANTES MATRICULADOS</option>
							<%else%>
							<option value='4' >POSTULANTES MATRICULADOS</option>
							<%end if%>
                           </select> 
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
            <td><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			  <input type="hidden" name="sede" value="<%=sede_ccod%>">
              <input type="hidden" name="jornada" value="<%=jorn_ccod%>">
			  <input type="hidden" name="carrera" value="<%=carr_ccod%>">
			  <input type="hidden" name="estado_ccod" value="<%=estado_ccod%>">
			  <input type="hidden" name="paso" value="<%=busqueda%>">
			     			  
                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumnos
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right">P&aacute;gina:
                                 <%lista.accesopagina%>
                             </td>
                             </tr>
                               <tr>
                                 <td align="center">
                                    <%lista.dibujaTabla()%>
                                  </td>
                             </tr>
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
                                              </table>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
