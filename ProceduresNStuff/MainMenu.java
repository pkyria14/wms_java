import javax.swing.JFrame;
import java.awt.Color;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JTextField;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.JRadioButton;

public class MainMenu extends JFrame {

	
	private static final long serialVersionUID = 1L;
	private JTextField textField;
	private JTextField textField_1;
	private JTextField textField_4;
	private JTextField textField_5;
	private JTextField textField_2;
	private JTextField textField_3;

	private final ButtonGroup ItemGroup = new ButtonGroup();
	private final ButtonGroup ClientGroup = new ButtonGroup();
	
	public MainMenu() {
		
		getContentPane().setBackground(Color.LIGHT_GRAY);
		setBounds(100, 100, 720, 546);

		getContentPane().setLayout(null);

		JButton btnInsertClient = new JButton("INSERT CLIENT");
		btnInsertClient.setBackground(new Color(220, 220, 220));
		btnInsertClient.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		btnInsertClient.setBounds(21, 88, 150, 33);
		getContentPane().add(btnInsertClient);

		JButton btnNewButton = new JButton("UPDATE CLIENT");
		btnNewButton.setBackground(new Color(220, 220, 220));
		btnNewButton.setBounds(21, 164, 150, 33);
		getContentPane().add(btnNewButton);

		JButton btnNewButton_1 = new JButton("DELETE CLIENT");
		btnNewButton_1.setBackground(new Color(220, 220, 220));
		btnNewButton_1.setBounds(21, 240, 150, 33);
		getContentPane().add(btnNewButton_1);

		JLabel lblClient = new JLabel("CLIENT");
		lblClient.setHorizontalAlignment(SwingConstants.CENTER);
		lblClient.setBackground(Color.BLACK);
		lblClient.setFont(new Font("Arial", Font.PLAIN, 17));
		lblClient.setBounds(19, 47, 150, 33);
		getContentPane().add(lblClient);

		JLabel lblpallet = new JLabel("PALLET");
		lblpallet.setHorizontalAlignment(SwingConstants.CENTER);
		lblpallet.setBackground(Color.BLACK);
		lblpallet.setFont(new Font("Arial", Font.PLAIN, 17));
		lblpallet.setBounds(198, 47, 150, 33);
		getContentPane().add(lblpallet);

		JLabel lblEmployee = new JLabel("EMPLOYEE");
		lblEmployee.setHorizontalAlignment(SwingConstants.CENTER);
		lblEmployee.setBackground(Color.BLACK);
		lblEmployee.setFont(new Font("Arial", Font.PLAIN, 17));
		lblEmployee.setBounds(367, 47, 150, 33);
		getContentPane().add(lblEmployee);

		textField = new JTextField();
		textField.setBounds(21, 222, 150, 20);
		getContentPane().add(textField);
		textField.setColumns(10);

		textField_1 = new JTextField();
		textField_1.setColumns(10);
		textField_1.setBounds(21, 145, 150, 20);
		getContentPane().add(textField_1);

		JButton btnInsertEmployee = new JButton("INSERT EMPLOYEE");
		btnInsertEmployee.setBackground(new Color(220, 220, 220));
		btnInsertEmployee.setBounds(367, 88, 150, 33);
		getContentPane().add(btnInsertEmployee);

		JButton btnUpdateEmployee = new JButton("UPDATE EMPLOYEE");
		btnUpdateEmployee.setBackground(new Color(220, 220, 220));
		btnUpdateEmployee.setBounds(367, 164, 150, 33);
		getContentPane().add(btnUpdateEmployee);

		textField_4 = new JTextField();
		textField_4.setColumns(10);
		textField_4.setBounds(367, 145, 150, 20);
		getContentPane().add(textField_4);

		JButton btnDeleteEmployee = new JButton("DELETE EMPLOYEE");
		btnDeleteEmployee.setBackground(new Color(220, 220, 220));
		btnDeleteEmployee.setBounds(367, 240, 150, 33);
		getContentPane().add(btnDeleteEmployee);

		textField_5 = new JTextField();
		textField_5.setColumns(10);
		textField_5.setBounds(367, 222, 150, 20);
		getContentPane().add(textField_5);

		JButton btnInsertpallet = new JButton("INSERT PALLET");
		btnInsertpallet.setBackground(new Color(220, 220, 220));
		btnInsertpallet.setBounds(198, 88, 150, 33);
		getContentPane().add(btnInsertpallet);

		JButton button_4 = new JButton("UPDATE PALLET");
		button_4.setBackground(new Color(220, 220, 220));
		button_4.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		button_4.setBounds(195, 164, 150, 33);
		getContentPane().add(button_4);

		textField_2 = new JTextField();
		textField_2.setColumns(10);
		textField_2.setBounds(195, 145, 150, 20);
		getContentPane().add(textField_2);

		JButton button_5 = new JButton("DELETE PALLET");
		button_5.setBackground(new Color(220, 220, 220));
		button_5.setBounds(195, 240, 150, 33);
		getContentPane().add(button_5);

		textField_3 = new JTextField();
		textField_3.setColumns(10);
		textField_3.setBounds(195, 222, 150, 20);
		getContentPane().add(textField_3);

		JLabel lblUtilities = new JLabel("UTILITIES");
		lblUtilities.setHorizontalAlignment(SwingConstants.CENTER);
		lblUtilities.setBackground(Color.BLACK);
		lblUtilities.setFont(new Font("Arial", Font.PLAIN, 17));
		lblUtilities.setBounds(526, 47, 150, 33);
		getContentPane().add(lblUtilities);

		JButton btnNewButton_2 = new JButton("CLIENT HISTORY");
		btnNewButton_2.setBackground(new Color(220, 220, 220));
		btnNewButton_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		btnNewButton_2.setBounds(541, 88, 133, 33);
		getContentPane().add(btnNewButton_2);

		JButton btnNewButton_3 = new JButton("NOTIFY IDLE");
		btnNewButton_3.setBackground(new Color(220, 220, 220));
		btnNewButton_3.setBounds(541, 296, 127, 33);
		getContentPane().add(btnNewButton_3);

		JButton btnNewButton_4 = new JButton("SEARCH ITEM");
		btnNewButton_4.setBackground(new Color(220, 220, 220));
		btnNewButton_4.setBounds(541, 139, 127, 33);
		getContentPane().add(btnNewButton_4);

		JButton btnLogOut = new JButton("LOG OUT");
		btnLogOut.setBackground(Color.LIGHT_GRAY);
		btnLogOut.setBounds(587, 473, 89, 23);
		getContentPane().add(btnLogOut);
		
		JRadioButton rdbtnNewRadioButton = new JRadioButton("food");
		rdbtnNewRadioButton.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton.setBounds(541, 336, 63, 23);
		getContentPane().add(rdbtnNewRadioButton);
		ItemGroup.add(rdbtnNewRadioButton);
		
		JRadioButton rdbtnNewRadioButton_1 = new JRadioButton("full");
		rdbtnNewRadioButton_1.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton_1.setBounds(541, 388, 63, 23);
		getContentPane().add(rdbtnNewRadioButton_1);
		ItemGroup.add(rdbtnNewRadioButton_1);
		
		JRadioButton rdbtnNewRadioButton_2 = new JRadioButton("idle");
		rdbtnNewRadioButton_2.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton_2.setBounds(541, 362, 63, 23);
		getContentPane().add(rdbtnNewRadioButton_2);
		ItemGroup.add(rdbtnNewRadioButton_2);
		
		JRadioButton rdbtnNewRadioButton_3 = new JRadioButton("client");
		rdbtnNewRadioButton_3.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton_3.setBounds(541, 179, 72, 23);
		getContentPane().add(rdbtnNewRadioButton_3);
		ClientGroup.add(rdbtnNewRadioButton_3);
		
		JRadioButton rdbtnPallet = new JRadioButton("pallet");
		rdbtnPallet.setBackground(Color.LIGHT_GRAY);
		rdbtnPallet.setBounds(541, 205, 72, 23);
		getContentPane().add(rdbtnPallet);
		ClientGroup.add(rdbtnPallet);
		
		JRadioButton rdbtnPosition = new JRadioButton("position");
		rdbtnPosition.setBackground(Color.LIGHT_GRAY);
		rdbtnPosition.setBounds(541, 231, 72, 23);
		getContentPane().add(rdbtnPosition);
		ClientGroup.add(rdbtnPosition);
		
		JButton btnShowClients_1 = new JButton("SHOW CLIENTS");
		btnShowClients_1.setBackground(new Color(220, 220, 220));
		btnShowClients_1.setBounds(21, 296, 150, 33);
		getContentPane().add(btnShowClients_1);
		
		JButton btnShowPalette = new JButton("SHOW PALETTE");
		btnShowPalette.setBackground(new Color(220, 220, 220));
		btnShowPalette.setBounds(198, 296, 150, 33);
		getContentPane().add(btnShowPalette);
		

		btnLogOut.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					frLogin.MainMenu.setVisible(false);
					frLogin.frmLogin.setVisible(true);
					
				} catch (Exception e) {;
				}
			}
		});
		
		btnInsertClient.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					
					frLogin.MainMenu.setVisible(false);
					frLogin.InsertClient = new InsertClient();
					frLogin.InsertClient.setVisible(true);
				} catch (Exception e) {;
				}
			}
		});
		
		btnInsertpallet.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					
					frLogin.MainMenu.setVisible(false);
					frLogin.InsertPallet= new insertPallet();
					frLogin.InsertPallet.setVisible(true);
				} catch (Exception e) {;
				}
			}

		});
		
		btnInsertEmployee.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					
					frLogin.MainMenu.setVisible(false);
					frLogin.InsertEmployee= new InsertEmployee();
					frLogin.InsertEmployee.setVisible(true);
				} catch (Exception e) {;
				}
			}

		});
	}
}
