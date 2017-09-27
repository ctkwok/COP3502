//Chun Kwok
import java.util.InputMismatchException;
import java.util.Scanner;

public class Main {
    public static void main(String args[]) {
        boolean termination = false;
        Scanner scnr = new Scanner(System.in);
        int tempHoldInt = 0;
        double tempHoldFloat = 0.0;
        int numMPH = 0;
        double tankCapac = 0.0;
        double percentTank = 0.0;

        while (termination == false) {

            System.out.print("Enter your car's MPG rating (miles/gallon as a positive integer: ");
            try {
                tempHoldInt = scnr.nextInt();
                if (tempHoldInt > 0) {
                    numMPH = tempHoldInt;

                } else {
                    System.out.println("\nERROR: ONLY POSITIVE INTEGERS ARE ACCEPTED FOR MPG!!!");
                    break;
                }
            } catch (InputMismatchException e) {
                System.out.println("\nERROR: ONLY POSITIVE INTEGERS ARE ACCEPTED FOR MPG!!!");
                break;
            }

            System.out.print("Enter your car’s tank capacity (gallons) as a positive decimal number: ");
            try {
                tempHoldFloat = scnr.nextDouble();
                if (tempHoldFloat > 0) {
                    tankCapac = tempHoldFloat;

                } else {
                    System.out.println("\nERROR: ONLY POSITIVE DECIMAL NUMBERS ACCEPTED FOR TANK CAPACITY!!!");
                    break;
                }
            } catch (InputMismatchException e) {
                System.out.println("\nERROR: ONLY POSITIVE DECIMAL NUMBERS ACCEPTED FOR TANK CAPACITY!!!");
                break;
            }
            System.out.print("Enter the percentage of the gas tank that is currently filled (from 0-100%): ");
            try {
                tempHoldFloat = scnr.nextDouble();
                if (tempHoldFloat >= 0 && tempHoldFloat <= 100) {
                    percentTank = tempHoldFloat;

                } else {
                    System.out.println("\nERROR: PERCENTAGE MUST BE A DECIMAL NUMBER IN THE RANGE OF 0-100(INCLUSIVE)!!!");
                    break;
                }
            } catch (InputMismatchException e) {
                System.out.println("\nERROR: PERCENTAGE MUST BE A DECIMAL NUMBER IN THE RANGE OF 0-100(INCLUSIVE)!!!");
                break;
            }

            double rawRange = numMPH * tankCapac * (percentTank*0.01);

            if ((int)rawRange <= 25)
            {
                System.out.println("Attention! Your current estimated range is running low: " + (int) rawRange + " miles left!!!");
            }else
                System.out.println("Keep driving! Your current estimated range is: " + (int) rawRange + " miles!");

            termination = true;
        }
    }

}