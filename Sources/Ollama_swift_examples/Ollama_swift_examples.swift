import Ollama

/// A service to interact with Ollama models using modern Swift concurrency.
public actor OllamaService {
    private let client: Ollama.Client
    private let model: Model.ID

    @MainActor
    public init(model: Model.ID = "qwen3:1.7b", client: Ollama.Client? = nil) {
        self.model = model
        self.client = client ?? .default
    }

    /// Performs a simple chat request.
    /// - Parameter messages: The messages to send to the model.
    /// - Returns: The response content from the model.
    public func chat(messages: [Ollama.Chat.Message]) async throws -> String {
        let response = try await client.chat(
            model: model,
            messages: messages
        )
        return response.message.content
    }

    /// Performs a streaming chat request.
    /// - Parameter messages: The messages to send to the model.
    /// - Returns: An async stream of response fragments.
    public func chatStream(messages: [Ollama.Chat.Message]) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    // Note: chatStream is non-async but returns an AsyncSequence
                    for try await chunk in try await client.chatStream(model: model, messages: messages) {
                        continuation.yield(chunk.message.content)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
