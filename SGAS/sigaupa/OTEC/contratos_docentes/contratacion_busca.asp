<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Contratacion de Docentes"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("Planificacion")

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "contratos_docentes_otec.xml", "botonera"

'-----------------------------------------------------------------------
v_dcur_ncorr 	= 	Request.QueryString("busqueda[0][dcur_ncorr]")
v_sede_ccod 	= 	Request.QueryString("busqueda[0][sede_ccod]")
v_anos_ccod     = 	Request.QueryString("busqueda[0][anio_admision]")
'-----------------------------------------------------------------------
'v_dcur_ncorr =21
set formulario = new cformulario
formulario.carga_parametros "contratos_docentes_otec.xml", "filtro_docentes2"
formulario.inicializar conexion 

 
if v_sede_ccod <> "" then
filtro="and sede_ccod="&v_sede_ccod&""
end if

if v_dcur_ncorr = "" then
v_dcur_ncorr=0
end if

if v_anos_ccod="" then
anos=conexion.consultaUno("select datepart(year,getdate())")
v_anos_ccod=anos
end if




consulta="Select rp.pers_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, sede_ccod,dc.dcur_ncorr,dcur_tdesc,"&v_anos_ccod&" as anos_ccod,"& vbcrlf & _

"cast((select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee where aaa.bhot_ccod=bbb.bhot_ccod "& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and datepart(year,ddd.dgso_finicio)="&v_anos_ccod&""& vbcrlf & _
"and aaa.anot_ncorr is null)as numeric)as  pendientes,"& vbcrlf & _

"cast((select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee where aaa.bhot_ccod=bbb.bhot_ccod "& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and datepart(year,ddd.dgso_finicio)="&v_anos_ccod&""& vbcrlf & _
"and aaa.anot_ncorr is null)as numeric)as  pendie,"& vbcrlf & _

"(select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee"& vbcrlf & _
"where aaa.bhot_ccod=bbb.bhot_ccod"& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and datepart(year,ddd.dgso_finicio)="&v_anos_ccod&""& vbcrlf & _
"and aaa.anot_ncorr is not null)as anexos_creados,"& vbcrlf & _
"(select count(distinct bbb.seot_ncorr) from bloques_relatores_otec aaa,bloques_horarios_otec bbb,secciones_otec ccc,datos_generales_secciones_otec ddd,diplomados_cursos eee"& vbcrlf & _
"where aaa.bhot_ccod=bbb.bhot_ccod"& vbcrlf & _
"and bbb.seot_ncorr=ccc.seot_ncorr"& vbcrlf & _
"and ccc.dgso_ncorr=ddd.dgso_ncorr"& vbcrlf & _
"and ddd.dcur_ncorr=eee.dcur_ncorr"& vbcrlf & _
"and eee.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and aaa.pers_ncorr=p.pers_ncorr"& vbcrlf & _
"and datepart(year,ddd.dgso_finicio)="&v_anos_ccod&""& vbcrlf & _
"and aaa.anot_ncorr is not null)as anexos_creadosz"& vbcrlf & _
",+'$--'as valor_categoria,(select cdot_ncorr from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1   and cast(ano_contrato as varchar)='"&v_anos_ccod&"')as cdot_ncorr ,(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1   and cast(ano_contrato as varchar)='"&v_anos_ccod&"')as tcdo_ccod,  "& vbcrlf & _
"(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1  and cast(ano_contrato as varchar)='"&v_anos_ccod&"')as z_tcdo_ccod  "& vbcrlf & _
",protic.tiene_todos_los_valores_hora(dc.dcur_ncorr,p.pers_ncorr) as valores_hora"& vbcrlf & _
"from relatores_programa rp,diplomados_cursos dc,datos_generales_secciones_otec dgot,personas p"& vbcrlf & _
"where rp.dgso_ncorr =dgot.dgso_ncorr"& vbcrlf & _
"and dgot.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and cast(datepart(year,dgot.dgso_finicio)as varchar)='"&v_anos_ccod&"'"& vbcrlf & _
""&filtro& vbCrLf &_
"and dc.dcur_ncorr="&v_dcur_ncorr&""& vbCrLf &_
"and rp.pers_ncorr=p.pers_ncorr"& vbCrLf &_
"order by nombre"  



'response.Write("<pre>"&consulta&"</pre>")

