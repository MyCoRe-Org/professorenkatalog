package org.mycore.profkat.bpmn.workflows.create_object_simple;

import java.io.IOException;
import java.nio.file.Path;

import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.datamodel.metadata.MCRObjectID;
import org.mycore.jspdocportal.common.bpmn.MCRBPMNUtils;
import org.mycore.jspdocportal.common.bpmn.workflows.create_object_simple.MCRAbstractWorkflowMgr;
import org.mycore.jspdocportal.common.bpmn.workflows.create_object_simple.MCRWorkflowMgr;
import org.xml.sax.SAXParseException;

public class MCRWorkflowMgrPerson extends MCRAbstractWorkflowMgr implements MCRWorkflowMgr{
	/**
	 * 
	 * @param mcrObjID
	 * @return null if correct, errormessage otherwise
	 */
	@Override
	public String validate(MCRObjectID mcrObjID){
		Path wfFile = MCRBPMNUtils.getWorkflowObjectFile(mcrObjID);
		try {
			@SuppressWarnings("unused")
            MCRObject mcrWFObj = new MCRObject(wfFile.toUri());
		}
		catch(SAXParseException e){
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
