package nl.mpi.lexicon.business.archive;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NameNotFoundException;
import javax.naming.NamingException;

import mpi.corpusstructure.ArchiveAccessContext;
import mpi.corpusstructure.CorpusStructureDB;
import mpi.corpusstructure.CorpusStructureDBImpl;
import mpi.corpusstructure.Node;
import mpi.corpusstructure.UnknownNodeException;
import mpi.util.OurURL;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import nl.mpi.lexicon.domain.LMF.instance.ArchiveHandle;

public class LamusResolver implements IResolver {

    protected final Log logger = LogFactory.getLog(getClass());
    String databaseLocation = "java:comp/env/jdbc/CSDB";
    private String ANNEX_SERVICE = "";
    public final static String ARCHIVE_IDENTIFIER = "MPI";

    public LamusResolver() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            this.ANNEX_SERVICE = (String) envCtx.lookup("LEXUS/EAF_Handler");
        } catch (NamingException e) {
            throw new IllegalArgumentException("Unable to load EAF Handler from initial context");
        }

    }

    public LamusResolver(URL a_annexServiceLocation) {
        this.ANNEX_SERVICE = a_annexServiceLocation.toExternalForm();
    }
    /*
     * (non-Javadoc)
     * @see nl.mpi.lexicon.business.archive.IResolver#resolve(nl.mpi.lexicon.domain.LMF.instance.ArchiveHandle)
     */

    public URL resolve(ArchiveHandle a_resourceHandle) throws ResolveException {
        CorpusStructureDBImpl db = new CorpusStructureDBImpl(this.databaseLocation);
        URL result = null;
        try {
            Node node = null;
            try {
                node = db.getNode(a_resourceHandle.getResourceHandle());
            } catch (UnknownNodeException e) {
                logger.error(e);
                throw new ResolveException("ResourceHandle[" + a_resourceHandle + "] not recognized by LAMUS.", e);
            }


            boolean processed = false;
            if (node.getFormat().equals(CorpusStructureDB.WR_FORMAT_EAF) || node.getFormat().trim().equals("EAF")) {
                String resourceHandle = a_resourceHandle.getResourceHandle();
                try {
                    resourceHandle = URLEncoder.encode(resourceHandle, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    //This should never happen
                    logger.error(e);
                }
                String location = this.ANNEX_SERVICE + "?nodeid=" + resourceHandle + "&" + a_resourceHandle.getFragmentIdentifier();

                try {
                    result = new URL(location);
                    processed = true;
                } catch (MalformedURLException e) {
                    logger.error(e);
                    //we will not throw a ResolveException here. A direct link tpo the resource itself will be provided instead see below
                }

            }

            if (!processed) {
                OurURL url = db.getObjectURL(a_resourceHandle.getResourceHandle(), ArchiveAccessContext.HTTP_URL);

                try {
                    result = new URL(url.getProtocol(), url.getHost(), url.getPort(), url.getPath());
                } catch (MalformedURLException e) {
                    logger.error(e);
                    throw new ResolveException("Unable to create URL from LAMUS result[" + url.getProtocol() + "," + url.getHost() + "," + url.getPort() + "," + url.getPath() + "]");
                }
            }
        } catch (Throwable t) {
            logger.error(t);
        } finally {
            db.close();
        }
        return result;

    }


    /* (non-Javadoc)
     * @see nl.mpi.lexicon.business.archive.IResolver#getMetaDataURI(nl.mpi.lexicon.domain.LMF.instance.ArchiveHandle)
     */
    public URL getMetaDataURL(ArchiveHandle a_archiveHandle) throws ResolveException {
        String IMDIHandlerContextPath = null;
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            IMDIHandlerContextPath = (String) envCtx.lookup("LEXUS/IMDI_Handler");

        } catch (NameNotFoundException e) {
            logger.error(e);
            throw new ResolveException("LEXUS/IMDI_HANDLER not found in Context document. Please check configuration..");
        } catch (NamingException e) {
            logger.error(e);
            throw new ResolveException("Unable to retrieve Context for imdi handler extraction");
        }

        URL url = null;
        try {
            url = new URL(IMDIHandlerContextPath + "?openpath=" + URLEncoder.encode(a_archiveHandle.getResourceHandle(), "UTF-8"));
            //url = new URL("http", "corpus1.mpi.nl", "/ds/imdi_browser/?openpath=" + URLEncoder.encode( "UTF-8", a_archiveHandle.getResourceHandle()));
        } catch (MalformedURLException e) {
            logger.error(e);
            throw new ResolveException("Unable to create URL for metadata");
        } catch (UnsupportedEncodingException e) {
            throw new ResolveException("UTF-8 is not supprted???");
        }
        return url;
    }
}
