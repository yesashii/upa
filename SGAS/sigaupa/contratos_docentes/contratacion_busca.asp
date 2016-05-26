<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				      :	
'FECHA CREACIÓN			      :
'CREADO POR					      :
'ENTRADA					        : NA
'SALIDA						        : NA
'MODULO QUE ES UTILIZADO	: CONTRATOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 01/03/2013 - posterior actualizacion 18/04/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO						      : Corregir código, eliminar sentencia *=, =*
'LINEA						      : 71, 72, 76
'********************************************************************
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
botonera.Carga_Parametros "contratos_docentes.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod 	= 	Request.QueryString("busqueda[0][carr_ccod]")
sede_ccod 	= 	Request.QueryString("busqueda[0][sede_ccod]")
jorn_ccod 	= 	Request.QueryString("busqueda[0][jorn_ccod]")
'-----------------------------------------------------------------------
if ESVACIO(sede_ccod) then
	sede_ccod = negocio.obtenersede
end if

sql_ano_primer_sem= " select b.anos_ccod from periodos_academicos a,periodos_academicos b  "& vbCrLf & _
				" where a.anos_ccod=b.anos_ccod "& vbCrLf & _
				" and a.peri_ccod="&v_peri_ccod&" "& vbCrLf & _
				" --and b.plec_ccod=1 "

anio_sem = conexion.consultaUno(sql_ano_primer_sem)
'anio_sem=2009
set formulario = new cformulario
formulario.carga_parametros "contratos_docentes.xml", "filtro_docentes2"
formulario.inicializar conexion 'conectar



consulta = ""
consulta = consulta & "select distinct e.tcdo_ccod                                               as " & vbCrLf
consulta = consulta & "                tipo_contrato, " & vbCrLf
consulta = consulta & "                e.tcdo_ccod, " & vbCrLf
consulta = consulta & "                e.cdoc_ncorr, " & vbCrLf
consulta = consulta & "                b.sede_ccod, " & vbCrLf
consulta = consulta & "                b.carr_ccod, " & vbCrLf
consulta = consulta & "                b.jorn_ccod, " & vbCrLf
consulta = consulta & "                a.pers_ncorr, " & vbCrLf
consulta = consulta & "                protic.obtener_rut(a.pers_ncorr)                          as rut " & vbCrLf
consulta = consulta & "                , " & vbCrLf
consulta = consulta & "                max(d.tcat_valor) " & vbCrLf
consulta = consulta & "                as categoria, " & vbCrLf
consulta = consulta & "                (select tcat_valor " & vbCrLf
consulta = consulta & "                 from   tipos_categoria " & vbCrLf
consulta = consulta & "                 where  tcat_ccod = " & vbCrLf
consulta = consulta & "                        protic.obtiene_categoria_carrera(a.pers_ncorr, " & vbCrLf
consulta = consulta & "                        '"&sede_ccod&"', " & vbCrLf
consulta = consulta & "                                            '"& carr_ccod &"', '"&jorn_ccod&"', " & vbCrLf
consulta = consulta & "                                '"&v_peri_ccod&"', 0))        as valor_categoria " & vbCrLf
consulta = consulta & "                , " & vbCrLf
consulta = consulta & "                protic.obtener_nombre_completo(a.pers_ncorr, " & vbCrLf
consulta = consulta & "                'a')         as nom, " & vbCrLf
consulta = consulta & "                protic.anexos_pendientes(a.pers_ncorr, '"& carr_ccod &"') as " & vbCrLf
consulta = consulta & "                pendientes, " & vbCrLf
consulta = consulta & "                protic.anexos_pendientes(a.pers_ncorr, '"& carr_ccod &"') as " & vbCrLf
consulta = consulta & "                calcular, " & vbCrLf
consulta = consulta & "                --protic.anexos_nuevos(a.pers_ncorr,2012) as anexos_nuevos ,    " & vbCrLf
consulta = consulta & "                protic.anexos_nuevos_escuela(a.pers_ncorr, '"& carr_ccod &"', " & vbCrLf
consulta = consulta & "                '" & sede_ccod & "', '" & jorn_ccod & "', "&anio_sem&")   as " & vbCrLf
consulta = consulta & "                anexos_nuevos_escuela, " & vbCrLf
consulta = consulta & "                protic.anexos_nuevos(a.pers_ncorr, "&anio_sem&")          as " & vbCrLf
consulta = consulta & "                anexos_creados, " & vbCrLf
consulta = consulta & "                protic.maxima_duracion_asignatura(a.pers_ncorr)           as " & vbCrLf
consulta = consulta & "                duracion_asignatura " & vbCrLf
consulta = consulta & "from   personas a " & vbCrLf
consulta = consulta & "       join carreras_docente as b " & vbCrLf
consulta = consulta & "         on a.pers_ncorr = b.pers_ncorr " & vbCrLf
consulta = consulta & "            and cast(b.carr_ccod as varchar) = '" & carr_ccod & "' " & vbCrLf
consulta = consulta & "            and cast(b.jorn_ccod as varchar) = '" & jorn_ccod & "' " & vbCrLf
consulta = consulta & "            and cast(b.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrLf
consulta = consulta & "       left outer join bloques_profesores as c " & vbCrLf
consulta = consulta & "                    on b.pers_ncorr = c.pers_ncorr " & vbCrLf
consulta = consulta & "       left outer join tipos_categoria as d " & vbCrLf
consulta = consulta & "                    on b.tcat_ccod = d.tcat_ccod " & vbCrLf
consulta = consulta & "       left outer join contratos_docentes_upa as e " & vbCrLf
consulta = consulta & "                    on a.pers_ncorr = e.pers_ncorr " & vbCrLf
consulta = consulta & "                       and e.ano_contrato = "&anio_sem&" " & vbCrLf
consulta = consulta & "                       and e.ecdo_ccod = 1 " & vbCrLf
consulta = consulta & "       join periodos_academicos f " & vbCrLf
consulta = consulta & "         on b.peri_ccod = f.peri_ccod " & vbCrLf
consulta = consulta & "            and f.anos_ccod = "&anio_sem&" " & vbCrLf
consulta = consulta & "group  by a.pers_ncorr, " & vbCrLf
consulta = consulta & "          b.sede_ccod, " & vbCrLf
consulta = consulta & "          b.carr_ccod, " & vbCrLf
consulta = consulta & "          b.jorn_ccod, " & vbCrLf
consulta = consulta & "          e.cdoc_ncorr, " & vbCrLf
consulta = consulta & "          e.tcdo_ccod " & vbCrLf
consulta = consulta & "order  by nom "
'-----------------------------------------------------------------------------------------------------------------NUEVA ACTUALIZACIÓN 18/04/2013

