package nl.mpi.lexicon.business.archive;
/**
 * This class describes a ResolveException. These are typically thrown if a an ArchiveHandle can not be
 * resolved to a URL.
 * @author Marc Kemps-Snijders
 * For comments or requests please contact www.mpi.nl
 *
 */
public class ResolveException extends Exception{

	/**
	 * Constructor
	 * @param a_message
	 */
	public ResolveException( String a_message){
		super( a_message);
	}
	/**
	 * Constructor
	 * @param a_message
	 * @param a_throwable
	 */
	public ResolveException( String a_message, Throwable a_throwable){
		super( a_message, a_throwable);
	}
}