'"Select rp.pers_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, sede_ccod,dc.dcur_ncorr,dcur_tdesc,"& vbcrlf & _
'"cast((select count(pers_ncorr) from bloques_relatores_otec a where a.pers_ncorr=rp.pers_ncorr and anot_ncorr is null) as numeric)as  pendientes,"& vbcrlf & _
'"(select count(pers_ncorr) from bloques_relatores_otec a where a.pers_ncorr=rp.pers_ncorr and anot_ncorr is not null)as anexos_creados,+'$ '+cast( (select top 1 ceiling((MAOT_NPRESUPUESTO_RELATOR/seot_ncantidad_relator)/maot_nhoras_programa)  from mallas_otec a,secciones_otec b,bloques_relatores_otec bro,bloques_horarios_otec bht where a.maot_ncorr=b.maot_ncorr and b.dgso_ncorr=dgot.dgso_ncorr and a.dcur_ncorr=dc.dcur_ncorr and pers_ncorr=p.pers_ncorr and bro.bhot_ccod=bht.bhot_ccod and bht.seot_ncorr=b.seot_ncorr)as varchar)as valor_categoria,(select cdot_ncorr from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr and ecdo_ccod=1)as cdot_ncorr ,(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr)as tcdo_ccod,  "& vbcrlf & _
'"(select tcdo_ccod from contratos_docentes_otec cdo where cdo.pers_ncorr=rp.pers_ncorr)as z_tcdo_ccod  "& vbcrlf & _
'"from relatores_programa rp,diplomados_cursos dc,datos_generales_secciones_otec dgot,personas p,tipos_categoria tc"& vbcrlf & _
'"where rp.dgso_ncorr =dgot.dgso_ncorr"& vbcrlf & _
'"and dgot.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
'"and rp.tcat_ccod=tc.tcat_ccod"& vbcrlf & _
'" "&filtro& vbCrLf &_
'"and dc.dcur_ncorr="&v_dcur_ncorr&""& vbCrLf &_
'"and rp.pers_ncorr=p.pers_ncorr"& vbCrLf &_
'"order by nombre"


'response.Write("<pre>"&consulta&"</pre>")
'response.End()
formulario.consultar consulta


 

'set f_busqueda = new CFormulario
'f_busqueda.Carga_Parametros "contratos_docentes_otec.xml", "busqueda2"
'f_busqueda.Inicializar conexion
'f_busqueda.Consultar " select ''"
'
'f_busqueda.Siguiente
''response.End()
' f_busqueda.AgregaCampoCons "dcur_ncorr", v_dcur_ncorr
'  f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
'  f_busqueda.AgregaCampoCons "anos_ccod", v_anos_ccod
  
  
   set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "contratos_docentes_otec.xml", "f_busqueda_"
 
 f_busqueda.Inicializar conexion
 
 consulta = "Select '"&v_anos_ccod&"' as anio_admision, '"&v_sede_ccod&"' as sede_ccod, '"&v_dcur_ncorr&"' as dcur_ncorr "
 f_busqueda.consultar consulta
' se quita la restricción de no poder contratar para programas cerrados, según solicitud de Guillermo Araya el 22-08-2013
' ----------------------------------------Marcelo Sandoval
 consulta = " select anio_admision,c.sede_ccod,c.sede_tdesc, b.dcur_ncorr,b.dcur_tdesc " & vbCrlf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrlf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrlf & _
			" and a.sede_ccod=c.sede_ccod  " & vbCrlf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and a.dcur_ncorr not in (5,35) " & vbCrlf & _
			" order by anio_admision desc,c.sede_tdesc asc, b.dcur_tdesc asc " 
	'response.Write("<pre>"&consulta&"</pre>")		
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente
'---------------------------modificaciones nuevos filtros-------------------------------------------------

if (v_dcur_ncorr <> 0 ) then

sql_existe="select count(*) as existe"& vbCrlf & _ 
			"from diplomados_cursos d,tipos_Detalle t"& vbCrlf & _
			"where d.TDET_CCOD = t.TDET_CCOD"& vbCrlf & _
			"and d.DCUR_NCORR =" &v_dcur_ncorr&""
	existe =  conexion.ConsultaUno(sql_existe)

sql_contar=" select dcur_tdesc as nombre from diplomados_cursos"& vbCrlf & _
			"where DCUR_NCORR =" &v_dcur_ncorr&""
	nombrecarrera =  conexion.ConsultaUno(sql_contar)

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
var dcur_ncorrM = <%=v_dcur_ncorr%> 

