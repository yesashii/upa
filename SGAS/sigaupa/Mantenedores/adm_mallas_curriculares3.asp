 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
carrera       = request.QueryString("bsec[0][carr_ccod]")
especialidad  = request.QueryString("bsec[0][espe_ccod]")
nivel         = request.QueryString("bsec[0][nive_ccod]")
plan          = request.QueryString("bsec[0][plan_ccod]") 
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
espe_ccod = request.querystring("busqueda[0][espe_ccod]")
plan_ccod= request.QueryString("busqueda[0][plan_ccod]")


carrera=carr_ccod
especialidad=espe_ccod
plan=plan_ccod

'carrera22=carr_ccod
'especialidad22=espe_ccod
'planes22=plan_ccod

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Mallas"

set botonera =  new CFormulario
botonera.carga_parametros "adm_mallas_curriculares3.xml", "btn_busca_malla"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'---------------------------------------------------------------------------------------------------

set tabla = new cformulario

ca="select cast(carr_ccod as varchar)+' - '+carr_tdesc as carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carrera&"'"
rcarrera=conectar.consultauno(ca)
espe="select cast(espe_ccod as varchar)+ '-' +espe_tdesc as espe_tdesc from especialidades where cast(espe_ccod as varchar)='"&especialidad&"'"
respecialidad=conectar.consultauno(espe)
pl="select cast(plan_ccod as varchar)+'-'+cast(plan_ncorrelativo as varchar)+' - '+plan_tdesc as plan_ncorrelativo from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'"
rplan=conectar.consultauno(pl)

tabla.carga_parametros	"adm_mallas_curriculares3.xml",	"tabla_conv"
tabla.inicializar		conectar

sede_ccod =1 ' negocio.obtenersede 
sede =1'negocio.obtenersede 

sede_ccod = negocio.ObtenerSede
sede = negocio.ObtenerSede
'response.End()
tablas=" select distinct " & _
		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & _
		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras,e.carr_ccod as carr_ccod  " & _
		" from asignaturas a " & _
		" , malla_curricular b " & _
		" , planes_estudio c " & _
		" , especialidades e" & _
		" where a.asig_ccod = b.asig_ccod " & _
		" and e.ESPE_CCOD=c.ESPE_CCOD" & _
		" and b.plan_ccod=c.plan_ccod " & _
		" and cast(b.plan_ccod as varchar)= '"&plan&"' " & _
		" and cast(c.espe_ccod as varchar)= '"&especialidad&"' " & _
		" order by b.nive_ccod,a.asig_ccod "
		

nro_niveles=conectar.consultauno("select max(nivel) from (select distinct " & _
		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & _
		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras " & _		
		" from asignaturas a " & _
		" , malla_curricular b " & _
		" , planes_estudio c " & _
		" where a.asig_ccod = b.asig_ccod " & _
		" and b.plan_ccod=c.plan_ccod " & _
		" and cast(b.plan_ccod as varchar)= '"&plan&"' " & _
		" and cast(c.espe_ccod as varchar)= '"&especialidad&"' " & _
		" )s")
		
		
MaxNiveles=nro_niveles
set fo 		= 		new cFormulario
fo.carga_parametros	"adm_mallas_curriculares3.xml",	"tabla_conv"
fo.inicializar		conectar
fo.consultar 		tablas

'response.End()
set asignatura = new cformulario
asignatura.carga_parametros "adm_mallas_curriculares3.xml","tabla"
asignatura.inicializar conectar		
asignatura.consultar tablas
	if asignatura.nroFilas > 0 then
		redim asig_ccod(asignatura.nroFilas)
		for k=0 to asignatura.nroFilas-1
			asignatura.siguiente
			asig_ccod(k)= asignatura.obtenerValor("asig_ccod")
		next
	end if
'response.End()
set requisito = new cformulario
requisito.carga_parametros "adm_mallas_curriculares3.xml","tabla"
requisito.inicializar conectar		
requisito.consultar tablas
'response.End()
set req = new cformulario
req.carga_parametros "adm_mallas_curriculares3.xml","tabla"
		
for j=0 to asignatura.nroFilas-1
	requisito="SELECT distinct M1.ASIG_CCOD as asig_ccod, substring(t.TREQ_TDESC,1,3) as tipo " & _
		  " FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p " & _
		  " WHERE R.MALL_CREQUISITO = M1.MALL_CCOD " & _
		  " AND R.MALL_CCOD = M2.MALL_CCOD " & _
		  " and r.TREQ_CCOD = t.TREQ_CCOD " & _
		  " and cast(m2.asig_ccod as varchar)= '" & asig_ccod(j) & "' " & _
		  " and m2.plan_ccod = p.plan_ccod " & _
		  " and cast(m2.plan_ccod as varchar)= '"&plan&"' " & _
		  " and cast(p.espe_ccod as varchar)= '" & especialidad & "' "
	req.Inicializar conectar
	req.consultar requisito
	if req.nrofilas > 0 then
		req_tipo = ""
		for kk=0 to req.nrofilas-1
			req.siguiente
			req_tipo = req_tipo & " " & req.ObtenerValor("asig_ccod") & " - " &req.obtenervalor("tipo")&"<br>" 
		next
		fo.agregaCampoFilaCons j, "requisito", req_tipo
	else
		fo.agregaCampoFilaCons j, "requisito", "--"
	end if
