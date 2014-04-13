package org.mycore.frontend.workflowengine.strategies;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jbpm.context.exe.ContextInstance;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.filter.ElementFilter;
import org.jdom2.output.Format;
import org.jdom2.output.XMLOutputter;
import org.mycore.common.MCRException;
import org.mycore.common.MCRSessionMgr;
import org.mycore.datamodel.common.MCRActiveLinkException;
import org.mycore.datamodel.metadata.MCRMetaLangText;
import org.mycore.datamodel.metadata.MCRMetadataManager;
import org.mycore.datamodel.metadata.MCRObject;
import org.mycore.datamodel.metadata.MCRObjectID;
import org.mycore.datamodel.metadata.MCRObjectService;
import org.xml.sax.SAXParseException;

public class MCRProfessorumMetadataStrategie extends MCRDefaultMetadataStrategy{
	private static String XSI_URL = "http://www.w3.org/2001/XMLSchema-instance";
	public MCRProfessorumMetadataStrategie() {
		super("person");
	}

	@SuppressWarnings("rawtypes")
	public boolean createEmptyMetadataObject(boolean authorRequired, List authorIDs, List authors, 
			MCRObjectID nextFreeObjectId, 	String userid,	Map identifiers, String publicationType,
			String saveDirectory){
		
		Element mycoreobject = new Element ("mycoreobject");				
		mycoreobject.addNamespaceDeclaration(org.jdom2.Namespace.getNamespace("xsi", XSI_URL));
		mycoreobject.setAttribute("noNamespaceSchemaLocation", 
					"datamodel-" + nextFreeObjectId.getTypeId() +".xsd", 
					org.jdom2.Namespace.getNamespace("xsi", XSI_URL));		
		
		Element structure = new Element ("structure");			
		Element metadata = new Element ("metadata");	
		Element service = new MCRObjectService().createXML();

		Element eInitiators = new Element("servflags");
		eInitiators.setAttribute("class","MCRMetaLangText");
		MCRMetaLangText initiator = new MCRMetaLangText();
		initiator.setSubTag("servflag");
		initiator.setLang("de");
		initiator.setText(userid);
		
		initiator.setType("creator");
		Element eInitiator = initiator.createXML();
		eInitiators.addContent(eInitiator);

		initiator.setType("editor");
		eInitiator = initiator.createXML();	
		eInitiators.addContent(eInitiator);
		service.addContent(eInitiators);
		mycoreobject.addContent(structure);
		mycoreobject.addContent(metadata);
		mycoreobject.addContent(service);
	    
		// ID Setzen
		String nextID = nextFreeObjectId.toString();
		mycoreobject.setAttribute("ID", nextID);	 
		mycoreobject.setAttribute("label", nextID);

		Document mycoreobjectdoc = new Document(mycoreobject);
		MCRObject prof = null;
	
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			XMLOutputter xop = new XMLOutputter();
			try {
				xop.output(mycoreobjectdoc, baos);
				prof = new MCRObject(baos.toByteArray(), false);
			} catch (IOException e) {
				logger.error(e);
			}
			catch(SAXParseException e){
				logger.error(e);
			}
			
			FileOutputStream fos = new FileOutputStream(saveDirectory + "/" + nextID + ".xml");
			(new XMLOutputter(Format.getPrettyFormat())).output(mycoreobject,fos);
			fos.close();
		} catch ( Exception ex){
			logger.warn("Could not create professorum data object " +  nextID );
			return false;
		}

   	    return true;		
	}

	public void setWorkflowVariablesFromMetadata(ContextInstance ctxI, Element metadata){	
		try{
			StringBuffer sbTitle = new StringBuffer("");
			Iterator it = metadata.getDescendants(new ElementFilter("surname"));
			if( it.hasNext()){
				//nur den ersten Titelsatz!
				Element title = (Element)it.next();
				sbTitle.append(title.getText());				
			}
			sbTitle.append(", ");			
			it = metadata.getDescendants(new ElementFilter("firstname"));
			if( it.hasNext()){
				//nur den ersten Titelsatz!
				Element title = (Element)it.next();
				sbTitle.append(title.getText());				
			}			
			ctxI.setVariable("wfo-title", sbTitle.toString());	
			
		}catch(MCRException ex){
			logger.error("catched error", ex);
		}			
	}
	
	public boolean commitMetadataObject(String mcrobjid, String directory) {
		String filename = directory + "/" + mcrobjid + ".xml";
		File file = new File(filename);
		if(file.exists()){
			try{
				InputStream is = new FileInputStream(file);
				long length = file.length();

		   	    byte[] bytes = new byte[(int)length];

		   	    // Read in the bytes
		   	    int offset = 0;
		   	    int numRead = 0;
		   	    while (offset < bytes.length
		   	    		&& (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
		   	    	offset += numRead;
		   	    }

		   	    // Ensure all the bytes have been read in
		   	    if (offset < bytes.length) {
		   	    	throw new IOException("Could not completely read file "+file.getName());
		   	    }

		   	    // Close the input stream and return bytes
		   	    is.close();
		   	    
		   	    MCRObject mcrO = new MCRObject(bytes, true);
		   	    MCRObjectService mcrService = mcrO.getService();
		   	    mcrService.removeFlags("editor");
		   	    mcrService.addFlag("editor", MCRSessionMgr.getCurrentSession().getUserInformation().getUserID());
  	
		   	    if (MCRMetadataManager.exists(MCRObjectID.getInstance(mcrobjid))) {
					// updates changes not the accesrules
		   	    	MCRMetadataManager.update(mcrO);
				} else {
					MCRMetadataManager.create(mcrO);
				}
			}
			catch(IOException e){
				logger.error(e);
				return false;
			}
			catch(MCRActiveLinkException e){
				logger.error(e);
				return false;
			}
			catch(SAXParseException e){
				logger.error(e);
				return false;
			}
		
		}

		return true;
	}
}
