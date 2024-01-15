package org.example;

import java.util.Arrays;

public class Matrix {
    private double[][] value;
    public Matrix(double[][] elements){
        this.value = new double[elements.length][];
        for(int i=0;i< elements.length;i++){
            this.value[i] = Arrays.copyOf(elements[i],elements[i].length);
        }
    }
    public int getRowNumber(){
        return this.value.length;
    }
    public int getColumnNumber(){
        return (this.value[0]).length;
    }
    //get and set
    public double getElement(int row, int col) {
        if(row>=0 && row<=this.value.length-1)
            if(col>=0 && col<=(this.value[row]).length-1)
                return this.value[row][col];
            else
                throw new IndexOutOfBoundsException();
        else
            throw new IndexOutOfBoundsException();
    }
    public void setElement(int row, int col, double new_value) {
        if(row>=0 && row<=this.value.length-1)
            if(col>=0 && col<=(this.value[row]).length-1)
                this.value[row][col] = new_value;
            else
                throw new IndexOutOfBoundsException();
        else
            throw new IndexOutOfBoundsException();
    }
    //add
    public Matrix add(Matrix other){
        if(this.value.length!=other.value.length)
            throw new IllegalArgumentException("Matrix dimension error when add!");
        else{
            double[][] result = new double[other.value.length][other.value[0].length];
            for(int i=0;i< result.length;i++){
                for(int j=0;j<result[i].length;j++){
                    result[i][j] = 0;
                }
            }
//            System.out.println(result);
            System.out.println("other.value.length"+other.value.length);
            System.out.println("other.value[0].length"+other.value[0].length);
            for(int i=0;i<other.value.length;i++){
                for(int j=0;j<(other.value[0]).length;j++){
                    result[i][j] = this.value[i][j]+other.value[i][j];
                }
            }
            return new Matrix(result);
        }
    }
    //sub
    public Matrix sub(Matrix other){
        if(this.value.length!=other.value.length)
            throw new IllegalArgumentException("Matrix dimension error when sub!");
        else{
            double[][] result = new double[other.value.length][other.value[0].length];
            for(int i=0;i<other.value.length;i++){
                for(int j=0;j<(other.value[0]).length;j++){
                    result[i][j] = this.value[i][j] - other.value[i][j];
                }
            }
            return new Matrix(result);
        }
    }
    //multiply
    public Matrix mul(Matrix other){
        if(this.value[0].length != other.value.length)
            throw new IllegalArgumentException("Matrix dimension error when mul!");
        else{
            double[][] result = new double[this.value.length][other.value[0].length];
            //result[][] should be all 0
            for (int i = 0; i < this.value.length; i++) {
                for (int j = 0; j < other.value[0].length; j++) {
                    for (int k = 0; k < value[0].length; k++) {
                        result[i][j] += this.value[i][k] * other.value[k][j];
                    }
                }
            }
            return new Matrix(result);
        }
    }
    //transpose
    public Matrix transpose(){
        double[][] result = new double[this.value[0].length][this.value.length];
        for(int i=0;i<this.value.length;i++){
            for(int j=0;j<this.value[0].length;j++){
                result[j][i] = this.getElement(i,j);
            }
        }
        return new Matrix(result);
    }
    // print
    public void print(){
        for(int i=0;i<this.value.length;i++){
            System.out.printf("[");
            for(int j=0;j<this.value[0].length;j++){
                System.out.printf("%f ",this.getElement(i,j));
            }
            System.out.println("]");
        }
    }
}