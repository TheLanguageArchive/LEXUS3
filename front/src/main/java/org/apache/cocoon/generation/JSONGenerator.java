/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.cocoon.generation;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.json.JSONException;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;
import org.json.JSONObject;
import org.apache.excalibur.source.Source;
import org.json.JSONArray;

/**
 * Generates an XML representation of the incoming JSON object.
 *
 * @cocoon.sitemap.component.documentation
 * Generates an XML representation of the incoming JSON object.
 * @cocoon.sitemap.component.name   request-parameter
 * @cocoon.sitemap.component.label  use-namespace
 * @cocoon.sitemap.component.label  root-element
 * @cocoon.sitemap.component.documentation.caching No.
 * @cocoon.sitemap.component.pooling.max  16
 *
 * @version $Id: JSONGenerator.java 605689 2010-02-14 20:48:43Z huiver $
 */
public class JSONGenerator extends ServiceableGenerator {

    /** The namespace prefix of this generator. */
    private final static String JSONnode = "json";
    /** The namespace prefix of this generator. */
    private final static String PREFIX = "json";
    /** The namespace URI of this generator. */
    private final static String URI = "http://apache.org/cocoon/json/1.0";
    /** Request parameter name. */
    private final static String REQUESTPARAMETER = "request-parameter";
    /** Use namespace or not. */
    private final static String USENAMESPACE = "use-namespace";
    /** Root element. */
    private final static String ROOTELEMENT = "root-element";
    private String requestParameter;
    private Boolean useNamespace;
    private String rootElement;
    protected static AttributesImpl attributes;

    /**
     * @Override setup method for generator
     * */
    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters parameters)
            throws ProcessingException, SAXException, IOException {
        super.setup(resolver, objectModel, src, parameters);
        attributes = new AttributesImpl();
        requestParameter = parameters.getParameter(REQUESTPARAMETER, "request");
        useNamespace = parameters.getParameterAsBoolean(USENAMESPACE, false);
        rootElement = parameters.getParameter(ROOTELEMENT, JSONnode);
    }

    /**
     * Generate XML data.
     */
    public void generate()
            throws SAXException {
        final Request request = ObjectModelHelper.getRequest(objectModel);
        final AttributesImpl attr = new AttributesImpl();

        try {
            JSONObject json = new JSONObject(request.getParameter("request"));
            try {
                getLogger().debug("JSONobject=" + URLEncoder.encode(json.toString(), "UTF-8"));
            } catch (UnsupportedEncodingException ex) {
                Logger.getLogger(JSONGenerator.class.getName()).log(Level.SEVERE, null, ex);
            }
            this.contentHandler.startDocument();
            this.contentHandler.startPrefixMapping(PREFIX, URI);
            toSAX(json, JSONnode, this.contentHandler);
            this.contentHandler.endPrefixMapping(PREFIX);
            this.contentHandler.endDocument();
        } catch (JSONException ex) {
            // TODO: generate error XML here
            ex.printStackTrace();
        }
    }

    public void toSAX(Object json, String rootElement, org.xml.sax.ContentHandler contentHandler) throws JSONException, SAXException {
        int i;
        JSONArray ja;
        JSONObject jo;
        String k;
        Iterator keys;
        int len;
        Object v;

        if (json instanceof JSONObject) {

            // Emit <rootElement>
            if (!rootElement.equals("")) {
                startElement(rootElement, attributes);
            }

            // Loop thru the keys.

            jo = (JSONObject) json;
            keys = jo.keys();
            while (keys.hasNext()) {
                k = keys.next().toString();
                v = jo.opt(k);
                if (v == null) {
                    v = "";
                }
                toSAX(v, k, contentHandler);
            }

            if (!rootElement.equals("")) {
                endElement(rootElement);
            }

            return;

        } else if (json instanceof JSONArray) {

            if (!rootElement.equals("")) {
                startElement(rootElement, attributes);
            }

            ja = (JSONArray) json;
            len = ja.length();
            for (i = 0; i < len; ++i) {
                v = ja.opt(i);
                toSAX(v, (rootElement.equals("") ? "array" : rootElement), contentHandler);
            }

            if (!rootElement.equals("")) {
                endElement(rootElement);
            }

            return;
        } else {

            if (!rootElement.equals("")) {
                startElement(rootElement, attributes);
            }

            content(json.toString());

            if (!rootElement.equals("")) {
                endElement(rootElement);
            }

            return;
        }
    }

    private void startElement(String element, AttributesImpl attributes) throws SAXException {
        getLogger().debug("start element: " + element);
        if (useNamespace) {
            contentHandler.startElement(URI, element, PREFIX + ":" + element, attributes);
        } else {
            contentHandler.startElement("", element, element, attributes);
        }
    }

    private void endElement(String element) throws SAXException {
        getLogger().debug("end element: " + element);
        if (useNamespace) {
            contentHandler.endElement(URI, element, PREFIX + ":" + element);
        } else {
            contentHandler.endElement("", element, element);
        }
    }

    private void content(String s) throws SAXException {
        String chars = org.json.XML.escape(s);
        getLogger().debug("content: " + chars);
        contentHandler.characters(chars.toCharArray(), 0, chars.length());
    }
}
