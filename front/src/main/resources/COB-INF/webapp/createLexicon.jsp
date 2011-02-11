<%@ include file="/WEB-INF/jsp/include.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<link rel=stylesheet type="text/css" href="styles/ConventionsLana.css">

</head>
<body>
<form action="createLexicon.htm" method="get">

<P>

<!--<div style="BORDER: black 1px solid; WIDTH: 60%;background-color:#eeeecc;borderColor=#999999">-->
<div class="groupBox" style="WIDTH:60%;">

<TABLE>
<TR>
	<TD>
	<Span class='fieldlabel'>Lexicon name:</span>
	</TD>
	<TD>
	<input type="text" name="name" value="" />
	</TD>
	<TD>
	<Span class='fieldlabel'>Description:</span>
	</TD>
	<TD>
	<input type="text" name="description" value="" />
	</TD>
</TR>



</TABLE>
</div>
<input class="button" type="submit" value="Save" />

</body>
</html>
