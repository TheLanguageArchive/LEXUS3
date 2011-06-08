/*
 * Copyright (C) 2011 The Language Archive, Max Planck Institute for PsychoLinguistics
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package nl.mpi.lexus.desktop;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 *
 * @author huiver
 */
/* Jetty does not unzip the war file included in the .jar file, therefor
 * we'll do it ourselves. Sucks a bit, but hey.
 * 
 */
public class Unzip {

    public static void copyInputStream(InputStream in, OutputStream out)
            throws IOException {
        byte[] buffer = new byte[1024];
        int len;

        while ((len = in.read(buffer)) >= 0) {
            out.write(buffer, 0, len);
        }

        in.close();
        out.close();
    }

    public static void unzip(ZipFile zipFile, File outputFolder, String filename) throws IOException {
        Enumeration entries;

        if (null != filename) {
            System.err.println("Going to extract file: " + filename + " from " + zipFile.getName());
        }

        entries = zipFile.entries();

        while (entries.hasMoreElements()) {
            ZipEntry entry = (ZipEntry) entries.nextElement();

            if (entry.isDirectory()) {
                // Assume directories are stored parents first then children.
                // System.err.println("Extracting directory: " + outputFolder.getAbsolutePath() + entry.getName());
                // This is not robust, just for demonstration purposes.
                (new File(outputFolder, entry.getName())).mkdir();
                continue;
            }

            if (null == filename || entry.getName().equals(filename)) {
                // System.err.println("Extracting file: " + entry.getName());
                copyInputStream(zipFile.getInputStream(entry),
                        new BufferedOutputStream(new FileOutputStream(new File(outputFolder, entry.getName()))));
            }
        }

        zipFile.close();
    }
}
