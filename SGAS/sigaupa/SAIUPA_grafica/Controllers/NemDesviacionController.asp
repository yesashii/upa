      <%
      class NemDesviacionController
      Dim Model, ModelFacultad, ModelJornada, ModelCarrera
	  Dim ModelTotalSede,ModelTotalFacultad,ModelTotalJornada,ModelTotalCarrera
      Dim ViewData

      private sub Class_Initialize()
      Set ViewData = Server.CreateObject("Scripting.Dictionary")
      end sub

      private sub Class_Terminate()
      end sub

        public Sub List(vars)
            Dim u
            set u = new NemDesviacionHelper
            If IsNothing(vars) Then
                set Model = u.SelectAll
				set ModelFacultad = u.SelectAllFacultad
				set ModelJornada = u.SelectAllJornada
				set ModelCarrera = u.SelectAllCarrera
				set ModelTotalSede = u.SelectTotalSede
				set ModelTotalFacultad = u.SelectTotalFacultad
				set ModelTotalJornada = u.SelectTotalJornada
				set ModelTotalCarrera = u.SelectTotalCarrera
            ElseIf IsNothing(vars("q")) Then
                set Model = u.SelectAll
				set ModelFacultad = u.SelectAllFacultad
				set ModelJornada = u.SelectAllJornada
				set ModelCarrera = u.SelectAllCarrera
				set ModelTotalSede = u.SelectTotalSede
				set ModelTotalFacultad = u.SelectTotalFacultad
				set ModelTotalJornada = u.SelectTotalJornada
				set ModelTotalCarrera = u.SelectTotalCarrera
            Else
                set Model = u.Search(vars("q"))
            End If
            
            
            %>   <!--#include file="../views/NemDesviacion/List.asp" --> <%
        End Sub
		
		public Sub List_excel(vars)
            Dim u
            set u = new NemDesviacionHelper
            If IsNothing(vars) Then
                set Model = u.SelectAll
				set ModelFacultad = u.SelectAllFacultad
				set ModelJornada = u.SelectAllJornada
				set ModelCarrera = u.SelectAllCarrera
				set ModelTotalSede = u.SelectTotalSede
				set ModelTotalFacultad = u.SelectTotalFacultad
				set ModelTotalJornada = u.SelectTotalJornada
				set ModelTotalCarrera = u.SelectTotalCarrera
            ElseIf IsNothing(vars("q")) Then
                set Model = u.SelectAll
				set ModelFacultad = u.SelectAllFacultad
				set ModelJornada = u.SelectAllJornada
				set ModelCarrera = u.SelectAllCarrera
				set ModelTotalSede = u.SelectTotalSede
				set ModelTotalFacultad = u.SelectTotalFacultad
				set ModelTotalJornada = u.SelectTotalJornada
				set ModelTotalCarrera = u.SelectTotalCarrera
            Else
                set Model = u.Search(vars("q"))
            End If
            
            
            %>   <!--#include file="../views/NemDesviacion/List_excel.asp" --> <%
        End Sub

  End Class



%>
    