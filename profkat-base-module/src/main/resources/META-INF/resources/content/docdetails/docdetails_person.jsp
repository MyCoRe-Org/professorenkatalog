<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd" %>
<%-- Parameter: id - the MCR Object ID--%>
<%-- Parameter: fromWF - from Workflow or database --%>


	<%--Tab bar (begin) --%>	
	<c:set var="tab" value="${param.tab}" />
	<c:if test="${empty tab}"><c:set var="tab" value="data" /></c:if>
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<mcr:receiveMcrObjAsJdom mcrid="${param.id}" varDom="mcrobj" fromWF="${param.fromWF}"/>
	<c:if test="${not(param.print eq 'true')}">
		<div  class="tabbar ur-embedded">
			<c:set var="msgKeyStatus">OMD.CPR.states.<x:out select="$mcrobj/mycoreobject/metadata/box.status/status"/></c:set>
			<div class="pull-right" style="font-style: italic; color: #666666; padding-right:16px; padding-top:11px;"><fmt:message key="${msgKeyStatus}" /></div>
			<ul id="tabs_on_page" class="nav nav-tabs">
				<c:set var="tabtokens" value="data|article|documents" />
				<c:forTokens items="${tabtokens}" delims="|" var="current" varStatus="status">
      				<c:set var="tabstyle" value="" /> 
					<c:if test="${current eq tab}">
						<c:set var="tabstyle" value="active" />
					</c:if>
					<c:if test="${current eq 'data'}">
						<li class="${tabstyle}">
							<a href="${WebApplicationBaseURL}nav?path=${param.path}&amp;id=${param.id}&amp;offset=${param.offset}&amp;resultid=${param.resultid}&amp;fromWF=${param.fromWF}&amp;tab=${current}"><fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
						</li>
					</c:if>
					<c:if test="${current eq 'article'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[@xlink:label='display_biography']">
							<li class="${tabstyle}">
								<a href="${WebApplicationBaseURL}nav?path=${param.path}&amp;id=${param.id}&amp;offset=${param.offset}&amp;resultid=${param.resultid}&amp;fromWF=${param.fromWF}&amp;tab=${current}"><fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>		
					</c:if>
					<c:if test="${current eq 'documents'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
							<li class="${tabstyle}">
								<a href="${WebApplicationBaseURL}nav?path=${param.path}&amp;id=${param.id}&amp;offset=${param.offset}&amp;resultid=${param.resultid}&amp;fromWF=${param.fromWF}&amp;tab=${current}"><fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>		
					</c:if>
				</c:forTokens>				
			</ul>
		</div>
	</c:if>
	<%--Tab bar (end) --%>

