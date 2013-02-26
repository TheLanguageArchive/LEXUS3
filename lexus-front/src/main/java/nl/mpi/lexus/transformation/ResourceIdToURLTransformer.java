// $Id: ResourceIdToURLTransformer.java,v 1.4 2004/11/19 14:55:40 verwe00t Exp $
package nl.mpi.lexus.transformation;

import java.io.*;
import java.net.URL;
import java.util.*;
import nl.mpi.lexicon.business.archive.IResolver;
import nl.mpi.lexicon.business.archive.LamusResolver;
import nl.mpi.lexicon.business.archive.ResolveException;
import nl.mpi.lexicon.domain.LMF.instance.ArchiveHandle;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * Convert a resource ID in a data element to a URL.
 * Declaration in sitemap:
 * <pre>
 *  &lt;map:transformers default="xslt"&gt;
 *    &lt;map:transformer name="lexus-resources" src="nl.mpi.lexus.transformation.ResourceIdToURLTransformer"/&gt;
 *  &lt;/map:transformers&gt;
 * </pre>
 * Usage in pipeline:
 * <pre>
 *  &lt;map:transform type="lexus-resources"/&gt;
 * </pre>
 * It will look for elements in the "http://nl.mpi.lexus/resource-resolver"
 * namespace. The following elements are recognized (assuming xmlns:rr="http://apache.org/cocoon/resource-resolver"):
 * <dl>
 * <dt>&lt;rr:resource-id-to-url archive="MPI" value="MPI316757#" mimetype="text/x-eaf+xml" type="url" lexiconId="uuid:boe"/&gt;</dt>
 * <dd>Adds to the element a local and/or a remote (Lamus) generated URL.</dd>
 * </dl>
 */
