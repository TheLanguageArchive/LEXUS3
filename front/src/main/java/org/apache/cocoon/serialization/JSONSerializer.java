/*
 *
 *
 * 
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
package org.apache.cocoon.serialization;

//import org.apache.avalon.framework.configuration.Configuration;
//import org.apache.avalon.framework.configuration.ConfigurationException;
//import org.apache.cocoon.CascadingIOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.Attributes;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Stack;


import net.sf.saxon.value.Whitespace;

/**
 * JSONSerializer converts XML into JSON.
 * It is adapted from JSONEmitter, see
 * http://www.christian-seiler.de/projekte/xslt-json/
 *
 * @cocoon.sitemap.component.documentation
 * JSONerializer converts XML into JSON.
 * It is adapted from JSONEmitter, see
 * http://www.christian-seiler.de/projekte/xslt-json/
 * @cocoon.sitemap.component.documentation.caching Yes
 * 
 * @version $Id: JSONerializer.java 607379 2010-04-28 10:55:00Z huiver $
 */
public class JSONSerializer implements org.apache.cocoon.serialization.Serializer {

    // to be used later on
    public final static String NAMESPACE = "urn:json-output";
    // different types of elements
    public final static int OBJECT = 0;
    public final static int ARRAY = 1;
    public final static int NUMBER = 2;
    public final static int STRING = 3;
    public final static int FALSE = 4;
    public final static int TRUE = 5;
    public final static int NULL = 6;
    protected boolean empty = true;
    protected boolean startTagOpen = false;
    protected JSONElement currentElement = null;
    protected Stack<Integer> objectStack = new Stack<Integer>();
    protected Stack<Integer> isNotFirst = new Stack<Integer>();
    StringBuffer currentText;
    StringBuffer debugOutput;
    OutputStream output = null;

    public void setDocumentLocator(Locator locator) {
    }

    public void startDocument() throws SAXException {
//        Logger.getLogger(JSONSerializer.class.getName()).log(Level.SEVERE, "startDocument()");
        debugOutput = new StringBuffer("");

       // write("{");
    }

    public void startPrefixMapping(String prefix, String uri) throws SAXException {
    }

