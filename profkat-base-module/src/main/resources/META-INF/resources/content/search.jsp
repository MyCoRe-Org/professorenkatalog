<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="errorpage.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="heading1" key="Webpage.Search.h1" /> 
<stripes:layout-render name="../WEB-INF/layout/default.jsp" heading1="${heading1}" 
                       layout="2columns">
	
	<stripes:layout-component name="html_header">
		<title><fmt:message key="Nav.Search" /> @ <fmt:message key="Webpage.title" /></title>
		<meta name="description" lang="de"
	          content="Suchemaske für den Catalogus Professorum Rostochiensium (Rostocker Professorenkatalog)" />
		<meta name="author" content="Forschungsstelle Universitätsgeschichte der Universität Rostock" />
		<meta name="keywords" lang="de"
			  content="Suche Suchen Rostock Universität Uni Professor Professoren Gelehrter Gelehrte Mitarbeiter"  />
		<meta name="keywords" lang="en"
	          content="search Rostock University professor professors scolar scolars members" />
	</stripes:layout-component>
	
	<stripes:layout-component name="contents">
		<h2><fmt:message key="Nav.Search" /></h2>
		
		<p><fmt:message key="Webpage.Search.Possibilities" /> </p>
		<p><mcr:includeEditor editorPath="editor/searchmasks/SearchMask_AllMetadataFields.xml"/></p>

		<p><mcr:outputNavigation expanded="false" mode="toc" id="left"/></p>
		<div style="width:600px;"><mcr:includeWebcontent id="search_intro" file="search_introtext.html"/></div>
	</stripes:layout-component>
</stripes:layout-render>