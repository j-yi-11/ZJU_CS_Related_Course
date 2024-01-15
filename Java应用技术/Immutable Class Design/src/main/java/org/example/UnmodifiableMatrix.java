package org.example;
import org.example.Matrix;
public final class UnmodifiableMatrix{
    private final Matrix mar;
    public UnmodifiableMatrix(Matrix initial_mar){
        this.mar = initial_mar;
    }
    //only get
    public double getElement(int row, int col){
        return this.mar.getElement(row,col);
    }
}