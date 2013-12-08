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

	<mcr:debugInfo />
	
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
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_docdetails.css">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_biogr_article.css">		
 	</stripes:layout-component>


	<stripes:layout-component name="contents">
		<jsp:include page="/content/docdetails/docdetails_person.jsp">
   			<jsp:param name="id" value="${mcrid}" />
   			<jsp:param name="fromWF" value="${from}" />
   		</jsp:include>
 	</stripes:layout-component>
 	
	 <stripes:layout-component name="right_side">
		<div class="base_box infobox">
			<div class="docdetails-toolbar">
				<div class="docdetails-toolbar-item">
					<mcrb:searchDetailBrowser/>
				</div>
				<div style="clear: both;"></div>
			</div>
    		<div class="docdetails-toolbar">
    			<c:if test="${empty param.print and !fn:contains(style,'user')}">
     				<div class="docdetails-toolbar-item">
		   				<a href="${WebApplicationBaseURL}content/print_details.jsp?id=${param.id}&print=true&fromWF=${param.fromWF}" target="_blank">
	       					<img height="24px" src="${WebApplicationBaseURL}images/workflow_print.gif" border="0" title="<fmt:message key="WF.common.printdetails" />"  class="imagebutton" height="30"/>
	       				</a>
	       			</div>
     			</c:if>
    
     			<c:if test="${empty param.print}">
     				<c:set var="url">${WebApplicationBaseURL}metadata/${param.id}</c:set>
     					<div class="docdetails-toolbar-item">
		     			<a target="_blank" href="${WebApplicationBaseURL}nav?path=~feedback&prof_url=<%=java.net.URLEncoder.encode(pageContext.getAttribute("url").toString(), "ISO-8859-1")%>&prof_name=<%=java.net.URLEncoder.encode(pageContext.getAttribute("prof_name").toString().replace("\n",""), "ISO-8859-1")%>">
	    	    			<img height="24px" src="${WebApplicationBaseURL}images/feedback.gif" border="0" title="<fmt:message key="WF.professorum.feedback" />"  class="imagebutton" height="30"/>
	        			</a>
	         		</div>
     			</c:if>
     			<c:if test="${(not from)}" > 
     				<mcr:checkAccess var="modifyAllowed" permission="writedb" key="${mcrid}" />
     				<mcr:isObjectNotLocked var="bhasAccess" objectid="${mcrid}" />
      				<c:if test="${modifyAllowed}">
        				<c:choose>
         					<c:when test="${bhasAccess}"> 
		         				<!--  Editbutton -->
								<div class="docdetails-toolbar-item">
	    	     					<form method="get" action="${WebApplicationBaseURL}StartEdit" class="resort">                 
	        	    					<input name="page" value="nav?path=~workflowEditor-${type}"  type="hidden">                                       
	            						<input name="mcrid" value="${mcrid}" type="hidden"/>
										<input title="<fmt:message key="WF.common.object.EditObject" />" src="${WebApplicationBaseURL}images/workflow1.gif" type="image"  class="imagebutton" height="24px" />
	         						</form> 
	         					</div>
         					</c:when>
         					<c:otherwise>
           						<div class="docdetails-toolbar-item">  
           							<img height="24px" title="<fmt:message key="WF.common.object.EditObjectIsLocked" />" border="0" src="${WebApplicationBaseURL}images/workflow_locked.gif" height="30" />
           						</div>
         					</c:otherwise>
        				</c:choose>
        
        				<!--  RTF Export -->
        				<div class="docdetails-toolbar-item"> 
        					<a href="${WebApplicationBaseURL}servlets/CPR2RTFServlet?id=${param.id}" target="_blank">
          						<img height="24px" src="${WebApplicationBaseURL}images/workflow_rtf_export.gif" border="0" title="<fmt:message key="WF.common.rtfexport" />"  class="imagebutton" height="30"/>
           					</a>        
         				</div>
      				</c:if>      
   				</c:if>
   				<div style="clear:both;"></div>
			</div>
		</div>
		
		<x:if select="$linked/mycoreobject/structure/derobjects/derobject[@xlink:label='display_image']">
			<div class="base_box infobox">
				<mcrb:derivateImageBrowser mcrid="${mcrid}" imageWidth="150" labelContains="display_image" />
			</div>
		</x:if>
	</stripes:layout-component>
</stripes:layout-render>