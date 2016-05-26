<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=Resultado_comparador.xls"
Response.ContentType = "application/vnd.ms-excel"

ufco_ttabla=request.Form("a[0][ufco_tdescripcion]")
carrera=request.Form("a[0][carrera]")
carrera2=request.Form("_a[0][carrera]")
periodo_solo=request.Form("a[0][peri_solo]")
periodo_desde=request.Form("a[0][desde]")
periodo_hasta=request.Form("a[0][hasta]")
if carrera="" then
carrera=carrera2
end if



'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

usu=negocio.obtenerUsuario	
 

ufco_tctabla=conexion.ConsultaUno("select  ufco_tctabla from ufe_comparador where ufco_ttabla='"&ufco_ttabla&"'")

'response.Write("ufco_ttabla= "&ufco_ttabla&"<br>")
'response.Write("carrera= "&carrera&"<br>")
'response.Write("ufco_tctabla= "&ufco_tctabla&"<br>")
'response.Write("periodo_solo= "&periodo_solo&"<br>")



sql="select "&ufco_tctabla&" , b.PERIODO_ACA,b.AP_MATERNO,b.AP_PATERNO,b.CARRERA,b.CIUDAD_PARTICULAR,b.COD_CARRERA,b.CONDICION,b.DIRE_PARTICULAR,b.EDAD,b.EMAIL, b.email_upa, b.ESPECIALIDAD,b.ESTADO_ACADEMICO,b.FECHA_MATRICULA,b.FECHA_MODIFICACION,b.FECHA_NACIMIENTO,b.JORNADA,b.NOMBRE,b.OBSERVACION,b.PAIS,b.REGION_PARTICULAR,b.SEDE,b.SEXO,b.COMUNA_PARTICULAR,b.TELEFONO_PARTICULAR, cast(b.ARAN_MCOLEGIATURA as numeric), cast (b.ARAN_MMATRICULA as numeric)"

' Aca contruimos el sql con los campos fijos del Formulario
'if carrera=1 then
'sql=sql&",b.carrera"
'end if

sql=sql&" from "&ufco_ttabla&" as a, MATRICULAS_TOTALES_UFE as b where cast(a.rut as varchar)=cast(b.pers_nrut as varchar)"

'response.Write(sql)
'response.End()

if periodo_solo<>""  then
sql=sql&" and b.periodo_aca="&periodo_solo&""
elseif  periodo_desde<>"" and periodo_hasta<>"" then
sql=sql&" and b.periodo_aca between "&periodo_desde&" and "&periodo_hasta&""
end if

'response.Write("sql= "&sql&"<br>")
'response.end()

'-------------------------------------------------------------------------------
contador=0
arr_camposExcel=split(ufco_tctabla,",")
'response.Write(Ubound(arr_camposExcel))
'while contador< Ubound(arr_camposExcel)
'
'response.Write("<br>"&replace(arr_camposExcel(contador),"a.",""))
'contador=contador+1
'wend
'response.End()



