package org.mycore.frontend.workflowengine.guice;

import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowManager;
import org.mycore.frontend.workflowengine.jbpm.professorum.MCRDocumentDerivateStrategy;
import org.mycore.frontend.workflowengine.jbpm.professorum.MCRWorkflowManagerProfessorum;
import org.mycore.frontend.workflowengine.strategies.MCRDefaultPermissionStrategy;
import org.mycore.frontend.workflowengine.strategies.MCRDerivateStrategy;
import org.mycore.frontend.workflowengine.strategies.MCRMetadataStrategy;
import org.mycore.frontend.workflowengine.strategies.MCRPermissionStrategy;
import org.mycore.frontend.workflowengine.strategies.MCRProfessorumMetadataStrategie;

import com.google.inject.AbstractModule;

public class MCRProfessorumWorkflowModule  extends AbstractModule {

	public void configure() {
		bind(MCRWorkflowManager.class).to(MCRWorkflowManagerProfessorum.class);
		
		bind(MCRDerivateStrategy.class).to(MCRDocumentDerivateStrategy.class);
		bind(MCRPermissionStrategy.class).to(MCRDefaultPermissionStrategy.class);
		bind(MCRMetadataStrategy.class).to(MCRProfessorumMetadataStrategie.class);
		
	}

}
