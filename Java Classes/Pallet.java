

import java.awt.Color;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.JToggleButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JSplitPane;
import javax.swing.JTable;
import javax.swing.ImageIcon;

public class Pallet extends JFrame {

	
	private static final long serialVersionUID = 1L;
	
	private JTextField extra;
	private JTextField expi;
	private JTextField eDate;
	private JTextField cID;
	private JTextField wID;
	private JTextField position;
	private JTextField basic;
	static SQLprocedure proc = new SQLprocedure ();
	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Pallet frame = new Pallet();
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
	public Pallet() {
		setResizable(false);
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
		lblInsertNewClient.setForeground(new Color(0, 0, 0));
		lblInsertNewClient.setFont(new Font("Tahoma", Font.BOLD, 20));
		lblInsertNewClient.setBackground(new Color(135, 206, 250));
		lblInsertNewClient.setBounds(254, 11, 240, 36);
		getContentPane().add(lblInsertNewClient);
		
	
		
		JLabel lblPosition = new JLabel("POSITION :");
		lblPosition.setForeground(new Color(34, 139, 34));
		lblPosition.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblPosition.setHorizontalAlignment(SwingConstants.RIGHT);
		lblPosition.setBounds(33, 68, 124, 14);
		getContentPane().add(lblPosition);
		
		JLabel lblWarehouseId = new JLabel("WAREHOUSE ID :");
		lblWarehouseId.setForeground(new Color(0, 128, 0));
		lblWarehouseId.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblWarehouseId.setHorizontalAlignment(SwingConstants.RIGHT);
		lblWarehouseId.setBounds(33, 115, 124, 14);
		getContentPane().add(lblWarehouseId);
		
		JLabel lblClientId = new JLabel("CLIENT ID :");
		lblClientId.setForeground(new Color(34, 139, 34));
		lblClientId.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblClientId.setHorizontalAlignment(SwingConstants.RIGHT);
		lblClientId.setBounds(33, 162, 124, 14);
		getContentPane().add(lblClientId);
		
		JLabel lblExportDate = new JLabel("EXPORT DATE :");
		lblExportDate.setForeground(new Color(34, 139, 34));
		lblExportDate.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblExportDate.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExportDate.setBounds(33, 209, 124, 14);
		getContentPane().add(lblExportDate);
		
		JLabel lblFood = new JLabel("FOOD :");
		lblFood.setForeground(new Color(34, 139, 34));
		lblFood.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblFood.setHorizontalAlignment(SwingConstants.RIGHT);
		lblFood.setBounds(33, 256, 124, 14);
		getContentPane().add(lblFood);
		
		JLabel lblExpirationDate = new JLabel("EXPIRATION DATE :");
		lblExpirationDate.setForeground(new Color(34, 139, 34));
		lblExpirationDate.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblExpirationDate.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExpirationDate.setBounds(33, 303, 124, 14);
		getContentPane().add(lblExpirationDate);
		
		JLabel lblExtraCost = new JLabel("EXTRA COST :");
		lblExtraCost.setForeground(new Color(34, 139, 34));
		lblExtraCost.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblExtraCost.setHorizontalAlignment(SwingConstants.RIGHT);
		lblExtraCost.setBounds(33, 350, 124, 14);
		getContentPane().add(lblExtraCost);
		
		extra = new JTextField();
		extra.setColumns(10);
		extra.setBounds(177, 347, 340, 20);
		getContentPane().add(extra);
		
		expi = new JTextField();
		expi.setColumns(10);
		expi.setBounds(177, 300, 170, 20);
		getContentPane().add(expi);
		
		eDate = new JTextField();
		eDate.setColumns(10);
		eDate.setBounds(177, 206, 170, 20);
		getContentPane().add(eDate);
		
		cID = new JTextField();
		cID.setColumns(10);
		cID.setBounds(177, 159, 170, 20);
		getContentPane().add(cID);
		
		wID = new JTextField();
		wID.setColumns(10);
		wID.setBounds(177, 112, 170, 20);
		getContentPane().add(wID);
		
		position = new JTextField();
		position.setColumns(10);
		position.setBounds(177, 65, 85, 20);
		getContentPane().add(position);
		
		JButton btnBack = new JButton("<BACK");
		btnBack.setBackground(new Color(34, 139, 34));
		btnBack.setForeground(Color.WHITE);
		btnBack.setBounds(10, 11, 89, 23);
		getContentPane().add(btnBack);
		
		btnBack.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					Authentication.MainMenu.setVisible(true);
					Authentication.InsertPallet.dispose();
				} catch (Exception e) {;
				}
			}
		});
		
		JButton btnSave = new JButton("ADD");
		btnSave.setBackground(new Color(34, 139, 34));
		btnSave.setForeground(Color.WHITE);
		btnSave.setBounds(585, 435, 89, 23);
		getContentPane().add(btnSave);
		
		JCheckBox food = new JCheckBox("");
		food.setBackground(new Color(192, 192, 192));
		food.setBounds(177, 251, 26, 23);
		getContentPane().add(food);
		
		JLabel label = new JLabel("BASIC COST :");
		label.setForeground(new Color(34, 139, 34));
		label.setFont(new Font("Tahoma", Font.BOLD, 12));
		label.setHorizontalAlignment(SwingConstants.RIGHT);
		label.setBounds(33, 397, 124, 14);
		getContentPane().add(label);
		
		basic = new JTextField();
		basic.setColumns(10);
		basic.setBounds(177, 394, 170, 20);
		getContentPane().add(basic);
		
		JLabel lblNewLabel = new JLabel("New label");
		lblNewLabel.setForeground(new Color(34, 139, 34));
		lblNewLabel.setIcon(new ImageIcon("images\\cool-background.jpg"));
		lblNewLabel.setBounds(0, 0, 1000, 500);
		getContentPane().add(lblNewLabel);
		
		btnSave.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					List<String> input = new ArrayList();
					input.add(position.getText());
					input.add(wID.getText());
					input.add(cID.getText());
					input.add(eDate.getText());
					if (food.isEnabled()) input.add("1");
					else input.add("0");
					input.add(expi.getText());
					input.add(basic.getText());
					input.add(extra.getText());
					input.add(Authentication.SSN);
					String output = proc.superFunction(input, "PalletInsert", true);
					if (output.equals("Error")) JOptionPane.showMessageDialog(null, "Error: Please fill all Information");
					else JOptionPane.showMessageDialog(null, "Pallet Added with ID: " + output  );
				} catch (Exception e) {;
				}
			}
		});
	}
}
