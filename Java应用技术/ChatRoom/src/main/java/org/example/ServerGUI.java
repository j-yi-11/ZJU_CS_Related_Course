package org.example;
import java.awt.Color;
import java.awt.Image;
import java.awt.Toolkit;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
@SuppressWarnings("serial")
public class ServerGUI extends JFrame {
	private JPanel contentPanel = new JPanel();
	private JTextArea monitorTa;
	private JScrollPane monitorSp;
	public ServerGUI() {
		this.init();
	}
	@SuppressWarnings("deprecation")
	private void init() {
		String port;
		int portnum = 0;
		boolean port_valid = false;
		do {
			port_valid = true;
			port = JOptionPane.showInputDialog(this,"Input port to listen to:","Server",JOptionPane.PLAIN_MESSAGE);
	        try {
	        	portnum = Integer.parseInt(port);
				if(portnum<1 || portnum>65536){
					throw new RuntimeException("port ERROR:"+portnum);
				}
	        }
	        catch(Exception e) {
	        	JOptionPane.showMessageDialog(null, "port need to between 1 and 65536", "Error",JOptionPane.ERROR_MESSAGE);
	        	port_valid = false;
	        }
		} while(port_valid==false);
		this.setTitle("Server UI");
		this.setSize(610, 570);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
        Toolkit kit =Toolkit.getDefaultToolkit();
        Image image2 =kit.createImage("images/JYlogo.jpeg");
        setIconImage(image2);
		monitorTa = new JTextArea("", 500, 80);
        Color color = new Color(255,255,245);
        monitorTa.setBackground(color);
        monitorTa.setEditable(false);
        monitorSp = new JScrollPane(monitorTa);
		contentPanel.setLayout(null);
		add(monitorSp);
		monitorSp.setBounds(0, 0, 597, 535);
		contentPanel.setOpaque(false);
		getContentPane().add(contentPanel);
		ServerSocket sersoc = new ServerSocket(portnum, this);
		sersoc.listen();
	}
    public void MonitorTaDisplay(String msg) {
    	monitorTa.append(msg);
    	monitorTa.setCaretPosition(monitorTa.getText().length() - 1);
    }
}


