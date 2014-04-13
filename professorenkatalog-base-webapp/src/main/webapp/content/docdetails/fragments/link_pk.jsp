<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr"%>
<!-- $data as xml element representing mcrlink object --->
<c:set var="WebApplicationBaseURL"
	value="${applicationScope.WebApplicationBaseURL}" />

<%--
<c:set var="location"><x:out select="string($data/@*[local-name='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
<c:set var="descr"><x:out select="string($data/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
--%>
<x:set var="location"
	select="string($data/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" />
<x:set var="descr"
	select="string($data/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" />

<c:if test="${descr eq '#'}">
	<c:set var="descr" value="" />
</c:if>
<c:choose>
	<c:when test="${location eq '#'}">
		<c:out value="${descr}" />
	</c:when>
	<c:otherwise>
		<c:out value="${descr}" />
		<jsp:element name="a">	
			<jsp:attribute name="href">
				<c:out value="${location}" />
			</jsp:attribute>
			<jsp:attribute name="target">_blank</jsp:attribute>
			<jsp:body>
				<c:choose>
					<c:when test="${fn:contains(location, 'rosdok')}">
			    		<nobr>(<fmt:message key="OMD.CPR.link.internal" />
			    			   <img src="${WebApplicationBaseURL}images/link_intern.gif"
							alt="interner Link" />)</nobr>
			     	</c:when>
			        <c:otherwise>
			    		<nobr> (<fmt:message key="OMD.CPR.link.external" />
			    			   <img src="${WebApplicationBaseURL}images/link_extern.gif"
							alt="externer Link" />)</nobr>
			    	</c:otherwise>
		      	</c:choose>
			</jsp:body>	
		</jsp:element>
	</c:otherwise>
</c:choose>