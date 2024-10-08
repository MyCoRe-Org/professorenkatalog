<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.apache.commons.lang3.StringUtils "%>
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

<mcr:retrieveObject mcrid="${mcrid}" varDOM="mcrobj" cache="true" fromWorkflow="${fromWF}" />
<c:set var="prof_name">
  <x:out select="$mcrobj/mycoreobject/metadata/box.surname/surname" />,
  <x:out select="$mcrobj/mycoreobject/metadata/box.firstname/firstname" />
  <c:set var="affix"><x:out select="$mcrobj/mycoreobject/metadata/box.nameaffix/nameaffix" /></c:set>
  <c:if test="${fn:length(affix)>2}">(<c:out value="${affix}" />)</c:if>
</c:set>
<c:set var="pageTitle"><%= StringUtils.normalizeSpace(pageContext.getAttribute("prof_name").toString()) %></c:set> <%-- variable used in html_head.jspf --%>

<!doctype html>
<html>
  <head>
    <%@ include file="fragments/html_head.jspf" %>
    <%--ggf. Metatags ergänzen <mcr:transformXSL dom="${doc}" xslt="xslt/docdetails/metatags_html.xsl" /> --%>
    <c:set var="description">
      <mcr:transformXSL dom="${mcrobj}" xslt="xslt/docdetails/person2html_header_description.xsl" />
    </c:set>
    <meta name="description" lang="de" content="${fn:trim(description)}" />
    <link rel="canonical" href="${WebApplicationBaseURL}resolve/id/${mcrid}" />
  </head>
  <body>
    <%@ include file="fragments/header.jspf" %>
    <div id="content_area">
      <div id="docdetails" class="container">
        <div class="row">
          <div id="docdetails-main" class="col docdetails">
            <mcr:transformXSL dom="${mcrobj}" xslt="xslt/profkat/docdetails/header.xsl" />
            <c:if test="${fromWF eq 'true'}">
              <div class="alert alert-info" style="margin-top:20px" role="alert">
                <h4 style="margin:5px 0px">
                  <a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}do/workspace/tasks#${param.anchor}">
                    <fmt:message key="WF.Preview.return" />
                  </a>
                  <fmt:message key="WF.Preview" />
                </h4>
              </div>
            </c:if>
            <c:set var="msgKeyStatus">OMD.profkat.state.<x:out select="$mcrobj/mycoreobject/metadata/box.status/status"/></c:set>
            <div  class="tabbar docdetails-tabbar" style="position:relative">
              <ul id="tabs_on_page" class="nav nav-tabs profkat-details-tabs" style="position:relative">
                <li class="nav-item" role="presentation">
                  <a id="nav_tab_data" class="nav-link active" data-toggle="tab" data-target="#nav_content_data" href="#tab_data">
                    <i class="fas fa-user docdetails-tabbar-icon"></i>
                    <fmt:message key="Webpage.docdetails.tabs.data"/>
                  </a>
                </li>
                <x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[classification/@categid='display_biography']">
                  <li class="nav-item" role="presentation">
                    <a id="nav_tab_article" class="nav-link" data-toggle="tab" data-target="#nav_content_article" href="#tab_article">
                      <i class="fas fa-book docdetails-tabbar-icon"></i>
                      <fmt:message key="Webpage.docdetails.tabs.article"/>
                    </a>
                  </li>
                </x:if>
                <x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
                  <li class="nav-item">
                    <a id="nav_tab_documents" class="nav-link" data-toggle="tab" data-target="#nav_content_documents" href="#tab_documents">
                      <i class="far fa-file docdetails-tabbar-icon"></i>
                      <fmt:message key="Webpage.docdetails.tabs.documents"/></a>
                  </li>
                </x:if>
              </ul>
              <div class="docdetails-tabbar-info" style="position:absolute; top:5px; right:15px">
                <fmt:message key="${msgKeyStatus}" />
              </div>
            </div>
            <%--Tab bar (end) --%>
            
            <div id="nav_content_root" class="tab-content mt-3">
              <div id="nav_content_data" class="tab-pane active" data-parent="#nav_content_root">
                <mcr:transformXSL dom="${mcrobj}" xslt="xslt/profkat/docdetails/metadata.xsl" />
              </div>
              <div id="nav_content_documents" class="tab-pane" data-parent="#nav_content_root">
                <div class="card card-sm profkat-card-copyright">
                  <div class="card-body">
                    <fmt:message key="OMD.derivate.copyright.notice" />
                  </div>
                </div>
                <mcr:transformXSL dom="${mcrobj}" xslt="xslt/profkat/docdetails/derivate_list.xsl" />
              </div>
              <div id="nav_content_article" class="tab-pane" data-parent="#nav_content_root">
                <mcr:transformXSL dom="${mcrobj}" xslt="xslt/profkat/docdetails/derivate_content.xsl" />
              </div>
            </div>
            <c:if test="${fromWF eq 'true'}">
              <div class="alert alert-info" style="margin-top:20px" role="alert">
                <h4 style="margin:5px 0px">
                  <a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}do/workspace/tasks#${param.anchor}">
                    <fmt:message key="WF.Preview.return" />
                  </a>
                  <fmt:message key="WF.Preview" />
                </h4>
              </div>
            </c:if>
            <script type="text/javascript">
              $(function() {
                var hash = window.location.hash;
                if(hash.startsWith('#tab_')){
                  $('#nav_'+hash.substr(1)).tab('show');
                }
              });
            </script>
          </div>
          
          <div id="docdetails-right" class="col-3">
            <div class="docdetails-infobox" style="margin-bottom:32px;">
              <div class="row">
                <div class="col">
                  <search:result-navigator mcrid="${mcrid}" />
                </div>
              </div>
              <div class="row">
                <div class="col">
                  <jsp:include page="includes/citation_profkat.jsp">
                    <jsp:param name="mcrobj" value="${mcrobj}" />
                  </jsp:include>
                </div>
              </div>
              <div class="row mb-3">
                <div class="col">
                  <c:set var="url">${WebApplicationBaseURL}resolve/id/${it.id}</c:set>
                  <a class="btn btn-outline-secondary btn-sm w-100" style="text-align:left;" target="_blank" title="<fmt:message key="Webpage.feedback" />"
                     href="${WebApplicationBaseURL}do/feedback?topicURL=<%=java.net.URLEncoder.encode(pageContext.getAttribute("url").toString(), "UTF-8")%>&amp;topicHeader=<%=java.net.URLEncoder.encode(pageContext.getAttribute("prof_name").toString().replaceAll("\\s+"," "), "UTF-8")%>">
                    <i class="far fa-comments"></i> <fmt:message key="Webpage.feedback.button"/>
                  </a>
                </div>
              </div>
              <div class="row mb-3">
                <div class="col">
                  <a class="btn btn-outline-secondary btn-sm hidden-sm hidden-xs" style="text-align:left;margin-right:6px" href="${WebApplicationBaseURL}resolve/id/${it.id}/print" target="_blank" title="<fmt:message key="WF.common.printdetails" />">
                    <i class="fas fa-print"></i> <fmt:message key="Webpage.print.button"/>
                  </a>
                  <c:if test="${(not fromWF)}" >
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
    </div>
    <%@ include file="fragments/footer.jspf" %>
  </body>
</html>
