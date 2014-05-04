<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrb" uri="http://www.mycore.org/jspdocportal/browsing.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="Nav.ClassificationsSearch" />
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle="${pageTitle}" layout="2columns">
	<stripes:layout-component name="html_header">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_classification-browser.css">
	</stripes:layout-component>
    <stripes:layout-component name="contents">
		<h2><fmt:message key="Webpage.browse.title.subject" /></h2>
		<mcr:includeWebContent file="browse_bkl_intro.html" />

		<mcrb:classificationBrowser classification="cpr_class_cprbkl"
			count="true" hideemptyleaves="true" expand="false"
			searchfield="class_bkl" searchmask="~searchstart-classcpr_bkl"
			searchrestriction="objectType=person" showdescription="true"
			showuri="false" showid="false" />
	</stripes:layout-component>
</stripes:layout-render>