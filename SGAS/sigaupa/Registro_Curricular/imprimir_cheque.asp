<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/funciones_formateo.asp" -->

<%
set pagina = new CPagina


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion


'------------------------------------------------------------------------------------------------
post_ncorr = Request.QueryString("post_ncorr")
'impresora  = request.querystring("impresora") 
impresora  = "\\protic-1\AppleLaser" 
'-------------------------------------------------------------
  function Ac(texto,ancho,alineado)
    largo =Len(Trim(texto))
	if isnull(largo) then largo=0
	if largo > ancho then largo=ancho
    if ucase(alineado) = "D" then 
	   Ac=space(ancho-largo)&Left(texto,largo)
	else
	   Ac=Left(texto,cint(largo))&space(ancho-largo)
	end if   
  end function
'-----------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "genera_contrato_4.xml", "f_detalle_cheque_2"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

for fila = 0 to formulario.CuentaPost -1
   num_doc = formulario.ObtenerValorPost (fila, "imprimir_d")
   
   if num_doc = 1 then
     sdpa_ccod = formulario.ObtenerValorPost (fila, "sdpa_ccod")
	 sdpa_ncuota = formulario.ObtenerValorPost (fila, "sdpa_ncuota")
     post_ncorr = formulario.ObtenerValorPost (fila, "post_ncorr")
	 ofer_ncorr = formulario.ObtenerValorPost (fila, "ofer_ncorr")
	 sdpa_ndocumento= formulario.ObtenerValorPost (fila, "sdpa_ndocumento")	
   end if 
next

'------------------------------------------------------------------------------------------------------
set f_detalle = new CFormulario
		f_detalle.Carga_Parametros "genera_contrato_4.xml", "imprimir_cheque"
		f_detalle.Inicializar conexion
		
		 consulta = "select sdpa_mmonto monto, to_char(sdpa_fvencimiento,'DD') dia, "&_
	   				"to_char(sdpa_fvencimiento,'MONTH') mes,  "&_
	   				"to_char(sdpa_fvencimiento,'YY') ano  "&_
					"from sdetalles_pagos  "&_
					"where sdpa_ccod='"& sdpa_ccod &"' and  "&_
					"sdpa_ncuota="& sdpa_ncuota &" and  "&_
					"post_ncorr="& post_ncorr &"  and "&_
					"ofer_ncorr="& ofer_ncorr &"  and  "&_
					"sdpa_ndocumento= "& sdpa_ndocumento
		
		f_detalle.Consultar consulta
		'response.Write(consulta)
		f_detalle.siguiente


'---------------------------------------------------------------
   nro_letras= Traduce_numero(f_detalle.obtenerValor("monto"),2)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)   
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10) & space(50) & Ac("M:"& formatnumber(f_detalle.obtenerValor("monto"),0,-1,0,-1) ,9,"I") & Ac(".----",5,"I") & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo &  space(40) & Ac("d:"& f_detalle.obtenerValor("dia") ,3,"I") & space(5) & Ac("m:"&f_detalle.obtenerValor("mes"),11,"I") & space(5) & Ac("y:"&f_detalle.obtenerValor("ano"),6,"I")
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & space(10) & Ac("UNIVERSIDAD AUTONOMA DEL SUR",40,"I")
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo & space(10) & Ac(nro_letras,60,"I") & space(4)
   archivo = archivo & chr(13) & chr(10)
  	

'----------------------------------------------------------------------				

   response.Write(archivo)
   response.End()
   Set oFile      = CreateObject("Scripting.FileSystemObject")
   Set oPrinter   = oFile.CreateTextFile(impresora) 
   
   oPrinter.write(archivo)
 
   Set oWshnet    = Nothing
   Set oFile      = Nothing
   set oPrinter   = Nothing
   set iPrinter   = Nothing 
   
   'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'---------------------------------------------------------------------------------				
%>

