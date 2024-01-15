package org.example;
import org.example.MathUtils;
import org.example.UnmodifiableVector;
import org.example.Vector;
public class Main {
    public static void main(String[] args) {
        System.out.println("Test begin:");
        // vector
        double[] a = {1.5, 4.6, 6.8};
        double[] b = {9.8, 0, -5.5};
        Vector v1 = new Vector(a);
        Vector v2 = new Vector(b);
        Vector result = v1.add(v2);
        System.out.println("Vector add result:");
        result.print();
        result = v1.sub(v2);
        System.out.println("Vector sub result:");
        result.print();
        System.out.println("Vector dot result:"+v1.dot(v2));
        result = v1.cross(v2);
        System.out.println("Vector cross result:");
        result.print();
        System.out.println("Vector 1 mag result:"+v1.magnitude());
        System.out.println("Vector 2 mag result:"+v2.magnitude());
        // matrix
        double[][] c = {
                {1,-2,3},
                {-4,5,-6},
                {7,-8,9}
        };
        double[][] d = {
                {5,3,-2},
                {-7,2,2},
                {1,0,1}
        };
        Matrix m1 = new Matrix(c);
        Matrix m2 = new Matrix(d);
        Matrix result_ = m1.add(m2);
        System.out.println("Matrix add result:");
        result_.print();
        result_ = m1.sub(m2);
        System.out.println("Matrix sub result:");
        result_.print();
        result_ = m1.mul(m2);
        System.out.println("Matrix mul result:");
        result_.print();
        result_ = m1.transpose();
        System.out.println("Matrix transpose result:");
        result_.print();
        // UnmodifiableVector
        UnmodifiableVector uv1 = new UnmodifiableVector(v1);
        boolean success = true;
        for(int i=0;i<v1.getLength();i++){
            if(v1.getElement(i) != uv1.getElement(i)){
                System.out.println("vector get element failed!");
                success = false;
            }
        }
        if(success==true){
            System.out.println("vector get element succeed!");
        }
        success = true;
        UnmodifiableVector uv2 = new UnmodifiableVector(v2);
        v2.setElement(1,-33);
        System.out.println(v2.getElement(1));
        success = true;
        // UnmodifiableMatrix
        UnmodifiableMatrix um1 = new UnmodifiableMatrix(m1);
        UnmodifiableMatrix um2 = new UnmodifiableMatrix(m2);
        m1.setElement(1,1,99);

         System.out.println(m1.getElement(1,1));
    }
}