package org.mycore.profkat.bpmn.workflows.create_object_simple;

import java.io.IOException;
import java.nio.file.Path;

import org.jdom2.JDOMException;
import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.datamodel.metadata.MCRObjectID;
import org.mycore.jspdocportal.common.bpmn.MCRBPMNUtils;
import org.mycore.jspdocportal.common.bpmn.workflows.create_object_simple.MCRAbstractWorkflowMgr;
import org.mycore.jspdocportal.common.bpmn.workflows.create_object_simple.MCRWorkflowMgr;

/**
 * WorkflowManager implementation for Profkat person objects
 * 
 * @author Robert Stephan
 *
 */
public class MCRWorkflowMgrPerson extends MCRAbstractWorkflowMgr implements MCRWorkflowMgr{
	/**
	 * 
	 * @param mcrObjID - the MyCoRe object ID of the person
	 * @return null if correct, errormessage otherwise
	 */
	@Override
	public String validate(MCRObjectID mcrObjID){
		Path wfFile = MCRBPMNUtils.getWorkflowObjectFile(mcrObjID);
		try {
			@SuppressWarnings("unused")
            MCRObject mcrWFObj = new MCRObject(wfFile.toUri());
		}
		catch(JDOMException e){
			return "XML Error: "+e.getMessage();
		}
		catch(IOException e){
			return "I/O-Error: "+e.getMessage();
		}
		return null;
		
	}

    @Override
    protected String getDefaultMetadataXML(String mcrBase) {
        return "<metadata>"
            +"<box.surname class='MCRMetaLangText'>"
            +"  <surname inherited='0' form='plain'>Neue/r Professor/-in</surname>"
            +"</box.surname>"
            + "</metadata>";
    }
	
}
