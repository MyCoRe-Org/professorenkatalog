<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd" %>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>
<%-- Parameter: id - the MCR Object ID--%>
<%-- Parameter: fromWF - from Workflow or database --%>


	<%--Tab bar (begin) --%>
	<c:set var="tab" value="${param.tab}" />
	<c:if test="${empty tab}"><c:set var="tab" value="data" /></c:if>
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<mcr:retrieveObject mcrid="${param.id}" varDOM="mcrobj" cache="true" fromWorkflow="${param.fromWF}" />
    
    <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/header.xsl" />
	
    <c:if test="${not(param.print eq 'true')}">
		<c:if test="${param.fromWF eq 'true'}">
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
							<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
								<i class="fas fa-user docdetails-tabbar-icon"></i>
								<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
						</li>
					</c:if>
					<c:if test="${current eq 'article'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
									<i class="fas fa-book docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>		
					</c:if>
					<c:if test="${current eq 'documents'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
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

<mcrdd:docdetails mcrID="${param.id}" lang="de" fromWorkflow="${param.fromWF}" var="doc" outputStyle="headlines"> 
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
    
 
   	
   	<c:if test="${param.fromWF eq 'true'}">
		<div class="alert alert-info" style="margin-top:20px" role="alert">
			<h4 style="margin:5px 0px">
				<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
				<fmt:message key="WF.Preview" />
			</h4>
		</div>
	</c:if>	
  </mcrdd:docdetails>