    public void endPrefixMapping(String prefix) throws SAXException {
    }

    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
    }

    public void processingInstruction(String target, String data) throws SAXException {
    }

    public void skippedEntity(String name) throws SAXException {
    }

    public void startDTD(String name, String publicId, String systemId) throws SAXException {
    }

    public void endDTD() throws SAXException {
    }

    public void startEntity(String name) throws SAXException {
    }

    public void endEntity(String name) throws SAXException {
    }

    public void startCDATA() throws SAXException {
    }

    public void endCDATA() throws SAXException {
    }

    public void comment(char[] ch, int start, int length) throws SAXException {
    }

    public String getMimeType() {
        return "application/json";
    }

    public boolean shouldSetContentLength() {
        return false;
    }

    public static class JSONElement {

        /**
         * The loc of the tag. This may be "object", "array", etc.
         */
        public String name;
        /**
         * The value of the key attribute.
         */
        public String key = null;
    };

    /**
     * Set the {@link OutputStream} where the requested resource should
     * be serialized.
     */
    public void setOutputStream(OutputStream out) throws IOException {
        this.output = out;
    }

    public void startElement(String uri, String loc, String raw, Attributes a)
            throws SAXException {
        // Logger.getLogger(JSONSerializer.class.getName()).log(Level.SEVERE, "startElement " + loc + ", stackSize="+objectStack.size());
        if (!loc.equals("object") && !loc.equals("array")
                && !loc.equals("number") && !loc.equals("string")
                && !loc.equals("false") && !loc.equals("true")
                && !loc.equals("null")) {
            throw new SAXException("Element name not one of object, array, number, string, false, true or null!");
        }

        if (startTagOpen) {
            closeStartTag(currentElement, false);
        }

        if (objectStack.empty()) {
            if (!loc.equals("array") && !loc.equals("object")) {
                throw new SAXException("Only objects and arrays are allowed as top-level elements!");
            }
        } else {
            int type = objectStack.peek().intValue();
            if (type != OBJECT && type != ARRAY) {
                throw new SAXException("Only objects and arrays may contain subelements!");
            }
        }

        startTagOpen = true;

        JSONElement e = new JSONElement();
        e.name = loc;
        e.key = a.getValue("key");
        currentElement = e;
        if (loc.equals("string") || loc.equals("number")) {
            currentText = new StringBuffer();
        }

    }

    public void endElement(String uri, String loc, String raw)
            throws SAXException {
        // Logger.getLogger(JSONSerializer.class.getName()).log(Level.SEVERE, "endElement "+loc + ", stackSize="+objectStack.size());
        if (startTagOpen) {
            closeStartTag(currentElement, true);
        } else {
            int type = objectStack.pop().intValue();
            isNotFirst.pop();
            switch (type) {
                case OBJECT:
                    write("}");
                    break;
                case ARRAY:
                    write("]");
                    break;
                case NUMBER:
                    writeNumber(currentText.toString());
                    break;
                case STRING:
                    write("\"");
                    write(currentText.toString().replace("\\", "\\\\").replace("\"", "\\\""));
                    write("\"");
                    break;
                // TRUE, FALSE und NULL treten nicht auf
            }
        }
    }

    public void characters(char c[], int start, int len)
            throws SAXException {
        CharSequence chars = new String(c);
        if (startTagOpen) {
            closeStartTag(currentElement, false);
        }
        // ignore whitespaces outside <string>
        if (Whitespace.isWhite(chars) && (objectStack.empty() || objectStack.peek().intValue() != STRING)) {
            return;
        }
        if (objectStack.empty()) {
            throw new SAXException("Character data is not allowed outside <number> and <string>!");
        }
        int type = objectStack.peek().intValue();
        if (type == NUMBER || type == STRING) {
            currentText.append(chars);
        } else {
            throw new SAXException("Character data is not allowed outside <number> and <string>!");
        }
    }

    public void endDocument() throws SAXException {
        if (!objectStack.isEmpty()) {
            throw new IllegalStateException("Attempt to end document in serializer when elements are unclosed");
        }

        //write("}");
        Logger.getLogger(JSONSerializer.class.getName()).log(Level.INFO, "JSONSerializer: " + debugOutput);
    }

    protected void closeStartTag(JSONElement e, boolean empty) throws SAXException {
        if (startTagOpen) {
            if (!isNotFirst.empty() && isNotFirst.peek().intValue() == 1) {
                write(",");
            } else if (!isNotFirst.empty()) {
                isNotFirst.pop();
                isNotFirst.push(new Integer(1));
            }
            if (e.key != null) {
                // sanity checking is done before e.key is set
                write("\"");
                write(e.key);
                write("\":");
            } else if (e.key == null && !objectStack.empty() && objectStack.peek().intValue() == OBJECT) {
                throw new SAXException("key attribute for object member not given!");
            }

            startTagOpen = false;

            int type;
            if (e.name.equals("object")) {
                write("{");
                if (empty) {
                    write("}");
                    return;
                }
                type = OBJECT;
            } else if (e.name.equals("array")) {
                write("[");
                if (empty) {
                    write("]");
                    return;
                }
                type = ARRAY;
            } else if (e.name.equals("number")) {
                if (empty) {
                    write("0");
                    return;
                }
                type = NUMBER;
            } else if (e.name.equals("string")) {
                if (empty) {
                    write("\"");
                    write("\"");
                    return;
                }
                type = STRING;
            } else if (e.name.equals("true")) {
                if (!empty) {
                    throw new SAXException("true, false and null elements must be empty!");
                }
                write("true");
                return;
            } else if (e.name.equals("false")) {
                if (!empty) {
                    throw new SAXException("true, false and null elements must be empty!");
                }
                write("false");
                return;
            } else if (e.name.equals("null")) {
                if (!empty) {
                    throw new SAXException("true, false and null elements must be empty!");
                }
                write("null");
                return;
            } else {
                throw new SAXException("Element name not one of object, array, number, string, false, true or null!");
            }
            objectStack.push(new Integer(type));
            isNotFirst.push(new Integer(0));
        }
    }

    protected void writeNumber(String s) throws SAXException {
        // make sure value's numeric
        String res;
        try {
            /*
             * Here's some smarty pants code to generate an integer string when the number is an integer.
             */
            Integer i = Integer.parseInt(s);
            double d = Double.parseDouble(s);
            if ((int)d == i) {
                res = i.toString();
            }
            else {
                res = new Double(d).toString();
            }
        } catch (Exception e) {
            res = "0";
        }

        write(res);
    }

    protected void write(String out) throws SAXException {
        try {
            // Logger.getLogger(JSONSerializer.class.getName()).log(Level.SEVERE, "writing: " + out);
            this.output.write(out.getBytes());
            debugOutput.append(out);
        } catch (IOException ex) {
            Logger.getLogger(JSONSerializer.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
