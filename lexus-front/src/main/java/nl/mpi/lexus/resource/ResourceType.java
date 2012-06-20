package nl.mpi.lexus.resource;

//import mpi.bcarchive.typecheck.FileType;

/**
 * Determine type of resource
 */
public class ResourceType {

    private static final String TYPE_VIDEO = "video";
    private static final String TYPE_AUDIO = "audio";
    private static final String TYPE_IMAGE = "image";
    private static final String TYPE_URL = "url";

    
    /* This determines the general type (?) according to mimetype.
        HHV: It's a bit limited I think, copied it from nl.mpi.lexicon.domain.LMF.instance.Resource. */
    public static String determineType(String mimeType) {
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
