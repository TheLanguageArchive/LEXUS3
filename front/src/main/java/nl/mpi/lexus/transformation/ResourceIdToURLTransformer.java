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
import org.apache.cocoon.environment.Response;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

/**
 * Convert a resource ID in a data element to a URL.
 * Declaration in sitemap:
 * <pre>
 *  &lt;map:transformers default="xslt"&gt;
 *    &lt;map:transformer name="resource-id-to-url" src="nl.mpi.lexus.transformation.ResourceIdToURLTransformer"/&gt;
 *  &lt;/map:transformers&gt;
 * </pre>
 * Usage in pipeline:
 * <pre>
 *  &lt;map:transform type="resource-id-to-url"/&gt;
 * </pre>
 * It will look for elements in the "http://nl.mpi.lexus/resource-resolver"
 * namespace. The following elements are recognized (assuming xmlns:ritu="http://apache.org/cocoon/resource-resolver"):
 * <dl>
 * <dt>&lt;ritu:resource-id archive="MPI" value="MPI316757#" mimetype="text/x-eaf+xml" type="url" lexiconId="uuid:boe"/&gt;</dt>
 * <dd>Substitutes the element with a local or a Lamus generated URL.</dd>
 * </dl>
 */
public class ResourceIdToURLTransformer
        extends AbstractTransformer {

    private static final String NAMESPACE = "http://nl.mpi.lexus/resource-resolver";
    private static final String RESOURCEID_ELEMENT = "resource-id-to-url";
    private static final String VALUE = "value";
    private static final String ARCHIVE = "archive";
    private static final String MIMETYPE = "mimetype";
    private static final String TYPE = "type";
    private static final String LEXICONID = "lexiconId";
    private Response response;
    private static final String LOCAL_COPY = "local";
    private static final String MPI = "MPI";
    private static final String RESOURCES_URI = "resources-uri";
    private Parameters par;
    private Map objectModel;
    private String resources_uri = "";

    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters par)
            throws ProcessingException, SAXException, IOException {
        response = ObjectModelHelper.getResponse(objectModel);
        this.par = par;
        if (null != par.getParameter(RESOURCES_URI, null)) {
            resources_uri = par.getParameter(RESOURCES_URI, "");
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
                        } catch (ResolveException e) {
                            // logger.error(e);
                        }
                    } else {
                        // throw new RuntimeException("Unknown archive type[" + archive + "] encountered");
                    }
                }
                if (getLogger().isDebugEnabled()) {
                    getLogger().debug("ResourceIdToURLTransformer result=" + urlStr);
                }
                super.contentHandler.characters(urlStr.toCharArray(), 0, urlStr.length());
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
