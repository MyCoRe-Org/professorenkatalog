<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib  prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld"%>

<stripes:layout-definition>
	<%-- Parameters: 
	     heading1: The overall heading of the page, usually hidden by CSS
	               (useful for screen readers) 
	     
	     layout: "1column", "2columns", "3columns" (=default)
	     
	 --%>
	<!DOCTYPE html>
	<c:if test="${empty layout}">
		<c:set var="layout" value="3columns" />
	</c:if>
	<mcrdd:setnamespace prefix="nav" uri="http://www.mycore.org/jspdocportal/navigation" />
	<c:set var="WebApplicationBaseURL" value="${applicationScope.WebApplicationBaseURL}" />
	<c:set var="path" value="${requestScope.path}" />
	<%-- set the current language --%>
	<mcr:setLanguage var="lang" allowedLanguages="de" />
	<fmt:setLocale value="${lang}" scope="request" />
	<fmt:setBundle basename='messages' scope="request" />
	<html>
	<head>
		<meta charset="UTF-8" />
		<%--

 		<title>	${pageTitle} @ <fmt:message key="Webpage.title" /></title>

		<c:if test="${not empty param.id}">
			<link rel="canonical" href="${WebApplicationBaseURL}resolve/id/${param.id}" />
		</c:if>


		<script src="${WebApplicationBaseURL}javascript/jspdocportal.js" type="text/javascript"></script>
		 --%>
		<link rel="shortcut icon" href="${WebApplicationBaseURL}images/favicon_profkat.ico">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_reset.css">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_layout.css">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_content.css">
		<stripes:layout-component name="html_header">
			<%-- any additional HTML header content --%>
		</stripes:layout-component>		
	</head>

	<body>
		<fmt:message var="gotoContents" key="Webpage.gotoContents" />  
		<div class="none">
			<h1>${heading1}</h1>
			<p><a href="#contents" title="${gotoContents}">${gotoContents}</a></p>
		</div>
		<div id="wrapper">
			<div id="header">
				<div class="top_navigation">
					<mcr:outputNavigation id="top" mode="top" separatorString="|" /> 
					<%--<div  class="separator" >|</div>
						<div class="item">
							<span style="padding-left:10px;padding-right:10px">
								<mcr:outputLanguageSelector languages="de,en" separatorString="&nbsp;&nbsp;|&nbsp;&nbsp;" />
							</span>
						</div> 	--%>
					<ul>
						<li class="separator">|</li> 
						<li class="userinfo">
							<mcr:session method="get" var="username" type="userID" />
							<c:if test="${not (username eq 'gast' || username eq 'guest')}">
								<span class="label"><fmt:message key="Webpage.user" />:&nbsp;</span>
								<span class="username">							 
									<a href="${WebApplicationBaseURL}nav?path=~userdetail">${username}</a>
								</span>
								[<span class="action">
									<a href="${WebApplicationBaseURL}nav?path=~logout">
										<fmt:message key="Nav.Logout" />
									</a>
								</span>]							
							</c:if>							
							<c:if test="${(username eq 'gast' || username eq 'guest')}">
								[<span class="action">
									<a href="${WebApplicationBaseURL}nav?path=~login">
											<fmt:message key="Nav.Login" />
									</a>
								</span>]
							</c:if>			
						</li>
					</ul>									
				</div> <%--END OF top_navigation --%>
				<div id="logo_uni">
						<a href="http://www.mycore.org">
							<img title="Logo der Einrichtung" alt="MyCoRe" class="logo_uni" src="${WebApplicationBaseURL}images/mycore_logo_129x34_knopf_dunkel.png"/>
					   </a>
					   <span style="font-family:Verdana;font-size:150%">Beispielanwendung für Professorenkatalog</span>
				</div>						
			</div><!-- END OF header -->
			<div id="left_col" class="left_col_${layout}">
				<div class="base_box">
					<div class="main_navigation">
						<mcr:outputNavigation id="left" expanded="true" mode="left" />
					</div>
					<div style="padding-top:32px;padding-bottom:32px; text-align: center;">
						<a href="http://www.mycore.org">
							<img alt="powered by MyCoRe 2.2"
								 src="${WebApplicationBaseURL}images/poweredByMyCoRe2_2lines.gif"
							 	style="border:0;text-align:center;">
						</a>
					</div>
					<div class="main_navigation">
						<mcr:outputNavigation id="admin" expanded="false" mode="left" />
					</div>
				</div>
			</div><!-- END OF left_col -->
			
			<div id="center_col" class="center_col_${layout}">
				<div class="base_box breadcrumbs">
					<mcr:outputNavigation id="left" mode="breadcrumbs" separatorString="»" />				
				</div>
				
				<div id="contents" class="base_content text">
					<stripes:layout-component name="contents">
						<%--<div>This is the main page ...</div>--%>
					</stripes:layout-component>			
				</div>
			</div><!-- END of content -->
			<div id="right_col" class="right_col_${layout}">
				<stripes:layout-component name="right_side">
					<%--<div class="base_box infobox">Alles wird gut!</div> --%>
				</stripes:layout-component>
				
			</div> <!--  END OF right-->
		</div>

	</body>
	</html>
</stripes:layout-definition>