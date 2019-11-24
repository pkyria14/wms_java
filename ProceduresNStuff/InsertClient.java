
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import java.awt.Color;
import java.awt.Font;
import javax.swing.SwingConstants;

public class InsertClient extends JFrame {

	private static final long serialVersionUID = 1L;
	private JTextField textField;
	private JTextField textField_1;
	private JTextField textField_2;
	private JTextField textField_3;
	private JTextField textField_4;
	private JTextField textField_5;
	private JTextField textField_6;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {

		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					InsertClient window = new InsertClient();
					window.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public InsertClient() {
		initialize();
	}

	/**
	 * Initialize the contents of the
	 */
	private void initialize() {
		getContentPane().setBackground(Color.LIGHT_GRAY);
		setBackground(new Color(135, 206, 250));
		setBounds(100, 100, 700, 450);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		getContentPane().setLayout(null);

		JLabel lblInsertNewClient = new JLabel("INSERT NEW CLIENT");
		lblInsertNewClient.setFont(new Font("Tahoma", Font.PLAIN, 17));
		lblInsertNewClient.setBackground(new Color(135, 206, 250));
		lblInsertNewClient.setBounds(274, 11, 164, 36);
		getContentPane().add(lblInsertNewClient);
		
		//---
		Icon logoImage = new ImageIcon("fflogo.PNG");
	   JLabel lblIcon = new JLabel(logoImage);
		
		

		//----

	   JLabel lblLogooooo = new JLabel("");
	   lblLogooooo.setIcon(new ImageIcon("U:\\workspace\\3etos\\epl342\\eclipse342\\epl343\\src\\fflogo.PNG"));
		lblLogooooo.setBounds(459, 118, 146, 155);
		getContentPane().add(lblLogooooo);
	   
		JLabel labelID = new JLabel("ID :");
		labelID.setHorizontalAlignment(SwingConstants.RIGHT);
		labelID.setBounds(10, 65, 124, 14);
		getContentPane().add(labelID);

		JLabel label_1 = new JLabel("NAME :");
		label_1.setHorizontalAlignment(SwingConstants.RIGHT);
		label_1.setBounds(10, 118, 124, 14);
		getContentPane().add(label_1);

		JLabel label_2 = new JLabel("SURNAME :");
		label_2.setHorizontalAlignment(SwingConstants.RIGHT);
		label_2.setBounds(10, 171, 124, 14);
		getContentPane().add(label_2);

		JLabel label_3 = new JLabel("DATE OF BIRTH :");
		label_3.setHorizontalAlignment(SwingConstants.RIGHT);
		label_3.setBounds(10, 224, 124, 14);
		getContentPane().add(label_3);

		JLabel label_4 = new JLabel("PHONE NUMBER :");
		label_4.setHorizontalAlignment(SwingConstants.RIGHT);
		label_4.setBounds(10, 277, 124, 14);
		getContentPane().add(label_4);

		JLabel label_5 = new JLabel("HOME NUMBER :");
		label_5.setHorizontalAlignment(SwingConstants.RIGHT);
		label_5.setBounds(10, 330, 124, 14);
		getContentPane().add(label_5);

		JLabel label_6 = new JLabel("ADDRESS :");
		label_6.setHorizontalAlignment(SwingConstants.RIGHT);
		label_6.setBounds(10, 383, 124, 14);
		getContentPane().add(label_6);

		textField = new JTextField();
		textField.setColumns(10);
		textField.setBounds(154, 380, 340, 20);
		getContentPane().add(textField);

		textField_1 = new JTextField();
		textField_1.setColumns(10);
		textField_1.setBounds(154, 327, 170, 20);
		getContentPane().add(textField_1);

		textField_2 = new JTextField();
		textField_2.setColumns(10);
		textField_2.setBounds(154, 274, 170, 20);
		getContentPane().add(textField_2);

		textField_3 = new JTextField();
		textField_3.setColumns(10);
		textField_3.setBounds(154, 221, 170, 20);
		getContentPane().add(textField_3);

		textField_4 = new JTextField();
		textField_4.setColumns(10);
		textField_4.setBounds(154, 168, 170, 20);
		getContentPane().add(textField_4);

		textField_5 = new JTextField();
		textField_5.setColumns(10);
		textField_5.setBounds(154, 115, 170, 20);
		getContentPane().add(textField_5);

		textField_6 = new JTextField();
		textField_6.setColumns(10);
		textField_6.setBounds(154, 62, 85, 20);
		getContentPane().add(textField_6);

		JButton btnBack = new JButton("<BACK");
		btnBack.setBounds(10, 11, 89, 23);
		getContentPane().add(btnBack);

		btnBack.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					frLogin.MainMenu.setVisible(true);
					frLogin.InsertClient.dispose();
				} catch (Exception e) {
					;
				}
			}
		});

		JButton btnSave = new JButton("ADD");
		btnSave.setBounds(585, 379, 89, 23);
		getContentPane().add(btnSave);
		
		btnSave.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					// SAVE TO DATABASE
				} catch (Exception e) {
					;
				}
			}
		});
	}
}