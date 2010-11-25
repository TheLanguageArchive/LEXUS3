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
import javax.xml.transform.OutputKeys;
import javax.xml.transform.sax.TransformerHandler;
import javax.xml.transform.stream.StreamResult;


import net.sf.saxon.value.Whitespace;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.cocoon.CascadingIOException;

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
public class JSONSerializer extends AbstractTextSerializer {

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

    /* (non-Javadoc)
     * @see org.apache.cocoon.serialization.AbstractTextSerializer#init()
     */
    public void init() throws Exception {
        super.init();
        this.format.put(OutputKeys.METHOD, "text");
    }

    /**
     * Set the configurations for this serializer.
     */
    public void configure(Configuration conf) throws ConfigurationException {
        super.configure(conf);
        this.format.put(OutputKeys.METHOD, "text");
    }

    /**
     * Set the {@link OutputStream} where the requested resource should
     * be serialized.
     */
    public void setOutputStream(OutputStream out) throws IOException {
        super.setOutputStream(out);
        try {
            TransformerHandler handler = this.getTransformerHandler();
            handler.getTransformer().setOutputProperties(format);
            handler.setResult(new StreamResult(this.output));
            this.setContentHandler(handler);
            this.setLexicalHandler(handler);
       } catch (Exception e) {
            final String message = "Cannot set TextSerializer outputstream";
            throw new CascadingIOException(message, e);
        }
    }


    @Override
    public void setDocumentLocator(Locator locator) {
    }

    @Override
    public void startDocument() throws SAXException {
        super.startDocument();
    }

    @Override
    public void startPrefixMapping(String prefix, String uri) throws SAXException {
    }

    @Override
    public void endPrefixMapping(String prefix) throws SAXException {
    }

    @Override
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
    }

    @Override
    public void processingInstruction(String target, String data) throws SAXException {
    }

    @Override
    public void skippedEntity(String name) throws SAXException {
    }

    @Override
    public void startDTD(String name, String publicId, String systemId) throws SAXException {
    }

    @Override
    public void endDTD() throws SAXException {
    }

    @Override
    public void startEntity(String name) throws SAXException {
    }

    @Override
    public void endEntity(String name) throws SAXException {
    }

    @Override
    public void startCDATA() throws SAXException {
    }

    @Override
    public void endCDATA() throws SAXException {
    }

    @Override
    public void comment(char[] ch, int start, int length) throws SAXException {
    }

    @Override
    public String getMimeType() {
        return "application/json";
    }

    @Override
    public boolean shouldSetContentLength() {
        return false;
    }

    public static class JSONElement {

        /**
         * The type of the tag. This may be "object", "array", etc.
         */
        public String name;
        /**
         * The value of the key attribute.
         */
        public String key = null;
    };


    public void startElement(String uri, String localName, String raw, Attributes a)
            throws SAXException {
        // Logger.getLogger(JSONSerializer.class.getName()).log(Level.SEVERE, "startElement " + localName + ", key=" + a.getValue("key")+", stackSize="+objectStack.size());
        if (!localName.equals("object") && !localName.equals("array")
                && !localName.equals("number") && !localName.equals("string")
                && !localName.equals("false") && !localName.equals("true")
                && !localName.equals("null")) {
            throw new SAXException("Element name not one of object, array, number, string, false, true or null!");
        }

        if (startTagOpen) {
            closeStartTag(currentElement, false);
        }

        if (objectStack.empty()) {
            if (!localName.equals("array") && !localName.equals("object")) {
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
        e.name = localName;
        e.key = a.getValue("key");
        currentElement = e;
        if (localName.equals("string") || localName.equals("number")) {
            currentText = new StringBuffer();
        }

    }

    @Override
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

    @Override
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

    @Override
    public void endDocument() throws SAXException {
        if (!objectStack.isEmpty()) {
            throw new IllegalStateException("Attempt to end document in serializer when elements are unclosed");
        }

        super.endDocument();
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
                throw new SAXException("key attribute for child of object not given: e.name="+e.name+", currentText=" + currentText);
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
             * Here's some smarty pants code to generate an integer string when the string is parseable as an integer.
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
        char c[];
        c = out.toCharArray();
        super.characters(c, 0, c.length);
    }
}
