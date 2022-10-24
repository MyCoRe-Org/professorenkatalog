<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>


<div id="citation" class="ir-box ir-box-emph py-2 profkat-citation">
  <h5><fmt:message key="OMD.profkat.quoting"/>:</h5>
  <c:set var="mcrid"><x:out select="$mcrobj/mycoreobject/@ID" /></c:set>
  <c:set var="last"><x:out select="$mcrobj/mycoreobject/metadata/box.surname/surname" /></c:set>
  <c:set var="first"><x:out select="$mcrobj/mycoreobject/metadata/box.firstname/firstname" /></c:set>
  <jsp:useBean id="now" class="java.util.Date" scope="page" />
  <c:choose>
    <c:when test="${fn:startsWith(mcrid, 'cpr_')}">
      <c:url var="url" value="http://purl.uni-rostock.de/cpr/${fn:substringAfter(mcrid, 'cpr_person_')}" />
    </c:when>
    <c:otherwise>
      <c:url var="url" value="${WebApplicationBaseURL}resolve/id/${mcrid}" />
    </c:otherwise>
  </c:choose>
  <fmt:message key="OMD.profkat.quoting.text">
    <fmt:param>${first}&#160;${last}</fmt:param>
    <fmt:param>${url}</fmt:param>
    <fmt:param>${fn:replace(fn:replace(url,'/resolve/', '<wbr />/resolve/'),'/cpr', '<wbr />/cpr')}</fmt:param>
    <fmt:param><fmt:formatDate value="${now}" pattern="dd.MM.yyyy" /></fmt:param>
  </fmt:message>
</div>
