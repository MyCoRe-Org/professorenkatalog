<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>

<c:set var="mcrid">
  <c:choose>
    <c:when test="${!empty requestScope.id}">${requestScope.id}</c:when>
    <c:otherwise>${it.id}</c:otherwise>
  </c:choose>
</c:set>
<c:set var="fromWF"  value="${param.fromWF}" />
<c:if test="${empty fromWF}">
  <c:set var="fromWF" value="false" />
</c:if>
<c:choose>
  <c:when test="${fromWF}" >
    <c:set var="layout" value="preview" />
  </c:when>
  <c:otherwise>
    <c:set var="layout" value="normal" />
  </c:otherwise>
</c:choose>

<mcr:retrieveObject mcrid="${mcrid}" varDOM="mcrobj" cache="true" fromWorkflow="${fromWF}" />
  <c:set var="prof_name">
    <x:out select="$mcrobj/mycoreobject/metadata/box.surname/surname" />,
    <x:out select="$mcrobj/mycoreobject/metadata/box.firstname/firstname" />
    <c:set var="affix"><x:out select="$mcrobj/mycoreobject/metadata/box.nameaffix/nameaffix" /></c:set>
    <c:if test="${fn:length(affix)>2}">(<c:out value="${affix}" />)</c:if>
  </c:set>
  <c:set var="pageTitle">${prof_name}</c:set>

<!doctype html>
<html>
  <head>
    <%@ include file="fragments/html_head.jspf" %>
    <%--ggf. Metatags ergänzen <mcr:transformXSL dom="${doc}" xslt="xsl/docdetails/metatags_html.xsl" /> --%>
    <c:set var="description">
      <mcr:transformXSL dom="${mcrobj}" xslt="xsl/docdetails/person2html_header_description.xsl" />
    </c:set>
    <meta name="description" lang="de" content="${fn:trim(description)}" />
    <link rel="canonical" href="${WebApplicationBaseURL}resolve/id/${mcrid}" />
  </head>
  <body>
    <%@ include file="fragments/header.jspf" %>
    <div id="content_area ir-print">
      <div id="docdetails" class="container">
        <div class="row">
          <div id="docdetails-main" class="col-9 docdetails">
            <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/header.xsl" />
            <c:if test="${fromWF eq 'true'}">
              <div class="alert alert-info" style="margin-top:20px" role="alert">
                <h4 style="margin:5px 0px">
                  <fmt:message key="WF.Preview" />
                </h4>
              </div>
            </c:if>
            <div class="docdetails-infobox" style="margin-top:32px;">
              <jsp:include page="includes/citation_profkat.jsp">
                <jsp:param name="mcrobj" value="${mcrobj}" />
              </jsp:include>
            </div>
          </div>
          <x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[classification/@categid='display_portrait' or classification/@categid='display_signature']">
            <div id="docdetails-portrait" class="col-3 docdetails">
              <search:derivate-image mcrobj="${mcrobj}" width="100%" category="display_portrait" showFooter="true" protectDownload="true" />
              <search:derivate-image mcrobj="${mcrobj}" width="100%" category="display_signature" protectDownload="true" />
            </div>
          </x:if>
        </div>
        <div class="row">
          <div id="docdetails-main" class="col docdetails">
            <c:set var="msgKeyStatus">OMD.profkat.state.<x:out select="$mcrobj/mycoreobject/metadata/box.status/status"/></c:set>
            <hr class="border border-primary" />
            <div class="float-right">
              (<fmt:message key="${msgKeyStatus}" />)
            </div>
            <h3><fmt:message key="Webpage.docdetails.tabs.data"/></h3>
            <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/metadata.xsl" />
            <x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[classification/@categid='display_biography']">
              <hr class="border border-primary" />
              <h3><fmt:message key="Webpage.docdetails.tabs.article"/></h3>
              <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/derivate_content.xsl" />
            </x:if>
            <x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
              <hr class="border border-primary" />
              <h3><fmt:message key="Webpage.docdetails.tabs.documents"/></h3>
              <div class="card card-sm profkat-card-copyright">
                <div class="card-body">
                  <fmt:message key="OMD.derivate.copyright.notice" />
                </div>
              </div>
              <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/derivate_list.xsl" />
            </x:if>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
