import java.io.*;

public class MasterProcess {

    public static void main(String[] args) throws IOException, InterruptedException {
        // Create a shared file
        String sFile = "shared_data.txt";
        File sharedFile = new File(sFile);
        sharedFile.createNewFile();
        System.out.printf("sharedFile.getAbsolutePath() = %s\n", sharedFile.getAbsolutePath());

        // Start sub-process 1
        ProcessBuilder pb1 = new ProcessBuilder("java", "SubProcess1", sharedFile.getAbsolutePath());
        System.out.printf("pb1 = %s\n",pb1.toString());
        Process p1 = pb1.start();

        // Start sub-process 2
        ProcessBuilder pb2 = new ProcessBuilder("java", "SubProcess2", sharedFile.getAbsolutePath());
        System.out.printf("pb2 = %s\n",pb2.toString());
        Process p2 = pb2.start();

        // Wait for sub-processes to complete
        p1.waitFor();
        p2.waitFor();

        // Read and display shared data
        try (BufferedReader reader = new BufferedReader(new FileReader(sharedFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("Master received: " + line);
            }
        }

        System.out.println("Master process completed.");
    }
}