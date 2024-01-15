package org.example;
import java.io.Serializable;
public class Message implements Serializable{
	protected static final long serialVersionUID = 3210103803L;
    static final int MESSAGE = 0, USERLIST = 1;
    private int type;
    private String content;
    Message(int type, String content) {
        this.type = type;
        this.content = content;
    }
    int getType() {
        return this.type;
    }
    String getContent() {
        return this.content;
    }
}
