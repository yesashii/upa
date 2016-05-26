<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


v_ccos_ccod = 	Request.QueryString("ccos_ccod")
sede_ccod 	= 	Request.QueryString("sede_ccod")
jorn_ccod 	= 	Request.QueryString("jorn_ccod")
carr_ccod 	= 	Request.QueryString("carr_ccod")
tdet_ccod 	= 	Request.QueryString("tdet_ccod")
v_edita		=	Request.QueryString("v_edita")

if carr_ccod=0 then
	carr_ccod=""
end if
if jorn_ccod=0 then
	jorn_ccod=""
end if


set pagina = new CPagina
pagina.Titulo = "Asignar centro de costo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'---------------------------------------------------------------------------------------------------

set negocio = new CNegocio
negocio.Inicializa conexion
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
usuario=negocio.ObtenerUsuario()


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asigna_centros_costos.xml", "botonera"

set f_busqueda_cc = new CFormulario
f_busqueda_cc.Carga_Parametros "asigna_centros_costos.xml", "busqueda"
f_busqueda_cc.Inicializar conexion
f_busqueda_cc.Consultar "Select ''"
f_busqueda_cc.SiguienteF

f_busqueda_cc.AgregaCampoCons "ccos_ccod", v_ccos_ccod

'sede_ccod_usuario=negocio.ObtenerSede()
if sede_ccod="" or sede_ccod=0 then
	sede_ccod=1
end if

'f_busqueda_cc.AgregaCampoCons "ccos_ccod", v_ccos_ccod


'---------------------------------------------------------------------------------------------------
'---------------------------------------Agregado ingenieril para los combos ------------------------
 set f_sedes2 = new CFormulario
 f_sedes2.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_sedes2.Inicializar conexion
 
 consulta_sedes = "select distinct b.sede_ccod as ccod " & vbCrLf &_ 
					" from ofertas_academicas a, sis_sedes_usuarios b  " & vbCrLf &_ 
					" where cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' " & vbCrLf &_ 
					" and a.sede_ccod=b.sede_ccod "
					
 f_sedes2.Consultar consulta_sedes

 while f_sedes2.siguiente
 	if cad_sedes="" then
	   cad_sedes=cad_sedes&f_sedes2.obtenerValor("ccod")
	else
	   cad_sedes=cad_sedes&","&f_sedes2.obtenerValor("ccod")   
	end if
 wend
 'response.Write("<pre>"&cad_sedes&"->"&sede_ccod&"</pre>")
 '------------------------------------------consultamos las carreras--------------------------------------------------------
 if sede_ccod<>"" and sede_ccod<>"-1" then
		 set f_carreras = new CFormulario
		 f_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
		 f_carreras.Inicializar conexion
		 consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
         			         " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					  		 " where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		 " --and a.post_bnuevo='S'" & vbCrLf &_ 
                    		 " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    		 " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
							 " and b.carr_ccod=c.carr_ccod" & vbCrLf &_
                             " order by carr_tdesc"
		f_carreras.Consultar consulta_carreras
		
		while f_carreras.siguiente
			if cad_carreras="" then
			    cad_carreras=cad_carreras & "'" & f_carreras.obtenerValor("carr_ccod") & "'"
			else
		        cad_carreras=cad_carreras & ",'" & f_carreras.obtenerValor("carr_ccod") & "'"
		    end if
        wend
 end if