next
'response.End()
'set fbusqueda = new cFormulario
'---------------------------------------------------modificado para corregir filtros 05-11-2004------------------


carrera = conectar.consultauno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar) = '" & carr_ccod & "'")
especialidad = conectar.consultauno("SELECT espe_tdesc FROM especialidades WHERE cast(espe_ccod as varchar)= '" & espe_ccod & "'")
planes = conectar.consultauno("SELECT plan_tdesc FROM planes_estudio WHERE cast(plan_ccod as varchar)= '" & plan_ccod & "'")

'response.Write(espe_ccod & ":"& especialidad & "<BR><BR>")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "adm_mallas_curriculares3.xml", "f_busqueda"
 
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select ''"

	
 	if  EsVacio(espe_ccod) then
  		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "carr_ccod ='"&carr_ccod&"'"
		f_busqueda.AgregaCampoCons "espe_ccod", espe_ccod 
	end if
	
	if EsVacio(plan_ccod) then
		f_busqueda.Agregacampoparam "plan_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "plan_ccod", "filtro" , "espe_ccod ='"&espe_ccod&"'"
		f_busqueda.AgregaCampoCons "plan_ccod", plan_ccod 
	end if

	
		
	if carr_ccod<>"" then
		f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
	end if
		

 f_busqueda.Siguiente
'----------------------------------------------------------------------------------------------------------------




set fAsignaturas = new cFormulario
'fbusqueda.carga_parametros "parametros.xml", "2"
'fbusqueda.inicializar conectar
fAsignaturas.carga_parametros "parametros.xml", "3"
fAsignaturas.inicializar conectar

peri =negocio.ObtenerPeriodoAcademico("PLANIFICACION")


carreras = negocio.obtenerCarreras
if plan="" then 
	plan="0"
end if

'if inacap.obtenerRol = "JC" then
'	consulta = "select  '" & carrera &"' as carr_ccod,'" & especialidad &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod" 
'end if			

'fbusqueda.consultar consulta
'response.End()
'consulta = "SELECT a.carr_ccod, b.espe_ccod, c.plan_ccod, a.carr_tdesc, " & _
'	"		   b.espe_tdesc, c.plan_ncorrelativo " & _
'	"	  FROM carreras a, especialidades b, planes_estudio c, ofertas_academicas d " &  _
'	"	 WHERE a.carr_ccod = b.carr_ccod "   & _
'	"	   AND b.espe_ccod = c.espe_ccod "   & _
'	"	   and b.espe_ccod = d.espe_ccod "   & _
'	"	   and cast(d.peri_ccod as varchar)= '" & peri &"' "  & _
'	"	   and cast(d.sede_ccod as varchar)= '"&sede&"' "  & _
 '	"	 "

'fbusqueda.inicializaListaDependiente "lBusqueda", consulta

'fbusqueda.siguiente

if carrera <> "" and nivel <> "" then
	filtro = " cast(nive_ccod as varchar)='" & nivel & "' and b.plan_ccod=isnull(" & plan & ",0)"  
else
	filtro = " 1=2 "
end if
consulta = " select " & sede & vbCrLf & _
 " as sede_ccod, b.asig_ccod, asig_tdesc " & vbCrLf & _
 "  , a.carr_ccod, " & peri & " as periodo ,a.nive_ccod ,a.plan_ccod,a.espe_ccod " & vbCrLf & _
 "   , count(distinct secc_ccod) as nro_secciones " & vbCrLf & _
 "  , isnull(sum(secc_nquorum),0) as minimo " & vbCrLf & _
 "  , isnull(sum(secc_ncupo),0) as cupo  " & vbCrLf & _
 " from " & vbCrLf & _
 "  (  " & vbCrLf & _
 "    select distinct a.asig_ccod, c.carr_ccod,a.nive_ccod,b.plan_ccod,c.espe_ccod  " & vbCrLf & _
 "      from  " & vbCrLf & _
 "          malla_curricular a " & vbCrLf & _
 "         , planes_estudio b " & vbCrLf & _
 "         , especialidades c " & vbCrLf & _
 "      where " & vbCrLf & _
 "        a.plan_ccod=b.plan_ccod " & vbCrLf & _
 "          and b.espe_ccod=c.espe_ccod " & vbCrLf & _
 "          and " & filtro & vbCrLf & _
 "   ) a " & vbCrLf & _
 "   , asignaturas b, secciones c " & vbCrLf & _
 "  where " & vbCrLf & _
 "    a.asig_ccod=b.asig_ccod " & vbCrLf & _
 "    and a.asig_ccod *= c.asig_ccod " & vbCrLf & _
 "    and sede_ccod = " & sede & vbCrLf & _
 "    and peri_ccod = " & peri & vbCrLf & _
 "  group by sede_ccod, b.asig_ccod, asig_tdesc,a.carr_ccod,a.nive_ccod,a.plan_ccod,a.espe_ccod " & vbCrLf & _
 "    , a.carr_ccod " & vbCrLf

