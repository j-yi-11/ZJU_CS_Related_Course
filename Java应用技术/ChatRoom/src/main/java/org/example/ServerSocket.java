package org.example;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import javax.swing.JOptionPane;
public class ServerSocket {
    private int port;
    private ArrayList<InteractWithClient> clientlist;
    private int clientid;
    private SimpleDateFormat curtime;
    private ServerGUI server;
    private ConnectDatabase database;
    public ServerSocket(int port, ServerGUI server) {
        this.port = port;
        clientlist = new ArrayList<InteractWithClient>();
        this.clientid = 0;
        this.curtime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        this.server = server;
        this.database = new ConnectDatabase();
    }
    public void listen() {
        try
        {
            java.net.ServerSocket serverSocket = new java.net.ServerSocket(port);
            display("Listening Port " + port + " ...\n");
            while(true)
            {
                Socket socket = serverSocket.accept();      
                InteractWithClient tempclient = new InteractWithClient(socket);  
                clientlist.add(tempclient);
                tempclient.start();
                notifyClients(tempclient.userName+" is Online");
                database.insertData("server", tempclient.userName+" is online");
                display(tempclient.userName+" connected to server with online people:" + clientlist.size() + "\n");
            }
        }
        catch (IOException e) {
            String msg = curtime.format(new Date()) + " Creating ServerSocket ERROR: " + e + "\n";
            display(msg);
        }finally {
            // TODO: show all data and close connection to database
            try{
                database.queryData("TRUE");
            }catch (SQLException e){
                e.printStackTrace();
            }
            if(this.database!=null){
                database.closeConnection();
            }
        }
    }
    private synchronized void notifyClients(String message) {
        String notice = curtime.format(new Date()) + "\n" + message + "\n\n";
        Message chatmsg = new Message(Message.MESSAGE, notice);
        for(int i = 0; i < clientlist.size(); ++i) {
            InteractWithClient nowclient = clientlist.get(i);
            nowclient.sendMessage(chatmsg);
        }
    	String tempstr = "Number of Users Online Now is " + clientlist.size() + "\n";
    	tempstr += "Online Users List as Follows:\n";
    	tempstr += "ID  User Name    Connect Time\n";
        for(int i = 0; i < clientlist.size(); ++i) {
            InteractWithClient nowclient = clientlist.get(i);
            tempstr += " ["+(i+1) + "]     " + nowclient.userName + "      " + nowclient.linktime +  "\n";
        }
        Message listmsg = new Message(Message.USERLIST, tempstr);
        for(int i = 0; i < clientlist.size(); ++i) {
            InteractWithClient nowclient = clientlist.get(i);
            nowclient.sendMessage(listmsg);
        }
    }
    synchronized void remove(int id) {
        for(int i = 0; i < clientlist.size(); i++)
        {
            InteractWithClient nowclient = clientlist.get(i);
            if(nowclient.id == id)
            {
                clientlist.remove(i);
                return;
            }
        }
    }
    private void display(String msg) {
        msg = curtime.format(new Date()) + " " + msg;
        server.MonitorTaDisplay(msg);
    }
    class InteractWithClient extends Thread {
    	int id;
        Socket socket;
        ObjectInputStream socketInput;
        ObjectOutputStream socketOutput;
        String userName;
        String linktime;
        Message clientmessage;
        InteractWithClient(Socket socket) {
            id = ++clientid;
            this.socket = socket;
            String errorMsg;
            try
            {
            	socketOutput = new ObjectOutputStream(socket.getOutputStream());
                socketInput  = new ObjectInputStream(socket.getInputStream());
            	userName = (String) socketInput.readObject();
            }
            catch (IOException e1) {
            	errorMsg = "Create socket I/O stream ERROR! " + e1;
            	JOptionPane.showMessageDialog(null, errorMsg, "Error",JOptionPane.ERROR_MESSAGE);
                return;
            }
            catch (ClassNotFoundException e2) {
            }
            linktime = curtime.format(new Date());
        }
        @Override
        public void run() {
            while(true) {
                try {
                    clientmessage = (Message) socketInput.readObject();
                }
                catch (IOException e1) {
                    break;
                }
                catch(ClassNotFoundException e2) {
                    break;
                }
                notifyClients(userName + " said:\n" + clientmessage.getContent());
                //TODO write String message to database
                database.insertData(userName,clientmessage.getContent());
            }
            remove(id);
            notifyClients(userName+" is absent now\n");
            display(userName+" disconnect from the server with current online people: " + clientlist.size() + "\n");
        }
        private boolean sendMessage(Message msg) {
            if(!socket.isConnected()) {
                return false;
            }
            try {
                socketOutput.writeObject(msg);
            }
            catch(IOException e) {
            	display("send message to " + userName + " but exception occurs" + e.toString() + "\n");
            	return false;
            }
            return true;
        }
    }
}
