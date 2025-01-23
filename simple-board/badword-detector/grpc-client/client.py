import grpc
from levenshtein import levenshtein_pb2, levenshtein_pb2_grpc

def main():
    # Server address
    server_address = '192.168.36.149:50051'

    # Create a channel and a stub
    with grpc.insecure_channel(server_address) as channel:
        stub = levenshtein_pb2_grpc.LevenshteinServiceStub(channel)

        # Prepare the request
        query = levenshtein_pb2.Query(text="씨발")

        # Send the request and get the response
        try:
            response = stub.Search(query)
            print("Response from server:")
            for word in response.words:
                print(f"ID: {word.id}, Content: {word.content}, Similarity Rate: {word.similarity_rate:.2f}")
        except grpc.RpcError as e:
            print(f"gRPC error: {e.code()} - {e.details()}")

if __name__ == "__main__":
    main()
