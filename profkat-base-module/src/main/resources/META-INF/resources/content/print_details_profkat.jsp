<%@page import="org.mycore.jspdocportal.common.MCRHibernateTransactionWrapper"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>

<mcr:setNamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
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

<style type="text/css">
body {
	font-family: Arial, Helvetica, sans-serif;
	background:  white;
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