<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcrb" uri="http://www.mycore.org/jspdocportal/browsing.tld"%>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld"%>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld"%>

<fmt:setLocale value="${requestScope.lang}" />
<c:choose>
	<c:when test="${fn:contains(requestScope.path,'browse')}">
		<fmt:message var="headline" key="Webpage.searchresults.result-document-browse" />
	</c:when>
	<c:otherwise>
		<fmt:message var="headline" key="Webpage.searchresults.result-document-search" />
	</c:otherwise>
</c:choose>

<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle="${headline}">
	<stripes:layout-component name="html_header">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_searchresult.css" />
	</stripes:layout-component>

	<stripes:layout-component name="contents">
		<div class="ur-box">
			<div class="ur-text">
			<h1>${headline}</h1>
			<mcr:debugInfo />
		</div>
		<mcrb:searchresultBrowser varmcrid="mcrid" varurl="url" result ="${actionBean.result}" sortfields="profkat_idx_profkat modified">
			<c:set var="doctype" value="${fn:substringBefore(fn:substringAfter(mcrid, '_'),'_')}" />
			<c:catch var="catchException">
				<jsp:include page="resultdetails/resultdetails_${doctype}.jsp">
					<jsp:param name="id" value="${mcrid}" />
					<jsp:param name="url" value="${url}" />
				</jsp:include>
			</c:catch>
			<c:if test="${catchException!=null}">
				<br />
					An error occured while displaying resultlist details for ${doctype} : ${catchException.message}
				<br />
			</c:if>
			
		</mcrb:searchresultBrowser>
	</div>
	</stripes:layout-component>
</stripes:layout-render>
