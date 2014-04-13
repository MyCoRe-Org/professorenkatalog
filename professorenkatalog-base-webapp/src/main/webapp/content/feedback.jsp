<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="WF.professorum.feedback" />
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle="${pageTitle}" layout="2columns">
    <stripes:layout-component name="contents">
<c:set var="returnurl" value="${param.prof_url}" />
<c:if test="${empty returnurl}">
	<c:set var="returnurl" value="http://cpr.uni-rostock.de" />
</c:if> 
<h2>${pageTitle}</h2>

<div>

<mcr:includeWebContent file="feedback.html" />


</div>
<div>
<br /><br />
<script type="text/javascript"><!--
function chkFormular()
{
/*
if(document.getElementById("Formular").Ansprechpartner.value=="")
{
alert("Bitte den Ansprechpartner eingeben!");
document.getElementById("Formular").Ansprechpartner.focus();
return false;
}
*/
/*if(document.getElementById("Formular").EMail.value=="")
{
alert("Bitte die E-Mail-Adresse eingeben!");
document.getElementById("Formular").EMail.focus();
return false;
}
if(document.getElementById("Formular").EMail.value.indexOf('@') == -1)
{
alert("Keine gueltige E-Mail-Adresse!");
document.getElementById("Formular").EMail.focus();
return false;
}
if(document.getElementById("Formular").EMail.value.indexOf('.') == -1)
{
alert("Keine gueltige E-Mail-Adresse!");
document.getElementById("Formular").EMail.focus();
return false;
}*/
if(document.getElementById("Formular").Feedback.value=="")
{
alert("Bitte Ihr Feedback eingeben!");
document.getElementById("Formular").Feedback.focus();
return false;
}
}
// --></script>            
<form method="post" action="http://katalog.ub.uni-rostock.de/ubscript-cgi/qmailv2.pl" id="Formular" onsubmit="return chkFormular()">
<div>
<input type="hidden" name="type" value="21" />
<input name="sendto" type="hidden" value="unigeschichte@uni-rostock.de" />
<input name="cc" type="hidden" value="digibib.ub@uni-rostock.de" />
<input type="hidden" name="subject" value="Feedbackformular aus dem Catalogus Professorum" />
<input name="LANG" type="hidden" value="DU" />
<input name="return" type="hidden"  value="<c:out value='${returnurl}'/>" />
</div>



<table cellpadding="10px">
<tr>
<td style="width: 20%;">
<span style="font-weight: bold; color: #FF0000;">&nbsp;&nbsp;</span>
<span class="mcfontSmall">Empfänger:</span>
</td>
<td style="width: 80%;">
<div>unigeschichte@uni-rostock.de</div>
</td>
</tr>
<tr><td>&nbsp;</td></tr>
<tr>
<td style="width: 20%;">
<span style="font-weight: bold; color: #FF0000;">&nbsp;&nbsp;</span>
<span class="mcfontSmall">Ihre Angaben zu:</span>
</td>
<td style="width: 80%;">
<div>
	<input name="Professor_Name" type="hidden" value="${param.prof_name}" />
	<input name="Professor_URL" type="hidden" value="${returnurl}" />
	
	<b>
		<c:out value="${param.prof_name}" /><br />
		<c:out value="${param.prof_url}" /><br /><br /></b>	
</div>
</td>
</tr>

<tr>
<td style="width: 20%;">
<span style="font-weight: bold; color: #FF0000;">&nbsp;&nbsp;</span>
<span class="mcfontSmall">Ihr Name:</span>
</td>
<td style="width: 80%;">
<div>

<input type="text" style="width:450px;margin-bottom:16px" name="Ansprechpartner" />
</div>
</td>
</tr>
<tr>
<td style="width: 20%;" valign="top">
<span style="font-weight: bold; color: #FF0000;">&nbsp;&nbsp;</span>
<span class="mcfontSmall">Ihre E-Mail:</span>
</td>
<td style="width: 80%;">
<div>
<input type="text" style="width:450px;;margin-bottom:16px" name="EMail" />
</div>
</td>
</tr>

<tr>
<td style="width: 20%;" valign="top">
<span style="font-weight: bold; color: #FF0000;">*</span>
<span>Ihr Kommentar:</span>
</td>
<td style="width: 80%;">
<div>
<textarea style="width:650px; height:200px;"name="Feedback"></textarea>
</div>
</td>
</tr>
</table>
<div>



<br /><br />

</div>
<table>
<tr>
<td style="width: 20%;">
<input type="submit" value="Abschicken" />
</td>
<td style="width: 80%;">
<input type="reset" value="Eingabe l&ouml;schen" />
</td>
</tr>
</table>


</form>


</stripes:layout-component>
</stripes:layout-render>
