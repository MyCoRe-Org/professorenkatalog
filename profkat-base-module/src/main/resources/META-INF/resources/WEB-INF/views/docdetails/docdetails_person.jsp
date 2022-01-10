<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.mycore.org/jspdocportal/base.tld" prefix="mcr" %>
<%@ taglib uri="http://www.mycore.org/jspdocportal/docdetails.tld" prefix="mcrdd" %>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>
<%-- Parameter: id - the MCR Object ID--%>
<%-- Parameter: fromWF - from Workflow or database --%>


	<%--Tab bar (begin) --%>
	<c:set var="tab" value="${param.tab}" />
	<c:if test="${empty tab}"><c:set var="tab" value="data" /></c:if>
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	<mcr:retrieveObject mcrid="${param.id}" varDOM="mcrobj" cache="true" fromWorkflow="${param.fromWF}" />
    
    <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/header.xsl" />
	
    <c:if test="${not(param.print eq 'true')}">
		<c:if test="${param.fromWF eq 'true'}">
				<div class="alert alert-info" style="margin-top:20px" role="alert">
					<h4 style="margin:5px 0px">
						<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
						<fmt:message key="WF.Preview" />
					</h4>
				</div>
		</c:if>
		<div  class="tabbar docdetails-tabbar" style="position:relative">
			<c:set var="msgKeyStatus">OMD.profkat.state.<x:out select="$mcrobj/mycoreobject/metadata/box.status/status"/></c:set>
			
			<c:set var="tabtokens" value="data|article|documents" />
			<ul id="tabs_on_page" class="nav nav-tabs" style="position:relative">
			 
				
				<c:forTokens items="${tabtokens}" delims="|" var="current" varStatus="status">
      				<c:set var="tabstyle" value="" /> 
					<c:if test="${current eq tab}">
						<c:set var="tabstyle" value="active" />
					</c:if>
					<c:if test="${current eq 'data'}">
						<li class="nav-item">
							<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
								<i class="fas fa-user docdetails-tabbar-icon"></i>
								<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
						</li>
					</c:if>
					<c:if test="${current eq 'article'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
									<i class="fas fa-book docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>		
					</c:if>
					<c:if test="${current eq 'documents'}">
						<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
							<li class="nav-item">
								<a class="nav-link ${tabstyle}" href="${WebApplicationBaseURL}resolve/id/${param.id}?tab=${current}${empty param._search ? '' : '&_search='.concat(param._search)}${param.fromWF eq 'true' ? '&fromWF=true' : ''}">
									<i class="far fa-file docdetails-tabbar-icon"></i>
									<fmt:message key="Webpage.docdetails.tabs.${current}"/></a>
							</li>
						</x:if>
					</c:if>
				</c:forTokens>
			</ul>
			<div class="docdetails-tabbar-info" style="position:absolute; top:5px; right:15px">
					<fmt:message key="${msgKeyStatus}" />
			</div>
		</div>
	</c:if>
	<%--Tab bar (end) --%>
  
  
   <c:if test="${(tab eq 'data') or (param.print eq 'true')}">
     <mcr:transformXSL dom="${mcrobj}" xslt="xsl/profkat/docdetails/metadata.xsl" />
   </c:if>

