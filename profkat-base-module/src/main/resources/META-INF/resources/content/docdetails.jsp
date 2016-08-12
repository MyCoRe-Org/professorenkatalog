<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.net.URLEncoder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>

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

 <c:set var="pageTitle">${prof_name}</c:set>
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle="${pageTitle}" layout="${layout_name}">
	<stripes:layout-component name="html_header">
		<meta name="description" lang="de"
	          content="Im Catalogus Professorum Rostochiensium (Rostocker Professorenkatalog) sollen alle an der Universität Rostock seit 1419 tätigen Professoren mit Angaben zur Person, zum wissenschaftlichen Profil und zu den Aktivitäten an der Rostocker Hochschule dokumentiert werden." />
		<meta name="author" content="Forschungsstelle Universitätsgeschichte der Universität Rostock" />
		<link rel="canonical" href="${WebApplicationBaseURL}resolve/id/${mcrid}" />
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
		<div class="docdetails-infobox ur-box ur-box-bordered ur-infobox" style="margin-bottom:32px; padding: 18px 6px 6px 6px;">
			<search:result-navigator mcrid="${mcrid}" />
			
			<div class="container-fluid">
				<c:if test="${empty param.print}">
					<div class="row" style="padding-bottom:6px">
     					<c:set var="url">${WebApplicationBaseURL}resolve/id/${param.id}</c:set>
		   				<a class="btn btn-default btn-sm col-xs-12" style="text-align:left;" target="_blank" title="<fmt:message key="Webpage.feedback" />"
		   		   		   href="${WebApplicationBaseURL}feedback.action?topicURL=<%=java.net.URLEncoder.encode(pageContext.getAttribute("url").toString(), "UTF-8")%>&amp;topicHeader=<%=java.net.URLEncoder.encode(pageContext.getAttribute("prof_name").toString().replaceAll("\\s+"," "), "UTF-8")%>">
	    					<span class="glyphicon glyphicon-comment"></span> <fmt:message key="Webpage.feedback.button"/>
	    				</a>
	         		</div>
	         		<div class="row" style="padding-bottom:6px">
	         				<a class="btn btn-default btn-sm col-xs-5" style="text-align:left;margin-right:6px" href="${WebApplicationBaseURL}content/print_details.jsp?id=${param.id}&amp;print=true&amp;fromWF=${param.fromWF}" target="_blank" title="<fmt:message key="WF.common.printdetails" />">
	       						<span class="glyphicon glyphicon-print"></span> <fmt:message key="Webpage.print.button"/>
	       					</a>
	       		
	       		
	       				<c:if test="${(not from)}" >
	       						<search:show-edit-button mcrid="${mcrid}" cssClass="btn btn-sm btn-primary ir-edit-btn col-xs-3" />  
   						</c:if>
   			
		    	   		<button type="button" class="btn btn-default btn-sm pull-right hidden-xs" style="border:none;color:#DEDEDE;" 
		    	   		        data-toggle="collapse" data-target="#hiddenTools" title="<fmt:message key="Webpage.tools.menu4experts" />"
				   		   href="${WebApplicationBaseURL}api/v1/objects/${mcrid}">
	    					<span class="glyphicon glyphicon-wrench"></span>
	        			</a>
	      			</div>
	      			<div id="hiddenTools" class="collapse">
	      				<div class="row" style="padding-bottom:6px">
	      					<a class="btn btn-warning btn-sm" target="_blank" title="<fmt:message key="Webpage.tools.showXML" />"
				   		   		href="${WebApplicationBaseURL}api/v1/objects/${mcrid}" rel="nofollow">XML</a>
	        				<a class="btn btn-warning btn-sm" style="margin-left:6px" target="_blank" title="<fmt:message key="Webpage.tools.showSOLR" />"
				   		   		href="${WebApplicationBaseURL}receive/${mcrid}?XSL.Style=solrdocument" rel="nofollow">SOLR</a>
	      			</div>
	      			</div>
	         </c:if>

   			</div>
		</div>

		<x:if select="$linked/mycoreobject/structure/derobjects/derobject[@xlink:title='display_portrait' or @xlink:title='display_signature']">
			<div class="docdetails-infobox ur-box ur-box-bordered ur-infobox hidden-xs">
				<search:derivate-image mcrid="${mcrid}" width="100%" labelContains="display_portrait" showFooter="true" protectDownload="true" />
				<search:derivate-image mcrid="${mcrid}" width="100%" labelContains="display_signature" protectDownload="true" />
			</div>
		</x:if>
	</stripes:layout-component>
</stripes:layout-render>