<mcrdd:docdetails mcrID="${param.id}" lang="de" fromWorkflow="${param.fromWF}" var="doc" outputStyle="headlines"> 
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<mcrdd:header>
	    <mcrdd:item select="/mycoreobject/metadata/box.surname/surname" var="last"/>
        <mcrdd:item select="/mycoreobject/metadata/box.firstname/firstname" var="first" />
        <mcrdd:item select="/mycoreobject/metadata/box.nameaffix/nameaffix" var="affix" />
        <mcrdd:item select="/mycoreobject/metadata/box.academictitle/academictitle" var="akadtitle" />
		<mcrdd:item select="/mycoreobject/metadata/box.state/state" labelkeyPrefix="OMD.CPR.states." var="status"/>
		<c:set var="doctitle">${last},&#160;${first}</c:set>
		
        <div>
			<h2>
				<c:out value="${doctitle}" escapeXml="false" />
        		<c:if test="${fn:length(affix)>2}">(<c:out value="${affix}" />)</c:if>
       		</h2>
       	</div> 
       	<div style="padding-left:30px;">${akadtitle}</div>      	
    
	</mcrdd:header>

    <c:set var="proflabelkey" value="" />
    <c:set var="profshowinfo" value="false" />
    <x:if select="$mcrobj/mycoreobject/metadata/box.type/type[@categid='ro_professor']">
    	<c:set var="proflabelkey" value="OMD.CPR.professorships" />
    	<c:set var="profshowinfo" value="true" />
    </x:if>
    
    <mcrdd:row select="/mycoreobject/metadata/box.professorship/professorship" labelkey="${proflabelkey}" showInfo="${profshowinfo}" colWidths="95">
		<mcrdd:item select="./text" styleName="docdetails-value-bold" />              
    	<mcrdd:item select="./event" styleName="docdetails-value-bold" />
    	<mcrdd:outputitem select="." var="x">
    	    <x:forEach select="$x/text[@*[local-name() = 'lang']='x-predec']">
    	    	<c:set var="linkids" scope="request"><x:out select="./text()" /></c:set>
    			<c:forTokens items="${linkids}" delims=":;|" var="currentID" varStatus="status">
					<c:if test="${fn:startsWith(currentID, 'cpr_')}">
						<mcr:receiveMcrObjAsJdom mcrid="${currentID}" varDom="linked" fromWF="false"/>
   						<c:if test="${not empty linked}">
   							<c:set var="doctitle"><fmt:message key="OMD.CPR.hint.predec"/>:&#160;</c:set>
   							<c:set var="doctitle">${doctitle}<x:out select="$linked/metadata/box.surname/surname" />,&#160;</c:set>
    						<c:set var="doctitle">${doctitle}<x:out select="$linked/metadata/box.firstname/firstname" /></c:set>
							<c:set var="affix"><x:out select="$linked/metadata/box.nameaffix/nameaffix" /></c:set>
							<c:if test="${fn:length(affix)>2}"><c:set var="doctitle">${doctitle}&#160;(<c:out value="${affix}" />)</c:set></c:if>
							<a href="${WebApplicationBaseURL}metadata/${currentID}">
								<img src="${WebApplicationBaseURL}images/prof_predec.gif" border="0" title="${doctitle}" />  
					   		</a>
				   		</c:if>
				   	</c:if>
				</c:forTokens>
    		</x:forEach>
    				
    		<x:forEach select="$x/text[@*[local-name() = 'lang']='x-succ']">
    		   	<c:set var="linkids" scope="request"><x:out select="./text()" /></c:set>
    			<c:forTokens items="${linkids}" delims=":;|" var="currentID" varStatus="status">
	  				<c:if test="${fn:startsWith(currentID, 'cpr_')}">
	  					<mcr:receiveMcrObjAsJdom mcrid="${currentID}" varDom="linked" fromWF="false"/>
   						<c:if test="${not empty linked}">
   							<c:set var="doctitle"><fmt:message key="OMD.CPR.hint.succ"/>:&#160;</c:set>
   							<c:set var="doctitle">${doctitle}<x:out select="$linked/metadata/box.surname/surname" />,&#160;</c:set>
         					<c:set var="doctitle">${doctitle}<x:out select="$linked/metadata/box.firstname/firstname" /></c:set>
							<c:set var="affix"><x:out select="$linked/metadata/box.nameaffix/nameaffix" /></c:set>
							<c:if test="${fn:length(affix)>2}"><c:set var="doctitle">${doctitle}&#160;(<c:out value="${affix}" />)</c:set></c:if>
							<a href="${WebApplicationBaseURL}metadata/${currentID}">
								<img src="${WebApplicationBaseURL}images/prof_succ.gif" border="0" title="${doctitle}" />  
				   			</a>
				   		</c:if>
				   	</c:if>
				</c:forTokens>
    		</x:forEach>
    	</mcrdd:outputitem>
   	</mcrdd:row>
     
     <mcrdd:separator showLine="true" />
   	 
   	 <c:if test="${(tab eq 'data') or (param.print eq 'true')}">
 		<mcrdd:row select="/mycoreobject/metadata/box.faculty/faculty" labelkey="OMD.CPR.faculties" showInfo="true" colWidths="95">
	  		<mcrdd:item select="./text" />              
    		<mcrdd:classificationitem select="./classification" />  
    	</mcrdd:row>
    
   		<mcrdd:row select="/mycoreobject/metadata/box.institute/institute" labelkey="OMD.CPR.institutes" showInfo="true" >
   			<mcrdd:item select="." />  
   		</mcrdd:row>
   	
   		<mcrdd:row select="/mycoreobject/metadata/box.fieldofstudy/fieldofstudy" labelkey="OMD.CPR.fieldofstudies" showInfo="true" >
   			<mcrdd:item select="." />  
   		</mcrdd:row>
    
    	<mcrdd:row select="/mycoreobject/metadata/box.subjectclass/subjectclass" labelkey="OMD.CPR.subjects" showInfo="true" >
	  		<mcrdd:classificationitem select="." />  
    	</mcrdd:row>
    
    	<mcrdd:separator showLine="true" />
   	       
   		<mcrdd:row select="/mycoreobject/metadata/box.email/email" labelkey="OMD.CPR.emails" showInfo="false" >
   			<mcrdd:outputitem select="." var="current">
   				<c:set var="email"><x:out select="$current/text()" /></c:set>
   				<jsp:include page="fragments/email_pk.jsp">
   					<jsp:param name="email" value="${email}" />
   				</jsp:include>
   			</mcrdd:outputitem>   
   		</mcrdd:row>
    
   		<mcrdd:row select="/mycoreobject/metadata/box.homepage/homepage" labelkey="OMD.CPR.homepages" showInfo="true" >
   			<mcrdd:outputitem select="." var="current">
   				<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<jsp:include page="fragments/link_pk.jsp">
   					<jsp:param name="href" value="${href}" />
   					<jsp:param name="title" value="${title}" />
   				</jsp:include>
   			</mcrdd:outputitem> 
   		</mcrdd:row>    
    
    	<mcrdd:separator showLine="true"/>    
       		<mcrdd:row select="/mycoreobject/metadata/box.surname/surname[position()>1]" labelkey="OMD.CPR.surnames" showInfo="true" >
   			<mcrdd:item select="." />  
   		</mcrdd:row> 

   		<mcrdd:row select="/mycoreobject/metadata/box.firstname/firstname[position()>1]" labelkey="OMD.CPR.firstnames" showInfo="false" >
   			<mcrdd:item select="." />  
   		</mcrdd:row> 
    
		<mcrdd:row select="/mycoreobject/metadata/box.birth/birth|/mycoreobject/metadata/box.death/death" labelkey="OMD.CPR.lifetimes" showInfo="true" colWidths="95">
		  	<mcrdd:outputitem select="." var="data">
   				<x:set var="date" select="string($data/text)" />
				<x:set var="place" select="string($data/event)" />
				<x:set var="type" select="local-name($data)" />

				<nobr>
					<c:if test="${type eq 'birth'}"> <fmt:message key="OMD.common.born" /> </c:if>
					<c:if test="${type eq 'death'}"> <fmt:message key="OMD.common.died" /> </c:if>
	
					<c:if test="${(not empty date)}">
						<c:if test="${fn:contains(date, '.')}">
							<fmt:message key="OMD.common.at" />
						</c:if>
						<c:out value="${date}" />
					</c:if> 
					<c:if test="${(not empty place)}">
						<fmt:message key="OMD.common.in" />
						<c:out value="${place}" />
					</c:if>
				</nobr>
   			</mcrdd:outputitem>   
    	</mcrdd:row>
   		
   		<mcrdd:row select="/mycoreobject/metadata/box.confession/confession" labelkey="OMD.CPR.confessions" showInfo="false" >
   			<mcrdd:item select="." />  
   		</mcrdd:row> 
   	
   		<mcrdd:row select="/mycoreobject/metadata/box.family/family" labelkey="OMD.CPR.families" showInfo="true" >
			<mcrdd:item select="./@type" labelkeyPrefix="OMD.CPR.family.display."/> 
			<mcrdd:outputitem select="." var="current">
 	  			<c:set var="name"><x:out select="$current/name" escapeXml="false" /></c:set>
		 		<c:set var="profession"><x:out select="$current/profession" escapeXml="false"/></c:set>
		 		<c:set var="url"><x:out select="$current/name/@id" escapeXml="false"/></c:set>
				<c:if test="${fn:length(name) gt 1}">
					<c:out value="${name}" escapeXml="false" /><c:if test="${fn:length(profession) gt 1}">,&#160;</c:if>
				</c:if>
				<c:if test="${fn:length(profession) gt 1}">
					<c:out value="${profession}" escapeXml="false" />
				</c:if>
				<c:if test="${fn:length(url) gt 1}">
					<jsp:element name="a">	
						<jsp:attribute name="href">
							<c:out value="${url}" />
						</jsp:attribute>
						<jsp:attribute name="target">_blank</jsp:attribute>
						<jsp:body>
					   		<nobr> (<fmt:message key="OMD.CPR.link.external" />
			    			   	<img src="${WebApplicationBaseURL}images/link_extern.png"
							alt="Link" />)</nobr>
						</jsp:body>	
					</jsp:element>
				</c:if>
   			</mcrdd:outputitem>
   		</mcrdd:row> 
   	
   		<mcrdd:separator showLine="true" />	   
      	<mcrdd:row select="/mycoreobject/metadata/box.biographic/biographic" labelkey="OMD.CPR.biographics" showInfo="true" colWidths="95">
	  		<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" />  
    	</mcrdd:row>

  		<mcrdd:row select="/mycoreobject/metadata/box.academicdegree/academicdegree" labelkey="OMD.CPR.academicdegrees" showInfo="true" colWidths="95">
    		<mcrdd:item select="./@type" labelkeyPrefix="OMD.CPR.academicdegree.display."/>
    		<mcrdd:item select="./time" />              
 			<mcrdd:outputitem select="." var="xml">
   				<x:out select="$xml/text" />
   				<x:if select="$xml/dissertation">
   					<br /><i><fmt:message key="OMD.CPR.dissertationTitle"/>:&#160;</i><x:out select="$xml/dissertation" escapeXml="false"/>
   				</x:if>
   			</mcrdd:outputitem> 
    	</mcrdd:row>
		
		<mcrdd:separator showLine="true" />	
   	
   		<mcrdd:row select="/mycoreobject/metadata/box.adminfunction/adminfunction" labelkey="OMD.CPR.adminfunctions" showInfo="true" colWidths="95">
			<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" />  
    	</mcrdd:row>

   		<mcrdd:row select="/mycoreobject/metadata/box.otherfunction/otherfunction" labelkey="OMD.CPR.otherfunctions" showInfo="true" colWidths="95">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" />  
    	</mcrdd:row>
    
    	<mcrdd:row select="/mycoreobject/metadata/box.membership/membership[not(@type='party')]" labelkey="OMD.CPR.memberships" showInfo="true" colWidths="95">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" />  
    	</mcrdd:row>

   		<mcrdd:row select="/mycoreobject/metadata/box.award/award" labelkey="OMD.CPR.awards" showInfo="true" colWidths="95">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" />  
    	</mcrdd:row>         

   		<mcrdd:row select="/mycoreobject/metadata/box.otherinfo/otherinfo" labelkey="OMD.CPR.otherinfos" showInfo="true" >
		  	<mcrdd:item select="." />  
    	</mcrdd:row>         

		<mcrdd:separator showLine="true" />

   		<mcrdd:row select="/mycoreobject/metadata/box.mainpublication/mainpublication" labelkey="OMD.CPR.mainpublications" showInfo="true" >
		  	<mcrdd:item select="." />  
    	</mcrdd:row>         
        
          
   		<mcrdd:row select="/mycoreobject/metadata/box.publicationslink/publicationslink" 
   		       labelkey="OMD.CPR.bibliographicrefs" showInfo="true" >
   			<mcrdd:outputitem select="." var="current">
   		   		<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<jsp:include page="fragments/link_pk.jsp">
   					<jsp:param name="href" value="${href}" />
   					<jsp:param name="title" value="${title}" />
   				</jsp:include>
   			</mcrdd:outputitem> 
   		</mcrdd:row>  
 		
  		<mcrdd:separator showLine="true" />	

   		<mcrdd:row select="/mycoreobject/metadata/box.source/source" labelkey="OMD.CPR.sources" showInfo="true" >
   			<mcrdd:outputitem select="." var="current">
   				<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<jsp:include page="fragments/link_pk.jsp">
   					<jsp:param name="href" value="${href}" />
   					<jsp:param name="title" value="${title}" />
   				</jsp:include>
   			</mcrdd:outputitem> 
   		</mcrdd:row>  

		<mcrdd:row select="/mycoreobject/metadata/box.complexref/complexref|/mycoreobject/metadata/box.reference/reference" 
   		           labelkey="OMD.CPR.references" showInfo="true" >   
   			<mcrdd:outputitem select="." var="current">
   		   		<x:set var="linkData" select="$current" scope="session" />
   		   		<x:set var="doc" select="$doc" scope="session" />
   		   	   	<x:if select="local-name($current)='reference'">
   					<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   					<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   					<jsp:include page="fragments/link_pk.jsp">
   						<jsp:param name="href" value="${href}" />
   						<jsp:param name="title" value="${title}" />
   					</jsp:include>
   				</x:if>
   				<x:if select="local-name($current)='complexref'">
   					<c:set var="content"><x:out select="$current/text()" /></c:set>
   					<mcrdd:complexref content="${content}" />
   				</x:if>
   			</mcrdd:outputitem> 
   		</mcrdd:row> 
   		
   		<mcrdd:row select="/mycoreobject/metadata/box.identifier/identifier[@type='gnd']" labelkey="OMD.CPR.onlineres" showInfo="true" >
   			<mcrdd:item select="/mycoreobject/metadata/box.identifier/identifier[@type='gnd']" var="pnd" />
   			<x:if select="string($pnd)='xxx'">
   				<mcrdd:outputitem select="." var="x">
   					<fmt:message key="OMD.CPR.identifiers.nognd" />
   				</mcrdd:outputitem>
   			</x:if>
   			<x:if select="string($pnd)!='xxx'">
   				<mcrdd:outputitem select="." var="x">
   					<c:set var="pndString"><x:out select="string($pnd)" /></c:set>
   					GND: <a href="http://d-nb.info/gnd/${pndString}" title="Eintrag in der Personennamendatei (PND)">${pndString}</a>
					<mcrdd:pndbeacon pnd="${pndString}"
						whitelist="reichka|archinform|biocist|bbkl|cmvw|reichstag|adbreg|gabio|poi_fmr|fembio|lagis|hls|rism|historicum|lemo|sandrart|odb|odnb|rag|repfont_per|adam|vkuka|volchr|lassalle_all|lwl|gesa|dewp|hafaspo|litirol|plnoe|regacad|vorleser|wwwddr|documenta|ps_usbk|pw_artcyclop|pw_basiswien|pw_discogs|pw_ifa|pw_kunstaspekte|pw_lexm|pw_mactut|pw_mgp|pw_musicbrainz|pw_nobel|pw_olgdw|pw_orden|pw_photonow|pw_rkd|pw_rwien|pw_sbo|pw_sikart|gistb|dingler|mat_hr|saebi|ads|ausfor|bbcyp|ariadne_fib2|sdi_lei|sozkla|leilei|litport|cpg848|mugi|mutopia|neerland|oschwb|pianosoc|lvr|wima|bmlo|adsfr|mat_adbk|aeik|badw|bbaw|ps_smmue|blo_lilla|bruemmer|dmv|dra_wr|esf|froebel|jenc1906|kaprbrd|kas_bvcdu|kas_person|leopoldina|mumi|nas_us|mfo_pc|saw_akt|saw_ehem|tripota|pacelli|preusker|cpl|rppd|baader_gelehrte|baader_schriftsteller|lipowsky_kuenstler|lipowsky_musiker|haw|zeno_eisler|zeno_mwfoto|zeno_mwkunst|zeno_pagel|zeno_schmidt"
						replaceLabels="reichka:Akten der Reichskanzlei. Weimarer Republik|archinform:Architekturdatenbank archINFORM|biocist:Biographia Cisterciensis (BioCist)|bbkl:Biographisch-Bibliographisches Kirchenlexikon (BBKL)|cmvw:Carl Maria von Weber Gesamtausgabe (WeGA)|reichstag:Datenbank der deutschen Parlamentsabgeordneten|adbreg:Deutsche Biographie (ADB/NDB)|gabio:Dictionary of Georgian Biography|poi_fmr:Digitaler Portraitindex Frühe Neuzeit|fembio:FemBio Frauen-Biographieforschung|lagis:Hessische Biographie|hls:Historisches Lexikon der Schweiz (HLS)|rism:Internationales Quellenlexikon der Musik (RISM)|historicum:Klassiker der Geschichtswissenschaft|lemo:Lebendiges virtuelles Museum Online (LeMO)|sandrart:Sandrart: Teutsche Academie der Bau-, Bild- und Mahlerey-Künste. 1675-80|odb:Ostdeutsche Biographie (Kulturstiftung der deutschen Vertriebenen)|odnb:Oxford Dictionary of Biography|rag:Repertorium Academicum Germanicum (RAG)|repfont_per:Repertorium Geschichtsquellen des deutschen Mittelalters|vkuka:Virtuelles Kupferstichkabinett|volchr:Vorarlberg Chronik|lassalle_all:Lasalle – Briefe und Schriften"
					/>

					<mcrdd:pndbeacon pnd="${pndString}"
						whitelist="ubr_biblgr|bibaug|dta|zbw|ri_opac|rektor|repfont_aut|gvk|vd17|wikisource|kalliope|ecodices|gw|latlib|pw_arxiv|pw_imslp|pw_mvbib|pw_perlentaucher|slub|hvv_lz|hvv_zh|notendatenbank|commons|cpdl|kreusch|rulib|liberley|pgde|sophie|wortblume|zeno|bsb|oenlv|vd16|zdn|lbbw|elk-wue|fmfa"
						replaceLabels="ubr_biblgr:Universitätsbibliographie Rostock|bibaug:Bibliotheca Augustana|dta:Deutsches Textarchiv|zbw:Pressemappe 20. Jahrhundert - Personenarchiv|ri_opac:Regesta Imperii OPAC|rektor:Rektoratsreden im 19. und 20. Jahrhundert|repfont_aut:Repertorium Geschichtsquellen des deutschen Mittelalters|gvk:Verbundkatalog des GBV|vd17:Verzeichnis der deutschen Drucke des 17.Jahrhunderts (VD17)|wikisource:Wikisource-Autorenseite"
					/>
					<br />
					<c:url var="url" value="${WebApplicationBaseURL}gnd/${pndString}" />
					<fmt:message key="OMD.PROFKAT.quoting.gnd">
      					<fmt:param>${url}</fmt:param>      			
      				</fmt:message>   				
    				</mcrdd:outputitem>
   			</x:if>                                             			   		 
   		</mcrdd:row>   				
	</c:if> 	
  	
	<c:if test="${(tab eq 'article') or (param.print eq 'true')}">
  		<mcrdd:row select="/mycoreobject/structure/derobjects/derobject[@xlink:label='display_biography']" labelkey="OMD.CPR.documents" showInfo="true" >
  			<mcrdd:derivatecontent select="." width="100%" encoding="UTF-8" />
  		</mcrdd:row>	
	</c:if>

	<c:if test="${(tab eq 'documents') or (param.print eq 'true')}">
		<mcrdd:row select="/mycoreobject/structure/derobjects/derobject" labelkey="OMD.CPR.derobjects" showInfo="true" >
			<mcrdd:derivatelist select="." showsize="true" />
	  	</mcrdd:row>
	</c:if>	
  	
  	<mcrdd:separator showLine="true" />
    
    <mcrdd:row select="/mycoreobject" labelkey="OMD.CPR.created_changed" showInfo="true" >
   		<%-- 06.10.2006, editorCP  /  17.06.2009, editorCP --%>
   		<mcrdd:item select="./service/servdates/servdate[@type='createdate']" datePattern ="dd.MM.yyyy" var="createdate"/>
   		<mcrdd:item select="./service/servdates/servdate[@type='modifydate']" datePattern ="dd.MM.yyyy" var="modifydate" />
   		<mcrdd:item select="./service/servflags/servflag[@type='createdBy']" var="createdBy"/>
   		<mcrdd:item select="./service/servflags/servflag[@type='modifiedBy']" var="modifiedBy" />
   		<mcrdd:outputitem select="." var="current">
   			${createdate},&#160;${createdBy}&#160;&#160;/&#160;&#160;${modifydate},&#160;${modifiedBy}
   		</mcrdd:outputitem>  
   	</mcrdd:row>
   	<%--
   	<mcrdd:row select="/mycoreobject" labelkey="OMD.CPR.link2page" showInfo="true" >
   		<mcrdd:item select="/mycoreobject/metadata/box.identifier/identifier[@type='pnd']" var="pnd"/>
   		<mcrdd:outputitem select="./@ID" var="current">
   			<c:if test="${(not empty(pnd)) and (pnd ne 'xxx')}">
   				<jsp:element name="a">
   					<jsp:attribute name="href">http://cpr.uni-rostock.de/pnd/${pnd}</jsp:attribute>
   					<jsp:body>http://cpr.uni-rostock.de/pnd/${pnd}</jsp:body>
   				</jsp:element>
   				</td></tr><tr><td class="docdetails-value">
   			</c:if>
   		    <jsp:element name="a">
   		   		<jsp:attribute name="href">http://cpr.uni-rostock.de/metadata/<x:out select="string($current)"/></jsp:attribute>
   		   		<jsp:body>http://cpr.uni-rostock.de/metadata/<x:out select="string($current)"/></jsp:body>
   		    </jsp:element>
   		</mcrdd:outputitem>
   	</mcrdd:row>
   	--%> 
   	
   	<mcrdd:row select="/mycoreobject" labelkey="OMD.CPR.quoting" showInfo="true" >
   		<mcrdd:item select="/mycoreobject/metadata/box.surname/surname" var="last"/>
   		<mcrdd:item select="/mycoreobject/metadata/box.firstname/firstname" var="first" />
   		<mcrdd:item select="/mycoreobject/metadata/box.identifier/identifier[@type='pnd']" var="pnd"/>
   		<jsp:useBean id="now" class="java.util.Date" scope="page" />
   		<mcrdd:outputitem select="./@ID" var="current">
   			<%-- OMD.CPR.quoting.text=Eintrag von &quot;{0}&quot; im Rostocker Professorenkatalog, URL: <a href="{1}">{1}</a> (abgerufen am {2})  --%> 
   			<c:set var="currentID"><x:out select="string($current)"/></c:set>
   			<c:url var="url" value="${WebApplicationBaseURL}resolve/id/${currentID}" />
   			<fmt:message key="OMD.PROFKAT.quoting.text">
      			<fmt:param>${first}&#160;${last}</fmt:param>
      			<fmt:param>${url}</fmt:param>
      			<fmt:param><fmt:formatDate value="${now}" pattern="dd.MM.yyyy" /></fmt:param>
      		</fmt:message>      			
   		</mcrdd:outputitem>
   	</mcrdd:row>
  </mcrdd:docdetails>