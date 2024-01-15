package org.example;
public class MathUtils {
    public static UnmodifiableVector getUnmodifiableVector(Vector vector) {
        return new UnmodifiableVector(vector);
    }
    public static UnmodifiableMatrix getUnmodifiableMatrix(Matrix matrix) {
        return new UnmodifiableMatrix(matrix);
    }
}