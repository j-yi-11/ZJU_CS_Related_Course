package org.example;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import javax.swing.JOptionPane;
public class ClientSocket {
	private Socket cliSocket;
	private ObjectInputStream socketIn;
	private ObjectOutputStream socketOut;
	private String serverIP = "127.0.0.1";
	private int port = 0;
	private String username;
	private ChattingRoomGUI chatRoom;
	public ClientSocket(String serverIP, int port, String username, ChattingRoomGUI chatRoom) {
		this.serverIP = serverIP;
		this.port = port;
		this.username = username;
		this.chatRoom = chatRoom;
	}
	public boolean connectServer() {
		try {
			cliSocket = new Socket(serverIP,port);
		}catch (Exception e) {
			JOptionPane.showMessageDialog(null, "Fail to connect to server", "Error",JOptionPane.ERROR_MESSAGE);
			return false;
		}
		JOptionPane.showMessageDialog(null, "connect to server successfully");
		String errorMsg="";
		try {
			socketIn = new ObjectInputStream(cliSocket.getInputStream());
			socketOut = new ObjectOutputStream(cliSocket.getOutputStream());
		}catch (Exception e) {
			errorMsg = "Create socket I/O error " + e;
			JOptionPane.showMessageDialog(null, errorMsg, "Error",JOptionPane.ERROR_MESSAGE);
			return false;
		}
		try {
			socketOut.writeObject(username);
		}catch (IOException e) {
			errorMsg = "Send msg to server ERROR " + e;
			JOptionPane.showMessageDialog(null, errorMsg, "Error",JOptionPane.ERROR_MESSAGE);
			return false;
		}
		new InteractWithServer().start();
		return true;
	}
	class InteractWithServer extends Thread{
		@Override
		public void run() {
			while(true) {
				try {
					Message servermsg = (Message) socketIn.readObject();
					String content = servermsg.getContent();
	                switch(servermsg.getType()) {
						case Message.MESSAGE:
							chatRoom.ChattingTaDisplay(content);
							break;
						case Message.USERLIST:
							chatRoom.UserlistTaClear();
							chatRoom.UserlistTaDisplay(content);
							break;
						default:
							System.out.println("message type ERROR "+servermsg.getType());
							break;
                	}
				} catch (Exception e) {
					JOptionPane.showMessageDialog(null, "already disconnect from server");
					chatRoom.setVisible(false);
					break;
				}
			}
		}
	}
	public void sendMessage(Message msg) {
		try {
			socketOut.writeObject(msg);
		} catch (Exception e) {
			JOptionPane.showMessageDialog(null, "send ERROR", "Error",JOptionPane.ERROR_MESSAGE);
		}
	}
}