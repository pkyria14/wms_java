

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import java.awt.SystemColor;
import java.awt.Color;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JPasswordField;

import java.awt.event.ActionListener;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.awt.event.ActionEvent;



public class Authentication {

	static JFrame frmLogin;
	static JFrame MainMenu;
	static JFrame InsertClient;
	static JFrame InsertPallet;
	static JFrame InsertEmployee;
	private JLabel lblNewLabel_3;
	private JTextField textField;
	private JPasswordField passwordField;
	static SQLprocedure proc = new SQLprocedure ();
	 static String SSN ;
	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Connection conn= proc.getDBConnection();
					Authentication window = new Authentication();
					Authentication.frmLogin.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public Authentication() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frmLogin = new JFrame();
		frmLogin.setResizable(false);
		frmLogin.setTitle("Login");
		frmLogin.getContentPane().setBackground(new Color(135, 206, 250));
		frmLogin.setBounds(100, 150, 630, 400);
		frmLogin.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		frmLogin.getContentPane().setLayout(null);
		textField = new JTextField();
		textField.setBounds(218, 180, 197, 20);
		frmLogin.getContentPane().add(textField);
		textField.setColumns(10);
		
		JLabel lblWelcomePleaseEnter = new JLabel("Photos Forwarding");
		lblWelcomePleaseEnter.setIcon(new ImageIcon("images\\Capture.png"));
		lblWelcomePleaseEnter.setBounds(10, 0, 600, 150);
		frmLogin.getContentPane().add(lblWelcomePleaseEnter);
		
		JLabel lblNewLabel = new JLabel("Username:");
		lblNewLabel.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel.setBounds(132, 180, 99, 14);
		lblNewLabel.setForeground(Color.BLACK);
		frmLogin.getContentPane().add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("Password:");
		lblNewLabel_1.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel_1.setBounds(132, 220, 79, 17);
		lblNewLabel_1.setForeground(Color.BLACK);
		frmLogin.getContentPane().add(lblNewLabel_1);
			
		JButton btnNewButton = new JButton("LOGIN");
		btnNewButton.setForeground(new Color(25, 25, 0));
		btnNewButton.setBackground(Color.WHITE);
		btnNewButton.setFont(new Font("AGENCY FB", Font.PLAIN, 22));
		btnNewButton.setBounds(260, 260, 104, 48);
		
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					String username = textField.getText();
					String password = passwordField.getText();
					List<String> input = new ArrayList();
					input.add(username);
					input.add(password);
					String output = proc.superFunction(input, "Auth", true);
					if (output.equals("0") || output.equals("Error")) {
						JOptionPane.showMessageDialog(null, "Invalid Username or Password");
					}
					else {
						frmLogin.dispose();
						MainMenu = new MainMenu();
						MainMenu.setVisible(true) ;
					}
				}
				catch(Exception e) { ;}
			}
		});
		
		frmLogin.getContentPane().add(btnNewButton);
		
		passwordField = new JPasswordField();
		passwordField.setBounds(218, 220, 197, 20);
		frmLogin.getContentPane().add(passwordField);
		
		lblNewLabel_3 = new JLabel("");
		lblNewLabel_3.setFont(new Font("Tahoma", Font.PLAIN, 13));
		lblNewLabel_3.setBackground(new Color(135, 206, 250));
		lblNewLabel_3.setBounds(425, 126, 151, 73);
		frmLogin.getContentPane().add(lblNewLabel_3);
		
		JLabel lblNewLabel2 = new JLabel("New label");
		lblNewLabel2.setIcon(new ImageIcon("images\\cool-background.jpg"));
		lblNewLabel2.setBounds(0, 0, 1000, 500);
		frmLogin.getContentPane().add(lblNewLabel2);
	}
}

