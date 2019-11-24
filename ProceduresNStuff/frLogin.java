import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JTextField;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.Color;
import javax.swing.JButton;
import javax.swing.JPasswordField;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class frLogin {

	static JFrame frmLogin;
	static JFrame MainMenu;
	static JFrame InsertClient;
	static JFrame InsertPallet;
	static JFrame InsertEmployee;
	private JLabel lblNewLabel_3;
	private JTextField textField;
	private JPasswordField passwordField;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					frLogin window = new frLogin();
					frLogin.frmLogin.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public frLogin() {
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
		frmLogin.setBounds(100, 100, 592, 400);
		frmLogin.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmLogin.getContentPane().setLayout(null);
		
		textField = new JTextField();
		textField.setBounds(218, 126, 197, 20);
		frmLogin.getContentPane().add(textField);
		textField.setColumns(10);
		
		JLabel lblWelcomePleaseEnter = new JLabel("Photos Forwarding");
		lblWelcomePleaseEnter.setForeground(new Color(0, 0, 0));
		lblWelcomePleaseEnter.setBackground(SystemColor.textHighlight);
		lblWelcomePleaseEnter.setFont(new Font("AGENCY FB", Font.PLAIN, 34));
		lblWelcomePleaseEnter.setBounds(200, 33, 566, 55);
		frmLogin.getContentPane().add(lblWelcomePleaseEnter);
		
		JLabel lblNewLabel = new JLabel("Username:");
		lblNewLabel.setFont(new Font("Tahoma", Font.PLAIN, 15));
		lblNewLabel.setBounds(132, 127, 99, 14);
		frmLogin.getContentPane().add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("Password:");
		lblNewLabel_1.setFont(new Font("Tahoma", Font.PLAIN, 15));
		lblNewLabel_1.setBounds(132, 169, 79, 17);
		frmLogin.getContentPane().add(lblNewLabel_1);
			
		JButton btnNewButton = new JButton("LOGIN");
		btnNewButton.setForeground(new Color(25, 25, 0));
		btnNewButton.setBackground(Color.WHITE);
		btnNewButton.setFont(new Font("AGENCY FB", Font.PLAIN, 22));
		btnNewButton.setBounds(233, 248, 104, 48);
		
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
				String username = textField.getText();
				char[] password = passwordField.getPassword();
				
				boolean valid = true;
				//if ((position == 0) || (position > 3) || !valid) lblNewLabel_3.setText("LOGIN NOT SUCCESFUL");
				//else if (position == 1 && valid) {frmLogin.dispose();frame2 = new MainMenu();frame2.setVisible(true) ;}
				{frmLogin.dispose();MainMenu = new MainMenu();MainMenu.setVisible(true) ;}
				}
				catch(Exception e) { ;}
			}
		});
		
		frmLogin.getContentPane().add(btnNewButton);
		
		passwordField = new JPasswordField();
		passwordField.setBounds(218, 169, 197, 20);
		frmLogin.getContentPane().add(passwordField);
		
		lblNewLabel_3 = new JLabel("");
		lblNewLabel_3.setFont(new Font("Tahoma", Font.PLAIN, 13));
		lblNewLabel_3.setBackground(new Color(135, 206, 250));
		lblNewLabel_3.setBounds(425, 126, 151, 73);
		frmLogin.getContentPane().add(lblNewLabel_3);
	}
}
