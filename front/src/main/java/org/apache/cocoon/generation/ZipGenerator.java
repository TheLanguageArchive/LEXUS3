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

import org.apache.cocoon.generation.*;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.net.URI;
import java.util.Enumeration;
import java.util.Map;

import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import javax.naming.ConfigurationException;
import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceException;
import org.apache.excalibur.source.SourceValidity;

import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.components.source.util.SourceUtil;
import org.apache.cocoon.core.xml.SAXParser;
import org.apache.cocoon.environment.SourceResolver;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
* The <code>ZipGenerator</code> is a class that reads a zip file
 * and generates SAX Events that describe the contents of the zip.
 * The <code>ZipGenerator</code> is cacheable.
 *
 * @cocoon.sitemap.component.documentation
 * The <code>ZipGenerator</code> is a class that reads a zip file
 * and generates SAX Events that describe the contents of the zip.
 * The <code>ZipGenerator</code> is cacheable.
 * @cocoon.sitemap.component.name   zip
 * @cocoon.sitemap.component.label  content
 * @cocoon.sitemap.component.documentation.caching Yes.
 * Uses the last modification date of the xml document for validation.
 * Adapted from the FileGenerator.
 *
 * @version $Id: ZipGenerator.java 605687 2007-12-19 20:27:35Z hverweij $
 */
public class ZipGenerator extends ServiceableGenerator
                           implements CacheableProcessingComponent, Configurable {

    public static final String NAMESPACE_PREFIX = "zip";
    public static final String NAMESPACE_URI = "http://apache.org/cocoon/zip-archive/1.0";

    private static final String CONF_NAMESPACE_URI = "uri";
    private static final String CONF_NAMESPACE_PREFIX = "prefix";

    private String defaultUri;
    private String defaultPrefix;

    private String uri;
    private String prefix;
    private final AttributesImpl attr;



    /** The input source */
    protected Source inputSource;

    protected File src;

    /** The SAX Parser. */
    protected SAXParser parser;


    public ZipGenerator() {
        this.attr = new AttributesImpl();
    }

    public void setParser(SAXParser parser) {
        this.parser = parser;
    }

    public void configure(Configuration configuration) {
        this.defaultUri = configuration.getChild(CONF_NAMESPACE_URI).getValue(NAMESPACE_URI);
        this.defaultPrefix = configuration.getChild(CONF_NAMESPACE_PREFIX).getValue(NAMESPACE_PREFIX);
        getLogger().info("this.defaultUri=" + this.defaultUri);
        getLogger().info("this.defaultPrefix=" + this.defaultPrefix);
    }

	/**
     * Recycle this component.
     * All instance variables are set to <code>null</code>.
     */
    public void recycle() {
        if (this.inputSource != null) {
            super.resolver.release(this.inputSource);
            this.inputSource = null;
        }
        if (this.parser != null) {
            super.manager.release(this.parser);
            this.parser = null;
        }
        this.attr.clear();
        super.recycle();
    }

    /**
     * Setup the file generator.
     * Try to get the last modification date of the source for caching.
     */
    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters par)
    throws ProcessingException, SAXException, IOException {
        super.setup(resolver, objectModel, src, par);
        this.uri = par.getParameter(CONF_NAMESPACE_URI, this.defaultUri);
        this.prefix = par.getParameter(CONF_NAMESPACE_PREFIX, this.defaultPrefix);

        try {
        	// Lookup parser in Avalon contexts
        	if (this.parser == null) {
				this.parser = (SAXParser) this.manager.lookup(SAXParser.class.getName());
            }
        } catch (ServiceException e) {
            throw new ProcessingException("Exception when getting parser.", e);
        }

        this.src = new File(src);
        
        try {
            this.inputSource = super.resolver.resolveURI(src);
        } catch (SourceException se) {
            throw SourceUtil.handle("Error during resolving of '" + src + "'.", se);
        }

        if (getLogger().isDebugEnabled()) {
            getLogger().debug("Source " + super.source +
                              " resolved to " + this.inputSource.getURI());
        }
    }

    /**
     * Generate the unique key.
     * This key must be unique inside the space of this component.
     *
     * @return The generated key hashes the src
     */
    public Serializable getKey() {
        return this.inputSource.getURI();
    }

    /**
     * Generate the validity object.
     *
     * @return The generated validity object or <code>null</code> if the
     *         component is currently not cacheable.
     */
    public SourceValidity getValidity() {
        return this.inputSource.getValidity();
    }

    /**
     * Generate XML data.
     */
    public void generate()
    throws IOException, SAXException, ProcessingException {
        getLogger().info("Source " + super.source +
                              " resolved to " + this.inputSource.getURI());
        getLogger().info("this.contentHandler=" + this.contentHandler);
        getLogger().info("this.prefix=" + this.prefix);
        getLogger().info("this.uri=" + this.uri);
        this.contentHandler.startDocument();
        this.contentHandler.startPrefixMapping(this.prefix, this.uri);
        String zipURI = this.inputSource.getURI();
        getLogger().info("zipURI=" + zipURI);
        start("archive");
        try {
            String jarPath = "jar:" + URI.create(zipURI).toURL() + "!/";
            ZipFile sourceZip = new ZipFile(this.src);
            getLogger().info("sourceZip=" + sourceZip);
            Enumeration entries = sourceZip.entries();
            while (entries.hasMoreElements()) {
                ZipEntry entry = (ZipEntry)entries.nextElement();
                String type = (entry.isDirectory() ? "directory" : "file");
                attribute("type", type);
                attribute("name", entry.getName());
                attribute("compressed-size", new Double(entry.getCompressedSize()).toString());
                attribute("size", new Double(entry.getSize()).toString());
                attribute("uri", jarPath + entry.getName());
                start("entry");
                end("entry");
            }
        }
        catch (Exception ex) {
            attr.clear();
            start("errors");
            attribute("type", "not-a-zip-file");
            start("error");
            if (null != ex) {
                if (null != ex.getMessage()) {
                    data(ex.getMessage());
                }
                data(" (cause=" + ex.getCause() + ") (class=" + ex.getClass() + ")");
            };
            end("error");
            end("errors");
        }
        end("archive");
        this.contentHandler.endDocument();
    }


    /**
     * Adds an attribute with the given name and value.
     */
    private void attribute(String name, String value) {
        getLogger().info("@" + name + "=" + value);

        attr.addAttribute("", name, name, "CDATA", value);
    }

    /**
     * Starts an element with the given local name.
     * @param name	local name of the element
     * @throws SAXException
     */
    private void start(String name) throws SAXException {
        getLogger().info("<" + name + ">");
        super.contentHandler.startElement(uri, name, prefix + ":" + name, attr);
        attr.clear();
    }

    /**
     * Ends the given element.
     * @param name local name of the element
     * @throws SAXException
     */
    private void end(String name) throws SAXException {
        getLogger().info("</" + name + ">");
        super.contentHandler.endElement(uri, name, prefix + ":" + name);
    }

    /**
     * Writes the given element data.
     * @param data
     * @throws SAXException
     */
    private void data(String data) throws SAXException {
        getLogger().info(data);
        super.contentHandler.characters(data.toCharArray(), 0, data.length());
    }
}
