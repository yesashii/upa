      <%
      class DocenteGradoController
      Dim Model
	  Dim ModelTotal
	  Dim ModelHoras
	  Dim ModelTotalHoras
      Dim ViewData

      private sub Class_Initialize()
      Set ViewData = Server.CreateObject("Scripting.Dictionary")
      end sub

      private sub Class_Terminate()
      end sub

        public Sub List(vars)
            Dim u
            set u = new DocenteGradoHelper
            If IsNothing(vars) Then
                 set Model = u.SelectAll
				 set ModelTotal = u.SelectTotal
				 set ModelHoras = u.SelectAllHoras
				 set ModelTotalHoras = u.SelectTotalHoras
			ElseIf IsNothing(vars("q")) Then
                set Model = u.SelectAll
				set ModelTotal = u.SelectTotal
				set ModelHoras = u.SelectAllHoras
				set ModelTotalHoras = u.SelectTotalHoras
            Else
                set Model = u.Search(vars("q"))
            End If
            
            
            %>   <!--#include file="../views/DocenteGrado/List.asp" --> <%
        End Sub
		
		public Sub List_excel(vars)
            Dim u
            set u = new DocenteGradoHelper
            If IsNothing(vars) Then
                 set Model = u.SelectAll
				 set ModelTotal = u.SelectTotal
				 set ModelHoras = u.SelectAllHoras
				 set ModelTotalHoras = u.SelectTotalHoras
            ElseIf IsNothing(vars("q")) Then
                 set Model = u.SelectAll
				 set ModelTotal = u.SelectTotal
				 set ModelHoras = u.SelectAllHoras
				 set ModelTotalHoras = u.SelectTotalHoras
            Else
                set Model = u.Search(vars("q"))
            End If
            
            
            %>   <!--#include file="../views/DocenteGrado/List_excel.asp" --> <%
        End Sub

  End Class



%>
    