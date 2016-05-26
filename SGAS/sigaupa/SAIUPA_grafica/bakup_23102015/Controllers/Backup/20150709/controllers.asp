		<!--#include file="LoginController.asp" -->
        
        <!--#include file="HomeController.asp" -->
        
        <!--#include file="PostulanteController.asp" -->
        
        <!--#include file="MatrNuevoController.asp" -->

        <!--#include file="ExtrNuevoController.asp" -->
        
        <!--#include file="OtraRegionController.asp" -->
        
        <!--#include file="MatrXSexoController.asp" -->

        <!--#include file="MatrXEdadSIESController.asp" -->
        
        <!--#include file="MatrXEdadAutoevController.asp" -->
        
        <!--#include file="PsuPromedioController.asp" -->
        
        <!--#include file="PsuMinimoController.asp" -->
        
        <!--#include file="PsuMaximoController.asp" -->
        
        <!--#include file="NemPromedioController.asp" -->
        
        <!--#include file="PsuDesviacionController.asp" -->
        
        <!--#include file="NemDesviacionController.asp" -->
        
        <!--#include file="ExcelDetalleController.asp" -->
        
        <!--#include file="ExcelDetalleMatriculadosController.asp" -->
        
        <!--#include file="ExcelDetalleProfesoresController.asp" -->
        
        <!--#include file="ExcelDetalleCohorteMatController.asp" -->
         
        <!--#include file="ExcelDetalleTituladosController.asp" -->
        
        <!--#include file="AporteFiscalIndirectoController.asp" -->

        <!--#include file="VacantesNuevoController.asp" -->

		<!--#include file="ColegioProcedeController.asp" -->        
      
        <!--#include file="ArancelNuevoController.asp" -->
        
        <!--#include file="MatriculaNuevoController.asp" -->
        
        <!--#include file="MatriculaCreditoController.asp" -->
        
        <!--#include file="CostoTitulacionController.asp" -->
        
        <!--#include file="DocenteEdadController.asp" -->
        
        <!--#include file="DocenteSexoController.asp" -->
        
        <!--#include file="DocenteGradoController.asp" -->
        
        <!--#include file="DocenteJornadaController.asp" -->
        
        <!--#include file="DocenteJerarquiaController.asp" -->
        
        <!--#include file="DocenteJerarquiaGradoController.asp" -->
        
        <!--#include file="DocentePromRentaController.asp" -->
        
        <!--#include file="EvolucionCohorteController.asp" -->

        <!--#include file="RetencionCohorteController.asp" -->
        
        <!--#include file="TitulacionCohorteController.asp" -->
        
        <!--#include file="PorcentajeTitulacionCohorteController.asp" -->
            

      <%
      Public Controllers : Set Controllers = Server.CreateObject("Scripting.Dictionary")
        Controllers.Add "LoginController", ""
		
		Controllers.Add "HomeController", ""
		
        Controllers.Add "PostulanteController", ""
		
		Controllers.Add "MatrNuevoController", ""
		
		Controllers.Add "ExtrNuevoController", ""
		
		Controllers.Add "OtraRegionController", ""
		
		Controllers.Add "MatrXSexoController", ""
		
		Controllers.Add "MatrXEdadSIESController", ""
		
		Controllers.Add "MatrXEdadAutoevController", ""	
		
		Controllers.Add "PsuPromedioController", ""	
		
		Controllers.Add "PsuMinimoController", ""	
		
		Controllers.Add "PsuMaximoController", ""	
		
		Controllers.Add "NemPromedioController", ""	
		
		Controllers.Add "PsuDesviacionController", ""	
		
		Controllers.Add "NemDesviacionController", ""
		
		Controllers.Add "ExcelDetalleController", ""	
		
		Controllers.Add "ExcelDetalleMatriculadosController", ""
		
		Controllers.Add "ExcelDetalleProfesoresController", ""	
		
		Controllers.Add "ExcelDetalleCohorteMatController", ""	
		
		Controllers.Add "ExcelDetalleTituladosController", ""
		
		Controllers.Add "AporteFiscalIndirectoController", ""	
		
		Controllers.Add "VacantesNuevoController", ""

		Controllers.Add "ColegioProcedeController", ""	      
		
		Controllers.Add "ArancelNuevoController", ""
		
		Controllers.Add "MatriculaNuevoController", ""
		
		Controllers.Add "MatriculaCreditoController", ""
		
		Controllers.Add "CostoTitulacionController", ""
		
		Controllers.Add "DocenteEdadController", ""
		
		Controllers.Add "DocenteSexoController", ""
		
		Controllers.Add "DocenteGradoController", ""
		
		Controllers.Add "DocenteJornadaController", ""
		
		Controllers.Add "DocenteJerarquiaController", ""
		
		Controllers.Add "DocenteJerarquiaGradoController", ""
		
		Controllers.Add "DocentePromRentaController", ""
		
		Controllers.Add "EvolucionCohorteController", ""
		
		Controllers.Add "RetencionCohorteController", ""
		
		Controllers.Add "TitulacionCohorteController", ""
		
		Controllers.Add "PorcentajeTitulacionCohorteController", ""
              
      %>
      
    