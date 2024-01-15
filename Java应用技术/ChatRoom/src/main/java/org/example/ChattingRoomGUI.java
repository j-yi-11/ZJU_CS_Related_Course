package org.example;
import java.awt.Color;
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
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
public class ChattingRoomGUI extends JFrame {
	private JPanel contentPanel = new JPanel();
	private JLabel bgLabel;
	private JButton sendBtn = new JButton("Send");
	private JButton clearBtn = new JButton("Clear");
	private JTextField chattingTf = new JTextField();
	private JTextArea chattingTa;
	private JTextArea userlistTa;
	private JScrollPane chattingSp;
	private JScrollPane userlistSp;
	public ChattingRoomGUI() {
		this.init();
		this.addListener();
	}
	private void init() {
		this.setTitle("Chatting Window");
		this.setSize(610, 570);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(false);
        Toolkit kit =Toolkit.getDefaultToolkit();
        Image image2 =kit.createImage("images/JYlogo.jpeg");
        setIconImage(image2);
		ImageIcon image1 = new ImageIcon("images/JYemjoy.gif");
		bgLabel = new JLabel(image1);
		chattingTa = new JTextArea("", 100, 80);
        Color color = new Color(245,255,255);
        chattingTa.setBackground(color);
        chattingTa.setEditable(false);
        userlistTa = new JTextArea("", 50, 80);
        color = new Color(255,245,255);
        userlistTa.setBackground(color);
        userlistTa.setEditable(false);
        chattingSp = new JScrollPane(chattingTa);
        userlistSp = new JScrollPane(userlistTa);
		contentPanel.setLayout(null);
		add(bgLabel);
		add(chattingSp);
		add(userlistSp);
		add(chattingTf);
		add(sendBtn);
		add(clearBtn);
		chattingTf.setBounds(0, 400, 400, 100);
		sendBtn.setBounds(298, 500, 100, 30);
		clearBtn.setBounds(188, 500, 100, 30);
		chattingSp.setBounds(0, 0, 400, 400);
		userlistSp.setBounds(400, 253, 195, 280);
		bgLabel.setBounds(400, 0, 205, 253);
		contentPanel.setOpaque(false);
		getContentPane().add(contentPanel);
	}
	private void addListener() {
		sendBtn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
	            String tempmsg = chattingTf.getText().trim();
	            if(tempmsg.length() == 0){
	            	JOptionPane.showMessageDialog(null, "message can not be empty!", "Error",JOptionPane.ERROR_MESSAGE);
	                return;
	            }
	            Message msg = new Message(Message.MESSAGE, tempmsg);
	            ClientLoginGUI.Client.sendMessage(msg);
	            chattingTf.setText("");
			}
		});
		clearBtn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				chattingTa.setText("");
			}
		});
		
	}
    public void ChattingTaDisplay(String msg) {
    	chattingTa.append(msg);
    	chattingTa.setCaretPosition(chattingTa.getText().length() - 1);
    }
    public void UserlistTaDisplay(String msg) {
    	userlistTa.append(msg);
    	userlistTa.setCaretPosition(userlistTa.getText().length() - 1);
    }
    public void UserlistTaClear() {
    	userlistTa.setText("");
    }
}


