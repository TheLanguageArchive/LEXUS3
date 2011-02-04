package nl.mpi.lexus.transformation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;

import javax.activation.MimetypesFileTypeMap;
import mpi.bcarchive.typecheck.FileType;
import org.apache.avalon.framework.parameters.ParameterException;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.apache.commons.io.FileUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * Transformer that copies an uploaded file to the users resources folder.
 * The file ID is retrieved from the session using the @id parameter.
 * A <resource value="filename" archive="local" type="..." fragmentIdentifier="..." url="..."/> element
 * is inserted into the SAX stream.
 * @author Huib Verweij (MPI.nl)
 *
 * Usage:
 *   <process-upload:to-resource value="id" type="..." xmlns:process-upload="http://www.mpi.nl/lexus/process-upload/1.0"/>
 */
public class UploadProcessorTransformer extends AbstractTransformer {

    // Identifies the namespace used for the copy transformation
    public static final String PROCESS_UPLOAD_NS =
            "http://www.mpi.nl/lexus/process-upload/1.0";
    // The file element that holds the source
    public static final String TO_RESOURCE_ELEMENT = "to-resource";
    
    // Attributes
    public static final String VALUE_ATTRIBUTE = "value";
    public static final String ARCHIVE_ATTRIBUTE = "archive";
    public static final String FRAGMENTIDENTIFIER_ATTRIBUTE = "fragmentIdentifier";
    public static final String URL_ATTRIBUTE = "url";
    public static final String MIMETYPE_ATTRIBUTE = "mimetype";
    public static final String TYPE_ATTRIBUTE = "type";

    // Output elements
    private static final String RESOURCE_ELEMENT_NAMESPACE = "";
    private static final String RESOURCE_ELEMENT = "resource";

    /* Parameter for the transformer */
    private final String USER_RESOURCES_FOLDER_PARAMETERS = "user-resources-folder";

    private static final String ARCHIVE_LOCAL = "local";

    private static final String TYPE_VIDEO = "video";
    private static final String TYPE_AUDIO = "audio";
    private static final String TYPE_IMAGE = "image";
    private static final String TYPE_URL = "url";

    private String usersResourcesFolder = "";
    private Map objectModel;

    public void setup(SourceResolver resolver, Map objectModel, String src,
            Parameters par)
            throws ProcessingException, SAXException, IOException {
        this.objectModel = objectModel;
        try {
            usersResourcesFolder = par.getParameter(USER_RESOURCES_FOLDER_PARAMETERS);
            getLogger().debug(USER_RESOURCES_FOLDER_PARAMETERS + "=" + usersResourcesFolder);
        } catch (ParameterException ex) {
            Logger.getLogger(UploadProcessorTransformer.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void startElement(String namespaceURI, String localName,
            String qName, Attributes attributes)
            throws SAXException {

        // If we encounter a file element in our namespace, invoke a copy
        // on the src attribute
        if (PROCESS_UPLOAD_NS.equals(namespaceURI) && TO_RESOURCE_ELEMENT.equals(localName)) {
            final Request request = ObjectModelHelper.getRequest(objectModel);
            final HttpSession session = request.getSession();
            String mimeType = "";
            String type = "";
            File tf = null;

            String id = attributes.getValue(VALUE_ATTRIBUTE);
            getLogger().debug("id " + id);
            getLogger().debug("session = " + session);

            String tmpFile = (String) session.getAttribute(id);
            try {
                tf = new File(tmpFile);
            } catch(Exception ioex) {
                getLogger().error("Failed to access uploaded file " + tmpFile);
            }
            if (null != tf) {
                String fileName = tf.getName();

                /* Try to copy the file to the resources folder. */
                try {
                    copy(tmpFile, usersResourcesFolder + fileName);
                } catch (Exception ex) {
                    getLogger().error("Failed to copy " + tmpFile + " to " + usersResourcesFolder);
                }

                /* determine mimetype */
                FileType ft = new FileType();
                FileInputStream tmpStr;
                try {
                    tmpStr = new FileInputStream(tmpFile);
                    String str = ft.checkStream(tmpStr, fileName);
                    tmpStr.close();
                    mimeType = FileType.resultToMimeType(str);
                    if (mimeType == null) {
                        //We switch to the 'standard' java mime type maper here
                        MimetypesFileTypeMap handler = new MimetypesFileTypeMap();
                        mimeType = handler.getContentType(tmpFile);

                    }
                } catch (Exception ex) {
                    getLogger().error("Failed to establish mimetype: " + ex.getLocalizedMessage());
                }

                /* Delete the file from scratch area. */
                tf.delete();

                /* Determine general type */
                type = determineType(mimeType);

                /* Add the attributes. */
                AttributesImpl attr = new AttributesImpl();
                // attr.setAttributes(attributes);
                attr.addAttribute("", VALUE_ATTRIBUTE, VALUE_ATTRIBUTE, "string", fileName);
                attr.addAttribute("", ARCHIVE_ATTRIBUTE, ARCHIVE_ATTRIBUTE, "string", ARCHIVE_LOCAL);
                attr.addAttribute("", MIMETYPE_ATTRIBUTE, MIMETYPE_ATTRIBUTE, "string", mimeType);
                attr.addAttribute("", TYPE_ATTRIBUTE, TYPE_ATTRIBUTE, "string", type);

                contentHandler.startElement(RESOURCE_ELEMENT_NAMESPACE, RESOURCE_ELEMENT, RESOURCE_ELEMENT, attr);
                contentHandler.endElement(RESOURCE_ELEMENT_NAMESPACE, RESOURCE_ELEMENT, RESOURCE_ELEMENT);
            }
        } else {
            super.startElement(namespaceURI, localName, qName, attributes);
        }
    }

    @Override
    public void endElement(String namespaceURI, String localName, String qName)
            throws SAXException {

        if (PROCESS_UPLOAD_NS.equals(namespaceURI) && TO_RESOURCE_ELEMENT.equals(localName)) {
            // Do nothing here since we want to remove this element.
        } else {
            super.endElement(namespaceURI, localName, qName);
        }
    }

    /**
     * Method that creates a File object based on the given name and copies it if
     * possible. File may be a directory, in which case subdirs are also
     * removed.
     *
     * @param name The name of the file or directory to be copied.
     */
    private void copy(String name, String target) throws SAXException {

        getLogger().debug("Copying file " + name + " to " + target);
        File file = new File(name);
        File outfile = new File(target);
        if (outfile != null && outfile.exists()) {
            throw new SAXException("Will not overwrite existing target file: " + target);
        }
        if (file != null && outfile != null && file.exists()) {
            try {
                // File to file or file to dir copy
                FileUtils.copyFile(file, outfile);
            } catch (Exception ignore) {
                throw new SAXException("Could not copy file " + name + " to " + target + " (error: " + ignore + ")");
            }
        }
    }

    
    /* This determines the general type (?) according to mimetype.
        HHV: It's a bit limited I suspect, copied it from nl.mpi.lexicon.domain.LMF.instance.Resource. */
    private String determineType(String mimeType) {

        if (mimeType.startsWith("video/")) {
            return TYPE_VIDEO;
        } else if (mimeType.startsWith("audio/")) {
            return TYPE_AUDIO;
        } else if (mimeType.startsWith("image/")) {
            return TYPE_IMAGE;
        } else if (mimeType.equals("application/smil+xml")) {
            return TYPE_VIDEO;
        } else if (mimeType.equals("application/ogg")) {
            return TYPE_AUDIO;
        }
        return TYPE_URL;
    }
}