<mcrdd:docdetails mcrID="${param.id}" lang="de" fromWorkflow="${param.fromWF}" var="doc" outputStyle="headlines"> 
	<mcrdd:setnamespace prefix="xlink" uri="http://www.w3.org/1999/xlink" />
	 
   	 <c:if test="${(tab eq 'data') or (param.print eq 'true')}">
        <mcrdd:row select="/mycoreobject/metadata/box.surname/surname[position()>1] | /mycoreobject/metadata/box.variantname/variantname" labelkey="OMD.profkat.variantnames" showInfo="true" >
   			<mcrdd:item select="." />  
   		</mcrdd:row> 

   		<mcrdd:row select="/mycoreobject/metadata/box.firstname/firstname[position()>1]" labelkey="OMD.profkat.firstnames" showInfo="false" >
   			<mcrdd:item select="." />  
   		</mcrdd:row> 
    
		<mcrdd:row select="(/mycoreobject/metadata/box.birth/birth|/mycoreobject/metadata/box.death/death)[1]" labelkey="OMD.profkat.lifetimes" showInfo="true" colWidths="8em">
		  	<mcrdd:outputitem select="." var="data">
				<x:set var="birth_type" select="local-name($data/../../box.birth/birth)" />
				<x:set var="birth_place" select="string($data/../../box.birth/birth/event)" />
				<x:set var="birth_date" select="string($data/../../box.birth/birth/text)" />
				
				<x:set var="death_type" select="local-name($data/../../box.death/death)" />
				<x:set var="death_place" select="string($data/../../box.death/death/event)" />
				<x:set var="death_date" select="string($data/../../box.death/death/text)" />
				<c:if test="${not empty birth_type}">
				<nobr>
					<fmt:message key="OMD.common.born" />
					<c:if test="${(not empty birth_date) and (birth_date ne'#')}">
						<c:if test="${fn:contains(birth_date, '.')}">
							<fmt:message key="OMD.common.at" />
						</c:if>
						<c:out value="${birth_date}" />
					</c:if> 
					<c:if test="${(not empty birth_place) and (birth_place ne '#')}">
						<fmt:message key="OMD.common.in" />
						<c:out value="${birth_place}" />
					</c:if>
				</nobr>
				</c:if>
				
				<c:if test="${(not empty birth_type) and (not empty death_type)}">
					</td></tr>
					<tr><td class="docdetails-value">
				</c:if>   				
				
				
				<c:if test="${not empty death_type}">
				<nobr>
					<fmt:message key="OMD.common.died" />
	
					<c:if test="${(not empty death_date) and (death_date ne '#')}">
						<c:if test="${fn:contains(death_date, '.')}">
							<fmt:message key="OMD.common.at" />
						</c:if>
						<c:out value="${death_date}" />
					</c:if> 
					<c:if test="${(not empty death_place) and (death_place ne '#')}">
						<fmt:message key="OMD.common.in" />
						<c:out value="${death_place}" />
					</c:if>
				</nobr>			
				</c:if>
   			</mcrdd:outputitem>   
    	</mcrdd:row>
   		
   		<mcrdd:row select="/mycoreobject/metadata/box.confession/confession" labelkey="OMD.profkat.confessions" showInfo="false" >
   			<mcrdd:item select="." />  
   		</mcrdd:row> 
   	
   		<mcrdd:row select="/mycoreobject/metadata/box.family/family" labelkey="OMD.profkat.families" showInfo="true" colWidths="8em" >
			<mcrdd:item select="./@type" labelkeyPrefix="OMD.profkat.family."/> 
			<mcrdd:outputitem select="." var="current">
 	  			<c:set var="name"><x:out select="$current/name" escapeXml="false" /></c:set>
		 		<c:set var="profession"><x:out select="$current/profession" escapeXml="false"/></c:set>
		 		<c:set var="url"><x:out select="$current/name/@id" escapeXml="false"/></c:set>

               
				<c:choose>
        
				  <c:when test="${fn:length(url) <= 1}">
                    <c:set var="output" value="" />
					<c:if test="${fn:length(name) gt 1}">
					  <c:set var="output" value="${name}" />
					  <c:if test="${fn:length(profession) gt 1}">
                          <c:set var="output" value="${output},&#160;" />
                      </c:if>
				    </c:if>
				    <c:if test="${fn:length(profession) gt 1}">
					  <c:set var="output" value="${output}${profession}" /> 
				    </c:if>
                    <c:out value="${output}" escapeXml="false" />
				  </c:when>
				    
				   <c:when test="${fn:startsWith(param.id, 'cpb_')}">
				   	<jsp:element name="a">	
						<jsp:attribute name="href">
							<c:out value="${url}" />
						</jsp:attribute>
						<jsp:attribute name="target">_blank</jsp:attribute>
						<jsp:body>
				          <c:set var="output" value="" />
					      <c:if test="${fn:length(name) gt 1}">
					        <c:set var="output" value="${name}" />
					        <c:if test="${fn:length(profession) gt 1}">
                              <c:set var="output" value="${output},&#160;" />
                            </c:if>
				          </c:if>
				          <c:if test="${fn:length(profession) gt 1}">
					        <c:set var="output" value="${output}${profession}" /> 
				          </c:if>
                          <c:out value="${output}" escapeXml="false" />
				        </jsp:body>	
					</jsp:element>
				   </c:when>
				   <c:otherwise>
				    <c:set var="output" value="" />
					<c:if test="${fn:length(name) gt 1}">
					  <c:set var="output" value="${name}" />
					  <c:if test="${fn:length(profession) gt 1}">
                          <c:set var="output" value="${output},&#160;" />
                      </c:if>
				    </c:if>
				    <c:if test="${fn:length(profession) gt 1}">
					  <c:set var="output" value="${output}${profession}" /> 
				    </c:if>
                    <c:out value="${output}" escapeXml="false" />
					<jsp:element name="a">	
						<jsp:attribute name="href">
							<c:out value="${url}" />
						</jsp:attribute>
						<jsp:attribute name="target">_blank</jsp:attribute>
						<jsp:body>
					   		<nobr> (<fmt:message key="OMD.profkat.link.external" />
			    			   	<img src="${WebApplicationBaseURL}images/link_extern.png"
							alt="Link" />)</nobr>
						</jsp:body>	
					</jsp:element>
				  </c:otherwise>
				  </c:choose>
   			</mcrdd:outputitem>
   		</mcrdd:row> 
   	
   		<mcrdd:separator showLine="true" />	   
      	<mcrdd:row select="/mycoreobject/metadata/box.biographic/biographic" labelkey="OMD.profkat.biographics" showInfo="true" colWidths="8em">
	  		<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>

  		<mcrdd:row select="/mycoreobject/metadata/box.academicdegree/academicdegree" labelkey="OMD.profkat.academicdegrees" showInfo="true" colWidths="8em 6em">
    		<mcrdd:item select="./@type" labelkeyPrefix="OMD.profkat.academicdegree.display."/>
    		<mcrdd:item select="./time" />              
 			<mcrdd:outputitem select="." var="current">
   				<x:out select="$current/text" />
   				<c:set var="diss"><x:out select="$current/dissertation" escapeXml="false" /></c:set>
   				<c:if test="${fn:length(diss) gt 1}">
   					<br /><i><fmt:message key="OMD.profkat.dissertationTitle"/>:&#160;</i><c:out value="${diss}" escapeXml="false"/>
   				</c:if>
   			</mcrdd:outputitem> 
    	</mcrdd:row>
		
		<mcrdd:separator showLine="true" />	
   	
   		<mcrdd:row select="/mycoreobject/metadata/box.adminfunction/adminfunction" labelkey="OMD.profkat.adminfunctions" showInfo="true" colWidths="8em">
			<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>

   		<mcrdd:row select="/mycoreobject/metadata/box.otherfunction/otherfunction" labelkey="OMD.profkat.otherfunctions" showInfo="true" colWidths="8em">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>
    
    	<mcrdd:row select="/mycoreobject/metadata/box.membership/membership[@type='scientific']" labelkey="OMD.profkat.scientific_memberships" showInfo="true" colWidths="8em">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>
    	
    	<mcrdd:row select="/mycoreobject/metadata/box.membership/membership[not(@type='party') and not(@type='scientific')]" labelkey="OMD.profkat.other_memberships" showInfo="true" colWidths="8em">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>

   		<mcrdd:row select="/mycoreobject/metadata/box.award/award" labelkey="OMD.profkat.awards" showInfo="true" colWidths="8em">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>
    	
    	<mcrdd:row select="/mycoreobject/metadata/box.partymember/partymember" labelkey="OMD.profkat.partymembers" showInfo="true" colWidths="8em">
		  	<mcrdd:item select="./time" />              
    		<mcrdd:item select="./text" escapeXml="false" />  
    	</mcrdd:row>

   		<mcrdd:row select="/mycoreobject/metadata/box.otherinfo/otherinfo" labelkey="OMD.profkat.otherinfos" showInfo="true" >
		  	<mcrdd:item select="." escapeXml="false" />  
    	</mcrdd:row>         

		<mcrdd:separator showLine="true" />

		<x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">
   			<mcrdd:row select="/mycoreobject/metadata/box.mainpublication/mainpublication" labelkey="OMD.profkat.mainpublications" showInfo="true" >
		  		<mcrdd:item select="." escapeXml="false"/>
    		</mcrdd:row>
        </x:if>
          
   		<mcrdd:row select="/mycoreobject/metadata/box.publicationslink/publicationslink" 
   		       labelkey="OMD.profkat.bibliographicrefs" showInfo="true" >
   			<mcrdd:outputitem select="." var="current">
   		   		<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" escapeXml="false"/></c:set>
   				<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<jsp:include page="fragments/link_pk.jsp">
   					<jsp:param name="href" value="${href}" />
   					<jsp:param name="title" value="${title}" />
   					<jsp:param name="mcrid" value="${param.id}" />
   				</jsp:include>
   			</mcrdd:outputitem> 
   		</mcrdd:row>  
 		
  		<mcrdd:separator showLine="true" />	

   		<mcrdd:row select="/mycoreobject/metadata/box.source/source" labelkey="OMD.profkat.sources" showInfo="true" >
   			<mcrdd:outputitem select="." var="current">
   				<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" escapeXml="false"/></c:set>
   				<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   				<jsp:include page="fragments/link_pk.jsp">
   					<jsp:param name="href" value="${href}" />
   					<jsp:param name="title" value="${title}" />
   					<jsp:param name="mcrid" value="${param.id}" />
   				</jsp:include>
   			</mcrdd:outputitem> 
   		</mcrdd:row>  

		<mcrdd:row select="/mycoreobject/metadata/box.complexref/complexref|/mycoreobject/metadata/box.reference/reference" 
   		           labelkey="OMD.profkat.references" showInfo="true" >   
   			<mcrdd:outputitem select="." var="current">
   		   		<x:set var="linkData" select="$current" scope="session" />
   		   		<x:set var="doc" select="$doc" scope="session" />
   		   	   	<x:if select="local-name($current)='reference'">
   					<c:set var="href"><x:out select="string($current/@*[local-name()='href' and namespace-uri()='http://www.w3.org/1999/xlink'])" escapeXml="false"/></c:set>
   					<c:set var="title"><x:out select="string($current/@*[local-name()='title' and namespace-uri()='http://www.w3.org/1999/xlink'])" /></c:set>
   					<jsp:include page="fragments/link_pk.jsp">
   						<jsp:param name="href" value="${href}" />
   						<jsp:param name="title" value="${title}" />
   						<jsp:param name="mcrid" value="${param.id}" />
   					</jsp:include>
   				</x:if>
   				<x:if select="local-name($current)='complexref'">
   					<c:set var="content"><x:out select="$current/text()" /></c:set>
   					<mcrdd:complexref content="${content}" />
   				</x:if>
   			</mcrdd:outputitem> 
   		</mcrdd:row> 
   		
   		<mcrdd:row select="/mycoreobject/metadata/box.identifier/identifier[@type='gnd']" labelkey="OMD.profkat.onlineres" showInfo="true" >
   			<mcrdd:item select="/mycoreobject/metadata/box.identifier/identifier[@type='gnd']" var="pnd" />
   			<x:if select="string($pnd)='xxx'">
   				<mcrdd:outputitem select="." var="x">
   					<fmt:message key="OMD.profkat.identifier.nognd" />
   				</mcrdd:outputitem>
   			</x:if>
   			<x:if select="string($pnd)!='xxx'">
   				<mcrdd:outputitem select="." var="x">
   					<c:set var="pndString"><x:out select="string($pnd)" /></c:set>
   					<div class="float-right"><a class="btn btn-xs float-right" href="${WebApplicationBaseURL}profkat_beacon_data?gnd=${pndString}" title="PND Beacon Dataservice Result"><i class="fas fa-paperclip" style="color:#EFEFEF;"></i></a></div>
					GND: <a target="beacon_result" href="http://d-nb.info/gnd/${pndString}" title="Eintrag in der Personennamendatei (PND)">${pndString}</a>
					
					<c:set var="otherpks"></c:set>
					<x:if select="starts-with($mcrobj/mycoreobject/@ID,'cpr_')">
   						<c:set var="otherpks">"hpk", </c:set>
   					</x:if>
   					<x:if select="starts-with($mcrobj/mycoreobject/@ID,'cph_')">
   						<c:set var="otherpks">"cpr", </c:set>
   					</x:if>
					
					<div class="profkat-beacon-result" title="http://d-nb.info/gnd/${pndString}"
						data-profkat-beacon-whitelist='[${otherpks} "dewp@pd", "mat_hr", "cphel", "cpmz", "reichka", "archinform", "cphal@hk", "biocist", "bbkl", "cmvw", "reichstag", "adbreg", "gabio", "poi_fmr", "fembio", "leopoldina@hk", "lagis", "hls", "rism", "historicum", "lemo", "sandrart", "odb", "odnb", "rag", "repfont_per", "adam", "vkuka", "volchr", "lassalle_all", "lwl", "gesa", "dewp", "hafaspo", "litirol", "plnoe", "regacad", "vorleser", "wwwddr", "documenta", "ps_usbk", "pw_artcyclop", "pw_basiswien", "pw_discogs", "pw_ifa", "pw_kunstaspekte", "pw_lexm", "pw_mactut", "pw_mgp", "pw_musicbrainz", "pw_nobel", "pw_olgdw", "pw_orden", "pw_photonow", "pw_rkd", "pw_rwien", "pw_sbo", "pw_sikart", "gistb", "dingler", "saebi", "ads", "ausfor", "bbcyp", "ariadne_fib2", "sdi_lei", "sozkla", "leilei", "litport", "cpg848", "mugi", "mutopia", "neerland", "oschwb", "pianosoc", "lvr", "wima", "bmlo", "adsfr", "mat_adbk", "aeik", "badw", "bbaw", "ps_smmue", "blo_lilla", "bruemmer", "dmv", "dra_wr", "esf", "froebel", "jenc1906", "kaprbrd", "kas_bvcdu", "kas_person", "leopoldina", "mumi", "nas_us", "mfo_pc", "saw_akt", "saw_ehem", "tripota", "pacelli", "preusker", "cpl", "rppd", "baader_gelehrte", "baader_schriftsteller", "lipowsky_kuenstler", "lipowsky_musiker", "haw", "zeno_eisler", "zeno_mwfoto", "zeno_mwkunst", "zeno_pagel", "zeno_schmidt"]'
						data-profkat-beacon-replaceLabels="reichka:Akten der Reichskanzlei. Weimarer Republik|archinform:Architekturdatenbank archINFORM|biocist:Biographia Cisterciensis (BioCist)|bbkl:Biographisch-Bibliographisches Kirchenlexikon (BBKL)|cmvw:Carl Maria von Weber Gesamtausgabe (WeGA)|reichstag:Datenbank der deutschen Parlamentsabgeordneten|adbreg:Deutsche Biographie (ADB/NDB)|gabio:Dictionary of Georgian Biography|poi_fmr:Digitaler Portraitindex Frühe Neuzeit|fembio:FemBio Frauen-Biographieforschung|lagis:Hessische Biographie|hls:Historisches Lexikon der Schweiz (HLS)|rism:Internationales Quellenlexikon der Musik (RISM)|historicum:Klassiker der Geschichtswissenschaft|lemo:Lebendiges virtuelles Museum Online (LeMO)|sandrart:Sandrart: Teutsche Academie der Bau-, Bild- und Mahlerey-Künste. 1675-80|odb:Ostdeutsche Biographie (Kulturstiftung der deutschen Vertriebenen)|odnb:Oxford Dictionary of Biography|rag:Repertorium Academicum Germanicum (RAG)|repfont_per:Repertorium Geschichtsquellen des deutschen Mittelalters|vkuka:Virtuelles Kupferstichkabinett|volchr:Vorarlberg Chronik|lassalle_all:Lasalle – Briefe und Schriften"
					></div>

					<div class="profkat-beacon-result" title="http://d-nb.info/gnd/${pndString}"
					   data-profkat-beacon-whitelist='["ubr_biblgr", "bibaug", "dta", "zbw", "ri_opac", "rektor", "repfont_aut", "gvk", "vd17", "wikisource", "kalliope", "ecodices", "gw", "latlib", "pw_arxiv", "pw_imslp", "pw_mvbib", "pw_perlentaucher", "slub", "hvv_lz", "hvv_zh", "notendatenbank", "commons", "cpdl", "kreusch", "rulib", "liberley", "pgde", "sophie", "wortblume", "zeno", "bsb", "oenlv", "vd16", "zdn", "lbbw", "elk-wue", "fmfa"]'
					   data-profkat-beacon-replaceLabels="ubr_biblgr:Universitätsbibliographie Rostock|bibaug:Bibliotheca Augustana|dta:Deutsches Textarchiv|zbw:Pressemappe 20. Jahrhundert - Personenarchiv|ri_opac:Regesta Imperii OPAC|rektor:Rektoratsreden im 19. und 20. Jahrhundert|repfont_aut:Repertorium Geschichtsquellen des deutschen Mittelalters|gvk:Verbundkatalog des GBV|vd17:Verzeichnis der deutschen Drucke des 17.Jahrhunderts (VD17)|wikisource:Wikisource-Autorenseite"
					></div>
					<script type="text/javascript" src="${WebApplicationBaseURL}js/profkat_gndbeacon.js"></script>
					
					<x:if select="starts-with($mcrobj/mycoreobject/@ID,'cpb_')">
					<div id="digibib_bs_link" class="profkat-beacon-result d-none" data-gnd="${pndString}">
					  <ul style="list-style-position:inside">
					    <li>
					      <a target="beacon_result" href="https://publikationsserver.tu-braunschweig.de/servlets/solr/find?condQuery=${pndString}">
					        <span id="digibib_bs_link_numfound" ></span> <fmt:message key="OMD.profkat.cpb.documents_in_digibib" />
					      </a>
					    </li>
					  </ul>
					</div>

					<script type="text/javascript">
					  $.ajax({
						  type : "GET",
						  url : "https://publikationsserver.tu-braunschweig.de/api/v1/search?q=allMeta%3D"+$('#digibib_bs_link').attr('data-gnd') +"&wt=json&json.wrf=?",
						  dataType : "jsonp",
						  success : function(data) {
							  var c = data.response.numFound;
							  if(c>0){
						  		$('#digibib_bs_link_numfound').text(c);
						  		$('#digibib_bs_link').removeClass('d-none');
							  }
							  
						  }});
					</script>
					</x:if>
					
					<c:url var="url" value="${WebApplicationBaseURL}resolve/gnd/${pndString}" />
					<p>
						<fmt:message key="OMD.profkat.quoting.gnd">
      						<fmt:param>${url}</fmt:param>
      					</fmt:message>
      				</p>   				
    				</mcrdd:outputitem>
   			</x:if>                                             			   		 
   		</mcrdd:row>
        <x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">   
   		<mcrdd:row select="/mycoreobject/metadata/box.epoch/epoch" 
   		           labelkey="OMD.profkat.classification" showInfo="true"  colWidths="8em">
   		    <mcrdd:outputitem select="." var="current">
   		       <x:if select="local-name($current)='epoch'">
   		       	<fmt:message key="OMD.profkat.epoch" />:
   		       </x:if>
   			</mcrdd:outputitem> 
   		              
   			<mcrdd:outputitem select="." var="current">
   				<x:if select="local-name($current)='epoch'">
   			    	<c:set var="classid"><x:out select="$current/@classid" /></c:set>
    				<c:set var="categid"><x:out select="$current/@categid" /></c:set>
   					<mcr:displayCategory categid="${categid}" classid="${classid}" lang="de"/>
   				</x:if>
   		   </mcrdd:outputitem>
   		</mcrdd:row>
        </x:if> 	
	</c:if> 	
  	
	<c:if test="${(tab eq 'article') or (param.print eq 'true')}">
  		<mcrdd:row select="/mycoreobject/structure/derobjects/derobject[@xlink:title='display_biography']" labelkey="OMD.profkat.documents" showInfo="true" >
  			<mcrdd:derivatecontent select="." width="100%" encoding="UTF-8" />
  		</mcrdd:row>	
	</c:if>

	<c:if test="${(tab eq 'documents') or (param.print eq 'true')}">
		<x:if select="$mcrobj/mycoreobject/structure/derobjects/derobject">
			<div class="docdetails-block">
				<div class="card card-sm panel-copyright">
					<div class="card-body">
  						<fmt:message key="OMD.derivate.copyright.notice" />
	               </div>
				</div>
			</div>
		</x:if>
		<mcrdd:row select="/mycoreobject/structure/derobjects[./derobject]" labelkey="OMD.profkat.derobjects" showInfo="true" >
			<x:forEach var="x" select="$doc/mycoreobject/structure/derobjects/derobject/@xlink:href">
	 			 <c:set var="id"><x:out select="$x" /></c:set>
 				 <search:derivate-list derid="${id}" showSize="true" />
 		  </x:forEach>
	  	</mcrdd:row>
	</c:if>	
  	
  	<mcrdd:separator showLine="true" />
    
    <mcrdd:row select="/mycoreobject" labelkey="OMD.profkat.created_changed" showInfo="true" >
   		<%-- 06.10.2006, editorCP  /  17.06.2009, editorCP --%>
   		<mcrdd:item select="./service/servdates/servdate[@type='createdate']" datePattern ="dd.MM.yyyy" var="createdate"/>
   		<mcrdd:item select="./service/servdates/servdate[@type='modifydate']" datePattern ="dd.MM.yyyy" var="modifydate" />
   		<x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">
   			<mcrdd:item select="./service/servflags/servflag[@type='createdby']" var="createdBy"/>
   			<mcrdd:item select="./service/servflags/servflag[@type='modifiedby']" var="modifiedBy" />
   		</x:if>
   		<mcrdd:outputitem select="." var="current">
   			${createdate}${empty createdBy ? '' : ',&#160;'.concat(createdBy)}&#160;&#160;/&#160;&#160;${modifydate}${empty modifiedBy ? '' : ',&#160;'.concat(modifiedBy)}
   		</mcrdd:outputitem>  
   	</mcrdd:row>
   	
   	<x:if select="not(starts-with($mcrobj/mycoreobject/@ID,'cpb_'))">
   	<mcrdd:row select="/mycoreobject" labelkey="OMD.profkat.quoting" showInfo="true" >
   		<mcrdd:item select="/mycoreobject/metadata/box.surname/surname" var="last"/>
   		<mcrdd:item select="/mycoreobject/metadata/box.firstname/firstname" var="first" />
   		<jsp:useBean id="now" class="java.util.Date" scope="page" />
   		<mcrdd:outputitem select="./@ID" var="current">
   			<%-- OMD.profkat.quoting.text=Eintrag von &quot;{0}&quot; im Rostocker Professorenkatalog, URL: <a href="{1}">{1}</a> (abgerufen am {2})  --%> 
   			<c:set var="currentID"><x:out select="string($current)"/></c:set>
   			<c:url var="url" value="${WebApplicationBaseURL}resolve/id/${currentID}" />
   			<c:if test="${fn:startsWith(currentID, 'cpr_')}">
   				<c:url var="url" value="http://purl.uni-rostock.de/cpr/${fn:substringAfter(currentID,'cpr_person_')}" />
   			</c:if>
   			<fmt:message key="OMD.profkat.quoting.text">
      			<fmt:param>${first}&#160;${last}</fmt:param>
      			<fmt:param>${url}</fmt:param>
      			<fmt:param>${url}</fmt:param>
      			<fmt:param><fmt:formatDate value="${now}" pattern="dd.MM.yyyy" /></fmt:param>
      		</fmt:message>      			
   		</mcrdd:outputitem>
   	</mcrdd:row>
   	</x:if>
   	
   	<c:if test="${param.fromWF eq 'true'}">
		<div class="alert alert-info" style="margin-top:20px" role="alert">
			<h4 style="margin:5px 0px">
				<a class="btn btn-secondary btn-sm float-right" href="${WebApplicationBaseURL}showWorkspace.action?mode=profkat"><fmt:message key="WF.Preview.return" /></a>
				<fmt:message key="WF.Preview" />
			</h4>
		</div>
	</c:if>	
  </mcrdd:docdetails>