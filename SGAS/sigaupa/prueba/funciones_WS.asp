<%

' Variables de carga
'******************* 	VARIABLES LIBRES 		*****************
'Item
CodItem = "123456"
TpoCodigo = "INT"
'Descuentos
NroLinDR = ""
TpoMov = ""
GlosaDR = ""
TpoValor = ""
ValorDR = ""
IndExeDR = ""
'Libres
ImprDestino = ""
ValorLibre2 = "" 
ValorLibre3 = "" 
ValorLibre4 = "" 
ValorLibre5 = ""
ValorLibre6 = ""
ValorLibre7 = "" 
ValorLibre8 = ""
ValorLibre9 = ""
ValorLibre10 = ""
'******************* 	VARIABLES ENCABEZADO 	*****************
TipoDTE = "33"
Version = "1.0"
Folio = "0"
FchEmis = "2009-12-22"
IndNoRebaja = ""
TipoDespacho = ""
IndTraslado = ""
IndServicio = ""
MntBruto = ""
FmaPago = ""
FchCancel = ""
PeriodoDesde = ""
PeriodoHasta = ""
MedioPago = "CF"
TermPagoCdg = ""
TermPagoDias = ""
FchVenc = ""
RUTEmisor = "78079790-8"
RznSoc = "DBNeT"
GiroEmis = "Serviciós"
Sucursal = ""
CdgSIISucur = ""
DirOrigen = "Av 11 de Septiembre 1860 of 181"
CmnaOrigen = "PROVIDENCIA"
CiudadOrigen = "SANTIAGO"
CdgVendedor = ""
RUTMandante = ""
RUTRecep = "78079790-8"
CdgIntRecep = ""
RznSocRecep = "DBNeT"
GiroRecep = "Servicios"
Telefono = "5847800"
DirRecep = "Av 11 de Septiembre 1860 of 181"
CmnaRecep = "PROVIDENCIA"
CiudadRecep = "SANTIAGO"
DirPostal = ""
CmnaPostal = ""
CiudadPostal = ""
RUTSolicita = ""
Patente = ""
RUTTrans = ""
DirDest = ""
CmnaDest = ""
CiudadDest = ""
MntNeto = "1000"
MntExe = "1000"
MntBase = ""
TasaIVA = "19"
IVA = "1000"
IVANoRet = ""
CredEC = ""
MontoPeriodo = ""
GrntDep = ""
MontoNF = ""
MntTotal = "3000"
SaldoAnterior = ""
VlrPagar = ""
TpoImpresion = ""
MntCancel = ""
SaldoInsol = ""
FmaPagExp = ""
TipoCtaPago = ""
NumCtaPago = ""
BcoPago = ""
GlosaPagos = ""
CdgTraslado = ""
FolioAut = ""
FchAut = ""
CodAdicSucur = ""
IdAdicEmisor = ""
NumId = ""
Nacionalidad = ""
IdAdicRecep = ""
CorreoRecep = ""
RUTChofer = ""
NombreChofer = ""
CodModVenta = ""
CodClauVenta = ""
TotClauVenta = ""
CodViaTransp = ""
NombreTransp = ""
RUTCiaTransp = ""
NomCiaTransp = ""
IdAdicTransp = ""
Booking = ""
Operador = ""
CodPtoEmbarque = ""
IdAdicPtoEmb = ""
CodPtoDesemb = ""
IdAdicPtoDesemb = ""
Tara = ""
CodUnidMedTara = ""
PesoBruto = ""
CodUnidPesoBruto = ""
PesoNeto = ""
CodUnidPesoNeto = ""
TotItems = ""
TotBultos = ""
MntFlete = ""
MntSeguro = ""
CodPaisRecep = ""
CodPaisDestin = ""
TpoMoneda = ""
MntMargenCom = ""
IVAProp = ""
IVATerc = ""
TpoMonedaOtrMnda = ""
TpoCambio = ""
MntNetoOtrMnda = ""
MntExeOtrMnda = ""
MntFaeCarneOtrMnda = ""
MntMargComOtrMnda = ""
IVAOtrMnda = ""
IVANoRetOtrMnda = ""
MntTotOtrMnda = ""
ActivEcon = "11111"
'******************* 	VARIABLES DETALLE 		*****************
NroLinDet = "1"
IndExe = ""
NmbItem = "Item 1"
DscItem = "Item descrito"
QtyRef = ""
UnmdRef = ""
PrcRef = ""
QtyItem = "1"
FchElabor = ""
FchVencim = ""
UnmdItem = ""
PrcItem = "33695"
PrcOtrMon = ""
FctConv = ""
ValorDscto = ""
DescuentoPct = ""
DescuentoMonto = ""
RecargoPct = ""
RecargoMonto = ""
CodImpAdic = ""
MontoItem = "33695"
DctoOtrMnda = ""
RecargoOtrMnda = ""
MontoItemOtrMnda = ""
IndAgente = ""
MntBaseFaena = ""
MntMargComer = ""
PrcConsFinal = ""
Moneda="0"

'******************* 	VARIABLES REFERENCIA 	*****************
NroLinRef = ""
TpoDocRef = ""
IndGlobal = ""
FolioRef = ""
RUTOtr = ""
FchRef = ""
CodRef = ""
RazonRef = ""

response.Write("Intentando conectar a WS")

