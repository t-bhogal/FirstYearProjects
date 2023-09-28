/*
 * Romeo.java
 *
 * Romeo class.  Implements the Romeo subsystem of the Romeo and Juliet ODE system.
 */


import java.lang.Thread;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.InetAddress;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.IOException;

import javafx.util.Pair;

public class Romeo extends Thread {

    private ServerSocket ownServerSocket = null; //Romeo's (server) socket
    private Socket serviceMailbox = null; //Romeo's (service) socket


    private double currentLove = 0;
    private double a = 0; //The ODE constant

    //Class construtor
    public Romeo(double initialLove) {
        currentLove = initialLove;
        a = 0.02;
        int thePort = 7778;
        String theIPAddress = "127.0.0.1";
        try {
            ownServerSocket = new ServerSocket(thePort, 50, InetAddress.getByName(theIPAddress)); //sets up Romeo's server socket

            //TO BE COMPLETED

            System.out.println("Romeo: What lady is that, which doth enrich the hand\n" +
                    "       Of yonder knight?");
        } catch(Exception e) {
            System.out.println("Romeo: Failed to create own socket " + e);
        }
    }

    //Get acquaintance with lover;
    public Pair<InetAddress,Integer> getAcquaintance() {
        System.out.println("Romeo: Did my heart love till now? forswear it, sight! For I ne'er saw true beauty till this night.");

        //TO BE COMPLETED
        // RECEIVE LOVER'S SOCKET INFORMATION



        InetAddress serverAddress = this.ownServerSocket.getInetAddress();
        int portNumber = this.ownServerSocket.getLocalPort();
        Pair<InetAddress, Integer> details = new Pair<>(serverAddress, portNumber);

        return details; //share's own socket

    }


    //Retrieves the lover's love
    public double receiveLoveLetter()
    {
        double tmp = 0.0;
        try {
            // serviceMailbox = new Socket("127.0.0.1", 7779); // creates socket connection
            serviceMailbox = this.ownServerSocket.accept();
            InputStream socketStream = serviceMailbox.getInputStream();
            InputStreamReader socketReader = new InputStreamReader(socketStream);
            char x; // reads the message from the socket
            StringBuffer ODEvalue = new StringBuffer();
            while (true) {
                x = (char) socketReader.read();
                if (x == 'J') {
                    break;
                }
                ODEvalue.append(x);
            }
            tmp = Double.parseDouble(ODEvalue.toString()); // converts the message to a double
        }
        catch (IOException e) {
            throw new RuntimeException(e);
        }
        catch (Exception e) {
            System.exit(1);
        }
        System.out.println("Romeo: O sweet Juliet... (<-" + tmp + ")");
        return tmp;
    }


    //Love (The ODE system)
    //Given the lover's love at time t, estimate the next love value for Romeo
    public double renovateLove(double partnerLove){
        System.out.println("Romeo: But soft, what light through yonder window breaks?\n" +
                "       It is the east, and Juliet is the sun.");
        currentLove = currentLove+(a*partnerLove);
        return currentLove;
    }


    //Communicate love back to playwriter
    public void declareLove(){

        //TO BE COMPLETED
        System.out.println("I would I were thy bird");

        try {
            OutputStream outcomeStream = serviceMailbox.getOutputStream();
            OutputStreamWriter outcomeStreamWriter = new OutputStreamWriter(outcomeStream);
            outcomeStreamWriter.write(currentLove + "R");
            outcomeStreamWriter.flush(); // return outcome
            serviceMailbox.close();

        }
        catch (IOException e) {
            throw new RuntimeException(e);
        }
        catch (Exception e) {
            System.exit(1);
        }
    }



    //Execution
    public void run () {
        try {
            while (!this.isInterrupted()) {
                //Retrieve lover's current love
                double JulietLove = this.receiveLoveLetter();

                //Estimate new love value
                this.renovateLove(JulietLove);

                //Communicate love back to playwriter
                this.declareLove();
            }
        }catch (Exception e){
            System.out.println("Romeo: " + e);
        }
        if (this.isInterrupted()) {
            System.out.println("Romeo: Here's to my love. O true apothecary,\n" +
                    "Thy drugs are quick. Thus with a kiss I die." );
        }
    }

}
