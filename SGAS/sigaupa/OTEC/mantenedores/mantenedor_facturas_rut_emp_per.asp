<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
v_fact_nfactura =Request.QueryString("b[0][fact_nfactura]")
v_pers_nrut =Request.QueryString("b[0][pers_nrut]")
v_pers_xdv =Request.QueryString("b[0][pers_xdv]")
v_pers_nrut2 =Request.QueryString("b[0][pers_nrut2]")
v_pers_xdv2 =Request.QueryString("b[0][pers_xdv2]")
v_n_oc =Request.QueryString("b[0][n_oc]")
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Información de matricula"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedor_facturas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "mantenedor_facturas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "fact_nfactura", v_fact_nfactura
f_busqueda.AgregaCampoCons "pers_nrut", v_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", v_pers_xdv
f_busqueda.AgregaCampoCons "pers_nrut2", v_pers_nrut2
f_busqueda.AgregaCampoCons "pers_xdv2", v_pers_xdv2
f_busqueda.AgregaCampoCons "n_oc", v_n_oc
f_busqueda.Siguiente


if v_fact_nfactura <> "" then
filtro1=filtro1&"and f.fact_nfactura = "&v_fact_nfactura&""
end if

if v_pers_nrut <> "" then
filtro2=filtro2&"and p.pers_nrut = "&v_pers_nrut&""
end if

if v_pers_nrut2 <> "" then
filtro3=filtro3&"and f.fact_nfactura in(select f.fact_nfactura from postulacion_otec po, personas p, postulantes_cargos_factura pcf, facturas f where po.pote_ncorr = pcf.pote_ncorr and po.pers_ncorr = p.PERS_NCORR and pcf.fact_ncorr = f.fact_ncorr and p.PERS_Nrut = "&v_pers_nrut2&")"
end if

if v_n_oc <> "" then
filtro4=filtro4&"and (norc_empresa = "&v_n_oc&" or norc_otic ="&v_n_oc&")"
end if

set cursos_postulante = new CFormulario
cursos_postulante.Carga_Parametros "mantenedor_facturas.xml", "f_cursos_postulante"
cursos_postulante.Inicializar conexion

if v_fact_nfactura<> "" or v_pers_nrut <>"" or v_pers_nrut2 <>"" then

sql_descuentos="SELECT f.fact_ncorr,f.fact_nfactura,protic.trunc(f.fact_ffactura) as fecha_factura,f.fact_mtotal,f.empr_ncorr,p.PERS_TNOMBRE,cast(pers_nrut as varchar)+'-'+pers_xdv as rut_empresa," & vbCrLf &_
"'<a href=""javascript:VerAlumnos('+ cast(fact_ncorr as varchar)+ ')"">'+ 'Ver' + '</a>' as revisar," & vbCrLf &_
"(select top 1 dcur_tdesc from postulacion_otec a, datos_generales_secciones_otec b, diplomados_cursos c,postulantes_cargos_factura pcf where a.dgso_ncorr= b.dgso_ncorr" & vbCrLf &_
"and b.dcur_ncorr=c.dcur_ncorr and a.pote_ncorr = pcf.pote_ncorr and pcf.fact_ncorr = f.fact_ncorr) as curso"& vbCrLf &_
"FROM facturas f, personas p" & vbCrLf &_
"where f.empr_ncorr = p.PERS_ncorr"& vbCrLf &_
""&filtro1&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""

cursos_postulante.Consultar sql_descuentos
else 

cursos_postulante.Consultar "select ''"
end if
'**********************OTIC************************

set cursos_otic = new CFormulario
cursos_otic.Carga_Parametros "mantenedor_facturas.xml", "f_cursos_otic"
cursos_otic.Inicializar conexion

if v_n_oc <> "" then

sql_descuentos="select dgso_ncorr,(select pers_tnombre from personas x where x.pers_ncorr = empr_ncorr_empresa) as PERS_TNOMBRE,(select protic.obtener_rut(x.pers_ncorr) from personas x where x.pers_ncorr = empr_ncorr_empresa) as rut_empresa," & vbCrLf &_
"(select pers_tnombre from personas x where x.pers_ncorr = empr_ncorr_otic ) as PERS_TNOMBRE_otic,(select protic.obtener_rut(x.pers_ncorr) from personas x where x.pers_ncorr = empr_ncorr_otic) as rut_otic,'<a href=""javascript:VerAlumnosOtic('+ cast(dgso_ncorr as varchar)+ ')"">'+ 'Ver' + '</a>' as revisar," & vbCrLf &_
"(select top 1 dcur_tdesc from postulacion_otec a, datos_generales_secciones_otec b, diplomados_cursos c where a.dgso_ncorr= b.dgso_ncorr and b.dcur_ncorr=c.dcur_ncorr and a.dgso_ncorr = po.dgso_ncorr) as curso, "&v_n_oc&" as oc" & vbCrLf &_
"from  postulacion_otec po,personas p"& vbCrLf &_
"where empr_ncorr_empresa = p.pers_ncorr" & vbCrLf &_
""&filtro4&""& vbCrLf &_
"group by dgso_ncorr,empr_ncorr_empresa,empr_ncorr_otic"

cursos_otic.Consultar sql_descuentos
else 

