<%@ Page language="c#" Codebehind="documento_banco.aspx.cs" AutoEventWireup="false" Inherits="CartaGuia.WebForm1" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=9.1.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>WebForm1</title>
		<meta content="False" name="vs_showGrid">
		<meta content="Microsoft Visual Studio 7.0" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<CR:CRYSTALREPORTVIEWER id="CrystalReportViewer1" style="Z-INDEX: 101; LEFT: 31px; POSITION: absolute; TOP: 23px" runat="server" Height="50px" Width="350px"></CR:CRYSTALREPORTVIEWER></form>
	</body>
</HTML>