' response.End()
 '-----------------------------------------buscamos las jornadas que pertenecen a la carrera
 if carr_ccod<>"" and carr_ccod<>"-1"  then
	  	set f_jornadas = new CFormulario
		f_jornadas.Carga_Parametros "tabla_vacia.xml", "tabla"
		f_jornadas.Inicializar conexion
		consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod" & vbCrLf &_  
							" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                		    " where cast(b.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_ 
                    		" and b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    		" and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    		" and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    		" and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"
		f_jornadas.Consultar consulta_jornadas
		
		while f_jornadas.siguiente
			if cad_jornadas="" then
			    cad_jornadas=cad_jornadas&f_jornadas.obtenerValor("jorn_ccod")
			else
		        cad_jornadas=cad_jornadas&","&f_jornadas.obtenerValor("jorn_ccod")
		    end if
        wend
 end if
'--------------------------------------------fin seleccion combos carreras--------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "asigna_centros_costos.xml", "busqueda2"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "Select ''"

f_busqueda.AgregaCampoCons "tdet_ccod", tdet_ccod
f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod
f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod
f_busqueda.AgregaCampoCons "jorn_ccod", jorn_ccod

'--------------------------------------------agregamos filtros a los select que mostraran la sede, asignatura, jornada
 if cad_sedes<>"" then
 	   f_busqueda.Agregacampoparam "sede_ccod", "filtro" , "sede_ccod in ("&cad_sedes&")"
	   'response.Write("sede_ccod in ("&cad_sedes&")")
 end if
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod 
   
 	if  EsVacio(sede_ccod) or sede_ccod="-1" then
  		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "carr_ccod in ("&cad_carreras&")"
	    f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
		'response.Write("carr_ccod in ("&cad_carreras&")")
	end if
	
		
	if EsVacio(carr_ccod) or carr_ccod="-1" then
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "jorn_ccod", "filtro" , "jorn_ccod in ("&cad_jornadas&")"
	    f_busqueda.AgregaCampoCons "jorn_ccod", jorn_ccod 
	end if
'-----------------------------------------------------------fin filtros------------------------------------------------
f_busqueda.Siguiente
'response.End()



'---------------------------modificaciones nuevos filtros-------------------------------------------------
' ##########################################	CARRERAS   ##########################################
consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc,a.sede_ccod" & vbCrLf &_ 
                    " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
                    " where cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
					" --and a.post_bnuevo='S'" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
                    " and b.carr_ccod=c.carr_ccod" 
conexion.Ejecuta consulta_carreras
set rec_carreras = conexion.ObtenerRS

' ##########################################	JORNADAS   ##########################################
consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod,b.carr_ccod" & vbCrLf &_  
					" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                    " where b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    " and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    " and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'"

conexion.Ejecuta consulta_jornadas
set rec_jornadas=conexion.ObtenerRS
'---------------------------------------------------------------------------------------------------------
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
formulario.action="asigna_centros_costos.asp";
formulario.submit();
}

function filtrarCarreras(formulario)
{
formulario.paso.value="";
formulario.method="get";
formulario.action="asigna_centros_costos.asp";
formulario.submit();
}

function enviar(formulario)
{
document.buscador.paso.value="1";
document.buscador.method="get";
document.buscador.action="asigna_centros_costos.asp";
document.buscador.submit();
}


arr_carreras = new Array();
arr_jornadas =new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_carreras[<%=i%>] = new Array();
arr_carreras[<%=i%>]["carr_ccod"] = '<%=rec_carreras("carr_ccod")%>';
arr_carreras[<%=i%>]["carr_tdesc"] = '<%=rec_carreras("carr_tdesc")%>';
arr_carreras[<%=i%>]["sede_ccod"] = '<%=rec_carreras("sede_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

<%
rec_jornadas.MoveFirst
j = 0
while not rec_jornadas.Eof
%>
arr_jornadas[<%=j%>] = new Array();
arr_jornadas[<%=j%>]["jorn_ccod"] = '<%=rec_jornadas("jorn_ccod")%>';
arr_jornadas[<%=j%>]["jorn_tdesc"] = '<%=rec_jornadas("jorn_tdesc")%>';
arr_jornadas[<%=j%>]["carr_ccod"] = '<%=rec_jornadas("carr_ccod")%>';
<%	
	rec_jornadas.MoveNext
	j = j + 1
wend
%>

