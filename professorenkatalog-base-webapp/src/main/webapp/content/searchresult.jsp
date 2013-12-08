<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="errorpage.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcr"
	uri="http://www.mycore.org/jspdocportal/base.tld"%>
<%@ taglib prefix="mcrb"
	uri="http://www.mycore.org/jspdocportal/browsing.tld"%>
<%@ taglib prefix="stripes"
	uri="http://stripes.sourceforge.net/stripes.tld"%>

<stripes:layout-render name="../WEB-INF/layout/default.jsp"
	layout="3columns">
	<stripes:layout-component name="html_header">
		<link type="text/css" rel="stylesheet"
			href="${WebApplicationBaseURL}css/style_searchresult.css">
		<meta name="robots" content="nofollow" />
	</stripes:layout-component>
	<stripes:layout-component name="contents">
		<fmt:setBundle basename="messages" />
		<c:choose>
			<c:when test="${fn:contains(requestScope.path,'browse')}">
				<fmt:message var="headline"
					key="Webpage.Searchresult.result-document-browse" />
			</c:when>
			<c:otherwise>
				<fmt:message var="headline"
					key="Webpage.Searchresult.result-document-search" />
			</c:otherwise>
		</c:choose>

		<h2>${headline}</h2>
		<mcr:debugInfo />
		<mcrb:searchresultBrowser varmcrid="mcrid" varurl="url"
			sortfields="profsortname rostockdate_ivon rostockdate_ibis class_fac_sort profstates modified">
			<jsp:include page="resultdetails/resultdetails_person.jsp">
				<jsp:param name="id" value="${mcrid}" />
				<jsp:param name="url" value="${url}" />
			</jsp:include>
		</mcrb:searchresultBrowser>
	</stripes:layout-component>
</stripes:layout-render>
