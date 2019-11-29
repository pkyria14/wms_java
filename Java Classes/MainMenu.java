

import javax.swing.JFrame;
import java.awt.Color;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;
import java.awt.event.ActionEvent;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.JRadioButton;
import javax.swing.ImageIcon;
import javax.swing.UIManager;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;

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
	private JTextField txtCliendid;
	private JTextField textField_7;
	private JTextField textField_8;
	private JTextField textField_9;
	static SQLprocedure proc = new SQLprocedure ();
	int notify = 0;
	int search = 0;
	private JTextField textField_10;
	
	public MainMenu() {
		setResizable(false);
		
		JLabel lblNoteTypeall = new JLabel("Note: Type \"all\" in SHOW sections to see everything from that category");
		lblNoteTypeall.setBounds(67, 366, 420, 14);
		getContentPane().add(lblNoteTypeall);
		
		getContentPane().setBackground(Color.LIGHT_GRAY);
		setBounds(100, 100, 702, 544);
		getContentPane().setLayout(null);
		JButton btnInsertClient = new JButton("INSERT CLIENT");
		btnInsertClient.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnInsertClient.setForeground(new Color(255, 255, 255));
		btnInsertClient.setBackground(new Color(34, 139, 34));
		btnInsertClient.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		btnInsertClient.setBounds(21, 88, 150, 33);
		getContentPane().add(btnInsertClient);

		JButton btnNewButton = new JButton("UPDATE CLIENT");
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnNewButton.setForeground(new Color(255, 255, 255));
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				String text = textField_1.getText();  //Email,PersonalPhone,ResidentHome,Address
				List<String> input = new ArrayList();
				if (text.length() == 0) JOptionPane.showMessageDialog(null, "No input") ;
				else {
				String opt[] = text.split(">");
				
				if (opt[0].equals("Email") || opt[0].equals("PersonalPhone") || opt[0].equals("ResidentHome") ||opt[0].equals("Address") ) {
					input.add(opt[1]);
					input.add(opt[2]);
					input.add(Authentication.SSN);
					String output = proc.superFunction(input, "ClientUpdate" + opt[0], true);
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Invalid Input");
					else JOptionPane.showMessageDialog(null, "Client Updated");
				}
				else JOptionPane.showMessageDialog(null, "Invalid Input");
				}
				textField_1.setText("Field>CliendID>newValue");
				textField_1.setForeground(Color.GRAY);
			}
		});
		btnNewButton.setBackground(new Color(34, 139, 34));
		btnNewButton.setBounds(21, 164, 150, 33);
		getContentPane().add(btnNewButton);

		JButton btnNewButton_1 = new JButton("DELETE CLIENT");
		btnNewButton_1.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnNewButton_1.setForeground(new Color(255, 255, 255));
		btnNewButton_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField.getText();
				List<String> input = new ArrayList();
				input.add(text);
				input.add(Authentication.SSN);
				String output = proc.superFunction(input, "ClientDelete", true);
				if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Invalid Input");
				else if (output.equals("0")) JOptionPane.showMessageDialog(null, "Error: Client doesnt exist");
				else JOptionPane.showMessageDialog(null, "Client with ID" + input + " Deleted" );
				textField.setText("ClientID");
				textField.setForeground(Color.GRAY);
			}
		});
		btnNewButton_1.setBackground(new Color(34, 139, 34));
		btnNewButton_1.setBounds(21, 240, 150, 33);
		getContentPane().add(btnNewButton_1);

		JLabel lblClient = new JLabel("CLIENT");
		lblClient.setForeground(new Color(0, 0, 0));
		lblClient.setHorizontalAlignment(SwingConstants.CENTER);
		lblClient.setBackground(Color.BLACK);
		lblClient.setFont(new Font("Arial", Font.BOLD, 20));
		lblClient.setBounds(19, 47, 150, 33);
		getContentPane().add(lblClient);

		JLabel lblpallet = new JLabel("PALLET");
		lblpallet.setForeground(new Color(0, 0, 0));
		lblpallet.setHorizontalAlignment(SwingConstants.CENTER);
		lblpallet.setBackground(Color.BLACK);
		lblpallet.setFont(new Font("Arial", Font.BOLD, 20));
		lblpallet.setBounds(198, 47, 150, 33);
		getContentPane().add(lblpallet);

		JLabel lblEmployee = new JLabel("EMPLOYEE");
		lblEmployee.setForeground(new Color(0, 0, 0));
		lblEmployee.setHorizontalAlignment(SwingConstants.CENTER);
		lblEmployee.setBackground(Color.BLACK);
		lblEmployee.setFont(new Font("Arial", Font.BOLD, 20));
		lblEmployee.setBounds(367, 47, 150, 33);
		getContentPane().add(lblEmployee);

		textField = new JTextField();
		textField.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField.getText().equals("ClientID")) textField.setText("");
				textField.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField.getText().equals("")) textField.setText("ClientID");
				textField.setForeground(Color.GRAY);
			}

		});
		textField.setBounds(21, 222, 150, 20);
		getContentPane().add(textField);
		textField.setColumns(10);
		textField.setText("ClientID");
		textField.setForeground(Color.GRAY);
		
		textField_1 = new JTextField();
		textField_1.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_1.getText().equals("Field>CliendID>newValue")) textField_1.setText("");
				textField_1.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_1.getText().equals("")) textField_1.setText("Field>CliendID>newValue");
				textField_1.setForeground(Color.GRAY);
			}
		});
		textField_1.setColumns(10);
		textField_1.setBounds(21, 145, 150, 20);
		getContentPane().add(textField_1);
		textField_1.setText("Field>CliendID>newValue");
		textField_1.setForeground(Color.GRAY);

		JButton btnInsertEmployee = new JButton("INSERT EMPLOYEE");
		btnInsertEmployee.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnInsertEmployee.setForeground(new Color(255, 255, 255));
		btnInsertEmployee.setBackground(new Color(34, 139, 34));
		btnInsertEmployee.setBounds(367, 88, 150, 33);
		getContentPane().add(btnInsertEmployee);

		JButton btnUpdateEmployee = new JButton("UPDATE EMPLOYEE");
		btnUpdateEmployee.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnUpdateEmployee.setForeground(new Color(255, 255, 255));
		btnUpdateEmployee.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_4.getText();  //Email,PersonalPhone,ResidentHome,Address
				List<String> input = new ArrayList();
				if (text.length() == 0) JOptionPane.showMessageDialog(null, "No input") ;
				else {
				String opt[] = text.split(">");
				
				if (opt[0].equals("Email") || opt[0].equals("Position") || opt[0].equals("PhoneNumber") ||opt[0].equals("Salary") 
						||opt[0].equals("Address")||opt[0].equals("isAdmin")) {
					input.add(opt[1]);
					input.add(opt[2]);
					input.add(Authentication.SSN);
					String output = proc.superFunction(input, "EmployeeUpdate" + opt[0], true);
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Invalid Input");
					else JOptionPane.showMessageDialog(null, "Employee Updated");
				}
				else JOptionPane.showMessageDialog(null, "Invalid Input");
				}
				textField_4.setText("Field>EmplID>newValue");
				textField_4.setForeground(Color.GRAY);
			}
		});
		btnUpdateEmployee.setBackground(new Color(34, 139, 34));
		btnUpdateEmployee.setBounds(367, 164, 150, 33);
		getContentPane().add(btnUpdateEmployee);

		textField_4 = new JTextField();
		textField_4.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_4.getText().equals("Field>EmplID>newValue")) textField_4.setText("");
				textField_4.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_4.getText().equals("")) textField_4.setText("Field>EmplID>newValue");
				textField_4.setForeground(Color.GRAY);
			}
		});
		textField_4.setColumns(10);
		textField_4.setBounds(367, 145, 150, 20);
		getContentPane().add(textField_4);
		textField_4.setText("Field>EmplID>newValue");
		textField_4.setForeground(Color.GRAY);
		
		JButton btnDeleteEmployee = new JButton("DELETE EMPLOYEE");
		btnDeleteEmployee.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnDeleteEmployee.setForeground(new Color(255, 255, 255));
		btnDeleteEmployee.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_5.getText();
				List<String> input = new ArrayList();
				input.add(text);
				input.add(Authentication.SSN);
				String output = proc.superFunction(input, "EmployeeDelete", true);
				if (output.equals("0")) JOptionPane.showMessageDialog(null, "Error: Employee doesnt exist ");
				else {
				if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Employee doesnt exist ");
				else JOptionPane.showMessageDialog(null, "Empoyee with ID " + text + " Deleted" );
				}
				textField_5.setText("EmployeeID");
				textField_5.setForeground(Color.GRAY);
			}
		});
		btnDeleteEmployee.setBackground(new Color(34, 139, 34));
		btnDeleteEmployee.setBounds(367, 240, 150, 33);
		getContentPane().add(btnDeleteEmployee);

		textField_5 = new JTextField();
		textField_5.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_5.getText().equals("EmployeeID")) textField_5.setText("");
				textField_5.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_5.getText().equals("")) textField_5.setText("EmployeeID");
				textField_5.setForeground(Color.GRAY);
			}
		});
		textField_5.setColumns(10);
		textField_5.setBounds(367, 222, 150, 20);
		getContentPane().add(textField_5);
		textField_5.setText("EmployeeID");
		textField_5.setForeground(Color.GRAY);

		JButton btnInsertpallet = new JButton("INSERT PALLET");
		btnInsertpallet.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnInsertpallet.setForeground(new Color(255, 255, 255));
		btnInsertpallet.setBackground(new Color(34, 139, 34));
		btnInsertpallet.setBounds(198, 88, 150, 33);
		getContentPane().add(btnInsertpallet);

		JButton button_4 = new JButton("UPDATE PALLET");
		button_4.setFont(new Font("Tahoma", Font.BOLD, 11));
		button_4.setForeground(new Color(255, 255, 255));
		button_4.setBackground(new Color(34, 139, 34));
		button_4.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_2.getText();  //Email,PersonalPhone,ResidentHome,Address
				List<String> input = new ArrayList();
				if (text.length() == 0) JOptionPane.showMessageDialog(null, "No input") ;
				else {
				String opt[] = text.split(">");
				
				if (opt[0].equals("Position") || opt[0].equals("ExportDate") || opt[0].equals("ExtraCost")) {
					input.add(opt[1]);
					input.add(opt[2]);
					input.add(Authentication.SSN);
					String output = proc.superFunction(input, "PalletUpdate" + opt[0], true);
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Invalid Input");
					else JOptionPane.showMessageDialog(null, "Pallet Updated");
				}
				else JOptionPane.showMessageDialog(null, "Invalid Input");
				}
				textField_2.setText("Field>PalletID>newValue");
				textField_2.setForeground(Color.GRAY);

			}
		});
		button_4.setBounds(195, 164, 150, 33);
		getContentPane().add(button_4);

		textField_2 = new JTextField();
		textField_2.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_2.getText().equals("Field>PalletID>newValue")) textField_2.setText("");
				textField_2.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_2.getText().equals("")) textField_2.setText("Field>PalletID>newValue");
				textField_2.setForeground(Color.GRAY);
			}
		});
		textField_2.setColumns(10);
		textField_2.setBounds(195, 145, 150, 20);
		getContentPane().add(textField_2);
		textField_2.setText("Field>PalletID>newValue");
		textField_2.setForeground(Color.GRAY);

		JButton button_5 = new JButton("DELETE PALLET");
		button_5.setFont(new Font("Tahoma", Font.BOLD, 11));
		button_5.setForeground(new Color(255, 255, 255));
		button_5.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_3.getText();
				List<String> input = new ArrayList();
				input.add(text);
				input.add(Authentication.SSN);
				String output = proc.superFunction(input, "PalletDelete", true);
				if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Pallet doesnt exist");
				else JOptionPane.showMessageDialog(null, "Pallet with ID " + text + " Deleted" );
				textField_3.setText("PalletID");
				textField_3.setForeground(Color.GRAY);
			}
		});
		button_5.setBackground(new Color(34, 139, 34));
		button_5.setBounds(195, 240, 150, 33);
		getContentPane().add(button_5);

		textField_3 = new JTextField();
		textField_3.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_3.getText().equals("PalletID")) textField_3.setText("");
				textField_3.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_3.getText().equals("")) textField_3.setText("PalletID");
				textField_3.setForeground(Color.GRAY);
			}
		});
		textField_3.setColumns(10);
		textField_3.setBounds(195, 222, 150, 20);
		getContentPane().add(textField_3);
		textField_3.setText("PalletID");
		textField_3.setForeground(Color.GRAY);
		
		JLabel lblUtilities = new JLabel("UTILITIES");
		lblUtilities.setForeground(new Color(0, 0, 0));
		lblUtilities.setHorizontalAlignment(SwingConstants.CENTER);
		lblUtilities.setBackground(Color.BLACK);
		lblUtilities.setFont(new Font("Arial", Font.BOLD, 20));
		lblUtilities.setBounds(526, 47, 150, 33);
		getContentPane().add(lblUtilities);

		JButton btnNewButton_3 = new JButton("NOTIFY");
		btnNewButton_3.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnNewButton_3.setForeground(new Color(255, 255, 255));
		btnNewButton_3.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				List<String> input = new ArrayList();
				if (notify == 0) JOptionPane.showMessageDialog(null, "Please Select an option");
				else if (notify == 1) {
					String output = proc.superFunction(input, "NotifyFood", false);
					Showinput.showFood(output);
				}
				else if (notify == 2) {
					String output = proc.superFunction(input, "PalletIdle", false);
					Showinput.showIDLE(output);
				}
				else if (notify == 3) {
					String output = proc.superFunction(input, "NotifyFull", true);
					JOptionPane.showMessageDialog(null, "Warehouse has " + output + " free spaces");
				}
			}
		});
		btnNewButton_3.setBackground(new Color(34, 139, 34));
		btnNewButton_3.setBounds(541, 296, 127, 33);
		getContentPane().add(btnNewButton_3);

		JButton btnNewButton_4 = new JButton("SEARCH ITEM");
		btnNewButton_4.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnNewButton_4.setForeground(new Color(255, 255, 255));
		btnNewButton_4.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_10.getText();
				List<String> input = new ArrayList();
				input.add(text);
				if (search == 0) JOptionPane.showMessageDialog(null, "Please Select an option");
				else if (search == 1) {
					String output = proc.superFunction(input, "SearchItemByClient", false);
					if (output.equals("Error"))JOptionPane.showMessageDialog(null, "Pallet doesnt exist");
					else Showinput.showPallet(output);
				}
				else if (search == 2) {
					String output = proc.superFunction(input, "SearchItemByPosition", false);
					if (output.equals("Error"))JOptionPane.showMessageDialog(null, "Pallet doesnt exist");
					else Showinput.showPallet(output);
				}
				textField_10.setText("ClientID/Position");
				textField_10.setForeground(Color.GRAY);
			}
		});
		btnNewButton_4.setBackground(new Color(34, 139, 34));
		btnNewButton_4.setBounds(541, 183, 127, 33);
		getContentPane().add(btnNewButton_4);

		JButton btnLogOut = new JButton("LOG OUT");
		btnLogOut.setForeground(Color.WHITE);
		btnLogOut.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnLogOut.setBackground(new Color(34, 139, 34));
		btnLogOut.setBounds(587, 473, 89, 23);
		getContentPane().add(btnLogOut);
		
		JRadioButton rdbtnNewRadioButton = new JRadioButton("food");
		rdbtnNewRadioButton.setFont(new Font("Tahoma", Font.BOLD, 11));
		rdbtnNewRadioButton.setForeground(Color.WHITE);
		rdbtnNewRadioButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				notify = 1;
			}
		});
		rdbtnNewRadioButton.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton.setBounds(541, 336, 63, 23);
		getContentPane().add(rdbtnNewRadioButton);
		ItemGroup.add(rdbtnNewRadioButton);
		
		JRadioButton rdbtnNewRadioButton_1 = new JRadioButton("full");
		rdbtnNewRadioButton_1.setFont(new Font("Tahoma", Font.BOLD, 11));
		rdbtnNewRadioButton_1.setForeground(Color.WHITE);
		rdbtnNewRadioButton_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				notify = 3;
			}
		});
		rdbtnNewRadioButton_1.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton_1.setBounds(541, 388, 63, 23);
		getContentPane().add(rdbtnNewRadioButton_1);
		ItemGroup.add(rdbtnNewRadioButton_1);
		
		JRadioButton rdbtnNewRadioButton_2 = new JRadioButton("idle");
		rdbtnNewRadioButton_2.setFont(new Font("Tahoma", Font.BOLD, 11));
		rdbtnNewRadioButton_2.setForeground(Color.WHITE);
		rdbtnNewRadioButton_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				notify = 2;
			}
		});
		rdbtnNewRadioButton_2.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton_2.setBounds(541, 362, 63, 23);
		getContentPane().add(rdbtnNewRadioButton_2);
		ItemGroup.add(rdbtnNewRadioButton_2);
		
		JRadioButton rdbtnNewRadioButton_3 = new JRadioButton("client");
		rdbtnNewRadioButton_3.setFont(new Font("Tahoma", Font.BOLD, 11));
		rdbtnNewRadioButton_3.setForeground(Color.WHITE);
		rdbtnNewRadioButton_3.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				search = 1;
			}
		});
		rdbtnNewRadioButton_3.setBackground(Color.LIGHT_GRAY);
		rdbtnNewRadioButton_3.setBounds(541, 221, 72, 23);
		getContentPane().add(rdbtnNewRadioButton_3);
		ClientGroup.add(rdbtnNewRadioButton_3);
		
		JRadioButton rdbtnPosition = new JRadioButton("position");
		rdbtnPosition.setFont(new Font("Tahoma", Font.BOLD, 11));
		rdbtnPosition.setForeground(Color.WHITE);
		rdbtnPosition.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				search = 2;
			}
		});
		rdbtnPosition.setBackground(Color.LIGHT_GRAY);
		rdbtnPosition.setBounds(541, 245, 72, 23);
		getContentPane().add(rdbtnPosition);
		ClientGroup.add(rdbtnPosition);
		
		txtCliendid = new JTextField();
		txtCliendid.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (txtCliendid.getText().equals("ClientID")) txtCliendid.setText("");
				txtCliendid.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (txtCliendid.getText().equals("")) txtCliendid.setText("ClientID");
				txtCliendid.setForeground(Color.GRAY);
			}
		});
		txtCliendid.setColumns(10);
		txtCliendid.setBounds(21, 296, 150, 20);
		getContentPane().add(txtCliendid);
		txtCliendid.setText("ClientID");
		txtCliendid.setForeground(Color.GRAY);
		
		JButton btnShowClient = new JButton("SHOW CLIENT");
		btnShowClient.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnShowClient.setForeground(new Color(255, 255, 255));
		btnShowClient.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = txtCliendid.getText();
				List<String> input = new ArrayList();
				
				if (text.equals("all")) {
					String output = proc.superFunction(input, "printClient", false); 
					Showinput.showClient(output);
				}
				else {
					input.add(text);
					String output = proc.superFunction(input, "ClientShow", false);
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Client doesnt exist ");
					else Showinput.showClient(output);
				}
				txtCliendid.setText("ClientID");
				txtCliendid.setForeground(Color.GRAY);
			}
		});
		btnShowClient.setBackground(new Color(34, 139, 34));
		btnShowClient.setBounds(21, 314, 150, 33);
		getContentPane().add(btnShowClient);
		
		textField_7 = new JTextField();
		textField_7.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_7.getText().equals("PalletID")) textField_7.setText("");
				textField_7.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_7.getText().equals("")) textField_7.setText("PalletID");
				textField_7.setForeground(Color.GRAY);
			}
		});
		textField_7.setColumns(10);
		textField_7.setBounds(198, 296, 150, 20);
		getContentPane().add(textField_7);
		textField_7.setText("PalletID");
		textField_7.setForeground(Color.GRAY);
		
		JButton btnShowPallet = new JButton("SHOW PALLET");
		btnShowPallet.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnShowPallet.setForeground(new Color(255, 255, 255));
		btnShowPallet.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_7.getText();
				List<String> input = new ArrayList();
				
				if (text.equals("all")) {
					String output = proc.superFunction(input, "printPallet", false); 
					Showinput.showPallet(output);
				}
				else {
					input.add(text);
					String output = proc.superFunction(input, "PalletShow", false);
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Pallet doesnt exist ");
					else Showinput.showPallet(output);
				}
				textField_7.setText("PalletID");
				textField_7.setForeground(Color.GRAY);
			}
		});
		btnShowPallet.setBackground(new Color(34, 139, 34));
		btnShowPallet.setBounds(198, 314, 150, 33);
		getContentPane().add(btnShowPallet);
		
		textField_8 = new JTextField();
		textField_8.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_8.getText().equals("EmployeeID")) textField_8.setText("");
				textField_8.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_8.getText().equals("")) textField_8.setText("EmployeeID");
				textField_8.setForeground(Color.GRAY);
			}
		});
		textField_8.setColumns(10);
		textField_8.setBounds(367, 296, 150, 20);
		getContentPane().add(textField_8);
		textField_8.setText("EmployeeID");
		textField_8.setForeground(Color.GRAY);
		
		JButton btnShowEmployee = new JButton("SHOW EMPLOYEE");
		btnShowEmployee.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnShowEmployee.setForeground(new Color(255, 255, 255));
		btnShowEmployee.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_8.getText();
				List<String> input = new ArrayList();
				
				if (text.equals("all")) {
					String output = proc.superFunction(input, "printEmployee", false); 
					Showinput.showEmployee(output);
				}
				else {
					input.add(text);
					String output = proc.superFunction(input, "EmployeeShow", false); 
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Employee doesnt exist ");
					else Showinput.showEmployee(output);
				}
				textField_8.setText("EmployeeID");
				textField_8.setForeground(Color.GRAY);
			}
		});
		btnShowEmployee.setBackground(new Color(34, 139, 34));
		btnShowEmployee.setBounds(367, 314, 150, 33);
		getContentPane().add(btnShowEmployee);
		
		JButton btnClientHistory = new JButton("CLIENT HISTORY");
		btnClientHistory.setFont(new Font("Tahoma", Font.BOLD, 11));
		btnClientHistory.setForeground(new Color(255, 255, 255));
		btnClientHistory.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String text = textField_9.getText();
				List<String> input = new ArrayList();
				input.add(text);
				
				String output = proc.superFunction(input, "ClientHistory", false);
				if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Invalid input");
				else if (output.isEmpty()) ;
				else Showinput.showClientHistory(output);
				textField_9.setText("ClientID");
				textField_9.setForeground(Color.GRAY);
			}
		});
		btnClientHistory.setBackground(new Color(34, 139, 34));
		btnClientHistory.setBounds(541, 106, 127, 33);
		getContentPane().add(btnClientHistory);
		
		textField_9 = new JTextField();
		textField_9.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_9.getText().equals("ClientID")) textField_9.setText("");
				textField_9.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_9.getText().equals("")) textField_9.setText("ClientID");
				textField_9.setForeground(Color.GRAY);
			}
		});
		textField_9.setColumns(10);
		textField_9.setBounds(541, 88, 127, 20);
		getContentPane().add(textField_9);
		textField_9.setText("ClientID");
		textField_9.setForeground(Color.GRAY);
		
		textField_10 = new JTextField();
		textField_10.addFocusListener(new FocusAdapter() {
			@Override
			public void focusGained(FocusEvent e) {
				if (textField_10.getText().equals("ClientID/Position")) textField_10.setText("");
				textField_10.setForeground(Color.BLACK);
			}
			@Override
			public void focusLost(FocusEvent e) {
				if (textField_10.getText().equals("")) textField_10.setText("ClientID/Position");
				textField_10.setForeground(Color.GRAY);
			}
		});
		textField_10.setColumns(10);
		textField_10.setBounds(541, 164, 127, 20);
		getContentPane().add(textField_10);
		textField_10.setText("ClientID/Position");
		textField_10.setForeground(Color.GRAY);
		
		JLabel lblNewLabel = new JLabel("New label");
		lblNewLabel.setIcon(new ImageIcon("images\\cool-background.jpg"));
		lblNewLabel.setBounds(0, 0, 1000, 546);
		getContentPane().add(lblNewLabel);
		

		btnLogOut.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					Authentication.MainMenu.setVisible(false);
					Authentication.frmLogin.setVisible(true);
					
				} catch (Exception e) {;
				}
			}
		});
		
		btnInsertClient.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					
					Authentication.MainMenu.setVisible(false);
					Authentication.InsertClient = new Client();
					Authentication.InsertClient.setVisible(true);
				} catch (Exception e) {;
				}
			}
		});
		
		btnInsertpallet.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					
					Authentication.MainMenu.setVisible(false);
					Authentication.InsertPallet= new Pallet();
					Authentication.InsertPallet.setVisible(true);
				} catch (Exception e) {;
				}
			}

		});
		
		btnInsertEmployee.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					
					Authentication.MainMenu.setVisible(false);
					Authentication.InsertEmployee= new User();
					Authentication.InsertEmployee.setVisible(true);
				} catch (Exception e) {;
				}
			}

		});
	}
}