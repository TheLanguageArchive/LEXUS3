package nl.mpi.lexus.desktop;

import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.net.URISyntaxException;
import java.net.URI;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipException;
import javax.swing.*;
import java.security.ProtectionDomain;
import java.util.zip.ZipFile;

import org.basex.http.rest.RESTServlet;
import org.basex.http.restxq.RestXqServlet;

import com.google.common.io.Files;

import org.mortbay.jetty.Connector;
import org.mortbay.jetty.Server;
import org.mortbay.jetty.nio.SelectChannelConnector;
import org.mortbay.jetty.webapp.WebAppContext;

/**
 * Create a system tray icon from where Lexus can be started.
 *
 */
public class Lexus {

    private static Server webServer = null;
    private static org.basex.http.restxq.RestXqServlet db = null;
    private static Desktop desktop = null;

    public static void main(String[] args) {
        /* Turn off metal's use of bold fonts */
        UIManager.put("swing.boldMetal", Boolean.FALSE);
        //Schedule a job for the event-dispatching thread:
        //adding TrayIcon.
        SwingUtilities.invokeLater(new Runnable() {

            @Override
            public void run() {
                createAndShowGUI();
            }
        });

        if (Desktop.isDesktopSupported()) {
            desktop = Desktop.getDesktop();
        }

    }

    private static void createAndShowGUI() {
        //Check the SystemTray support
        if (!SystemTray.isSupported()) {
            System.out.println("SystemTray is not supported");
            return;
        }
        final PopupMenu popup = new PopupMenu();
        final TrayIcon trayIcon =
                new TrayIcon(createImage("/images/LEXUS_IKON.png", "tray icon"));
        final SystemTray tray = SystemTray.getSystemTray();
        System.out.println(tray.getTrayIconSize());

        // Create a popup menu components
        MenuItem aboutItem = new MenuItem("About");
        final MenuItem open = new MenuItem("Open Lexus");
        MenuItem exitItem = new MenuItem("Exit");

        //Add components to popup menu
        popup.add(aboutItem);
        popup.addSeparator();
        popup.add(open);
        popup.addSeparator();
        popup.add(exitItem);

        trayIcon.setPopupMenu(popup);

        try {
            tray.add(trayIcon);
        } catch (AWTException e) {
            System.out.println("TrayIcon could not be added.");
            return;
        }


        trayIcon.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,
                        "This dialog box is run from System Tray");
            }
        });


        aboutItem.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null,
                        "Lexus is the lexicon editor from the Max Planck Institute for Psycholinguistics in Nijmegen, the Netherlands.");
            }
        });


        open.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                if (!lexusStarted()) {
                    open.setEnabled(false);
                    try {
                        startDb();
                        try {
                            startWebserver();
                        } catch (URISyntaxException ex) {
                            Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } catch (ZipException ex) {
                        Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (IOException ex) {
                        Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
                    } finally {
                        open.setEnabled(true);
                    }
                }
                if (lexusStarted()) {
                    openLexus();
                } else {
                    JOptionPane.showMessageDialog(null,
                            "Could not start Lexus because: "
                            + (dbStarted() ? "the database could not start " : "")
                            + (webServerStarted() ? "the webserver could not start " : "")
                            + ".");
                    stopLexus();
                }
            }
        });


        exitItem.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                if (lexusStarted()) {
                    stopLexus();
                }
                tray.remove(trayIcon);
                System.exit(0);
            }
        });
    }

    //Obtain the image URL
    protected static Image createImage(String path, String description) {
        System.out.println(Lexus.class.getPackage() + "." + path + ": " + description);
        URL imageURL = Lexus.class.getResource(path);
        System.out.println(imageURL.toExternalForm());
        if (imageURL == null) {
            System.err.println("Resource not found: " + path);
            return null;
        } else {
            return (new ImageIcon(imageURL, description)).getImage();
        }
    }

    private static Boolean dbStarted() {
        return null != db;
    }

    private static Boolean webServerStarted() {
        return null != webServer;
    }

    private static Boolean lexusStarted() {
        return dbStarted() && webServerStarted();
    }

    private static void stopLexus() {
        try {
            if (webServerStarted()) {
                webServer.stop();
                webServer.join();
            }
        } catch (Exception ex) {
            Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (dbStarted()) {
            db.destroy();
        }
    }

    // Start the database.
    protected static Boolean startDb() {
        db = new RestXqServlet();
        return true;
    }

    // Start the webserver.
    protected static Boolean startWebserver() throws ZipException, IOException, URISyntaxException {

        String webappFilename = "webapp-3.0-SNAPSHOT.war";
        String jetty_default = ".";
        String jetty_home = System.getProperty("jetty.home", jetty_default);

        webServer = new Server();

        ProtectionDomain domain = Lexus.class.getProtectionDomain();
        URL location = domain.getCodeSource().getLocation();


        Connector connector = new SelectChannelConnector();
        connector.setPort(Integer.getInteger("jetty.port", 8080).intValue());
        webServer.setConnectors(new Connector[]{connector});

        WebAppContext webapp = new WebAppContext();
        webapp.setContextPath("/");
        webapp.setServer(webServer);
        webapp.setExtractWAR(true);

        File tempFolder = Files.createTempDir();
        System.out.println("tempFolder=" + tempFolder);
        File moduleFile = new File(Lexus.class.getProtectionDomain().getCodeSource().getLocation().toURI());

        if(!moduleFile.isDirectory()){
        	Unzip.unzip(new ZipFile(moduleFile), tempFolder, webappFilename);
        	File warFile = new File(tempFolder, "/" + webappFilename);
            webapp.setWar(warFile.getAbsolutePath());
            System.out.println("warFile=" + warFile);
        }
        else{
        	webapp.setWar(Lexus.class.getProtectionDomain().getCodeSource().getLocation().toURI() + "/" + webappFilename);
            System.out.println("warFile=" + Lexus.class.getProtectionDomain().getCodeSource().getLocation().toURI() + "/" + webappFilename);
        }
        
        
        webServer.setHandler(webapp);

        try {
            webServer.start();
        } catch (Exception ex) {
            Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }

    // Open Lexus in the browser.
    protected static Boolean openLexus() {
        if (null != desktop && null != webServer) {
            try {
                URI lexusHome = new java.net.URI("http://localhost:8080/index.html");
                System.out.println("lexusHome=" + lexusHome.toString());
                desktop.browse(lexusHome);
            } catch (URISyntaxException ex) {
                Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            }
            return true;
        } else {
            return false;
        }
    }
}