cursos_otic.Consultar "select ''"
end if

'response.Write("<pre>"&sql_descuentos&"</pre>")
'	response.End()
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
function ValidaBusqueda()
{
	rut_empresa=document.buscador.elements['b[0][pers_nrut]'].value
	rut_alumno=document.buscador.elements['b[0][pers_nrut2]'].value
	n_factura=document.buscador.elements['b[0][fact_nfactura]'].value
	n_oc=document.buscador.elements['b[0][n_oc]'].value
	
	parametro =(rut_empresa+""+ rut_alumno  +""+n_factura)
	//alert(parametro+" n_oc " + n_oc)
		if (parametro != "" && n_oc != ""){
		alert('Debe ingresar solo 1 criterio de busqueda')	
		return false;	
		}
		
	
	
	if((rut_empresa != "" && rut_alumno != "")||(rut_empresa != "" && n_factura != "")||(rut_alumno != "" && n_factura != "")){
		alert('Debe ingresar solo 1 criterio de busqueda')	
		return false;	
	}
	
	if (rut_empresa != ""){	
		rut=document.buscador.elements['b[0][pers_nrut]'].value+'-'+document.buscador.elements['b[0][pers_xdv]'].value	
		if (!valida_rut(rut)) {
			alert('Ingrese un rut válido');		
			document.buscador.elements['b[0][pers_nrut]'].focus()
			document.buscador.elements['b[0][pers_nrut]'].select()
			return false;
		}
	}
	if (rut_alumno != ""){	
		rut=document.buscador.elements['b[0][pers_nrut2]'].value+'-'+document.buscador.elements['b[0][pers_xdv2]'].value	
		if (!valida_rut(rut)) {
			alert('Ingrese un rut válido');		
			document.buscador.elements['b[0][pers_nrut2]'].focus()
			document.buscador.elements['b[0][pers_nrut2]'].select()
			return false;
		}
	}
	return true;
}

function VerAlumnosOtic(dgso_ncorr)
{
	//alert(fact_ncorr);
	window.open("mostrar_alumnos_otec.asp?dgso_ncorr="+dgso_ncorr,"","width=770,height=580, scrollbars=yes, top=10,left=10,  resizable=yes");
}

function VerAlumnos(fact_ncorr)
{
	//alert(fact_ncorr);
	window.open("mostrar_alumnos_otec.asp?fact_ncorr="+fact_ncorr,"","width=770,height=580, scrollbars=yes, top=10,left=10,  resizable=yes");
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
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
		  <%pagina.DibujarTitulo("Datos Empresas y Alumnos")%>
            <td>
				 <form name="buscador">
				 <input type="hidden" name="buscar">
				 	<table align="center" width="100%">
						<tr>
							<td width="8%"><strong>Rut Empresa</strong></td>
							<td width="25%"><%f_busqueda.DibujaCampo("pers_nrut")%>
-
  <%f_busqueda.DibujaCampo("pers_xdv")%>
  <a href="javascript:buscar_persona('b[0][pers_nrut]', 'b[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
							<td width="10%"><strong>N&deg; Factura</strong></td>
							<td width="31%"><%f_busqueda.DibujaCampo("fact_nfactura")%></td>
						    <td width="26%"><div align="center">
						      <%f_botonera.DibujaBoton("buscar")%>
					        </div></td>
					  </tr>
                      <tr>
							<td width="8%"><strong>Rut Alumno</strong></td>
							<td width="25%"><%f_busqueda.DibujaCampo("pers_nrut2")%>
-
  <%f_busqueda.DibujaCampo("pers_xdv2")%>
  <a href="javascript:buscar_persona('b[0][pers_nrut2]', 'b[0][pers_xdv2]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
							<td width="10%"><strong>N&deg; OC</strong></td>
							<td width="31%"><%f_busqueda.DibujaCampo("n_oc")%></td>
						    <td width="26%">&nbsp;</td>
					  </tr>
                    </table>	
                    <%if request.QueryString.count = 0 then%>					
					<table align="left" width="100%">
						<tr valign="bottom">
							<td width="14%"><%f_botonera.DibujaBoton("salir")%></td>
						</tr>
					</table>
                    <%end if%>
                 </form>
			</td>
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
	<%if request.QueryString.count > 0 and buscar<>"N" then%> 
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
		  
            <td>
              <%pagina.DibujarTituloPagina%><br>
  
             <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Información de matricula"%>
				
                      <table width="98%"  border="0" align="center">
					   <tr>
                       		<%if v_fact_nfactura<> "" or v_pers_nrut <>"" or v_pers_nrut2 <>"" then%>
                       
                       
                             <td align="right">P&aacute;gina:
                                 <%cursos_postulante.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
									<%cursos_postulante.Dibujatabla()%>
							   </td>
						  <%end if%>
                          
                          <%if v_n_oc <> "" then%>
                       
                       
                             <td align="right">P&aacute;gina:
                                 <%cursos_otic.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
									<%cursos_otic.Dibujatabla()%>
							   </td>
						  <%end if%>
                          
                          
                        </tr>
                      </table>
                      
                  </tr>
                </table>
                          <br>
            </form>
        </table>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				</tr>
              </table>
            </div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%end if%><br>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>