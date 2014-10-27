package org.mycore.profkat.pndbeacon;

import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.Transaction;
import org.mycore.backend.hibernate.MCRHIBConnection;
import org.mycore.frontend.servlets.MCRServlet;
import org.mycore.services.fieldquery.MCRQuery;
import org.mycore.services.fieldquery.MCRQueryParser;



/**
 * This class generates a PND Beacon text file.
 * The PND Beacon format is used at Wikipedia to publish available PND numbers for personal data sets
 * The data will be created each time the servlet is called.
 * 
 * Format description at http://de.wikipedia.org/wiki/Benutzer:APPER/PND-BEACON
 * 
 * If the file is used more frequently, we should think about a caching mechanism
 * e.g. write it to disk and redirect to it 
 * and only recreate it if request date > creation date + x days
 * 
 * @author Robert Stephan
 * 
 * @version $Revision: 16201 $ $Date: 2009-11-23 14:08:54 +0100 (Mo, 23 Nov 2009) $
 * 
 */
public class ProfKatPNDBeaconServlet extends MCRServlet {
	private static final long serialVersionUID = -4640031382109677365L;
	private static SimpleDateFormat DATEFORMAT;
	static{
		DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US);
		DATEFORMAT.setTimeZone(TimeZone.getTimeZone("GMT+0"));
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.setContentType("text/plain; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		writeMetdata(response.getWriter(), new Date());
		writePNDs(response.getWriter());
	}

	/**
	 * writes the metadata for beacon pnd file
	 * @param w - the Writer
	 * @param creation - the Date of creation
	 * @throws IOException
	 */
	private void writeMetdata(Writer w, Date creation) throws IOException{
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+0"), Locale.GERMANY);
		cal.setTime(creation);
		w.write("#FORMAT: PND-BEACON\n");
		w.write("#VERSION: 0.1\n");
		w.write("#FEED: http://profkat.meine-einrichtung.de/profkat_pnd_beacon.txt\n");
		w.write("#TARGET: http://profkat.meine-einrichtung.de/pnd/{ID}\n");
		w.write("#PREFIX: http://d-nb.info/gnd/\n");
		w.write("#NAME: Beispiel Professorenkatalog)\n");
		w.write("#DESCRIPTION: Beispielanwendung für einen Professorenkatalog (im Aufbau).\n");
		w.write("#CONTACT: AG Professorenkatalog <profkate@meine-einrichtung.de>\n");
		w.write("#INSTITUTION: AG Professorenkatalog, Universität Musterstadt\n");
		w.write("#ISIL: DE-xx\n");
		w.write("#MESSAGE: Eintrag im Beispielprofessorenkatalog\n");
		w.write("#UPDATE: will be rebuilt on every request\n");
		
		w.write("#TIMESTAMP: ");w.write(DATEFORMAT.format(cal.getTime()));w.write("\n");
		cal.add(Calendar.DAY_OF_YEAR, 7);
		w.write("#REVISIT: ");w.write(DATEFORMAT.format(cal.getTime()));w.write("\n");
	}
	
	/**
	 * executes a MyCoRe search for valid PND-Numbers and passes them to a writer
	 * @param w the output writer
	 * @throws IOException
	 */
	private void writePNDs(Writer w) throws IOException{
		Transaction tx  = MCRHIBConnection.instance().getSession().beginTransaction();
		try{
			MCRQuery query = new MCRQuery((new MCRQueryParser()).parse("((pnd like *) and (not (pnd = \"xxx\")))"));
			//TODO SOLR Migration
			/*MCRResults result = MCRQueryManager.search(query);
			for(int i=0;i<result.getNumHits();i++){
				String pnd="";
				String mcrID = result.getHit(i).getID();
				MCRObject mcrObj = MCRMetadataManager.retrieveMCRObject(MCRObjectID.getInstance(mcrID));
				MCRMetaElement mcrME = mcrObj.getMetadata().getMetadataElement("box.identifier");
				if(mcrME!=null){
					for(int j=0;j<mcrME.size();j++){
						MCRMetaLangText mcrMLE = (MCRMetaLangText)mcrME.getElement(j);
						if(mcrMLE.getType().equals("pnd")){
							pnd = mcrMLE.getText();
							break;
						}
					}
				}
				w.write(pnd+"\n");
			}
			*/
		}
		finally{
			tx.commit();
		}
	}			
}
