/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.apache.cocoon.acting;

import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.avalon.framework.parameters.Parameters;
import java.util.Map;
import java.util.HashMap;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.xml.AttributesImpl;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This action looks into the JSON in the request-parameter
 * specified by the "json-request-parameter" action-parameter (default "request").
 * Using that JSON it extracts the value of the JSON field that is specified by
 * the "json-field" action-parameter. It sets the sitemap parameter specified by
 * the "sitemap-parameter" action-parameter. Complicated? Yes. Here's an example
 * &ltmap:action type="json-field"&gt;
 *      &lt;map:parameter name="json-request-parameter" value="request"/&gt;
 *      &lt;map:parameter name="json-field" value="lexicon"/&gt;
 *      &lt;map:parameter name="sitemap-parameter" value="lexicon-id"/&gt;
 * &ltmap:/action&gt;
 *
 * If json-request-parameter is "request" and sitemap-parameter is equal
 * to the json-field you can skip them.
 * @author huiver
 */
public class JSONField extends AbstractAction {
    public static final String JSONFIELD = "json-field";
    public static final String JSONREQUESTPARAMETER = "json-request-parameter";
    public static final String REQUEST = "request";
    public static final String SITEMAPPARAMETER = "sitemap-parameter";

    private String requestParameter;
    private String jsonParameter;

    public Map act(Redirector redirector,
            SourceResolver resolver,
            Map objectModel,
            String source,
            Parameters params) {

        Map sitemapParams = new HashMap();

        try {
            String jsonParameter = params.getParameter(JSONREQUESTPARAMETER, REQUEST);
            String jsonField = params.getParameter(JSONFIELD);
            String sitemapParameter = params.getParameter( SITEMAPPARAMETER, jsonField);
            final Request request = ObjectModelHelper.getRequest(objectModel);
            final AttributesImpl attr = new AttributesImpl();
            String jsonSource = request.getParameter(jsonParameter);
            getLogger().debug(JSONField.class + ": JSON source =" + jsonSource);
            JSONObject json = new JSONObject(jsonSource);
            String field = json.getJSONObject("parameters").getString(jsonField);
            if (field.startsWith("uuid:")) field = field.substring(5);
            sitemapParams.put(jsonField, field);
        } catch (JSONException ex) {
            Logger.getLogger(JSONField.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParameterException ex) {
            Logger.getLogger(JSONField.class.getName()).log(Level.SEVERE, null, ex);
        }
        return sitemapParams;
    }
}
