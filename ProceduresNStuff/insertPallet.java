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

public class insertPallet extends JFrame {

	
	private static final long serialVersionUID = 1L;
	
	private JTextField textField;
	private JTextField textField_1;
	private JTextField textField_3;
	private JTextField textField_4;
	private JTextField textField_5;
	private JTextField textField_6;
	private JTextField textField_2;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					insertPallet frame = new insertPallet();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public insertPallet() {
		initialize();
	}

	/**
	 * Initialize the contents of the 
	 */
	private void initialize() {
		getContentPane().setBackground(Color.LIGHT_GRAY);
		setBackground(new Color(135, 206, 250));
		setBounds(100, 100, 700, 508);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		getContentPane().setLayout(null);
		
		JLabel lblInsertNewClient = new JLabel("INSERT NEW PALLET");
		lblInsertNewClient.setFont(new Font("Tahoma", Font.PLAIN, 17));
		lblInsertNewClient.setBackground(new Color(135, 206, 250));
		lblInsertNewClient.setBounds(254, 11, 196, 36);
		getContentPane().add(lblInsertNewClient);
		
		JLabel lblLogo = new JLabel("");
		lblLogo.setIcon(new ImageIcon("U:\\workspace\\3etos\\epl342\\eclipse342\\epl343\\src\\fflogo.PNG"));
		lblLogo.setBounds(466, 168, 146, 118);
		getContentPane().add(lblLogo);
		
		JLabel lblPosition = new JLabel("POSITION :");
		lblPosition.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPosition.setBounds(10, 89, 124, 14);
		getContentPane().add(lblPosition);
		
		JLabel lblWarehouseId = new JLabel("WAREHOUSE ID :");
		lblWarehouseId.setHorizontalAlignment(SwingConstants.RIGHT);
		lblWarehouseId.setBounds(10, 136, 124, 14);
		getContentPane().add(lblWarehouseId);
		
		JLabel lblClientId = new JLabel("CLIENT ID :");
		lblClientId.setHorizontalAlignment(SwingConstants.RIGHT);
		lblClientId.setBounds(10, 183, 124, 14);
		getContentPane().add(lblClientId);
		
		JLabel lblExportDate = new JLabel("EXPORT DATE :");
		lblExportDate.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExportDate.setBounds(10, 230, 124, 14);
		getContentPane().add(lblExportDate);
		
		JLabel lblFood = new JLabel("FOOD :");
		lblFood.setHorizontalAlignment(SwingConstants.RIGHT);
		lblFood.setBounds(10, 277, 124, 14);
		getContentPane().add(lblFood);
		
		JLabel lblExpirationDate = new JLabel("EXPIRATION DATE :");
		lblExpirationDate.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExpirationDate.setBounds(10, 324, 124, 14);
		getContentPane().add(lblExpirationDate);
		
		JLabel lblExtraCost = new JLabel("EXTRA COST :");
		lblExtraCost.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExtraCost.setBounds(10, 371, 124, 14);
		getContentPane().add(lblExtraCost);
		
		textField = new JTextField();
		textField.setColumns(10);
		textField.setBounds(154, 368, 340, 20);
		getContentPane().add(textField);
		
		textField_1 = new JTextField();
		textField_1.setColumns(10);
		textField_1.setBounds(154, 321, 170, 20);
		getContentPane().add(textField_1);
		
		textField_3 = new JTextField();
		textField_3.setColumns(10);
		textField_3.setBounds(154, 227, 170, 20);
		getContentPane().add(textField_3);
		
		textField_4 = new JTextField();
		textField_4.setColumns(10);
		textField_4.setBounds(154, 180, 170, 20);
		getContentPane().add(textField_4);
		
		textField_5 = new JTextField();
		textField_5.setColumns(10);
		textField_5.setBounds(154, 133, 170, 20);
		getContentPane().add(textField_5);
		
		textField_6 = new JTextField();
		textField_6.setColumns(10);
		textField_6.setBounds(154, 86, 85, 20);
		getContentPane().add(textField_6);
		
		JButton btnBack = new JButton("<BACK");
		btnBack.setBounds(10, 11, 89, 23);
		getContentPane().add(btnBack);
		
		btnBack.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					frLogin.MainMenu.setVisible(true);
					frLogin.InsertPallet.dispose();
				} catch (Exception e) {;
				}
			}
		});
		
		JButton btnSave = new JButton("ADD");
		btnSave.setBounds(585, 435, 89, 23);
		getContentPane().add(btnSave);
		
		JCheckBox chckbxYes = new JCheckBox("");
		chckbxYes.setBounds(154, 272, 26, 23);
		getContentPane().add(chckbxYes);
		
		JLabel label = new JLabel("BASIC COST :");
		label.setHorizontalAlignment(SwingConstants.RIGHT);
		label.setBounds(10, 418, 124, 14);
		getContentPane().add(label);
		
		textField_2 = new JTextField();
		textField_2.setColumns(10);
		textField_2.setBounds(154, 415, 170, 20);
		getContentPane().add(textField_2);
		
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