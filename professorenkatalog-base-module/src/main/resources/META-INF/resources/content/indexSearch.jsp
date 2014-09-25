<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld" %>
<%@ taglib prefix="mcrb" uri="http://www.mycore.org/jspdocportal/browsing.tld" %>
<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld" %>

<fmt:message var="pageTitle" key="Nav.CPRIndex" /> 
<stripes:layout-render name="../WEB-INF/layout/default.jsp" pageTitle = "${pageTitle}">
	<stripes:layout-component name="html_header">
		<link type="text/css" rel="stylesheet" href="${WebApplicationBaseURL}css/style_index-browser.css">
	</stripes:layout-component>
	
	<stripes:layout-component name="contents">
		<h2><fmt:message key="Webpage.indexbrowser.${param.searchclass}.title" /></h2>
		<fmt:message key="Webpage.indexbrowser.${param.searchclass}.intro" />
		<br />
		<br />
		<mcrb:indexBrowser index="${param.searchclass}" 
    			varurl="url" varxml="xml"
				docdetailsurl="nav?path=~searchdocdetails-index_person&amp;id={0}">
			<table>
				<tr class="indexitem">
					<td valign="top"><img border="0"
						style="vertical-align: middle; padding-right: 10px"
						src="images/greenArrow.gif" alt="" /></td>
					<td>
					  	<div class="itemtitle">
							<a href="${url}">
								<x:out select="$xml/value/col[@name='surname']" />, 
								<x:out select="$xml/value/col[@name='firstname']" />
								<x:if select="$xml/value/col[@name='//box.nameaffix/nameaffix' and ./text() != '']">
									&#160;(<x:out select="$xml/value/col[@name='//box.nameaffix/nameaffix']/text()" />)
								</x:if>					
							</a>
					  </div>
					  
						<x:if select="$xml/value/col[@name='//box.period/period/text' and ./text() != '' and ./text() != 'unbekannt']">
							<fmt:message key="OMD.CPR.professorships" />:&#160;
							<c:set var="profdates"><x:out select="$xml/value/col[@name='//box.period/period/text']" /></c:set>
							<c:out value="${fn:replace(profdates, ' - ', ', ')}" /> 
							<br />
						</x:if>
						<x:if select="$xml/value/col[@name='//box.professorship/professorship[last()]/event' and ./text() != '']">
							<fmt:message key="OMD.common.last" />:&#160;
							<x:out select="$xml/value/col[@name='//box.professorship/professorship[last()]/event']" />
							<br />
						</x:if>
						<x:if select="$xml/value/col[@name='//box.faculty/faculty[last()]/classification/@categid' and ./text() != '']">
							<fmt:message key="OMD.common.last" />:&#160;
							<c:set var="categid"><x:out select="$xml/value/col[@name='//box.faculty/faculty[last()]/classification/@categid']" /></c:set>
							<mcr:displayClassificationCategory lang="de" classid="profkat_class_institutions" categid="${categid}" />
							<br />
						</x:if>
						<x:if select="$xml/value/col[@name='state' and ./text() != '']">
							<fmt:message key="OMD.CPR.states" />&#160;
							<c:set var="state"><x:out select="$xml/value/col[@name='state']" /></c:set>
							<fmt:message key="OMD.CPR.states.${state}"/>
							<br />
						</x:if>
					</td>
				</tr>
			</table>
		</mcrb:indexBrowser>
    </stripes:layout-component>
</stripes:layout-render>

<%-- Sample index item:
    <value pos="17">
      <sort>wustenberg_peter-wilhelm</sort>
      <idx>wustenberg</idx>
      <id>cp_person_00001914</id>
      <col name="surname">Wüstenberg</col>
      <col name="firstname">Peter-Wilhelm</col>
      <col name="//nameaffixes/nameaffix" />
      <col name="//professorships/professorship[last()]/event">o. Professor für Pathologische Physiologie</col>
      <col name="//periods/period/text">1977-92</col>
      <col name="id">cp_person_00001914</col>
    </value>  --%>
