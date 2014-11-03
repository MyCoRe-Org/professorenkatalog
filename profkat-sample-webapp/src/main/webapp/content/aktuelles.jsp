<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcr"
	uri="http://www.mycore.org/jspdocportal/base.tld"%>
<%@ taglib prefix="stripes"
	uri="http://stripes.sourceforge.net/stripes.tld"%>

<fmt:message var="pageTitle" key="Nav.Aktuelles" />
<stripes:layout-render name="../WEB-INF/layout/default.jsp"
	pageTitle="${pageTitle}">
	<stripes:layout-component name="contents">
		<h2>${pageTitle}</h2>
		<div>
			<mcr:includeWebcontent id="aktuelles" file="aktuelles.html" />
		</div>
	</stripes:layout-component>
</stripes:layout-render>
