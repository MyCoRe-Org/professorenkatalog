package org.mycore.frontend.workflowengine.jbpm.professorum;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.fileupload.FileItem;
import org.apache.log4j.Logger;
import org.jbpm.context.exe.ContextInstance;
import org.mycore.common.MCRException;
import org.mycore.common.MCRUtils;
import org.mycore.datamodel.metadata.MCRDerivate;
import org.mycore.frontend.workflowengine.jbpm.MCRWorkflowConstants;
import org.mycore.frontend.workflowengine.strategies.MCRDefaultDerivateStrategy;

public class MCRDocumentDerivateStrategy extends MCRDefaultDerivateStrategy {
	private static Logger logger = Logger.getLogger(MCRDocumentDerivateStrategy.class.getName());
	
	public void saveFiles(List files, String dirname, ContextInstance ctxI, String newLabel, String newTitle) throws MCRException {
		MCRDerivate der = null;;
		boolean bUpdateDerivate=false;
		
		try {
			der = new MCRDerivate(new File(dirname + ".xml").toURI());
		}catch(Exception ex){
			String errMsg = "could not set derivate " + dirname + ".xml";
			logger.error(errMsg, ex);
			throw new MCRException(errMsg);
		}
		
		String derID = der.getId().toString();
		
		// save the files	
		ArrayList<String> ffname = new ArrayList<String>();
		String mainfile = "";
		int newFileCnt = 0;
		FileOutputStream fouts = null;
		for (int i = 0; i < files.size(); i++) {
			FileItem item = (FileItem) (files.get(i));
			String fname = item.getName().trim();
			// IE Explorer Bug, the name includes the whole path
			if (fname.indexOf("/") >0)
				fname = fname.substring(fname.lastIndexOf("/")+1);
			if (fname.indexOf("\\") >0 )
				fname = fname.substring(fname.lastIndexOf("\\")+1);
					
			try{
				File fout = new File(dirname, fname);
				fouts = new FileOutputStream(fout);
				MCRUtils.copyStream(item.getInputStream(), fouts);
				fouts.flush();
				fouts.close();
				logger.info("Data object stored under " + fout.getName());
				newFileCnt++;
			}catch(Exception ex){
				String errMsg = "could not store data object " + fname;
				logger.error(errMsg, ex);
				throw new MCRException(errMsg);
			} 
		}
		if ((mainfile.length() == 0) && (ffname.size() > 0)) {
			mainfile = ffname.get(0);
		}
	
		if (der.getDerivate().getInternals().getMainDoc().equals("#####")) {
			der.getDerivate().getInternals().setMainDoc(mainfile);
			bUpdateDerivate=true;
		}
		if ( newLabel != null && newLabel.length()>0 ) {
			der.setLabel(newLabel);
			bUpdateDerivate=true;
		}
		if ( newTitle != null && newTitle.length()>0 ) {
			der.getService().removeFlags("title");
			der.getService().addFlag("title", newTitle);
			bUpdateDerivate=true;
		}

		// update the Derivate...xml file
		try{
			if ( bUpdateDerivate ){
				byte[] outxml = MCRUtils.getByteArray(der.createXML());
				try {
					FileOutputStream out = new FileOutputStream(dirname	+ ".xml");
					out.write(outxml);
					out.flush();
					out.close();
				} catch (IOException ex) {
					logger.error(ex.getMessage());
					logger.error("Exception while store to file " + dirname	+ ".xml", ex);
					throw ex;
				}
			}
		} catch (Exception e) {
			String msgErr = "Can't open file " + dirname + ".xml"; 
			logger.error(msgErr, e);
			throw new MCRException(msgErr);
		}
		
		String attachedDerivates = (String)ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_ATTACHED_DERIVATES);		
				
		if ( derID.length() >0 && attachedDerivates.indexOf(derID)<0  ) {
			if ( attachedDerivates.trim().length() > 0) {
				attachedDerivates += ",";
			}
			ctxI.setVariable("attachedDerivates", attachedDerivates  + derID);
		}

		String fcnt = (String)ctxI.getVariable(MCRWorkflowConstants.WFM_VAR_FILECNT);
		try {
			int cnt = Integer.parseInt(fcnt);
			ctxI.setVariable(MCRWorkflowConstants.WFM_VAR_FILECNT, String.valueOf( cnt + newFileCnt) );	
		} catch ( NumberFormatException nonum ) {
			ctxI.setVariable(MCRWorkflowConstants.WFM_VAR_FILECNT, String.valueOf( newFileCnt) );	
		}			
	}

	
	public boolean deleteDerivateObject(ContextInstance ctxI, String saveDirectory, String backupDirectory, String metadataObjectID, String derivateObjectID, boolean mustWorkflowVarBeUpdated) {
  		 try{
			if(super.deleteDerivateObject(ctxI, saveDirectory, backupDirectory, metadataObjectID, derivateObjectID, mustWorkflowVarBeUpdated)){
						return true;
			}
		  }catch(MCRException ex){
				logger.error("catched error", ex);
				return false;
		  }			
		  return true;
		}	
}
