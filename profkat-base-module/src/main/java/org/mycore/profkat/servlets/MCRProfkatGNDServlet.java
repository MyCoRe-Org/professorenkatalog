/*
 * $RCSfile$
 * $Revision: 11306 $ $Date: 2007-04-05 16:32:11 +0200 (Do, 05 Apr 2007) $
 *
 * This file is part of ***  M y C o R e  ***
 * See http://www.mycore.de/ for details.
 *
 * This program is free software; you can use it, redistribute it
 * and / or modify it under the terms of the GNU General Public License
 * (GPL) as published by the Free Software Foundation; either version 2
 * of the License or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program, in a file called gpl.txt or license.txt.
 * If not, write to the Free Software Foundation Inc.,
 * 59 Temple Place - Suite 330, Boston, MA  02111-1307 USA
 */

package org.mycore.profkat.servlets;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.mycore.solr.MCRSolrClientFactory;
import org.mycore.solr.MCRSolrUtils;

/**
 * This servlet opens retrieves the object for the given GND and opens the docdetails view
 * @author Robert Stephan
 * 
 * @see org.mycore.frontend.servlets.MCRServlet
 */
public class MCRProfkatGNDServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static Logger LOGGER = Logger.getLogger(MCRProfkatGNDServlet.class);

    /**
     * The initalization of the servlet.
     * 
     * @see javax.servlet.GenericServlet#init()
     */
    public void init() throws ServletException {
        super.init();
    }

    /**
     * The method replace the default form MCRSearchServlet and redirect the
     * 
     * @param job
     *            the MCRServletJob instance
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.debug("contextPath=" + request.getContextPath());
        LOGGER.debug("servletPath=" + request.getServletPath());

        String uri = request.getPathInfo();
        String gnd = null;
        if (uri != null) {
            gnd = uri.substring(1);
        }
        if (gnd == null || gnd.length() == 0) {
            getServletContext().getRequestDispatcher("/").forward(request, response);
            return;
        }

        //"gnd_uri": "http://d-nb.info/gnd/14075444X"
        try {
            SolrClient solrClient = MCRSolrClientFactory.getSolrClient();
            SolrQuery solrQuery = new SolrQuery();
            solrQuery.setQuery("gnd_uri:"+MCRSolrUtils.escapeSearchValue("http://d-nb.info/gnd/" + gnd));

            QueryResponse solrResponse = solrClient.query(solrQuery);
            SolrDocumentList solrResults = solrResponse.getResults();

            Iterator<SolrDocument> it = solrResults.iterator();
            if (it.hasNext()) {
                SolrDocument doc = it.next();
                String id = String.valueOf(doc.getFirstValue("id"));
                getServletContext().getRequestDispatcher("/resolve/id/" + id).forward(request, response);
            }

        } catch (SolrServerException e) {
            LOGGER.error(e);
        }
    }
}
