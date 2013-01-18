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
import java.io.Serializable;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.excalibur.source.SourceValidity;
import org.json.JSONException;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;
import org.json.JSONObject;
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
public class JSONGenerator extends ServiceableGenerator implements CacheableProcessingComponent {

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
    private AttributesImpl attributes;
    private String jsonSource;
    private JSONValidity validity;

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
        final Request request = ObjectModelHelper.getRequest(objectModel);
        jsonSource = request.getParameter(requestParameter);
    }

    /**
     * Generate XML data.
     */
    public void generate()
            throws SAXException {
        try {
            getLogger().debug("JSON source =" + jsonSource);
            JSONObject json = new JSONObject(jsonSource);
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

    public Serializable getKey() {
        MessageDigest md;
        if (null == jsonSource) {
            return null;
        }
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(JSONGenerator.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
        return md.digest(jsonSource.getBytes());
    }

    public SourceValidity getValidity() {
        if (this.validity == null) {
            this.validity = new JSONValidity(this.jsonSource);
        }
        return this.validity;
    }


    /** Specific validity class, that holds all files that have been generated */
    public static class JSONValidity implements SourceValidity {

        private final String jsonSource;

        public JSONValidity(String jsonSource) {
            this.jsonSource = jsonSource;
        }

        public int isValid() {
            return SourceValidity.VALID;
        }

        public int isValid(SourceValidity newValidity) {
            return isValid();
        }

    }
}
