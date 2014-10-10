/**
 * $RCSfile: MCRWorkflowManagerProfessorum.java,v $
 * $Revision: 1.10 $ $Date: 2006/07/13 14:51:20 $
 *
 * This file is part of ** M y C o R e **
 * Visit our homepage at http://www.mycore.de/ for details.
 *
 * This program is free software; you can use it, redistribute it
 * and / or modify it under the terms of the GNU General Public License
 * (GPL) as published by the Free Software Foundation; either version 2
 * of the License or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program, normally in the file license.txt.
 * If not, write to the Free Software Foundation Inc.,
 * 59 Temple Place - Suite 330, Boston, MA  02111-1307 USA
 *
 **/

// package
package org.mycore.frontend.workflowengine.jbpm.professorum;

// Imported java classes
import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.jbpm.context.exe.ContextInstance;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.filter.Filters;
import org.jdom2.output.XMLOutputter;
import org.jdom2.xpath.XPathExpression;
import org.jdom2.xpath.XPathFactory;

import org.mycore.common.JSPUtils;
import org.mycore.common.MCRException;
import org.mycore.datamodel.metadata.MCRMetaLangText;
import org.mycore.datamodel.metadata.MCRMetadataManager;
import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.datamodel.metadata.MCRObjectID;
import org.mycore.frontend.workflowengine.guice.MCRProfessorumWorkflowModule;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowConstants;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowManager;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowProcess;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowProcessManager;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowUtils;
import org.mycore.frontend.workflowengine.strategies.MCRMetadataStrategy;
import org.mycore.frontend.workflowengine.strategies.MCRWorkflowDirectoryManager;
import org.mycore.user2.MCRUser;
import org.mycore.user2.MCRUserManager;

import com.google.inject.Guice;

/**
 * This class holds methods to manage the workflow file system of MyCoRe.
 * 
 * @author  Anja Schaar
 * @version $Revision: 1.0 $ $Date: 2006/07/18 14:51:20 $
 */

public class MCRWorkflowManagerProfessorum extends MCRWorkflowManager{
	
	
	private static Logger logger = Logger.getLogger(MCRWorkflowManagerProfessorum.class.getName());
	private static MCRWorkflowManager singleton;
	
