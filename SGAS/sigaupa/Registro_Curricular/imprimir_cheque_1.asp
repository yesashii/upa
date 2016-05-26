<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/funciones_formateo.asp" -->

<%
set pagina = new CPagina


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

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
contador_fila=0
for fila = 0 to formulario.CuentaPost -1
   num_doc = formulario.ObtenerValorPost (fila, "imprimir_d")
   
   if num_doc = 1 then
     ting_ccod = formulario.ObtenerValorPost (fila, "ting_ccod")
	 ding_ndocto = formulario.ObtenerValorPost (fila, "ding_ndocto")
     ingr_ncorr = formulario.ObtenerValorPost (fila, "ingr_ncorr")
     contador_fila=contador_fila+1
   	
   end if 
   
next

'------------------------------------------------------------------------------------------------------
set f_detalle = new CFormulario
		f_detalle.Carga_Parametros "genera_contrato_4.xml", "imprimir_cheque"
		f_detalle.Inicializar conexion
		
		 consulta = "select dii.DING_MDOCTO monto, to_char(dii.DING_FDOCTO,'DD') dia, "&_
	   				"to_char(dii.DING_FDOCTO,'MONTH') mes,  "&_
	   				"to_char(dii.DING_FDOCTO,'YYYY') ano  "&_
					"from detalle_ingresos dii "&_
					"where dii.ting_ccod=nvl('"& ting_ccod &"', 0) and  "&_
					"dii.ding_ndocto=nvl('"& ding_ndocto &"', 0) and  "&_
					"dii.ingr_ncorr=nvl('"& ingr_ncorr & "', 0)"
					
		
		f_detalle.Consultar consulta
		'response.Write(contador_fila)
		f_detalle.siguiente


'---------------------------------------------------------------

if (contador_fila<>0) then
   nro_letras= Traduce_numero(f_detalle.obtenerValor("monto"),2)
   'nro_letras= "DOCE MILLONES TRECIENTOS TREINTA Y TRES MIL DOCIENTOS NOVENTA Y NUEVE" 
   
   largoNumero = Len(formatnumber(f_detalle.obtenerValor("monto"),0,-1,0,-1)) + 4 
   largoNroLetras = Len(nro_letras)
   if (largoNroLetras >=60) then 
       SegundoLargo = largoNroLetras - 60
       ver_nro_letras =  Ac(nro_letras,60,"I") & chr(13) & chr(10) & Ac(Right(nro_letras,SegundoLargo),SegundoLargo,"D")
	else 
	    ver_nro_letras = Ac(nro_letras,largoNroLetras,"I")   
	end if   
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10)  &  space(6) & Ac("| |",3,"D")  
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
 
   
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D") &  space(41) & Ac("****"& formatnumber(f_detalle.obtenerValor("monto"),0,-1,0,-1) ,largoNumero,"I") & Ac(".-********",10,"D") 
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & space(32) & Ac(f_detalle.obtenerValor("dia") ,3,"I") & space(7) & Ac(f_detalle.obtenerValor("mes"),11,"I") & space(4) & Ac(f_detalle.obtenerValor("ano"),4,"I")
   archivo = archivo  & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10)
   archivo = archivo &  Ac("******| |",9,"D")& space(10) & Ac("UNIVERSIDAD AUTONOMA DEL SUR",40,"I") & space(10) 
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D") 
   archivo = archivo &  space(54)   & Ac("**********",10,"I") 
   archivo = archivo & chr(13) & chr(10)  &  space(6) & Ac("| |",3,"D") 
   archivo = archivo & Ac("--",2,"D") & ver_nro_letras  & Ac(".--------",10,"I")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
   archivo = archivo & chr(13) & chr(10) &  space(6) & Ac("| |",3,"D")
  	

'----------------------------------------------------------------------				

   response.Write("<pre>"& archivo & "</pre>")
   response.End()
   Set oFile      = CreateObject("Scripting.FileSystemObject")
   Set oPrinter   = oFile.CreateTextFile(impresora) 
   
   oPrinter.write(archivo)
 
   Set oWshnet    = Nothing
   Set oFile      = Nothing
   set oPrinter   = Nothing
   set iPrinter   = Nothing 
 
   'response.Redirect(request.ServerVariables("HTTP_REFERER"))

end if 
   
'---------------------------------------------------------------------------------				
%>

