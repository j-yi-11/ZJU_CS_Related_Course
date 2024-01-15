package org.example;
//REFERENCE: https://blog.51cto.com/c959c/5331811#93_queryparser_460
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.FieldType;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
/**
 * QueryType enum represents different types of queries (TITLE, AUTHOR, ABSTRACT, COMMENT).
 */
enum QueryType {
    TITLE(0),
    AUTHOR(1),
    ABSTRACT(2),
    COMMENT(3);
    private int value = 0;
    QueryType(int value){
        this.value = value;
    }
    public int getValue() {
        return this.value;
    }
}
/**
 * InvIndexer class is responsible for creating and searching an inverted index using Apache Lucene.
 */
public class InvIndexer {
    public static void main(String[] args) {
        String indexDir = "D:/index";
        String dataDir = "D:/HTML_parser";
        // 0-->title  1-->author  2-->abstract  3-->comment
        int queryType = 1;
        QueryType type = QueryType.TITLE;
        boolean parserDebug = true;
        String tmpStr = "author:Hanzhang Zhou, Junlang Qian, Zijian Feng, Hui Lu, Zixiao Zhu, Kezhi Mao";
        tmpStr = args[0];//added
        String queryParser = "";
        // Determine the query type based on the input string
        if(tmpStr.contains("title:")){
            queryParser = tmpStr.substring("title:".length());
            queryType = 0;
            type = QueryType.TITLE;
            if(parserDebug) System.out.println("queryParser = "+queryParser);
        }
        if(tmpStr.contains("author:")){
            queryParser = tmpStr.substring("author:".length());
            queryType = 1;
            type = QueryType.AUTHOR;
            if(parserDebug) System.out.println("queryParser = "+queryParser);
        }
        if(tmpStr.contains("abstract:")){
            queryParser = tmpStr.substring("abstract:".length());
            queryType = 2;
            type = QueryType.ABSTRACT;
            if(parserDebug) System.out.println("queryParser = "+queryParser);
        }
        if(tmpStr.contains("comment:")){
            queryParser = tmpStr.substring("comment:".length());
            queryType = 3;
            type = QueryType.COMMENT;
            if(parserDebug) System.out.println("queryParser = "+queryParser);
        }

        System.out.println("type = "+type);
        try {
            createIndex(indexDir, dataDir);
            System.out.println("Inverted index created successfully.");

            searchIndex(indexDir, type,queryParser); 
        } catch (IOException | ParseException e) {
            e.printStackTrace();
        }
    }
    /**
     * Create an inverted index.
     *
     * @param indexDir The directory where the index will be stored.
     * @param dataDir  The directory containing the data files.
     * @throws IOException If an I/O error occurs.
     */
    public static void createIndex(String indexDir, String dataDir) throws IOException {
        // Delete all files in the index directory
        File indexFolder = new File(indexDir);
        if(indexFolder.exists() && indexFolder.isDirectory()){
            File[] files = indexFolder.listFiles();
            if(files!=null){
                for(File file : files){
                    file.delete();
                }
            }
        }
        System.out.println("refreshed index");
        Analyzer analyzer = new StandardAnalyzer();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        Directory directory = FSDirectory.open(Paths.get(indexDir));
        IndexWriter indexWriter = new IndexWriter(directory, config);

        File[] files = new File(dataDir).listFiles();
        int fileCount = 0;
        if (files != null) {
            for (File file : files) {
                if (file.isFile() && file.getName().endsWith(".txt")) {
                    indexFile(indexWriter, file);
                    fileCount++;
                }
            }
        }
        System.out.println("file count = "+fileCount);
        indexWriter.commit();//added
        indexWriter.close();
        directory.close();
    }
    /**
     * Index a file.
     *
     * @param indexWriter The IndexWriter object.
     * @param file        The file to be indexed.
     * @throws IOException If an I/O error occurs.
     */
    public static void indexFile(IndexWriter indexWriter, File file) throws IOException {
        FileReader fileReader = new FileReader(file);
        BufferedReader bufferedReader = new BufferedReader(fileReader);

        StringBuilder stringBuilder = new StringBuilder();
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            stringBuilder.append(line).append("\n");
        }
        bufferedReader.close();

        String content = stringBuilder.toString().trim();

        // Define patterns for extracting title, authors, abstract, and comments
        Pattern titlePattern = Pattern.compile("Title: (.+)");
        Pattern authorsPattern = Pattern.compile("Authors: (.+)");
        Pattern abstractPattern = Pattern.compile("Abstract: (.+)");
        Pattern commentsPattern = Pattern.compile("Comments: (.+)");

