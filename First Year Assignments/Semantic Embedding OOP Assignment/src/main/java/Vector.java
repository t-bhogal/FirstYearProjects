public class Vector {
    private double[] doubElements;

    public Vector(double[] _elements) {
        doubElements = _elements;
    }

    public double getElementatIndex(int _index)
    {
        try {
            return doubElements[_index];
        }
        catch (IndexOutOfBoundsException e) {
            return -1;
        }
    }

    public void setElementatIndex(double _value, int _index) {
        try {
            doubElements[_index] = _value;
        }
        catch (IndexOutOfBoundsException e) {
            doubElements[doubElements.length - 1] = _value;
        }
    }

    public double[] getAllElements() {
        return doubElements;
    }

    public int getVectorSize() {
        return doubElements.length;
    }

    public Vector reSize(int _size) {
        if (_size == getVectorSize() || _size <= 0) {
            return new Vector(doubElements);
        }
        else if (_size < getVectorSize()) {
            double[] shorterVector = new double[_size];
            for (int i = 0; i < _size; i++) {
                shorterVector[i] = doubElements[i];
            }
            return new Vector(shorterVector);
        }
        else {
            double[] longerVector = new double[_size];
            for (int i = 0; i < doubElements.length; i++) {
                longerVector[i] = doubElements[i];
            }
            for (int i = doubElements.length; i < _size; i++) {
                longerVector[i] = -1;
            }
            return new Vector(longerVector);
        }
    }

    public Vector add(Vector _v) {
        if (_v.getVectorSize() > getVectorSize()) {
            Vector resizedVector = reSize(_v.getVectorSize());
            double[] newArray = new double[resizedVector.getVectorSize()];
            for (int i = 0; i < newArray.length; i++) {
                 newArray[i] = resizedVector.getElementatIndex(i) + _v.getElementatIndex(i);
            }
            return new Vector(newArray);
        }
        else if (_v.getVectorSize() < getVectorSize()){
            Vector resizedVector = _v.reSize(doubElements.length);
            double[] newArray = new double[resizedVector.getVectorSize()];
            for (int i = 0; i < newArray.length; i++) {
                newArray[i] = resizedVector.getElementatIndex(i) + doubElements[i];
            }
            return new Vector(newArray);
        }
        else { // when v size = doub size
            for (int i = 0; i < getVectorSize(); i++) {
                doubElements[i] = doubElements[i] + _v.getElementatIndex(i);
            }
            return new Vector(doubElements);
        }
    }

    public Vector subtraction(Vector _v) {
        if (_v.getVectorSize() > getVectorSize()) {
            Vector resizedVector = reSize(_v.getVectorSize());
            double[] newArray = new double[resizedVector.getVectorSize()];
            for (int i = 0; i < newArray.length; i++) {
                newArray[i] = resizedVector.getElementatIndex(i) - _v.getElementatIndex(i);
            }
            return new Vector(newArray);
        }
        else if (_v.getVectorSize() < getVectorSize()){
            Vector resizedVector = _v.reSize(doubElements.length);
            double[] newArray = new double[resizedVector.getVectorSize()];
            for (int i = 0; i < newArray.length; i++) {
                newArray[i] = doubElements[i] - resizedVector.getElementatIndex(i);
            }
            return new Vector(newArray);
        }
        else { // when v size = doub size
            for (int i = 0; i < getVectorSize(); i++) {
                doubElements[i] = doubElements[i] - _v.getElementatIndex(i);
            }
            return new Vector(doubElements);
        }
    }

    public double dotProduct(Vector _v) {
        if (_v.getVectorSize() > getVectorSize()) {
            Vector resizedVector = reSize(_v.getVectorSize());
            double[] newArray = new double[resizedVector.getVectorSize()];
            for (int i = 0; i < newArray.length; i++) {
                newArray[i] = resizedVector.getElementatIndex(i) * _v.getElementatIndex(i);
            }
            double dotProductTotal = 0;
            for (int i = 0; i < newArray.length; i++) {
                dotProductTotal = dotProductTotal + newArray[i];
            }
            return dotProductTotal;
        }
        else if (_v.getVectorSize() < getVectorSize()){
            Vector resizedVector = _v.reSize(doubElements.length);
            double[] newArray = new double[resizedVector.getVectorSize()];
            for (int i = 0; i < newArray.length; i++) {
                newArray[i] = doubElements[i] * resizedVector.getElementatIndex(i);
            }
            double dotProductTotal = 0;
            for (int i = 0; i < newArray.length; i++) {
                dotProductTotal = dotProductTotal + newArray[i];
            }
            return dotProductTotal;
        }
        else {
            for (int i = 0; i < getVectorSize(); i++) {
                doubElements[i] = doubElements[i] * _v.getElementatIndex(i);
            }
            double dotProductTotal = 0;
            for (int i = 0; i < doubElements.length; i++) {
                dotProductTotal = dotProductTotal + doubElements[i];
            }
            return dotProductTotal;
        }
    }

    public double cosineSimilarity(Vector _v) {
        if (_v.getVectorSize() > getVectorSize()) {
            double dotProductTotal = _v.dotProduct(new Vector(doubElements));
            Vector resizedVector = reSize(_v.getVectorSize());

            // modulus of each vector
            double modulusTotal1 = 0;
            for (int i = 0; i < resizedVector.getVectorSize(); i++) {
                modulusTotal1 = modulusTotal1 + (resizedVector.getElementatIndex(i)* resizedVector.getElementatIndex(i));
            }
            double modulusTotal2 = 0;
            for (int i = 0; i < resizedVector.getVectorSize(); i++) {
                modulusTotal2 = modulusTotal2 + (_v.getElementatIndex(i)*_v.getElementatIndex(i));
            }
            return dotProductTotal / ((Math.sqrt(modulusTotal1) * Math.sqrt(modulusTotal2)));
        }
        else if (_v.getVectorSize() < getVectorSize()){
            double dotProductTotal = _v.dotProduct(new Vector(doubElements));
            Vector resizedVector = _v.reSize(doubElements.length);

            // modulus of each vector
            double modulusTotal1 = 0;
            for (int i = 0; i < doubElements.length; i++) {
                modulusTotal1 = modulusTotal1 + (doubElements[i]*doubElements[i]);
            }
            double modulusTotal2 = 0;
            for (int i = 0; i < doubElements.length; i++) {
                modulusTotal2 = modulusTotal2 + (resizedVector.getElementatIndex(i)*resizedVector.getElementatIndex(i));
            }
            return dotProductTotal / ((Math.sqrt(modulusTotal1) * Math.sqrt(modulusTotal2)));
        }
        else {
            double[] newArray = new double[doubElements.length];
            for (int i = 0; i < doubElements.length; i++) {
                newArray[i] = doubElements[i] * _v.getElementatIndex(i);
            }
            double dotProductTotal = 0;
            for (int i = 0; i < doubElements.length; i++) {
                dotProductTotal = dotProductTotal + newArray[i];
            }

            // modulus of each vector
            double modulusTotal1 = 0;
            for (int i = 0; i < doubElements.length; i++) {
                modulusTotal1 = modulusTotal1 + (doubElements[i]*doubElements[i]);
            }
            double modulusTotal2 = 0;
            for (int i = 0; i < doubElements.length; i++) {
                modulusTotal2 = modulusTotal2 + (_v.getElementatIndex(i)*_v.getElementatIndex(i));
            }
            return dotProductTotal / ((Math.sqrt(modulusTotal1) * Math.sqrt(modulusTotal2)));
        }
    }

    @Override
    public boolean equals(Object _obj) {
        Vector v = (Vector) _obj;
        int elementChecker = 0;
        if (v.getVectorSize() == doubElements.length) {
            for (int i = 0; i < doubElements.length; i++) {
                if (v.getElementatIndex(i) == doubElements[i]) {
                    elementChecker++;
                }
            }
            if (elementChecker == doubElements.length) {
                return true;
            }
            return false;
        }
        else {
            return false;
        }
    }

    @Override
    public String toString() {
        StringBuilder mySB = new StringBuilder();
        for (int i = 0; i < this.getVectorSize(); i++) {
            mySB.append(String.format("%.5f", doubElements[i])).append(",");
        }
        mySB.delete(mySB.length() - 1, mySB.length());
        return mySB.toString();
    }
}
