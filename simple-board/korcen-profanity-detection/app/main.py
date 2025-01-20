from concurrent import futures
from fastapi import FastAPI
import grpc
from grpc import profanity_pb2_grpc
from service.profanity_service import ProfanityService
from utils.model_loader import ModelLoader

app = FastAPI()

model_loader = ModelLoader(
    tokenizer_path="./models/tokenizer_with_kogpt2.pickle",
    model_path="./models/vdcnn_model_with_kogpt2.h5"
)

def start_grpc_server():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    profanity_pb2_grpc.add_ProfanityServiceServicer_to_server(
        ProfanityService(model_loader), server)
    server.add_insecure_port("[::]:50051")
    server.start()

@app.on_event("startup")
def startup_event():
    start_grpc_server()
