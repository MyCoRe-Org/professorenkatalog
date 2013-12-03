package org.mycore.frontend.workflowengine.jbpm.professorum;

import org.jbpm.graph.exe.ExecutionContext;
import org.mycore.common.MCRException;
import org.mycore.frontend.workflowengine.jbpm.MCRAbstractAction;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowConstants;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowManager;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowManagerFactory;

public class MCRCreateDocumentAction extends MCRAbstractAction {
	
	
	private static final long serialVersionUID = 1L;
	private static MCRWorkflowManager WFM = MCRWorkflowManagerFactory.getImpl("professorum");

	public void executeAction(ExecutionContext executionContext) {
		logger.debug("creating empty professorum document");
		executionContext.setVariable(MCRWorkflowConstants.WFM_VAR_METADATA_PUBLICATIONTYPE, "person");
		String createdDocID = WFM.createEmptyMetadataObject(executionContext.getContextInstance());
		if(createdDocID != null && !createdDocID.equals("")){
			executionContext.setVariable(MCRWorkflowConstants.WFM_VAR_METADATA_OBJECT_IDS, createdDocID);
			executionContext.setVariable(MCRWorkflowConstants.WFM_VAR_ATTACHED_DERIVATES, "");
		}else{
			String errMsg = "could not create a docID for person";
			logger.error(errMsg);
			throw new MCRException(errMsg);
		}
	}

}
