import pickle
import tensorflow as tf

# 모델 로드 유틸
class ModelLoader:
    def __init__(self, tokenizer_path, model_path):
        with open(tokenizer_path, 'rb') as f:
            self.tokenizer = pickle.load(f)
        self.model = tf.keras.models.load_model(model_path)

    def predict(self, text):
        tokens = self.tokenizer.texts_to_sequences([text])
        prediction = self.model.predict(tokens)
        return prediction[0][0] > 0.5  # 욕설 여부 반환