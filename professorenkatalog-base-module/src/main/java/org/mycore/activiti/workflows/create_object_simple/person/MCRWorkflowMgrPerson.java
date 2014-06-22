package org.mycore.activiti.workflows.create_object_simple.person;

import java.io.StringReader;

import org.jdom2.Document;
import org.jdom2.input.SAXBuilder;
import org.mycore.activiti.workflows.create_object_simple.MCRAbstractWorkflowMgr;
import org.mycore.common.MCRException;
import org.mycore.datamodel.metadata.MCRObjectMetadata;

public class MCRWorkflowMgrPerson extends MCRAbstractWorkflowMgr implements org.mycore.activiti.workflows.create_object_simple.MCRWorkflowMgr{
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

	
}
