<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!--  Request-Attribute resultDoc = org.apache.solr.common.SolrDocument -->
<c:set var="mcrid" value="${resultDoc.getFieldValueMap()['id']}" />
<span class="badge pull-right">${mcrid}</span>

<h4>
	<a href="${WebApplicationBaseURL}resolve/id/${mcrid}">${resultDoc.getFieldValueMap()['profkat.idx_headline']}</a>
</h4>
<mcr:hasAccess var="modifyAllowed" permission="writedb" mcrid="${mcrid}" />
	<c:if test="${modifyAllowed}">
		<mcr:isLocked var="locked" mcrid="${mcrid}" />
		<c:choose>
			<c:when test="${not locked}">
				<!--  Editbutton -->
				<a class="btn btn-primary btn-lg pull-right" style="padding:6px" 
				href="${WebApplicationBaseURL}startedit.action?mcrid=${mcrid}" title="<fmt:message key="WF.common.object.EditObject" />">
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
	

<table style="border-spacing: 4px; border-collapse: separate; font-size: 100%">
	<tr>
		<th style="min-width: 120px"><fmt:message key="Webpage.search.result.label.profkat.period" />:&#160;</th>
		<td>${resultDoc.getFieldValueMap()['profkat.period']}</td>
	</tr>
	<tr>
		<th style="min-width: 120px"><fmt:message key="Webpage.search.result.label.profkat.last_professorship" />:&#160;</th>
		<td>${resultDoc.getFieldValueMap()['profkat.last_professorship']}</td>
	</tr>
	<c:if test="${not empty resultDoc.getFieldValueMap()['profkat.last_faculty_class']}">
		<tr>
			<th style="min-width: 120px"><fmt:message key="Webpage.search.result.label.profkat.last_faculty_class" />:&#160;</th>
			<td><mcr:displayClassificationCategory lang="de"
					classid="${fn:substringBefore(resultDoc.getFieldValueMap()['profkat.last_faculty_class'], ':')}"
					categid="${fn:substringAfter(resultDoc.getFieldValueMap()['profkat.last_faculty_class'], ':')}" />
			</td>
	</tr>
	</c:if>
	<tr>
		<th style="min-width: 120px"><fmt:message key="Webpage.search.result.label.profkat.status_msg" />:&#160;</th>
		<td><fmt:message key="${resultDoc.getFieldValueMap()['profkat.status_msg']}" /></td>
	</tr>
</table>
