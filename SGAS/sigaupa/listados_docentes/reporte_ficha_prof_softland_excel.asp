<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_planificacion_general.txt"
Response.ContentType = "text/plain"
'Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
'carr_ccod = request.QueryString("busqueda[0][carr_ccod]")
'response.Write("carrera :" & carr_ccod)
'response.End()
set pagina = new CPagina
'pagina.Titulo = "Reporte Planificacion General" 

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

periodo = conexion.consultaUno("select max(peri_ccod) from actividades_periodos where tape_ccod=6 and acpe_bvigente='S'")


sql_detalles_mate = " select distinct rtrim(convert(char,b.pers_nrut))+',,'+',,'+',,' as uno," & vbcrlf & _
      " rtrim(convert(char,b.pers_nrut))+rtrim(convert(char,b.pers_xdv))+ " & vbcrlf & _
      " ',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,' as dos, " & vbcrlf & _
      " ',,'+',,'+',,'+',,'+',,'+',,'+ " & vbcrlf & _
      " 'C' +',,'+',,'+',,'+ " & vbcrlf & _
      " 'N,' +'S,' +'N,' + " & vbcrlf & _
      " b.pers_tape_paterno +','+b.pers_tape_materno+','+b.pers_tnombre+ " & vbcrlf & _
      " ',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+ " & vbcrlf & _
      " ',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+',,'+ " & vbcrlf & _
      " ',,'+',,'+',' as tres" & vbcrlf & _
" from bloques_profesores a,personas b " & vbcrlf & _
" where a.pers_ncorr=b.pers_ncorr"& vbcrlf 
	
'response.Write("Sql : "&sql_detalles_mate)
set f_detalle_mat  = new cformulario
f_detalle_mat.carga_parametros "planificacion_gral_excel.xml", "f_detalle_serv"
f_detalle_mat.inicializar conexion							
f_detalle_mat.consultar sql_detalles_mate

'------------------------------------------------------------------------------
%>
  <%  while f_detalle_mat.Siguiente 
  response.Write(f_detalle_mat.ObtenerValor("uno") & f_detalle_mat.ObtenerValor("dos") & f_detalle_mat.ObtenerValor("tres") & vbcrlf)
  wend %>
