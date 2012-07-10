package nl.mpi.lexus.transformation;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;


import nl.mpi.corpusstructure.ArchiveAccessContext;
import nl.mpi.corpusstructure.CorpusStructureDB;
import nl.mpi.corpusstructure.CorpusStructureDBImpl;
import nl.mpi.corpusstructure.Node;
import nl.mpi.corpusstructure.UnknownNodeException;
import nl.mpi.util.OurURL;
import nl.mpi.lexus.resource.ResourceType;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Response;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.apache.avalon.framework.configuration.Configuration;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * Collects an object from the archive using an ID.
 * Declaration in sitemap:
 * <pre>
 *  &lt;map:transformers default="xslt"&gt;
 *    &lt;map:transformer name="archive" src="nl.mpi.lexus.transformation.ImdiArchiveTransformer"/&gt;
 *  &lt;/map:transformers&gt;
 * </pre>
 * Usage in pipeline:
 * <pre>
 *  &lt;map:transform type="archive"/&gt;
 * </pre>
 * It will look for elements in the "http://nl.mpi.lexus/archive"
 * namespace. The following elements are recognized (assuming xmlns:archive="http://nl.mpi.lexus/archive"):
 * <dl>
 * <dt>&lt;archive:get-object archive="MPI" id="MPI600399##"/&gt;</dt>
 * <dd>On success it adds the object to the archive:get-object element.</dd>
 * </dl>
 */
public class ImdiArchiveTransformer extends AbstractTransformer {

    private static final String NAMESPACE = "http://nl.mpi.lexus/archive";
    private static final String PREFIX = "archive";
    private static final String GET_OBJECT_ELEMENT = "get-object";
    private static final String MPI = "MPI";
    private static final String DefaultEAFHandler = "http://corpus1.mpi.nl/ds/annex/protected/interface.jsp";
    private static final String DefaultIMDIHandler = "http://corpus1.mpi.nl/ds/imdi_browser";
    private static final String CONF_EAF_HANDLER = "EAF-handler";
    private static final String CONF_IMDI_HANDLER = "IMDI-handler";
    private static final String SETUP_EAF_HANDLER = "EAF-handler";
    private static final String SETUP_IMDI_HANDLER = "IMDI-handler";
    private static final String OBJECT_ELEMENT = "object";
    private static final String ID_ATTRIBUTE = "id";
    private static final String URL_ATTRIBUTE = "url";
    private static final String METADATA_URL_ATTRIBUTE = "metadataURL";
    private static final String FORMAT_ATTRIBUTE = "format";
    private static final String ARCHIVE_HANDLE_ATTRIBUTE = "archiveHandle";
    private static final String TYPE_ATTRIBUTE = "type";
    
    private Response response;
    private Parameters par;
    private Map objectModel;
    private String EAFHandlerContextPath;
    private String IMDIHandlerContextPath;