	protected MCRWorkflowManagerProfessorum() throws Exception {
		super("person", "person", "professorum");	
	}

	
	/**
	 * Returns the disshab workflow manager singleton.
	 * @throws ClassNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static synchronized MCRWorkflowManager instance() throws Exception {
		if (singleton == null)
			singleton = Guice.createInjector(new MCRProfessorumWorkflowModule()).getInstance(MCRWorkflowManager.class);
		return singleton;
	}
	
	
	
	public long initWorkflowProcess(String initiator, String transitionName) throws MCRException {
			MCRWorkflowProcess wfp = createWorkflowProcess(workflowProcessType);
			try{
				wfp.initialize(initiator);
				wfp.save();
				MCRUser user = MCRUserManager.getUser(initiator);
				String email = user.getEMailAddress();
				if(email != null && !email.equals("")){
					wfp.setStringVariable(MCRWorkflowConstants.WFM_VAR_INITIATOREMAIL, email);
				}
				
				wfp.setStringVariable(MCRWorkflowConstants.WFM_VAR_FILECNT, "0");
				
				wfp.endTask("initialization", initiator, transitionName);
				
				return wfp.getProcessInstanceID();
			}catch(MCRException ex){
				logger.error("MCRWorkflow Error, could not initialize the workflow process", ex);
				throw new MCRException("MCRWorkflow Error, could not initialize the workflow process");
			}finally{
				if(wfp != null)
					wfp.close();
			}				
	}
	
	
	public long initWorkflowProcessForEditing(String initiator, String mcrid ){
		
		if (mcrid != null && MCRMetadataManager.exists(MCRObjectID.getInstance(mcrid))) {
			// Store Object in Workflow - Filesystem
			MCRObject mob = MCRMetadataManager.retrieveMCRObject(MCRObjectID.getInstance(mcrid));
			mob = setInitiatorInMetadata(initiator, mob);
			String type = mob.getId().getTypeId();			
			String atachedDerivates = JSPUtils.saveToDirectory(mob, MCRWorkflowDirectoryManager.getWorkflowDirectory(type));
			
			long processID = initWorkflowProcess(initiator, "go2processEditInitialized");
			
			MCRWorkflowProcess wfp = MCRWorkflowProcessManager.getInstance().getWorkflowProcess(processID);

			//String urn = this.identifierStrategy.getUrnFromDocument(mcrid);
			
			wfp.setStringVariable(MCRWorkflowConstants.WFM_VAR_METADATA_OBJECT_IDS, mcrid);
			//wfp.setStringVariable(MCRWorkflowConstants.WFM_VAR_RESERVATED_URN, urn);	
			wfp.setStringVariable(MCRWorkflowConstants.WFM_VAR_ATTACHED_DERIVATES, atachedDerivates);
			int filecnt =  (atachedDerivates.split("_derivate_")).length;
			wfp.setStringVariable("fileCnt", String.valueOf(filecnt));
			
			setWorkflowVariablesFromMetadata(  wfp.getContextInstance(), mob.createXML().getRootElement().getChild("metadata"));;
			setMetadataValid(mcrid, true,  wfp.getContextInstance());
			wfp.close();
			return processID;

		} else {
			return -1;
		}
	}
	
	public String checkDecisionNode(String decisionNode, ContextInstance ctxI) {
		if(decisionNode.equals("canDocumentBeSubmitted")){
			if(checkSubmitVariables(ctxI)){
				return "documentCanBeSubmitted";
			}else{
				return "documentCantBeSubmitted";
			}
		}else if(decisionNode.equals("canDocumentBeCommitted")){
			if(checkSubmitVariables(ctxI)){
				return "go2wasCommitmentSuccessful";
			}else{
				return "go2sendBackToDocumentCreated";
			}
		}
		return null;
	}

	private boolean checkSubmitVariables(ContextInstance ctxI){
		try{
			String createdDocID = (String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_METADATA_OBJECT_IDS);
			if(	!MCRWorkflowUtils.isEmpty(createdDocID)		){				
				String strDocValid = (String) ctxI.getVariable(MCRMetadataStrategy.VALID_PREFIX + createdDocID );
				if(strDocValid != null ){
					if(strDocValid.equals("true") ){
						return true;
					}
				}
			}
		}catch(MCRException ex){
			logger.error("catched error", ex);
		}
		return false;		
	}	
	
		
	public String createEmptyMetadataObject(ContextInstance ctxI){
		
	try{
		String type = (String)ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_METADATA_PUBLICATIONTYPE);
		MCRObjectID nextFreeId = getNextFreeID(type);
		String initiator = (String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_INITIATOR);
		String saveDirectory = MCRWorkflowDirectoryManager.getWorkflowDirectory(mainDocumentType);
		if(metadataStrategy.createEmptyMetadataObject(false,null,null, nextFreeId, initiator, null, null, saveDirectory) ){				
			permissionStrategy.setPermissions(nextFreeId.toString(),initiator,	getWorkflowProcessType(), ctxI,	MCRWorkflowConstants.PERMISSION_MODE_DEFAULT );
		//	MCRHIBConnection.instance().flushSession();
			return nextFreeId.toString();
		}
 	 } catch(MCRException ex){
			logger.error("could not create empty metadata object for professorum" );
 	 }
	 return null;
		
	}	
	
	public boolean commitWorkflowObject(ContextInstance ctxI){
		boolean bSuccess = false;
		try{
			String documentID = (String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_METADATA_OBJECT_IDS);
			String documentType = MCRObjectID.getInstance(documentID).getTypeId();
			String directory = MCRWorkflowDirectoryManager.getWorkflowDirectory(documentType);			
			
			bSuccess = metadataStrategy.commitMetadataObject(documentID, directory);
		//	MCRHIBConnection.instance().flushSession();
			String delDers = (String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_DELETED_DERIVATES);
			if ( delDers != null) {
				List<String> deletedDerIDs = Arrays.asList(((String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_DELETED_DERIVATES)).split(","));
				for (Iterator<String> it = deletedDerIDs.iterator(); it.hasNext();) {
					String derivateID = it.next();
					if ( derivateID != null && derivateID.length() > 0 && !derivateID.equals("null")) {
						derivateStrategy.deleteDeletedDerivates(derivateID);
					}
				}
			}
			if(ctxI.hasVariable(MCRWorkflowConstants.WFM_VAR_DELETED_FILES_IN_DERIVATES)){
				List<String> deletedDerFiles = Arrays.asList(((String)ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_DELETED_FILES_IN_DERIVATES)).split(","));
				for (Iterator<String> it = deletedDerFiles.iterator(); it.hasNext();) {
					String derivateFile= it.next();
					if ( derivateFile != null && derivateFile.length() > 0 ) {
						derivateStrategy.deleteDeletedDerivateFile(derivateFile);
					}
				}
			}
			String ders = (String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_ATTACHED_DERIVATES);
		//	MCRHIBConnection.instance().flushSession();
			if ( ders != null) {
				List<String> derivateIDs = Arrays.asList(((String) ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_ATTACHED_DERIVATES)).split(","));
				for (Iterator<String> it = derivateIDs.iterator(); it.hasNext();) {
					String derivateID = it.next();
					if ( derivateID != null && derivateID.length() > 0 ) {
						derivateStrategy.commitDerivateObject(derivateID, MCRWorkflowDirectoryManager.getWorkflowDirectory(documentType));
	//					MCRHIBConnection.instance().flushSession();
						//permissionStrategy.setPermissions(derivateID, null,	workflowProcessType, ctxI, MCRWorkflowConstants.PERMISSION_MODE_PUBLISH);
						permissionStrategy.removeAllPermissions(derivateID);
					}
				}
			}
			// readrule wird auf true gesetzt
			//permissionStrategy.setPermissions(documentID, null,	workflowProcessType, ctxI, MCRWorkflowConstants.PERMISSION_MODE_PUBLISH);
			permissionStrategy.removeAllPermissions(documentID);
			
			bSuccess = true;
		}catch(MCRException ex){
			logger.error("an error occurred", ex);
			ctxI.setVariable("varnameERROR", ex.getMessage());								
		}finally{
			
		}		
		return bSuccess;
	}
	
	public boolean removeWorkflowFiles(ContextInstance ctxI){
		boolean bSuccess = false;
		String workflowDirectory = MCRWorkflowDirectoryManager.getWorkflowDirectory(mainDocumentType);
		try{
			bSuccess = metadataStrategy.removeMetadataFiles(ctxI, workflowDirectory, deleteDir);
			bSuccess &= derivateStrategy.removeDerivates(ctxI,workflowDirectory, deleteDir);
		}catch(MCRException ex){
			logger.error("could not delete workflow files", ex);
			ctxI.setVariable("varnameERROR", ex.getMessage());						
		}finally{
		}
		return bSuccess;
	}
		
	private MCRObject setInitiatorInMetadata(String initiatorID, MCRObject mob){
		try {
			Document jDomMob = mob.createXML();
			XPathFactory xpfac = XPathFactory.instance();
								
			XPathExpression<Element> xpe = xpfac.compile("/mycoreobject/service/servflags/servflag[@type='editor']", Filters.element());
			Element editor = (Element) xpe.evaluateFirst(jDomMob);
			if ( editor != null ) { 
				editor.setText(initiatorID);
				logger.debug("Update initiators tag:" + initiatorID);
			} else {
				
				Element eInitiators = new Element("servflags");
				eInitiators.setAttribute("class","MCRMetaLangText");
				MCRMetaLangText initiator = new MCRMetaLangText();
				initiator.setSubTag("servflag");
				initiator.setLang("de");
				initiator.setText(initiatorID);
				
				initiator.setType("creator");
				Element eInitiator = initiator.createXML();
				eInitiators.addContent(eInitiator);

				initiator.setType("editor");
				eInitiator = initiator.createXML();	
				eInitiators.addContent(eInitiator);
				
				XPathExpression<Element> xpe2 = xpfac.compile("/mycoreobject/service", Filters.element());
				Element eService = (Element)  xpe2.evaluateFirst(jDomMob);
				eService.addContent(eInitiators);
				
				logger.debug("Created initiators tag:" + initiatorID);
			}
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			XMLOutputter xop = new XMLOutputter();
			
			xop.output(jDomMob, baos);
			mob = new MCRObject(baos.toByteArray(), true);

		} catch ( Exception all) {
			logger.error("can't set the initiators tag", all);
		}
		return mob;
	}
}