function CargarCarreras(formulario, sede_ccod)
{
	formulario.elements["busqueda[0][carr_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Carreras";
	formulario.elements["busqueda[0][carr_ccod]"].add(op)
	for (i = 0; i < arr_carreras.length; i++)
	  { 
		if (arr_carreras[i]["sede_ccod"] == sede_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_carreras[i]["carr_ccod"];
			op.text = arr_carreras[i]["carr_tdesc"];
			formulario.elements["busqueda[0][carr_ccod]"].add(op)			
		 }
	}	
}

function CargarJornadas(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][jorn_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Jornada";
	formulario.elements["busqueda[0][jorn_ccod]"].add(op)
	for (j = 0; j < arr_jornadas.length; j++)
	  { 
		if (arr_jornadas[j]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_jornadas[j]["jorn_ccod"];
			op.text = arr_jornadas[j]["jorn_tdesc"];
			formulario.elements["busqueda[0][jorn_ccod]"].add(op)			
		 }
	}	
}
function inicio()
{
  <%if sede_ccod <> "" then%>
    CargarCarreras(buscador, <%=sede_ccod%>);
	buscador.elements["busqueda[0][carr_ccod]"].value ='<%=carr_ccod%>'; 
  <%end if%>
  <%if carr_ccod <> "" then%>
    CargarJornadas(buscador, <%=carr_ccod%>);
	buscador.elements["busqueda[0][jorn_ccod]"].value ='<%=jorn_ccod%>'; 
  <%end if%>
}

function marca_opcion(form,op){
	
	if(op==1){
		form.opcion[1].checked=true;
		DeshabilitaEscuela();
	}else{
		form.opcion[0].checked=true;
		DeshabilitaDetalle();
	}
}


function DeshabilitaEscuela(){

	buscador.elements["busqueda[0][sede_ccod]"].disabled=true;
	buscador.elements["busqueda[0][jorn_ccod]"].disabled=true;
	buscador.elements["busqueda[0][carr_ccod]"].disabled=true;
	// habilita detalle
	buscador.elements["busqueda[0][tdet_ccod]"].disabled=false;
	
}
function DeshabilitaDetalle(){
	buscador.elements["busqueda[0][tdet_ccod]"].disabled=true;
	// habilita escuela
	buscador.elements["busqueda[0][sede_ccod]"].disabled=false;
	buscador.elements["busqueda[0][jorn_ccod]"].disabled=false;
	buscador.elements["busqueda[0][carr_ccod]"].disabled=false;
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();marca_opcion(document.buscador,1);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
  
    <td valign="top" bgcolor="#EAEAEA">
	<form name="buscador">
	<input type="hidden" name="v_edita" value="<%=v_edita%>">
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
	  
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
     			  
			  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
				  <tr>
                    <td>
                          <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bordercolor='#999999' >
                            <tr bgcolor='#C4D7FF' bordercolor='#999999'> 
                              <td width="51%" > <div align="center">
                                  <input type="radio" name="opcion" value="1" onClick="DeshabilitaDetalle();" <%=v_checked_carrera%> >
                                  <strong>Por Carrera</strong></div></td>
                              <td width="49%"> <div align="center">
                                  <input type="radio" name="opcion" value="2" onClick="DeshabilitaEscuela();" <%=v_checked_detalle%>>
                                  <strong> Por Tipo Cargo</strong></div></td>
                            </tr>
                            <tr > 
                              <td > <table width="99%"   cellspacing="0" cellpadding="0"  >
                                  <tr> 
                                    <td width="85"><div align="left"><strong>Sede</strong></div></td>
                                    <td width="16"><div align="center">:</div></td>
                                    <td width="280"><%f_busqueda.DibujaCampo("sede_ccod")%></td>
                                  </tr>
                                  <tr> 
                                    <td><div align="left"><strong>Carrera</strong></div></td>
                                    <td width="16"><div align="center">:</div></td>
                                    <td><%f_busqueda.DibujaCampo("carr_ccod")%></td>
                                  </tr>
                                  <tr> 
                                    <td><div align="left"><strong>Jornada</strong></div></td>
                                    <td width="16"><div align="center">:</div></td>
                                    <td><%f_busqueda.DibujaCampo("jorn_ccod")%></td>
                                  </tr>
                                </table></td>
                              <td > <table width="98%" height="98%" >
                                  <tr> 
                                    <td>&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td><%f_busqueda.DibujaCampo("tdet_ccod")%></td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp; </td>
                                  </tr>
                                </table></td>
                            </tr>
                          </table>
					</td>
                  </tr>

                </table>
            
			</td>
          </tr>
        </table>
		
		</td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	
	<br>
	<table width="97%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                </div>
              
			  <table width="99%"  border="0" cellspacing="0" cellpadding="0" >
                  <tr>
				  		<td><%pagina.DibujarSubtitulo "Titulo"%></td>
				  </tr>
				  <tr>
				  		<td align="center"><br/><%f_busqueda_cc.DibujaCampo("ccos_ccod")%><br/></td>
				  </tr>
				  <tr>
				  <td><p><br></p></td>
				  </tr>
				 </table> 
            </td></tr>
        </table>
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="9%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
					<td><div align="left"><%f_botonera.DibujaBoton("guardar")%></div></td>
                  	<td><div align="left"><%f_botonera.DibujaBoton("cerrar")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br></form>
	</td>
	
  </tr>  
</table>
</body>
</html>