    public void configure(Configuration configuration) {
        this.EAFHandlerContextPath = configuration.getChild(CONF_EAF_HANDLER).getValue(DefaultEAFHandler);
        this.IMDIHandlerContextPath = configuration.getChild(CONF_IMDI_HANDLER).getValue(DefaultIMDIHandler);
        getLogger().info("this.EAFHandlerContextPath=" + this.EAFHandlerContextPath);
        getLogger().info("this.IMDIHandlerContextPath=" + this.IMDIHandlerContextPath);
      //  Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("this.EAFHandlerContextPath=" + this.EAFHandlerContextPath);
      //  Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("this.IMDIHandlerContextPath=" + this.IMDIHandlerContextPath);


    }

    
    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters par)
            throws ProcessingException, SAXException, IOException {
        response = ObjectModelHelper.getResponse(objectModel);
        this.par = par;
        if (null != par.getParameter(SETUP_EAF_HANDLER, null)) {
            EAFHandlerContextPath = par.getParameter(SETUP_EAF_HANDLER, "");
        }
        if (null != par.getParameter(SETUP_IMDI_HANDLER, null)) {
            IMDIHandlerContextPath = par.getParameter(SETUP_IMDI_HANDLER, "");
        }

        getLogger().info("this.EAFHandlerContextPath=" + this.EAFHandlerContextPath);
        getLogger().info("this.IMDIHandlerContextPath=" + this.IMDIHandlerContextPath);
        //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("this.EAFHandlerContextPath=" + this.EAFHandlerContextPath);
        //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("this.IMDIHandlerContextPath=" + this.IMDIHandlerContextPath);

        this.objectModel = objectModel;
    }

    @Override
    public void startElement(String namespaceURI, String lName, String qName, Attributes attributes)
            throws SAXException {
        CorpusStructureDBImpl db = null;

        if (namespaceURI.equals(NAMESPACE)) {
            if (lName.equals(GET_OBJECT_ELEMENT)) {
                String nodeId = attributes.getValue(ID_ATTRIBUTE);
                AttributesImpl attrs = new AttributesImpl();

                getLogger().info("nodeId=" + nodeId);
                //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("nodeId=" + nodeId);

                Context initCtx;
                try {
                    initCtx = new InitialContext();
                    //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("initCtx = " + initCtx);
                    getLogger().info("initCtx = " + initCtx);

                    Context envCtx = (Context) initCtx.lookup("java:comp/env");
                    //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("envCtx = " + envCtx);
                    getLogger().info("envCtx = " + envCtx);

                    String dbURL = (String) envCtx.lookup("jdbc/CSDB");
                    //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("Corpus dbURL = " + dbURL);
                    getLogger().info("Corpus dbURL = " + dbURL);

                    db = new CorpusStructureDBImpl(dbURL);
                } catch (NamingException ex) {
                    getLogger().fatal(ex);
                    //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info(ex.toString());

                }

                getLogger().info("Corpus db handler=" + db);
                //Logger.getLogger(ImdiArchiveTransformer.class.getName()).info("Corpus db handler=" + db);

                
                
                if (null != db) {
                    
                    try {
                        Node node = db.getNode(nodeId);

                        if (null != node) {

                           // Logger.getLogger(ImdiArchiveTransformer.class.getName()).log(Level.INFO, "node = {0}", node);
                            getLogger().info("node = " + node);

                            if (node.getFormat() != null && node.getFormat().equals(CorpusStructureDB.WR_FORMAT_EAF) || node.getFormat().trim().equals("EAF")) {
                                try {
                                    attrs.addAttribute("", URL_ATTRIBUTE, URL_ATTRIBUTE, "CDATA", this.EAFHandlerContextPath + "?nodeid=" + URLEncoder.encode(nodeId, "utf-8"));
                                    getLogger().info(this.EAFHandlerContextPath + "?nodeid=" + URLEncoder.encode(nodeId, "utf-8"));
                                } catch (UnsupportedEncodingException ex) {
                                	getLogger().error(null, ex);
                                    //Logger.getLogger(ImdiArchiveTransformer.class.getName()).log(Level.SEVERE, null, ex);
                                }
                            } else {
                                OurURL url = db.getObjectURL(nodeId, ArchiveAccessContext.HTTP_URL);
                                if (getLogger().isInfoEnabled()) {
                                    getLogger().info(url.getProtocol() + " " + url.getHost() + "    " + url.getPort() + " " + url.getPath());
                                    //Logger.getLogger(ImdiArchiveTransformer.class.getName()).log(Level.INFO, url.getProtocol() + " " + url.getHost() + "    " + url.getPort() + " " + url.getPath());

                                }
                                String urlStr = url.getProtocol() + "://" + url.getHost() + (url.getPort() == -1 ? "" : ":" + url.getPort()) + url.getPath();
                                attrs.addAttribute("", URL_ATTRIBUTE, URL_ATTRIBUTE, "CDATA", urlStr);
                            }
                            try {
                                attrs.addAttribute("", METADATA_URL_ATTRIBUTE, METADATA_URL_ATTRIBUTE, "CDATA", this.IMDIHandlerContextPath + "?openpath=" + URLEncoder.encode(nodeId, "utf-8"));
                            } catch (UnsupportedEncodingException ex) {
                            	getLogger().error(null, ex);
                                Logger.getLogger(ImdiArchiveTransformer.class.getName()).log(Level.SEVERE, null, ex);
                            }                            
                            
                            attrs.addAttribute("", FORMAT_ATTRIBUTE, FORMAT_ATTRIBUTE, "CDATA", node.getFormat());
                            attrs.addAttribute("", ARCHIVE_HANDLE_ATTRIBUTE, ARCHIVE_HANDLE_ATTRIBUTE, "CDATA", nodeId);
                            attrs.addAttribute("", TYPE_ATTRIBUTE, TYPE_ATTRIBUTE, "CDATA", ResourceType.determineType(node.getFormat()));
                            
                        } else {
                        	getLogger().info("node = null!");
                        }
                    } catch (UnknownNodeException e) {
                        getLogger().fatal("Unknown node ID[" + nodeId + "] specified by the user");
                        //Logger.getLogger(ImdiArchiveTransformer.class.getName()).log(Level.INFO, "Unknown node ID[" + nodeId + "] specified by the user");

                        

                    } finally {
                        db.close();
                    }
                }
                super.contentHandler.startElement(NAMESPACE, GET_OBJECT_ELEMENT, PREFIX + ":" + GET_OBJECT_ELEMENT, attributes);
                super.contentHandler.startElement(NAMESPACE, OBJECT_ELEMENT, PREFIX + ":" + OBJECT_ELEMENT, attrs);
                super.endElement(NAMESPACE, OBJECT_ELEMENT, PREFIX + ":" + OBJECT_ELEMENT);
            }
        }
        else {
            super.contentHandler.startElement(namespaceURI, lName, qName, attributes);
        }
    }

    @Override
    public void endElement(String namespaceURI, String lName, String qName)
            throws SAXException {
        
        if (namespaceURI.equals(NAMESPACE) && lName.equals(GET_OBJECT_ELEMENT)) {
            super.endElement(NAMESPACE, GET_OBJECT_ELEMENT, PREFIX + ":" + GET_OBJECT_ELEMENT);
        }
        else {
            super.endElement(namespaceURI, lName, qName);
        }
    }

    @Override
    public void characters(char[] c, int start, int len)
            throws SAXException {
        super.characters(c, start, len);
    }
    
}