        // Create matchers
        Matcher titleMatcher = titlePattern.matcher(content);
        Matcher authorsMatcher = authorsPattern.matcher(content);
        Matcher abstractMatcher = abstractPattern.matcher(content);
        Matcher commentsMatcher = commentsPattern.matcher(content);

        String title = "", authors = "", abstractText="",comments="";
        boolean debug = false;
        // Extract and print information
        if (titleMatcher.find()) {
            title = titleMatcher.group(1).trim();
            if(debug) System.out.println("Title: " + title);//
        }

        if (authorsMatcher.find()) {
            authors = authorsMatcher.group(1).trim();
            if(debug) System.out.println("Authors: " + authors);
        }

        if (abstractMatcher.find()) {
            abstractText = abstractMatcher.group(1).trim();
            if(debug) System.out.println("Abstract: " + abstractText);
        }

        if (commentsMatcher.find()) {
            comments = commentsMatcher.group(1).trim();
            if(debug) System.out.println("Comments: " + comments);
        }

        FieldType fieldType = new FieldType();
        fieldType.setStored(true);
        fieldType.setIndexOptions(IndexOptions.DOCS_AND_FREQS_AND_POSITIONS);
        fieldType.setTokenized(true);

        Document document = new Document();
        document.add(new Field("authors", authors, fieldType));
        document.add(new Field("title", title, fieldType));
        document.add(new Field("abstract", abstractText, fieldType));
        document.add(new Field("comments", comments, fieldType));
        indexWriter.addDocument(document);
    }
    /**
     * Search the index.
     *
     * @param indexDir   The directory where the index is stored.
     * @param type       The type of query (TITLE, AUTHOR, ABSTRACT, COMMENT).
     * @param queryStr   The query string.
     * @throws IOException    If an I/O error occurs.
     * @throws ParseException If an error occurs while parsing the query.
     */
    public static void searchIndex(String indexDir, QueryType type, String queryStr) throws IOException, ParseException {
        Directory directory = FSDirectory.open(Paths.get(indexDir));
        DirectoryReader reader = DirectoryReader.open(directory);
        IndexSearcher indexSearcher = new IndexSearcher(reader);
        Analyzer analyzer = new StandardAnalyzer();
        QueryParser titleQueryParser = new QueryParser("title", analyzer);
        QueryParser authorsQueryParser = new QueryParser("authors",analyzer);
        QueryParser abstractQueryParser = new QueryParser("abstract",analyzer);
        QueryParser commentQueryParser = new QueryParser("comments",analyzer);
        Query titleQuery = titleQueryParser.parse(queryStr);
        Query authorsQuery = titleQueryParser.parse(queryStr);
        Query abstractQuery = titleQueryParser.parse("large language models");
        Query commentQuery = titleQueryParser.parse(queryStr);

        // Combine queries using BooleanQuery
        BooleanQuery.Builder booleanQueryBuilder = new BooleanQuery.Builder();
        switch (type){ 
            case TITLE:
                booleanQueryBuilder.add(titleQuery, BooleanClause.Occur.MUST);
                break;
            case AUTHOR:
                booleanQueryBuilder.add(authorsQuery, BooleanClause.Occur.MUST);
                break;
            case ABSTRACT:
                booleanQueryBuilder.add(abstractQuery,BooleanClause.Occur.MUST);
                break;
            case COMMENT:
                booleanQueryBuilder.add(commentQuery,BooleanClause.Occur.MUST);
                break;
            default:
                System.out.println("Unexpected query Type = "+type); 
                break;
        }
        // Execute the final query
        Query compoundOrQuery = booleanQueryBuilder.build();
        TopDocs topDocs = indexSearcher.search(compoundOrQuery, 10); 
        System.out.println("\n\n\n--------------Query Results shown as bellow--------------\n" +
                "Total Results: " + topDocs.totalHits+"\nQuery String: "+queryStr);
        for (ScoreDoc scoreDoc : topDocs.scoreDocs) {
            Document document = indexSearcher.doc(scoreDoc.doc);
            System.out.println("Title: " + document.get("title"));
            System.out.println("Authors: " + document.get("authors"));
            System.out.println("Abstract: " + document.get("abstract"));
            System.out.println("Comments: " + document.get("comments"));
            System.out.println("Score: " + scoreDoc.score);
            System.out.println("------------------------");
        }
        reader.close();
        directory.close();
    }
}
