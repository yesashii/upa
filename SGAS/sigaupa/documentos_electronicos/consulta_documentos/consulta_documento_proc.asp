<!-- #include file = "../../Factura_Electronica/Proc_consulta_boleta.asp" -->
<!-- #include file = "../../Factura_Electronica/Proc_consulta_dte.asp" -->
<%
	Class Controlador_Consulta
		private isConstructed
		private control_boleta
		private control_dte
		
		private sub Class_Initialize
			Set control_boleta = new Controlador_consulta_boleta
			Set control_dte = new Controlador_consulta_dte
			
			Dim item()
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public function Consultar()
			dim arreglom(6)
			arreglom(0) = ARRAY(39, "Boleta Electr&oacute;nica")
			arreglom(1) = ARRAY(41, "Boleta Electr&oacute;nica Exenta")
			arreglom(2) = ARRAY(33, "Factura Electr&oacute;nica")
			arreglom(3) = ARRAY(34, "Factura Electr&oacute;nica Exenta")
			arreglom(4) = ARRAY(52, "Gu&iacute;a de Despacho Electr&oacute;nica ")
			arreglom(5) = ARRAY(61, "Nota de Credito Electr&oacute;nica ")
			arreglom(6) = ARRAY(56, "Nota de Debito Electr&oacute;nica ")
			Consultar = arreglom
		end function
		
		public function enviar_boleta(stipo, sfolio, smonto, sfecha)
			control_boleta.enviar control_boleta.generadorxml(stipo, sfolio, smonto, sfecha)
		end function
		
		public function enviar_dte(stipo, sfolio, smonto, sfecha)
			control_dte.enviar control_dte.generadorxml(sfolio, stipo, smonto, sfecha)
		end function
		
	end class
%>