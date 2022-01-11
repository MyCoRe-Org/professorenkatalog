<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld" %>

<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>

	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<c:set var="mcrid">
   		<c:choose>
      		<c:when test="${!empty requestScope.id}">${requestScope.id}</c:when>
      		<c:otherwise>${it.id}</c:otherwise>
   		</c:choose>
	</c:set>
	<c:set var="from"  value="${param.fromWF}" /> 
	<c:set var="debug" value="${param.debug}" />
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

    <mcr:retrieveObject mcrid="${mcrid}" varDOM="linked" cache="true" fromWorkflow="${from}" />
	<c:set var="prof_name">
		<x:out select="$linked/mycoreobject/metadata/box.surname/surname" />,
    	<x:out select="$linked/mycoreobject/metadata/box.firstname/firstname" />
    	<c:set var="affix"><x:out select="$linked/mycoreobject/metadata/box.nameaffix/nameaffix" /></c:set>
		<c:if test="${fn:length(affix)>2}">(<c:out value="${affix}" />)</c:if>
	</c:set>
	
	<c:set var="layout_name">3columns</c:set>
	<c:if test="${not empty param.print}"><c:set var="layout_name">1column</c:set></c:if>

 <c:set var="pageTitle">${prof_name}</c:set>
 <mcr:retrieveObject mcrid="${mcrid}" varDOM="mcrobj" cache="true" fromWorkflow="false" />
 
 
<!doctype html>
<html>
<head>
  <%@ include file="fragments/html_head.jspf" %>
  <%--ggf. Metatags ergänzen <mcr:transformXSL dom="${doc}" xslt="xsl/docdetails/metatags_html.xsl" /> --%>
	    <!-- View: docdetails-profkat.jsp -->
	    
		<c:set var="description">
			<mcr:transformXSL dom="${mcrobj}" xslt="xsl/docdetails/person2html_header_description.xsl" />
      	</c:set>
    	<meta name="description" lang="de" content="${fn:trim(description)}" />
		<link rel="canonical" href="${WebApplicationBaseURL}resolve/id/${mcrid}" />
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_docdetails_headlines.css" />
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_biogr_article.css" />		

</head>
<body>
  <%@ include file="fragments/header.jspf" %>
  <div id="docdetails" class="container">
      
     <div class="row">
        <div id="docdetails-main" class="col docdetails">
		<mcr:debugInfo />
    
    
<c:set var="tab" value="${param.tab}" />
	<c:if test="${empty tab}"><c:set var="tab" value="data" /></c:if>
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<mcr:retrieveObject mcrid="${mcrid}" varDOM="mcrobj" cache="true" fromWorkflow="${fromWF}" />
    
    <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/header.xsl" />
	
    <c:if test="${not(param.print eq 'true')}">
		<c:if test="${from eq 'true'}">
				<div class="alert alert-info" style="margin-top:20px" role="alert">
					<h4 style="margin:5px 0px">
						<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
						<fmt:message key="WF.Preview" />
					</h4>
				</div>
		</c:if>
		<div  class="tabbar docdetails-tabbar" style="position:relative">
			<c:set var="msgKeyStatus">OMD.profkat.state.<x:out select="$mcrobj/mycoreobject/metadata/box.status/status"/></c:set>
			
			<c:set var="tabtokens" value="data|article|documents" />
			<ul id="tabs_on_page" class="nav nav-tabs" style="position:relative">
			 
				
				<c:forTokens items="${tabtokens}" delims="|" var="current" varStatus="status">
      				<c:set var="tabstyle" value="" /> 
					<c:if test="${current eq tab}">
						<c:set var="tabstyle" value="active" />
					</c:if>
					<c:if test="${current eq 'data'}">
						<li class="nav-item">
							<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${mcrid}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${from eq 'true' ? '&fromWF=true' : ''}">
								<i class="fas fa-user docdetails-tabbar-icon"></i>
								<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
						</li>
					</c:if>
					<c:if test="${current eq 'article'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${mcrid}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${from eq 'true' ? '&fromWF=true' : ''}">
									<i class="fas fa-book docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>		
					</c:if>
					<c:if test="${current eq 'documents'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${mcrid}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${from eq 'true' ? '&fromWF=true' : ''}">
									<i class="far fa-file docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>
					</c:if>
				</c:forTokens>
			</ul>
			<div class="docdetails-tabbar-info" style="position:absolute; top:5px; right:15px">
					<fmt:message key="${msgKeyStatus}" />
			</div>
		</div>
	</c:if>
	<%--Tab bar (end) --%>
  
  
   <c:if test="${(tab eq 'data') or (param.print eq 'true')}">
     <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/metadata.xsl" />
   </c:if>

