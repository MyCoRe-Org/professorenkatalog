package org.mycore.activiti.workflows.create_object_simple.person;

import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Path;

import org.jdom2.Document;
import org.jdom2.input.SAXBuilder;
import org.mycore.activiti.MCRActivitiUtils;
import org.mycore.activiti.workflows.create_object_simple.MCRAbstractWorkflowMgr;
import org.mycore.activiti.workflows.create_object_simple.MCRWorkflowMgr;
import org.mycore.common.MCRException;
import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.datamodel.metadata.MCRObjectID;
import org.mycore.datamodel.metadata.MCRObjectMetadata;
import org.xml.sax.SAXParseException;

public class MCRWorkflowMgrPerson extends MCRAbstractWorkflowMgr implements MCRWorkflowMgr{
	private static final String DEFAULT_METADATA_XML =""
	+"<metadata>"
    +"<box.surname class='MCRMetaLangText'>"
    +"  <surname inherited='0' form='plain'>Neue/r Professor/-in</surname>"
    +"</box.surname>"
    + "</metadata>";

	
	@Override
	public MCRObjectMetadata getDefaultMetadata() {
		SAXBuilder sax = new SAXBuilder();
		try{
		  Document doc = sax.build(new StringReader(DEFAULT_METADATA_XML));
		  MCRObjectMetadata mcrOMD = new MCRObjectMetadata();
		  mcrOMD.setFromDOM(doc.getRootElement());
		  return mcrOMD;
		}
		catch(Exception e){
			throw new MCRException("Could not create default metadata", e);
		}
	}

	
	/**
	 * 
	 * @param mcrObjID
	 * @return null if correct, errormessage otherwise
	 */
	@Override
	public String validate(MCRObjectID mcrObjID){
		Path wfFile = MCRActivitiUtils.getWorkflowObjectFile(mcrObjID);
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
	
}