'response.Write("<pre>"&consulta&"</pre>")
formulario.consultar consulta


 
''#############################################################33

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
                    		 " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"'" & vbCrLf &_ 
                    		 " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
							 " and b.carr_ccod=c.carr_ccod" & vbCrLf &_
							" order by carr_tdesc desc "
							
							
		 consulta_carreras = "Select distinct c.carr_ccod,c.carr_tdesc" & vbCrLf &_ 
         			         " from ofertas_academicas a, especialidades b,carreras c" & vbCrLf &_ 
					  		 " where cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		 " and  cast(a.peri_ccod as varchar) in (select a.peri_ccod " & vbCrLf &_
                    		 "            from periodos_academicos a , periodos_academicos b "& vbCrLf &_
                    		 "            where a.anos_ccod=b.anos_ccod " & vbCrLf &_
                    		 "            and b.peri_ccod='"&v_peri_ccod&"')"  & vbCrLf &_
                    		 " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
							 " and b.carr_ccod=c.carr_ccod" & vbCrLf &_
							 " order by carr_tdesc desc "	
																						
		f_carreras.Consultar consulta_carreras
		'response.Write(consulta_carreras)
' " and a.post_bnuevo='S'" & vbCrLf &_ 		

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
 if carr_ccod<>"" and carr_ccod<>"-1" then
'response.Write(".")
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
							
				consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod" & vbCrLf &_  
							" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                		    " where cast(b.carr_ccod as varchar)='"&carr_ccod&"'" & vbCrLf &_ 
                    		" and b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    		" and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    		" and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    		" and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf &_ 
                    		" and  cast(a.peri_ccod as varchar) in (select a.peri_ccod " & vbCrLf &_
                    		"            from periodos_academicos a , periodos_academicos b "& vbCrLf &_
                    		"            where a.anos_ccod=b.anos_ccod " & vbCrLf &_
                    		"            and b.peri_ccod='"&v_peri_ccod&"')"  
							
												
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
f_busqueda.Carga_Parametros "contratos_docentes.xml", "busqueda2"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "Select ''"


'--------------------------------------------agregamos filtros a los select que mostraran la sede, asignatura, jornada
 if cad_sedes<>"" then
 	   f_busqueda.Agregacampoparam "sede_ccod", "filtro" , "sede_ccod in ("&cad_sedes&")"
	   'response.Write("sede_ccod in ("&cad_sedes&")")
 end if
 f_busqueda.AgregaCampoCons "tdet_ccod", tdet_ccod 
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.AgregaCampoCons "jorn_ccod", jorn_ccod
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
					" where cast(a.peri_ccod as varchar) in (select a.peri_ccod " & vbCrLf &_
                    "                                            from periodos_academicos a , periodos_academicos b "& vbCrLf &_
                    "                                            where a.anos_ccod=b.anos_ccod " & vbCrLf &_
                    "                                            and b.peri_ccod='"&v_peri_ccod&"')" & vbCrLf &_ 
                    " and a.espe_ccod=b.espe_ccod" & vbCrLf &_
                    " and b.carr_ccod=c.carr_ccod order by c.carr_tdesc " 
					
'" AND a.post_bnuevo='S'" & vbCrLf &_ 					
conexion.Ejecuta consulta_carreras
set rec_carreras = conexion.ObtenerRS

' ##########################################	JORNADAS   ##########################################
consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod,b.carr_ccod" & vbCrLf &_  
					" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                    " where b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    " and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    " and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' order by d.jorn_tdesc "
					
consulta_jornadas = "select distinct d.jorn_tdesc,d.jorn_ccod,b.carr_ccod" & vbCrLf &_  
					" from ofertas_academicas a, carreras b,especialidades c, jornadas d " & vbCrLf &_ 
                    " where b.carr_ccod=c.carr_ccod" & vbCrLf &_ 
                    " and c.espe_ccod=a.espe_ccod" & vbCrLf &_ 
                    " and a.jorn_ccod=d.jorn_ccod" & vbCrLf &_ 
                    " and cast(a.peri_ccod as varchar) in (select a.peri_ccod " & vbCrLf &_
                    "                                            from periodos_academicos a , periodos_academicos b "& vbCrLf &_
                    "                                            where a.anos_ccod=b.anos_ccod " & vbCrLf &_
                    "                                            and b.peri_ccod='"&v_peri_ccod&"')" & vbCrLf &_ 
					"  order by d.jorn_tdesc "

					
'response.Write(consulta_jornadas)
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

function ValidaBusqueda(){
	 
	valor_carrera=buscador.elements["busqueda[0][carr_ccod]"].value;
	valor_jornada=buscador.elements["busqueda[0][jorn_ccod]"].value;

	if(valor_carrera < 0){
		alert("Debe seleccionar una Carrera");
		
	}else if(valor_jornada < 0){
		alert("Debe seleccionar una Jornada");
	}else{
		return true;
	}
	
}

function Validar_Calculo(form){
mensaje="Calcular";
	if (verifica_check(form,mensaje)){
		return true;
	}
	
	return false;
}

function Validar_Impresion(form){
mensaje="Imprimir";
//alert(mensaje);


 nro = form.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')&&(comp.value != 1)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
	     num += 1;
		 //alert("indice chekeado:"+indice);
		 v_pers_ncorr=form.elements["m["+indice+"][pers_ncorr]"].value;
		 v_cdoc_ncorr=form.elements["m["+indice+"][cdoc_ncorr]"].value;
		 v_tcdo_ccod=form.elements["m["+indice+"][tcdo_ccod]"].value;

		v_indefinido="SI";		 
		 if(v_tcdo_ccod==1){
		 	v_indefinido="NO";
		 }

		 if(v_tcdo_ccod==2){
		 	v_indefinido="SI";
		 }

		 if(v_tcdo_ccod==3){
		 	v_indefinido="PF";
		 }

		 if(v_cdoc_ncorr){
		 	window.open("../REPORTESNET/imprimir_anexos.aspx?pers_ncorr="+v_pers_ncorr+"&cdoc_ncorr="+v_cdoc_ncorr+"&indefinido="+v_indefinido);
		 }else{
		 	alert("Aun no existe un contrato creado para el docente seleccionado");
		 }
	  }
   }
   if( num == 0 ) {

      alert('Ud. no ha seleccionado ningún registro para Imprimir');

   }	


}

function apaga_check(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if((comp.type == 'checkbox')&&(str!='indefinido')){
	     num += 1;
		 v_indice=extrae_indice(str);
//alert(str);
		 v_estado=document.edicion.elements["m["+v_indice+"][tcdo_ccod]"].value;
		 if (v_estado){
		 	document.edicion.elements["m["+v_indice+"][tipo_contrato]"].disabled=true;
			//document.edicion.elements["boleta["+v_indice+"][ebol_ccod]"].disabled=true;
			//document.edicion.elements["boleta["+v_indice+"][bole_nboleta]"].disabled=true;
		 }
	  }
   }
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="apaga_check();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="99%"   cellspacing="0" cellpadding="0"  >
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
