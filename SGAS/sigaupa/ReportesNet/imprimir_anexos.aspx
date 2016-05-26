<%@ Page language="c#" Codebehind="imprimir_anexos.aspx.cs" AutoEventWireup="false" Inherits="imprimir_anexos.WebForm1" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=9.1.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>WebForm1</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="WebForm1" method="post" runat="server">
			<CR:CrystalReportViewer id="VerContrato" style="Z-INDEX: 101; LEFT: 21px; POSITION: absolute; TOP: 17px" runat="server" Width="350px" Height="50px"></CR:CrystalReportViewer>
		</form>
	</body>
</HTML>
