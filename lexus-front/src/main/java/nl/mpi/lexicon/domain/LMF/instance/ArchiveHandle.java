package nl.mpi.lexicon.domain.LMF.instance;

/**
 * This class describes an ArchiveHandle. It contains a reference to the Archive and a reference to the 
 * archived resource.
 * In case persistent Identifiers are used that can be resolved, the archiveIdentifier may also point to the
 * resolver for the pid. 
 * @author Marc Kemps-Snijders
 * For comments or requests please contact www.mpi.nl
 *
 */
public class ArchiveHandle {
	/**
	 * Refers to the persistent ID of this object
	 */
	private String ID;
	/**
	 * Indicates a local copy
	 */
	public final static String LOCAL_COPY = "local";

	/**
	 * Reference to the archive/resolver
	 */
	private String archiveIdentifier;
	/**
	 * Reference to the resource identifier
	 */
	private String resourceHandle;
	/**
	 * Refers to the mimeType of the object.
	 */
	private String mimeType;
	/**
	 * Refers to the fragment in the resource
	 */
	private String fragmentIdentifier;
	
	
	public ArchiveHandle(){
		super();
	}
	/**
	 * @return the iD
	 */
	public String getID() {
		return ID;
	}

	/**
	 * @param id the iD to set
	 */
	public void setID(String id) {
		ID = id;
	}
	/**
	 * @return the archiveIdentifier
	 */
	public String getArchiveIdentifier() {
		return archiveIdentifier;
	}

	/**
	 * @param archiveIdentifier the archiveIdentifier to set
	 */
	public void setArchiveIdentifier(String archiveIdentifier) {
		this.archiveIdentifier = archiveIdentifier;
	}

	/**
	 * @return the resourceHandle
	 */
	public String getResourceHandle() {
		return resourceHandle;
	}

	/**
	 * @param resourceHandle the resourceHandle to set
	 */
	public void setResourceHandle(String resourceHandle) {
		this.resourceHandle = resourceHandle;
	}

	/**
	 * @return the mimeType
	 */
	public String getMimeType() {
		return mimeType;
	}

	/**
	 * @param mimeType the mimeType to set
	 */
	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	/**
	 * @return the fragmentIdentifier
	 */
	public String getFragmentIdentifier() {
		return fragmentIdentifier;
	}

	/**
	 * @param fragmentIdentifier the fragmentIdentifier to set
	 */
	public void setFragmentIdentifier(String fragmentIdentifier) {
		this.fragmentIdentifier = fragmentIdentifier;
	}
	
	
}
