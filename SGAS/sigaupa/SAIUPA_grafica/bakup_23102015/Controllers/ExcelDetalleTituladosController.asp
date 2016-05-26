      <%
      class ExcelDetalleTituladosController
      Dim Model
      Dim ViewData

      private sub Class_Initialize()
      Set ViewData = Server.CreateObject("Scripting.Dictionary")
      end sub

      private sub Class_Terminate()
      end sub

        public Sub List(vars)
            Dim u
            set u = new ExcelDetalleTituladosHelper
            If IsNothing(vars) Then
                 set Model = u.SelectAll
            ElseIf IsNothing(vars("q")) Then
                 set Model = u.SelectAll
            Else
                 set Model = u.Search(vars("q"))
            End If
            
            %>   <!--#include file="../views/ExcelDetalleTitulados/List_excel.asp" --> <%
        End Sub
		
		public Sub List_excel(vars)
            Dim u
            set u = new ExcelDetalleTituladosHelper
            If IsNothing(vars) Then
                 set Model = u.SelectAll
            ElseIf IsNothing(vars("q")) Then
                 set Model = u.SelectAll
            Else
                 set Model = u.Search(vars("q"))
            End If
            
           %>   <!--#include file="../views/ExcelDetalleTitulados/List_excel.asp" --> <%
        End Sub

  End Class



%>
    