set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql		
'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title></head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr>
 <% while contador=< Ubound(arr_camposExcel)%>
 
    <td width="28%"><div align="center"><strong><%=replace(UCASE(arr_camposExcel(contador)),"A.","")%> </strong></div></td>
    
  <%
  contador=contador+1
  wend%>
  
    
	 <td width="28%"><div align="center"><strong>NOMBRE</strong></div></td>
     <td width="28%"><div align="center"><strong>AP_MATERNO</strong></div></td>
     <td width="28%"><div align="center"><strong>AP_PATERNO</strong></div></td>
	 <td width="28%"><div align="center"><strong>EDAD</strong></div></td>
	 <td width="28%"><div align="center"><strong>SEXO</strong></div></td>
	 <td width="28%"><div align="center"><strong>DIRE_PARTICULAR</strong></div></td>
     <td width="28%"><div align="center"><strong>CIUDAD_PARTICULAR</strong></div></td>
	  <td width="28%"><div align="center"><strong>REGION_PARTICULAR</strong></div></td>
      <td width="28%"><div align="center"><strong>COMUNA_PARTICULAR</strong></div></td>
	   <td width="28%"><div align="center"><strong>TELEFONO_PARTICULAR</strong></div></td>
       <td width="28%"><div align="center"><strong>EMAIL_UPA</strong></div></td>
	  <td width="28%"><div align="center"><strong>EMAIL</strong></div></td>
	  <td width="28%"><div align="center"><strong>PERIODO_ACA</strong></div></td>
	  	 <td width="28%"><div align="center"><strong>SEDE</strong></div></td>
		<!-- <td width="28%"><div align="center"><strong>SEDE_INGRESA</strong></div></td>
		 <td width="28%"><div align="center"><strong>SEDE_MINEDUC</strong></div></td>-->
	 <td width="28%"><div align="center"><strong>CARRERA</strong></div></td>
	  <td width="28%"><div align="center"><strong>JORNADA</strong></div></td>
     <td width="28%"><div align="center"><strong>COD_CARRERA</strong></div></td>
	 <!--<td width="28%"><div align="center"><strong>COD_CARRERA_MINEDUC</strong></div></td>
	  <td width="28%"><div align="center"><strong>COD_CARRERA_INGRESA</strong></div></td>-->
     <td width="28%"><div align="center"><strong>ESPECIALIDAD</strong></div></td>
	  <td width="28%"><div align="center"><strong>CONDICION</strong></div></td>
     <td width="28%"><div align="center"><strong>ESTADO_ACADEMICO</strong></div></td>
     <td width="28%"><div align="center"><strong>FECHA_MATRICULA</strong></div></td>
     <td width="28%"><div align="center"><strong>FECHA_MODIFICACION</strong></div></td>
     <td width="28%"><div align="center"><strong>FECHA_NACIMIENTO</strong></div></td>
     <td width="28%"><div align="center"><strong>OBSERVACION</strong></div></td>
     <td width="28%"><div align="center"><strong>PAIS</strong></div></td>
     
    
     <!-- <td width="28%"><div align="center"><strong>MONTO_ARANCEL</strong></div></td>
     <td width="28%"><div align="center"><strong>MONTO_MATRICULA</strong></div></td>-->
  </tr>
  <%while f_valor_documentos.Siguiente
  contador=0%>
  <tr>
  <% while contador=< Ubound(arr_camposExcel)%>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor(replace(arr_camposExcel(contador),"a.",""))%></div></td>
    <%
  contador=contador+1
  wend%>
        
		 <td><div align="left"><%=f_valor_documentos.ObtenerValor("NOMBRE")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("AP_MATERNO")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("AP_PATERNO")%></div></td>
		  <td><div align="left"><%=f_valor_documentos.ObtenerValor("EDAD")%></div></td>
		  <td><div align="left"><%=f_valor_documentos.ObtenerValor("SEXO")%></div></td>
		  <td><div align="left"><%=f_valor_documentos.ObtenerValor("DIRE_PARTICULAR")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("CIUDAD_PARTICULAR")%></div></td>
		 <td><div align="left"><%=f_valor_documentos.ObtenerValor("REGION_PARTICULAR")%></div></td>
          <td><div align="left"><%=f_valor_documentos.ObtenerValor("COMUNA_PARTICULAR")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("TELEFONO_PARTICULAR")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("EMAIL_upa")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("EMAIL")%></div></td>
		 <td><div align="left"><%=f_valor_documentos.ObtenerValor("PERIODO_ACA")%></div></td>
		 <td><div align="left"><%=f_valor_documentos.ObtenerValor("SEDE")%></div></td>
		 <!--<td><div align="left"><%'=f_valor_documentos.ObtenerValor("sede_ingr")%></div></td>
		 <td><div align="left"><%'=f_valor_documentos.ObtenerValor("sede_mineduc")%></div></td>-->
		 <td><div align="left"><%=f_valor_documentos.ObtenerValor("CARRERA")%></div></td>
		 <td><div align="left"><%=f_valor_documentos.ObtenerValor("JORNADA")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("COD_CARRERA")%></div></td>
		<!-- <td><div align="left"><%'=f_valor_documentos.ObtenerValor("car_min_ncorr")%></div></td>
		 <td><div align="left"><%'=f_valor_documentos.ObtenerValor("car_ing_ncorr")%></div></td>-->
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("ESPECIALIDAD")%></div></td>
		  <td><div align="left"><%=f_valor_documentos.ObtenerValor("CONDICION")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("ESTADO_ACADEMICO")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("FECHA_MATRICULA")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("FECHA_MODIFICACION")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("FECHA_NACIMIENTO")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("OBSERVACION")%></div></td>
         <td><div align="left"><%=f_valor_documentos.ObtenerValor("PAIS")%></div></td>
         
          <!--<td><div align="left"><%'=f_valor_documentos.ObtenerValor("ARAN_MCOLEGIATURA")%></div></td>
         <td><div align="left"><%'=f_valor_documentos.ObtenerValor("ARAN_MMATRICULA")%></div></td>-->
   </tr>
  <%wend%>
</table>
</html>