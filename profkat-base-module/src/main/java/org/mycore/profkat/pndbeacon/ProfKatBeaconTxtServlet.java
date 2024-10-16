package org.mycore.profkat.pndbeacon;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;
import java.util.TimeZone;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.request.QueryRequest;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.mycore.common.config.MCRConfiguration2;
import org.mycore.solr.MCRSolrCoreManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mycore.solr.auth.MCRSolrAuthenticationLevel;
import org.mycore.solr.auth.MCRSolrAuthenticationManager;

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

        w.println("#FORMAT: BEACON");
        w.println("#VERSION: 0.1");
        w.println("#PREFIX: http://d-nb.info/gnd/");

        for (String field : new String[] { "TARGET", "FEED", "NAME", "DESCRIPTION", "CONTACT", "INSTITUTION", "ISIL",
            "MESSAGE", "UPDATE" }) {
            if (MCRConfiguration2.getString(propPrefix + field.trim()).isPresent()) {
                w.println("#" + field + ": " + MCRConfiguration2.getString(propPrefix + field.trim()).get());
            }
        }
        w.println("#TIMESTAMP: " + DATEFORMAT.format(cal.getTime()));
        if (MCRConfiguration2.getInt(propPrefix + "REVISIT_days").orElse(-1) != -1) {
            cal.add(Calendar.DAY_OF_YEAR,
                MCRConfiguration2.getInt(propPrefix + "REVISIT_days").get());
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
            SolrClient solrClient = MCRSolrCoreManager.getMainSolrClient();
            SolrQuery solrQuery = new SolrQuery();
            solrQuery.setQuery("gnd_uri:*");
            solrQuery.setFields("gnd_uri"); 
            solrQuery.setSort("gnd_uri", ORDER.asc);
            solrQuery.setRows(Integer.MAX_VALUE);

            QueryRequest queryRequest = new QueryRequest(solrQuery);
            MCRSolrAuthenticationManager.getInstance().applyAuthentication(queryRequest,
                MCRSolrAuthenticationLevel.SEARCH);
            QueryResponse solrResponse = queryRequest.process(solrClient);
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
