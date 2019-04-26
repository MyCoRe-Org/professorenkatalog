<%@ page isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
<%
((HttpServletResponse) response).setStatus(HttpServletResponse.SC_NOT_FOUND);
%>
<fmt:message var="pageTitle" key="Webpage.error.Error" />
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle="${pageTitle}">
    <stripes:layout-component name="main_part">	
		<h2><span style="color:red">Fehler:<br /></span>F�r die GND-Nummer: ${param.gnd} wurde kein Datensatz gefunden</h2>
		<div>
			<p>
				Der Catalogus Professorum l�st nur GND-Nummern f�r Professoren und Professorinnen der Universit�t Rostock auf.
			</p>
			<p>
				Die von Ihnen verwendete GND-Nummer: <strong>${param.gnd}</strong> konnte nicht gefunden werden.
			</p>
			<p>
				Wenn es sich um einen neu berufenen Professor / Professorin handelt, kann es sein, 
				dass noch kein Datensatz angelegt wurde. Probieren Sie es bitte sp�ter noch einmal.
			</p>
			<p>
				Bitte �berpr�fen Sie, ob die verwendete GND-Nummer korrekt ist und informieren Sie ggf. die Forschungsstelle
				Universit�tsgeschichte (unigeschichte@uni-rostock.de).
			</p>
		</div>
	</stripes:layout-component>
</stripes:layout-render>
</body>
</html>