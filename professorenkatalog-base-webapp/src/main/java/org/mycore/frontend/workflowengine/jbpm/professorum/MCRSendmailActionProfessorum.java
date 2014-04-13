package org.mycore.frontend.workflowengine.jbpm.professorum;

import java.util.Locale;
import java.util.PropertyResourceBundle;

import org.jbpm.graph.exe.ExecutionContext;
import org.mycore.frontend.workflowengine.jbpm.MCRAbstractAction;
import org.mycore.frontend.workflowengine.jbpm.MCRJbpmSendmail;

public class MCRSendmailActionProfessorum  extends MCRAbstractAction {
	
	private static final long serialVersionUID = 1L;
	
	private String from;
	private String to;
	private String replyTo;
	private String bcc;
	private String subject;
	private String body;
	private String mode;
	
	private String jbpmVariableName;
	
	private String dateOfSubmissionVariable;
	
	
	public void executeAction(ExecutionContext executionContext) {
		body = getBody(executionContext, mode);
		MCRJbpmSendmail.sendMail(from, to, replyTo, bcc, subject,
				body, mode, jbpmVariableName, dateOfSubmissionVariable, executionContext);
	}
	
	/**
	 * returns the body message of a requested email
	 * @param executionContext
	 * @return
	 */
	protected String getBody(ExecutionContext executionContext, String mode){
		String ret = "";
		String lang = "de";
		if(mode.equals("success")){
			String inLang = (String)executionContext.getVariable("initiatorLanguage"); 
			if( inLang != null && !inLang.equals("")){
				lang = inLang;
			}
			String salutation = (String)executionContext.getVariable("salutation");
			if(salutation != null)
				ret += salutation + "\r\n\r\n";
			else
				ret += "Sehr geehrte(r) Autor(in)";
			String body = " Der Eintrag in den CPR wurde angenommen und publiziert.";
			try {
				body = PropertyResourceBundle.getBundle("messages", new Locale(lang)).getString("WF.Mails.SuccessMessage.publication");
			} catch (java.util.MissingResourceException mRE) {
				// ignore and take the standard text
				;
			}			
			if(body != null)
				ret += body + "\r\n\r\n";
			String footer = PropertyResourceBundle.getBundle("messages", new Locale(lang)).getString("WF.Mails.Footer");
			if(footer != null)
				ret += footer;
		}
		if(ret != null)
			return ret;
		return "";
	}


}
