<!-- #include file = "funciones.asp" -->
<%

	Class Controlador_carga_boleta
		
		private tipo
		private RUTRecep
		private RznSocRecep
		private CiudadRecep
		private CmnaRecep
		private DirRecep
		private isConstructed
		private CiudadOrigen
		private CmnaOrigen
		private DirOrigen
		private GiroEmis
		private RznSoc
		private RUTEmisor
		private TipoDTE
		private Folio
		private FchEmis
		private MntTotal
		private ActivEcon
		private VlrPagar
		private FchVenc
		private xmlResponse
		private TipoDTEREF
		private FolioREF
		private FchEmisREF
		private Codigo
		private Razon
		
		private sub Class_Initialize
			CiudadOrigen = "Santiago"
			CmnaOrigen = "Las Condes"
			DirOrigen = "Av. Las Condes 11121"
			GiroEmis = "Universidad"
			RznSoc = "Universidad del Pacifico"
			RUTEmisor = "71704700-1"
			ActivEcon="803020"
			TipoDTEREF = ""
			FolioREF = ""
			FchEmisREF = ""
			Codigo = ""
			Razon = ""
			RutChofer = ""
			Dim xmlResponse
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public sub SetReceptor (rut, nombre, ciudad, comuna, direccion)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			RUTRecep = rut
			RznSocRecep = nombre
			CiudadRecep = ciudad
			CmnaRecep = comuna
			DirRecep = direccion
		end sub
		
		
		public sub SetRegistro(stipo, sfolio, sfechaemision, sfechavencimiento)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			TipoDTE =stipo
			Folio = sfolio
			FchEmis = sfechaemision
			FchVenc = sfechavencimiento
		end sub
		
		public function GetTipo()
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			GetTipo = TipoDTE
		end function
		
		public function GetFolio()
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			GetFolio = Folio
		end function
		
		public function GetFecha()
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			GetFecha = FchEmis
		end function
		
		public sub SetMontoTotal(arreglo)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			for i=0 to UBound(arreglo)
				MntTotal = Clng(MntTotal+arreglo(i)(3))
			next
		end sub
		
		public function GetMontoTotal()
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			GetMontoTotal = MntTotal
		end function
		
		public sub SetMontoPagar()
			VlrPagar = MntTotal
		end sub
		
		public function generadorxml(arreglo)
		
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
			
			xmlgenerado = "<?xml version='1.0' encoding='UTF-8'?>"&vbCrLf&_
			"<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:dbn='DBNeT'> "&vbCrLf&_
			vbTAB&"<soapenv:Header/> "&vbCrLf&_
			vbTAB&"<soapenv:Body> "&vbCrLf&_
			vbTAB&vbTAB&"<dbn:putCustomerETDLoad> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&"<dbn:Extras/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&"<dbn:Encabezado> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:camposEncabezado> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TipoDTE>"&TipoDTE&"</dbn:TipoDTE> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Version>1.0</dbn:Version> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Folio>"&Folio&"</dbn:Folio> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchEmis>"&FchEmis&"</dbn:FchEmis> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndNoRebaja/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TipoDespacho/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndTraslado/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndServicio>1</dbn:IndServicio>"&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntBruto/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FmaPago/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchCancel/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PeriodoDesde/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PeriodoHasta/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MedioPago/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TermPagoCdg/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TermPagoDias/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchVenc>"&FchVenc&"</dbn:FchVenc> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTEmisor>"&RUTEmisor&"</dbn:RUTEmisor> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RznSoc>"&RznSoc&"</dbn:RznSoc> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:GiroEmis>"&GiroEmis&"</dbn:GiroEmis> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Sucursal/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CdgSIISucur/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DirOrigen>"&DirOrigen&"</dbn:DirOrigen> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CmnaOrigen>"&CmnaOrigen&"</dbn:CmnaOrigen> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CiudadOrigen>"&CiudadOrigen&"</dbn:CiudadOrigen> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CdgVendedor/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTMandante/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTRecep>"&RUTRecep&"</dbn:RUTRecep> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CdgIntRecep/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RznSocRecep>"&RznSocRecep&"</dbn:RznSocRecep> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:GiroRecep>SINGIRO</dbn:GiroRecep> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Telefono/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DirRecep>"&DirRecep&"</dbn:DirRecep> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CmnaRecep>"&CmnaRecep&"</dbn:CmnaRecep> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CiudadRecep>"&CiudadRecep&"</dbn:CiudadRecep> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DirPostal/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CmnaPostal/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CiudadPostal/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTSolicita/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Patente/>"&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTTrans/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DirDest>"&DirRecep&"</dbn:DirDest> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CmnaDest>LAS CONDES</dbn:CmnaDest> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CiudadDest>SANTIAGO</dbn:CiudadDest> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntNeto/>"&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntExe>"&MntTotal&"</dbn:MntExe>"&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntBase/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TasaIVA/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IVA/>"&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IVANoRet/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CredEC/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MontoPeriodo/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:GrntDep/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MontoNF/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntTotal>"&MntTotal&"</dbn:MntTotal> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:SaldoAnterior/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:VlrPagar>"&VlrPagar&"</dbn:VlrPagar> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TpoImpresion/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntCancel/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:SaldoInsol/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FmaPagExp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TipoCtaPago/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NumCtaPago/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:BcoPago/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:GlosaPagos/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CdgTraslado/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FolioAut/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchAut/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodAdicSucur/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IdAdicEmisor/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NumId/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Nacionalidad/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IdAdicRecep/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CorreoRecep/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTChofer/>"&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NombreChofer/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodModVenta/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodClauVenta/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TotClauVenta/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodViaTransp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NombreTransp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTCiaTransp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NomCiaTransp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IdAdicTransp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Booking/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Operador/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodPtoEmbarque/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IdAdicPtoEmb/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodPtoDesemb/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IdAdicPtoDesemb/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Tara/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodUnidMedTara/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PesoBruto/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodUnidPesoBruto/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PesoNeto/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodUnidPesoNeto/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TotItems/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TotBultos/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntFlete/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntSeguro/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodPaisRecep/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodPaisDestin/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TpoMoneda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntMargenCom/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IVAProp/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IVATerc/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TpoMonedaOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TpoCambio/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntNetoOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntExeOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntFaeCarneOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntMargComOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IVAOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IVANoRetOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntTotOtrMnda/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:camposEncabezado> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:ActivEcon> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:ActividadEconomica> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:ActivEcon>"&ActivEcon&"</dbn:ActivEcon> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:ActividadEconomica> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:ActivEcon> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:ImptoReten/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TipoBultos/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:ImpRetOtr/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Comi/> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&"</dbn:Encabezado> "&vbCrLf&_
			vbTAB&vbTAB&vbTAB&"<dbn:Detalles> "&vbCrLf
			xmlgenerado = xmlgenerado & detallexml(arreglo)
			xmlgenerado = xmlgenerado & vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:Detalles> "&vbCrLf
			if TipoDTEREF = "" then
				xmlgenerado = xmlgenerado & vbTAB&vbTAB&vbTAB&"<dbn:DescuentosRecargosyOtros />"&vbCrLf
			else
				xmlgenerado = xmlgenerado & vbTAB&vbTAB&vbTAB&"<dbn:DescuentosRecargosyOtros> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Referencias>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<!--Zero or more repetitions:-->"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Referencias>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NroLinRef>1</dbn:NroLinRef>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TpoDocRef>"&TipoDTEREF&"</dbn:TpoDocRef>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndGlobal/>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FolioRef>"&FolioREF&"</dbn:FolioRef>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RUTOtr/>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchRef>"&FchEmisREF&"</dbn:FchRef>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodRef>"&Codigo&"</dbn:CodRef>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RazonRef>"&Razon&"</dbn:RazonRef>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:Referencias>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:Referencias>"&vbCrLf&_
				vbTAB&vbTAB&vbTAB&"</dbn:DescuentosRecargosyOtros> "&vbCrLf
			end if
			xmlgenerado = xmlgenerado & vbTAB&vbTAB&"</dbn:putCustomerETDLoad> "&vbCrLf&_
			vbTAB&"</soapenv:Body> "&vbCrLf&_
			"</soapenv:Envelope>"
			generadorxml = xmlgenerado
		end function
		
		private function detallexml(arreglo)
			xml=""
			for i=0 to UBound(arreglo)
				xml=xml&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Detalle> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Detalles> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NroLinDet>"&i+1&"</dbn:NroLinDet> "&vbCrLf
				if arreglo(i)(4) = "on" then
					xml=xml&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndExe>1</dbn:IndExe>"&vbCrLf
				else
					xml=xml&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndExe/> "&vbCrLf
				end if
				xml=xml&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:NmbItem>"&left(arreglo(i)(1),79)&"</dbn:NmbItem> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DscItem>"&left(arreglo(i)(1),999)&"</dbn:DscItem> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:QtyRef/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:UnmdRef/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PrcRef/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:QtyItem>"&arreglo(i)(0)&"</dbn:QtyItem> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchElabor/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FchVencim/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:UnmdItem/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PrcItem>"&arreglo(i)(3)&"</dbn:PrcItem> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PrcOtrMon/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:FctConv/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:ValorDscto/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DescuentoPct/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DescuentoMonto/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RecargoPct/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RecargoMonto/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodImpAdic/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MontoItem>"&arreglo(i)(3)&"</dbn:MontoItem> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:DctoOtrMnda/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:RecargoOtrMnda/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MontoItemOtrMnda/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:IndAgente/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntBaseFaena/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:MntMargComer/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:PrcConsFinal/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:Moneda/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:Detalles> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:SubDescuentos/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:CodItems/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:SubRecargos/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:SubCantidades/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&vbTAB&"<dbn:TpoDocLiq/> "&vbCrLf&_
				vbTAB&vbTAB&vbTAB&vbTAB&"</dbn:Detalle> "&vbCrLf
			next
			detallexml = xml
		end function 
		
		public function enviar(xml)
			'response.write("<pre>"&xml&"</pre>")
			'response.End()
			strSOAPAction = "DBNeT/putCustomerETDLoad"
			
			'Ahora sí estamos listos para llamar a la función InvokeWebService(). Conociendo la estructura del XML de respuesta (SOAP Response), obtenemos el resultado de la ejecución:
			'Dimensionamos la variable donde obtendremos la respuesta del WebService 
			
			Dim xmlResponse
			'response.write xmlResponse &"<-1"
			'Realizamos la llamada a la función InvokeWebService(), brindándole los parámetros correspondientes
			Codigo = ""
			Mensajes = ""
			TrackId = ""
			If InvokeWebService (xml, strSOAPAction, "http://172.16.254.15/wssCustomerETDLoadASP/CustomerETDLoadASP.asmx", xmlResponse	) Then
				'Si el WebService se ejecutó con éxito, obtenemos la respuesta y la imprimimos utilizando MSXML.DOMDocument
				
				Codigo = xmlResponse.documentElement.selectSingleNode("soap:Body/putCustomerETDLoadResponse/putCustomerETDLoadResult/Codigo").text
				Mensajes = xmlResponse.documentElement.selectSingleNode("soap:Body/putCustomerETDLoadResponse/putCustomerETDLoadResult/Mensajes").text
				TrackId = xmlResponse.documentElement.selectSingleNode("soap:Body/putCustomerETDLoadResponse/putCustomerETDLoadResult/TrackId").text
				'Response.Write ("Resultado:" )
				'Response.Write ("<br>Codigo: "&Codigo)
				'Response.Write ("<br>Mensajes: "&Mensajes) 
				'Response.Write ("<br>TrackId: " &TrackId)	
										
			End If
			dim retorno(2)
			
			retorno(0) = Codigo
			retorno(1) = Mensajes
			retorno(2) = TrackId
			'response.write "<pre>" & xml & "</pre>"
			
			'Liberamos la memoria del objeto xmlResponse 
			Set xmlResponse = Nothing
			
			'print_r retorno, 0
			
			enviar = retorno
		end function
		
	end class
%>
