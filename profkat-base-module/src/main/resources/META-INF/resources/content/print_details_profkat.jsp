<%@page import="org.mycore.frontend.jsp.MCRHibernateTransactionWrapper"%>
<%@ page contentType="text/html;charset=UTF-8"%>

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
	try (MCRHibernateTransactionWrapper mtw = new MCRHibernateTransactionWrapper()) {
	%>
	 <mcr:retrieveObject mcrid="${mcrid}" varDOM="linked" cache="true" fromWorkflow="${from}" />
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
							<search:derivate-image mcrobj="${mcrid}" width="100%" showFooter="true" category="display_portrait" />
							<search:derivate-image mcrobj="${mcrid}" width="100%" category="display_signature" />
						</div>
					</x:if>
				</div>
			</div>


		</div>
	</div>


	<%
		}
	%>
</body>
</html>