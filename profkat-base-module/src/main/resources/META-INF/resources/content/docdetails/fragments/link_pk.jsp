<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr"%>

<%-- JSP-Parameter: href, title --%>

<c:set var="WebApplicationBaseURL" value="${applicationScope.WebApplicationBaseURL}" />
<c:set var="location">${param.href}</c:set>
<c:set var="descr">${param.title}</c:set>

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
			    			   <img src="${WebApplicationBaseURL}images/link_intern.png"
							alt="interner Link" />)</nobr>
			     	</c:when>
			        <c:otherwise>
			    		<nobr> (<fmt:message key="OMD.CPR.link.external" />
			    			   <img src="${WebApplicationBaseURL}images/link_extern.png"
							alt="externer Link" />)</nobr>
			    	</c:otherwise>
		      	</c:choose>
			</jsp:body>	
		</jsp:element>
	</c:otherwise>
</c:choose>