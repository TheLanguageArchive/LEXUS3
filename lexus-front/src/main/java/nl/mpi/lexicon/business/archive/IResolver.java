package nl.mpi.lexicon.business.archive;

import java.net.URL;

import nl.mpi.lexicon.domain.LMF.instance.ArchiveHandle;

public interface IResolver {
	/**
	 * Resolves the specified ArchiveHandle to a URL
	 * @param a_archiveHandle
	 * @return
	 * @throws ResolveException
	 */
	public URL resolve( ArchiveHandle a_archiveHandle) throws ResolveException;
	/**
	 * Returns the URL to the metadata of the specified handle
	 * @param a_archiveHandle
	 * @return
	 * @throws ResolveException
	 */
	public URL getMetaDataURL( ArchiveHandle a_archiveHandle) throws ResolveException;

	
}
