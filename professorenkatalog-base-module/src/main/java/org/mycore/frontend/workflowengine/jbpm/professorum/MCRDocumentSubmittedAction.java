package org.mycore.frontend.workflowengine.jbpm.professorum;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.jbpm.context.exe.ContextInstance;
import org.jbpm.graph.exe.ExecutionContext;
import org.jdom2.Element;
import org.mycore.access.MCRAccessManager;
import org.mycore.common.config.MCRConfiguration;
import org.mycore.common.MCRException;
import org.mycore.common.xml.MCRXMLHelper;
import org.mycore.frontend.workflowengine.jbpm.MCRAbstractAction;
import org.xml.sax.SAXParseException;

public class MCRDocumentSubmittedAction extends MCRAbstractAction{
	
	String lockedVariables;
	private static final long serialVersionUID = 1L;
	private static Logger logger = Logger.getLogger(MCRDocumentSubmittedAction.class);
	private static Element editorModeRule;
	
	static{
		String strRule = MCRConfiguration.instance().getString("MCR.WorkflowEngine.defaultACL.editorMode.professorum", "<condition format=\"xml\"><boolean operator=\"or\"><condition field=\"group\" operator=\"=\" value=\"editprofessorum\" /></boolean></condition>");
		try{
			editorModeRule = (Element)MCRXMLHelper.parseXML(strRule,false).getRootElement().detach();
		}
		catch(SAXParseException e){
			logger.error(e);
		}
	}

	public void executeAction(ExecutionContext executionContext) throws MCRException {
		logger.debug("locking workflow variables and setting the access control to the editor mode");
		ContextInstance contextInstance = executionContext.getContextInstance();
		List<Object> ids = new ArrayList<Object>();
		ids.addAll(Arrays.asList(((String)contextInstance.getVariable("attachedDerivates")).split(",")));
		ids.add(contextInstance.getVariable("createdDocID"));
	//	Transaction tx = MCRHIBConnection.instance().getSession().beginTransaction();
		for (Iterator it = ids.iterator(); it.hasNext();) {
			String id = (String) it.next();
			Collection<String> permissions = MCRAccessManager.getPermissionsForID(id);
			for (Iterator<String> it2 = permissions.iterator(); it2.hasNext();) {
				String permission = (String) it2.next();
				MCRAccessManager.addRule(id, permission, editorModeRule, "");
			}
		}
		//tx.commit();
	}

}
