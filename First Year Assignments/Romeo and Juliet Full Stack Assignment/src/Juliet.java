/*
 * Juliet.java
 *
 * Juliet class.  Implements the Juliet subsystem of the Romeo and Juliet ODE system.
 */


import javafx.util.Pair;

import java.io.*;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

public class Juliet extends Thread {

    private ServerSocket ownServerSocket = null; //Juliet's (server) socket
    private Socket serviceMailbox = null; //Juliet's (service) socket

    private double currentLove = 0;
    private double b = 0;

    //Class constructor
    public Juliet(double initialLove) {
        currentLove = initialLove;
        b = 0.01;
        int thePort = 7779;
        String theIPAddress = "127.0.0.1";
        try {
            ownServerSocket = new ServerSocket(thePort, 50, InetAddress.getByName(theIPAddress)); //sets up Juliet's server socket
            System.out.println("Juliet: Good pilgrim, you do wrong your hand too much, ...");
        }
        catch(Exception e) {
            System.out.println("Juliet: Failed to create own socket " + e);
            System.exit(1);
        }
    }





    //Get acquaintance with lover;
    // Receives lover's socket information and share's own socket
    public Pair<InetAddress,Integer> getAcquaintance() {
        System.out.println("Juliet: My bounty is as boundless as the sea,\n" +
                "       My love as deep; the more I give to thee,\n" +
                "       The more I have, for both are infinite.");

        //receive lover's socket information and share own socket



        InetAddress serverAddress = this.ownServerSocket.getInetAddress();
        int portNumber = this.ownServerSocket.getLocalPort();
        Pair<InetAddress, Integer> details = new Pair<>(serverAddress, portNumber);

        return details; //share's own socket

    }





    //Retrieves the lover's love (accepts the server's service request)
    public double receiveLoveLetter()    { // REVIEW THIS METHOD BECAUSE WTF IS HAPPENING HERE
        double tmp = 0.0;
        try {
            // serviceMailbox = new Socket("127.0.0.1", 7779); // creates socket connection
            serviceMailbox = this.ownServerSocket.accept();
            InputStream socketStream = serviceMailbox.getInputStream();
            InputStreamReader socketReader = new InputStreamReader(socketStream);
            char x;
            StringBuffer ODEvalue = new StringBuffer();
            while (true) {
                x = (char) socketReader.read();
                if (x == 'R') {
                    break;
                }
                ODEvalue.append(x);
            }
            tmp = Double.parseDouble(ODEvalue.toString()); // converts the message to a double
        }
        catch (IOException e) {
            throw new RuntimeException(e);
        }
        catch (Exception e){
            System.exit(1);
        }
        System.out.println("Juliet: Romeo, Romeo! Wherefore art thou Romeo? (<-" + tmp + ")");
        return tmp;
    }




    //Love (The ODE system)
    //Given the lover's love at time t, estimate the next love value for Romeo
    public double renovateLove(double partnerLove){
        System.out.println("Juliet: Come, gentle night, come, loving black-browed night,\n" +
                "       Give me my Romeo, and when I shall die,\n" +
                "       Take him and cut him out in little stars.");
        currentLove = currentLove+(-b*partnerLove);
        return currentLove;
    }





    //Communicate love back to playwriter
    public void declareLove(){

        //TO BE COMPLETED
        // prints juliet's goodnight message
        System.out.println("Good night, good night! Parting is such a sweet sorrow\n" +
                " That I shall say good night till it be morrow.");

        //return the outcome of the request to the client (sends back a message with the current ode value to the playwriter i.e. send back currentLove)
        try {
            OutputStream outcomeStream = serviceMailbox.getOutputStream();
            OutputStreamWriter outcomeStreamWriter = new OutputStreamWriter(outcomeStream);
            outcomeStreamWriter.write(currentLove + "J");
            outcomeStreamWriter.flush(); // return outcome
            serviceMailbox.close();

        }
        catch (IOException e) {
            throw new RuntimeException(e);
        }
        catch (Exception e){
            System.exit(1);
        }

    }





    //Execution
    public void run () {
        try {
            while (!this.isInterrupted()) {
                //Retrieve lover's current love
                double RomeoLove = this.receiveLoveLetter();

                //Estimate new love value
                this.renovateLove(RomeoLove);

                //Communicate back to lover, Romeo's love
                this.declareLove();
            }
        }catch (Exception e){
            System.out.println("Juliet: " + e);
        }
        if (this.isInterrupted()) {
            System.out.println("Juliet: I will kiss thy lips.\n" +
                    "Haply some poison yet doth hang on them\n" +
                    "To make me die with a restorative.");
        }

    }

}