public class ResourceIdToURLTransformer
        extends AbstractTransformer {

    private static final String NAMESPACE = "http://nl.mpi.lexus/resource-resolver";
    private static final String PREFIX = "rr";
    private static final String RESOURCEID_ELEMENT = "resource-id-to-url";
    private static final String VALUE = "value";
    private static final String ARCHIVE = "archive";
    private static final String MIMETYPE = "mimetype";
    private static final String TYPE = "type";
    private static final String LEXICONID = "lexiconId";
    private static final String LOCAL_COPY = "local";
    private static final String MPI = "MPI";
    private static final String RESOURCES_URI = "resources-uri";
    private static final String LOCAL_RESOURCES_FOLDER = "local-resources-folder";
    private Map objectModel;
    private String resources_uri = "";
    private String local_folder = "";
    private String LOCAL_ELEMENT = "local";
    private String REMOTE_ELEMENT = "remote";

    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters par)
            throws ProcessingException, SAXException, IOException {
        if (null != par.getParameter(RESOURCES_URI, null)) {
            resources_uri = par.getParameter(RESOURCES_URI, "");
        }
        if (null != par.getParameter(LOCAL_RESOURCES_FOLDER, null)) {
            local_folder = par.getParameter(LOCAL_RESOURCES_FOLDER, "");
        }

        this.objectModel = objectModel;
    }

    public void startElement(String namespaceURI, String lName, String qName, Attributes attributes)
            throws SAXException {
        if (namespaceURI.equals(NAMESPACE)) {
            if (lName.equals(RESOURCEID_ELEMENT)) {
                String archive = attributes.getValue(ARCHIVE);
                String value = attributes.getValue(VALUE);
                String type = attributes.getValue(TYPE);
                String mimetype = attributes.getValue(MIMETYPE);
                String lexiconId = attributes.getValue(LEXICONID);
                if (getLogger().isDebugEnabled()) {
                    getLogger().debug("ResourceIdToURLTransformer.archive=" + archive);
                    getLogger().debug("ResourceIdToURLTransformer.value=" + value);
                    getLogger().debug("ResourceIdToURLTransformer.type=" + type);
                    getLogger().debug("ResourceIdToURLTransformer.mimetype=" + mimetype);
                    getLogger().debug("ResourceIdToURLTransformer.lexiconId=" + lexiconId);
                }
                String urlStr = "";
                if (null != archive) {
                    if (archive.equals(LOCAL_COPY)) {
                        Request request = ObjectModelHelper.getRequest(objectModel);
                        String reqURI = request.getScheme() + ":////" + request.getServerName() + ":" + request.getServerPort() +
                                "/" + request.getContextPath() + "/";
                        urlStr = reqURI + resources_uri + "/" + lexiconId + "/" + value;
                        urlStr = urlStr.replaceAll("//", "/");
                        if (getLogger().isDebugEnabled()) {
                            getLogger().debug("ResourceIdToURLTransformer result=" + urlStr);
                        }
                        String localStr = "";
                        localStr = local_folder + "/" + value;
                        super.contentHandler.startElement(NAMESPACE, RESOURCEID_ELEMENT, PREFIX+":"+RESOURCEID_ELEMENT, attributes);
                        super.contentHandler.startElement(NAMESPACE, LOCAL_ELEMENT, PREFIX+":"+LOCAL_ELEMENT, new AttributesImpl());
                        super.contentHandler.characters(localStr.toCharArray(), 0, localStr.length());
                        super.endElement(NAMESPACE, LOCAL_ELEMENT, PREFIX+":"+LOCAL_ELEMENT);
                        super.contentHandler.startElement(NAMESPACE, REMOTE_ELEMENT, PREFIX+":"+REMOTE_ELEMENT, new AttributesImpl());
                        super.contentHandler.characters(urlStr.toCharArray(), 0, urlStr.length());
                        super.endElement(NAMESPACE, REMOTE_ELEMENT, PREFIX+":"+REMOTE_ELEMENT);
                        super.endElement(NAMESPACE, RESOURCEID_ELEMENT, PREFIX+":"+RESOURCEID_ELEMENT);
                    } else if (archive.equals(MPI)) {
                        IResolver resolver = new LamusResolver();

                        if (getLogger().isDebugEnabled()) {
                            getLogger().debug("ResourceIdToURLTransformer resolver=" + resolver);
                        }
                        URL url = null;
                        try {
                            ArchiveHandle handle = new ArchiveHandle();
                            handle.setArchiveIdentifier(archive);
                            handle.setMimeType(mimetype);
                            handle.setResourceHandle(value);
                            url = resolver.resolve(handle);
                            urlStr = null == url ? "" : url.toExternalForm();
                            if (getLogger().isDebugEnabled()) {
                                getLogger().debug("ResourceIdToURLTransformer result=" + urlStr);
                            }
                            super.contentHandler.startElement(NAMESPACE, RESOURCEID_ELEMENT, PREFIX+":"+RESOURCEID_ELEMENT, attributes);
                            super.contentHandler.startElement(NAMESPACE, REMOTE_ELEMENT, PREFIX+":"+REMOTE_ELEMENT, new AttributesImpl());
                            super.contentHandler.characters(urlStr.toCharArray(), 0, urlStr.length());
                            super.endElement(NAMESPACE, REMOTE_ELEMENT, PREFIX+":"+REMOTE_ELEMENT);
                            super.endElement(NAMESPACE, RESOURCEID_ELEMENT, PREFIX+":"+RESOURCEID_ELEMENT);
                        } catch (ResolveException e) {
                            // logger.error(e);
                        }
                    } else {
                        // throw new RuntimeException("Unknown archive type[" + archive + "] encountered");
                    }
                }
            }
        } else {
            super.startElement(namespaceURI, lName, qName, attributes);
        }
    }

    public void endElement(String namespaceURI, String lName, String qName)
            throws SAXException {
        if (!namespaceURI.equals(NAMESPACE)) {
            super.endElement(namespaceURI, lName, qName);
        }
    }

    public void characters(char[] c, int start, int len)
            throws SAXException {
        super.characters(c, start, len);
    }
}
