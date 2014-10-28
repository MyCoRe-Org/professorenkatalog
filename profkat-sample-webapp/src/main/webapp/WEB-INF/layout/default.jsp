<%@ page language="java" contentType="application/xhtml+xml; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib  prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrdd" uri="http://www.mycore.org/jspdocportal/docdetails.tld"%>

<stripes:layout-definition>
<html xmlns="http://www.w3.org/1999/xhtml" lang="de">
	<%-- Parameters: 
	     pageTitle: The overall heading of the page, usually hidden by CSS
	               (useful for screen readers) 
	     
	     layout: "1column", "2columns", "3columns" (=default)
	 --%>
	<c:choose>
		<c:when test="${layout eq '1column'}">
			<c:set var="class_left_side">hidden</c:set>
			<c:set var="class_contents"></c:set>
			<c:set var="class_right_side">hidden</c:set>
		</c:when>
		<c:when test="${layout eq '2columns'}">
			<c:set var="class_left_side">col-xs-12 col-md-2 ur-col</c:set>
			<c:set var="class_contents">col-xs-12 col-md-10 ur-col</c:set>
			<c:set var="class_right_side">hidden</c:set>
		</c:when>
		<c:otherwise> <%--3columns --%>
			<c:set var="class_left_side">col-xs-12 col-md-2 ur-col</c:set>
			<c:set var="class_contents">col-xs-12 col-md-8 ur-col</c:set>
			<c:set var="class_right_side">col-xs-12 col-md-2 ur-col</c:set>
		</c:otherwise>
	</c:choose>
	<mcrdd:setnamespace prefix="nav" uri="http://www.mycore.org/jspdocportal/navigation" />
	<c:set var="WebApplicationBaseURL" value="${applicationScope.WebApplicationBaseURL}" />
	<c:set var="path" value="${requestScope.path}" />
	<%-- set the current language --%>
	<mcr:setLanguage var="lang" allowedLanguages="de" />
	<fmt:setLocale value="${lang}" scope="request" />
  	<head>
  		<title>	${pageTitle} @ <fmt:message key="Webpage.title" /></title>
  		<meta charset="utf-8" />
    	<meta name="viewport" content="width=device-width, initial-scale=1" />
    	<meta name="author" content="Universitätsbibliothek Rostock" />
		
		<link type="image/x-icon" rel="shortcut icon"  href="${pageContext.request.contextPath}/themes/cpr/images/icon_cpr.ico" />

		<%--
		<meta name="description" lang="de"
	          content="Im Professorenkatalog sollen alle an der Universität tätigen Professoren mit 
	                    Angaben zur Person, zum wissenschaftlichen Profil und zu den Aktivitäten an der 
	                    Hochschule dokumentiert werden." />
		<meta name="author" content="AG Professorenkatalog" />
		<meta name="keywords" lang="de"
			  content="Professorenkatalog Universität Uni Professorenlexikon Gelehrtenkatalog 
			           Gelehrtenlexikon Lexikon Katalog Professor Professoren Gelehrter Gelehrte" />
		<meta name="keywords" lang="en"
	          content="professor scolar catalogue catalog lexicon encyclopedia encyclopaedia" />

		<c:if test="${not empty param.id}">
			<link rel="canonical" href="${WebApplicationBaseURL}metadata/${param.id}" />
		</c:if>


		<script src="${WebApplicationBaseURL}javascript/jspdocportal.js" type="text/javascript"></script>
		 --%>
		
		 <!-- Bootstrap -->
    	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />

		<%--
    	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    	<!--[if lt IE 9]>
      		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    	<![endif]-->
		--%>
		
		<%--
    	<link type="text/css"  rel="stylesheet" href="${pageContext.request.contextPath}/themes/uni-rostock/css/uni-rostock_bootstrap.css" />
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/themes/cpr/css/cpr.css" />
		 --%>
		<stripes:layout-component name="html_header">
			<%-- any additional HTML header content --%>
		</stripes:layout-component>		
	</head>

	<body>
		<fmt:message var="gotoContents" key="Webpage.gotoContents" />  
		<div class="sr-only">
			<h1>${pageTitle}</h1>
			<p><a href="#contents" title="${gotoContents}">${gotoContents}</a></p>
		</div>

		<div id="top" class="container ur-head hidden-xs hidden-sm" style="position:relative;">
			<div class="navbar navbar-default ur-topnav hidden-xs hidden-sm">
           		<mcr:outputNavigation id="top" mode="top" cssClass="nav navbar-nav navbar-right"> 
					<%--<div  class="separator" >|</div>
						<div class="item">
							<span style="padding-left:10px;padding-right:10px">
								<mcr:outputLanguageSelector languages="de,en" separatorString="&#160;&#160;|&#160;&#160;" />
							</span>
						</div> 	--%>
					<mcr:session method="get" var="username" type="userID" />
					<c:if test="${not (username eq 'gast' || username eq 'guest')}">
						<li class="userinfo">
							<a href="${WebApplicationBaseURL}nav?path=~login">
								<fmt:message key="Webpage.user" />:&#160;
								<span class="username">${username}</span>
							</a>
						</li>
						<li>
							<a href="${WebApplicationBaseURL}nav?path=~logout">
								[<span class="action"><fmt:message key="Nav.Logout" />]</span>
							</a>
						</li>							
					</c:if>			
					<c:if test="${(username eq 'gast' || username eq 'guest')}">
						<li>
							<a href="${WebApplicationBaseURL}nav?path=~login">
								[<span class="action"><fmt:message key="Nav.Login" /></span>]
							</a>
						</li>
					</c:if>		
				</mcr:outputNavigation>							
         	</div>
         	<h1 style="color:#326432;"><img src="${WebApplicationBaseURL}images/logo_hat.png" style="margin:0px 24px" />Professorenkatalog - Beispielanwendung</h1>	
		</div>
		<div class="panel panel-default hidden-md hidden-lg">
			  <div class="panel-heading" style="min-height:50px">
			    <button class="btn btn-default" style="float:right" data-toggle="collapse" data-target="#panel-collapse-1">
     				    <span class="glyphicon glyphicon-align-justify">&#8203;</span>
      			</button>
			  	<h3 style="margin-top:0px;margin-bottom:0px;padding-top:0px;padding-bottom:0px;font-family:Verdana;font-size:32px">
			  	&#160;&#160;&#160;Professorenkatalog</h3>

			  </div>
  			<div id="panel-collapse-1" class="collapse panel-body">
    			<mcr:outputNavigation id="left" expanded="true" mode="left" />
  			</div>
		</div>
	    <div id="contents" class="container">
   			<div class="row">
  				<div class="${class_left_side}">
  					<div class="ur-box ur-box-bordered hidden-xs hidden-sm">
	  					<div class="main_navigation">
							<mcr:outputNavigation id="left" cssClass="nav ur-sidenav" expanded="true" mode="left" />
						</div>
						<div style="padding-top:32px;padding-bottom:32px; text-align: center;">
							<a href="http://www.mycore.org">
								<img alt="powered by MyCoRe"
									 src="${WebApplicationBaseURL}images//mycore_logo_powered_129x34_knopf_hell.png"
								 	style="border:0;text-align:center;" />
							</a>
						</div>
						<div class="main_navigation">
							<mcr:outputNavigation id="admin" cssClass="nav ur-sidenav" expanded="false" mode="left" />
						</div>
					</div>
  				</div>
  				<div class="clearfix hidden-md hidden-lg"></div>
				<div class="${class_contents}">
					<div class="ur-box ur-box-bordered" style="min-height:24px">
						<div class="hidden-xs hidden-sm"> 
							<mcr:outputNavigation id="left" mode="breadcrumbs" cssClass="breadcrumb ur-breadcrumb" />	
						</div>
					</div>

					<stripes:layout-component name="contents">
						<%--<div>This is the main page ...</div>--%>
					</stripes:layout-component>
  				</div>
  				
  				<div class="${class_right_side}">
  					<stripes:layout-component name="right_side">
						<%-- <div class="ur-box ur-box-bordered ur-text">Alles wird gut!<br /><br /></div> --%>
					</stripes:layout-component>
  				</div>
			</div>
		</div>

		<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
   		<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
   		<!-- Include all compiled plugins (below), or include individual files as needed -->
   		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
	</body>
</html>
</stripes:layout-definition>
