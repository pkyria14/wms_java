import java.awt.BorderLayout;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.JToggleButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JSplitPane;
import javax.swing.JTable;
import javax.swing.ImageIcon;
public class InsertEmployee extends JFrame {

	private JPanel contentPane;
	
	private static final long serialVersionUID = 1L;
	private JTextField textField;
	private JTextField textField_1;
	private JTextField textField_2;
	private JTextField textField_3;
	private JTextField textField_4;
	private JTextField textField_5;
	private JTextField textField_6;
	private JTextField textField_7;
	private JTextField textField_8;
	private JTextField textField_10;
	private JTextField textField_11;


	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					InsertEmployee frame = new InsertEmployee();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	

	public InsertEmployee() {
		initialize();
	}

	/**
	 * Initialize the contents of the 
	 */
	private void initialize() {
		getContentPane().setBackground(Color.LIGHT_GRAY);
		setBackground(new Color(135, 206, 250));
		setBounds(100, 100, 700, 580);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		getContentPane().setLayout(null);
		
		JLabel lblInsertNewClient = new JLabel("INSERT NEW EMPLOYEE");
		lblInsertNewClient.setFont(new Font("Tahoma", Font.PLAIN, 17));
		lblInsertNewClient.setBackground(new Color(135, 206, 250));
		lblInsertNewClient.setBounds(274, 11, 196, 36);
		getContentPane().add(lblInsertNewClient);
		
		JLabel lblLogo = new JLabel("");
		lblLogo.setIcon(new ImageIcon("U:\\workspace\\3etos\\epl342\\eclipse342\\epl343\\src\\fflogo.PNG"));
		lblLogo.setBounds(456, 187, 131, 131);
		getContentPane().add(lblLogo);
		
		JLabel lblPosition = new JLabel("SSN :");
		lblPosition.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPosition.setBounds(10, 64, 124, 14);
		getContentPane().add(lblPosition);
		
		JLabel lblWarehouseId = new JLabel("ID :");
		lblWarehouseId.setHorizontalAlignment(SwingConstants.RIGHT);
		lblWarehouseId.setBounds(10, 103, 124, 14);
		getContentPane().add(lblWarehouseId);
		
		JLabel lblClientId = new JLabel("NAME :");
		lblClientId.setHorizontalAlignment(SwingConstants.RIGHT);
		lblClientId.setBounds(10, 142, 124, 14);
		getContentPane().add(lblClientId);
		
		JLabel lblExportDate = new JLabel("SURNAME :");
		lblExportDate.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExportDate.setBounds(10, 181, 124, 14);
		getContentPane().add(lblExportDate);
		
		JLabel lblFood = new JLabel("DATE OF BIRTH :");
		lblFood.setHorizontalAlignment(SwingConstants.RIGHT);
		lblFood.setBounds(10, 220, 124, 14);
		getContentPane().add(lblFood);
		
		JLabel lblExpirationDate = new JLabel("EMAIL :");
		lblExpirationDate.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExpirationDate.setBounds(10, 259, 124, 14);
		getContentPane().add(lblExpirationDate);
		
		JLabel lblExtraCost = new JLabel("POSITION :");
		lblExtraCost.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExtraCost.setBounds(0, 298, 124, 14);
		getContentPane().add(lblExtraCost);
		
		JButton btnBack = new JButton("<BACK");
		btnBack.setBounds(10, 11, 89, 23);
		getContentPane().add(btnBack);
		
		btnBack.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					frLogin.MainMenu.setVisible(true);
					frLogin.InsertEmployee.dispose();
				} catch (Exception e) {;
				}
			}
		});
		
		JButton btnSave = new JButton("ADD");
		btnSave.setBounds(585, 507, 89, 23);
		getContentPane().add(btnSave);
		
		JLabel lblPhoneNumber = new JLabel("PHONE NUMBER:");
		lblPhoneNumber.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPhoneNumber.setBounds(10, 337, 124, 14);
		getContentPane().add(lblPhoneNumber);
		
		JLabel lblHomeNumber_1 = new JLabel("HOME NUMBER:");
		lblHomeNumber_1.setHorizontalAlignment(SwingConstants.RIGHT);
		lblHomeNumber_1.setBounds(10, 376, 124, 14);
		getContentPane().add(lblHomeNumber_1);
		
		JLabel lblHomeNumber = new JLabel("ADDRESS :");
		lblHomeNumber.setHorizontalAlignment(SwingConstants.RIGHT);
		lblHomeNumber.setBounds(10, 415, 124, 14);
		getContentPane().add(lblHomeNumber);
		
		JLabel lblAdmin = new JLabel("SALARY :");
		lblAdmin.setHorizontalAlignment(SwingConstants.RIGHT);
		lblAdmin.setBounds(10, 454, 124, 14);
		getContentPane().add(lblAdmin);
		
		JLabel lblAdmin_1 = new JLabel("ADMIN :");
		lblAdmin_1.setHorizontalAlignment(SwingConstants.RIGHT);
		lblAdmin_1.setBounds(10, 493, 124, 14);
		getContentPane().add(lblAdmin_1);
		
		textField = new JTextField();
		textField.setBounds(160, 61, 140, 20);
		getContentPane().add(textField);
		textField.setColumns(10);
		
		textField_1 = new JTextField();
		textField_1.setColumns(10);
		textField_1.setBounds(160, 100, 140, 20);
		getContentPane().add(textField_1);
		
		textField_2 = new JTextField();
		textField_2.setColumns(10);
		textField_2.setBounds(160, 139, 140, 20);
		getContentPane().add(textField_2);
		
		textField_3 = new JTextField();
		textField_3.setColumns(10);
		textField_3.setBounds(160, 253, 140, 20);
		getContentPane().add(textField_3);
		
		textField_4 = new JTextField();
		textField_4.setColumns(10);
		textField_4.setBounds(160, 214, 140, 20);
		getContentPane().add(textField_4);
		
		textField_5 = new JTextField();
		textField_5.setColumns(10);
		textField_5.setBounds(160, 175, 140, 20);
		getContentPane().add(textField_5);
		
		textField_6 = new JTextField();
		textField_6.setColumns(10);
		textField_6.setBounds(160, 376, 140, 20);
		getContentPane().add(textField_6);
		
		textField_7 = new JTextField();
		textField_7.setColumns(10);
		textField_7.setBounds(160, 337, 140, 20);
		getContentPane().add(textField_7);
		
		textField_8 = new JTextField();
		textField_8.setColumns(10);
		textField_8.setBounds(160, 298, 140, 20);
		getContentPane().add(textField_8);
		
		textField_10 = new JTextField();
		textField_10.setColumns(10);
		textField_10.setBounds(160, 448, 140, 20);
		getContentPane().add(textField_10);
		
		textField_11 = new JTextField();
		textField_11.setColumns(10);
		textField_11.setBounds(160, 409, 280, 20);
		getContentPane().add(textField_11);
		
		JCheckBox checkBox = new JCheckBox("");
		checkBox.setBounds(160, 489, 21, 23);
		getContentPane().add(checkBox);
		
		btnSave.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					// SAVE TO DATABASE
				} catch (Exception e) {;
				}
			}
		});
	}
}