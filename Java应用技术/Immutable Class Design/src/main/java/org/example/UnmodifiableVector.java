package org.example;

import org.example.Vector;

public final class UnmodifiableVector{
    private final Vector vec;
    public UnmodifiableVector(Vector initial_vec){
        this.vec = initial_vec;
    }
    //only get
    public double getElement(int row){
        return this.vec.getElement(row);
    }
}