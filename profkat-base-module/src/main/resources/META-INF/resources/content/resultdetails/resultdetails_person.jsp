<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- Parameter: id - the MCR Object ID--%>
<%-- Parameter: url - the MCR Object ID--%>

<mcr:receiveMcrObjAsJdom mcrid="${param.id}" varDom="xml"/>
<c:set var="type" value="${fn:substringBefore(fn:substringAfter(param.id, '_'),'_')}" />
<div class="panel panel-default ur-searchresult-item-panel">
	<div class="panel-heading">
			<c:set var="title"><x:out select="$xml/mycoreobject/metadata/box.surname/surname[1]" />,&#160;
			<x:out select="$xml/mycoreobject/metadata/box.firstname/firstname[1]" />
			<x:if select="string-length($xml/metadata/box.nameaffix/nameaffix)>0">
				&#160;(<x:out select="$xml/mycoreobject/metadata/box.nameaffix/nameaffix" />)
			</x:if></c:set>
			<h4 class="panel-title"><a href="${param.url}"><b>${title}</b></a>
			<span class="badge pull-right"><x:out select="$xml/mycoreobject/@ID" /></span>
			</h4>
	</div>
	<div class="panel-body">
		<mcr:hasAccess var="modifyAllowed" permission="writedb" mcrid="${param.id}" />
 		<c:if test="${modifyAllowed}">
 			<mcr:isLocked var="locked" mcrid="${param.id}" />
 			<c:choose>
 				<c:when test="${not locked}">
 					<!--  Editbutton -->
 					<a class="btn btn-primary btn-lg pull-right" style="padding:6px" 
						href="${WebApplicationBaseURL}startedit.action?mcrid=${param.id}" title="<fmt:message key="WF.common.object.EditObject" />">
		   					<span class="glyphicon glyphicon-pencil"></span>
		   			</a> 
				</c:when>
				<c:otherwise>
					<button class="btn btn-default btn-lg pull-right" style="padding:6px" disabled="disabled" 
           				title="<fmt:message key="WF.common.object.EditObjectIsLocked" />">
		   				<span class="glyphicon glyphicon-ban-circle"></span>
           			</button>
				</c:otherwise>
			</c:choose>         
		</c:if>   
	
	
<table style="border-spacing:4px;border-collapse:separate;font-size:100%">
	<x:set var="data2" select="$xml/mycoreobject/metadata/box.professorship/professorship[last()]/event" /> 
	<x:if select="string-length($data2)>0">
		<tr>
			<th style="min-width:80px">
				<fmt:message key="OMD.common.last" />:
			</th>
			<td>
				<x:out select="$data2" />
			</td>
		</tr>
	</x:if>
	<x:set var="data3" select="$xml/mycoreobject/metadata/box.faculty/faculty[last()]/classification" /> 
	<x:if select="string-length($data3/@categid)>0">
		<tr>
			<th style="min-width:80px">
				<fmt:message key="OMD.common.last" />:
			</th>
		
			<td>
			    <c:set var="classid"><x:out select="$data3/@classid" /></c:set>
			    <c:set var="categid"><x:out select="$data3/@categid" /></c:set>
				<mcr:displayClassificationCategory lang="de" classid="${classid}" categid="${categid}"/>
			</td>
		</tr>
	</x:if>
	<x:set var="data4" select="$xml/mycoreobject/metadata/box.status/status" />
	<x:if select="string-length($data4)>0">
		<tr>
			<th style="min-width:80px">
				<fmt:message key="OMD.CPR.states" />:
			</th>
			<td>
			    <c:set var="x"><x:out select="$data4" /></c:set>
				<fmt:message key="OMD.CPR.states.${x}" />
			</td>
		</tr>
	</x:if>
 </table>
	</div>
</div>
 