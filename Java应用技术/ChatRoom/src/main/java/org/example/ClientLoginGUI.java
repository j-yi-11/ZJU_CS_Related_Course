package org.example;
import java.awt.Color;
import java.awt.Font;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
@SuppressWarnings("serial")
public class ClientLoginGUI extends JFrame {
	private JPanel contentPanel = new JPanel();
	private JLabel bgLabel;
	private JLabel serverLabel = new JLabel("Server IP Address");
	private JLabel portLabel = new JLabel("Port");
	private JLabel userLabel = new JLabel("User Name");
	private JLabel titleLabel = new JLabel("Login In GUI");
	private JButton loginBtn = new JButton("Login in");
	private JTextField serverTf = new JTextField("127.0.0.1");
	private JTextField portTf = new JTextField("3803");
	private JTextField userTf = new JTextField();
	public static ChattingRoomGUI chatRoom = new ChattingRoomGUI();
	public static ClientSocket Client;
	public ClientLoginGUI() {
		this.init();
		this.addListener();
	}
	@SuppressWarnings("deprecation")
	private void init() {
		this.setTitle("Client Login In GUI");
		this.setSize(500, 315);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
        Toolkit kit =Toolkit.getDefaultToolkit();
        Image image1 =kit.createImage("images/JYlogo.jpeg");
        setIconImage(image1);
		ImageIcon image2 = new ImageIcon("images/JYinit.gif");
		bgLabel = new JLabel(image2);
		bgLabel.setBounds(0, 0, 500, 280);
		Integer con = Integer.valueOf(Integer.MIN_VALUE);
		this.getLayeredPane().add(bgLabel, con);
		((JPanel) this.getContentPane()).setOpaque(false);
		contentPanel.setLayout(null);
		add(serverTf);
		add(portTf);
		add(userTf);
		add(loginBtn);
		add(serverLabel);
		add(portLabel);
		add(titleLabel);
		add(userLabel);
		serverTf.setBounds(140, 110, 240, 20);
		portTf.setBounds(140, 140, 240, 20);
		userTf.setBounds(140, 170, 240, 20);
		Font f1 = new Font("黑体", Font.BOLD + Font.ITALIC, 12);
		serverLabel.setBounds(50, 107, 90, 25);
		serverLabel.setFont(f1);
		serverLabel.setForeground(Color.RED);
		portLabel.setBounds(85, 137, 90, 25);
		portLabel.setFont(f1);
		portLabel.setForeground(Color.RED);
		userLabel.setBounds(85, 167, 90, 25);
		userLabel.setFont(f1);
		userLabel.setForeground(Color.RED);
		titleLabel.setBounds(165, 50, 200, 50);
		Font f2 = new Font("隶书", Font.BOLD, 38);
		titleLabel.setFont(f2);
		titleLabel.setForeground(Color.BLACK);
		loginBtn.setBounds(200, 225, 100, 30);
		contentPanel.setOpaque(false);
		getContentPane().add(contentPanel);
	}
	private void addListener() {
		loginBtn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				forloginBtn(serverTf.getText().trim(), portTf.getText().trim(), userTf.getText().trim());
			}
		});
	}
	public void forloginBtn(String serverIP, String port, String username) {
		int portnum;
        if(serverIP.length() == 0){
        	JOptionPane.showMessageDialog(null, "Server IP address is null", "Error",JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(port.length() == 0){
        	JOptionPane.showMessageDialog(null, "Port is null", "Error",JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(username.length() == 0){
        	JOptionPane.showMessageDialog(null, "User name is null", "Error",JOptionPane.ERROR_MESSAGE);
            return;
        }
        try {
        	portnum = Integer.parseInt(port);
        }
        catch(Exception e) {
        	JOptionPane.showMessageDialog(null, "Port need to be integer between 1 and 65535", "Error",JOptionPane.ERROR_MESSAGE);
            return;
        }
		Client = new ClientSocket(serverIP, portnum, username, chatRoom);
		if(!Client.connectServer())
			return;
		setVisible(false);
	    chatRoom.setVisible(true);
	}
}