'salida=LeeXml_CargaTDE_Valor(CodItem,TpoCodigo,TipoDTE,Version,Folio,FchEmis,MedioPago,RUTEmisor,RznSoc,GiroEmis,DirOrigen,CmnaOrigen,CiudadOrigen,RUTRecep,RznSocRecep,GiroRecep,Telefono,DirRecep,CmnaRecep,MntNeto,MntExe,TasaIVA,IVA,MntTotal,NroLinDet,NmbItem,DscItem,PrcItem,MontoItem)
param = "?CodItem="&CodItem&"&TpoCodigo="&TpoCodigo&"&TipoDTE="&TipoDTE
salida=fn_llamada_ws("putCustomerETDLoad",param)


'response.Write("<br>Resultado de la conexion : "&salida)

'*********************FUNCIONES CONEXION A WS *******************


function fn_llamada_ws(metodo,param)
		WSURL = "http://172.16.254.14/wssCustomerETDLoadASP/CustomerETDLoadASP.asmx/"
		Set xml = Server.CreateObject("Microsoft.XMLHTTP")
		xml.Open "POST", WSURL, false
		xml.Send
		Estado_conexion=xml.status
		response.Write("<br> Estado: "&xml.status)
		if Estado_conexion <> 200 then			
			fn_llamada_ws = "<br>Error|Sin Conexión " & metodo		
			response.Write( fn_llamada_ws)
		else
			fn_llamada_ws=xml.ResponseText
		end if
		Set xmlResponse = Nothing
end function

'**************************************

Function LeeXml_CargaTDE_Valor(CodItem,TpoCodigo,TipoDTE,Version,Folio,FchEmis,MedioPago,RUTEmisor,RznSoc,GiroEmis,DirOrigen,CmnaOrigen,CiudadOrigen,RUTRecep,RznSocRecep,GiroRecep,Telefono,DirRecep,CmnaRecep,MntNeto,MntExe,TasaIVA,IVA,MntTotal,NroLinDet,NmbItem,DscItem,PrcItem,MontoItem)
	Dim xmlResponse
	Dim indicadores
	

	param = "?CodItem="&CodItem&"&TpoCodigo="&TpoCodigo&"&TipoDTE="&TipoDTE
	param = param&"&Version="&Version&"&Folio="&Folio&"&FchEmis="&FchEmis&"&MedioPago="&MedioPago
	param = param&"&RUTEmisor="&RUTEmisor&"&RznSoc="&RznSoc&"&GiroEmis="&GiroEmis&"DirOrigen="&DirOrigen
	param = param&"&CmnaOrigen="&CmnaOrigen&"&CiudadOrigen="&CiudadOrigen&"&RUTRecep="&RUTRecep&"&RznSocRecep="&RznSocRecep
	param = param&"&GiroRecep="&GiroRecep&"&Telefono="&Telefono&"&DirRecep="&DirRecep&"&CmnaRecep="&CmnaRecep&"&MntNeto="&MntNeto
	param = param&"&MntExe="&MntExe&"&TasaIVA="&TasaIVA&"&IVA="&IVA&"&MntTotal="&MntTotal&"&NroLinDet="&NroLinDet
	param = param&"&NmbItem="&NmbItem&"&DscItem="&DscItem&"&PrcItem="&PrcItem&"&MontoItem="&MontoItem
	              
	metodo		="putCustomerETDLoad"
'vMensaje = wss.putCustomerETDLoad(extras, vEnca, vDetalles, descReca)			
	responseText=fn_llamada_ws(metodo,param)
	
	indicadores = ""
 	if mid(responseText,1,3)<>"Err" then
	
		Set xmlResponse = CreateObject("MSXML2.DOMDocument")
		xmlResponse.async = false
		xmlResponse.loadXml responseText  
	   
		OutErr = xmlResponse.documentElement.selectSingleNode("Codigo").Text 
		
		if len(OutErr)>0 then
			indicadores = "Error en B. de datos"
		else
		    Orespuesta	= xmlResponse.documentElement.selectSingleNode("Mensajes").Text 
			Omsg		= xmlResponse.documentElement.selectSingleNode("TrackId").Text 
			
			indicadores = Orespuesta & "Ç" & Omsg 
		end if
		   
		Set xnodelist = Nothing
		
		LeeXml_CargaTDE = indicadores	
	
	else
		
		LeeXml_CargaTDE = "Error|Sin Conexión " & metodo
	 
	End If
	
End Function
	

Function LeeXml_insertCorrImp(codEmpresa,suministro,correlativo)
	Dim xmlResponse
	Dim indicadores
	
	param		="?codEmpresa="&codEmpresa&"&suministro="&suministro&"&correlativo="&correlativo
	metodo		="putCustomerETDLoad"
		
	responseText=fn_llamada_ws(metodo,param)
	
	if mid(responseText,1,3)<>"Err" then
	
		Set xmlResponse = CreateObject("MSXML2.DOMDocument")
		xmlResponse.async = false
		xmlResponse.loadXml responseText  
	   
		indicadores = xmlResponse.documentElement.selectSingleNode("corImpresion").Text 
	   
		Set xnodelist = Nothing
		
		LeeXml_insertCorrImp = indicadores
	
	else
		LeeXml_insertCorrImp = "Error|Sin Conexión " & metodo
	 
	End If	

End Function

%>