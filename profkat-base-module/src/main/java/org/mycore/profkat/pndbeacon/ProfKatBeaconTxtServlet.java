package org.mycore.profkat.pndbeacon;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;
import java.util.TimeZone;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.mycore.common.config.MCRConfiguration;
import org.mycore.solr.MCRSolrClientFactory;

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
public class ProfKatBeaconTxtServlet extends HttpServlet {
    private static Logger LOGGER = LogManager.getLogger(ProfKatBeaconTxtServlet.class);

    private static final long serialVersionUID = -4640031382109677365L;

    private static SimpleDateFormat DATEFORMAT;
    static {
        DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US);
        DATEFORMAT.setTimeZone(TimeZone.getTimeZone("GMT+0"));
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        writeMetdata(response.getWriter(), new Date());
        response.getWriter().println();
        writePNDs(response.getWriter());
        response.getWriter().println();
    }

    /**
     * writes the metadata for beacon pnd file
     * @param w - the Writer
     * @param creation - the Date of creation
     * @throws IOException
     */
    private void writeMetdata(PrintWriter w, Date creation) throws IOException {
        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+0"), Locale.GERMANY);
        cal.setTime(creation);
        String propPrefix = "MCR.Profkat.Beacon." + getServletConfig().getServletName() + ".";
        MCRConfiguration mcrConfig = MCRConfiguration.instance();

        w.println("#FORMAT: BEACON");
        w.println("#VERSION: 0.1");
        w.println("#PREFIX: http://d-nb.info/gnd/");

        for (String field : new String[] { "TARGET", "FEED", "NAME", "DESCRIPTION", "CONTACT", "INSTITUTION", "ISIL",
            "MESSAGE", "UPDATE" }) {
            if (mcrConfig.getString(propPrefix + field, null) != null) {
                w.println("#" + field + ": " + mcrConfig.getString(propPrefix + field.trim()));
            }
        }
        w.println("#TIMESTAMP: " + DATEFORMAT.format(cal.getTime()));
        if (mcrConfig.getInt(propPrefix + "REVISIT_days", -1) != -1) {
            cal.add(Calendar.DAY_OF_YEAR,
                mcrConfig.getInt(propPrefix + "REVISIT_days"));
            w.println("#REVISIT: " + DATEFORMAT.format(cal.getTime()));
        }
    }

    /**
     * executes a MyCoRe search for valid PND-Numbers and passes them to a writer
     * @param w the output writer
     * @throws IOException
     */
    private void writePNDs(PrintWriter w) throws IOException {

        //"gnd_uri": "http://d-nb.info/gnd/14075444X"
        try {
            SolrClient solrClient = MCRSolrClientFactory.getMainSolrClient();
            SolrQuery solrQuery = new SolrQuery();
            solrQuery.setQuery("gnd_uri:*");
            solrQuery.setFields("gnd_uri"); 
            solrQuery.setSort("gnd_uri", ORDER.asc);
            solrQuery.setRows(Integer.MAX_VALUE);

            QueryResponse solrResponse = solrClient.query(solrQuery);
            SolrDocumentList solrResults = solrResponse.getResults();
            Iterator<SolrDocument> it = solrResults.iterator();
            while (it.hasNext()) {
                SolrDocument doc = it.next();
                String gnd = String.valueOf(doc.getFirstValue("gnd_uri"));
                if (!gnd.equals("http://d-nb.info/gnd/xxx")) {
                    w.println(gnd.substring(21));
                }
            }

        } catch (SolrServerException e) {
            LOGGER.error(e);
        }
    }
}
