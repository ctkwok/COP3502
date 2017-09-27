import java.util.*;

public class Main {
    public static void main(String args[]){
        //Part 1 int
        int rectLength;
        int rectWidth;
        int cirRad;
        int triBase;
        int triHeight;
        int triFirstLeg;
        int triSecondLeg;
        int triThirdLeg;

        //Part 2 Int
        int sphRad;
        int rectPrismHeight;
        int rectPrismDepth;
        int rectPrismWidth;
        int cylRad;
        int cylHeight;
        //Part 1
        Scanner scnr = new Scanner(System.in);
        System.out.print("Enter length of rectangle (positive integer): ");
        rectLength = scnr.nextInt();
        System.out.print("Enter width of rectangle (positive integer): ");
        rectWidth = scnr.nextInt();
        System.out.print("Now enter the radius of the circle (positive integer):");
        cirRad = scnr.nextInt();
        System.out.print("Now enter the base of the triangle (positive integer):");
        triBase = scnr.nextInt();
        System.out.print("Now enter the height of the triangle (positive integer):");
        triHeight = scnr.nextInt();
        // Need 3 legs for Perimeter in the case the triangle is not a right triangle
        System.out.print("Now enter length of leg 1 of the triangle (positive integer):");
        triFirstLeg = scnr.nextInt();
        System.out.print("Now enter length of leg 2 of the triangle (positive integer):");
        triSecondLeg = scnr.nextInt();
        System.out.print("Now enter length of leg 3 of the triangle (positive integer):");
        triThirdLeg = scnr.nextInt();
        System.out.println("Area of rectangle: " + rectLength*rectWidth);
        System.out.println("Area of circle: " + Math.PI*cirRad*cirRad);
        System.out.println("Perimeter of rectangle: " + 2 * (rectLength + rectWidth));
        System.out.println("Circumference of circle: " + 2 * Math.PI * cirRad);
        System.out.println("Area of Triangle: " + 0.5 * triBase * triHeight);
        System.out.println("Perimeter of Triangle: " + (triFirstLeg + triSecondLeg + triThirdLeg));

        //Part 2
        System.out.print("Enter the radius of the sphere: ");
        sphRad = scnr.nextInt();
        System.out.print("Enter the diameter of the rectangular prism: ");
        rectPrismDepth = scnr.nextInt();
        System.out.print("Enter the height of the rectangular prism: ");
        rectPrismHeight = scnr.nextInt();
        System.out.print("Enter the width of the rectangular prism: ");
        rectPrismWidth = scnr.nextInt();
        System.out.print("Enter the height of the cylinder: ");
        cylHeight = scnr.nextInt();
        System.out.print("Enter the radius of the cylinder: ");
        cylRad = scnr.nextInt();

        System.out.println("The surface area of the sphere is: " + 4 * Math.PI * sphRad * sphRad);
        System.out.println("The volume of the sphere is: " + (4.0/3.0) * Math.PI * sphRad * sphRad * sphRad);
        System.out.println("The surface area of the rectangular prism is: " + 2.0 * ((rectPrismDepth*rectPrismHeight) + (rectPrismHeight*rectPrismWidth) + (rectPrismDepth*rectPrismWidth)));
        System.out.println("The volume of the rectangular prism is: " + 1.0*rectPrismDepth*rectPrismHeight*rectPrismWidth);
        System.out.println("The surface area of the cylinder is: " + (2*Math.PI*cylRad*cylHeight + 2*Math.PI*cylRad*cylRad));
        System.out.println("The volume of the cylinder is: " + Math.PI*cylRad*cylRad*cylHeight);

    }
}
