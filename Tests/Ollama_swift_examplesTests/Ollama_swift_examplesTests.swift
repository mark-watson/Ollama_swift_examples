import XCTest
import Ollama

final class Ollama_swift_examplesTests: XCTestCase {
    let text1 = "If Mary is 42, Bill is 27, and Sam is 51, what are their pairwise age differences."
    let client = Ollama.Client.default // http://localhost:11434 endpoint
    func testExample() async throws {
      let response = try await client.chat(
        model: "llama3.2:latest",
        messages: [
            .system("You are a helpful assistant who completes text and also answers questions. You are always concise."),
            .user("What is the capital of Germany?"),
            .user("what if Sam is 52?")
        ])
        print(response.message.content)
    }
}