fAsignaturas.consultar consulta

 n_asig  = conectar.consultauno(" select count(*) " & _
		" from malla_curricular a" & _
		" where cast(a.plan_ccod as varchar)= '"&plan&"'")


consulta = "SELECT espe_ccod, espe_tdesc, carr_ccod  FROM especialidades"
conectar.Ejecuta consulta
set rec_especialidades = conectar.ObtenerRS

consulta2= "Select plan_ccod,plan_tdesc,espe_ccod from planes_estudio"
conectar.Ejecuta consulta2
set rec_planes=conectar.ObtenerRS

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
function elim_asig(formulario){
	mensaje="eliminar Asignaturas";
	if (verifica_check(formulario,mensaje)) {
		formulario.method="post"
		formulario.action = 'eliminar_asig_plan.asp';
		formulario.submit();
	}
}

function enviar(formulario){
formulario.submit();
}
function agrega_asig(formulario){

	direccion="agregar_asig.asp?carr="+formulario.carr.value+"&plan="+formulario.plan.value+"&espe="+formulario.espe.value;
	resultado=window.open(direccion, "ventana1","width=700,height=550,scrollbars=yes, left=0, top=0");
}


arr_especialidades = new Array();
arr_planes =new Array();

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

<%
rec_planes.MoveFirst
j = 0
while not rec_planes.Eof
%>
arr_planes[<%=j%>] = new Array();
arr_planes[<%=j%>]["plan_ccod"] = '<%=rec_planes("plan_ccod")%>';
arr_planes[<%=j%>]["plan_tdesc"] = '<%=rec_planes("plan_tdesc")%>';
arr_planes[<%=j%>]["espe_ccod"] = '<%=rec_planes("espe_ccod")%>';
<%	
	rec_planes.MoveNext
	j = j + 1
wend
%>

function CargarEspecialidades(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][espe_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Especialidad";
	formulario.elements["busqueda[0][espe_ccod]"].add(op)
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["busqueda[0][espe_ccod]"].add(op)			
		 }
	}	
}

function CargarPlanes(formulario, espe_ccod)
{
	formulario.elements["busqueda[0][plan_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Plan";
	formulario.elements["busqueda[0][plan_ccod]"].add(op)
	for (j = 0; j < arr_planes.length; j++)
	  { 
		if (arr_planes[j]["espe_ccod"] == espe_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_planes[j]["plan_ccod"];
			op.text = arr_planes[j]["plan_tdesc"];
			formulario.elements["busqueda[0][plan_ccod]"].add(op)			
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
}




</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
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
              <br>
                <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td><div align="left">Carrera</div></td>
                                <td><div align="center">:</div></td>
                                <td>
                                  <% f_busqueda.dibujaCampo ("carr_ccod") %>
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%"><div align="left">Especialidad</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="81%"><% f_busqueda.dibujaCampo ("espe_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="15%"><div align="left">Planes</div></td>
                                <td width="4%"><div align="center">:</div></td>
                                <td width="81%"><% f_busqueda.dibujaCampo ("plan_ccod") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%if carrera <> "" and especialidad  <> "" and plan <> "" then %>
                          <table width="627">
                            <tr> 
                              <td width="137" nowrap>Programa de Estudio</td>
                              <td width="478">:<strong><%=rcarrera%></strong></td>
                            </tr>
                            <tr> 
                              <td>Especilidad</td>
                              <td>:<strong><%=respecialidad%></strong></td>
                            </tr>
                            <tr> 
                              <td>Plan</td>
                              <td>:<strong><%=rplan%></strong></td>
                            </tr>
                          </table>
                          <%end if %><br><%pagina.DibujarSubtitulo "Asignaturas - Requisitos"%>
                      <br>
                      <table width="100%" border="0">
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td><div align="center">
                                <% 
	fo.dibujatabla()
%>
                          </div></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
						  	  <input name="n_asig" type="hidden" value="<%=n_asig%>">
						      <input name="carr" type="hidden" value="<%=rcarrera%>">
							  <input name="espe" type="hidden" value="<%=respecialidad%>">
							  <input name="planes2" type="hidden" value="<%=rplan%>">
							  
							   <input name="plan" type="hidden" value="<%=plan%>">
							  <input name="cod_carrera" type="hidden" value="<%=carr_ccod%>">
							  <input name="cod_planes" type="hidden" value="<%=plan_ccod%>">
							  <input name="cod_especialidad" type="hidden" value="<%=espe_ccod%>">

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
                    <%botonera.dibujaboton "AGREGAR"%>
                  </div></td>
                  <td><div align="center">
                    <%botonera.dibujaboton "ELIMINAR"%>
                  </div></td>
				  <td><div align="center">  
				    <%botonera.agregabotonparam "excel", "url", "listado_mallas_excel.asp"
					  botonera.dibujaboton "excel"%>
				  </div></td>
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
