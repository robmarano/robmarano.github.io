import java.io.*;

public class SubProcess1 {

    public static void main(String[] args) throws IOException {
        String filePath = args[0];
        System.out.printf("sharedFile.getAbsolutePath() = %s\n", filePath);

        try (FileWriter writer = new FileWriter(filePath, true)) {
            writer.write("SubProcess1 wrote: Hello from process 1!\n");
        }
        System.out.println("SubProcess1 completed.");
    }
}