package nl.mpi.lexus.desktop;

import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.net.URISyntaxException;
import java.net.URI;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.*;
import org.basex.api.jaxrx.JaxRxServer;


import org.mortbay.jetty.Connector;
import org.mortbay.jetty.Server;
import org.mortbay.jetty.nio.SelectChannelConnector;
import org.mortbay.jetty.webapp.WebAppContext;

/**
 * Hello world!
 *
 */
public class Lexus {

    private static Server server = null;
    private static org.basex.api.jaxrx.JaxRxServer db = null;
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
        MenuItem start = new MenuItem("Start");
        MenuItem open = new MenuItem("Open Lexus");
        MenuItem exitItem = new MenuItem("Exit");

        //Add components to popup menu
        popup.add(aboutItem);
        popup.addSeparator();
        popup.add(start);
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

        start.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                startDb();
                startWebserver();
                openLexus();
            }
        });
        
        open.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                openLexus();
            }
        });


        exitItem.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    server.stop();
                    server.join();
                } catch (Exception ex) {
                    Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                db.quit(true);
                
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

    // Start the database.
    protected static Boolean startDb() {
        db = new JaxRxServer();
        return true;
    }

    // Start the webserver.
    protected static Boolean startWebserver() {

        String jetty_default = new java.io.File("./start.jar").exists() ? "." : "../..";;
        String jetty_home = System.getProperty("jetty.home", jetty_default);

        server = new Server();

        Connector connector = new SelectChannelConnector();
        connector.setPort(Integer.getInteger("jetty.port", 8080).intValue());
        server.setConnectors(new Connector[]{connector});

        WebAppContext webapp = new WebAppContext();
        webapp.setContextPath("/");
        webapp.setWar(Lexus.class.getResource("/webapp-3.0-SNAPSHOT.war").toString());
        //webapp.setDefaultsDescriptor(jetty_home+"/etc/webdefault.xml");

        server.setHandler(webapp);
        try {
            server.start();
            //    server.join();
        } catch (Exception ex) {
            Logger.getLogger(Lexus.class.getName()).log(Level.SEVERE, null, ex);
        }
        return true;
    }

    // Open Lexus in the browser.
    protected static Boolean openLexus() {
        if (null != desktop) {
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
