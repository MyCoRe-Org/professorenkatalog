<%@page import="org.mycore.backend.hibernate.MCRHIBConnection"%>
<%@page import="org.mycore.common.MCRException"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.apache.log4j.Logger"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%--
     Make the JSTL-core and the JSTL-fmt taglibs available
     within this page. JSTL is the Java Standard Tag Library,
     which defines a set of commonly used elements
     The prefix to be used for core-tags is "c"
     The prefix to be used for fmt-tags is "fmt"
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld" %>
<%@ taglib prefix="mcrb" uri="http://www.mycore.org/jspdocportal/browsing.tld" %>



<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<c:set var="mcrid">
   		<c:choose>
      		<c:when test="${!empty requestScope.id}">${requestScope.id}</c:when>
      		<c:otherwise>${param.id}</c:otherwise>
   		</c:choose>
	</c:set>
	<c:set var="from"  value="${param.from}" />

<mcr:session method="get" type="language" var="lang" />
<fmt:setLocale value="${lang}" scope="session" />
<fmt:setBundle basename="messages" scope="session" />

<html>
<head><title>Print Details</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="shortcut icon" href="${applicationScope.WebApplicationBaseURL}images/icon_cpr.ico" />
	<link type="text/css" rel="stylesheet" href="${applicationScope.WebApplicationBaseURL}css/style_reset.css" />
	<link type="text/css" rel="stylesheet" href="${applicationScope.WebApplicationBaseURL}css/style_layout.css" />
	<link type="text/css" rel="stylesheet" href="${applicationScope.WebApplicationBaseURL}css/style_content.css" />
	<link type="text/css" rel="stylesheet" href="${applicationScope.WebApplicationBaseURL}css/style_docdetails_headlines.css" />
	<style type="text/css">
		body{
		background: white;
		}
	</style>
</head>
<body bgcolor="#FFFFFF">
<%
    Logger logger = Logger.getLogger(this.getClass());
    Transaction tx  = MCRHIBConnection.instance().getSession().beginTransaction();
	try{
%>
<mcr:receiveMcrObjAsJdom mcrid="${mcrid}" varDom="linked" fromWF="${from}"/>
<table><tr ><td  style="vertical-align: top;">
<div>
<div class="base_content text">

<c:set var="mcrid" value="${param.id}" />

<c:choose>
 <c:when test="${fn:contains(mcrid,'codice')}">
     <c:import url="docdetails/docdetails-codice.jsp" />
 </c:when>
 
 <c:when test="${fn:contains(mcrid,'thesis')}">
     <c:import url="docdetails/docdetails_thesis.jsp" />
 </c:when>
 
 <c:when test="${fn:contains(mcrid,'disshab')}">
     <c:import url="docdetails/docdetails_disshab.jsp" />
 </c:when>
 
 
 <c:when test="${fn:contains(mcrid,'person')}">
     <c:import url="docdetails/docdetails_person.jsp" />
 </c:when>
 
  <c:when test="${fn:contains(mcrid,'institution')}">
     <c:import url="docdetails/docdetails_institution.jsp" />
 </c:when> 
 
  <c:when test="${fn:contains(mcrid,'document')}">
     <c:import url="docdetails/docdetails_document.jsp" />
 </c:when>

 <c:when test="${fn:contains(mcrid,'_series_')}">
     <c:import url="docdetails/docdetails_series.jsp" />
 </c:when>
 
 <c:when test="${fn:contains(mcrid,'_series-volume_')}">
     <c:import url="docdetails/docdetails_series-volume.jsp" />
 </c:when>
 
 <c:otherwise>
     <c:import url="docdetails/docdetails-document.jsp" />
 </c:otherwise>
 </c:choose>
  </div>
  </div>
 </td>
 <td>
 
	<x:if select="$linked/mycoreobject/structure/derobjects/derobject[@xlink:label='display_image']">
		<div class="base_box infobox">
			<mcrb:derivateImageBrowser mcrid="${mcrid}" imageWidth="150" labelContains="display_image" />
		</div>
	</x:if>
	
</td>
</tr>
</table>

<% }	
	catch(MCRException e){
		logger.error(e);
		pageContext.getOut().append(e.getMessage());
	}
	finally{
		if (!tx.wasCommitted()){
			tx.commit();
		}
	}
	%>
</body>
</html>