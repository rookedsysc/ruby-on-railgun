from app.grpc import profanity_pb2, profanity_pb2_grpc
from app.utils.model_loader import ModelLoader

class ProfanityService(profanity_pb2_grpc.ProfanityServiceServicer):
    def __init__(self, model_loader):
        self.model_loader = model_loader

    def DetectProfanity(self, request, context):
        is_profane = self.model_loader.predict(request.text)
        message = "Profane text detected." if is_profane else "Clean text."
        return profanity_pb2.ProfanityResponse(is_profane=is_profane, message=message)