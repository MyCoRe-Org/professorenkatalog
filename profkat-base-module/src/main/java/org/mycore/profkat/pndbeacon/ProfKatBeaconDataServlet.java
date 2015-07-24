package org.mycore.profkat.pndbeacon;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.mycore.profkat.pndbeacon.UBRBibliographie;
import org.mycore.frontend.servlets.MCRServlet;

/**
 * This class retrieves the data from PND-Beacon-Service
 * an returns it
 * 
 * Due to performance issues the data will be cached
 * 
 * Request-Parameter: gnd - contains the GND-URI
 * 
 * Example request URL: http://localhost:8080/profkat/profkat_beacon_data?gnd=http%3A%2F%2Fd-nb.info%2Fgnd%2F118558838
 * 
 * @author Robert Stephan
 * 
 * @version $Revision: 16201 $ $Date: 2009-11-23 14:08:54 +0100 (Mo, 23 Nov 2009) $
 * 
 */
public class ProfKatBeaconDataServlet extends MCRServlet {
    private static final long serialVersionUID = 1L;

    private static Logger LOGGER = Logger.getLogger(ProfKatBeaconDataServlet.class);

    private static String BEACON_FINDBUCH_BASEURL = "http://beacon.findbuch.de/seealso/pnd-aks?format=redirect&id=";

    private static String UBR_BIBLIOGRAPHY_KEY = "ubr_biblgr";

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        StringWriter sw = new StringWriter();

        String gnd = request.getParameter("gnd");
        if (gnd != null) {
            gnd = gnd.replace("http://d-nb.info/gnd/", "");
            try {
                URL url = new URL(BEACON_FINDBUCH_BASEURL + gnd);
                String line = null;

                try (BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"))) {
                    while ((line = br.readLine()) != null) {
                        sw.append("\n").append(line);
                    }

                } catch (IOException e) {
                    LOGGER.error(e);
                }

                String result = sw.toString();

                UBRBibliographie biblioApp = UBRBibliographie.getInstance();
                if (biblioApp.getHitCount(gnd) > 0) {
                    int pos = countSubstringInString("<li id=", result);
                    String li = "<li id=\"" + UBR_BIBLIOGRAPHY_KEY + Integer.toString(pos + 1) + "\">" + "<a href=\""
                        + biblioApp.getURL(gnd) + "\">" + biblioApp.getMessage(gnd) + "</a> </li>";

                    result = result.replace("</ul>", li + "\n</ul>");
                }
                response.getWriter().append(result);

            } catch (MalformedURLException e) {
                LOGGER.error(e);
            }
        }
    }

    public static int countSubstringInString(String substring, String string) {
        return (string.length() - string.replace(substring, "").length()) / substring.length();
    }
}
