package org.apache.cocoon.generation;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.activation.MimetypesFileTypeMap;
import org.apache.avalon.framework.parameters.ParameterException;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

public class LexusFileUploads extends ServiceableGenerator {

    /** Logger for this class and subclasses */
    protected final Log logger = LogFactory.getLog(getClass());
    private long maxUploadSize = 1024 * 1024 * 10;
    private String uploadDir = "/tmp";

    /**
     * @Override setup method for generator
     * */
    public void setup(SourceResolver resolver, Map objectModel, String src, Parameters parameters)
            throws ProcessingException, SAXException, IOException {
        try {
            super.setup(resolver, objectModel, src, parameters);
            // maxUploadSize = parameters.getParameterAsLong("maxUploadSize");
            uploadDir = parameters.getParameter("uploadDir");
        } catch (ParameterException ex) {
            Logger.getLogger(LexusFileUploads.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Generate XML data.
     */
    public void generate()
            throws SAXException {


        final Request request = ObjectModelHelper.getRequest(objectModel);
        Map<String, String> map = new HashMap<String, String>();
        //We are echoing the parameters from the request here.
        Map paramMap = request.getParameters();

        for (String key : (Set<String>) paramMap.keySet()) {
            logger.info("Processing parameter " + key);
            String value = request.getParameter(key);
            if (value != null) {
                map.put(key, value);
            }
            try {
                String id = UUID.randomUUID().toString();

                map.put("id", id);
                int extSeparatorLastIndex = value.lastIndexOf(".");
                logger.debug("pathSeparatorLastIndex="+extSeparatorLastIndex + ", value="+value);
                String ext = (extSeparatorLastIndex == -1)
                        ? ""
                        : value.substring(extSeparatorLastIndex + 1, value.length());
                File tmpFile = new File(this.uploadDir + "/" + id + "." + ext); 

                File file = new File(value);
                org.apache.commons.io.FileUtils.copyFile(file, tmpFile);


                map.put("tmpFile", tmpFile.getAbsolutePath());

                request.getSession().setAttribute(id, tmpFile.getAbsolutePath());

                String mimeType = null;
                MimetypesFileTypeMap handler = new MimetypesFileTypeMap();
                mimeType = handler.getContentType(tmpFile);

                map.put("mimeType", mimeType);
                map.put(key, id);

            } catch (Exception ex) {
                logger.fatal("(" + key + "," + value + ") cannot be saved, error=" + ex.getMessage());
            }
        }
        AttributesImpl attr = new AttributesImpl();
        contentHandler.startDocument();
        contentHandler.startElement("", "result", "result", attr);
        for (String key : (Set<String>) map.keySet()) {
            contentHandler.startElement("", key, key, attr);
            contentHandler.characters(map.get(key).toCharArray(), 0, map.get(key).length());
            contentHandler.endElement("", key, key);
        }
        contentHandler.endElement("", "result", "result");
        contentHandler.endDocument();
    }
}
