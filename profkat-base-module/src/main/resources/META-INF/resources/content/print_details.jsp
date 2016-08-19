<%@page import="org.mycore.backend.hibernate.MCRHIBConnection"%>
<%@page import="org.mycore.common.MCRException"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%--
     Make the JSTL-core and the JSTL-fmt taglibs available
     within this page. JSTL is the Java Standard Tag Library,
     which defines a set of commonly used elements
     The prefix to be used for core-tags is "c"
     The prefix to be used for fmt-tags is "fmt"
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld"%>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>

<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
<c:set var="mcrid">
	<c:choose>
		<c:when test="${!empty requestScope.id}">${requestScope.id}</c:when>
		<c:otherwise>${param.id}</c:otherwise>
	</c:choose>
</c:set>
<c:set var="from" value="${param.from}" />

<mcr:setLanguage var="lang" allowedLanguages="de" />

<html>
<head>
<title>Print Details</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="${WebApplicationBaseURL}webjars/jquery/1.11.3/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="${WebApplicationBaseURL}webjars/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="${WebApplicationBaseURL}webjars/bootstrap/3.3.5/css/bootstrap.min.css" />
<link type="text/css" rel="stylesheet"	href="${WebApplicationBaseURL}themes/uni-rostock/css/uni-rostock_bootstrap.css" />
<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}themes/cpr/css/cpr.css" />
<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_docdetails_headlines.css" />
<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_biogr_article.css" />
</head>
<style type="text/css">
body {
	background: white;
}
</style>
</head>
<body bgcolor="#FFFFFF">
	<%
		Logger logger = Logger.getLogger(this.getClass());
		Transaction tx = MCRHIBConnection.instance().getSession().beginTransaction();
		try {
	%>
	<mcr:receiveMcrObjAsJdom mcrid="${mcrid}" varDom="linked"
		fromWF="${from}" />

	<div class="base_content text">

		<c:set var="mcrid" value="${param.id}" />
		<div class="container">
			<div class="row">
				<div class="col-xs-9">
					<c:choose>
						<c:when test="${fn:contains(mcrid,'person')}">
							<c:import url="docdetails/docdetails_person.jsp" />
						</c:when>
						<c:otherwise>
							<c:import url="docdetails/docdetails-document.jsp" />
						</c:otherwise>
					</c:choose>
				</div>

				<div class="col-xs-2">
					<x:if
						select="$linked/mycoreobject/structure/derobjects/derobject[@xlink:title='display_portrait']">
						<div class="base_box infobox">
							<search:derivate-image mcrid="${mcrid}" width="100%"
								showFooter="true" protectDownload="true" labelContains="display_portrait" />
							<search:derivate-image mcrid="${mcrid}" width="100%"
								 protectDownload="true" labelContains="display_signature" />
						</div>
					</x:if>
				</div>
			</div>


		</div>
	</div>


	<%
		} catch (MCRException e) {
			logger.error(e);
			pageContext.getOut().append(e.getMessage());
		} finally {
			if (!tx.wasCommitted()) {
				tx.commit();
			}
		}
	%>
</body>
</html>