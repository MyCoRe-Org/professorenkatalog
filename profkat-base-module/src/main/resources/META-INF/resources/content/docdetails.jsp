<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.net.URLEncoder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrb" uri="http://www.mycore.org/jspdocportal/browsing.tld" %>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<c:set var="mcrid">
   		<c:choose>
      		<c:when test="${!empty requestScope.id}">${requestScope.id}</c:when>
      		<c:otherwise>${param.id}</c:otherwise>
   		</c:choose>
	</c:set>
	<c:set var="from"  value="${param.fromWF}" /> 
	<c:set var="debug" value="${param.debug}" />
	<c:set var="style" value="${param.style}" />
	<c:set var="type"  value="${fn:split(mcrid,'_')[1]}" />
	<c:if test="${empty from}">
		<c:set var="from" value="false" />
	</c:if>	

	 
	<c:choose>
 		<c:when test="${from}" >
     		<c:set var="layout" value="preview" />
 		</c:when>
 		<c:otherwise>
     		<c:set var="layout" value="normal" />
 		</c:otherwise> 
	</c:choose>

	<mcr:receiveMcrObjAsJdom mcrid="${mcrid}" varDom="linked" fromWF="${from}"/>
	<c:set var="prof_name">
		<x:out select="$linked/mycoreobject/metadata/box.surname/surname" />,
    	<x:out select="$linked/mycoreobject/metadata/box.firstname/firstname" />
    	<c:set var="affix"><x:out select="$linked/mycoreobject/metadata/box.nameaffix/nameaffix" /></c:set>
		<c:if test="${fn:length(affix)>2}">(<c:out value="${affix}" />)</c:if>
	</c:set>
	
	<c:set var="layout_name">3columns</c:set>
	<c:if test="${not empty param.print}"><c:set var="layout_name">1column</c:set></c:if>

 
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle="${pageTitle}" layout="${layout_name}">
	<stripes:layout-component name="html_header">
		<meta name="description" lang="de"
	          content="Im Catalogus Professorum Rostochiensium (Rostocker Professorenkatalog) sollen alle an der Universität Rostock seit 1419 tätigen Professoren mit Angaben zur Person, zum wissenschaftlichen Profil und zu den Aktivitäten an der Rostocker Hochschule dokumentiert werden." />
		<meta name="author" content="Forschungsstelle Universitätsgeschichte der Universität Rostock" />
				<title>${prof_name} @ <fmt:message key="Webpage.title" /></title>
		<link rel="canonical" href="${WebApplicationBaseURL}/metadata/${mcrid}" />
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_docdetails_headlines.css" />
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_biogr_article.css" />		
 	</stripes:layout-component>


	<stripes:layout-component name="contents">
		<mcr:debugInfo />
		<jsp:include page="docdetails/docdetails_person.jsp">
   			<jsp:param name="id" value="${mcrid}" />
   			<jsp:param name="fromWF" value="${from}" />
   		</jsp:include>
 	</stripes:layout-component>
 	
	 <stripes:layout-component name="right_side">
		<div class="ur-box ur-box-bordered infobox" style="margin-bottom:32px; padding: 18px 6px 6px 6px;">
			<mcrb:searchDetailBrowser mcrid="${mcrid}"/>
			
			
					<c:if test="${empty param.print and !fn:contains(style,'user')}">
  						<a class="btn btn-default btn-lg" style="padding:6px" href="${WebApplicationBaseURL}content/print_details.jsp?id=${param.id}&amp;print=true&amp;fromWF=${param.fromWF}" target="_blank" title="<fmt:message key="WF.common.printdetails" />">
	       					<span class="glyphicon glyphicon-print"></span>
	       				</a>
					</c:if>
    
     				<c:if test="${empty param.print}">
     					<c:set var="url">${WebApplicationBaseURL}resolve/id/${param.id}</c:set>
		   				<a class="btn btn-default btn-lg" style="padding:6px" target="_blank" title="<fmt:message key="Webpage.feedback" />"
		   				   href="${WebApplicationBaseURL}feedback.action?topicURL=<%=java.net.URLEncoder.encode(pageContext.getAttribute("url").toString(), "ISO-8859-1")%>&amp;topicHeader=<%=java.net.URLEncoder.encode(pageContext.getAttribute("prof_name").toString().replaceAll("\\s+"," "), "ISO-8859-1")%>">
	    	       			<span class="glyphiconn glyphicon-envelope"></span>
	        			</a>
	         		</c:if>
     				<c:if test="${(not from)}" > 
     					<mcr:hasAccess var="modifyAllowed" permission="writedb" mcrid="${mcrid}" />
     					<mcr:isLocked var="locked" mcrid="${mcrid}" />
      					<c:if test="${modifyAllowed}">
        					<c:choose>
         						<c:when test="${not locked}"> 
		         					<!--  Editbutton -->
									<a class="btn btn-primary btn-lg" style="padding:6px" 
									   href="${WebApplicationBaseURL}startedit.action?mcrid=${mcrid}" title="<fmt:message key="WF.common.object.EditObject" />">
		   								<span class="glyphicon glyphicon-pencil"></span>
		   							</a> 
	         					</c:when>
         						<c:otherwise>
           							<button class="btn btn-default btn-lg" style="padding:6px" disabled="disabled" 
           							        title="<fmt:message key="WF.common.object.EditObjectIsLocked" />">
		   								<span class="glyphicon glyphicon-ban-circle"></span>
           							</button>
         					</c:otherwise>
        				</c:choose>
        
          				<!--  RTF Export -->
           				<a class="btn btn-default btn-lg" style="padding:6px" href="${WebApplicationBaseURL}servlets/CPR2RTFServlet?id=${param.id}" target="_blank" 
           					title="<fmt:message key="WF.common.rtfexport" />">
        					<span class="glyphicon glyphicon-book"></span>
        				</a>        
        			</c:if>      
   				</c:if>
			</div>

		
		<x:if select="$linked/mycoreobject/structure/derobjects/derobject[@xlink:title='display_portrait' or @xlink:title='display_signature']">
			
			<div class="ur-box ur-box-bordered infobox">
				<mcrb:derivateImageBrowser mcrid="${mcrid}" imageWidth="100%" labelContains="display_portrait" />
				<mcrb:derivateImageBrowser mcrid="${mcrid}" imageWidth="100%" labelContains="display_signature" />
			</div>
		</x:if>
	</stripes:layout-component>
</stripes:layout-render>