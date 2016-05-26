<!-- #include file = "../../Factura_Electronica/Proc_carga_boleta.asp" -->
<!-- #include file = "../../Factura_Electronica/Proc_pdf_boleta.asp" -->
<%
	Class Controlador_Boleta
		private isConstructed
		private control_carga
		private control_pdf
		private dao_boleta
		private item
		
		private sub Class_Initialize
			Set control_carga = new Controlador_carga_boleta
			Set control_pdf = new Controlador_pdf_boleta
			Set dao_boleta = new Dao_boletas
			Dim item()
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public sub SetReceptor(srut, snombre, sciudad, scomuna, sdireccion)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			
			control_carga.SetReceptor srut, snombre, sciudad, scomuna, sdireccion
		end sub
		
		public sub SetRegistro(stipo, sfolio, semision, svencimiento)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			
			control_carga.SetRegistro stipo, sfolio, semision, svencimiento 
		end sub
		
		public sub SetMontoTotal(sitem)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			
			control_carga.SetMontoTotal sitem
			control_carga.SetMontoPagar 
		end sub
		
		public function GetMonto()
			GetMonto = control_carga.GetMontoTotal()
		end function
		
		public function enviar(sitem)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			'XML Carga
			'response.write "<pre>"&control_carga.generadorxml(sitem)&"</pre>"
			'response.write("algo")
			'response.End()
			enviar = control_carga.enviar(control_carga.generadorxml(sitem))
		end function
		
		public sub GenerarPDF(srut, sfolio,stipo,smonto,sfecha, cedible)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			
			control_pdf.SetRegistro srut, sfolio, stipo, smonto, sfecha
			'response.write(srut&"-"&sfolio&"-"&stipo&"-"&smonto&"-"&sfecha&"-"&cedible)
			'response.write "<pre>"&control_pdf.generadorxml(cedible)&"</pre>"
			'response.end()
			'Comparar datos enviados con folio boleta, si datos no corresponden controlar error.
			'if vari=1 then
			control_pdf.enviar control_pdf.generadorxml(cedible)
			'else
			'	response.Write("datos no corresponden")
			'end if
		end sub
		
		public function IngresarBoleta(sfolio, srut, stipo,smonto,sfecha,sitem,susuario,sbole_ncorr)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			'print_r arreglo, 0
			'response.End()
			arreglo = enviar(sitem)
			'print_r arreglo, 0
			'response.End()
			if arreglo(0) = "OK" AND arreglo(1) = "Procesado" 	then
				EndTime = Now() + (6 / (24 * 60* 60)) '6 x 2 = 12 seconds
				Do While Now() < EndTime
				Loop
				
				dao_boleta.InsertaBoletaElectronica sfolio,sbole_ncorr,stipo,susuario
				'IngresarBoleta = "ok"
				'response.Write("inserta_boleta")
				'CREAR FUNCION EN DAO PARA INGRESAR BOLETA A BS SQL
				'arreglos = BuscarGuia(folio)
				'print_r arreglos, 0
				'response.End()
				'GenerarPDF srut, sfolio,stipo,smonto,sfecha, "false"
				'BuscarBoleta()
			end if
		end function
		
		public function BuscarBoleta (sbole_ncorr)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
				BuscarBoleta = dao_boleta.BuscarBoleta(sbole_ncorr)
		end function
		
		public function BuscarPersona(spers_ncorr)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
				BuscarPersona = dao_boleta.BuscarPersona(spers_ncorr)
		end function
		
		public function BuscarDireccion(spers_ncorr)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
				BuscarDireccion = dao_boleta.BuscarDireccion(spers_ncorr)
		end function
		
		public function BuscarCiudad(sciud_ccod)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
				BuscarCiudad = dao_boleta.BuscarCiudad(sciud_ccod)
		end function
		
		public function BuscarFolio(stipo)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Controlador Guia is not constructed")
			end if
			if stipo = 41 then
				tbol_ccod = 2
			else
				tbol_ccod = 1
			end if
				BuscarFolio = dao_boleta.BuscarFolio(tbol_ccod)
		end function
		
	end class
	
	Class Dao_boletas
		private sql
		private formulario
		private conectar
		private usuario
		private isConstructed
		
		private sub Class_Initialize
			set conectar = new CConexion
			conectar.Inicializar "upacifico"
		
			set negocio 	= new CNegocio
			negocio.Inicializa conectar
			
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public function BuscarPersona(spers_ncorr)
			sql= "select * from Personas WHERE pers_ncorr='"&spers_ncorr&"';"
			dim variables(5)
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conectar
			formulario.Consultar sql
			formulario.siguiente
		
			variables(0) = formulario.obtenerValor("pers_nrut")
			variables(1) = formulario.obtenerValor("pers_tnombre")
			variables(2) = formulario.obtenerValor("pers_tape_paterno")
			variables(3) = formulario.obtenerValor("pers_tape_materno")
			variables(4) = formulario.obtenerValor("pers_temail")
			variables(5) = formulario.obtenerValor("pers_xdv")
			
			'print_r variables,0
			BuscarPersona = variables
		end function
		
		public function BuscarDireccion(spers_ncorr)
			sql= "select * from Direcciones WHERE pers_ncorr='"&spers_ncorr&"';"
			dim variables(3)
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conectar
			formulario.Consultar sql
			formulario.siguiente
		
			variables(0) = formulario.obtenerValor("dire_tcalle")
			variables(1) = formulario.obtenerValor("dire_tnro")
			variables(2) = formulario.obtenerValor("ciud_ccod")
						
			'print_r variables,0
			BuscarDireccion = variables
		end function
		
		public function BuscarCiudad(sciud_ccod)
			sql= "select * from CIUDADES where CIUD_CCOD='"&sciud_ccod&"';"
			dim variables(2)
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conectar
			formulario.Consultar sql
			formulario.siguiente
		
			variables(0) = formulario.obtenerValor("ciud_tdesc")
			variables(1) = formulario.obtenerValor("ciud_tcomuna")
						
			'print_r variables,0
			BuscarCiudad = variables
		end function
		
		public function BuscarFolio(stbol)
			'sql= "select MAX(boel_ncorr) from BOLETA_ELECTRONICA where tbol_ccod="&stbol
			sql = "select foel_nact from folios_electronicos where foel_ccod=3"
			
			dim dato
			
			'SET formulario = new CFormulario
			'formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			'formulario.Inicializar conectar
			'formulario.Consultar sql
			'formulario.siguiente
		
			dato = conectar.consultauno(sql)
			'response.Write(sql)
			'response.End()			
			'print_r variables,0
			BuscarFolio = dato
		end function
		
		public function BuscarBoleta(sbole_ncorr)
			sql= "select top 1 a.BOEL_NCORR,a.bole_ncorr,a.tbol_ccod,a.ebol_ccod," & vbCrLf &_ 
			"a.boel_nfol,b.bole_mtotal,convert(date,b.bole_fboleta)bole_fboleta from" & vbCrLf &_ 					
			"BOLETA_ELECTRONICA a,BOLETAS b" & vbCrLf &_
			"where a.BOLE_NCORR = b.BOLE_NCORR and a.BOLE_NCORR ='"&sbole_ncorr&"'  order by 							         	a.boel_ncorr desc;"
			dim variables(6)
			'response.Write(sql)
			'response.End()
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conectar
			formulario.Consultar sql
			formulario.siguiente
		
			variables(0) = formulario.obtenerValor("boel_ncorr")
			variables(1) = formulario.obtenerValor("bole_ncorr")
			variables(2) = formulario.obtenerValor("tbol_ccod")
			variables(3) = formulario.obtenerValor("ebol_ccod")
			variables(4) = formulario.obtenerValor("boel_nfol")
			variables(5) = formulario.obtenerValor("bole_mtotal")
			variables(6) = formulario.obtenerValor("bole_fboleta")
			'print_r variables,0
			'response.End()
			BuscarBoleta = variables
		end function
		
		public function InsertaBoletaElectronica(folio,bole_ncorr,stipo,usuario)
			if stipo = 41 then
				tbol_ccod = 2
			else
				tbol_ccod = 1
			end if
			sql = "insert into BOLETA_ELECTRONICA(bole_ncorr, tbol_ccod, ebol_ccod, boel_nfol, audi_tusuario, audi_tmodificacion) values ("&bole_ncorr&","&tbol_ccod&",2,"&folio&","&usuario&",getdate())"
			'response.Write(sql)
			'response.End()
			conectar.EjecutaS(sql)
		end function
	end class
%>