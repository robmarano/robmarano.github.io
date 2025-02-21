import java.io.*;

public class SubProcess2 {

    public static void main(String[] args) throws IOException {
        String filePath = args[0];
        try (FileWriter writer = new FileWriter(filePath, true)) {
            writer.write("SubProcess2 wrote: Hello from process 2!\n");
        }
        System.out.println("SubProcess2 completed.");
    }
}