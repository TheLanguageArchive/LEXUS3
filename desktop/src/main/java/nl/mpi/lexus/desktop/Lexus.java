package nl.mpi.lexus.desktop;

import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.net.URL;
import javax.swing.*;

/**
 * Hello world!
 *
 */
public class Lexus 
{
    
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
        MenuItem cb1 = new MenuItem("Start");
        MenuItem exitItem = new MenuItem("Exit");
        
        //Add components to popup menu
        popup.add(aboutItem);
        popup.addSeparator();
        popup.add(cb1);
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
        
        cb1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                startDb();
                startWebserver();
                openLexus();
            }
        });
        

        exitItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
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
        return true;
    }
    
    
    // Start the webserver.
    protected static Boolean startWebserver() {
        return true;
    }
    
    
    // Open Lexus in the browser.
    protected static Boolean openLexus() {
        return true;
    }
    

}
