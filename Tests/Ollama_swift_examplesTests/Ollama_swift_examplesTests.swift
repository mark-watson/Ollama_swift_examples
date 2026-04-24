import Testing
import Ollama
@testable import Ollama_swift_examples

@Suite("Ollama Service Tests")
@MainActor
struct OllamaServiceTests {
    let service = OllamaService(model: "qwen3:1.7b")

    @Test("Basic Chat Functionality")
    func testBasicChat() async throws {
        let messages: [Ollama.Chat.Message] = [
            .system("You are a helpful assistant."),
            .user("What is the capital of Germany?")
        ]
        
        let response = try await service.chat(messages: messages)
        #expect(!response.isEmpty)
        print("Response: \(response)")
    }

    @Test("Streaming Chat Functionality")
    func testStreamingChat() async throws {
        let messages: [Ollama.Chat.Message] = [
            .user("Tell me a very short joke.")
        ]
        
        var fullResponse = ""
        for try await fragment in await service.chatStream(messages: messages) {
            fullResponse += fragment
        }
        
        #expect(!fullResponse.isEmpty)
        print("Streaming Response: \(fullResponse)")
    }
}
