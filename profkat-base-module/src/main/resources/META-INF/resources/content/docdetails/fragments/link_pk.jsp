<%@page import="org.mycore.common.config.MCRConfiguration"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr"%>

<%-- JSP-Parameter: href, title --%>

<%
	pageContext.setAttribute("wbisIPMap", MCRConfiguration.instance().getPropertiesMap("MCR.profkat.WBIS.user-ip."));
%>

<c:set var="WebApplicationBaseURL" value="${applicationScope.WebApplicationBaseURL}" />
<c:set var="location">${param.href}</c:set>
<c:set var="descr">${param.title}</c:set>

<c:if test="${descr eq '#'}">
	<c:set var="descr" value="" />
</c:if>
<%-- ADD WBIS user parameter from mycore.properties --%>
<c:if test="${fn:contains(location, 'db.saur.de/WBIS')}">
	<c:set var="location">#</c:set>
	<c:set var="ip">${header["X-FORWARDED-FOR"]}</c:set>
	<c:if test="${empty ip}"><c:set var="ip">${requestScope["JK_REMOTE_ADDR"]}</c:set></c:if>
	<c:if test="${empty ip}"><c:set var="ip">${pageContext.request.remoteAddr}</c:set></c:if>
	<%-- IPCHECK: ${ip}
		 HTTP-Header ("X-FORWARDED-FOR"): ${header["X-FORWARDED-FOR"]}
		 Request-Attribute ("JK_REMOTE_ADDR"): ${requestScope["JK_REMOTE_ADDR"]}
		 Request-RemoteAddress: ${pageContext.request.remoteAddr}
		 Request-LocalAddress: ${pageContext.request.localAddr}
	 --%>
	<c:forEach var="entry" items="${wbisIPMap}">
  		<c:if test="${ip.matches(entry.value)}">
  			<c:set var="location">${param.href}&user=${fn:replace(entry.key,'MCR.profkat.WBIS.user-ip.','')}</c:set>
  		</c:if>
	</c:forEach>
</c:if>

<c:choose>
	<c:when test="${location eq '#'}">
		<c:out value="${descr}" escapeXml="false" />
	</c:when>
	<c:otherwise>
		<c:out value="${descr}" escapeXml="false" />
		<jsp:element name="a">	
			<jsp:attribute name="href">
				<c:out value="${location}" />
			</jsp:attribute>
			<jsp:attribute name="target">_blank</jsp:attribute>
			<jsp:body>
				<c:choose>
					<c:when test="${fn:contains(location, 'rosdok')}">
			    		<nobr>(<fmt:message key="OMD.profkat.link.internal" />
			    			   <img src="${WebApplicationBaseURL}images/link_intern.png"
							alt="interner Link" />)</nobr>
			     	</c:when>
			        <c:otherwise>
			    		<nobr> (<fmt:message key="OMD.profkat.link.external" />
			    			   <img src="${WebApplicationBaseURL}images/link_extern.png"
							alt="externer Link" />)</nobr>
			    	</c:otherwise>
		      	</c:choose>
			</jsp:body>	
		</jsp:element>
	</c:otherwise>
</c:choose>