function Validar_Impresion(form){
mensaje="Imprimir";
//alert(dcur_ncorrM);


 nro = form.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')&&(comp.value != 1)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
		//alert(num);
	     num += 1;
		 //alert(num);
		 //alert("indice chekeado:"+indice);
		 v_pers_ncorr=form.elements["m["+indice+"][pers_ncorr]"].value;
		 v_cdot_ncorr=form.elements["m["+indice+"][cdot_ncorr]"].value;
		 v_tcdo_ccod=form.elements["m["+indice+"][z_tcdo_ccod]"].value;
		  //z_tcdo_ccod=<%=q_tcdo_ccod%>;
		 //v_tcdo_ccod=z_tcdo_ccod;
//alert(v_pers_ncorr);
//alert(v_cdot_ncorr);
//alert(v_tcdo_ccod);
		
		 if(v_cdot_ncorr){
		 	window.open("./contrato.asp?pers_ncorr="+v_pers_ncorr+"&cdot_ncorr="+v_cdot_ncorr+"&dcur_ncorr="+dcur_ncorrM+"&tcdo_ccod="+v_tcdo_ccod+"");
		 }else{
		 	alert("Aun no existe un contrato creado para el docente seleccionado");
		 }
	  }
   }
   if( num == 0 ) {

      alert('Ud. no ha seleccionado ningún registro para Imprimir');

   }	


}
function Validar_Calculo(form){
mensaje="Calcular";
	if (verifica_check(form,mensaje)){
		return true;
	}
	
	return false;
}


function apaga_check(){
   nro = document.edicion.elements.length;
   num =0;
   //alert(nro);
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'checkbox'){
	     num += 1;
		 //alert("str="+str);
		 //alert("comp="+comp.type);
		 v_indice=extrae_indice(comp.name);
		 //alert("indice:"+v_indice);
//		 v_estado=document.edicion.elements["m["+v_indice+"][anexos_creadosz]"].value;
		 //v_estado=form.elements["m["+v_indice+"][eane_ccod]"].value
		 //alert("estado:"+v_estado);
		 
//		 if (v_estado !="0"){
		 //alert("estado:"+v_estado);
//		 	document.edicion.elements["m["+v_indice+"][tcdo_ccod]"].disabled=true;
//		 }
	  }
   }
}

</script>
<% f_busqueda.generaJS %>
<style type="text/css">
body {
	background-color: #D8D8DE;
}
</style></head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad=apaga_check(); "MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">


<table width="650" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <td valign="top" bgcolor="#EAEAEA"><br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td width="581" height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="10" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td> <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
                
                <table width="98%"  border="0" align="center">
                 <tr>
                    <td width="20%"><strong>Año</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                  </tr>
				  <tr>
                    <td width="20%"><strong>Sede</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                  </tr>
				 <tr>
                    <td width="20%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr"%></td>
                 </tr>
                  <tr>
                    <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                  </tr>
                  <tr>
                    <td colspan="3"><table width="100%">
                        <tr>
                          
                          <td width="50%" align="right"><%botonera.dibujaboton "buscar"%></td>
                        </tr>
                    </table></td>
                  </tr>
                </table>
            </form></td>
          </tr>
        </table></td>
        <td width="10" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="10" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
    <br><br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="95%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <br> <%if carrera <> "" then%>
                    <table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=carrera%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></td>
  </tr>
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table> <%end if%>
                    <br>
                  </div>
				  <form name="edicion" method="">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td height="60" colspan="5"><div align="center"> 
                        <% if existe <> 1 and v_dcur_ncorr <> 0 then %>
                        	
                            	<h2 ALIGN=center><font color="red">El Modulo <%=nombrecarrera%>, No tiene un centro de costos</font></h2>
                                                    
                        <%end if%>
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%formulario.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>
                            <%formulario.dibujaTabla()%>
                          </div></td>
                        <td width="1"></td>
                      </tr>
                     
                    </table>
                          <br>
						  <!--<input type="checkbox" name="indefinido" value="1">Anexo Indefinido -->
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
                  <td><div align="center"><%botonera.DibujaBoton "calcular"%></div></td>
                  <td><div align="center"><%botonera.DibujaBoton "imprimir"%></div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
	
	</table>
</body>
</html>