<mcrdd:docdetails mcrID="${mcrid}" lang="de" fromWorkflow="${from}" var="doc" outputStyle="headlines"> 
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	 

  	
	<c:if test="${(tab eq 'article') or (param.print eq 'true')}">
  		<mcrdd:row select="/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']" labelkey="OMD.profkat.documents" showInfo="true" >
  			<mcrdd:derivatecontent select="." width="100%" encoding="UTF-8" />
  		</mcrdd:row>	
	</c:if>

	<c:if test="${(tab eq 'documents') or (param.print eq 'true')}">
		<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
			<div class="docdetails-block">
				<div class="card card-sm panel-copyright">
					<div class="card-body">
  						<fmt:message key="OMD.derivate.copyright.notice" />
	               </div>
				</div>
			</div>
		</x:if>
		<mcrdd:row select="/mycoreobject/structure/derobjects[./derobject]" labelkey="OMD.profkat.derobjects" showInfo="true" >
			<x:forEach var="x" select="$doc/mycoreobject/structure/derobjects/derobject/@xlink:href">
	 			 <c:set var="id"><x:out select="$x" /></c:set>
 				 <search:derivate-list derid="${id}" showSize="true" />
 		  </x:forEach>
	  	</mcrdd:row>
	</c:if>	
  	
  	<mcrdd:separator showLine="true" />
    
 
   	
   	<c:if test="${from eq 'true'}">
		<div class="alert alert-info" style="margin-top:20px" role="alert">
			<h4 style="margin:5px 0px">
				<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
				<fmt:message key="WF.Preview" />
			</h4>
		</div>
	</c:if>	
  </mcrdd:docdetails>
        </div>
        
        
        
        
        <div id="docdetails-right" class="col-3">
		<div class="docdetails-infobox" style="margin-bottom:32px;">
		    <div class="row">
		    <div class="col">
			<search:result-navigator mcrid="${mcrid}" />
			</div>
			</div>
			
	       <x:if select="starts-with($mcrobj/mycoreobject/@ID,'cpb_')">
	         <div class="row">
		       <div class="col">
			     <div id="citation" class="container ir-box ir-box-emph py-2">
  			       <div class="docdetails-label mt-0"><small><b><fmt:message key="OMD.profkat.quoting"/>:</b></small></div>
			         <c:set var="last"><x:out select="$mcrobj/mycoreobject/metadata/box.surname/surname" /></c:set>		
			         <c:set var="first"><x:out select="$mcrobj/mycoreobject/metadata/box.firstname/firstname" /></c:set>
			         <jsp:useBean id="now" class="java.util.Date" scope="page" />
			         <c:set var="currentID"><x:out select="$mcrobj/mycoreobject/@ID" /></c:set>
   			         <c:url var="url" value="${WebApplicationBaseURL}resolve/id/${currentID}" />
   			         <fmt:message key="OMD.profkat.quoting.text">
      			       <fmt:param>${first}&#160;${last}</fmt:param>
      			       <fmt:param>${url}</fmt:param>
      			       <fmt:param>${fn:replace(url,'/resolve/', ' /resolve/')}</fmt:param>
      			       <fmt:param><fmt:formatDate value="${now}" pattern="dd.MM.yyyy" /></fmt:param>
      		         </fmt:message>      			
			       </div>
			     </div>
			   </div>
			</x:if>
			
		     <c:if test="${empty param.print}">
					<div class="row mb-3">
					<div class="col">
     					<c:set var="url">${WebApplicationBaseURL}resolve/id/${it.id}</c:set>
		   				<a class="btn btn-outline-secondary btn-sm w-100" style="text-align:left;" target="_blank" title="<fmt:message key="Webpage.feedback" />"
		   		   		   href="${WebApplicationBaseURL}feedback.action?topicURL=<%=java.net.URLEncoder.encode(pageContext.getAttribute("url").toString(), "UTF-8")%>&amp;topicHeader=<%=java.net.URLEncoder.encode(pageContext.getAttribute("prof_name").toString().replaceAll("\\s+"," "), "UTF-8")%>">
	    					<i class="far fa-comments"></i> <fmt:message key="Webpage.feedback.button"/>
	    				</a>
	         		</div>
	         		</div>
	         		<div class="row mb-3">
	         		<div class="col">
	         				<a class="btn btn-outline-secondary btn-sm hidden-sm hidden-xs" style="text-align:left;margin-right:6px" href="${WebApplicationBaseURL}content/print_details_profkat.jsp?id=${it.id}&amp;print=true&amp;fromWF=${from}" target="_blank" title="<fmt:message key="WF.common.printdetails" />">
	       						<i class="fas fa-print"></i> <fmt:message key="Webpage.print.button"/>
	       					</a>
	       				<c:if test="${(not from)}" >
                                <mcr:showEditMenu mcrid="${mcrid}" cssClass="text-right pb-3" /> 
   						</c:if>
   			
		    	   		<button type="button" class="btn btn-default btn-sm float-right hidden-sm hidden-xs" style="border:none;color:#DEDEDE;" 
		    	   		        data-toggle="collapse" data-target="#hiddenTools" title="<fmt:message key="Webpage.tools.menu4experts" />">
	    					<i class="fas fa-tools"></i>
	        			</button>
	        			</div>
	      			</div>
	         		<div class="row mb-3">
	         		<div class="col">
	      			<div id="hiddenTools" class="collapse">
	      				<div class="row" style="padding-bottom:6px">
	      				  <div class="col">
	      					<a class="btn btn-warning btn-sm" target="_blank" title="<fmt:message key="Webpage.tools.showXML" />"
				   		   		href="${WebApplicationBaseURL}api/v2/objects/${mcrid}" rel="nofollow">XML</a>
	        				<a class="btn btn-warning btn-sm" style="margin-left:6px" target="_blank" title="<fmt:message key="Webpage.tools.showSOLR" />"
				   		   		href="${WebApplicationBaseURL}receive/${mcrid}?XSL.Style=solrdocument" rel="nofollow">SOLR</a>
				   		  </div>
	      			   </div>
	      			   </div>
	      			</div>
	      			</div>
	         </c:if>
		</div>
		<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[classification/@categid='display_portrait' or classification/@categid='display_signature']">
			
			<div class="docdetails-infobox hidden-xs" style="margin-left:auto;margin-right:auto">
			 		<div class="row mb-3">
	       		    <div class="col">
	       	
				<search:derivate-image mcrobj="${mcrobj}" width="100%" category="display_portrait" showFooter="true" protectDownload="true" />
				<search:derivate-image mcrobj="${mcrobj}" width="100%" category="display_signature" protectDownload="true" />
				</div>
				</div>
			</div>
		</x:if>
		        
        </div>
      </div>
      </div>
<%@ include file="fragments/footer.jspf" %>
</body>
</html>
