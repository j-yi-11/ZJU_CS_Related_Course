package org.example;

import java.util.Arrays;
public class Vector {
    private double[] value;
    //constructor
    public Vector(double[] elements){
        this.value = Arrays.copyOf(elements,elements.length);
    }
    //get and set
    public double getElement(int index){
        if (index>=0 && index<=this.value.length-1)
            return this.value[index];
        else
            throw new IndexOutOfBoundsException();
    }
    public void setElement(int index, double new_value){
        if(index>=0 && index<=this.value.length-1)
            this.value[index] = new_value;
        else
            throw new IndexOutOfBoundsException();
    }
    //get length
    public int getLength(){
        return value.length;
    }
    //add
    public Vector add(Vector other){
        if(this.getLength()!=other.getLength())
            throw new IllegalArgumentException("vector dimension error when add!");
        else{
            double[] result = new double[other.getLength()];
            for(int i=0;i<other.getLength();i++){
                result[i] = this.getElement(i) + other.getElement(i);
            }
            return new Vector(result);
        }
    }
    //sub
    public Vector sub(Vector other){
        if(this.getLength()!=other.getLength())
            throw new IllegalArgumentException("vector dimension error when sub!");
        else{
            double[] result = new double[other.getLength()];
            for(int i=0;i<other.getLength();i++){
                result[i] = this.getElement(i) - other.getElement(i);
            }
            return new Vector(result);
        }
    }
    //dot
    public double dot(Vector other){
        if(this.getLength()!=other.getLength())
            throw new IllegalArgumentException("vector dimension error when dot!");
        else{
            double result = 0.0;
            for(int i=0;i<other.getLength();i++){
                result += this.getElement(i) * other.getElement(i);
            }
            return result;
        }
    }
    //cross
    public Vector cross(Vector other){
        if(this.getLength() != 3 || other.getLength() != 3)
            throw new IllegalArgumentException("vector dimension error(not equal to 3) when cross!");
        else{
            double[] result = new double[3];
            result[0] = this.getElement(1) * other.getElement(2) - this.getElement(2) * other.getElement(1);
            result[1] = this.getElement(2) * other.getElement(0) - this.getElement(0) * other.getElement(2);
            result[2] = this.getElement(0) * other.getElement(1) - this.getElement(1) * other.getElement(0);
            return new Vector(result);
        }
    }
    //magnitude
    public double magnitude() {
        double sumOfSquares = 0.0;
        for (int i=0;i<this.getLength();i++) {
            sumOfSquares += this.getElement(i)*this.getElement(i);
        }
        return Math.sqrt(sumOfSquares);
    }
    //print
    public void print(){
        System.out.println("Vector: "+Arrays.toString(this.value));
    }
}