import org.apache.commons.lang3.time.StopWatch;

import javax.tools.Tool;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SemanticMain {
    public List<String> listVocabulary = new ArrayList<>();  //List that contains all the vocabularies loaded from the csv file.
    public List<double[]> listVectors = new ArrayList<>(); //Associated vectors from the csv file.
    public List<Glove> listGlove = new ArrayList<>();
    public final List<String> STOPWORDS;

    public SemanticMain() throws IOException {
        STOPWORDS = Toolkit.loadStopWords();
        Toolkit.loadGLOVE();
    }


    public static void main(String[] args) throws IOException {
        StopWatch mySW = new StopWatch();
        mySW.start();
        SemanticMain mySM = new SemanticMain();
        mySM.listVocabulary = Toolkit.getListVocabulary();
        mySM.listVectors = Toolkit.getlistVectors();
        mySM.listGlove = mySM.CreateGloveList();

        List<CosSimilarityPair> listWN = mySM.WordsNearest("computer");
        Toolkit.PrintSemantic(listWN, 5);

        listWN = mySM.WordsNearest("phd");
        Toolkit.PrintSemantic(listWN, 5);


        List<CosSimilarityPair> listLA = mySM.LogicalAnalogies("china", "uk", "london", 5);
        Toolkit.PrintSemantic("china", "uk", "london", listLA);

        listLA = mySM.LogicalAnalogies("woman", "man", "king", 5);
        Toolkit.PrintSemantic("woman", "man", "king", listLA);

        listLA = mySM.LogicalAnalogies("banana", "apple", "red", 3);
        Toolkit.PrintSemantic("banana", "apple", "red", listLA);
        mySW.stop();

        if (mySW.getTime() > 2000)
            System.out.println("It takes too long to execute your code!\nIt should take less than 2 second to run.");
        else
            System.out.println("Well done!\nElapsed time in milliseconds: " + mySW.getTime());
    }

    public List<Glove> CreateGloveList() {
        List<Glove> listResult = new ArrayList<>();
        int counter = 0;
        while (counter < listVocabulary.size()){
            listResult.add(new Glove(listVocabulary.get(counter), new Vector(listVectors.get(counter))));
            counter++;
        }

        for (int j = 0; j < STOPWORDS.size(); j++) {
            String currentStopword = STOPWORDS.get(j);
            for (int i = listResult.size() - 1; i >= 0; i--) {
                if (currentStopword.equals(listResult.get(i).getVocabulary())) {
                    listResult.remove(i);
                }
            }
        }

        return listResult;
    }

    public List<CosSimilarityPair> WordsNearest(String _word) {
        List<CosSimilarityPair> listCosineSimilarity = new ArrayList<>();
        Vector wordVector;

        int errorIndex = listVocabulary.indexOf("error");
        int wordIndex;
        Vector errorWordVector = new Vector(listVectors.get(errorIndex));
        wordIndex = errorIndex;
        boolean wordInList = false;

        for (int i = 0; i < listGlove.size(); i++) { // for loop finds the word in the list if it exists
            if (_word.equals(listGlove.get(i).getVocabulary())) {
                wordInList = true;
                wordIndex = i;
            }
        }

        if (wordInList) { // if the word exists in the list
            wordVector = listGlove.get(wordIndex).getVector();
        }

        else {
            wordVector = errorWordVector;
            _word = "error";
        }

        for (int i = 0; i < listGlove.size(); i++) { // find cos similarity between every word in the list
            if (listGlove.get(i).getVocabulary().equals(_word)){
                listGlove.remove(i);
            }
            double _cosinesimilarity = wordVector.cosineSimilarity(listGlove.get(i).getVector());
            CosSimilarityPair thisPair = new CosSimilarityPair(_word, listGlove.get(i).getVocabulary(), _cosinesimilarity);
            listCosineSimilarity.add(thisPair);
        }

        HeapSort.doHeapSort(listCosineSimilarity);
        return listCosineSimilarity;
    }

    public List<CosSimilarityPair> WordsNearest(Vector _vector) {
        List<CosSimilarityPair> listCosineSimilarity = new ArrayList<>();
        listGlove = CreateGloveList();

        for (int i = 0; i < listGlove.size(); i++) {
            if (listGlove.get(i).getVector().equals(_vector)) {
                listGlove.remove(listGlove.get(i));
                break;
            }
        }

        // then we go through listglove and calculate the cos similarity between the given vector and each vector in the list
        for (int i = 0; i < listGlove.size(); i++) {
            Vector thisVector = listGlove.get(i).getVector();
            String thisString = listGlove.get(i).getVocabulary();
            double cosineSimilarity = thisVector.cosineSimilarity(_vector);
            CosSimilarityPair newPair = new CosSimilarityPair(thisVector, thisString, cosineSimilarity);
            listCosineSimilarity.add(newPair);
            // System.out.println(listGlove.get(i).getVocabulary());
        }
        // Toolkit.PrintSemantic(listCosineSimilarity, listCosineSimilarity.size());

        // then we sort the list
        HeapSort.doHeapSort(listCosineSimilarity);
        return listCosineSimilarity;
    }

    /**
     * Method to calculate the logical analogies by using references.
     * <p>
     * Example: uk is to london as china is to XXXX.
     *       _firISRef  _firTORef _secISRef
     * In the above example, "uk" is the first IS reference; "london" is the first TO reference
     * and "china" is the second IS reference. Moreover, "XXXX" is the vocabulary(ies) we'd like
     * to get from this method.
     * <p>
     * If _top <= 0, then returns an empty listResult.
     * If the vocabulary list does not include _secISRef or _firISRef or _firTORef, then returns an empty listResult.
     *
     * @param _secISRef The second IS reference
     * @param _firISRef The first IS reference
     * @param _firTORef The first TO reference
     * @param _top      How many vocabularies to include.
     */
    public List<CosSimilarityPair> LogicalAnalogies(String _secISRef, String _firISRef, String _firTORef, int _top) {
        List<CosSimilarityPair> listResult = new ArrayList<>();

        if (_top <= 0) {
            return listResult;
        }

        Vector secISVector = null;
        Vector firstTOVector = null;
        Vector firstISVector = null;

        for (int i = 0; i < listVocabulary.size(); i++) {
            if (_secISRef.equals(listVocabulary.get(i))) {
                secISVector = new Vector(listVectors.get(i));
            }
            if (_firISRef.equals(listVocabulary.get(i))) {
                firstTOVector = new Vector(listVectors.get(i));
            }
            if (_firTORef.equals(listVocabulary.get(i))) {
                firstISVector = new Vector(listVectors.get(i));
            }
        }


        if (firstISVector != null && firstTOVector != null && secISVector != null) {

            Vector firstVectorsSubtracted = firstISVector.subtraction(firstTOVector);
            Vector secTOVector = firstVectorsSubtracted.add(secISVector);
            listResult = WordsNearest(secTOVector);
            for (int i = 0; i < listResult.size(); i++) {
                if (listResult.get(i).getWord2().equals(_secISRef)){
                    listResult.remove(i);
                }
                if (listResult.get(i).getWord2().equals(_firTORef)){
                    listResult.remove(i);
                }
                if (listResult.get(i).getWord2().equals(_firISRef)){
                    listResult.remove(i);
                }
            }
            List<CosSimilarityPair> sublist = listResult.subList(0, _top);
            return sublist;
        }
        else {
            return listResult;
        }
    }
}