from fastapi import FastAPI
from concurrent import futures
import grpc
from app.grpc import profanity_pb2_grpc
from app.services.profanity_service import ProfanityService
from app.utils.model_loader import ModelLoader

app = FastAPI()

model_loader = ModelLoader(
    tokenizer_path="app/models/tokenizer_with_kogpt2.pickle",
    model_path="app/models/vdcnn_model_with_kogpt2.h5"
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